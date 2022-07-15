// Barrel Shifter RTL Model
`include "mux_2x1.sv"
module barrel_shifter (
	input logic select,  // select=0 shift operation, select=1 rotate operation
	input logic direction, // direction=0 right move, direction=1 left move
	input logic[1:0] shift_value, // number of bits to be shifted (0, 1, 2 or 3)
	input logic[3:0] din,
	output logic[3:0] dout
);

	logic[3:0] temp_din, temp_dout;
	logic mux2_port1, mux3_port1, mux7_port1;
	logic mux0_out, mux1_out, mux2_out, mux3_out;

	always_comb begin
		if (direction == 1) begin
			temp_din[0] = din[3];
			temp_din[1] = din[2];
			temp_din[2] = din[1];
			temp_din[3] = din[0];
		end
		else temp_din = din;
	end

	always_comb begin : selectionLogic
		if (select == 0) begin
			mux2_port1 = 0;
			mux3_port1 = 0;
			mux7_port1 = 0;
		end
		else begin
			mux2_port1 = temp_din[0];
			mux3_port1 = temp_din[1];
			mux7_port1 = mux0_out;
		end
	end

	mux_2x1 mux0 (
		.in0(temp_din[0]),
		.in1(temp_din[2]),
		.sel(shift_value[1]),
		.out(mux0_out)
	);

	mux_2x1 mux1 (
		.in0(temp_din[1]),
		.in1(temp_din[3]),
		.sel(shift_value[1]),
		.out(mux1_out)
	);

	mux_2x1 mux2 (
		.in0(temp_din[2]),
		.in1(mux2_port1),
		.sel(shift_value[1]),
		.out(mux2_out)
	);

	mux_2x1 mux3 (
		.in0(temp_din[3]),
		.in1(mux3_port1),
		.sel(shift_value[1]),
		.out(mux3_out)
	);

	mux_2x1 mux4 (
		.in0(mux0_out),
		.in1(mux1_out),
		.sel(shift_value[0]),
		.out(temp_dout[0])
	);

	mux_2x1 mux5 (
		.in0(mux1_out),
		.in1(mux2_out),
		.sel(shift_value[0]),
		.out(temp_dout[1])
	);

	mux_2x1 mux6 (
		.in0(mux2_out),
		.in1(mux3_out),
		.sel(shift_value[0]),
		.out(temp_dout[2])
	);

	mux_2x1 mux7 (
		.in0(mux3_out),
		.in1(mux7_port1),
		.sel(shift_value[0]),
		.out(temp_dout[3])
	);

	always_comb begin
		if (direction == 1) begin
			dout[3] = temp_dout[0];
			dout[2] = temp_dout[1];
			dout[1] = temp_dout[2];
			dout[0] = temp_dout[3];
		end
		else dout = temp_dout;
	end

endmodule: barrel_shifter


