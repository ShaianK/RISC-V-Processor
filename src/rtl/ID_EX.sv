module ID_EX (
    input         clk,
    input         rst,
    input         flush,
    
    // Control signals
    input         RegWrite_in,
    input         MemtoReg_in,
    input         MemRead_in,
    input         MemWrite_in,
    input         ALUSrc_in,
    input         Branch_in,
    input  [1:0]  ALUOp_in,
    
    // Data signals
    input  [31:0] pc_in,
    input  [31:0] reg_data1_in,
    input  [31:0] reg_data2_in,
    input  [31:0] imm_in,
    input  [4:0]  rs1_in,
    input  [4:0]  rs2_in,
    input  [4:0]  rd_in,
    input  [2:0]  funct3_in,
    input  [6:0]  funct7_in,
    
    // Outputs
    output reg        RegWrite_out,
    output reg        MemtoReg_out,
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg        ALUSrc_out,
    output reg        Branch_out,
    output reg [1:0]  ALUOp_out,
    output reg [31:0] pc_out,
    output reg [31:0] reg_data1_out,
    output reg [31:0] reg_data2_out,
    output reg [31:0] imm_out,
    output reg [4:0]  rs1_out,
    output reg [4:0]  rs2_out,
    output reg [4:0]  rd_out,
    output reg [2:0]  funct3_out,
    output reg [6:0]  funct7_out
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            RegWrite_out <= 0;
            MemtoReg_out <= 0;
            MemRead_out  <= 0;
            MemWrite_out <= 0;
            ALUSrc_out   <= 0;
            Branch_out   <= 0;
            ALUOp_out    <= 0;
            pc_out       <= 0;
            reg_data1_out<= 0;
            reg_data2_out<= 0;
            imm_out      <= 0;
            rs1_out      <= 0;
            rs2_out      <= 0;
            rd_out       <= 0;
            funct3_out   <= 0;
            funct7_out   <= 0;
        end 
        else begin
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemRead_out  <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            ALUSrc_out   <= ALUSrc_in;
            Branch_out   <= Branch_in;
            ALUOp_out    <= ALUOp_in;
            pc_out       <= pc_in;
            reg_data1_out<= reg_data1_in;
            reg_data2_out<= reg_data2_in;
            imm_out      <= imm_in;
            rs1_out      <= rs1_in;
            rs2_out      <= rs2_in;
            rd_out       <= rd_in;
            funct3_out   <= funct3_in;
            funct7_out   <= funct7_in;
        end
    end
    
endmodule
