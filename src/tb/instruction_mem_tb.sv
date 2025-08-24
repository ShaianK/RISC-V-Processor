`timescale 1ns / 1ps

module instruction_mem_tb;
    reg [31:0] read_addr;
    wire [31:0] instruction;

    instruction_mem dut (
        .read_addr(read_addr),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("instruction_mem_tb.vcd");
        $dumpvars;
      	$monitor($time, " | read_addr=0x%h | instruction=0x%h", read_addr, instruction);

        // Reading from various memory addresses
        read_addr = 32'd0; 
        #10;
        read_addr = 32'd4; 
        #10;
        read_addr = 32'd8; 
        #10;
        read_addr = 32'd12; 
        #10;
        read_addr = 32'd16; 
        #10;
        read_addr = 32'd20; 
        #10;
      	read_addr = 32'd24; 
        #10;
      	read_addr = 32'd28;
        #10;

        // Unaligned address
        read_addr = 32'd2; 
        #10;

        // Test far address
        read_addr = 32'd1000; 
        #10;
        
        $finish;
    end

endmodule
