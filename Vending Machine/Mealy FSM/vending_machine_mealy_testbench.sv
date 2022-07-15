//vending machine testbench code
`timescale 1ns/1ns
module vending_machine_moore_testbench;
logic clock, rstn;
logic N, D, open;

// Instantiate design under test
vending_machine_mealy DUT(
.clk(clock),
.rstn(rstn),
.N(N),
.D(D),
.open(open)
);

initial begin
// Initialize Inputs
rstn = 0;
clock = 0;
N = 0;
D = 0;

// Wait 20 ns for global reset to finish and start counter
#20;
rstn = 1;

// Drive N, D
#20;
N = 1; 
D = 0;
#20;
N = 0;
D = 1; 
#20;
N = 0;
D = 0; 
rstn = 0;
#40;
rstn = 1;
#20;
N = 1; 
D = 0;
#20;
N = 1;
D = 0; 
#20;
N = 1;
D = 0; 
#20;
N = 0;
D = 0;
rstn = 0;
#40;
rstn = 1;
#20;
N = 1;
D = 0; 
#20;
N = 1;
D = 0; 
#20;
N = 0;
D = 1; 
#20;
N = 0;
D = 0;
rstn = 0;
#40;
rstn = 1;
#20;
N = 0;
D = 1; 
#20;
N = 1;
D = 0; 
#20;
N = 0;
D = 0;
rstn = 0;
#40;
rstn = 1;
#20;

// terminate simulation
$finish();
end

// Clock generator logic
always@(clock) begin
  #10ns clock <= !clock;
end
endmodule