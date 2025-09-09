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

    task test_alu_control(
        input [1:0] test_aluop,
        input [6:0] test_funct7,
        input [2:0] test_funct3,
        input string desc
    );
        begin
            aluop = test_aluop;
            funct7 = test_funct7;
            funct3 = test_funct3;
            #10;
            $display("%0t | aluop=%b | funct7=%b | funct3=%b | alu_control=%b | %s", 
                     $time, aluop, funct7, funct3, alu_control, desc);
        end
    endtask

    initial begin
        $dumpfile("alu_control_tb.vcd");
        $dumpvars(0, dut);
        
        test_alu_control(2'b00, 7'bxxxxxxx, 3'bxxx, "ADD (lw/sw)");
        test_alu_control(2'b01, 7'bxxxxxxx, 3'bxxx, "SUB (beq)");
        test_alu_control(2'b10, 7'b0000000, 3'b000, "ADD (R-type)");
        test_alu_control(2'b10, 7'b0100000, 3'b000, "SUB (R-type)");
        test_alu_control(2'b10, 7'b0000000, 3'b111, "AND (R-type)");
        test_alu_control(2'b10, 7'b0000000, 3'b110, "OR (R-type)");
        
        $finish;
    end

endmodule
