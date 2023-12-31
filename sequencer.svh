/*#####################################################################################################################################
## Class name     : Sequencer
## Revision       : 
## Release note   :   
/*#####################################################################################################################################*/

import uvm_pkg::*;
`include "uvm_macros.svh"
import project_pkg::*;

`ifndef Sequencer_exists
`define Sequencer_exists

class Sequencer extends uvm_sequencer#(Transaction);
  // Constractor and Factory registration
  `uvm_component_utils(Sequencer)
  function new (string name = "Sequencer", uvm_component parent = null);
	super.new(name,parent);
  endfunction
endclass

`endif