class alu_base_sequence extends uvm_sequence;
    `uvm_object_utils(alu_base_sequence)

    alu_sequence_item item;

    function new(string name="alu_base_sequence");
        super.new(name);
        `uvm_info("BASE_SEQUENECE", "Constructor Complete", UVM_HIGH)
    endfunction: new

    task body();
        `uvm_info("BASE_SEQUENECE", "Body task", UVM_HIGH)

        repeat(100) begin
            item = alu_sequence_item::type_id::create("item");
            start_item(item);
            if(!item.randomize()) begin
                `uvm_error("BASE_SEQUENECE", "Randomization failed")
            end
            finish_item(item);
            `uvm_info("BASE_SEQUENECE", $sformatf("Generated transaction %0d", item.get_inst_id()), UVM_MEDIUM)
        end

    endtask: body

endclass: alu_base_sequence