module alu_control (
    input       [6:0] funct7,
    input       [2:0] funct3,
    input       [1:0] aluop, 
    output reg  [3:0] alu_control 
);

    always_comb begin
        case (aluop)
            2'b00: alu_control = 4'b0010; // ADD (for lw/sw)
            2'b01: alu_control = 4'b0110; // SUB (for beq)
            2'b10: begin // R-type
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_control = 4'b0010; // ADD
                    {7'b0100000, 3'b000}: alu_control = 4'b0110; // SUB
                    {7'b0000000, 3'b111}: alu_control = 4'b0000; // AND
                    {7'b0000000, 3'b110}: alu_control = 4'b0001; // OR
                    default: alu_control = 4'b1111; // Invalid
                endcase
            end
            default: alu_control = 4'b1111;
        endcase
    end

endmodule
