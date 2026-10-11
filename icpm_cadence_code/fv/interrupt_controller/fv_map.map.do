
//input ports
add mapped point clk clk -type PI PI
add mapped point reset reset -type PI PI
add mapped point irq[15] irq[15] -type PI PI
add mapped point irq[14] irq[14] -type PI PI
add mapped point irq[13] irq[13] -type PI PI
add mapped point irq[12] irq[12] -type PI PI
add mapped point irq[11] irq[11] -type PI PI
add mapped point irq[10] irq[10] -type PI PI
add mapped point irq[9] irq[9] -type PI PI
add mapped point irq[8] irq[8] -type PI PI
add mapped point irq[7] irq[7] -type PI PI
add mapped point irq[6] irq[6] -type PI PI
add mapped point irq[5] irq[5] -type PI PI
add mapped point irq[4] irq[4] -type PI PI
add mapped point irq[3] irq[3] -type PI PI
add mapped point irq[2] irq[2] -type PI PI
add mapped point irq[1] irq[1] -type PI PI
add mapped point irq[0] irq[0] -type PI PI
add mapped point mask[15] mask[15] -type PI PI
add mapped point mask[14] mask[14] -type PI PI
add mapped point mask[13] mask[13] -type PI PI
add mapped point mask[12] mask[12] -type PI PI
add mapped point mask[11] mask[11] -type PI PI
add mapped point mask[10] mask[10] -type PI PI
add mapped point mask[9] mask[9] -type PI PI
add mapped point mask[8] mask[8] -type PI PI
add mapped point mask[7] mask[7] -type PI PI
add mapped point mask[6] mask[6] -type PI PI
add mapped point mask[5] mask[5] -type PI PI
add mapped point mask[4] mask[4] -type PI PI
add mapped point mask[3] mask[3] -type PI PI
add mapped point mask[2] mask[2] -type PI PI
add mapped point mask[1] mask[1] -type PI PI
add mapped point mask[0] mask[0] -type PI PI
add mapped point trigger_type[15] trigger_type[15] -type PI PI
add mapped point trigger_type[14] trigger_type[14] -type PI PI
add mapped point trigger_type[13] trigger_type[13] -type PI PI
add mapped point trigger_type[12] trigger_type[12] -type PI PI
add mapped point trigger_type[11] trigger_type[11] -type PI PI
add mapped point trigger_type[10] trigger_type[10] -type PI PI
add mapped point trigger_type[9] trigger_type[9] -type PI PI
add mapped point trigger_type[8] trigger_type[8] -type PI PI
add mapped point trigger_type[7] trigger_type[7] -type PI PI
add mapped point trigger_type[6] trigger_type[6] -type PI PI
add mapped point trigger_type[5] trigger_type[5] -type PI PI
add mapped point trigger_type[4] trigger_type[4] -type PI PI
add mapped point trigger_type[3] trigger_type[3] -type PI PI
add mapped point trigger_type[2] trigger_type[2] -type PI PI
add mapped point trigger_type[1] trigger_type[1] -type PI PI
add mapped point trigger_type[0] trigger_type[0] -type PI PI
add mapped point cpu_ack cpu_ack -type PI PI
add mapped point cpu_eoi cpu_eoi -type PI PI

//output ports
add mapped point cpu_irq cpu_irq -type PO PO
add mapped point irq_id[3] irq_id[3] -type PO PO
add mapped point irq_id[2] irq_id[2] -type PO PO
add mapped point irq_id[1] irq_id[1] -type PO PO
add mapped point irq_id[0] irq_id[0] -type PO PO
add mapped point active active -type PO PO
add mapped point stack_full stack_full -type PO PO
add mapped point stack_empty stack_empty -type PO PO

//inout ports




