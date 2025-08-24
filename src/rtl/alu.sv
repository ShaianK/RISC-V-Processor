typedef enum logic [3:0] {
    ALU_AND  = 4'b0000,  // AND operation
    ALU_OR   = 4'b0001,  // OR operation  
    ALU_ADD  = 4'b0010,  // ADD operation
    ALU_SUB  = 4'b0011   // SUB operation
} alu_op_t;

module alu(
    input  logic    [31:0]  data1,
    input  logic    [31:0]  data2,
    input  alu_op_t         aluop,
    output logic    [31:0]  alu_result,
    output logic            zero
);

    always_comb begin
        case (aluop)
            ALU_AND: alu_result = data1 & data2;
            ALU_OR:  alu_result = data1 | data2;
            ALU_ADD: alu_result = data1 + data2;
            ALU_SUB: alu_result = data1 - data2;
            default: alu_result = '0;
        endcase
    end

    assign zero = (alu_result == '0);

endmodule
