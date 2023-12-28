import uvm_pkg::*;
`include "uvm_macros.svh"
import alu_pkg::*;  // user defined data types 

//`ifndef Transaction_exists
//`define Transaction_exists
class Transaction extends uvm_sequence_item;
  // declare inputs
  rand  data_t alu_in_a, alu_in_b;
  rand  opcode_t alu_op_a, alu_op_b;
  rand  mode_t alu_enables;
  bit   alu_rst_n = 1'b0;
	
  // declare outputs 
  logic [7:0] alu_out;
  bit alu_irq;

  // Knobs for driving configurations 
  rand bit   enable_alu_irq_clr; // 
  rand bit   enable_alu_rst_n;
  rand bit   enable_alu_irq;

  // Knobs for driving certain scenarios
  rand bit dir_case;

//{
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  Constrains 
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  constraint unsigend_in {alu_in_a >= 0; alu_in_b >= 0;}
  constraint rst {enable_alu_rst_n dist { 1 := 90 ,0:=10};  

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
  

    `uvm_object_utils(Transaction); // factory registration 
   using macros instead of uvm do functions to deal with the transaction 
  `uvm_object_utils_begin


  `uvm_object_utils_end

  function new (string name = "Transaction");
    super.new(name);
  endfunction 

  // do functions
  
  

endclass



