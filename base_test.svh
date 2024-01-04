/*#####################################################################################################################################
## Class name     : Base_Test
## Revision       : 
## Release note   :   
/*#####################################################################################################################################*/

//import uvm_pkg::*;
//`include"uvm_macros.svh"
import project_pkg::*;

`ifndef Base_Test_exists
`define Base_Test_exists
class Base_Test extends uvm_test;
  // Data Members
  Environment env_h;

  // Constractor and factory reg
  `uvm_component_utils (Base_Test)
  function new (string name = "Base_Test", uvm_component parent = null);
	super.new(name, parent);
  endfunction 

  // Build phase
  virtual function void build_phase (uvm_phase phase);
  	super.build_phase (phase);
	 env_h = Environment::type_id::create("env_h",this);
	configure_agt();
  endfunction : build_phase

  // Run
  virtual task  run_phase (uvm_phase phase);
	//super.run_phase(phase);
	
	Sequence sqs_test = Sequence::type_id::create("sqs_test");
	sqs_test.num_trn = 1000;
 	
	phase.raise_objection(this);
	sqs_test.start(env_h.agt_h.sqr_h);
	#10;
	phase.drop_objection(this);

  endtask : run_phase

  // Configure the agent to be active or passive
  virtual function void configure_agt ();
	env_h.agt_h.is_active = UVM_ACTIVE;
  endfunction : configure_agt
endclass
`endif
