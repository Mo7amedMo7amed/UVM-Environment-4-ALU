/*#####################################################################################################################################
## Class name     : Sequence
## Revision       : 
## Release note   :   
/*#####################################################################################################################################*/
//import uvm_pkg::*;
//`include "uvm_macros.svh"
import project_pkg::*;

`ifndef Sequence_exists
`define Sequence_exists

class Sequence extends uvm_sequence#(Transaction);
  `uvm_object_utils (Sequence)
  function new (string name = "Sequence");
	super.new(name);
  endfunction
  int num_trn = 10;
  Transaction trn2drv;
 
 task body ();
  repeat (num_trn) begin
   do_item();
  end
  endtask

  task do_item ();
	trn2drv = Transaction::type_id::create("trn2drv");  
	`uvm_info ("SQN_BODY","Sending item to driver",UVM_LOW)
	start_item(trn2drv);
 	trn2drv.randomize();
	`uvm_info("SQN_BODY","After starting sending item and just before finishing",UVM_LOW)
	finish_item(trn2drv);
	`uvm_info ("SQN_BODY","Done sending item to driver",UVM_LOW )
  endtask

endclass

`endif