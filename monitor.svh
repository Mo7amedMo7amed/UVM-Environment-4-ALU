/*#####################################################################################################################################
## Class name     : Monitor
## Revision       : 
## Release note   :   
/*#####################################################################################################################################*/

import uvm_pkg::*;
`include "uvm_macros.svh"
import project_pkg::*;

`ifndef Monitor_exists
`define Monitor_exists
class Monitor extends uvm_monitor ;

  // Data members 
  Transaction collected_trn;
  virtual ifc v_ifc;
  uvm_analysis_port #(Transaction) mon_ap;

  // Factory registration and constractor
  `uvm_component_utils (Monitor)
  function new (string name = "Monitor", uvm_component parent = null);
    super.new (name,parent);
  endfunction

  // Build phase method
 virtual function void build_phase (uvm_phase phase );
    super.build_phase(phase); 
    if (!uvm_config_db #(virtual v_ifc)::get (this, "", "v_ifc",v_ifc)) 
	`uvm_fatal ("MON_NO_VIFC", {get_full_name(),".v_ifc","Could not get virtual interface"});
    mon_ap = new ("mon_ap",this);	
  endfunction : build_phase

  // Run phase method
  virtual task run_phase (uvm_phase phase);
     super.run_phase (phase);
     forever begin 
	fork
	collect_trn();
	join
     end
  endtask : run_phase
  
  task collect_trn ();
	collected_trn = Transaction::type_id::create("collected_trn");
	v_ifc.collect_inout(collected_trn);
	mon_ap.write (collected_trn);
  endtask : collect_trn
endclass
`endif 