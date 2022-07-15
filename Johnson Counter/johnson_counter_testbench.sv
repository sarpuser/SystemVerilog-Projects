`timescale 1ns/1ns
//Johnson Counter Testbench Code
module johnson_counter_testbench;
 logic clock, reset, preset;
 logic[3:0] load_cnt, count;

// Instantiate design under test
johnson_counter design_instance(
.clk(clock),
.clear(reset),
.preset(preset),
.load_cnt(load_cnt),
.count(count)
);

initial begin
// Initialize Inputs
reset = 0;
preset = 1;
clock = 0;
load_cnt = 4'b0000;

// Wait 10 ns for global reset to finish and start counter
#10;
reset = 1;

#10;
preset = 0;
load_cnt = 4'b0000;

#20;
preset = 1;

// Wait for 200ns and reset counter
#340ns;
reset=0;

// Wait for 20ns and start counter again
#20ns;
reset=1;

#10;
preset = 0;
load_cnt = 4'b1000;

#10;
preset = 1;

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
 $monitor(" time=%0t,  clear=%b  clk=%b  count=%d",$time, reset, clock, count);
end

endmodule