# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

loadIpCore           -dir "$::DIR_PATH/cores/"
loadSource           -dir "$::DIR_PATH/rtl/" -fileType "vhdl 2008"
loadSource -sim_only -dir "$::DIR_PATH/tb/"   -fileType "vhdl 2008"
