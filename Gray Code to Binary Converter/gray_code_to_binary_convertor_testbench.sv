//gray code to binary convertor testbench code
`timescale 1ns/1ns
module gray_to_binary_convertor_testbench;
parameter N=4;
logic clock, rstn;
logic [N-1:0] gray_value, binary_value;

// Instantiate design under test
gray_code_to_binary_convertor #(.N(N)) design_instance(
.clk(clock),
.rstn(rstn),
.gray_value(gray_value),
.binary_value(binary_value)
);

initial begin
// Initialize Inputs
rstn = 0;
clock = 0;

// Wait 20 ns for global reset to finish and start counter
#20;
rstn = 1;

// Drive gray value
for(int i=0; i<16; i++) begin
 #20;
 gray_value = i;
end

// Wait for 20ns 
#20ns;

// terminate simulation
$finish();
end

// Clock generator logic
always@(clock) begin
  #10ns clock <= !clock;
end
endmodule