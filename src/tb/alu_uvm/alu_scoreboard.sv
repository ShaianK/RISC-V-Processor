class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)

    uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) scoreboard_port;
    alu_sequence_item transactions[$];

    function new(string name="alu_scoreboard", uvm_component parent);
        super.new(name, parent);
        `uvm_info("SCOREBOARD_CLASS", "Constuctor Complete", UVM_HIGH);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SCOREBOARD_CLASS", "Build Phase", UVM_HIGH)

        scoreboard_port = new("scoreboard_port", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("SCOREBOARD_CLASS", "Connect Phase", UVM_HIGH)
    endfunction: connect_phase

    function void write(alu_sequence_item item);
        transactions.push_back(item);
    endfunction: write

    task compare(alu_sequence_item curr_trans);
        logic [31:0] expected;
        logic [31:0] actual;

        case(curr_trans.aluop)
            0: expected = curr_trans.data1 & curr_trans.data2;
            1: expected = curr_trans.data1 | curr_trans.data2;
            2: expected = curr_trans.data1 + curr_trans.data2;
            3: expected = curr_trans.data1 - curr_trans.data2;
        endcase

        actual = curr_trans.alu_result;

        if (actual != expected) begin
            `uvm_error("COMPARE", $sformatf("Transaction failed! ACT=%d, EXP=%d", actual, expected))
        end
        else begin
            `uvm_error("COMPARE", $sformatf("Transaction passed! ACT=%d, EXP=%d", actual, expected), UVM_LOW)
        end

    endtask: compare

    // Task since it can consume time
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("SCOREBOARD_CLASS", "Run Phase", UVM_HIGH)

        forever begin
            alu_sequence_item curr_trans;
            wait(transactions.size() != 0);
            curr_trans = transactions.pop_front();
            compare(curr_trans);
        end

    endtask: run_phase

endclass: alu_scoreboard