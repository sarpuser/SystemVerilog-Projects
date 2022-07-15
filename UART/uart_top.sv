// UART TX RTL Code
`include "uart_rx/uart_rx.sv"
`include "uart_tx/uart_tx.sv"
module uart_top #(parameter NUM_CLKS_PER_BIT=16) (
	input logic tx_clk, tx_rstn, rx_clk, rx_rstn,  
	input logic[7:0] tx_din,
	input logic tx_start,
	output logic tx_done, rx_done,
	output logic[7:0] rx_dout);


	// wire to connect output of uart_tx "tx" signal to
	// uart_rx "rx" signal
	logic serial_data_bit;

	uart_tx tx_inst (
		.clk(tx_clk),
		.rstn(tx_rstn),
		.din(tx_din),
		.start(tx_start),
		.done(tx_done),
		.tx(serial_data_bit)
	);


	// Instantiate uart receiver module
	uart_rx rx_inst (
		.clk(rx_clk),
		.rstn(rx_rstn),
		.rx(serial_data_bit),
		.done(rx_done),
		.dout(rx_dout)
	);

endmodule: uart_top


