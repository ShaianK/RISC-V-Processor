`include "pc.sv"
`include "instruction_mem.sv"
`include "register_file.sv"
`include "imm_gen.sv"
`include "control_unit.sv"
`include "alu_control.sv"
`include "alu.sv"
`include "data_mem.sv"

module datapath(
    input clk,
    input rst
);
    // Program Counter wires
    wire [31:0] pc_out;               // Current PC value
    wire [31:0] pc_next;              // Next PC value
    wire branch;                      // Branch control signal

    // Instruction fetch wires
    wire [31:0] instruction;          // Current instruction

    // Register File wires
    wire [4:0] rs1, rs2, rd;          // Register specifiers
    wire [31:0] reg_data1, reg_data2; // Register read data
    wire RegWrite;                    // Register write enable

    // Immediate Generator wires
    wire [31:0] imm_out;              // Decoded immediate value

    // ALU wires
    wire [31:0] alu_in2, alu_result;  // ALU input and result
    wire [3:0] alu_control;           // ALU operation select
    wire zero;                        // ALU zero flag

    // Data Memory wires
    wire [31:0] mem_read_data;       // Data memory read data
    wire MemRead, MemWrite, MemtoReg;// Data memory control signals

    // Control Unit wires
    wire ALUSrc;                     // ALU source select
    wire [1:0] ALUOp;                // ALU operation type

    // PC: Handles program counter update and branching
    pc PC(
        .clk(clk),
        .rst(rst),
        .branch(branch & zero), // Take branch if branch instruction and ALU zero
        .pc_next(pc_out + imm_out), // Branch target
        .pc(pc_out)
    );

    // Instruction Memory: Fetches instruction at PC
    instruction_mem IMEM(
        .read_addr(pc_out),
        .instruction(instruction)
    );

    // Register File: Reads rs1, rs2 and writes rd
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];
    regfile RF(
        .clk(clk),
        .RegWrite(RegWrite),
        .read_reg_1(rs1),
        .read_reg_2(rs2),
        .write_register(rd),
        .write_data(MemtoReg ? mem_read_data : alu_result), // Write-back mux
        .read_data_1(reg_data1),
        .read_data_2(reg_data2)
    );

    // Immediate Generator: Decodes/sign extends immediate from instruction
    imm_gen IMMGEN(
        .instruction(instruction),
        .imm_out(imm_out)
    );

    // Control Unit: Decodes opcode to generate control signals
    control_unit CTRLU(
        .opcode(instruction[6:0]),
        .Branch(branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );

    // ALU Control: Decodes funct3 & funct7 and ALUOp to select ALU operation
    alu_control ALUCTRL(
        .funct7(instruction[31:25]),
        .funct3(instruction[14:12]),
        .aluop(ALUOp),
        .alu_control(alu_control)
    );

    // ALU: Performs arithmetic/logic operations
    assign alu_in2 = ALUSrc ? imm_out : reg_data2; // ALU input mux
    alu ALU(
        .data1(reg_data1),
        .data2(alu_in2),
        .aluop(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    // Data Memory: Loads/stores data
    data_mem DMEM(
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .addr(alu_result),
        .write_data(reg_data2),
        .read_data(mem_read_data)
    );

endmodule