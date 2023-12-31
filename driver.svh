/*#####################################################################################################################################
## Class name   : Driver
## Revision     : 
## Release note :   
/*#####################################################################################################################################*/

import project_pkg::*;
import uvm_pkg::*;
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
	if (!uvm_config_db#(virtual v_ifc)::get (this,"","vifc",v_ifc))
	  `uvm_fatal ("DRV_NO_VIFC",{get_full_name(),".vifc"," \"Could not get virtual interface\""})
  endfunction : build_phase
  
  // Run method 
  task run_phase (uvm_phase phase);
   v_ifc.initialize(trn_h);
   forever begin
	`uvm_info ("DRV_RUN","Driver request TX",UVM_LOW)
	seq_item_port.get_next_item (trn_h);
	`uvm_info ("DRV_RUN", "Driver got TX",UVM_LOW)
	v_ifc.transfer(trn_h);
	#3;
	seq_item_port.item_done(trn_h);
   end 
  endtask : run_phase




endclass
`endif