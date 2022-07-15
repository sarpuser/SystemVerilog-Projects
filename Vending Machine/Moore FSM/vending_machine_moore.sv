// Vending Machine RTL Code
module vending_machine_moore( 
	input logic clk, rstn,  
	input logic N, D,
	output logic open);
	
	// state variables and state encoding parameters
	parameter[1:0] CENTS_0=2'b00, CENTS_5=2'b01, CENTS_10=2'b10, CENTS_15=2'b11;
	logic[1:0] present_state, next_state; 

	// Sequential Logic for present state
	always_ff@(posedge clk) begin
		if (!rstn) begin
			present_state <= CENTS_0;
		end
		else present_state <= next_state;
	end

	// Combination Logic for Next State and Output
	always_comb begin 
		case (present_state)
			CENTS_0: begin
				open = 0;
				if (N == 1) next_state = CENTS_5;
				else if (D == 1) next_state = CENTS_10;
				else next_state = CENTS_0;
			end
			CENTS_5: begin
				open = 0;
				if (N == 1) next_state = CENTS_10;
				else if (D == 1) next_state = CENTS_15;
				else next_state = CENTS_5;
			end
			CENTS_10: begin
				open = 0;
				if (N == 1 || D == 1) next_state = CENTS_15;
				else next_state = CENTS_10;
			end
			CENTS_15: begin
				open = 1;
				next_state = CENTS_0;
			end
			default: next_state = CENTS_0;
		endcase
	end
endmodule: vending_machine_moore

