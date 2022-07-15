//1-bit ALU testbench code
`timescale 1ns/1ps
module alu_top_testbench;
parameter N = 4;
logic clock, reset;
logic [N-1:0] operand1, operand2;
logic [(2*N)-1:0] result;
logic [N-1:0] operation;

// Instantiate design under test
alu_top #(.N(N)) design_instance(
 .clk(clock),
 .reset(reset),
 .operand1(operand1), 
 .operand2(operand2), 
 .select(operation), 
 .result(result)
);

initial begin
// Initialize Inputs
reset = 1;
clock = 1;
operand1 = 0;
operand2 = 0;
operation = 0;

// Wait 20 ns for global reset to finish and start counter
#20ns;
reset = 0;

#20ns
operand1 = 2;
operand2 = 1;
operation = 0; // Addition

#20ns;
operand1 = 9;
operand2 = 5;
operation = 1; // Subtraction

#20ns;
operand1 = 12;
operand2 = 10;
operation = 2; // Multiplication

#20ns;
operand1 = 7;
operand2 = 4;
operation = 3; // Modulo

#20ns
operand1 = 12;
operand2 = 6;
operation = 4; // Division

#20ns;
operand1 = 9;
operand2 = 8;
operation = 5; // Bitwise And

#20ns;
operand1 = 5;
operand2 = 10;
operation = 6; // Bitwise OR

#20ns;
operand1 = 1;
operand2 = 3;
operation = 7; // Bitwise XOR

#20ns;
operand1 = 9;
operand2 = 8;
operation = 8; // Logical AND

#20ns;
operand1 = 5;
operand2 = 10;
operation = 9; // Logical OR

#20ns;
operand1 = 4;
operand2 = 7;
operation = 10; // Left Shift by 1 (it is same as multiply by 2)

#20ns;
operand1 = 4;
operand2 = 7;
operation = 11; // Right Shift by 1 (it is same as divide by 2)

#20ns;
operand1 = 5;
operand2 = 5;
operation = 12; // Logical Equality

#20ns;
operand1 = 3;
operand2 = 8;
operation = 13; // Logical Inequality

#20ns;
operand1 = 9;
operand2 = 7;
operation = 14; // Less than comparison

#20ns;
operand1 = 13;
operand2 = 10;
operation = 15; // Greater than comparison

// Wait for 60ns
#60ns;

// terminate simulation
//$finish();
end

// Clock generator logic
always@(clock) begin
  #10ns clock <= !clock;
end

// Print input and output signals
initial begin
 $monitor(" time=%0t,  clk=%b  reset=%b  operation=%d, operand1=%d, operand2=%d",$time, clock, reset, operation, operand1, operand2);
end
endmodule