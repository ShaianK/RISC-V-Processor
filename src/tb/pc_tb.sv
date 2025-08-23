`timescale 1ns / 1ps

module pc_tb;
    reg clk;
    reg rst;
    reg branch;
    reg [31:0] pc_next;

    wire [31:0] pc;

    // Instantiate the Unit Under Test (UUT)
    pc uut (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Clock generation 10 ns
    always #5 clk = ~clk;

    initial begin
      	$dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);
      
        $monitor($time, " | clk=%b rst=%b branch=%b pc_next=0x%h pc=0x%h", clk, rst, branch, pc_next, pc);

        // Initialize inputs to zero
        clk = 0;
        rst = 0;
        branch = 0;
        pc_next = 32'h00000000;

        // Reset functionality
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;

        // Normal PC increment
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        // Branching 
        branch = 1;
        pc_next = 32'h00000020;
        @(posedge clk);
        #1;

        // Normal increments after branch
        branch = 0;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        $finish;
    end

endmodule
