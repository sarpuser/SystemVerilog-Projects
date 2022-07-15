`timescale 1ns/1ns
//FullAdder testbench code
module fulladder_testbench;
 logic in0, in1, carryin; 
 logic add, carryout;

//spect : 8336949259
// Instantiate design under test
fulladder_dataflow design_instance(
.a(in0),
.b(in1),
.cin(carryin),
.cout(carryout),
.sum(add)
);

initial begin
// Initialize Inputs
in0=0;
in1=0;
carryin=0;
// Wait 100 ns for global reset to finish
#100;
in0=0;
in1=0;
carryin=0;
#50 
in0=1;
in1=0;
carryin=0;
#50
in0=0;
in1=1;
carryin=0;
#50
in0=1;
in1=1;
carryin=0;
#50; 
in0=0;
in1=0;
carryin=1;
#50; 
in0=1;
in1=0;
carryin=1;
#50;
in0=0;
in1=1;
carryin=1;
#50;
in0=1;
in1=1;
carryin=1;
#50;
end

initial begin
 $monitor(" time=%0t   a=%d   b=%d   c=%d   sum=%d   cout=%d\n", $time, in0, in1, carryin, add, carryout);
end
endmodule