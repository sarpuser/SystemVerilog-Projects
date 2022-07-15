// UART RX CONTROL RTL Code
module uart_rx_control #(parameter NUM_OF_BYTES = 16)
(
	input logic clk, rstn, // clock, synchronous active low reset 
	output logic[7:0] mem_write_data, // output data byte to be written to RAM memory
	output logic [3:0] mem_write_addr, // address to memory to write data byte received by uart_tx fsm
	output logic mem_write_enable, // if set to '1', write data byte to memory in testbench
	input  logic uart_rx_done, // comes from uart_rx FSM as indication that parallel data byte is received and available to be written in testbench RAM memory
	input  logic [7:0] uart_rx_data, // parallel data byte received from uart_rx FSM
	output logic message_received); // indicates that all data bytes are received by uart_rx FSM and written to RAM memory in testbench


	// local variable
	logic [7:0] received_data;

	// Variable to count number of data bytes received
	integer j;

	// state encoding and state variable
	enum logic[1:0]{
		IDLE     = 2'b00, // IDLE FSM state
		WAIT     = 2'b01, // FSM state to wait for uart_rx FSM to send data byte to uart_rx_control FSM
		WRITE    = 2'b10  // FSM state to write data byte to write to RAM memory in testbench
	} state;

	// FSM with single always block for next state, 
	// present state flipflop and output logic
	// Note : use non-blocking assignment statement in always_ff block. 
	// Do not have any blocking assignment statements inside alwaya_ff block
	always_ff@(posedge clk) begin
		if(!rstn) begin
			mem_write_addr <= 0;
			mem_write_data <= 0;
			mem_write_enable <= 0;        
			message_received <= 0;
			j <= 0;
			state <= IDLE;
		end
		else begin
			case(state)
				// Initialize memory write address, write enable control and memory write data signals to 0
				// Initialize message_received, j to 0
				// Then move to WAIT state
				IDLE: begin
					mem_write_addr <= 0;
					mem_write_data <= 0;
					mem_write_enable <= 0;         
					message_received <= 0;
					j <= 0;
					state <= WAIT;
				end
				
				// Wait for uart_rx FSM to indicate data byte is available
				// This is done by waiting for uart_rx_done == 1 and then read uart_rx_data sent by uart_rx FSM
				// and store it to received_data local variable. Then move to WRITE state to write data byte
				// to RAM memory in testbench
				// Check if all data bytes have been received from uart_rx FSM, if yes then move to WAIT state otherwise
				// wait for uart_rx_done == 1 as mentioned above.
				WAIT: begin
					if(j < NUM_OF_BYTES) begin
						if(uart_rx_done == 1) begin
							received_data <= uart_rx_data;
							state <= WRITE;
						end
						else begin
							state <= WAIT;
						end
					end
					else begin
						message_received <= 1;
						state <= IDLE;
					end
				end
				
				// Write data byte to RAM memory inside testbench
				// This can be achieved by setting mem_write_enable to 1, set mem_write_addr to 'j' to increment
				// memory address and copy received_data to mem_write_data
				WRITE: begin
					// Note : Do not have mem_write_addr = mem_write_addr + 1 instead assign j to mem_write_addr as shown below
					j <= j + 1;
					mem_write_addr <= j; 
					mem_write_enable <= 1;
					mem_write_data <= received_data;
					state <= WAIT;
				end

				// In Default state move to IDLE state	  
				default: begin
					state <= IDLE;
				end
			endcase
		end
	end
endmodule: uart_rx_control



