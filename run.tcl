#### Template Script for RTL->Gate-Level Flow (generated from GENUS 20.10-d545_1) 

set_db information_level 9

if {[file exists /proc/cpuinfo]} {

puts "INFO: -----------------------------------------------------"
puts "INFO: Print Hostname : [info hostname]                     "
puts "INFO: -----------------------------------------------------"

sh grep "model name" /proc/cpuinfo
sh grep "cpu MHz"    /proc/cpuinfo

}

##############################################################################
## Preset global variables and attributes
##############################################################################


set DESIGN cva6
set GEN_EFF medium
set MAP_OPT_EFF medium
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs_${DATE}
set _REPORTS_PATH reports_${DATE}
set _LOG_PATH logs_${DATE}
set MODUS_WORKDIR MODUS_files
set_db / .init_lib_search_path {./LIB} 
#set_db / .script_search_path {. <path>} 
set_db / .init_hdl_search_path {./RTL} 
##Uncomment and specify machine names to enable super-threading.
##set_db / .super_thread_servers {<machine names>} 
##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
set_db / .max_cpus_per_server 8

##Default undriven/unconnected setting is 'none'.  
##set_db / .hdl_unconnected_value 0 | 1 | x | none
set_db pbs_mmmc_flow true
set_db / .information_level 9


set_db tns_opto true
###############################################################
## Library setup
###############################################################


read_libs  "./LIB/tcbn65gplustc.lib"

##read_mmmc mmmc.tcl

read_physical -lef "./LEF/antenna_9lm.lef ./LEF/tcbn65gplus_9lmT2.lef ./LEF/tpan65gpgv2od3_9lm.lef" 

## Provide either cap_table_file or the qrc_tech_file
set_db / .cap_table_file "./captable/cln65g+_1p09m+alrdl_typical_top2.captable"
##read_qrc <qrcTechFile name>
##generates <signal>_reg[<bit_width>] format
set_db / .hdl_array_naming_style %s\[%d\]  

##set_db / .lp_clock_gating_prefix _LP_CLKG_
##set_db / .lp_insert_clock_gating true 


####################################################################
## Load Design
####################################################################


read_hdl -sv "cv64a6_imafdc_sv39_config_pkg.sv riscv_pkg.sv rvfi_pkg.sv ariane_dm_pkg.sv ariane_pkg.sv cvxif_pkg.sv cvxif_instr_pkg.sv axi_pkg.sv ariane_axi_pkg.sv cf_math_pkg.sv   axi_shim.sv bht.sv   fpnew_pkg.sv std_cache_pkg.sv wt_cache_pkg.sv alu.sv amo_buffer.sv   ariane_regfile_ff.sv ariane_regfile_fpga.sv AsyncDpRam.sv AsyncThreePortRam.sv axi_adapter.sv axi_intf.sv  branch_unit.sv btb.sv cache_ctrl.sv defs_div_sqrt_mvp.sv commit_stage.sv compressed_decoder.sv controller.sv control_mvp.sv counter.sv csr_buffer.sv csr_regfile.sv  cva6_icache_axi_wrapper.sv cva6_icache.sv cva6_mmu_sv32.sv cva6_ptw_sv32.sv cva6_shared_tlb_sv32.sv cva6.sv cva6_tlb_sv32.sv cvxif_example_coprocessor.sv cvxif_fu.sv   decoder.sv delta_counter.sv div_sqrt_top_mvp.sv exp_backoff.sv ex_stage.sv fifo_v3.sv fpnew_cast_multi.sv fpnew_classifier.sv fpnew_divsqrt_multi.sv fpnew_fma_multi.sv fpnew_fma.sv fpnew_noncomp.sv fpnew_opgroup_block.sv fpnew_opgroup_fmt_slice.sv fpnew_opgroup_multifmt_slice.sv fpnew_rounding.sv fpnew_top.sv fpu_wrap.sv frontend.sv id_stage.sv instr_decoder.sv instr_queue.sv instr_realign.sv instr_scan.sv issue_read_operands.sv issue_stage.sv iteration_div_sqrt_mvp.sv lfsr_8bit.sv lfsr.sv load_store_unit.sv load_unit.sv lsu_bypass.sv lzc.sv miss_handler.sv mmu.sv multiplier.sv mult.sv norm_div_sqrt_mvp.sv nrbd_nrsc_mvp.sv perf_counters.sv pmp_entry.sv pmp.sv popcount.sv preprocess_mvp.sv ptw.sv ras.sv registers.svh re_name.sv rr_arb_tree.sv scoreboard.sv serdiv.sv shift_reg.sv sram.sv std_cache_subsystem.sv std_nbdcache.sv store_buffer.sv store_unit.sv stream_arbiter_flushable.sv stream_arbiter.sv stream_demux.sv stream_mux.sv SyncDpRam.sv tag_cmp.sv tc_sram.sv tc_sram_wrapper.sv tlb.sv unread.sv wt_axi_adapter.sv wt_cache_subsystem.sv wt_dcache_ctrl.sv wt_dcache_mem.sv wt_dcache_missunit.sv wt_dcache.sv wt_dcache_wbuffer.sv"


elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"

set_db [get_db insts i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_tag_srams[*].i_tag_sram] .preserve true
set_db [get_db insts i_cache_subsystem/i_wt_dcache/i_wt_dcache_mem/gen_data_banks[*].i_data_sram] .preserve true
set_db [get_db insts i_cache_subsystem/i_cva6_icache/gen_sram[*].data_sram] .preserve true
set_db [get_db insts i_cache_subsystem/i_cva6_icache/gen_sram[*].tag_sram] .preserve true


set_db optimize_constant_0_flops true         ;# Allows constant 0 propogation through flip flops
set_db optimize_constant_1_flops true         ;# Allows constant 1 propogation through flip flops
set_db delete_unloaded_seqs true              ;# Controls the deletion of unloaded sequential instances

set_db write_vlog_empty_module_for_logic_abstract true

report_hierarchy ${DESIGN} > ${_OUTPUTS_PATH}/SYN/${DESIGN}-hierarchy.rpt
write_hdl > ${_OUTPUTS_PATH}/NETLIST/${DESIGN}_elab.v
write_db -all_root_attributes -to_file ${_OUTPUTS_PATH}/DBS/${DESIGN}_elab.db


time_info Elaboration



check_design -unresolved

####################################################################
## Constraints Setup
####################################################################

read_sdc ./constraint.sdc
 
puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"


#set_db "design:$DESIGN" .force_wireload <wireload name> 

if {![file exists ${_LOG_PATH}]} {
  file mkdir ${_LOG_PATH}
  puts "Creating directory ${_LOG_PATH}"
}

if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}
puts "starting timing analysis"
init_design
time_info init_design
check_timing_intent


###################################################################################
## Define cost groups (clock-clock, clock-output, input-clock, input-output)
###################################################################################

## Uncomment to remove already existing costgroups before creating new ones.
## delete_obj [vfind /designs/* -cost_group *]

if {[llength [all_registers]] > 0} { 
  define_cost_group -name I2C -design $DESIGN
  define_cost_group -name C2O -design $DESIGN
  define_cost_group -name C2C -design $DESIGN
  path_group -from [all_registers] -to [all_registers] -group C2C -name C2C
  path_group -from [all_registers] -to [all_outputs] -group C2O -name C2O
  path_group -from [all_inputs]  -to [all_registers] -group I2C -name I2C
} 
define_cost_group -name I2O -design $DESIGN
path_group -from [all_inputs]  -to [all_outputs] -group I2O -name I2O

foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] >> $_REPORTS_PATH/${DESIGN}_pretim.rpt
}
##################################################################################################
## DFT Setup
##################################################################################################

