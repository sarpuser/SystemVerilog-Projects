//RTL Model for Linear Feedback Shift Register
module lfsr
#(parameter N = 4) // Number of bits for LFSR
(
	input logic clk, reset, load_seed,
	input logic[N-1:0] seed_data,
	output logic lfsr_done,
	output logic[N-1:0] lfsr_data
);

	logic xor_result;

	always_ff @(posedge clk, negedge reset) begin 
		if (!reset) lfsr_done <= 1'b0;
		else if (load_seed) lfsr_data <= seed_data;
		else if (!lfsr_done) begin
			unique case (N)	
				2: xor_result = lfsr_data[1] ^ lfsr_data[0];
				3: xor_result = lfsr_data[2] ^ lfsr_data[1];
				4: xor_result = lfsr_data[3] ^ lfsr_data[2];
				5: xor_result = lfsr_data[4] ^ lfsr_data[2];
				6: xor_result = lfsr_data[5] ^ lfsr_data[4];
				7: xor_result = lfsr_data[6] ^ lfsr_data[5];
				8: xor_result = lfsr_data[7] ^ lfsr_data[5] ^ lfsr_data[4] ^ lfsr_data[3];
			endcase
			lfsr_data = lfsr_data << 1;
			lfsr_data[0] = xor_result;
			if (lfsr_data == seed_data) begin
				lfsr_done = 1'b1;
			end
		end
	end
 
endmodule: lfsr