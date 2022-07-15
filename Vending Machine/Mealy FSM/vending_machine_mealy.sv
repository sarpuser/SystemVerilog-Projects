// Vending Machine RTL Code
module vending_machine_mealy( 
	input logic clk, rstn,  
	input logic N, D,
	output logic open);
	
	// State encoding and state variables
	parameter[1:0] CENTS_0=2'b00, CENTS_5=2'b01, CENTS_10=2'b10, CENTS_15=2'b11;
	logic[1:0] present_state, next_state; 

	// Local Variables for registering inputs N and D
	logic r_N, r_D;

	// Note : output open is not registered (i.e. no flipflop at output port
	// open) in this example for students to compare moore and mealy machine
	// waveform and see what is the different between mealy and moore
	// remember we learnt in class that mealy reacts immediately to change in input !!
	// Add flipflop for each input 'N' and 'D'
	// Sequential Logic for present state
	always_ff@(posedge clk) begin
		if(!rstn) present_state <= CENTS_0;
		else present_state <= next_state;
		r_N <= N;
		r_D <= D;
	end


	// Combination Logic for Next State and Output
	always_comb begin 
		case (present_state)
			CENTS_0: begin
				if (r_N == 1) begin
					next_state = CENTS_5;
					open = 0;
				end
				else if (r_D == 1) begin
					next_state = CENTS_10;
					open = 0;
				end
				else begin
					next_state = CENTS_0;
					open = 0;
				end
			end
			CENTS_5: begin
				if (r_N == 1) begin
					next_state = CENTS_10;
					open = 0;
				end
				else if (r_D == 1) begin
					next_state = CENTS_0;
					open = 1;
				end
				else begin
					next_state = CENTS_5;
					open = 0;
				end
			end
			CENTS_10: begin
				if (r_N == 1 || r_D == 1) begin
					next_state = CENTS_0;
					open = 1;
				end
				else begin
					next_state = CENTS_10;
					open = 0;
				end
			end
			default: begin
				next_state = CENTS_0;
				open = 0;
			end
		endcase
	end
endmodule: vending_machine_mealy
