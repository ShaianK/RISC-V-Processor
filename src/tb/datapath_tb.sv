`timescale 1ns / 1ps

module datapath_tb;
    reg clk;
    reg rst;

    datapath dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, dut);        
        clk = 0;
        rst = 1;
        
        $display("Time | clk | rst | Status");
        $display("%0t | %b | %b | Reset asserted", $time, clk, rst);
        
        // Hold reset for a few cycles
        #20;
        
        // Release reset and run for multiple cycles
        rst = 0;
        $display("%0t | %b | %b | Reset released - starting execution", $time, clk, rst);
        
        // Run for several clock cycles
        repeat(20) begin
            @(posedge clk);
            $display("%0t | %b | %b | Cycle %0d", $time, clk, rst, ($time-20)/10);
        end
        
        $finish;
    end
    
endmodule
