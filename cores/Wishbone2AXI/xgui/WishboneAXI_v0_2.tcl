
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/WishboneAXI_v0_2.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {AXI Master}]
  set C_M_AXI4_TARGET_SLAVE_BASE_ADDR [ipgui::add_param $IPINST -name "C_M_AXI4_TARGET_SLAVE_BASE_ADDR" -parent ${Page_0}]
  set_property tooltip {Base address of targeted slave} ${C_M_AXI4_TARGET_SLAVE_BASE_ADDR}
  set C_M_AXI4_BURST_LEN [ipgui::add_param $IPINST -name "C_M_AXI4_BURST_LEN" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths} ${C_M_AXI4_BURST_LEN}
  set C_M_AXI4_ID_WIDTH [ipgui::add_param $IPINST -name "C_M_AXI4_ID_WIDTH" -parent ${Page_0}]
  set_property tooltip {Thread ID Width} ${C_M_AXI4_ID_WIDTH}
  set C_M_AXI4_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_M_AXI4_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of Address Bus} ${C_M_AXI4_ADDR_WIDTH}
  set C_M_AXI4_DATA_WIDTH [ipgui::add_param $IPINST -name "C_M_AXI4_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of Data Bus} ${C_M_AXI4_DATA_WIDTH}

  #Adding Page
  set AXI_Slave [ipgui::add_page $IPINST -name "AXI Slave"]
  set C_S_AXI4_DATA_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI4_DATA_WIDTH" -parent ${AXI_Slave} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_S_AXI4_DATA_WIDTH}
  set C_S_AXI4_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI4_ADDR_WIDTH" -parent ${AXI_Slave}]
  set_property tooltip {Width of S_AXI address bus} ${C_S_AXI4_ADDR_WIDTH}
  ipgui::add_param $IPINST -name "C_S_AXI4_BASEADDR" -parent ${AXI_Slave}
  ipgui::add_param $IPINST -name "C_S_AXI4_HIGHADDR" -parent ${AXI_Slave}
  ipgui::add_param $IPINST -name "C_S_AXI4_ID_WIDTH" -parent ${AXI_Slave}

  #Adding Page
  set AXI_Lite_Master [ipgui::add_page $IPINST -name "AXI Lite Master"]
  set C_M_AXI4_LITE_START_DATA_VALUE [ipgui::add_param $IPINST -name "C_M_AXI4_LITE_START_DATA_VALUE" -parent ${AXI_Lite_Master}]
  set_property tooltip {The master will start generating data from the C_M_START_DATA_VALUE value} ${C_M_AXI4_LITE_START_DATA_VALUE}
  set C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR [ipgui::add_param $IPINST -name "C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR" -parent ${AXI_Lite_Master}]
  set_property tooltip {The master requires a target slave base address.
    -- The master will initiate read and write transactions on the slave with base address specified here as a parameter.} ${C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR}
  set C_M_AXI4_LITE_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_M_AXI4_LITE_ADDR_WIDTH" -parent ${AXI_Lite_Master}]
  set_property tooltip {Width of M_AXI address bus. 
    -- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.} ${C_M_AXI4_LITE_ADDR_WIDTH}
  set C_M_AXI4_LITE_DATA_WIDTH [ipgui::add_param $IPINST -name "C_M_AXI4_LITE_DATA_WIDTH" -parent ${AXI_Lite_Master} -widget comboBox]
  set_property tooltip {Width of M_AXI data bus. 
    -- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH} ${C_M_AXI4_LITE_DATA_WIDTH}
  set C_M_AXI4_LITE_TRANSACTIONS_NUM [ipgui::add_param $IPINST -name "C_M_AXI4_LITE_TRANSACTIONS_NUM" -parent ${AXI_Lite_Master}]
  set_property tooltip {Transaction number is the number of write 
    -- and read transactions the master will perform as a part of this example memory test.} ${C_M_AXI4_LITE_TRANSACTIONS_NUM}

  #Adding Page
  set AXI_Lite_Slave [ipgui::add_page $IPINST -name "AXI Lite Slave"]
  set C_S_AXI4_LITE_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI4_LITE_ADDR_WIDTH" -parent ${AXI_Lite_Slave}]
  set_property tooltip {Width of S_AXI address bus} ${C_S_AXI4_LITE_ADDR_WIDTH}
  set C_S_AXI4_LITE_DATA_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI4_LITE_DATA_WIDTH" -parent ${AXI_Lite_Slave} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_S_AXI4_LITE_DATA_WIDTH}

  ipgui::add_static_text $IPINST -name "Notice" -text {This core supports only AXI Lite -> Wishbone translation for now. More to come.}
  set BRIDGE_TYPE [ipgui::add_param $IPINST -name "BRIDGE_TYPE" -widget comboBox]
  set_property tooltip {AXI->Wishbone or Wishbone->AXI} ${BRIDGE_TYPE}
  set C_AXI_MODE [ipgui::add_param $IPINST -name "C_AXI_MODE" -widget comboBox]
  set_property tooltip {AXI or AXI-Lite} ${C_AXI_MODE}
  #Adding Group
  set sadf [ipgui::add_group $IPINST -name "sadf" -display_name {Wishbone parameters}]
  set C_WB_MODE [ipgui::add_param $IPINST -name "C_WB_MODE" -parent ${sadf} -widget comboBox]
  set_property tooltip {CLASSIC or PIPELINED} ${C_WB_MODE}
  set C_S_WB_ADR_WIDTH [ipgui::add_param $IPINST -name "C_S_WB_ADR_WIDTH" -parent ${sadf}]
  set_property tooltip {Width of Wishbone address bus} ${C_S_WB_ADR_WIDTH}
  ipgui::add_param $IPINST -name "C_S_WB_DAT_WIDTH" -parent ${sadf}
  ipgui::add_param $IPINST -name "C_M_WB_ADR_WIDTH" -parent ${sadf}
  set C_M_WB_DAT_WIDTH [ipgui::add_param $IPINST -name "C_M_WB_DAT_WIDTH" -parent ${sadf}]
  set_property tooltip {In most cases 32 bits is the only reasonable option} ${C_M_WB_DAT_WIDTH}


}

