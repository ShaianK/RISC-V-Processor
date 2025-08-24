`timescale 1ns / 1ps

module control_unit_tb();
    reg  [6:0]   opcode;
 
    wire         Branch;
    wire         MemRead;
    wire         MemWrite;
    wire         MemtoReg;
    wire         RegWrite;
    wire         ALUSrc;
    wire  [1:0]  ALUOp;

    control_unit dut(
        .opcode(opcode),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );

    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, dut);    

        opcode = 0;
        #10;

        $monitor($time, " | opcode=%b | Branch=%b | MemRead=%b | MemWrite=%b | MemtoReg=%b | RegWrite=%b | ALUSrc=%b | ALUOp=%b", 
                 opcode, Branch, MemRead, MemWrite, MemtoReg, RegWrite, ALUSrc, ALUOp);

        opcode = 7'b0110011;
        #10;

        opcode = 7'b0010011;
        #10;

        opcode = 7'b0000011;
        #10;

        opcode = 7'b0100011;
        #10;

        opcode = 7'b1100011;
        #10;

        opcode = 7'b1101111;
        #10;

        $finish;
    end

endmodule