`timescale 1ns/1ps
`include "carry_lookahead_adder.sv"

module integer_multiplier // Module start declaration
#(parameter N=4) // Parameter declaration
(
	input clock, reset, start,
	input logic[N-1:0] multiplicand, multiplier,
	output logic[(2*N):0] product, 
	output logic done);

	// Count variable for ADD/SHIFT stages
	logic [$clog2(N)-1:0] count;

	// Register to load multiplicand value
	logic[N-1:0] load_reg;

	// Register to store Adder sum and multipiler
	logic[(2*N):0] shift_reg;

	// wires to connect with carry lookahead adder
	logic[N-1:0] add_operand1, add_operand2;
	logic[N:0] sum;

	// next_state encoding and next_state variable
	enum logic[2:0]{
		IDLE             = 3'b000,
		INITIALIZE       = 3'b001,
		TEST             = 3'b010,
		ADD              = 3'b011,
		SHIFT_AND_COUNT  = 3'b100,
		DONE             = 3'b101
	} next_state;


	// Instantiate N-bit carry lookahead adder 
	// Pass add_operand1, add_operand2 and sum
	// Tie CIN to '0'
	carry_lookahead_adder #(.N(N)) adder_inst( 
		.A(add_operand1),
		.B(add_operand2),
		.result(sum),
		.CIN(0)
	);


	// Control FSM for Integer Multiplier
	// Use Single always block FSM approach
	// Use *only* non-blocking assignment statements within always block
	always_ff@(posedge clock, posedge reset) begin
		if(reset) begin
			count <= 0;
			next_state <= IDLE;
			load_reg <= 0;
			shift_reg <= 0;
		end
		else begin
			case(next_state)
				// Intialized count, load_reg, shift reg to 0
				// Wait for start signal.
				// if start is '1' then move to INITIALIZE otherwise say in IDLE state
				IDLE: begin
					if (start == 1) next_state <= INITIALIZE;
					else next_state <= IDLE;
				end

				// Load Multiplicand and Multiplier in a load register and a shift register
				// Initialize count to 0 and then set next_state to TEST
				INITIALIZE: begin
					shift_reg <= {1'b0, {N{1'b0}}, multiplier};
					load_reg <= multiplicand;
					count <= 0;
					next_state <= TEST;
				end

				// Check shift register LSB and based on that perform ADD/Shift operation
				// if LSB='1' then perform ADD followed by Right Shift by 1
				// if LSB='0' then perform Right Shift by 1
				TEST: begin
					if(shift_reg[0] == 1'b1) begin
						// Pass Multiplicand to carry lookadahead adder one of the input  (add_operand1)
						// Pass to carry lookahead adder second input add_operand2, the previous stage adder output value to add with Multiplicand. (shift_reg[(2*N)-1:N])
						// Move to ADD state
						add_operand1 <= load_reg;
						add_operand2 <= shift_reg[(2*N)-1:N];
						next_state <= ADD;
					
					end
					else begin
						// Since no add operation to be performed pass 0 to carry lookadder input one of the input (add_operand1)
						// Pass to carry lookahead adder second input add_operand1, the previous stage adder output value (shift_reg[(2*N)-1:N])
						// move to shift and increment count state (SHIFT_AND_COUNT)
						add_operand1 <= 0;
						add_operand2 <= shift_reg[(2*N)-1:N];
						next_state <= SHIFT_AND_COUNT;
					end
				end

				ADD: begin
					shift_reg <= {sum, shift_reg[N-1:0]}; // Load shift register : Output sum from Adder which includes carry and retain previous lower bit of shift register
					// move to shift and increment count state (SHIFT_AND_COUNT)
					next_state <= SHIFT_AND_COUNT;
			
				end

				SHIFT_AND_COUNT: begin
					// Right shift entire shift_reg by 1 position and store result in shift_reg
					// Increment count 
					shift_reg <= shift_reg >> 1;
					count <= count + 1;

					if(count == N-1) begin // If 'N' times SHIFT operation performed then move to Done state else go back to Test state
						next_state <= DONE;
					end
					else begin
						next_state <= TEST;
					end
				end
			
				DONE: begin
					next_state <= IDLE; // Wait for right shift value to be available. THis is the final product value.
				end
			endcase
		end
	end

	// Generate done=1 when FSM reaches DONE state
	assign done = (next_state == DONE) ? 1 : 0;

	// Generate Product in DONE state by loading shift_reg value to it
	assign product = (next_state == DONE) ? shift_reg : 0;

endmodule: integer_multiplier