proc update_PARAM_VALUE.C_M_WB_DAT_WIDTH { PARAM_VALUE.C_M_WB_DAT_WIDTH PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH } {
	# Procedure called to update C_M_WB_DAT_WIDTH when any of the dependent parameters in the arguments change
	
	set C_M_WB_DAT_WIDTH ${PARAM_VALUE.C_M_WB_DAT_WIDTH}
	set C_S_AXI4_LITE_DATA_WIDTH ${PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH}
	set values(C_S_AXI4_LITE_DATA_WIDTH) [get_property value $C_S_AXI4_LITE_DATA_WIDTH]
	set_property value [gen_USERPARAMETER_C_M_WB_DAT_WIDTH_VALUE $values(C_S_AXI4_LITE_DATA_WIDTH)] $C_M_WB_DAT_WIDTH
}

proc validate_PARAM_VALUE.C_M_WB_DAT_WIDTH { PARAM_VALUE.C_M_WB_DAT_WIDTH } {
	# Procedure called to validate C_M_WB_DAT_WIDTH
	return true
}

proc update_PARAM_VALUE.BRIDGE_TYPE { PARAM_VALUE.BRIDGE_TYPE } {
	# Procedure called to update BRIDGE_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRIDGE_TYPE { PARAM_VALUE.BRIDGE_TYPE } {
	# Procedure called to validate BRIDGE_TYPE
	return true
}

proc update_PARAM_VALUE.C_AXI_MODE { PARAM_VALUE.C_AXI_MODE } {
	# Procedure called to update C_AXI_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_MODE { PARAM_VALUE.C_AXI_MODE } {
	# Procedure called to validate C_AXI_MODE
	return true
}

