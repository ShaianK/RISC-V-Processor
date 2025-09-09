`timescale 1ns / 1ps

module alu_tb;
    localparam ALU_AND = 4'b0000;
    localparam ALU_OR  = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_SUB = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLL = 4'b0101;
    localparam ALU_SRL = 4'b0110;
    localparam ALU_SLT = 4'b0111;

    logic [31:0] data1;
    logic [31:0] data2;
    logic [3:0]  aluop;

    logic [31:0] alu_result;
    logic zero;

    alu dut (
        .data1(data1),
        .data2(data2),
        .aluop(aluop),
        .alu_result(alu_result),
        .zero(zero)
    );

    task test_alu_operation(
        input [31:0] test_data1,
        input [31:0] test_data2,
        input [3:0]  test_aluop,
        input string operation_name
    );
        begin
            data1 = test_data1;
            data2 = test_data2;
            aluop = test_aluop;
            #10;
            $display("%0t | %s | data1=%h | data2=%h | aluop=%b | alu_result=%h | zero=%b",
                     $time, operation_name, data1, data2, aluop, alu_result, zero);
        end
    endtask

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, dut);
        
        test_alu_operation(32'h0000_0001, 32'h1111_0001, ALU_AND, "AND");
        test_alu_operation(32'h0000_0001, 32'h0000_0002, ALU_OR,  "OR");
        test_alu_operation(32'h0000_0001, 32'h0000_0002, ALU_ADD, "ADD");
        test_alu_operation(32'h0000_0003, 32'h0000_0003, ALU_SUB, "SUB");
        test_alu_operation(32'h0000_0005, 32'h0000_0002, ALU_SUB, "SUB");
        test_alu_operation(32'h0000_0002, 32'h0000_0005, ALU_SUB, "SUB");
        test_alu_operation(32'h0000_000F, 32'h0000_00F0, ALU_XOR, "XOR");
        test_alu_operation(32'h0000_0001, 32'h0000_0002, ALU_SLL, "SLL");
        test_alu_operation(32'h0000_0008, 32'h0000_0002, ALU_SRL, "SRL");
        test_alu_operation(32'h0000_0002, 32'h0000_0005, ALU_SLT, "SLT");
        test_alu_operation(32'h0000_0005, 32'h0000_0002, ALU_SLT, "SLT");
        test_alu_operation(32'h0000_0002, 32'h0000_0005, 4'b1111, "Invalid op code");
        
        $finish;
    end
endmodule