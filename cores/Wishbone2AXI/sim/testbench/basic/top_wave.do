onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_aclk
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_areset
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_adr
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_dat_w
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_cyc
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_stb
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_lock
add wave -noupdate -expand -group Wishbone -color {Violet Red} -radix binary /tb_basic/m_wb_sel
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_we
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_dat_r
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_stall
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_err
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_rty
add wave -noupdate -expand -group Wishbone -color {Violet Red} /tb_basic/m_wb_ack
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_aclk
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_aresetn
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_awaddr
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_awprot
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_awvalid
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_awready
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_wdata
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} -radix binary /tb_basic/s_axi4_lite_wstrb
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_wvalid
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_wready
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_bresp
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_bvalid
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_bready
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_araddr
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_arprot
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_arvalid
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_arready
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_rdata
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_rresp
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_rvalid
add wave -noupdate -expand -group AXILite -color {Medium Sea Green} /tb_basic/s_axi4_lite_rready
add wave -noupdate -color {Sky Blue} /tb_basic/uut/axilite2wb/WishboneAXI_v0_1_S_AXI4_LITE_inst/trans_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {390 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 283
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {800 ns}