proc update_PARAM_VALUE.C_M_WB_ADR_WIDTH { PARAM_VALUE.C_M_WB_ADR_WIDTH } {
	# Procedure called to update C_M_WB_ADR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_WB_ADR_WIDTH { PARAM_VALUE.C_M_WB_ADR_WIDTH } {
	# Procedure called to validate C_M_WB_ADR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_ID_WIDTH { PARAM_VALUE.C_S_AXI4_ID_WIDTH } {
	# Procedure called to update C_S_AXI4_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_ID_WIDTH { PARAM_VALUE.C_S_AXI4_ID_WIDTH } {
	# Procedure called to validate C_S_AXI4_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_WB_ADR_WIDTH { PARAM_VALUE.C_S_WB_ADR_WIDTH } {
	# Procedure called to update C_S_WB_ADR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_WB_ADR_WIDTH { PARAM_VALUE.C_S_WB_ADR_WIDTH } {
	# Procedure called to validate C_S_WB_ADR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_WB_DAT_WIDTH { PARAM_VALUE.C_S_WB_DAT_WIDTH } {
	# Procedure called to update C_S_WB_DAT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_WB_DAT_WIDTH { PARAM_VALUE.C_S_WB_DAT_WIDTH } {
	# Procedure called to validate C_S_WB_DAT_WIDTH
	return true
}

