
/*#####################################################################################################################################
## Class name   : Evaluator 
## Revision     : 
## Release note :   
/*#####################################################################################################################################*/

import project_pkg::*;
import alu_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  

`ifndef Evaluator_exists
`define Evaluator_exists
class Evaluator extends uvm_component ;
	// Data Members
	Transaction expected_trn;
	Transaction actual_trn;
	
	// Factory reg and Constractor
	`uvm_component_utils(Evaluator)
	function new (string name = "Evaluator", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Ports
	uvm_analysis_export #(Transaction) expected_ex;  // Transactions come from the predictor
	uvm_analysis_export #(Transaction) actual_ex;   //  Transactions come from monitor
	uvm_tlm_analysis_fifo #(Transaction) expected_fifo;	// fifo to store the Transactions from predictor
	uvm_tlm_analysis_fifo #(Transaction) actual_fifo;	// fifo to store what is come from monitor for future use
	
	// Build Phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		expected_fifo = new ("expected_fifo",this);
		actual_fifo   = new ("actual_fifo",this);
		expected_ex   = new ("expected_ex",this);
		actual_ex     = new ("actual_ex",this);
	endfunction
	
	// Connect Phase
	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		expected_ex.connect (expected_fifo.export_port);
		actual_ex.connect (actual_fifo.export_port);
	endfunction
	
	// Run Phase
	virtual task run_phase(uvm_phase phase);
		forever begin
		expected_ex.get(expected_trn);
		actual_fifo.get(actual_trn);
		if (actual_trn.alu_out!== expected_trn.alu_out) begin
			`uvm_info ("EVAL_!EQUAL",{"The expected alu_out : %m",expected_trn.convert2string,"The actual alu_out :",actual_trn.convert2string},UVM_LOW)
		end
		if (actual_trn.alu_irq!== expected_trn.alu_irq) begin
			`uvm_info ("EVAL_!EQUAL",{"The expected alu_irq : %m",expected_trn.convert2string,"The actual alu_irq:",actual_trn.convert2string},UVM_LOW)
		end
		end
	endtask
	
endclass
`endif