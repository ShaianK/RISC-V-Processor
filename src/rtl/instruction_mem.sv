module instruction_mem(
    input [31:0] read_addr,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:255];

    // Initialize memory from file
    initial begin
        $readmemh("instructions.mem", memory);
    end

    always_comb begin
        instruction = memory[read_addr[9:2]]; // Byte address to word address
    end

endmodule
