`timescale 1ns/1ps
`include "carry_lookahead_adder.sv"

module booth_multiplier // Module start declaration
#(parameter N=4) // Parameter declaration
(
	input clock, reset, start,
	input logic signed [N-1:0] multiplicand, multiplier,
	output logic signed [(2*N)-1:0] product,
	output logic done);

	//Variable to store 2's complement of Multiplicand
	logic [N:0] multiplicand_neg;

	// Count variable for ADD/SHIFT stages
	logic [$clog2(N)-1:0] count;

	// Register to store Adder sum and multipiler
	logic signed [(2*N)+1:0] shift_reg;

	// Register to load multiplicand value
	logic signed [N:0] load_reg_pos;
	logic signed [N:0] load_reg_neg;

	// wires to connect with carry lookahead adder
	logic[N:0] add_operand1, add_operand2;
	logic[N:0] sum;
	logic cla_carry;

	// next_state encoding and next_state variable
	enum logic[2:0]{
		IDLE             = 3'b000,
		INITIALIZE       = 3'b001,
		TEST             = 3'b010,
		ADD              = 3'b011,
		SHIFT_AND_COUNT  = 3'b100,
		DONE             = 3'b101
	} next_state;

	// Instantiate (N+1)-bit carry lookahead adder 
	//Use add_operand1, add_operand2, sum to connect carry lookahead adder
	//Hint: Carry out from the adder is ignored in our calculations and output sum
	//has same length as add_operand1 and add_operand2
	// Tie CIN to '0'
	carry_lookahead_adder #(.N(N+1)) adder_inst(
		.A(add_operand1),
		.B(add_operand2),
		.result({cla_carry, sum}),
		.CIN(0)
	);

	// Create negative multiplicand value
	assign multiplicand_neg = -multiplicand;


	// Control FSM for Signed Multiplier
	// Use Single always block FSM approach
	// Use *only* non-blocking assignment statements within always block
	always_ff@(posedge clock, posedge reset) begin
		if(reset) begin
			count <= 0;
			next_state <= IDLE;
			load_reg_pos <= 0;
			load_reg_neg <= 0;
			shift_reg <= 0;
		end
		else begin
			case(next_state)
				// Wait for start signal
				IDLE: begin
					if (start == 1) next_state <= INITIALIZE;
					else next_state <= IDLE;
				end

				// Load Multiplicand and Multiplier in a load register and a shift register
				INITIALIZE: begin
					// load multiplicand to load_reg_pos
					load_reg_pos <= multiplicand;
					// load multiplicand_neg[N:0] to load_reg_neg
					load_reg_neg <= multiplicand_neg;
					shift_reg 	<= {1'b0, {N{1'b0}}, multiplier, 1'b0};
					count		<= 0;	
					next_state 	<= TEST;
				end

				// Check shift register LSB and based on that perform ADD/Shift operation
				// if last 2 LSB='01' then perform ADD with positive multiplicand followed by Right Shift by 1
				// if last 2 LSB='10' then perform ADD with negative multiplicand followed by Right Shift by 1
				// if last 2 LSB='00' then perform Right Shift by 1
				// if last 2 LSB='11' then perform Right Shift by 1
				TEST: begin
					if(shift_reg[1:0] == 2'b01) begin
						// Pass positive Multiplicand to carry lookadahead adder input
						// Pass previous adder output value after shift to add with Multiplicand
						// move to add state
						add_operand1 <= load_reg_pos;
						add_operand2 <= shift_reg[(2*N)+2:N+1];
						next_state <= ADD;
					end
					else if(shift_reg[1:0] == 2'b10) begin
						// Pass negative Multiplicand to carry lookadahead adder input
						// Pass previous adder output value after shift to add with Multiplicand
						// move to add state
						add_operand1 <= load_reg_neg;
						add_operand2 <= shift_reg[(2*N)+2:N+1];
						next_state <= ADD;
					end
					else begin
						// assign add_operand1 to 0, Since no add operation to be perform pass 0 to carry lookadder input
						// Pass previous adder output value after shift to add with Multiplicand	
						// move to shift and increment count state
						add_operand1 <= 0;
						add_operand2 <= shift_reg[(2*N)+2:N+1];
						next_state <= SHIFT_AND_COUNT;
					end
				end

				ADD: begin
					shift_reg <= {sum, shift_reg[N:0]}; // Load shift register : Output sum from Adder which includes carry and retain previous lower bit of shift register
					// Move to shift and increment count state
					next_state <= SHIFT_AND_COUNT;
				end

				SHIFT_AND_COUNT: begin
					shift_reg <= (shift_reg >>> 1); // Right Arithmetic shift entire shift register by 1 position
					// Increment count
					count <= count + 1;

					if(count == N-1) begin // If 'N' times SHIFT operation performed then move to Done state else go back to Test state
						next_state <= DONE;
					end
					else begin
						next_state <= TEST;
					end
				end

				DONE: begin
					next_state <= IDLE; // Wait for right shift value to be available. This is the final product value.
				end
			endcase
		end
	end

	// Generate done=1 when FSM reaches DONE state
	assign done = (next_state == DONE) ? 1 : 0;

	// Generate Product in DONE state by loading shift_reg value to it
	assign product = (next_state == DONE) ? {shift_reg[(2*N)], shift_reg[(2*N):1]} : 0;

endmodule: booth_multiplier

