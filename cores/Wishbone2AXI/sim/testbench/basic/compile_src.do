
if {[batch_mode]} {
  onerror {abort all; exit -f -code 1}
} else {
  onerror {abort all}
}
#Just in case...
quietly quit -sim   

# Set up uart_part_path and lib_name
#------------------------------------------------------
quietly set lib_name "work"
quietly set gencores_path "../../../hdl/general-cores/genrams"
quietly set src_path "../../../hdl/"

set compdirectives "-work $lib_name"

eval vcom  $compdirectives  $gencores_path/genram_pkg.vhd
eval vcom  $compdirectives  $gencores_path/memory_loader_pkg.vhd
eval vcom  $compdirectives  $gencores_path/xilinx/generic_dpram.vhd
eval vcom  $compdirectives  $gencores_path/xilinx/generic_dpram_sameclock.vhd
eval vcom  $compdirectives  $gencores_path/generic/inferred_sync_fifo.vhd
eval vcom  $compdirectives  $src_path/WishboneAXI_v0_1_M_AXI4.vhd
eval vcom  $compdirectives  $src_path/WishboneAXI_v0_1_M_AXI4_LITE.vhd
eval vcom  $compdirectives  $src_path/WishboneAXI_v0_1_S_AXI4.vhd
eval vcom  $compdirectives  $src_path/WishboneAXI_v0_1_S_AXI4_LITE.vhd
eval vcom  $compdirectives  $src_path/WishboneAXI_v0_1.vhd
eval vcom  $compdirectives  tb_basic.vhd
