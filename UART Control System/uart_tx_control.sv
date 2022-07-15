// UART TX CONTROL RTL Code
module uart_tx_control #(parameter NUM_OF_BYTES = 4)
(
	input logic clk, rstn, // clock, synchronous active low reset 
	input logic[7:0] mem_read_data, // input data bytes from memory
	output logic [3:0] mem_read_addr, // address to memory to read input data bytes
	output logic mem_read_enable, // if set to '0', read data bytes from memory
	output logic transmission_done, // set to '1' by FSM when all data bytes are transmitted to receiver
	input logic uart_tx_done, // comes from uart_tx FSM as indication that data byte requested by tx control FSM has been transmissted to uart receiver
	output logic [7:0] uart_tx_data, // data byte sent to uart_tx FSM to transmit serially data to uart_rx
	output logic uart_tx_start); // tx control FSM instructs uart_tx FSM to start data byte transmission to uart_rx


	// Variable to count number of data bytes transmitted
	integer j;

	// state encoding and state variable
	enum logic[2:0]{
		IDLE                = 3'b000,  // IDLE FSM State
		READ                = 3'b001,  // Memory Read FSM State to read input message data byte
		DELAY               = 3'b010,  // Wait for Read data from memory in testbench to be available in tx control FSM
		TRANSMIT            = 3'b011,  // Send data byte to uart_tx FSM and instruct uart_tx FSM to start serial data transmission to uart_rx
		WAIT                = 3'b100   // Waits for tx done from uart_tx FSM which indicates uart_tx has transmitted 1 data byte to uart_rx 
	} state;

	// FSM with single always block for next state, 
	// present state flipflop and output logic 
	// Note : use non-blocking assignment statement in always_ff block. 
	// Do not have any blocking assignment statements inside alwaya_ff block
	always_ff@(posedge clk) begin
		if(!rstn) begin
			mem_read_addr <= 0;
			mem_read_enable <= 0;        
			transmission_done <= 0;
			uart_tx_data <= 0;
			uart_tx_start <= 0;
			state <= IDLE;
			j <= 0;
		end
		else begin
			case(state)
				// Initialize memory read address, read enable control signals to 0
				// Initialize transmission_done, uart_tx_dtata, uart_tx_start, j to 0
				// Then move to READ state
				IDLE: begin
					mem_read_addr <= 0;
					mem_read_enable <= 0;       
					transmission_done <= 0;
					uart_tx_data <= 0;
					uart_tx_start <= 0;
					state <= READ;
					j <= 0;
				end
				
				// Read all data bytes from ROM model which is instantiated in testbench
				// To achieve this set mem_read_data to '1' and set mem_read_addr to value 'j'
				// j is incrementing memory address value it should be set in READ state
				// Check if all 'j' count is les then NUM_OF_BYTES. i.e. if all data bytes from ROM
				// in testbench has been transmitted by uart_tx to uart_rx
				// If all data bytes transmitted then move to IDLE state and reset mem_read_enable to 0
				// otherwise read next data byte from ROM memory in testbench and then move to DELAY sate
				READ: begin
					if(j < NUM_OF_BYTES) begin
						// Note : Do not have mem_read_addr = mem_read_addr + 1 instead assign j to mem_read_addr
						// as 'j' has been already incremented in wait state and new value is available to indicate next read address
						mem_read_addr <= j;
						mem_read_enable <= 1;
						state <= DELAY;
					end
					else begin
						state <= IDLE;
					end
				end
				
				// Important : ROM/RAM memory will take 1 cycle to provide data on mem_read_data
				// after mem_read_enable is set to '1'
				// mem_read_enable is set to '1' in READ FSM, so this DELAY sate is required
				// before read data byte is further sent by uart_tx_control FSM to uart_tx input din port
				// Then move to TRANSMIT state
				DELAY: begin
					state <= TRANSMIT;
				end
				
				// Indicate uart_tx FSM that din data bye is available for transmission and
				// uart_tx should start serial transmission each bit in data byte to uart_rx
				// To do this, set uart_tx_start to '1' and pass mem_read_data to uart_tx_data   
				// Then move to WAIT state
				TRANSMIT: begin
					uart_tx_start <= 1;
					uart_tx_data <= mem_read_data;
					state <= WAIT;
				end
				
				// Wait until uart_tx has completed serial transmission of data byte to uart_rx
				// To achieve this wait for uart_tx_done == 1 which is coming from uart_tx to uart_tx_control FSM
				// And then increment 'j' by '1' to indicate 1 data byte has been sent to uart_rx
				// Then move to READ sate if uart_tx_done is '1' otherwise staye in WAIT state 
				// until uart_tx_done from uart_tx FSM is '1'
				WAIT: begin
					if(uart_tx_done == 1) begin
						// Remember to increment j <= j + 1 here
						j <= j + 1;
						state <= READ;
					end
					else begin
						state <= WAIT;
					end
				end

				// In Default state move to IDLE state	  
				default: begin
					state <= IDLE;
				end
			endcase
		end
	end
endmodule: uart_tx_control


