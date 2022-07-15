module carry_lookahead_adder#(parameter N=4)(
	input logic[N-1:0] A, B,
	input logic CIN,
	output logic[N:0] result);

	logic[N:0] c;
	
	always_comb begin : generate_propagate
		c[0] = CIN;
		for (int i = 0; i < N; i++) begin
			c[i + 1] = ((A[i] & B[i]) | ((A[i] | B[i]) & c[i]));
		end
		result[N] = c[N];
	end
	
	genvar i;
	generate 
		for (i = 0; i < N; i++) begin : fa_loop
			fulladder fa_inst (
			.a(A[i]),
			.b(B[i]),
			.cin(c[i]),
			.sum(result[i]),
			.cout()
			);
		end
	endgenerate
	
endmodule: carry_lookahead_adder
