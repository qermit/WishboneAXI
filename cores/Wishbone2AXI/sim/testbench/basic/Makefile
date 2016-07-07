 
# vhdl files
SRC_FILES = ../../../hdl/*.vhd
SRC_FILES += ../../../hdl/general-cores/genrams/*.vhd
SRC_FILES += ../../../hdl/general-cores/genrams/xilinx/*.vhd
SRC_FILES += ../../../hdl/general-cores/genrams/generic/*.vhd
TB_FILES = *.vhd

# testbench
TESTBENCH = tb_basic

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys --warn-no-vital-generic -g

WORKDIR = ghdl_output
# Simulation break condition
GHDL_SIM_OPT = --stop-time=500ns

VIEWER = gtkwave

all: compile run view

compile :

	mkdir -p $(WORKDIR)
	$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=$(WORKDIR) --work=work $(SRC_FILES) $(TB_FILES)
	$(GHDL_CMD) -m  $(GHDL_FLAGS) --workdir=$(WORKDIR) --work=work $(TESTBENCH)

run :
	$(GHDL_CMD) -r $(TESTBENCH) $(GHDL_SIM_OPT) --vcdgz=$(TESTBENCH).vcdgz --wave=$(TESTBENCH).ghw

view :
	$(VIEWER) $(TESTBENCH).ghw

clean :
	$(GHDL_CMD) --clean --workdir=$(WORKDIR)
	rm *.o
	rm $(TESTBENCH).ghw
	rm $(TESTBENCH).vcdgz
