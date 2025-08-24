`timescale 1ns / 1ps

module imm_gen_tb;

    // Inputs and Outputs
    reg [31:0] instruction;
    wire [31:0] imm_out;

    imm_gen dut (
        .instruction(instruction),
        .imm_out(imm_out)
    );

    initial begin
        $dumpfile("imm_gen_tb.vcd");
        $dumpvars(0, dut);

        // I-Type: addi x1, x0, -1 (imm = 0xFFF -> sign extended to 0xFFFFFFFF)
        instruction = 32'b111111111111_00000_000_00001_0010011; // opcode=0010011
        #10;
        $display("I-Type (ADDI): instruction=0x%h, imm_out=0x%h (expected: 0xFFFFFFFF)", instruction, imm_out);

        // I-Type: addi x1, x0, 5 (imm = 0x005 -> sign extended to 0x00000005)
        instruction = 32'b000000000101_00000_000_00001_0010011; // opcode=0010011
        #10;
        $display("I-Type (ADDI): instruction=0x%h, imm_out=0x%h (expected: 0x00000005)", instruction, imm_out);

        // S-Type: sw x2, -4(x3) (imm = 0xFFC -> sign extended to 0xFFFFFFFC)
        instruction = 32'b1111111_00010_00011_010_11100_0100011; // opcode=0100011
        #10;
        $display("S-Type (SW): instruction=0x%h, imm_out=0x%h (expected: 0xFFFFFFFC)", instruction, imm_out);

        // B-Type: beq x2, x1, -12 (imm = 0xFF4 -> sign extended to 0xFFFFFFF4)
        instruction = 32'b1111111_00010_00001_000_10101_1100011; // opcode=1100011
        #10;
        $display("B-Type (BEQ): instruction=0x%h, imm_out=0x%h (expected: 0xFFFFFFF4)", instruction, imm_out);

        // U-Type: lui x1, 0x12345 (imm = 0x12345000)
        instruction = 32'b00010010001101000101_00001_0110111; // opcode=0110111
        #10;
        $display("U-Type (LUI): instruction=0x%h, imm_out=0x%h (expected: 0x12345000)", instruction, imm_out);

        // J-Type: jal x1, 0x10 (imm = 0x10)
        instruction = 32'b00000000000100000000_00001_1101111; // opcode=1101111
        #10;
        $display("J-Type (JAL): instruction=0x%h, imm_out=0x%h (expected: 0x00000800)", instruction, imm_out);

        // Default/unknown type
        instruction = 32'h00000000;
        #10;
        $display("Unknown type: instruction=0x%h, imm_out=0x%h (expected: 0x00000000)", instruction, imm_out);

        $finish;
    end

endmodule
