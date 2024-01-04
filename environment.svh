/*#####################################################################################################################################
## Class name     : Environment
## Revision       : 
## Release note   :   
/*#####################################################################################################################################*/

import uvm_pkg::*;
`include "uvm_macros.svh"
import project_pkg::*;

`ifndef Environment_exists
`define Environment_exists
class Environment extends uvm_env;
	// Data members
	Agent agt_h;
	Scoreboard scr_h;
	
	// Factory and Constractor
	`uvm_component_utils (Environment)
	function new (string name = "Environment", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	// Build Phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		agt_h = Agent::type_id::create("agt_h",this);
		scr_h = Scoreboard::type_id::create("scr_h",this);
		configure_agt();
	endfunction : build_phase
	
	//Connect Phase
	function void connect_phase(uvm_phase phase);
		agt_h.agt_ap.connect(scr_h.agt_ex1);
		agt_h.agt_ap.connect(scr_h.agt_ex2);
	
	endfunction : connect_phase

  // Configure the agent to be active or passive
  virtual function void configure_agt ();
	agt_h.is_active = UVM_ACTIVE;
  endfunction : configure_agt
endclass
`endif