proc update_PARAM_VALUE.C_WB_MODE { PARAM_VALUE.C_WB_MODE } {
	# Procedure called to update C_WB_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_WB_MODE { PARAM_VALUE.C_WB_MODE } {
	# Procedure called to validate C_WB_MODE
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to update C_M_AXI4_TARGET_SLAVE_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to validate C_M_AXI4_TARGET_SLAVE_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_BURST_LEN { PARAM_VALUE.C_M_AXI4_BURST_LEN } {
	# Procedure called to update C_M_AXI4_BURST_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_BURST_LEN { PARAM_VALUE.C_M_AXI4_BURST_LEN } {
	# Procedure called to validate C_M_AXI4_BURST_LEN
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_ID_WIDTH { PARAM_VALUE.C_M_AXI4_ID_WIDTH } {
	# Procedure called to update C_M_AXI4_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_ID_WIDTH { PARAM_VALUE.C_M_AXI4_ID_WIDTH } {
	# Procedure called to validate C_M_AXI4_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_ADDR_WIDTH { PARAM_VALUE.C_M_AXI4_ADDR_WIDTH } {
	# Procedure called to update C_M_AXI4_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_ADDR_WIDTH { PARAM_VALUE.C_M_AXI4_ADDR_WIDTH } {
	# Procedure called to validate C_M_AXI4_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_DATA_WIDTH { PARAM_VALUE.C_M_AXI4_DATA_WIDTH } {
	# Procedure called to update C_M_AXI4_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_DATA_WIDTH { PARAM_VALUE.C_M_AXI4_DATA_WIDTH } {
	# Procedure called to validate C_M_AXI4_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_AWUSER_WIDTH { PARAM_VALUE.C_M_AXI4_AWUSER_WIDTH } {
	# Procedure called to update C_M_AXI4_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_AWUSER_WIDTH { PARAM_VALUE.C_M_AXI4_AWUSER_WIDTH } {
	# Procedure called to validate C_M_AXI4_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_ARUSER_WIDTH { PARAM_VALUE.C_M_AXI4_ARUSER_WIDTH } {
	# Procedure called to update C_M_AXI4_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_ARUSER_WIDTH { PARAM_VALUE.C_M_AXI4_ARUSER_WIDTH } {
	# Procedure called to validate C_M_AXI4_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_WUSER_WIDTH { PARAM_VALUE.C_M_AXI4_WUSER_WIDTH } {
	# Procedure called to update C_M_AXI4_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_WUSER_WIDTH { PARAM_VALUE.C_M_AXI4_WUSER_WIDTH } {
	# Procedure called to validate C_M_AXI4_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_RUSER_WIDTH { PARAM_VALUE.C_M_AXI4_RUSER_WIDTH } {
	# Procedure called to update C_M_AXI4_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_RUSER_WIDTH { PARAM_VALUE.C_M_AXI4_RUSER_WIDTH } {
	# Procedure called to validate C_M_AXI4_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_BUSER_WIDTH { PARAM_VALUE.C_M_AXI4_BUSER_WIDTH } {
	# Procedure called to update C_M_AXI4_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_BUSER_WIDTH { PARAM_VALUE.C_M_AXI4_BUSER_WIDTH } {
	# Procedure called to validate C_M_AXI4_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH { PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH } {
	# Procedure called to update C_S_AXI4_LITE_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH { PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI4_LITE_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH { PARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI4_LITE_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH { PARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI4_LITE_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_DATA_WIDTH { PARAM_VALUE.C_S_AXI4_DATA_WIDTH } {
	# Procedure called to update C_S_AXI4_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_DATA_WIDTH { PARAM_VALUE.C_S_AXI4_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI4_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_ADDR_WIDTH { PARAM_VALUE.C_S_AXI4_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI4_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_ADDR_WIDTH { PARAM_VALUE.C_S_AXI4_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI4_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_AWUSER_WIDTH { PARAM_VALUE.C_S_AXI4_AWUSER_WIDTH } {
	# Procedure called to update C_S_AXI4_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_AWUSER_WIDTH { PARAM_VALUE.C_S_AXI4_AWUSER_WIDTH } {
	# Procedure called to validate C_S_AXI4_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_ARUSER_WIDTH { PARAM_VALUE.C_S_AXI4_ARUSER_WIDTH } {
	# Procedure called to update C_S_AXI4_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_ARUSER_WIDTH { PARAM_VALUE.C_S_AXI4_ARUSER_WIDTH } {
	# Procedure called to validate C_S_AXI4_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_WUSER_WIDTH { PARAM_VALUE.C_S_AXI4_WUSER_WIDTH } {
	# Procedure called to update C_S_AXI4_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_WUSER_WIDTH { PARAM_VALUE.C_S_AXI4_WUSER_WIDTH } {
	# Procedure called to validate C_S_AXI4_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_RUSER_WIDTH { PARAM_VALUE.C_S_AXI4_RUSER_WIDTH } {
	# Procedure called to update C_S_AXI4_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_RUSER_WIDTH { PARAM_VALUE.C_S_AXI4_RUSER_WIDTH } {
	# Procedure called to validate C_S_AXI4_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_BUSER_WIDTH { PARAM_VALUE.C_S_AXI4_BUSER_WIDTH } {
	# Procedure called to update C_S_AXI4_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_BUSER_WIDTH { PARAM_VALUE.C_S_AXI4_BUSER_WIDTH } {
	# Procedure called to validate C_S_AXI4_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_BASEADDR { PARAM_VALUE.C_S_AXI4_BASEADDR } {
	# Procedure called to update C_S_AXI4_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_BASEADDR { PARAM_VALUE.C_S_AXI4_BASEADDR } {
	# Procedure called to validate C_S_AXI4_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI4_HIGHADDR { PARAM_VALUE.C_S_AXI4_HIGHADDR } {
	# Procedure called to update C_S_AXI4_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI4_HIGHADDR { PARAM_VALUE.C_S_AXI4_HIGHADDR } {
	# Procedure called to validate C_S_AXI4_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE { PARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE } {
	# Procedure called to update C_M_AXI4_LITE_START_DATA_VALUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE { PARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE } {
	# Procedure called to validate C_M_AXI4_LITE_START_DATA_VALUE
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to update C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to validate C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH { PARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH } {
	# Procedure called to update C_M_AXI4_LITE_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH { PARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH } {
	# Procedure called to validate C_M_AXI4_LITE_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH { PARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH } {
	# Procedure called to update C_M_AXI4_LITE_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH { PARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH } {
	# Procedure called to validate C_M_AXI4_LITE_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM { PARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM } {
	# Procedure called to update C_M_AXI4_LITE_TRANSACTIONS_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM { PARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM } {
	# Procedure called to validate C_M_AXI4_LITE_TRANSACTIONS_NUM
	return true
}


proc update_MODELPARAM_VALUE.C_AXI_MODE { MODELPARAM_VALUE.C_AXI_MODE PARAM_VALUE.C_AXI_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_MODE}] ${MODELPARAM_VALUE.C_AXI_MODE}
}

proc update_MODELPARAM_VALUE.C_WB_MODE { MODELPARAM_VALUE.C_WB_MODE PARAM_VALUE.C_WB_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_WB_MODE}] ${MODELPARAM_VALUE.C_WB_MODE}
}

