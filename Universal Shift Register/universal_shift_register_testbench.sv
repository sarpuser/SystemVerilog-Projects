`timescale 1ns/1ps
module universal_shift_register_testbench();
logic [3:0] din;
logic clock, reset, load;
logic [3:0] dout;
logic [2:0] shift_mode;
logic sin, sout;

// Instantiate universal shift register design module
universal_shift_register dut(
 .din(din),
 .dout(dout),
 .clk(clock),
 .reset(reset),
 .shift_mode(shift_mode),
 .load(load),
 .sin(sin),
 .sout(sout)
);


// Stimulus For Universal Shift Register Modes
initial begin
  // Initiliase Input Stimulus
  din = 0;
  clock = 1;
  reset = 1;
  shift_mode = 3'b000;
  load = 0;
  sin = 0;

  // Reset Universal Shift Register
  #200ns; 
  reset = 1'b0;

  // Test PIPO Mode
  #200ns; 
  shift_mode = 3'b00;
  din = 9;

  // Reset Universal Shift Register
  #200ns; 
  reset = 1'b1;
  #200ns;
  reset = 1'b0;

  // Test SIPO-L mode
  shift_mode = 3'b001;
  sin = 1'b1;

  #200ns; 
  sin = 1'b1;

  #200ns; 
  sin = 1'b0;

  #200ns; 
  sin = 1'b1;

  #200ns;

  // Reset Universal Shift Register
  reset = 1'b1;
  #200ns;
  reset = 1'b0; 

  // Test SIPO-R mode
  shift_mode = 3'b010;
  sin = 1'b0;

  #200ns; 
  sin = 1'b1;

  #200ns; 
  sin = 1'b1;

  #200ns; 
  sin = 1'b1;

  #200ns;

  // Reset Universal Shift Register
  reset = 1'b1;
  sin = 1'b0;
  #200ns;
  reset = 1'b0; 

  // Test PISO-L mode
  load = 1'b1;
  din = 13;

  #200ns;
  load = 1'b0;
  shift_mode = 3'b011;

  // wait for 4 clock cycles to serially shift values out
  #800ns;

  // Reset Universal Shift Register
  reset = 1'b1;
  sin = 1'b0;
  #200ns;
  reset = 1'b0; 


   // Test PISO-R mode
   load = 1'b1;
   din = 8;

   #200ns;
   load = 1'b0;
   shift_mode = 3'b100;

   // wait for 4 clock cycles to serially shift values out
   #800ns;

   // Reset Universal Shift Register
   reset = 1'b1;
   #200ns;
   reset = 1'b0; 

   // Test SISO-L mode
   shift_mode=3'b101;
   sin = 1'b1;

   #200ns; 
   sin = 1'b0;

   #200ns; 
   sin = 1'b1;

   #200ns; 
   sin = 1'b0;

   #1000ns;


   // Reset Universal Shift Register
   reset = 1'b1;
   #200ns;
   reset = 1'b0; 

   
   // Test SISO-R mode
   shift_mode=3'b110;
   sin = 1'b1;

   #200ns; 
   sin = 1'b1;

   #200ns; 
   sin = 1'b0;

   #200ns; 
   sin = 1'b1;

   #1000ns;


   // Reset Universal Shift Register
   reset = 1'b1;
   sin = 1'b0;
   #200ns;
   reset = 1'b0; 
   shift_mode = 3'b000;

   #400ns;

   // terminate simulation
   $finish();
end

// Clock generator logic
always@(clock) begin
  #100ns clock <= !clock;
end

// Print input and output signals
initial begin
 $monitor(" time=%0t,  clk=%b  reset=%b  shift_mode=%d, load=%d, din=%d, dout=%d",$time, clock, reset, shift_mode, load, din, dout);
end
endmodule