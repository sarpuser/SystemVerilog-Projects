// Johnson Counter RTL Model
module johnson_counter (
	input logic clk, clear, preset,
	input logic[3:0] load_cnt,
	output logic[3:0] count
);
 always@(posedge clk or negedge clear) begin
	if(!clear) count = 4'b0000;
	else if (!preset) count = load_cnt;
	else begin
		count = {~count[0],count[3:1]};
	end
 end 
endmodule: johnson_counter
