class alu_monitor extends uvm_monitor;
    `uvm_component_utils(alu_monitor)
    
    virtual alu_interface vif;
    alu_sequence_item item;

    uvm_analysis_port #(alu_sequence_item) monitor_port;

    function new(string name="alu_monitor", uvm_component parent);
        super.new(name, parent);
        `uvm_info("MONITOR_CLASS", "Constructor Complete", UVM_HIGH)

    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MONITOR_CLASS", "Build Phase", UVM_HIGH)

        monitor_port = new("monitor_port", this);

        if (!(uvm_config_db#(virtual alu_interface)::get(this, "*", "vif", vif))) begin
            `uvm_error("MONITOR_CLASS", "Failed to get VIF from config db")
        end
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("MONITOR_CLASS", "Connect Phase", UVM_HIGH)
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("MONITOR_CLASS", "Run Phase", UVM_HIGH)

        forever begin
            // wait for any change on inputs
            @(vif.data1 or vif.data2 or vif.aluop);
            
            // give combinational logic time to settle
            #1; 
            
            item = alu_sequence_item::type_id::create("item");
            item.data1 = vif.data1;
            item.data2 = vif.data2;
            item.aluop = vif.aluop;
            item.alu_result = vif.alu_result;
            item.zero_flag = vif.zero_flag;

            `uvm_info("MONITOR_CLASS", $sformatf("Captured transaction: data1=%0h, data2=%0h, op=%0b, result=%0h, zero=%0b", 
                        item.data1, item.data2, item.aluop, item.alu_result, item.zero_flag), UVM_MEDIUM)
            
            monitor_port.write(item);
        end
    endtask: run_phase
endclass: alu_monitor