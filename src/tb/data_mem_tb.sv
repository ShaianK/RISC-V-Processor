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

    task write_memory(
        input [31:0] write_addr,
        input [31:0] data_to_write,
        input string description
    );
        begin
            $display("%s", description);
            addr = write_addr;
            write_data = data_to_write;
            MemWrite = 1;
            @(posedge clk);
            #1;
            MemWrite = 0;
            $display("  Written 0x%h to address %0d", data_to_write, write_addr);
        end
    endtask

    task read_memory(
        input [31:0] read_addr,
        input [31:0] expected_data,
        input string test_description
    );
        begin
            $display("%s", test_description);
            addr = read_addr;
            MemRead = 1;
            #1;
            $display("  read_data=0x%h (expected=0x%h) at address %0d", read_data, expected_data, read_addr);
            MemRead = 0;
        end
    endtask

    initial begin
        $dumpfile("data_mem_tb.vcd");
        $dumpvars(0, dut);

        clk = 0;
        MemWrite = 0;
        MemRead = 0;
        addr = 32'd0;
        write_data = 32'd0;
        #10;

        write_memory(32'd4, 32'h1234ABCD, "Test 1: Writing 0x1234ABCD to address 4");
        read_memory(32'd4, 32'h1234ABCD, "Test 2: Reading from address 4");
        
        write_memory(32'd8, 32'hBEEFBEEF, "Test 3: Writing 0xBEEFBEEF to address 8");
        read_memory(32'd8, 32'hBEEFBEEF, "Test 4: Reading from address 8");
        
        read_memory(32'd4, 32'h1234ABCD, "Test 5: Reading from address 4 again");

        $finish;
    end

endmodule