//Sequential Pins
add mapped point active_irq_id[0]/q active_irq_id_reg[0]/Q -type DFF DFF
add mapped point active_irq_id[1]/q active_irq_id_reg[1]/Q -type DFF DFF
add mapped point active_irq_id[2]/q active_irq_id_reg[2]/Q -type DFF DFF
add mapped point active_irq_id[3]/q active_irq_id_reg[3]/Q -type DFF DFF
add mapped point stack_pointer[2]/q stack_pointer_reg[2]/Q -type DFF DFF
add mapped point stack_pointer[1]/q stack_pointer_reg[1]/Q -type DFF DFF
add mapped point pending[3]/q pending_reg[3]/Q -type DFF DFF
add mapped point pending[13]/q pending_reg[13]/Q -type DFF DFF
add mapped point pending[11]/q pending_reg[11]/Q -type DFF DFF
add mapped point pending[6]/q pending_reg[6]/Q -type DFF DFF
add mapped point pending[7]/q pending_reg[7]/Q -type DFF DFF
add mapped point pending[10]/q pending_reg[10]/Q -type DFF DFF
add mapped point stack_pointer[0]/q stack_pointer_reg[0]/Q -type DFF DFF
add mapped point pending[0]/q pending_reg[0]/Q -type DFF DFF
add mapped point pending[15]/q pending_reg[15]/Q -type DFF DFF
add mapped point pending[1]/q pending_reg[1]/Q -type DFF DFF
add mapped point pending[4]/q pending_reg[4]/Q -type DFF DFF
add mapped point pending[5]/q pending_reg[5]/Q -type DFF DFF
add mapped point pending[9]/q pending_reg[9]/Q -type DFF DFF
add mapped point pending[8]/q pending_reg[8]/Q -type DFF DFF
add mapped point pending[12]/q pending_reg[12]/Q -type DFF DFF
add mapped point pending[14]/q pending_reg[14]/Q -type DFF DFF
add mapped point irq_stack[1][3]/q irq_stack_reg[1][3]/Q -type DFF DFF
add mapped point irq_stack[3][1]/q irq_stack_reg[3][1]/Q -type DFF DFF
add mapped point irq_stack[1][1]/q irq_stack_reg[1][1]/Q -type DFF DFF
add mapped point irq_stack[1][2]/q irq_stack_reg[1][2]/Q -type DFF DFF
add mapped point irq_stack[0][1]/q irq_stack_reg[0][1]/Q -type DFF DFF
add mapped point irq_stack[0][0]/q irq_stack_reg[0][0]/Q -type DFF DFF
add mapped point irq_stack[0][2]/q irq_stack_reg[0][2]/Q -type DFF DFF
add mapped point irq_stack[1][0]/q irq_stack_reg[1][0]/Q -type DFF DFF
add mapped point irq_stack[0][3]/q irq_stack_reg[0][3]/Q -type DFF DFF
add mapped point irq_stack[2][2]/q irq_stack_reg[2][2]/Q -type DFF DFF
add mapped point irq_stack[2][0]/q irq_stack_reg[2][0]/Q -type DFF DFF
add mapped point irq_stack[2][1]/q irq_stack_reg[2][1]/Q -type DFF DFF
add mapped point irq_stack[3][0]/q irq_stack_reg[3][0]/Q -type DFF DFF
add mapped point irq_stack[3][3]/q irq_stack_reg[3][3]/Q -type DFF DFF
add mapped point irq_stack[2][3]/q irq_stack_reg[2][3]/Q -type DFF DFF
add mapped point irq_stack[3][2]/q irq_stack_reg[3][2]/Q -type DFF DFF
add mapped point active_valid/q active_valid_reg/Q -type DFF DFF
add mapped point pending[2]/q pending_reg[2]/Q -type DFF DFF
add mapped point irq_previous[1]/q irq_previous_reg[1]/Q -type DFF DFF
add mapped point irq_previous[10]/q irq_previous_reg[10]/Q -type DFF DFF
add mapped point irq_previous[3]/q irq_previous_reg[3]/Q -type DFF DFF
add mapped point irq_previous[6]/q irq_previous_reg[6]/Q -type DFF DFF
add mapped point irq_previous[7]/q irq_previous_reg[7]/Q -type DFF DFF
add mapped point irq_previous[8]/q irq_previous_reg[8]/Q -type DFF DFF
add mapped point irq_previous[12]/q irq_previous_reg[12]/Q -type DFF DFF
add mapped point irq_previous[15]/q irq_previous_reg[15]/Q -type DFF DFF
add mapped point irq_previous[5]/q irq_previous_reg[5]/Q -type DFF DFF
add mapped point irq_previous[14]/q irq_previous_reg[14]/Q -type DFF DFF
add mapped point irq_previous[9]/q irq_previous_reg[9]/Q -type DFF DFF
add mapped point irq_previous[0]/q irq_previous_reg[0]/Q -type DFF DFF
add mapped point irq_previous[11]/q irq_previous_reg[11]/Q -type DFF DFF
add mapped point irq_previous[4]/q irq_previous_reg[4]/Q -type DFF DFF
add mapped point irq_previous[13]/q irq_previous_reg[13]/Q -type DFF DFF
add mapped point irq_previous[2]/q irq_previous_reg[2]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
