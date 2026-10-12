`timescale 1ns / 1ps

// ============================================================
// Interrupt Controller with Priority, Masking and Nesting
// 16 interrupt sources; IRQ0 has the highest priority.
// Verilog-2001 compatible RTL.
// ============================================================
module interrupt_controller #(
    parameter IRQ_COUNT   = 16,
    parameter STACK_DEPTH = 4,
    parameter IRQ_WIDTH   = 4
) (
    input  wire                  clk,
    input  wire                  reset,

    input  wire [IRQ_COUNT-1:0]  irq,
    input  wire [IRQ_COUNT-1:0]  mask,
    // trigger_type[i] = 0: level-triggered
    // trigger_type[i] = 1: rising-edge-triggered
    input  wire [IRQ_COUNT-1:0]  trigger_type,

    input  wire                  cpu_ack,
    input  wire                  cpu_eoi,

    output wire                  cpu_irq,
    output wire [IRQ_WIDTH-1:0]  irq_id,
    output wire                  active,
    output wire                  stack_full,
    output wire                  stack_empty
);

    localparam PTR_WIDTH = (STACK_DEPTH < 2) ? 1 : $clog2(STACK_DEPTH + 1);

    reg [IRQ_COUNT-1:0] irq_previous;
    reg [IRQ_COUNT-1:0] pending;

    reg [IRQ_WIDTH-1:0] active_irq_id;
    reg                  active_valid;

    reg [IRQ_WIDTH-1:0] irq_stack [0:STACK_DEPTH-1];
    reg [PTR_WIDTH-1:0] stack_pointer;

    wire [IRQ_COUNT-1:0] irq_request;
    wire [IRQ_COUNT-1:0] enabled;

    reg                  candidate_valid;
    reg [IRQ_WIDTH-1:0]  candidate_id;

    wire accept_irq;
    wire finish_irq;
    wire [IRQ_COUNT-1:0] clear_vector;

    integer i;
    integer j;

    // --------------------------------------------------------
    // Trigger detection:
    // - Level request follows the input level.
    // - Edge request is asserted for one clock after a rising
    //   transition, independently for each interrupt input.
    // --------------------------------------------------------
    assign irq_request =
        (irq & ~trigger_type) |
        (irq & ~irq_previous & trigger_type);

    always @(posedge clk or posedge reset) begin
        if (reset)
            irq_previous <= {IRQ_COUNT{1'b0}};
        else
            irq_previous <= irq;
    end

    // --------------------------------------------------------
    // Masking and fixed-priority encoder.
    // IRQ0 is checked first and therefore has highest priority.
    // --------------------------------------------------------
    assign enabled = pending & ~mask;

    always @(*) begin
        candidate_valid = 1'b0;
        candidate_id    = {IRQ_WIDTH{1'b0}};

        for (i = IRQ_COUNT-1; i >= 0; i = i-1) begin
            if (enabled[i]) begin
                candidate_valid = 1'b1;
                candidate_id    = i;
            end
        end
    end

    // A new interrupt may be offered if no interrupt is active,
    // or if it has higher priority (smaller ID) than the active one.
    assign cpu_irq = candidate_valid &&
                     (!active_valid ||
                      ((candidate_id < active_irq_id) && !stack_full));

    // irq_id presents the currently offered interrupt; otherwise
    // it presents the active interrupt ID, or zero when idle.
    assign irq_id = cpu_irq ? candidate_id :
                    (active_valid ? active_irq_id : {IRQ_WIDTH{1'b0}});

    assign active      = active_valid;
    assign stack_empty = (stack_pointer == 0);
    assign stack_full  = (stack_pointer == STACK_DEPTH);

    assign accept_irq = cpu_irq && cpu_ack;
    assign finish_irq = active_valid && cpu_eoi;

    // Clear the selected pending bit on acknowledgement.
    // New requests take precedence in the pending update below,
    // so a simultaneous request is not lost.
    assign clear_vector = accept_irq
                        ? ({{(IRQ_COUNT-1){1'b0}}, 1'b1} << candidate_id)
                        : {IRQ_COUNT{1'b0}};

    // --------------------------------------------------------
    // Pending bits:
    // pending_next = (pending & ~clear) | new_request
    // Request wins over clear if both happen in the same cycle.
    // --------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset)
            pending <= {IRQ_COUNT{1'b0}};
        else
            pending <= (pending & ~clear_vector) | irq_request;
    end

    // --------------------------------------------------------
    // Active interrupt and nesting stack.
    //
    // On acknowledgement of a higher-priority interrupt, save
    // the previous active interrupt and activate the new one.
    // On EOI, restore the most recently saved interrupt; if the
    // stack is empty, return to the idle/no-active state.
    //
    // If ACK and EOI occur together, ACK is given priority.
    // Stack overflow prevents accepting a nested interrupt.
    // --------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active_irq_id <= {IRQ_WIDTH{1'b0}};
            active_valid  <= 1'b0;
            stack_pointer <= {PTR_WIDTH{1'b0}};

            for (j = 0; j < STACK_DEPTH; j = j + 1)
                irq_stack[j] <= {IRQ_WIDTH{1'b0}};
        end
        else begin
            if (accept_irq) begin
                // Nested acceptance: preserve the currently active IRQ.
                if (active_valid) begin
                    if (candidate_id < active_irq_id &&
                        stack_pointer < STACK_DEPTH) begin
                        irq_stack[stack_pointer] <= active_irq_id;
                        stack_pointer <= stack_pointer + 1'b1;
                        active_irq_id <= candidate_id;
                    end
                    // If stack is full, do not replace the active IRQ.
                    // The pending request remains available for later.
                end
                else begin
                    active_irq_id <= candidate_id;
                    active_valid  <= 1'b1;
                end
            end
            else if (finish_irq) begin
                if (stack_pointer != 0) begin
                    active_irq_id <= irq_stack[stack_pointer - 1'b1];
                    stack_pointer <= stack_pointer - 1'b1;
                    active_valid  <= 1'b1;
                end
                else begin
                    active_irq_id <= {IRQ_WIDTH{1'b0}};
                    active_valid  <= 1'b0;
                end
            end
        end
    end

endmodule
