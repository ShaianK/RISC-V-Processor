`timescale 1ns / 1ps

module register_file_tb;
    reg clk;
    reg RegWrite;
    reg [4:0] read_reg_1;
    reg [4:0] read_reg_2;
    reg [4:0] write_register;
    reg [31:0] write_data;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;

    regfile dut (
        .clk(clk),
        .RegWrite(RegWrite),
        .read_reg_1(read_reg_1),
        .read_reg_2(read_reg_2),
        .write_register(write_register),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars;
        $monitor($time, " | clk=%b RegWrite=%b write_reg=%0d write_data=0x%h read_reg_1=%0d read_data_1=0x%h read_reg_2=%0d read_data_2=0x%h",
            clk, RegWrite, write_register, write_data, read_reg_1, read_data_1, read_reg_2, read_data_2);

        // Initialize
        clk = 0;
        RegWrite = 0;
        read_reg_1 = 0;
        read_reg_2 = 0;
        write_register = 0;
        write_data = 0;
        #10;

        // Write to register x1
        RegWrite = 1;
        write_register = 5'd1;
        write_data = 32'hBEEFBEEF;
        @(posedge clk);
        #1;

        // Read from register x1
        read_reg_1 = 5'd1;
        #1;

        // Write to register x2
        write_register = 5'd2;
        write_data = 32'h12345678;
        @(posedge clk);
        #1;

        // Read from both registers simultaneously
        read_reg_1 = 5'd1;
        read_reg_2 = 5'd2;
        #1;

        // Try to write to register x0
        write_register = 5'd0;
        write_data = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        read_reg_1 = 5'd0;
        #1;

        $finish;
    end

endmodule
