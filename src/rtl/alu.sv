module alu(
    input  logic    [31:0]  data1,
    input  logic    [31:0]  data2,
    input  logic    [3:0]   aluop,
    output logic    [31:0]  alu_result,
    output logic            zero
);

    localparam ALU_AND = 4'b0000;
    localparam ALU_OR  = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_SUB = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLL = 4'b0101;
    localparam ALU_SRL = 4'b0110;
    localparam ALU_SLT = 4'b0111;

    always_comb begin
        case (aluop)
            ALU_AND: alu_result = data1 & data2;
            ALU_OR:  alu_result = data1 | data2;
            ALU_ADD: alu_result = data1 + data2;
            ALU_SUB: alu_result = data1 - data2;
            ALU_XOR: alu_result = data1 ^ data2;
            ALU_SLL: alu_result = data1 << data2[4:0];
            ALU_SRL: alu_result = data1 >> data2[4:0];
            ALU_SLT: alu_result = ($signed(data1) < $signed(data2)) ? 32'h1 : 32'h0;
            default: alu_result = '0;
        endcase
    end

    assign zero = (alu_result == '0);

endmodule
