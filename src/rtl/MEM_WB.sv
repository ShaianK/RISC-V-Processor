module MEM_WB (
    input         clk,
    input         rst,
    
    // Control signals
    input         RegWrite_in,
    input         MemtoReg_in,
    
    // Data signals
    input  [31:0] mem_read_data_in,
    input  [31:0] alu_result_in,
    input  [4:0]  rd_in,
    
    // Outputs
    output reg        RegWrite_out,
    output reg        MemtoReg_out,
    output reg [31:0] mem_read_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0]  rd_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWrite_out     <= 0;
            MemtoReg_out     <= 0;
            mem_read_data_out<= 0;
            alu_result_out   <= 0;
            rd_out           <= 0;
        end 
        else begin
            RegWrite_out     <= RegWrite_in;
            MemtoReg_out     <= MemtoReg_in;
            mem_read_data_out<= mem_read_data_in;
            alu_result_out   <= alu_result_in;
            rd_out           <= rd_in;
        end
    end

endmodule
