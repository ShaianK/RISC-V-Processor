module data_mem(
    input               clk,                  
    input               MemWrite,             
    input               MemRead,              
    input       [31:0]  addr,          
    input       [31:0]  write_data,    
    output reg  [31:0]  read_data 
);

    reg [31:0] memory [0:255];

    // Initialize memory to zeros
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end

    always @(posedge clk) begin
        if (MemWrite) begin
            memory[addr[9:2]] <= write_data;
        end
    end

    always_comb begin
        if (MemRead) begin
            read_data = memory[addr[9:2]];
        end
        else begin
            read_data = 32'b0;
        end
    end

endmodule
