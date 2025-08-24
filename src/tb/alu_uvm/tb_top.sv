`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

// cant i package these
`include "alu_interface.sv"
`include "alu_sequence_item.sv"
`include "alu_sequence.sv"
`include "alu_sequencer.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "alu_agent.sv"
`include "alu_scoreboard.sv"
`include "alu_env.sv"
`include "alu_test.sv"

module tb_top();

    alu_interface intf();

    alu dut(
        .data1(intf.data1),
        .data2(intf.data2),
        .aluop(intf.aluop),
        .alu_result(intf.alu_result),
        .zero(intf.zero_flag)
    );

    initial begin
        uvm_config_db #(virtual alu_interface)::set(null, "*", "vif", intf);
    end

    initial begin
        run_test("alu_test");
    end

    initial begin
        $dumpfile("alu_uvm.vcd");
        $dumpvars();
    end

endmodule: tb_top