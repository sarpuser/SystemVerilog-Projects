// UART TX RTL Code
module uart_tx #(parameter NUM_CLKS_PER_BIT=16) (
	input logic clk, rstn,  
	input logic[7:0] din, // input parallel 8-bit data
	input logic start, // input start bit indicating new 8-bit data can be sampled by Uart Tx
	output logic done,// output done indidcates 8-bit parallel data is serially transmitted by Uart Tx
	output logic tx); // serial 8-bit data output from uart tx


	// count variable
	logic [$clog2(NUM_CLKS_PER_BIT)-1:0] count;

	// state encoding and state variable
	enum logic[2:0]{
		TX_IDLE       = 3'b000,
		TX_START_BIT  = 3'b001,
		TX_DATA_BIT   = 3'b010,
		TX_STOP_BIT   = 3'b011,
		TX_CLEANUP    = 3'b100
	} state;

	// data index bit
	logic [2:0] bit_index;

	// UART TX Format
	// TX_START_BIT -> 8 DATA_BITS Transmitted one at at time -> STOP_BIT
	// TX_SART_BIT is 0 (1 to 0 transition is detected as start bit)
	// TX_STOP_BIT is 1

	// FSM with single always block for next state, 
	// present state flipflop and output logic 
	always_ff@(posedge clk) begin
		if(!rstn) begin
			count <= 0;
			state <= TX_IDLE;
			bit_index <= 0;
			tx <= 1'bz; // changed from 0
			done <= 0;
		end
		else begin
			case(state)
				TX_IDLE: begin
					count <= 0;
					// Output tx = 1 indicates stop state
					tx <= 1;
					done <= 0;
					bit_index <= 0;
					// If start is set to '1' then start sampling UART Tx packet START BIT from next cycle
					if(rstn==1 && start == 1) state <= TX_START_BIT;
					else state<= TX_IDLE;
				end

				TX_START_BIT: begin
					// Output rx = 0 indicates as start bit
					tx<=0;  
					done <= 0;
					bit_index <= 0;
					// Transmit START BIT for NUM_CLKS_PER_BIT period
					if(count == (NUM_CLKS_PER_BIT-1)) begin
						state <= TX_DATA_BIT;
						count <= 0;
					end else begin
						state <= TX_START_BIT;
						count <= count + 1;
					end
				end

				TX_DATA_BIT: begin
					tx <= din[bit_index];
					done <= 0;
					// Transmit START BIT for NUM_CLKS_PER_BIT period
					if(count == (NUM_CLKS_PER_BIT-1)) begin
						count <= 0;
						// Check if all 8 data bits are transmitted
						if(bit_index == 7) begin
							bit_index <= 0;
							state <= TX_STOP_BIT;
						end
						else begin
							bit_index <= bit_index + 1;
							state <= TX_DATA_BIT;
						end
					end
					else begin 
						state <= TX_DATA_BIT; 
						count <= count + 1;
					end
				end

				TX_STOP_BIT: begin
					tx <= 1;
					bit_index <= 0;
					// Transmit STOP BIT for NUM_CLKS_PER_BIT period
					if(count == (NUM_CLKS_PER_BIT-1)) begin
						state <= TX_CLEANUP;
						count <= 0;
						// Generate Done=1 which indicates that UART TX has converted 
						// 8 paralle data bits into serial data bits and 
						// available on output tx signal
						done <= 1;
					end
					else begin
						state <= TX_STOP_BIT;
						count <= count + 1;
					end
				end

				TX_CLEANUP: begin
					// Stay in this state for 1 clock cycle and keep done asserted for 1 cycle
					done <= 1;
					state <= TX_IDLE;                
				end
				
				default: begin
					done <= 0;
					state <= TX_IDLE;
					tx <= 0;        
				end
			endcase
		end
	end
endmodule: uart_tx