set_db / .dft_scan_style muxed_scan 
set_db / .dft_prefix DFT_ 
# For VDIO customers, it is recommended to set the value of the next two attributes to false.
##set_db / .dft_identify_top_level_test_clocks true 
##set_db / .dft_identify_test_signals true 

##set_db / .dft_identify_internal_test_clocks false 
##set_db / .use_scan_seqs_for_non_dft false 

set_db "design:$DESIGN" .dft_scan_map_mode tdrc_pass 
set_db "design:$DESIGN" .dft_connect_shift_enable_during_mapping tie_off 
set_db "design:$DESIGN" .dft_connect_scan_data_pins_during_mapping loopback 
set_db "design:$DESIGN" .dft_scan_output_preference auto 
set_db "design:$DESIGN" .dft_lockup_element_type preferred_level_sensitive 
set_db "design:$DESIGN" .dft_mix_clock_edges_in_scan_chains true
set_db use_scan_seqs_for_non_dft false
 
##set_db [vfind / -hinst sram] .dft_dont_scan true 
##set_db [vfind / -hinst tc_sram] .dft_dont_scan true 
#set_db "<from pin> <inverting|non_inverting>" .dft_controllable <to pin>

define_shift_enable -name SE -active high -create_port SE

##define_test_mode -active high -create_port test_mode
#set_db "design:$DESIGN" .lp_clock_gating_test_signal Scan_en

## If you intend to insert compression logic, define your compression test signals or clocks here:
## define_test_mode...  [-shared_in]
## define_test_clock...
#########################################################################
## Segments Constraints (support fixed, floating, preserved and abstract)
## only showing preserved, and abstract segments as these are most often used
#############################################################################

##define_scan_preserved_segment -name <segObject> -sdi <pin|port|subport> -sdo <pin|port|subport> -analyze 
## If the block is complete from a DFT perspective, uncomment to prevent any non-scan flops from being scan-replaced
#set_db [get_db insts -if {.is_sequential==true && .dft_mapped==false}] .dft_dont_scan true
##define_scan_abstract_segment -name <segObject> <-module|-insts|-libcell> -sdi <pin> -sdo <pin> -clock_port <pin> [-rise|-fall] -shift_enable_port <pin> -active <high|low> -length <integer> 
## Uncomment if abstract segments are modeled in CTL format
##read_dft_abstract_model -ctl <file>


define_scan_chain -name top_chain -sdi scan_in -sdo scan_out -shift_enable SE -create_ports

## Run the DFT rule checks
check_dft_rules > $_REPORTS_PATH/${DESIGN}-tdrcs
report_scan_registers > $_REPORTS_PATH/${DESIGN}-DFTregs
report_scan_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_tdrc

## Fix the DFT Violations
## Uncomment to fix dft violations
set numDFTviolations [check_dft_rules]
if {$numDFTviolations > "0"} {
report_dft_violations > $_REPORTS_PATH/${DESIGN}-DFTviols  
   fix_dft_violations -async_set -async_reset [-clock] -test_control <TestModeObject>
   check_dft_rules
}

##  Run the Advanced DFT rule checks to identify:
## ...  x-source generators, internal tristate nets, and clock and data race violations
## Note:  tristate nets are reported for busses in which the enables are driven by
## tristate devices.  Use 'check_design' to report other types of multidriven nets.

check_design \
    -undriven \
    -unloaded \
    -unresolved \
    -multiple_driver > $_REPORTS_PATH/${DESIGN}-check_design_after_elab.rpt
check_dft_rules -advanced  > $_REPORTS_PATH/${DESIGN}-Advancedtdrcs
report_dft_violations > $_REPORTS_PATH/${DESIGN}-AdvancedDFTViols

