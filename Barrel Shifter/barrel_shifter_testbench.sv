`timescale 1ns/1ns
//Barrel Shifter Testbench Code
module barrel_shifter_testbench;
  logic select, direction;
  logic[1:0] shift_value;
  logic[3:0] din;
  logic[3:0] dout;

// Instantiate design under test
barrel_shifter design_instance(
 .select(select),
 .direction(direction),
 .shift_value(shift_value),
 .din(din),
 .dout(dout)
);

initial begin
// Initialize Inputs
select = 0;
direction = 0;
shift_value = 0;
din = 4'b0000;

// Right Shift by 1 
#100ns;
select = 0; // Shift operation
direction = 0; // Move Right 
shift_value = 1; // Shift by 1 bit position
din = 4'b1000;

// Right Shift by 2 
#100ns;
select = 0;
direction = 0; 
shift_value = 2; // Shift by 2 bit positions
din = 4'b1000;

// Right Shift by 3 
#100ns;
select = 0;
direction = 0;
shift_value = 3; // Shift by 2 bit positions
din = 4'b1000;

// Re-initialize all inputs 
#100ns;
select = 1;
direction = 0;
shift_value = 0;
din = 4'b0000;

// Rotate Right by 1 (ROR#1)
#100ns;
select = 1; // Rotate operation
direction = 0; // Move Right
shift_value = 1; // Shift by 1 bit position
din = 4'b1011;

// Rotate Right by 2 (ROR#2)
#100ns;
select = 1;
direction = 0;
shift_value = 2; // Shift by 2 bit positions
din = 4'b1011;

// Rotate Right by 3 (ROR#3)
#100ns;
select = 1;
direction = 0;
shift_value = 3; // Shift by 3 bit positions
din = 4'b1011;

// Re-initialize all inputs
#100ns;
select = 0;
direction = 1;
shift_value = 0;
din = 4'b0000;

// Left Shift by 1
#100ns;
select = 0; // Shift operation
direction = 1; // Move Right
shift_value = 1; // Shift by 1 bit position
din = 4'b0001;

// Left Shift by 2
#100ns;
select = 0;
direction = 1;
shift_value = 2; // Shift by 2 bit positions
din = 4'b0001;

// Left Shift by 3
#100ns;
select = 0;
direction = 1;
shift_value = 3; // Shift by 1 bit positions
din = 4'b0001;

// Re-initialize inputs
#100ns;
select = 1;
direction = 1;
shift_value = 0;
din = 4'b0000;

// Left Rotate by 1 (ROL#1)
#100;
select = 1; // Rotate operation
direction = 1; // Move Left
shift_value = 1; // Shift by 1 bit position
din = 4'b1011;

// Left Rotate by 2 (ROL#2)
#100ns;
select = 1;
direction = 1;
shift_value = 2; // Shift by 2 bit positions
din = 4'b1011;

// Left Rotate by 3 (ROL#3)
#100ns;
select = 1;
direction = 1;
shift_value = 3; // Shift by 3 bit positions
din = 4'b1011;

// Wait for 100ns and end simulation
#100ns;

// terminate simulation
$finish();
end


// Print input and output signals
initial begin
 $monitor(" time=%0t,  select=%b  shift_value=%b  din=%b dout=%b", $time, select, shift_value, din, dout);
end

endmodule