`timescale 1ns / 1ps

module alu_control_tb;
    reg  [6:0] funct7;
    reg  [2:0] funct3;
    reg  [1:0] aluop;
    wire [3:0] alu_control;

    alu_control dut (
        .funct7(funct7),
        .funct3(funct3),
        .aluop(aluop),
        .alu_control(alu_control)
    );

    initial begin
        $dumpfile("alu_control_tb.vcd");
        $dumpvars(0, dut);
        
        // lw/sw (add)
        aluop = 2'b00; funct7 = 7'bxxxxxxx; funct3 = 3'bxxx; #10;
        $display("%0t | aluop=%b | funct7=%b | funct3=%b | alu_control=%b | ADD (lw/sw)", $time, aluop, funct7, funct3, alu_control);
        
        // beq (sub)
        aluop = 2'b01; funct7 = 7'bxxxxxxx; funct3 = 3'bxxx; #10;
        $display("%0t | aluop=%b | funct7=%b | funct3=%b | alu_control=%b | SUB (beq)", $time, aluop, funct7, funct3, alu_control);
        
        // R-type add
        aluop = 2'b10; funct7 = 7'b0000000; funct3 = 3'b000; #10;
        $display("%0t | aluop=%b | funct7=%b | funct3=%b | alu_control=%b | ADD (R-type)", $time, aluop, funct7, funct3, alu_control);
        
        // R-type sub
        aluop = 2'b10; funct7 = 7'b0100000; funct3 = 3'b000; #10;
        $display("%0t | aluop=%b | funct7=%b | funct3=%b | alu_control=%b | SUB (R-type)", $time, aluop, funct7, funct3, alu_control);
        
        // R-type and
        aluop = 2'b10; funct7 = 7'b0000000; funct3 = 3'b111; #10;
        $display("%0t | aluop=%b | funct7=%b | funct3=%b | alu_control=%b | AND (R-type)", $time, aluop, funct7, funct3, alu_control);
        
        // R-type or
        aluop = 2'b10; funct7 = 7'b0000000; funct3 = 3'b110; #10;
        $display("%0t | aluop=%b | funct7=%b | funct3=%b | alu_control=%b | OR (R-type)", $time, aluop, funct7, funct3, alu_control);
        
        $finish;
    end

endmodule
