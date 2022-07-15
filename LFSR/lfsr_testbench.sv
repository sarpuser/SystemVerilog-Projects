`timescale 1ns/1ns
//LFSR Testbench Code
module lfsr_testbench;
  parameter N = 4;
  logic clock;
  logic [N-1:0] lfsr_data, seed_data;
  logic lfsr_done;
  logic reset, load_seed;
  int runtime;
   
  lfsr #(.N(N)) design_inst(
   .clk(clock),
   .reset(reset),
   .load_seed(load_seed),
   .seed_data(seed_data),
   .lfsr_data(lfsr_data),
   .lfsr_done(lfsr_done)
  );
  
  initial begin
   // Initialize Inputs
   reset = 0;
   load_seed = 0;
   clock = 0;
   seed_data = 4'b0000;

   // Wait 10 ns for global reset to finish and start counter
   #10;
   reset = 1;

   #10;
   load_seed = 1;
   seed_data = 4'b1111;

   #20;
   load_seed = 0;

   runtime = (20 * (2**N - 1)) + 100;
   #runtime;
    
   // terminate simulation
   $finish();
  end

  // Clock generator logic
  always@(clock) begin
    #10ns clock <= !clock;
  end

  // Print input and output signals
  initial begin
   $monitor(" time=%0t,  reset=%b  clk=%b  load_seed=%b  count=%d", $time, reset, clock, load_seed, lfsr_data);
  end

endmodule