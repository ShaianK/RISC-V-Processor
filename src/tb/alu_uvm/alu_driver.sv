class alu_driver extends uvm_driver#(alu_sequence_item);
    `uvm_component_utils(alu_driver)

    virtual alu_interface vif;
    alu_sequence_item item;

    function new(string name="alu_driver", uvm_component parent);
        super.new(name, parent);
        `uvm_info("DRIVER_CLASS", "Constructor Complete", UVM_HIGH)
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("DRIVER_CLASS", "Build Phase", UVM_HIGH)

      if (!(uvm_config_db#(virtual alu_interface)::get(this, "*", "vif", vif))) begin
            `uvm_error("DRIVER_CLASS", "Failed to get VIF from config db")
        end
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("DRIVER_CLASS", "Connect Phase", UVM_HIGH)
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("DRIVER_CLASS", "Run Phase", UVM_HIGH)

        forever begin
            item = alu_sequence_item::type_id::create("item");
            seq_item_port.get_next_item(item);
            drive(item);
            seq_item_port.item_done();
        end

    endtask: run_phase

    task drive(alu_sequence_item item);
        vif.data1 <= item.data1;
        vif.data2 <= item.data2;
        vif.aluop <= item.aluop;
        
        // wait for combinational logic to settle
        #1;
        
        // add delay to so monitor can detect changes
        #1;
        
        `uvm_info("DRIVER_CLASS", $sformatf("Drove transaction: data1=%0h, data2=%0h, op=%0b", 
                 item.data1, item.data2, item.aluop), UVM_MEDIUM)
    endtask: drive
endclass: alu_driver