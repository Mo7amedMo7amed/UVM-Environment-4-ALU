import uvm_pkg::*;
`include "uvm_macros.svh"

class CoverageCollector /*extends uvm_subscriber #(Transaction)*/ ;
  Transaction trn_h;
  











//  `uvm_component_utils(CoverageCollector)
//  function new (string name , uvm_component parent);
//    super.new (name, parent);
//    // Constract the coverage groups 
//
//
//  endfunction : new

//  virtual function void write  (Transaction mon_t);
//    this.trn_h = mon_t;
//    cg.sample();
//  endfunction : write
endclass
