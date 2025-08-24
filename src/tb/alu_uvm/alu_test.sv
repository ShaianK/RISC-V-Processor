class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)

    alu_env env;
    alu_base_sequence base_sequence;

    function new(string name="alu_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("TEST_CLASS", "Constuctor Complete", UVM_HIGH);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST_CLASS", "Build Phase", UVM_HIGH)

        env = alu_env::type_id::create("env", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("TEST_CLASS", "Connect Phase", UVM_HIGH)
    endfunction: connect_phase

    // Task since it can consume time
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("TEST_CLASS", "Run Phase", UVM_HIGH)

        phase.raise_objection(this);

        // Start sequence
        base_sequence = alu_base_sequence::type_id::create("base_sequence");
        base_sequence.start(env.agnt.sequencer);

        phase.drop_objection(this);

    endtask: run_phase

endclass: alu_test