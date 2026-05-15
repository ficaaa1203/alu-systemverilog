# 8-bit ALU in SystemVerilog

An 8-bit Arithmetic Logic Unit implemented in SystemVerilog, supporting 9 operations with Zero, Negative, and Signed Overflow status flags.

## Operations

| op code | function       |
|---------|----------------|
| `0000`  | ADD            |
| `0001`  | SUB            |
| `0010`  | MUL            |
| `0011`  | DIV            |
| `0100`  | AND            |
| `0101`  | OR             |
| `0110`  | XOR            |
| `0111`  | Left Shift     |
| `1000`  | Right Shift    |

## Interface

- **Inputs:** `A[7:0]`, `B[7:0]`, `op[3:0]`
- **Outputs:** `result[7:0]`, `Z`, `N`, `V`

### Flags
- **Z** — Zero: set when `result == 0`
- **N** — Negative: set when `result[7] == 1` (signed MSB)
- **V** — Overflow: set on signed arithmetic overflow (ADD, SUB, MUL)

## Build & Run

Requires [Icarus Verilog](http://iverilog.icarus.com/).

```bash
make          # compile and run testbench
make wave     # open waveform in GTKWave
make clean    # remove build artifacts
```

## Files

- `alu.sv` — ALU module
- `alu_tb.sv` — Testbench with 14 test cases
- `Makefile` — build automation

## Author

Andrei — Computer Engineering, UPT