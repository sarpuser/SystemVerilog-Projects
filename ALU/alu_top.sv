// N-bit ALU TOP RTL code
module alu_top // Module start declaration
#(parameter N=4) // Parameter declaration
(  	input logic clk, reset,
   	input logic[N-1:0]operand1, operand2,
   	input logic[3:0] select,
   	output logic[(2*N)-1:0] result
);

  // Local net declaration
  	logic[(2*N)-1:0] alu_out; 

  // Student to Add instantiation of module alu
	alu #(.N(N)) alu_instance (
		.operand1,
		.operand2,
		.operation(select),
		.alu_out
	);
  
  // Adding flipflop at the output of ALU
  	always@(posedge clk or posedge reset) begin
		if(reset == 1) begin
	  		result <= 0;
		end
		else begin
			result <= alu_out;
		end
 	end
endmodule: alu_top // Module alu_top end declaration