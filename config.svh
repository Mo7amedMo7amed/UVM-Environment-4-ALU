

import uvm_pkg::*;
`include"uvm_macros.svh"

class Config extends uvm_object ;
	// Factory and Constractor
	`uvm_object_utils(Config)
	function new (string name = "Config");
		super.new(name);
	endfunction

	virtual ifc v_ifc;
//string active = get_is_active();

endclass