module forwarding_unit (
    // ID/EX stage
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,
    
    // EX/MEM stage
    input       ex_mem_RegWrite,
    input [4:0] ex_mem_rd,
    
    // MEM/WB stage  
    input       mem_wb_RegWrite,
    input [4:0] mem_wb_rd,
    
    // Forwarding control 
    output reg [1:0] forwardA,  // Controls ALU input 1 forwarding
    output reg [1:0] forwardB   // Controls ALU input 2 forwarding
);

    // 2'b00: No forwarding
    // 2'b01: Forward from MEM/WB stage
    // 2'b10: Forward from EX/MEM stage (priority)
    always_comb begin
        // Forwarding for ALU input 1 (rs1)
        if (ex_mem_RegWrite && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs1)) begin
            forwardA = 2'b10; 
        end
        else if (mem_wb_RegWrite && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rs1)) begin
            forwardA = 2'b01;  
        end
        else begin
            forwardA = 2'b00;  
        end
        
        // Forwarding for ALU input 2 (rs2)
        if (ex_mem_RegWrite && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs2)) begin
            forwardB = 2'b10; 
        end
        else if (mem_wb_RegWrite && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rs2)) begin
            forwardB = 2'b01;
        end
        else begin
            forwardB = 2'b00; 
        end
    end

endmodule
