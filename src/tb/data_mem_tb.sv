`timescale 1ns / 1ps

module data_mem_tb;
    reg           clk;
    reg           MemWrite;
    reg           MemRead;
    reg   [31:0]  addr;
    reg   [31:0]  write_data;
    wire  [31:0]  read_data;

    data_mem dut (
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("data_mem_tb.vcd");
        $dumpvars(0, dut);

        clk = 0;
        MemWrite = 0;
        MemRead = 0;
        addr = 32'd0;
        write_data = 32'd0;
        #10;

        $display("Test 1: Writing 0x1234ABCD to address 4");
        addr = 32'd4;
        write_data = 32'h1234ABCD;
        MemWrite = 1;
        @(posedge clk);
        #1;
        MemWrite = 0;

        $display("Test 2: Reading from address 4");
        MemRead = 1;
        #1;
        $display("read_data=0x%h (expected=0x1234ABCD)", read_data);
        MemRead = 0;

        $display("Test 3: Writing 0xDEADBEEF to address 8");
        addr = 32'd8;
        write_data = 32'hBEEFBEEF;
        MemWrite = 1;
        @(posedge clk);
        #1;
        MemWrite = 0;

        $display("Test 4: Reading from address 8");
        MemRead = 1;
        #1;
        $display("read_data=0x%h (expected=0xBEEFBEEF)", read_data);
        MemRead = 0;

        $display("Test 5: Reading from address 4 again");
        addr = 32'd4;
        MemRead = 1;
        #1;
        $display("read_data=0x%h (expected=0x1234ABCD)", read_data);
        MemRead = 0;

        $finish;
    end

endmodule
