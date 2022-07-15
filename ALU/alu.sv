// 1-bit ALU behavioral code
module alu // Module start declaration
#(parameter N=4) // Parameter declaration
(
	input logic[N-1:0] operand1, operand2,
	input logic[3:0] operation,
	output logic[(2*N)-1:0] alu_out
);

	// always procedural block describing alu operations
	always@(operand1 or operand2 or operation) 
	begin
		case (operation)
			4'b0000: alu_out = operand1 + operand2;
			4'b0001: alu_out = operand1 - operand2;
			4'b0010: alu_out = operand1 * operand2;
			4'b0011: alu_out = operand1 / operand2;
			4'b0100: alu_out = operand1 % operand2;
			4'b0101: alu_out = operand1 & operand2;
			4'b0110: alu_out = operand1 | operand2;
			4'b0111: alu_out = operand1 ^ operand2;
			4'b1000: alu_out = operand1 && operand2;
			4'b1001: alu_out = operand1 || operand2;
			4'b1010: alu_out = operand1 << 1;
			4'b1011: alu_out = operand1 >> 1;
			4'b1100: alu_out = operand1 == operand2;
			4'b1101: alu_out = operand1 != operand2;
			4'b1110: alu_out = operand1 < operand2;
			4'b1111: alu_out = operand1 > operand2;
			default: alu_out = 4'bxxxx;
	endcase
	end
endmodule: alu

