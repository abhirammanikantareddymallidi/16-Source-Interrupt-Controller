`timescale 1ns / 1ps

module tb_interrupt_controller;

    reg clk = 1'b0;
    reg reset = 1'b1;
    reg [15:0] irq = 16'b0;
    reg [15:0] mask = 16'b0;
    reg [15:0] trigger_type = 16'b0;
    reg cpu_ack = 1'b0;
    reg cpu_eoi = 1'b0;

    wire cpu_irq;
    wire [3:0] irq_id;
    wire active;
    wire stack_full;
    wire stack_empty;

    interrupt_controller #(
        .IRQ_COUNT(16),
        .STACK_DEPTH(4),
        .IRQ_WIDTH(4)
    ) dut (
        .clk(clk),
        .reset(reset),
        .irq(irq),
        .mask(mask),
        .trigger_type(trigger_type),
        .cpu_ack(cpu_ack),
        .cpu_eoi(cpu_eoi),
        .cpu_irq(cpu_irq),
        .irq_id(irq_id),
        .active(active),
        .stack_full(stack_full),
        .stack_empty(stack_empty)
    );

    always #5 clk = ~clk;

    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    initial begin
        $dumpfile("interrupt_controller.vcd");
        $dumpvars(0, tb_interrupt_controller);

        // Reset
        tick();
        reset = 1'b0;

        // Test 1: level-triggered IRQ5
        irq[5] = 1'b1;
        tick();
        #1;
        if (!cpu_irq || irq_id != 4'd5)
            $display("FAIL: expected level IRQ5");
        else
            $display("PASS: level IRQ5 detected");

        // Acknowledge IRQ5
        cpu_ack = 1'b1;
        tick();
        cpu_ack = 1'b0;
        if (!active || irq_id != 4'd5)
            $display("FAIL: IRQ5 did not become active");
        else
            $display("PASS: IRQ5 acknowledged");

        // Deassert level input before EOI to prevent re-pending.
        irq[5] = 1'b0;
        tick();

        // Test 2: nested higher-priority IRQ2 while IRQ5 is active.
        irq[2] = 1'b1;
        tick();
        if (!cpu_irq || irq_id != 4'd2)
            $display("FAIL: expected nested IRQ2");
        else
            $display("PASS: higher-priority IRQ2 offered");

        cpu_ack = 1'b1;
        tick();
        cpu_ack = 1'b0;
        if (!active || irq_id != 4'd2)
            $display("FAIL: IRQ2 did not become active");
        else
            $display("PASS: IRQ2 acknowledged as nested interrupt");

        irq[2] = 1'b0;
        tick();

        // EOI restores IRQ5.
        cpu_eoi = 1'b1;
        tick();
        cpu_eoi = 1'b0;
        if (!active || irq_id != 4'd5)
            $display("FAIL: IRQ5 was not restored");
        else
            $display("PASS: previous IRQ5 restored");

        // EOI with empty stack returns to idle.
        cpu_eoi = 1'b1;
        tick();
        cpu_eoi = 1'b0;
        if (active)
            $display("FAIL: controller should be idle");
        else
            $display("PASS: EOI returned controller to idle");

        // Test 3: masking IRQ7.
        mask[7] = 1'b1;
        irq[7] = 1'b1;
        tick();
        if (cpu_irq)
            $display("FAIL: masked IRQ7 should not be offered");
        else
            $display("PASS: IRQ7 correctly masked");

        mask[7] = 1'b0;
        #1;
        if (!cpu_irq || irq_id != 4'd7)
            $display("FAIL: unmasked IRQ7 was not offered");
        else
            $display("PASS: pending IRQ7 offered after unmasking");

        cpu_ack = 1'b1;
        tick();
        cpu_ack = 1'b0;
        irq[7] = 1'b0;
        tick();
        cpu_eoi = 1'b1;
        tick();
        cpu_eoi = 1'b0;

        // Test 4: rising-edge IRQ1.
        trigger_type[1] = 1'b1;
        irq[1] = 1'b1;
        tick();
        if (!cpu_irq || irq_id != 4'd1)
            $display("FAIL: rising-edge IRQ1 not detected");
        else
            $display("PASS: rising-edge IRQ1 detected");

        cpu_ack = 1'b1;
        tick();
        cpu_ack = 1'b0;
        irq[1] = 1'b0;
        tick();
        cpu_eoi = 1'b1;
        tick();
        cpu_eoi = 1'b0;

        $display("Testbench completed. Review PASS/FAIL messages.");
        #10;
        $finish;
    end

endmodule
