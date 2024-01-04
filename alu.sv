// Simulate with +BAD_OR to force behavior errors 

import alu_pkg::*;
module alu 
	
	(  // Declare inputs
	input alu_rst_n, alu_clk, alu_enable_a, alu_enable_b, alu_enable, alu_irq_clr,
	input data_t alu_in_a, alu_in_b,
	input opcode_t alu_op_a, alu_op_b,
	// Declare outputs
	output data_t alu_out,
	output  alu_irq
	);
	reg alu_irq_r;
	
	bit good_or = 1;
   /*initial begin
      if ($test$plusargs("BAD_OR")) begin
	 good_or = 0;
	 $display("\n*********************************************");
	 $display("In %m");
	 $display("+BAD_OR detected: OR instructions will fail");
	 $display("*********************************************\n");
      end
   end*/
   
	always @(posedge alu_clk, negedge alu_rst_n)begin
		if (alu_rst_n != 1)begin
			alu_out <= '0; alu_irq_r <= '0;
		end
		else begin 
				if (alu_enable_a == 1 && alu_enable_b !=1 && alu_enable == 1)begin 
					case (alu_op_a)
					OP1:	if (alu_in_b != 8'h0) alu_out <= (alu_in_a & alu_in_b);
					OP2:	if (alu_in_b != 8'h03 && alu_in_a != 8'hFF) alu_out <= (alu_in_a &~ alu_in_b);
					OP3: 	alu_out <= good_or ? (alu_in_a | alu_in_b) : (alu_in_a & alu_in_b);
					OP4:	alu_out <= alu_in_a ^ alu_in_b;
					default: ;
					endcase
				end
				
				 if (alu_enable == 1 && alu_enable_a != 1 && alu_enable_b ==1)begin 
					case (alu_op_b)
					OP1:	alu_out <= alu_in_a ^~ alu_in_b;
					OP2:	if (alu_in_b != 8'h03) alu_out <= (alu_in_a & alu_in_b);
					OP3:	if (alu_in_b != 8'hF5) alu_out <= (alu_in_a |~ alu_in_b);
					OP4:	alu_out <= (good_or) ? (alu_in_a | alu_in_b) : (alu_in_a & alu_in_b);
					default: ;
					endcase
				end
				else begin
				alu_out <= '0; alu_irq_r <= '0;
				//$warning("@%t:%m Unrecognized mode {alu_enable,alu_enable_a,alu_enable_b}=%0b ", $realtime, {alu_enable,alu_enable_a,alu_enable_b});
				end
		end
	end
	
 	// IRQ states 
	always @ (posedge alu_clk , negedge alu_irq_clr)begin
		if (alu_irq_clr == 1)begin
			alu_irq_r <= 0;
		end
		else begin 
			if (alu_enable == 1 && alu_enable_a == 1 && alu_enable_b != 1)begin
				case (alu_op_a)
				OP1:  alu_irq_r <= (alu_in_a & alu_in_b == 8'hFF)  ? 1'b1 : 1'b0;
				OP2:  alu_irq_r <= (alu_in_a &~ alu_in_b == 8'h00) ? 1'b1 : 1'b0;
				OP3:  alu_irq_r <= (alu_in_a | alu_in_b == 8'hF8)  ? 1'b1 : 1'b0;
				OP4:  alu_irq_r <= (alu_in_a ^ alu_in_b == 8'h83)  ? 1'b1 : 1'b0;
				default: alu_irq_r <= '0;
				endcase
			end
			 if (alu_enable == 1 && alu_enable_a != 1 && alu_enable_b == 1)begin
				case (alu_op_b)
				OP1: alu_irq_r <= (alu_in_a ^~ alu_in_b == 8'hF1) ? 1'b1 : 1'b0;
				OP2: alu_irq_r <= (alu_in_a & alu_in_b == 8'hF4)  ? 1'b1 : 1'b0;
				OP3: alu_irq_r <= (alu_in_a |~ alu_in_b == 8'hF5) ? 1'b1 : 1'b0;
				OP4: alu_irq_r <= (alu_in_a | alu_in_b == 8'hFF)  ? 1'b1 : 1'b0;
				default: alu_irq_r <= '0;
				endcase
			end	
			else alu_irq_r <= '0;	
		end
		
	end 
	
	assign alu_irq = alu_irq_clr ? 1'b0: alu_irq_r;
        /*initial begin $monitor("alu_out = %d, alu_in_a = %d, alu_op_a=%s, alu_enable_a,alu_enable_b,alu_enable=%b",
					alu_out, alu_in_a, alu_op_a.name, {alu_enable_a,alu_enable_b,alu_enable}); end*/
endmodule






/*--------------------------------------------------------------------------
  Simple test
----------------------------------------------------------------------------*/
/*module tb();
	logic alu_clk = 0, alu_rst_n = 0, alu_irq_clr, alu_irq, alu_enable;
	logic alu_enable_a, alu_enable_b;
	logic [7:0] alu_in_a, alu_in_b, alu_out, alu_expect;
	opcode_t alu_op_a, alu_op_b;



	alu alu0 (.alu_clk(alu_clk), .alu_rst_n(alu_rst_n), .alu_in_a(alu_in_a),
	.alu_in_b(alu_in_b),.alu_op_a(alu_op_a),.alu_op_b(alu_op_b),.alu_out(alu_out)
	, .alu_irq(alu_irq), .alu_enable(alu_enable),.alu_enable_a(alu_enable_a),
	.alu_enable_b(alu_enable_b),.alu_irq_clr(alu_irq_clr));

	always #10 alu_clk = ~alu_clk;
    always begin #7 alu_in_a = $random; alu_in_b = $random;
				#15  alu_op_a = alu_op_a.next;
				#20  alu_op_b = alu_op_b.next;end
	initial begin

		alu_rst_n = 0; alu_irq_clr = 0; alu_enable = 0; alu_enable_a = 0;
		 alu_enable_b = 0; alu_in_a = 0; alu_in_b = 0; alu_op_a = alu_op_a.first; alu_op_b = alu_op_b.first;
		assert (alu_out == 0 && alu_irq == 0) $display ("Sucess: ALU unable to be reseted");
		
		#10 alu_in_a = 1; alu_in_b = 1; 
		#15 alu_rst_n= 1; alu_enable = 1;
		assert (alu_out == 0 && alu_irq == 0) $display ("Sucess: ALU does go idle state");
		
		#15 alu_rst_n= 1; alu_enable = 1; alu_enable_a =1; alu_enable_b = 0; alu_op_a = alu_op_a.first;

		#100 alu_rst_n= 1; alu_enable = 1; alu_enable_b =1; alu_enable_a = 0;
		#100 alu_rst_n= 1; alu_enable = 1; alu_enable_b =1; alu_enable_a = 1;
		
		// for IRQ
		#150;
		alu_enable = 1; alu_enable_a = 1; alu_enable_b = 0;
		alu_op_a = OP1; alu_in_a = 8'hFF; alu_in_b = 8'hFF;
		#100; alu_irq_clr = 1;
		#150; alu_irq_clr = 0;
		#100; alu_irq_clr = 1;
		#150; alu_irq_clr = 0;		
		
	end
endmodule */
