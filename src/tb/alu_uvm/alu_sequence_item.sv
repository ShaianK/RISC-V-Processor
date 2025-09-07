class alu_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(alu_sequence_item)

    rand logic   [31:0]  data1, data2;
    rand logic   [3:0]   aluop;
    
    logic   [31:0]  alu_result;
    logic           zero_flag;

    constraint data_c { data1 >= data2; }
  	
  	constraint shift_amt_c {
        if (aluop inside {5, 6}) data2 inside {[0:31]};
    }
  
    constraint op_code_c { aluop inside {0, 1, 2, 3, 4, 5, 6, 7}; }

    function new(string name="alu_sequence_item");
        super.new(name);
    endfunction: new

endclass: alu_sequence_item