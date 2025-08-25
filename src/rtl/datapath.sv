module datapath (
    input clk,
    input rst
);

    // IF/ID pipeline register wires
    wire [31:0] if_id_pc, if_id_instruction;

    // ID/EX pipeline register wires
    wire id_ex_RegWrite, id_ex_MemtoReg, id_ex_MemRead, id_ex_MemWrite, id_ex_ALUSrc, id_ex_Branch;
    wire [1:0] id_ex_ALUOp;
    wire [31:0] id_ex_pc, id_ex_reg_data1, id_ex_reg_data2, id_ex_imm;
    wire [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;
    wire [2:0] id_ex_funct3;
    wire [6:0] id_ex_funct7;

    // EX/MEM pipeline register wires
    wire ex_mem_RegWrite, ex_mem_MemtoReg, ex_mem_MemRead, ex_mem_MemWrite;
    wire [31:0] ex_mem_alu_result, ex_mem_reg_data2;
    wire [4:0] ex_mem_rd;
    wire ex_mem_zero;

    // MEM/WB pipeline register wires
    wire mem_wb_RegWrite, mem_wb_MemtoReg;
    wire [31:0] mem_wb_mem_read_data, mem_wb_alu_result;
    wire [4:0] mem_wb_rd;

    wire [31:0] pc_out;
    wire pc_enable;
    wire branch, id_ex_branch;
    wire [31:0] instruction;

    // Instruction decode
    wire [4:0] rs1, rs2, rd;
    wire [31:0] reg_data1, reg_data2;
    wire RegWrite, MemtoReg, MemRead, MemWrite, ALUSrc;
    
    // ALU
    wire [1:0] ALUOp;
    wire [31:0] imm_out;
    wire [3:0] alu_control;
    wire [31:0] alu_in2, alu_result;
    wire zero;

    // Reg file
    wire [31:0] rf_read_data1, rf_read_data2;
    
    // Memory
    wire [31:0] mem_read_data;

    // Forwarding Unit
    wire [1:0] forwardA, forwardB;
    wire [31:0] alu_data1, alu_data2_pre, store_data;
    
    // Hazard Detection Unit
    wire stall, nop;
    
    forwarding_unit FWU(
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .ex_mem_RegWrite(ex_mem_RegWrite),
        .ex_mem_rd(ex_mem_rd),
        .mem_wb_RegWrite(mem_wb_RegWrite),
        .mem_wb_rd(mem_wb_rd),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    
    hazard_detection_unit HDU(
        .if_id_rs1(rs1),
        .if_id_rs2(rs2),
        .id_ex_MemRead(id_ex_MemRead),
        .id_ex_RegWrite(id_ex_RegWrite),
        .id_ex_rd(id_ex_rd),
        .ex_mem_RegWrite(ex_mem_RegWrite),
        .ex_mem_rd(ex_mem_rd),
        .stall(stall),
        .nop(nop)
    );

    // ALU input multiplexers with forwarding
    assign alu_data1 = (forwardA == 2'b10) ? ex_mem_alu_result :                                            // Forward from EX/MEM
                       (forwardA == 2'b01) ? (mem_wb_MemtoReg ? mem_wb_mem_read_data : mem_wb_alu_result) : // Forward from MEM/WB
                       id_ex_reg_data1;                                                                     // No forwarding
                       
    assign alu_data2_pre = (forwardB == 2'b10) ? ex_mem_alu_result :                                            // Forward from EX/MEM
                           (forwardB == 2'b01) ? (mem_wb_MemtoReg ? mem_wb_mem_read_data : mem_wb_alu_result) : // Forward from MEM/WB
                           id_ex_reg_data2;                                                                     // No forwarding
                           
    // Store data forwarding (same logic as ALU input 2)
    assign store_data = (forwardB == 2'b10) ? ex_mem_alu_result :                                            // Forward from EX/MEM
                        (forwardB == 2'b01) ? (mem_wb_MemtoReg ? mem_wb_mem_read_data : mem_wb_alu_result) : // Forward from MEM/WB
                        id_ex_reg_data2;                                                                     // No forwarding

    // IF stage
    assign pc_enable = ~stall;
    pc PC(
        .clk(clk),
        .rst(rst),
        .pc_enable(pc_enable),
        .branch(id_ex_Branch & zero),
        .pc_next(id_ex_pc + id_ex_imm),
        .pc(pc_out)
    );
    instruction_mem IMEM(
        .read_addr(pc_out),
        .instruction(instruction)
    );

    // IF/ID pipeline register
    IF_ID if_id_reg(
        .clk(clk),
        .rst(rst),
        .flush(id_ex_Branch & zero),
        .stall(stall),
        .pc_in(pc_out),
        .instruction_in(instruction),
        .pc_out(if_id_pc),
        .instruction_out(if_id_instruction)
    );

    // ID stage
    assign rs1 = if_id_instruction[19:15];
    assign rs2 = if_id_instruction[24:20];
    assign rd  = if_id_instruction[11:7];    
    regfile RF(
        .clk(clk),
        .RegWrite(mem_wb_RegWrite),
        .read_reg_1(rs1),
        .read_reg_2(rs2),
        .write_register(mem_wb_rd),
        .write_data(mem_wb_MemtoReg ? mem_wb_mem_read_data : mem_wb_alu_result),
        .read_data_1(rf_read_data1),
        .read_data_2(rf_read_data2)
    );
    
    // Forward from MEM/WB stage if needed
    assign reg_data1 = (mem_wb_RegWrite && (mem_wb_rd == rs1) && (mem_wb_rd != 0)) ?
                       (mem_wb_MemtoReg ? mem_wb_mem_read_data : mem_wb_alu_result) :
                       rf_read_data1;
                       
    assign reg_data2 = (mem_wb_RegWrite && (mem_wb_rd == rs2) && (mem_wb_rd != 0)) ?
                       (mem_wb_MemtoReg ? mem_wb_mem_read_data : mem_wb_alu_result) :
                       rf_read_data2;
    imm_gen IMMGEN(
        .instruction(if_id_instruction),
        .imm_out(imm_out)
    );
    control_unit CTRLU(
        .opcode(if_id_instruction[6:0]),
        .Branch(branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );

    // ID/EX pipeline register
    ID_EX id_ex_reg(
        .clk(clk),
        .rst(rst),
        .flush(id_ex_Branch & zero),
        .nop(nop),
        .RegWrite_in(RegWrite),
        .MemtoReg_in(MemtoReg),
        .MemRead_in(MemRead),
        .MemWrite_in(MemWrite),
        .ALUSrc_in(ALUSrc),
        .Branch_in(branch),
        .ALUOp_in(ALUOp),
        .pc_in(if_id_pc),
        .reg_data1_in(reg_data1),
        .reg_data2_in(reg_data2),
        .imm_in(imm_out),
        .rs1_in(rs1),
        .rs2_in(rs2),
        .rd_in(rd),
        .funct3_in(if_id_instruction[14:12]),
        .funct7_in(if_id_instruction[31:25]),
        .RegWrite_out(id_ex_RegWrite),
        .MemtoReg_out(id_ex_MemtoReg),
        .MemRead_out(id_ex_MemRead),
        .MemWrite_out(id_ex_MemWrite),
        .ALUSrc_out(id_ex_ALUSrc),
        .Branch_out(id_ex_Branch),
        .ALUOp_out(id_ex_ALUOp),
        .pc_out(id_ex_pc),
        .reg_data1_out(id_ex_reg_data1),
        .reg_data2_out(id_ex_reg_data2),
        .imm_out(id_ex_imm),
        .rs1_out(id_ex_rs1),
        .rs2_out(id_ex_rs2),
        .rd_out(id_ex_rd),
        .funct3_out(id_ex_funct3),
        .funct7_out(id_ex_funct7)
    );

    // EX stage
    alu_control ALUCTRL(
        .funct7(id_ex_funct7),
        .funct3(id_ex_funct3),
        .aluop(id_ex_ALUOp),
        .alu_control(alu_control)
    );
    assign alu_in2 = id_ex_ALUSrc ? id_ex_imm : alu_data2_pre;
    alu ALU(
        .data1(alu_data1),
        .data2(alu_in2),
        .aluop(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    // EX/MEM pipeline register
    EX_MEM ex_mem_reg(
        .clk(clk),
        .rst(rst),
        .RegWrite_in(id_ex_RegWrite),
        .MemtoReg_in(id_ex_MemtoReg),
        .MemRead_in(id_ex_MemRead),
        .MemWrite_in(id_ex_MemWrite),
        .alu_result_in(alu_result),
        .reg_data2_in(store_data),
        .rd_in(id_ex_rd),
        .zero_in(zero),
        .RegWrite_out(ex_mem_RegWrite),
        .MemtoReg_out(ex_mem_MemtoReg),
        .MemRead_out(ex_mem_MemRead),
        .MemWrite_out(ex_mem_MemWrite),
        .alu_result_out(ex_mem_alu_result),
        .reg_data2_out(ex_mem_reg_data2),
        .rd_out(ex_mem_rd),
        .zero_out(ex_mem_zero)
    );

    // MEM stage
    data_mem DMEM(
        .clk(clk),
        .MemWrite(ex_mem_MemWrite),
        .MemRead(ex_mem_MemRead),
        .addr(ex_mem_alu_result),
        .write_data(ex_mem_reg_data2),
        .read_data(mem_read_data)
    );

    // MEM/WB pipeline register
    MEM_WB mem_wb_reg(
        .clk(clk),
        .rst(rst),
        .RegWrite_in(ex_mem_RegWrite),
        .MemtoReg_in(ex_mem_MemtoReg),
        .mem_read_data_in(mem_read_data),
        .alu_result_in(ex_mem_alu_result),
        .rd_in(ex_mem_rd),
        .RegWrite_out(mem_wb_RegWrite),
        .MemtoReg_out(mem_wb_MemtoReg),
        .mem_read_data_out(mem_wb_mem_read_data),
        .alu_result_out(mem_wb_alu_result),
        .rd_out(mem_wb_rd)
    );

endmodule