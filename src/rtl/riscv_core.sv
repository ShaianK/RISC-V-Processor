module riscv_core(
    input clk,
    input rst
);
    datapath DP(
        .clk(clk),
        .rst(rst)
    );
endmodule
