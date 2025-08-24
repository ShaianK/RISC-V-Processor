`timescale 1ns / 1ps

module alu_tb;
    logic [31:0] data1;
    logic [31:0] data2;
    alu_op_t aluop;

    logic [31:0] alu_result;
    logic zero;

    alu dut (
        .data1(data1),
        .data2(data2),
        .aluop(aluop),
        .alu_result(alu_result),
        .zero(zero)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, dut);
        
        $monitor($time, " | aluop=%b | data1=%h | data2=%h | alu_result=%h | zero=%b",
                  aluop, data1, data2, alu_result, zero);

        // AND
        data1 = 32'h0000_0001;
        data2 = 32'h1111_0001;
        aluop = ALU_AND;
        #10;

        // OR
        data1 = 32'h0000_0001;
        data2 = 32'h0000_0002;
        aluop = ALU_OR;
        #10;

        // ADD
        data1 = 32'h0000_0001;
        data2 = 32'h0000_0002;
        aluop = ALU_ADD;
        #10;

        // SUB (zero result)
        data1 = 32'h0000_0003;
        data2 = 32'h0000_0003;
        aluop = ALU_SUB;
        #10;

        // SUB (non-zero result)
        data1 = 32'h0000_0005;
        data2 = 32'h0000_0002;
        aluop = ALU_SUB;
        #10;

        // SUB (negative result)
        data1 = 32'h0000_0002;
        data2 = 32'h0000_0005;
        aluop = ALU_SUB;
        #10;

        // Invalid op code
        data1 = 32'h0000_0002;
        data2 = 32'h0000_0005;
        aluop = 4'b1111;
        #10;

        $finish;
    end
endmodule