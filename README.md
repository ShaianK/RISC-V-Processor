# RISC-V Processor

A pipelined RV32I processor core implementation using SystemVerilog.

## Features

- 5-Stage Pipeline
- Hazard resolution with forwarding, flushing, and stalls
- Verification with Verilog and UVM testbenches

## Microarchitecture Overview

### Pipeline Stages

1. Instruction Fetch (IF): Program counter and instruction memory
2. Instruction Decode (ID): Register file, control signals, immediate generation
3. Execute (EX): ALU operations and branch condition checking
4. Memory (MEM): Data memory access for load/store operations
5. Write Back (WB): Write back to register file

[Previous single cycle version implementation here](https://github.com/ShaianK/RISC-V-Processor/tree/8cc6bf10ed3c5bf0bb8a2dd70b26f5094c24616c)

### Hazard Resolution

- **Data Hazards**: Forwarding unit with EX stage bypass paths and external ID stage forwarding for register dependencies
- **Load-Use Hazards**: Hazard detection unit triggers pipeline stalls when forwarding cannot resolve dependencies
- **Control Hazards**: Pipeline flushing on branch

## Supported Instructions

### R-Type Instructions  
- `add` - Addition
- `sub` - Subtraction
- `and` - Bitwise AND
- `or` - Bitwise OR
- `sll` - Shift Left Logical
- `srl` - Shift Right Logical

### I-Type Instructions
- `addi` - Add immediate
- `andi` - AND immediate
- `ori` - OR immediate
- `xori` - XOR immediate
- `slli` - Shift Left Logical Immediate
- `srli` - Shift Right Logical Immediate
- `slti` - Set Less Than Immediate
- `lw` - Load word

### B-Type Instructions
- `beq` - Branch if equal

### S-Type Instructions
- `sw` - Store word

### U-Type Instructions
- `lui` - Load upper immediate

## Verification

- Verilog Testbenches: 
    - Individual module testing
    - Full CPU testing
- UVM Testbench for ALU verification 
- Simulations were through AMD Vivado and Synopsis VCS (EDA Playground). Earlier in the project I used Icarus Verilog and GTKWave.

## Simulation Examples

The processor successfully executes the following programs

```assembly
addi x2, x0, 5
addi x3, x0, 10
add x5, x3, x2
sub x6, x5, x2
andi x4, x5, 15
beq x5, x5, 8 
addi x2, x0, 20 <--- skip
add x2, x5, x2 
sw x5, 0(x0)   
lw x7, 0(x0)
```

![Screenshot of Waveform](https://files.catbox.moe/hidi1o.png)

```assembly
addi x2, x0, 5
lw x3, 0(x2)
add x3, x3, x1
add x4, x3, x3
```

![Screenshot of Waveform](https://files.catbox.moe/lvyevl.png)

## Todo

- Implement remaining instructions
- Branch prediction to avoid flushing/stalling the pipeline

## Resources

- [RISC-V ISA Specification](https://drive.google.com/file/d/1s0lZxUZaa7eV_O0_WsZzaurFLLww7ou5/view)
- Computer Organization and Design RISC-V Edition by David A Patterson and John L. Hennessy
- [RISC-V Instruction Encoder/Decoder](https://luplab.gitlab.io/rvcodecjs)
