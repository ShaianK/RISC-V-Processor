`timescale 1ns / 1ps

module riscv_cpu_tb;
    reg clk;
    reg rst;
    
    // Internal signals for monitoring (using hierarchical references)
    wire [31:0] pc_value;
    wire [31:0] instruction;
    wire [31:0] reg_data1, reg_data2;
    wire [31:0] alu_result;
    wire [31:0] mem_read_data;
    wire        zero_flag;
    wire [6:0]  opcode;
    wire [4:0]  rs1, rs2, rd;
    
    // Control signals
    wire Branch, MemRead, MemWrite, MemtoReg, RegWrite, ALUSrc;
    wire [1:0] ALUOp;

    // Instantiate the RISC-V core
    riscv_core dut (
        .clk(clk),
        .rst(rst)
    );

    // Connect internal signals for monitoring
    assign pc_value = dut.DP.pc_out;
    assign instruction = dut.DP.instruction;
    assign reg_data1 = dut.DP.reg_data1;
    assign reg_data2 = dut.DP.reg_data2;
    assign alu_result = dut.DP.alu_result;
    assign mem_read_data = dut.DP.mem_read_data;
    assign zero_flag = dut.DP.zero;
    assign opcode = instruction[6:0];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];
    assign Branch = dut.DP.branch;
    assign MemRead = dut.DP.MemRead;
    assign MemWrite = dut.DP.MemWrite;
    assign MemtoReg = dut.DP.MemtoReg;
    assign RegWrite = dut.DP.RegWrite;
    assign ALUSrc = dut.DP.ALUSrc;
    assign ALUOp = dut.DP.ALUOp;

    // Clock generation
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        $display("Time | PC   | Instruction | Opcode | rs1 | rs2 | rd  | RegData1 | RegData2 | ALUResult | MemData | Zero | Controls");
        $display("---------------------------------------------------------------------------------------------------------");
        
        // Initialize signals
        clk = 0;
        rst = 1;
        
        // Hold reset for 2 clock cycles
        #20;
        rst = 0;
        
        // Monitor the execution
        repeat (10) begin
            // Display state before clock edge (current instruction executing)
          $display("%4t | %04h | %08h  | %07b | %2d  | %2d  | %2d  | %08h | %08h | %08h | %08h | %1b    | B:%b MR:%b MW:%b MtR:%b RW:%b AS:%b AO:%2b",
                     $time, pc_value, instruction, opcode, rs1, rs2, rd, 
                     reg_data1, reg_data2, alu_result, mem_read_data, zero_flag,
                     Branch, MemRead, MemWrite, MemtoReg, RegWrite, ALUSrc, ALUOp);
            
            // Display instruction type
            case (opcode)
                7'b0110011: $display("         -> R-Type");
                7'b0010011: $display("         -> I-Type");
                7'b0000011: $display("         -> I-Type");
                7'b0100011: $display("         -> S-Type");
                7'b1100011: $display("         -> B-Type");
                7'b1101111: $display("         -> J-Type");
                default:    $display("         -> Unknown instruction type");
            endcase
            
            @(posedge clk);
            #1;
        end
        
        // Display register file contents
        $display("\Register File Contents (first 8):");
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

    // timer to prevent infinite simulation
    initial begin
        #10000; // 10us timeout
        $display("TIMEOUT: Simulation exceeded maximum time limit");
        $finish;
    end

endmodule
