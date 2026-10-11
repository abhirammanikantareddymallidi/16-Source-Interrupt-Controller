# liberty file path
read_libs /home/vlsi53/Cadence/FOUNDRY/digital/90nm/dig/lib/slow.lib
# top logic file name
read_hdl interrupt_controller.v
elaborate
# sdc file name
read_sdc interrupt_controller.sdc
# setting effort levels for 3 stages
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
# synthesis of generic gates
syn_generic
# synthesising for mapping
syn_map
# for optimization
syn_opt
# for sequential circuits
report_timing > interrupt_timing.repo
# for combinational circuits
report_timing -unconstrained > interrupt_timing.repo
# generating power report
report_power > interrupt_power.repo
# generating area report
report_area > interrupt_area.repo
# generating netlist from synthesis
write_hdl > interrupt_netlist.v
# generating sdc file from synthesis
write_sdc > interrupt_output.sdc
# to see the schematic
gui_show