## Fix the Avanced DFT Violations
## ... x-source violations are fixed by inserting registered shadow logic
## ... tristate net violations are fixed by selectively enabling and disabiling the tristate enable signals
##  in shift-mode. 
## ... clock and data race violations are not auto-fixed by the tool.
## Note: The fixing of tristate net violations using the 'fix_dft_violations -tristate_net' command
## should be deferred until a full-chip representation of the design is available.

## Uncomment to fix x-source violations (or alternatively, insert the shadow logic using the
## 'add_shadow_logic' command).
#fix_dft_violations -xsource -test_control <TestModeObject> -test_clock_pin <ClockPinOrPort> [-exclude_xsource <instance>]
check_dft_rules -advanced

## Update DFT status
report_scan_registers > $_REPORTS_PATH/${DESIGN}-DFTregs_tdrc
report_scan_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_tdrc


#### To turn off sequential merging on the design 
#### uncomment & use the following attributes.
##set_db / .optimize_merge_flops false 
##set_db / .optimize_merge_latches false 
#### For a particular instance use attribute 'optimize_merge_seqs' to turn off sequential merging. 



####################################################################################################
## Synthesizing to generic 
####################################################################################################

set_db / .syn_generic_effort $GEN_EFF
syn_generic
puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC
report_dp > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
write_snapshot -outdir $_REPORTS_PATH -tag generic
report_summary -directory $_REPORTS_PATH




######################################################################################################
## Optional DFT commands (section 1)
######################################################################################################

#############
## Identify Functional Shift Registers
#############
#identify_shift_register_scan_segments

#############
## Add testability logic as required
#############
#add_shadow_logic -around <instance> -mode <no_share|share|bypass> -test_control <TestModeObject>
#add_test_point -location <port|pin> -test_control <test_signal> -type <string>

#######################
## Add Boundary Scan and Programmable MBIST logic
########################

## Uncomment to define the existing 3rd party TAP controller to be used as the master controller for
## DFT logic such as boundary-scan, compression, Programmable MBIST and ptam.
#define_jtag_macro -name <objectName> ....

## Define JTAG Instructions for the existing Macro or when building the JTAG_Macro with user-defined instructions. 
## ... For current release, name the mandatory JTAG instructions as: EXTEST, SAMPLE, PRELOAD, BYPASS

##define_jtag_instruction_register -name <string> -length <integer> -capture <string>
##define_jtag_instruction -name <string> -opcode <string> ;# [-register <string> -length <integer>] [-private]

## Uncomment to build a JTAG_Macro with Programmable MBIST instructions.
## Names of the mandatory instructions are: MBISTTPN, MBISTSCH, MBISTCHK
#define_jtag_instruction -name <string> -opcode <string> -register <string> -length <integer>

## Uncomment to define the MBIST clock if inserting Programmable MBIST logic
#define_mbist_clock -name <objectNameOfMBISTClock> -period <integer> <port> ..

## Uncomment to read memory view files for programmable MBIST
#read_pmbist_memory_view -cdns_memory_view_file <string> -arm_mbif <string> -directory <string> <design>

#add_jtag_boundary_scan -tck <tckpin> -tdi <tdipin> -tms <tmspin> -trst <trstpin> -tdo <tdopin> -exclude_ports <list of ports excluded from boundary register> -preview

## Uncomment to read block-level interface files for programmable MBIST
#read_dft_pmbist_interface_files -directory <locationOfInterfaceFiles> <lib_cell|module|design>

## Uncomment to insert Programmable BIST (PMBIST) for memories
#add_pmbist -config_file <filename> -connect_to_jtag -directory <PMBISTworkDir> -dft_cfg_mode <dft_configuration_mode> -amu_location <design|module|inst|hinst> ..

## Uncomment to write interface files for programmable MBIST
#write_dft_pmbist_interface_files -directory <locationOfInterfaceFiles> [<design>]

## Uncomment to write out data and script files to generate PMBIST patterns
#write_dft_pmbist_testbench [-create_embedded_test_options <string>] [-irun_options <string>] [-directory <string>] [-testbench_directory <string>] [-ncsim_library <string>] [-script_only] [-no_deposit_script] [-no_build_model] [<design>]

