###############################################################################
# interrupt_controller.sdc
# Synopsys Design Constraints (SDC) for Cadence Genus (synthesis) / Innovus (P&R)
# Design : interrupt_controller  (16-source priority interrupt controller)
# Clock  : clk    (single clock domain, rising edge)
# Reset  : reset  (asynchronous, active-high)
###############################################################################

# -----------------------------------------------------------------------------
# User-tunable parameters
# -----------------------------------------------------------------------------
set CLK_PERIOD   10000.0    ;# ps -> 100 MHz (10 ns period; matches always #5 in TB)
set CLK_UNCERTAINTY 250.0   ;# ps (0.25 ns jitter + skew margin)
set CLK_LATENCY      0.0    ;# ps (ideal clock before CTS)
set CLK_TRANSITION 100.0    ;# ps (0.10 ns)
set IN_DELAY      2000.0    ;# ps (2 ns external delay on inputs)
set OUT_DELAY     2000.0    ;# ps (2 ns external delay on outputs)
set IN_DRIVE_CELL   "BUFX2" ;# <-- change to a buffer that exists in YOUR library
set OUT_LOAD         0.05   ;# pF load on each output (adjust to library units)

# -----------------------------------------------------------------------------
# Clock definition
# -----------------------------------------------------------------------------
create_clock -name clk -period $CLK_PERIOD -waveform [list 0 [expr {$CLK_PERIOD/2.0}]] [get_ports clk]

set_clock_uncertainty $CLK_UNCERTAINTY [get_clocks clk]
set_clock_latency     $CLK_LATENCY     [get_clocks clk]
set_clock_transition  $CLK_TRANSITION  [get_clocks clk]

# -----------------------------------------------------------------------------
# Input constraints
# -----------------------------------------------------------------------------
# All data/control inputs (everything except clk and the async reset)
set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports {clk reset}]]

set_input_delay -clock clk -max $IN_DELAY $DATA_INPUTS
set_input_delay -clock clk -min 500.0     $DATA_INPUTS   ;# 0.5 ns hold margin

# Drive strength model for inputs (comment out if the cell name does not exist)
set_driving_cell -lib_cell $IN_DRIVE_CELL $DATA_INPUTS

# Input transition on the reset port
set_input_transition 200.0 [get_ports reset] ;# 0.2 ns

# -----------------------------------------------------------------------------
# Asynchronous reset
# Reset is asserted/deasserted by the system, not timed against clk for the
# assertion edge. Recovery/removal on the flops is still checked from the
# input delay below. If reset arrives from a synchronizer, this is correct.
# -----------------------------------------------------------------------------
set_input_delay -clock clk -max $IN_DELAY [get_ports reset]
set_input_delay -clock clk -min 500.0     [get_ports reset]
set_false_path -hold -from [get_ports reset]   ;# optional: relax reset removal at synthesis stage
# Reset fan-out is high; do not let the tool buffer it as a data net issue
# set_max_transition 0.5 [get_ports reset]

# -----------------------------------------------------------------------------
# Output constraints
# -----------------------------------------------------------------------------
set_output_delay -clock clk -max $OUT_DELAY [all_outputs]
set_output_delay -clock clk -min 0.0        [all_outputs]
set_load $OUT_LOAD [all_outputs]

# -----------------------------------------------------------------------------
# Combinational through-paths (input -> output)
# 'mask' and 'irq' feed cpu_irq / irq_id combinationally (pending & ~mask ->
# priority encoder). Budget = CLK_PERIOD - IN_DELAY - OUT_DELAY = 6 ns here.
# Nothing extra is required; this comment documents the critical path.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Design rule constraints
# -----------------------------------------------------------------------------
set_max_transition 500.0 [current_design] ;# 0.5 ns
set_max_fanout     16  [current_design]

# -----------------------------------------------------------------------------
# Static / quasi-static inputs
# 'trigger_type' is a configuration input (level vs. edge select) that is
# normally written once, not toggled every cycle. Left timed by default for
# a conservative result. Uncomment to treat as static:
# set_false_path -from [get_ports trigger_type]
# -----------------------------------------------------------------------------

# End of file
