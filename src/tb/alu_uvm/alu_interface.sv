interface alu_interface();

    logic   [31:0]  data1, data2;
    logic   [3:0]   aluop;
    logic   [31:0]  alu_result;
    logic           zero_flag;
    
endinterface //alu_if