proc update_MODELPARAM_VALUE.C_S_WB_ADR_WIDTH { MODELPARAM_VALUE.C_S_WB_ADR_WIDTH PARAM_VALUE.C_S_WB_ADR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_WB_ADR_WIDTH}] ${MODELPARAM_VALUE.C_S_WB_ADR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_WB_DAT_WIDTH { MODELPARAM_VALUE.C_S_WB_DAT_WIDTH PARAM_VALUE.C_S_WB_DAT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_WB_DAT_WIDTH}] ${MODELPARAM_VALUE.C_S_WB_DAT_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_WB_ADR_WIDTH { MODELPARAM_VALUE.C_M_WB_ADR_WIDTH PARAM_VALUE.C_M_WB_ADR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_WB_ADR_WIDTH}] ${MODELPARAM_VALUE.C_M_WB_ADR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_WB_DAT_WIDTH { MODELPARAM_VALUE.C_M_WB_DAT_WIDTH PARAM_VALUE.C_M_WB_DAT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_WB_DAT_WIDTH}] ${MODELPARAM_VALUE.C_M_WB_DAT_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_LITE_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH PARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_LITE_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_ID_WIDTH { MODELPARAM_VALUE.C_S_AXI4_ID_WIDTH PARAM_VALUE.C_S_AXI4_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_ID_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI4_DATA_WIDTH PARAM_VALUE.C_S_AXI4_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI4_ADDR_WIDTH PARAM_VALUE.C_S_AXI4_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_AWUSER_WIDTH { MODELPARAM_VALUE.C_S_AXI4_AWUSER_WIDTH PARAM_VALUE.C_S_AXI4_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_ARUSER_WIDTH { MODELPARAM_VALUE.C_S_AXI4_ARUSER_WIDTH PARAM_VALUE.C_S_AXI4_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_WUSER_WIDTH { MODELPARAM_VALUE.C_S_AXI4_WUSER_WIDTH PARAM_VALUE.C_S_AXI4_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_RUSER_WIDTH { MODELPARAM_VALUE.C_S_AXI4_RUSER_WIDTH PARAM_VALUE.C_S_AXI4_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI4_BUSER_WIDTH { MODELPARAM_VALUE.C_S_AXI4_BUSER_WIDTH PARAM_VALUE.C_S_AXI4_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI4_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI4_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE { MODELPARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE PARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE}] ${MODELPARAM_VALUE.C_M_AXI4_LITE_START_DATA_VALUE}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR { MODELPARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR PARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR}] ${MODELPARAM_VALUE.C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH PARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_LITE_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH PARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_LITE_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM { MODELPARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM PARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM}] ${MODELPARAM_VALUE.C_M_AXI4_LITE_TRANSACTIONS_NUM}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR { MODELPARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR PARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR}] ${MODELPARAM_VALUE.C_M_AXI4_TARGET_SLAVE_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_BURST_LEN { MODELPARAM_VALUE.C_M_AXI4_BURST_LEN PARAM_VALUE.C_M_AXI4_BURST_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_BURST_LEN}] ${MODELPARAM_VALUE.C_M_AXI4_BURST_LEN}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_ID_WIDTH { MODELPARAM_VALUE.C_M_AXI4_ID_WIDTH PARAM_VALUE.C_M_AXI4_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_ID_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI4_ADDR_WIDTH PARAM_VALUE.C_M_AXI4_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI4_DATA_WIDTH PARAM_VALUE.C_M_AXI4_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_AWUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI4_AWUSER_WIDTH PARAM_VALUE.C_M_AXI4_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_ARUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI4_ARUSER_WIDTH PARAM_VALUE.C_M_AXI4_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_WUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI4_WUSER_WIDTH PARAM_VALUE.C_M_AXI4_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_RUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI4_RUSER_WIDTH PARAM_VALUE.C_M_AXI4_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI4_BUSER_WIDTH { MODELPARAM_VALUE.C_M_AXI4_BUSER_WIDTH PARAM_VALUE.C_M_AXI4_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI4_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI4_BUSER_WIDTH}
}

