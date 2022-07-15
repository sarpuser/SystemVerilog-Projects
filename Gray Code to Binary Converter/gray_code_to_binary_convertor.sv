module gray_code_to_binary_convertor #(parameter N = 4)( 
	input logic clk, rstn, 
	input logic[N-1:0] gray_value,
	output logic[N-1:0] binary_value);
 
	always_ff @(posedge clk, negedge rstn) begin : gray2binary
		if (!rstn) begin
			binary_value <= 0;
		end
		else begin
			for (int i = N - 1; i >= 0 ; i--) begin
				if (i == N -1) binary_value[i] = gray_value[i];
				else binary_value[i] = gray_value [i] ^ binary_value[i + 1];
			end
		end
	end

endmodule: gray_code_to_binary_convertor
