import uvm_pkg::*;
/*#####################################################################################################################################
## Class name   : Transaction
## Revision     : 
## Release note :   
/*#####################################################################################################################################*/

`include "uvm_macros.svh"
import alu_pkg::*;  // User defined data types 

`ifndef Transaction_exists
`define Transaction_exists
class Transaction extends uvm_sequence_item;
  // Declare inputs
  rand  data_t alu_in_a, alu_in_b;
  rand  opcode_t alu_op_a, alu_op_b;
  rand  mode_t alu_enables;
  //bit   alu_rst_n ;
	
  // Declare outputs 
  logic [7:0] alu_out;
  logic alu_irq;

  // Expected Results
  logic [7:0] alu_out_expected;
  logic   alu_irq_expected;

  // Knobs for driving configurations 
  rand bit   enable_alu_irq_clr; // 
  rand bit   enable_alu_rst_n;
  rand bit   enable_alu_irq;

  // Knobs for driving certain scenarios
  rand bit dir_case;
 
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  Constrains 
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  constraint unsigend_in {alu_in_a >= 0; alu_in_b >= 0;}
  constraint rst {enable_alu_rst_n dist { 1 := 90 ,0:=10};}  
 // constraint enable_rst { enable_alu_rst_n -> alu_rst_n;}

  constraint op_a_cons_and {  enable_alu_rst_n && alu_enables == ENABLE_MODE_A && alu_op_a == OP1 -> alu_in_b != 8'h0;    }
  constraint op_a_cons_nand { if (enable_alu_rst_n && alu_enables == ENABLE_MODE_A && alu_op_a == OP2 )  !(alu_in_a inside {8'hFF});    }
  constraint op_a_cons_nand2 { if (enable_alu_rst_n && alu_enables == ENABLE_MODE_A && alu_op_a == OP2)  !(alu_in_b inside {8'h03});    }

  constraint op_b_cons_and { enable_alu_rst_n && alu_enables == ENABLE_MODE_B && alu_op_b == OP2 -> alu_in_b != 8'h03;    }
  constraint op_b_cons_nor { enable_alu_rst_n && alu_enables == ENABLE_MODE_B && alu_op_b == OP3 -> alu_in_a != 8'hF5;    }

  constraint irq_triggered { if (enable_alu_irq) (alu_enables inside {ENABLE_MODE_A,ENABLE_MODE_B}); }
  constraint irq_triggered_opA_and { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_A && alu_op_a == OP1 )  -> (alu_in_a & alu_in_b == 8'hFF);  }
  constraint irq_triggered_opA_nand { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_A && alu_op_a == OP2 ) -> (~(alu_in_a & alu_in_b) == 8'h00);  }
  constraint irq_triggered_opA_or { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_A && alu_op_a == OP3 )   -> (alu_in_a | alu_in_b == 8'hF8);  }
  constraint irq_triggered_opA_xor { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_A && alu_op_a == OP4 )  -> (alu_in_a ^ alu_in_b == 8'hFF);  }

  constraint irq_triggered_opB_xnor { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_B && alu_op_b == OP1 ) -> (~(alu_in_a ^ alu_in_b) == 8'hF1);  }
  constraint irq_triggered_opB_and { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_B && alu_op_b == OP2 ) -> ((alu_in_a & alu_in_b) == 8'hF4);  }
  constraint irq_triggered_opB_nor { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_B && alu_op_b == OP3 ) -> (~(alu_in_a | alu_in_b) == 8'hF5);  }
  constraint irq_triggered_opB_or { (enable_alu_irq && enable_alu_rst_n && alu_enables == ENABLE_MODE_B && alu_op_b == OP4 ) -> ((alu_in_a | alu_in_b) == 8'hFF);  }

  constraint enabling_dir_case {dir_case dist {1 := 30, 0 :=70 }; }
  constraint direct_test_cases {enable_alu_rst_n && dir_case -> alu_in_a inside {8'h0, 8'hF0, 8'h02, 8'hFF }; alu_in_b inside {8'h0, 8'hF0, 8'h02, 8'hFF, 8'h0F};}
  
  // using macros instead of uvm do functions to deal with the transaction but to be noticed that this macros have shallow methods
//  `uvm_object_utils_begin(Transaction)
//   `uvm_field_enum (opcode_t,alu_op_a,UVM_ALL_ON)
//   `uvm_field_enum (opcode_t,alu_op_b, UVM_ALL_ON)
//   `uvm_field_enum (mode_t, alu_enables, UVM_ALL_ON)
//  `uvm_object_utils_end

  function new (string name = "Transaction");
    super.new(name);
  endfunction 
  
  `uvm_object_utils(Transaction); // Factory registration if you ganna not used field macros, dont use both at same time this will lead to bad results 
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Do functions :  used to do deep methods  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  virtual function  void do_copy (uvm_object rhs);
    Transaction trn_h;
    if (!$cast (trn_h,rhs)) `uvm_error ("TX_CAST : ",{get_full_name(), " \" Illegal do_copy argument! \" "})
  
   super.do_copy(rhs);
   alu_in_a         = trn_h.alu_in_a;
   alu_in_b         = trn_h.alu_in_b;
   alu_op_a         = trn_h.alu_op_a;
   alu_op_b         = trn_h.alu_op_b;
   alu_enables      = trn_h.alu_enables;
  // alu_rst_n        = trn_h.alu_rst_n;
    //Outputs and expected 
   alu_out          = trn_h.alu_out;
   alu_irq          = trn_h.alu_irq;
   alu_out_expected = trn_h.alu_out_expected;
   alu_irq_expected = trn_h.alu_irq_expected;
  endfunction 

  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer) ;
    Transaction trn_h;
    if (!$cast (trn_h, rhs)) `uvm_error ("TX_CAST",{get_type_name(), "Illegal do_compare argument .."})
   
    return ( super.do_compare (rhs,comparer) && alu_out === trn_h.alu_out &&
        	alu_irq === trn_h.alu_out && alu_out_expected === trn_h.alu_out_expected &&
		alu_irq_expected == trn_h.alu_irq_expected );
  endfunction

  function void do_record (uvm_recorder recorder);
    super.do_record (recorder);
    
   `uvm_record_field ("alu_enables", alu_enables.name)
    `uvm_record_attribute (recorder.tr_handle,"alu_op_a" , alu_op_a)
  endfunction

  virtual function void do_print (uvm_printer printer);
  printer.m_string = convert2string();
  endfunction
  
  virtual function string convert2string ();
    string s = super.convert2string();
	$sformat (s,"%s\n alu_out = %0x" , s,alu_out);
	$sformat (s,"%s\n alu_op_a = %s",s,alu_op_a.name);
    return s;
  endfunction
endclass
`endif