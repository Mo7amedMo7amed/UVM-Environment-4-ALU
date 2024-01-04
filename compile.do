
vlog alu_pkg.sv
vlog alu.sv

vlog project_pkg.sv
vlog alu_ifc.sv
vlog tb_top.sv
vsim tb_top -classdebug -solvefailseverity=4 -solvefaildebug=2 -voptargs=+acc -cover
run 0