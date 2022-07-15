`timescale 1ns/1ns
//Integer Multiplier Testbench Code
module booth_multiplier_testbench;
	
parameter N = 4;
logic signed [N-1:0] multiplicand, multiplier;
logic signed [(2*N)-1:0] product, l_product;
logic done, clock, reset, start;

// Instantiate design under test
booth_multiplier #(
	.N(N)) design_instance (
	.clock(clock),
  	.reset(reset),
  	.start(start),
  	.multiplicand(multiplicand),
  	.multiplier(multiplier),
  	.product(product),
  	.done(done)
);

initial begin
	
	// Initialize Inputs
	reset = 1;
	clock = 1;
	multiplicand = 0;
	multiplier = 0;
	start = 0;

	// Generate Reset
	#20;
	reset = 0;
	#20;

	// Initialize multiplicand, multiplier and generate start pulse
	multiplicand = -5;
	multiplier = -3;
	start = 1;
	#20;
	start = 0;
	
	// Wait for product to be available from design
	wait (done == 1);
	
	// Check if interger_divider design generates correct product value for given multiplicand and multiplier 
	l_product = multiplicand * multiplier;
	if (product == l_product)
	  $display(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Correct Result\n", $time, multiplicand, multiplier, l_product, done);
	else
	  $error(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Incorrect Result\n", $time, multiplicand, multiplier, l_product, done);
	
	// Wait for de-assertion of done from desgin before loading new values of multiplicand and multiplier
	wait(done == 0);
	#20
	
	// Initialize multiplicand, multiplier and generate start pulse
	multiplicand = -8;
	multiplier = 4;
	start = 1;
	#20;
	start = 0;
	
	// Wait for product to be available from design
	wait(done == 1);
	
	// Check if interger_divider design generates correct product value for given multiplicand and multiplier 
	l_product = multiplicand * multiplier;
	if (product == l_product)
	  $display(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Correct Result\n", $time, multiplicand, multiplier, l_product, done);
	else
	  $error(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Incorrect Result\n", $time, multiplicand, multiplier, l_product, done);
	
	// Wait for de-assertion of done from desgin before loading new values of multiplicand and multiplier
	wait(done == 0);
	#20
	
	// Initialize multiplicand, multiplier and generate start pulse
	multiplicand = 7;
	multiplier = 9;
	start = 1;
	#20;
	start = 0;
	
	// Wait for product to be available from design
	wait(done == 1);
	
	// Check if interger_divider design generates correct product value for given multiplicand and multiplier 
	l_product = multiplicand * multiplier;
	if (product == l_product)
	  $display(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Correct Result\n", $time, multiplicand, multiplier, l_product, done);
	else
	  $error(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Incorrect Result\n", $time, multiplicand, multiplier, l_product, done);
	
	// Wait for de-assertion of done from desgin before loading new values of multiplicand and multiplier
	wait(done == 0);
	#20

	// Initialize multiplicand, multiplier and generate start pulse
	multiplicand = -8;
	multiplier = -8;
	start = 1;
	#20;
	start = 0;
	
	// Wait for product to be available from design
	wait(done == 1);
	
	// Check if interger_divider design generates correct product value for given multiplicand and multiplier 
	l_product = multiplicand * multiplier;
	if (product == l_product)
	  $display(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Correct Result\n", $time, multiplicand, multiplier, l_product, done);
	else
	  $error(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Incorrect Result\n", $time, multiplicand, multiplier, l_product, done);
	
	// Wait for de-assertion of done from desgin before loading new values of multiplicand and multiplier
	wait(done == 0);
	#20

		
	// Initialize multiplicand, multiplier and generate start pulse
	multiplicand = -8;
	multiplier = 7;
	start = 1;
	#20;
	start = 0;
	
	// Wait for product to be available from design
	wait(done == 1);
	
	// Check if interger_divider design generates correct product value for given multiplicand and multiplier 
	l_product = multiplicand * multiplier;
	if (product == l_product)
	  $display(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Correct Result\n", $time, multiplicand, multiplier, l_product, done);
	else
	  $error(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Incorrect Result\n", $time, multiplicand, multiplier, l_product, done);
	
	// Wait for de-assertion of done from desgin before loading new values of multiplicand and multiplier
	wait(done == 0);
	#20
	
	// Initialize multiplicand, multiplier and generate start pulse
	multiplicand = 0;
	multiplier = -8;
	start = 1;
	#20;
	start = 0;
	
	// Wait for product to be available from design
	wait(done == 1);
	
	// Check if interger_divider design generates correct product value for given multiplicand and multiplier 
	l_product = multiplicand * multiplier;
	if (product == l_product)
	  $display(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Correct Result\n", $time, multiplicand, multiplier, l_product, done);
	else
	  $error(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Incorrect Result\n", $time, multiplicand, multiplier, l_product, done);
	
	// Wait for de-assertion of done from desgin before loading new values of multiplicand and multiplier
	wait(done == 0);
	#20

	
	// Initialize multiplicand, multiplier and generate start pulse
	multiplicand = -8;
	multiplier = 0;
	start = 1;
	#20;
	start = 0;
	
	// Wait for product to be available from design
	wait(done == 1);
	
	// Check if interger_divider design generates correct product value for given multiplicand and multiplier 
	l_product = multiplicand * multiplier;
	if (product == l_product)
	  $display(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Correct Result\n", $time, multiplicand, multiplier, l_product, done);
	else
	  $error(" time=%0t   Multiplicand=%d   Multiplier=%d   Product=%d   Done=%d  Incorrect Result\n", $time, multiplicand, multiplier, l_product, done);
	
	// Wait for de-assertion of done from desgin before loading new values of multiplicand and multiplier
	wait(done == 0);
	#20


	// Wait for 10ns
	#200ns;
	
	// Terminate simulation
	$finish();
end
	
// Clock generator logic
always@(clock) begin
	#10ns clock <= !clock;
end
	
endmodule
	
	
	
	
	
	
	
	
	
	
	
