`timescale 1ns / 1ps

module riscv_cpu_tb;
    reg clk;
    reg rst;

    // Instantiate the RISC-V core
    riscv_core dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    wire branch_taken = dut.DP.id_ex_Branch & dut.DP.zero;
    wire pipeline_flush = branch_taken;
    
    // Register file monitoring
    wire [31:0] x0 = dut.DP.RF.x[0];
    wire [31:0] x1 = dut.DP.RF.x[1]; 
    wire [31:0] x2 = dut.DP.RF.x[2];
    wire [31:0] x3 = dut.DP.RF.x[3];
    wire [31:0] x4 = dut.DP.RF.x[4];
    wire [31:0] x5 = dut.DP.RF.x[5];
    wire [31:0] x6 = dut.DP.RF.x[6];
    wire [31:0] x7 = dut.DP.RF.x[7];
    
    // Memory monitoring
    wire [31:0] mem_00 = dut.DP.DMEM.memory[0]; 
    wire [31:0] mem_04 = dut.DP.DMEM.memory[1]; 
    wire [31:0] mem_08 = dut.DP.DMEM.memory[2]; 
    wire [31:0] mem_0C = dut.DP.DMEM.memory[3]; 
    wire [31:0] mem_10 = dut.DP.DMEM.memory[4]; 
    wire [31:0] mem_14 = dut.DP.DMEM.memory[5]; 
    wire [31:0] mem_18 = dut.DP.DMEM.memory[6]; 
    wire [31:0] mem_1C = dut.DP.DMEM.memory[7]; 

    initial begin
        $dumpfile("riscv_cpu_simulation.vcd");
        $dumpvars(0, riscv_cpu_tb);
        
        clk = 0;
        rst = 1;
        
        #10;
        rst = 0;
        
        // 18 clock cycles 
        #180;  
        
        //Register File Contents
        $display("\nRegister File Contents (first 8):");
        $display("========================================");
        $display("x0 = %08h  x1 = %08h  x2 = %08h  x3 = %08h", 
                 dut.DP.RF.x[0], dut.DP.RF.x[1], dut.DP.RF.x[2], dut.DP.RF.x[3]);
        $display("x4 = %08h  x5 = %08h  x6 = %08h  x7 = %08h", 
                 dut.DP.RF.x[4], dut.DP.RF.x[5], dut.DP.RF.x[6], dut.DP.RF.x[7]);
        
        // Display memory contents
        $display("\nMemory Contents (first 8):");
        $display("========================================");
        $display("Addr 00: %08h  Addr 04: %08h  Addr 08: %08h  Addr 12: %08h",
                 dut.DP.DMEM.memory[0], dut.DP.DMEM.memory[1], dut.DP.DMEM.memory[2], dut.DP.DMEM.memory[3]);
        $display("Addr 16: %08h  Addr 20: %08h  Addr 24: %08h  Addr 28: %08h",
                 dut.DP.DMEM.memory[4], dut.DP.DMEM.memory[5], dut.DP.DMEM.memory[6], dut.DP.DMEM.memory[7]);
        
        $display("\n========================================");
        $display("Testbench completed\n");
        
        $finish;
    end

    // Timer to prevent infinite simulation
    initial begin
        #10000; // 10us timeout
        $display("TIMEOUT: Simulation exceeded maximum time limit");
        $finish;
    end

endmodule
