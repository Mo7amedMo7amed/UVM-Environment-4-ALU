
import project_pkg::*;
import uvm_pkg::*;

module tb_top;
  logic clk = 0;
  always #10 clk = ~clk;
  ifc v_ifc(clk);

  initial begin
  uvm_config_db#(virtual ifc)::set(uvm_root::get(),"*","v_ifc",v_ifc);
  run_test("Base_Test");

  end
endmodule