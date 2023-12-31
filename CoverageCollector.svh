/*#####################################################################################################################################
## Class name   : CoverageCollector
## Revision     : 
## Release note :   
/*#####################################################################################################################################*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class Coverage_Collector /*extends uvm_subscriber #(Transaction)*/ ;
  Transaction trn_h;
  


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Coverage model
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
  covergroup cg_operation_a @( trn_h.enable_alu_rst_n && trn_h.alu_enables == ENABLE_MODE_A ) ;
	op_a: coverpoint trn_h.alu_op_a { 
	      bins op_a_and   = {OP1};
	      bins op_a_nand  = {OP2};
	      bins op_a_or    = {OP3};
	      bins op_a_xor   = {OP4}; 
		}
	unsigned_input_a: coverpoint trn_h.alu_in_a { illegal_bins negative_no = {[$:-1]}; bins others = default ;}
    	unsigned_input_b: coverpoint trn_h.alu_in_b { illegal_bins negative_no  = {[$:-1]}; bins others = default ;}

	operation_a_and  :   coverpoint trn_h.alu_out == {trn_h.alu_in_a & trn_h.alu_in_b}   iff (trn_h.alu_op_a == OP1) ;//{bins True = {1'b1}; ignore_bins False = {1'b0}; }// option.auto_bin_max =1;}
	operation_a_nand :   coverpoint trn_h.alu_out == {~(trn_h.alu_in_a & trn_h.alu_in_b)}iff (trn_h.alu_op_a == OP2) ;//{bins True = {1'b1}; ignore_bins False = {1'b0}; }
	operation_a_or   :   coverpoint trn_h.alu_out == {trn_h.alu_in_a | trn_h.alu_in_b}   iff (trn_h.alu_op_a == OP3) ;//{bins True = {1'b1}; ignore_bins False = {1'b0}; }
	operation_a_xor  :   coverpoint trn_h.alu_out == {trn_h.alu_in_a ^ trn_h.alu_in_b}   iff (trn_h.alu_op_a == OP4) ;//{bins True = {1'b1}; ignore_bins False = {1'b0}; }

	illegal_in_a: coverpoint  trn_h.alu_in_a iff ( trn_h.alu_op_a == OP2 ){
		illegal_bins alu_in_a_NAND = {8'hFF}; 
		bins others = default ;
		//option.weight = 50;
		//ignore_bins ignore_others = ! binsof ({8'hFF});
		}
	illegal_in_b_AND: coverpoint  trn_h.alu_in_b iff (trn_h.alu_op_a == OP1 ){
		illegal_bins alu_in_b_AND = {8'h00}; 
		bins others = default ;
		//option.weight = 50;
		//ignore_bins ignore_others = ! binsof(8'h00);
		}
	illegal_in_b_NAND: coverpoint  trn_h.alu_in_b iff (trn_h.alu_op_a == OP2 ){
		illegal_bins alu_in_b_AND = {8'h03};
		bins others = default ;
		//option.weight = 50;
		//ignore_bins ignore_others = ! binsof (8'h03); 
		}
	// Interrupt conditions
	irq_and  :     coverpoint ({(trn_h.alu_in_a & trn_h.alu_in_b)}== 8'hFF) {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_nand :     coverpoint ({~(trn_h.alu_in_a & trn_h.alu_in_b)}== 8'h00) {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_or   :     coverpoint ({(trn_h.alu_in_a | trn_h.alu_in_b)}== 8'hF8) {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_xor  :     coverpoint ({(trn_h.alu_in_a ^ trn_h.alu_in_b)}== 8'h83)  {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_state:     coverpoint trn_h.alu_irq { bins irq_high = {1'b1}; ignore_bins irq_low = {1'b0};}
	
        irq_active_and:    cross irq_and , irq_state {  
				bins irq_hi_and = binsof(irq_and)  && binsof(irq_state.irq_high);
				ignore_bins ig1 = !binsof(irq_and) || !binsof(irq_state.irq_high);}
        irq_active_nand:    cross irq_nand , irq_state {  
				bins irq_hi_nand = binsof(irq_nand) && binsof (irq_state.irq_high);
				ignore_bins ig1 = !binsof(irq_nand) || !binsof (irq_state.irq_high);}
        irq_active_or:    cross irq_or , irq_state {  
				bins irq_hi_or = binsof (irq_or) && binsof (irq_state.irq_high);
				ignore_bins ig1 = !binsof (irq_or) || !binsof (irq_state.irq_high);}
        irq_active_xor:    cross irq_xor , irq_state {  
				bins irq_hi_xor = binsof (irq_xor) && binsof (irq_state.irq_high);
				ignore_bins ig1 = !binsof (irq_xor) || !binsof (irq_state.irq_high);}

  endgroup

  covergroup cg_operation_b @( trn_h.enable_alu_rst_n && trn_h.alu_enables == ENABLE_MODE_B ) ;
	op_b: coverpoint trn_h.alu_op_b { 
	      bins op_a_and   = {OP1};
	      bins op_a_nand  = {OP2};
	      bins op_a_or    = {OP3};
	      bins op_a_xor   = {OP4}; 
		}
	unsigned_input_a:  coverpoint trn_h.alu_in_a { illegal_bins negative_no  = {[$:-1]}; bins others = default ;}
    	unsigned_input_b:  coverpoint trn_h.alu_in_b { illegal_bins negative_no  = {[$:-1]}; bins others = default ;}

	operation_b_xnor:  coverpoint trn_h.alu_out    == ~{trn_h.alu_in_a ^ trn_h.alu_in_b}   iff (trn_h.alu_op_b == OP1) {bins True = {1'b1}; ignore_bins False = {1'b0}; }// option.auto_bin_max =1;}
	operation_b_and:   coverpoint trn_h.alu_out    == {(trn_h.alu_in_a & trn_h.alu_in_b)}  iff (trn_h.alu_op_b == OP2) {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	operation_b_nor:   coverpoint trn_h.alu_out    == {~(trn_h.alu_in_a | trn_h.alu_in_b)} iff (trn_h.alu_op_b == OP3) {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	operation_b_or:    coverpoint trn_h.alu_out    == {trn_h.alu_in_a | trn_h.alu_in_b}    iff (trn_h.alu_op_b == OP4) {bins True = {1'b1}; ignore_bins False = {1'b0}; }

	illegal_in_a: coverpoint  trn_h.alu_in_a iff ( trn_h.alu_op_b == OP3 ){
		illegal_bins alu_in_a_NAND = {8'hF5}; 
		bins others = default ;
		}

	illegal_in_b: coverpoint  trn_h.alu_in_b iff (trn_h.alu_op_a == OP2 ){
		illegal_bins alu_in_b_AND = {8'h03}; 
		bins others = default ;
		}
	// Interrupt conditions
	irq_xnor  :     coverpoint ({~(trn_h.alu_in_a ^ trn_h.alu_in_b)}== 8'hF1) {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_and   :     coverpoint ({(trn_h.alu_in_a & trn_h.alu_in_b)}== 8'hF4)  {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_nor   :     coverpoint ({~(trn_h.alu_in_a | trn_h.alu_in_b)}== 8'hF5) {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_or    :     coverpoint ({(trn_h.alu_in_a | trn_h.alu_in_b)}== 8'hFF)  {bins True = {1'b1}; ignore_bins False = {1'b0}; }
	irq_state :     coverpoint trn_h.alu_irq { bins irq_high = {1'b1}; ignore_bins irq_low = {1'b0};}
	
        irq_active_xnor:    cross irq_xnor , irq_state {  
				bins irq_hi_xnor = binsof(irq_xnor)  && binsof(irq_state.irq_high);
				ignore_bins ig1 = !binsof(irq_xnor) || !binsof(irq_state.irq_high);}
        irq_active_and:    cross irq_and , irq_state {  
				bins irq_hi_and = binsof(irq_and) && binsof (irq_state.irq_high);
				ignore_bins ig1 = !binsof(irq_and) || !binsof (irq_state.irq_high);}
        irq_active_nor:    cross irq_nor , irq_state {  
				bins irq_hi_nor = binsof (irq_nor) && binsof (irq_state.irq_high);
				ignore_bins ig1 = !binsof (irq_nor) || !binsof (irq_state.irq_high);}
        irq_active_or:    cross irq_or , irq_state {  
				bins irq_hi_or = binsof (irq_or) && binsof (irq_state.irq_high);
				ignore_bins ig1 = !binsof (irq_or) || !binsof (irq_state.irq_high);}

  endgroup

  covergroup cg_others ;
	alu_out_reseted: coverpoint trn_h.alu_out iff (!trn_h.enable_alu_rst_n) { bins alu_out_zero = {8'h00}; bins others = default;}
	alu_irq_reseted: coverpoint trn_h.alu_irq iff (!trn_h.enable_alu_rst_n) { bins alu_irq_zero = {1'h0}; bins others = default;}
 	alu_irq_clr :    coverpoint trn_h.alu_irq == {1'b0} iff (trn_h.enable_alu_irq_clr == {1'b1});
	all_enables_high : coverpoint trn_h.alu_enables { illegal_bins all_high = {3'b111}; bins others = default;}
	stuck_zero  :      coverpoint trn_h.alu_out {bins stuck_out = 0[*10]; bins others = default;}
  endgroup
  
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
