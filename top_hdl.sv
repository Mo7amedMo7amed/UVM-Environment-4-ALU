//

module top_hdl ;
import alu_pkg::*;
logic clk = 0;
always #10 clk = ~clk;
ifc v_ifc(clk); 
alu alu0 (.alu_clk(clk), .alu_rst_n(v_ifc.alu_rst_n), .alu_in_a(v_ifc.alu_in_a),
		.alu_in_b(v_ifc.alu_in_b),.alu_op_a(v_ifc.alu_op_a),.alu_op_b(v_ifc.alu_op_b),
		.alu_out(v_ifc.alu_out), .alu_irq(v_ifc.alu_irq), .alu_enable(v_ifc.alu_enable),
		.alu_enable_a(v_ifc.alu_enable_a), .alu_enable_b(v_ifc.alu_enable_b),.alu_irq_clr(v_ifc.alu_irq_clr));
endmodule