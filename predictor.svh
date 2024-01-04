
/*#####################################################################################################################################
## Class name   : Predictor 
## Revision     : 
## Release note :   
/*#####################################################################################################################################*/

import project_pkg::*;
import alu_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  

`ifndef Predictor_exists
`define Predictor_exists
class Predictor extends uvm_subscriber#(Transaction);
	// Data Members
	Transaction expected_trn, t;
	uvm_analysis_port #(Transaction) expected_ap;
	
	// Factory and Constractor
	`uvm_component_utils(Predictor)
	function new (string name = "Predictor", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	// Build _phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		expected_ap = new ("expected_ap",this);
	endfunction : build_phase
	
	// Getting transactions from monitor ap and calculate the expected output then send it to evalualtor
	function  void write (Transaction t);
		$cast (expected_trn,t.clone());   // Clone the Transaction from monitor to another one to do operations on 
		expected_alu_out(expected_trn,t);
		expected_alu_irq (expected_trn,t);
		expected_ap.write(expected_trn);  // Send the calculated Transaction to the evalualtor
	endfunction : write
		
	// calculate expected outputs signals	
	function void expected_alu_out (Transaction expected_trn,Transaction t); // 
		if (t.enable_alu_rst_n != 1)begin
			expected_trn.alu_out <= '0; expected_trn.alu_irq <= '0;
		end
		else if (t.alu_enables == ENABLE_MODE_A)begin 
			case (t.alu_op_a)
				OP1:	if (t.alu_in_b != 8'h0) expected_trn.alu_out = (t.alu_in_a & t.alu_in_b);
				OP2:	if (t.alu_in_b != 8'h03 && t.alu_in_a != 8'hFF) expected_trn.alu_out = (t.alu_in_a &~ t.alu_in_b);
				OP3: 	expected_trn.alu_out =(t.alu_in_a | t.alu_in_b) ;
				OP4:	expected_trn.alu_out = t.alu_in_a ^t. alu_in_b;
				default: ;
			endcase
		end
				
		else if (t.alu_enables == ENABLE_MODE_B)begin 
			case (t.alu_op_b)
				OP1:	expected_trn.alu_out = t.alu_in_a ^~ t.alu_in_b;
				OP2:	if (t.alu_in_b != 8'h03) expected_trn.alu_out = (t.alu_in_a & t.alu_in_b);
				OP3:	if (t.alu_in_b != 8'hF5) expected_trn.alu_out = (t.alu_in_a |~ t.alu_in_b);
				OP4:	expected_trn.alu_out =  (t.alu_in_a | t.alu_in_b) ;
				default: ;
			endcase
		end
		else begin
			expected_trn.alu_out <= '0; 	
		end
		`uvm_info ("PREDICT_ALU_OUT",{"The Calculated alu_out : %x",expected_trn.alu_out},UVM_DEBUG);
	endfunction : expected_alu_out
	
	function void expected_alu_irq(Transaction expected_trn,Transaction t);
		if (t.enable_alu_irq_clr == 1)begin
			expected_trn.alu_irq <= 0;
		end
		else begin 
			if (t.alu_enables == ENABLE_MODE_A)begin
				case (t.alu_op_a)
				OP1:  expected_trn.alu_irq <= (t.alu_in_a & t.alu_in_b == 8'hFF)  ? 1'b1 : 1'b0;
				OP2:  expected_trn.alu_irq <= (t.alu_in_a &~ t.alu_in_b == 8'h00) ? 1'b1 : 1'b0;
				OP3:  expected_trn.alu_irq <= (t.alu_in_a | t.alu_in_b == 8'hF8)  ? 1'b1 : 1'b0;
				OP4:  expected_trn.alu_irq <= (t.alu_in_a ^ t.alu_in_b == 8'h83)  ? 1'b1 : 1'b0;
				default: expected_trn.alu_irq <= '0;
				endcase
			end
			else if (t.alu_enables == ENABLE_MODE_B)begin
				case (t.alu_op_b)
				OP1: expected_trn.alu_irq <= (t.alu_in_a ^~ t.alu_in_b == 8'hF1) ? 1'b1 : 1'b0;
				OP2: expected_trn.alu_irq <= (t.alu_in_a & t.alu_in_b == 8'hF4)  ? 1'b1 : 1'b0;
				OP3: expected_trn.alu_irq <= (t.alu_in_a |~ t.alu_in_b == 8'hF5) ? 1'b1 : 1'b0;
				OP4: expected_trn.alu_irq <= (t.alu_in_a | t.alu_in_b == 8'hFF)  ? 1'b1 : 1'b0;
				default: expected_trn.alu_irq <= '0;
				endcase
			end	
			else expected_trn.alu_irq <= '0;	
		end		

	`uvm_info ("PREDICT_ALU_IRQ",{"The Calculated alu_irq : %x",expected_trn.alu_irq},UVM_DEBUG);
	endfunction : expected_alu_irq
endclass
`endif