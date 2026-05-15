# Build & run:  make
# View waves:   make wave
# Clean files:  make clean

SIM = iverilog
VVP = vvp
SRC = alu.sv alu_tb.sv
OUT = alu.out

all: run

build:
	$(SIM) -g2012 -o $(OUT) $(SRC)

run: build
	$(VVP) $(OUT)

wave: run
	open -a gtkwave alu.vcd

clean:
	rm -f $(OUT) alu.vcd