// UART Control System Top Level Module
`include "../uart_top/uart_top.sv"
module uart_control_system #(parameter NUM_CLKS_PER_BIT=16, parameter NUM_OF_BYTES=4) (
	input logic clock, rstn,  // posedge clock and synchronous active low reset
	output logic[3:0] mem_write_addr, // memory write address generated to write RAM in testbench
	output logic[7:0] mem_write_data, // memory write data generated to write data to RAM in testbench
	output logic mem_write_enable, // memory write enable generated to enable writing to RAM in testbench
	input  logic[7:0] mem_read_data, // memory read data returned from ROM in testbench
	output logic[3:0] mem_read_addr, // memory read address generated to read ROM in testbench
	output logic mem_read_enable, // memory read enable generated to enable reading of ROM in testbench
	output logic transmission_done, // indicates all data bytes have been transmitted by uart tx control system
	output logic message_received); // indicates all data bytes have been received by uart rx control system

	// local variable
	logic tx_start;
	logic tx_done;
	logic [7:0] tx_data;
	logic [7:0] rx_data;
	logic rx_done;

	// Instantiate UART TX CONTROL Module
	uart_tx_control #(.NUM_OF_BYTES(NUM_OF_BYTES)) tx_control_fsm(
		.clk(clock),
		.rstn(rstn), 
		.mem_read_data(mem_read_data), // connect to mem_read_data input primary port
		.mem_read_addr(mem_read_addr), // connect to mem_read_addr output primary port
		.mem_read_enable(mem_read_enable), // connect to mem_read_enable output primary port
		.transmission_done(transmission_done), // connect to transmission_done output primary port
		.uart_tx_done(tx_done), // connect to tx_done coming from uart_top module instance
		.uart_tx_data(tx_data), // connect to tx_data going into uart_top module instance
		.uart_tx_start(tx_start) // connect to tx_start going into uart_top module instance
	);

	// Instantiate UART RX CONTROL Module
	// Note : Student to make connections below for uart_rx_control module instantiation
	uart_rx_control #(.NUM_OF_BYTES(NUM_OF_BYTES)) rx_control_fsm(
		.clk(clock),
		.rstn(rstn), 
		.mem_write_data(mem_write_data),  // connect to mem_write_data output primary port
		.mem_write_addr(mem_write_addr),  // connect to mem_write_addr output primary port
		.mem_write_enable(mem_write_enable), // connect to mem_write_enable output primary port
		.message_received(message_received),  // connect to message_received output primary port
		.uart_rx_done(rx_done), // connect to rx_done coming from uart_top module instance
		.uart_rx_data(rx_data) // connect to rx_data coming from uart_top module instance
	);

	// Instantiate UART TOP Module
	// uart_top module code has two child modules instantiated : uart_rx and uart_tx modules 
	// and uart_tx outout tx signal is connected to input rx signal of uart_rx module
	// See definition of uart_top in uart_top.sv
	uart_top #(.NUM_CLKS_PER_BIT(NUM_CLKS_PER_BIT)) uart_top_inst(
		.tx_clk(clock),
		.tx_rstn(rstn),
		.rx_clk(clock),
		.rx_rstn(rstn),
		.tx_start(tx_start),  // connected to uart_tx_start port of uart_tx_control module instance
		.tx_done(tx_done),  // connected to uart_tx_done port of uart_tx_control module instance
		.tx_din(tx_data),  // connected to uart_tx_data port of uart_tx_control module instance
		.rx_done(rx_done), // connected to uart_rx_done port of uart_rx_control module instance
		.rx_dout(rx_data) // connected to uart_rx_data port of uart_rx_control module instance
	);

endmodule : uart_control_system