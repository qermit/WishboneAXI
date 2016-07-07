# WishboneAXI 
This project is a universal, configurable Wishbone<=>AXI bridge together with Xilinx IP wrapper,
which makes it suitable for Block Design projects.
WishboneAXI tries to stay compliant to AXI4 and Wishbone B4 specifications, but is provided "as is",
with no guarantee of fitness for particular purpose.

Both AXI and WB interfaces have to use the same clock and data width.
If you want to do clock or DWIDTH conversion, please use dedicated CDC/DWIDTH circuits for
AXI or WB interfaces.

In final version bridge should support all conversion modes.
Current version supports following conversions:
AXI4 Lite -> Wishbone (classic, pipelined TBD)

Each conversion mode should have a suitable testbench, which would verify specs requirements.
