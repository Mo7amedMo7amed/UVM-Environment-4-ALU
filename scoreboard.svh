
/*#####################################################################################################################################
## Class name   : Scoreboard 
## Revision     : 
## Release note :   
/*#####################################################################################################################################*/

import project_pkg::*;
import alu_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  


`ifndef Scoreboard_exists
`define Scoreboard_exists
class Scoreboard extends uvm_component ;
	// Data Members
	Evaluator eval_h;
	Predictor predict_h;
	uvm_analysis_export #(Transaction) mon_ex1, mon_ex2;

	// Factory and Constractor
	`uvm_component_utils (Scoreboard)
	function new (string name = "Scoreboard", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	// Build phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		eval_h = Evaluator::type_id::create("eval_h",this);
		predict_h= Predictor::type_id::create("predict_h",this);
		mon_ex1 = new ("mon_ex1",this);
		mon_ex2 = new ("mon_ex2",this);
	endfunction : build_phase
	
	// Connect phase
	function void connect_phase (uvm_phase phase);
		predict_h.expected_ap.connect(eval_h.expected_ex);
		mon_ex1.connect (predict_h.analysis_export);
		mon_ex2.connect (eval_h.actual_ex);
	endfunction : connect_phase
endclass
`endif