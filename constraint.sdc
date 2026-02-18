### Author: Talha bin Azmat
### Email: talha.azmat@10xengineers.ai : talhabinazmat@gmail.com

set sdc_version 2.0
set_units -time ns

current_design cva6


create_clock -name "clk_i" -add -period 10.0 -waveform {0.0 5.0} [get_ports clk_i]

set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports rst_ni]
set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports boot_addr_i]
set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports hart_id_i]
set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports irq_i]
set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports ipi_i]
set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports time_irq_i]
set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports debug_req_i]
##set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports cvxif_resp_i]
##set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports l15_rtrn_i]
##set_input_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports axi_resp_i]



set_output_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports rvfi_o]
set_output_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports cvxif_req_o]
set_output_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports l15_req_o]
set_output_delay -clock [get_clocks clk_i] -add_delay 0.3 [get_ports axi_req_o]



set_max_fanout 15.000 [current_design]
set_max_transition 0.385 [current_design]