##Write out BSDL file
#write_dft_bsdl -bsdlout <BSDLfileName> -directory <work directory>


####################################################################################################
## Synthesizing to gates
####################################################################################################


set_db / .dft_auto_identify_shift_register true 
## identify functional shift register segments. Not applicable for n2n flow.
set_db / .syn_map_effort $MAP_OPT_EFF
syn_map
puts "Runtime & Memory after 'syn_map'"
time_info MAPPED
write_snapshot -outdir $_REPORTS_PATH -tag map
report_summary -directory $_REPORTS_PATH
report_dp > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt


foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_map.rpt
}


write_do_lec -revised_design fv_map -logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

## ungroup -threshold <value>

#######################################################################################################
## Optimize Netlist
#######################################################################################################
set_db / .syn_opt_effort $MAP_OPT_EFF
syn_opt
write_snapshot -outdir $_REPORTS_PATH -tag syn_opt
report_summary -directory $_REPORTS_PATH

puts "Runtime & Memory after 'syn_opt'"
time_info OPT

foreach cg [vfind / -cost_group *] {
  report_timing -group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_opt.rpt
}

######################################################################################################
## Optional additional DFT commands. (section 2)
######################################################################################################

## Re-run DFT rule checks
#check_dft_rules -advanced
## Build the full scan chanins
connect_scan_chains -auto_create_chains
report_scan_chains > $_REPORTS_PATH/${DESIGN}-DFTchains

## Inserting Compression logic
## add_test_compression -ratio <integer>  -mask <string> [-auto_create] [-preview]
##report_scan_chains > $_REPORTS_PATH/${DESIGN}-DFTchains_compression
## Reapply CPF rules
#commit_cpf

#######################################################################################################
## Optimize Netlist
#######################################################################################################
 
## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_db / .remove_assigns true 
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign>
##set_db / .use_tiehilo_for_const <none|duplicate|unique> 
 
## An effort of low was selected to minimize runtime of incremental opto.
## If your timing is not met, rerun incremental opto with a different effort level

write_snapshot -outdir $_REPORTS_PATH -tag syn_opt_low_incr 
report_summary -directory $_REPORTS_PATH
puts "Runtime & Memory after 'syn_opt'"
time_info INCREMENTAL_POST_SCAN_CHAINS


## generate reports to save the Innovus stats
write_snapshot -innovus -outdir $_OUTPUTS_PATH -tag syn_opt
summary_table -directory $_REPORTS_PATH
puts "Runtime & Memory after syn_opt"
time_info OPT


#check_dft_rules
#############################################
## DFT Reports
#############################################

report_scan_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_final
write_scandef > ${DESIGN}-scanDEF
write_dft_abstract_model > ${DESIGN}-scanAbstract
write_hdl -abstract > ${DESIGN}-logicAbstract
write_script -analyze_all_scan_chains > ${DESIGN}-writeScript-analyzeAllScanChains
## write_dft_jtag_boundary_verification -library <Verilog structural library files> -directory $MODUS_WORKDIR 
write_dft_atpg -library ./LIB/libfile.v -compression -directory $MODUS_WORKDIR 


######################################################################################################
## write backend file set (verilog, SDC, config, etc.)
######################################################################################################



report_dp > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
report_messages > $_REPORTS_PATH/${DESIGN}_messages.rpt
write_snapshot -outdir $_REPORTS_PATH -tag final
report_summary -directory $_REPORTS_PATH
write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_m.v
write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_m.sdc



#################################
### write_do_lec
#################################


write_do_lec -golden_design fv_map -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
##Uncomment if the RTL is to be compared with the final netlist..
write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do

puts "Final Runtime & Memory."
time_info FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"

file copy [get_db / .stdout_log] ${_LOG_PATH}/.

##quit
