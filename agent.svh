/*#####################################################################################################################################
## Class name     : Agent
## Revision       : 
## Release note   :   
/*#####################################################################################################################################*/

//import uvm_pkg::*;
//`include "uvm_macros.svh"
import project_pkg::*;

`ifndef Agent_exists
`define Agent_exists
class Agent extends uvm_agent ;
  // Data members
  Driver drv_h;
  Sequencer sqr_h;
  Monitor mon_h;
  //Trn_Config  trn_config;
  uvm_analysis_port #(Transaction) agt_ap; // analysis port to communicate agent with coverage collector and scoreboard ... defer then monitor ap  

  // Factroy reg and constractor
  `uvm_component_utils(Agent)
  function new (string name = "Agent", uvm_component parent = null);
	super.new (name,parent);
  endfunction
 
  // Build phase 
  virtual function void build_phase (uvm_phase phase);
	super.build_phase (phase);
	//if (uvm_config_db#(Trn_Config)::get (this,"","trn_config",trn_config)) `uvm_error ("AGT_BUILD",{get_full_name,"Config to agent"}); 
	if (get_is_active() == UVM_ACTIVE)begin
	  drv_h = Driver::type_id :: create ("Driver",this);
	  sqr_h = Sequencer::type_id:: create("Sequencer",this); 
	end
	mon_h = Monitor::type_id::create("Monitor",this);
	agt_ap = new ("agt_ap",this);
  endfunction : build_phase

  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
 	if (get_is_active() == UVM_ACTIVE)begin 
	  drv_h.seq_item_port.connect (sqr_h.seq_item_export);
	  mon_h.mon_ap.connect(this.agt_ap);
	end
  endfunction : connect_phase

endclass
`endif