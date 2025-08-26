module control_unit(
    input      [6:0] opcode,
    output reg       Branch,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemtoReg,    
    output reg       RegWrite,
    output reg       ALUSrc,
    output reg [1:0] ALUOp
);

    always_comb begin
        case (opcode)
            7'b0110011: begin // R-Type
                Branch = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                RegWrite = 1;
                ALUSrc = 0;
                ALUOp = 2'b10;
            end
            7'b0010011: begin // I-Type (addi, slti, ..)
                Branch = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                RegWrite = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;
            end
            7'b0000011: begin // I-Type (lw)
                Branch = 0;
                MemRead = 1;
                MemWrite = 0;
                MemtoReg = 1;
                RegWrite = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;
            end
            7'b0100011: begin // S-Type (sw)
                Branch = 0;
                MemRead = 0;
                MemWrite = 1;
                MemtoReg = 0;
                RegWrite = 0;
                ALUSrc = 1;
                ALUOp = 2'b00;
            end
            7'b1100011: begin // B-Type (beq)
                Branch = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                RegWrite = 0;
                ALUSrc = 0;
                ALUOp = 2'b01;
            end
            7'b1101111: begin // J-Type (jal)
                Branch = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                RegWrite = 1;
                ALUSrc = 0;
                ALUOp = 2'b00;
            end
            7'b0110111: begin // U-Type (LUI)
                Branch = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                RegWrite = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;
            end
            default: begin
                Branch = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                RegWrite = 0;
                ALUSrc = 0;
                ALUOp = 2'b00;
            end
        endcase
    end

endmodule
