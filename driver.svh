/*#####################################################################################################################################
## Class name   : Driver
## Revision     : 
## Release note :   
/*#####################################################################################################################################*/

//import project_pkg::*;
//import uvm_pkg::*;
`include "uvm_macros.svh"

`ifndef Driver_exists
`define Driver_exists

class Driver extends uvm_driver #(Transaction);
   // Data members
  Transaction trn_h;
  virtual ifc v_ifc;

  // Constractor and uvm macros automations includes factory registration  
  `uvm_component_utils(Driver)
  function  new (string name = "Driver", uvm_component parent = null);
	super.new (name,parent);
  endfunction

  // Build method
  function void build_phase (uvm_phase phase);
	super.build_phase(phase);
	if (!uvm_config_db#(virtual ifc)::get (this,"","v_ifc",v_ifc))
	  `uvm_fatal ("DRV_NO_VIFC",{get_full_name(),".vifc"," \"Could not get virtual interface\""})
  endfunction : build_phase
  
  // Run method 
  task run_phase (uvm_phase phase);
   v_ifc.initialize();
   forever begin
	`uvm_info ("DRV_RUN","Driver get next item",UVM_LOW)
	seq_item_port.get_next_item (trn_h);
	v_ifc.transfer(trn_h);
	#50;
	`uvm_info ("DRV_TRANSFER", trn_h.convert2string(),UVM_DEBUG)
	seq_item_port.item_done(trn_h);
   end 
  endtask : run_phase




endclass
`endif