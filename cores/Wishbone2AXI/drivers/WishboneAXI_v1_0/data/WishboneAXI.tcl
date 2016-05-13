

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "WishboneAXI" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXI4_LITE_BASEADDR" "C_S_AXI4_LITE_HIGHADDR" "C_S_AXI4_BASEADDR" "C_S_AXI4_HIGHADDR"
}
