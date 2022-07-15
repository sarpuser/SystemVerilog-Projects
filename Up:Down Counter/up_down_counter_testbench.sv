//4-bit counder testbench code
`timescale 1ns/1ns
module up_down_counter_testbench;
logic clock, reset, select;
logic [3:0] count_value;

// Instantiate design under test
up_down_counter #(.WIDTH(4)) design_instance(
.clk(clock),
.clear(reset),
.select(select),
.count_value(count_value)
);

initial begin
// Initialize Inputs
reset = 1;
clock = 1;
select = 0;

// Wait 10 ns for global reset to finish and start counter
#20;
reset = 0;

// Wait for 320ns and reset counter
#320ns;
reset = 1;
select = 1;

#20ns;
reset = 0;

// Wait for 320ns and reset counter
#320ns;
reset=1;
select = 0;

// Wait for 10ns
#100ns;

// terminate simulation
$finish();
end

// Clock generator logic
always@(clock) begin
  #10ns clock <= !clock;
end

// Print input and output signals
initial begin
 $monitor(" time=%0t,  clear=%b  clk=%b  count=%d",$time, reset, clock, count_value);
end
endmodule