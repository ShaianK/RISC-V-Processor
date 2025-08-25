module pc (
    input clk,
    input rst,
    input pc_enable,
    input branch,
    input [31:0] pc_next,
    output reg [31:0] pc
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'b0;    
        end
        else if (pc_enable) begin
            pc <= (branch) ? pc_next : pc + 4;
        end
    end
    
endmodule
