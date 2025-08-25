module EX_MEM (
    input         clk,
    input         rst,
    
    // Control signals
    input         RegWrite_in,
    input         MemtoReg_in,
    input         MemRead_in,
    input         MemWrite_in,
    
    // Data signals
    input  [31:0] alu_result_in,
    input  [31:0] reg_data2_in,
    input  [4:0]  rd_in,
    input         zero_in,
    
    // Outputs
    output reg        RegWrite_out,
    output reg        MemtoReg_out,
    output reg        MemRead_out,
    output reg        MemWrite_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] reg_data2_out,
    output reg [4:0]  rd_out,
    output reg        zero_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWrite_out   <= 0;
            MemtoReg_out   <= 0;
            MemRead_out    <= 0;
            MemWrite_out   <= 0;
            alu_result_out <= 0;
            reg_data2_out  <= 0;
            rd_out         <= 0;
            zero_out       <= 0;
        end 
        else begin
            RegWrite_out   <= RegWrite_in;
            MemtoReg_out   <= MemtoReg_in;
            MemRead_out    <= MemRead_in;
            MemWrite_out   <= MemWrite_in;
            alu_result_out <= alu_result_in;
            reg_data2_out  <= reg_data2_in;
            rd_out         <= rd_in;
            zero_out       <= zero_in;
        end
    end
    
endmodule
