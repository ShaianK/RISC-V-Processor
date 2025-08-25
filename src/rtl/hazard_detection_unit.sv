module hazard_detection_unit(
    // ID stage
    input [4:0] if_id_rs1,
    input [4:0] if_id_rs2,
    
    // ID/EX stage
    input       id_ex_MemRead,
    input       id_ex_RegWrite,
    input [4:0] id_ex_rd,
    
    // EX/MEM stage
    input       ex_mem_RegWrite,
    input [4:0] ex_mem_rd,
    
    // Control outputs
    output reg  stall,      // Stall IF/ID stages
    output reg  nop         // Insert NOP in ID/EX stage
);

    // Load-use hazard detection
    always_comb begin
        // Stall when a load instruction in EX stage writes to a register
        // that the current instruction in ID stage wants to read
        if (id_ex_MemRead && 
            ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)) &&
            (id_ex_rd != 0)) begin
            stall = 1'b1;
            nop = 1'b1;
        end
        else begin
            stall = 1'b0;
            nop = 1'b0;
        end
    end

endmodule
