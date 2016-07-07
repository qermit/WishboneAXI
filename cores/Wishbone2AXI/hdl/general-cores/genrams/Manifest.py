
files = [
	"genram_pkg.vhd",
	"memory_loader_pkg.vhd"];

if (target == "altera"):
	modules = {"local" : ["altera", "generic"]}
elif (target == "xilinx" and syn_device[0:4].upper()=="XC6V"):
	modules = {"local" : ["xilinx", "xilinx/virtex6"]}
elif (target == "xilinx" and syn_device[0:3].upper()=="XC7"):
	modules = {"local" : ["xilinx", "xilinx/series7"]}
elif (target == "xilinx"):
	modules = {"local" : ["xilinx", "generic"]}
