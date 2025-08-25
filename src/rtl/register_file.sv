module regfile(
    input clk,
    input RegWrite,
    input [4:0] read_reg_1,
    input [4:0] read_reg_2,
    input [4:0] write_register,
    input [31:0] write_data,
    output reg [31:0] read_data_1,
    output reg [31:0] read_data_2
);

    // 32 32-bit registers
    reg [31:0] x [31:0];

    // Initialize all registers to zero
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            x[i] = 32'b0;
        end
    end

    assign read_data_1 = x[read_reg_1];
    assign read_data_2 = x[read_reg_2];

    always @(posedge clk) begin
        if (RegWrite && write_register != 0) begin
            x[write_register] <= write_data;
        end
        
        // Register x0 is always zero
        x[0] <= 32'b0;
    end

endmodule
