//UART Control System Testbench Code
`timescale 1ns/1ns

module uart_control_system_testbench;
// Uart Transmitter and Receiver clock frequency
// CLK_PERIOD_NS * 2 = 10 x 2 = 20ns
parameter CLK_PERIOD_NS = 10;

// Number of bits in UART packets
// 1 Start bit + 8 Data Bits + 1 Stop bit = 10
parameter NUM_SERIAL_BITS = 10;


// Number of clocks per bit will be used by 
// within uart transmitter and receiver.
// Witin Uart Tx, this will be used to transmit each serial bit
// for NUM_CLKS_PER_BIT count.
// Within Uart Rx, this will be used to find mid point of serial data bit
// and then sample data.
// NUM_CLKS_PER_BIT = Frequency / Baud Rate
// Frequency = 1 / (2 * CLK_PERIOD_NS)
// Example : for Frequency 50 Mhz, Baud Rate = 115200
// NUM_CLKS_PER_BIT = (50 x 10^6) / 115200 = 434
// parameter NUM_CLKS_PER_BIT = 434;
parameter NUM_CLKS_PER_BIT = 16;  // for faster simulation and easy debug setting value to 16 instead of 434


// Only required for testbench for allowing 10 bits parallel
// data getting converted and transmitted serially on rx signal
// from uart receiver. Between two din packets injected by testbench
// into uart tx, this will be used as a delay
parameter TRANSMIT_TIME = (NUM_CLKS_PER_BIT * (CLK_PERIOD_NS *2) * NUM_SERIAL_BITS);

// Number of bytes to be transmitted by uart transmitter and received by uart receiver
parameter NUM_OF_BYTES = 4;

// local variables
logic clock, clock_by_n, rstn;
logic[3:0] mem_write_addr;
logic[7:0] mem_write_data;
logic mem_write_enable;
logic[7:0] mem_read_data;
logic[3:0] mem_read_addr;
logic mem_read_enable;
logic transmission_done;
logic message_received;

// Instantiate design under test with 4 bytes to be transmitted
uart_control_system #(.NUM_CLKS_PER_BIT(NUM_CLKS_PER_BIT), .NUM_OF_BYTES(NUM_OF_BYTES)) DUT(
  .clock(clock), 
  .rstn(rstn),  
  .mem_write_addr(mem_write_addr),
  .mem_write_data(mem_write_data),
  .mem_write_enable(mem_write_enable),
  .mem_read_data(mem_read_data),
  .mem_read_addr(mem_read_addr),
  .mem_read_enable(mem_read_enable),
  .transmission_done(transmission_done), 
  .message_received(message_received)
);

// Read Only Memory with bytes store which will be read and then transmitted by uart_tx_control FSM
logic[7:0] rom[NUM_OF_BYTES];

// Write Only Memory which will receive data from uart_rx_control FSM
logic[7:0] ram[NUM_OF_BYTES];

// Simple ROM model (read only memory) for UART TX Control FSM to read message byte data and pass it to uart_tx
// which will then be transmitted through uart transmitter(uart_tx) to uart receiver (uart_rx)
always@(posedge clock)
begin
    // Initialize memory with bytes to be transmitted
    // Note if NUM_OF_BYTES parameter is any other value say greater than 4, then for additional elements in rom 
    // values needs to be initialized under if(rstn == 0) condition
    if(rstn==0) begin
      rom[0] = 8'ha5;
      rom[1] = 8'ha8;
      rom[2] = 8'hab;
      rom[3] = 8'hae;
    end
    else if (mem_read_enable) begin
       mem_read_data = rom[mem_read_addr];
    end
    else begin 
       mem_read_data = 0;
    end
end

// Simple RAM memory model (write only memory) for uart_rx_control FSM to store message byte data received from uart_rx FSM
always @(posedge clock)
begin
    // Note if NUM_OF_BYTES parameter is any other value than 4, then for new elements in ram 
    // values needs to be initialized under if(rstn == 0) condition
    if(rstn==0) begin
      foreach(ram[i]) begin
        ram[i] = 0;
      end
    end
    else if (mem_write_enable) begin
        ram[mem_write_addr] = mem_write_data;
    end
    //else begin
    //  ram[mem_write_addr] = ram[mem_write_addr];
    //end
end

// Stimulate input ports
initial begin
  // Initialize Inputs
  rstn = 0;
  clock = 0;
  clock_by_n = 0;

  // Wait 20 ns for global reset to finish 
  #20;
  rstn = 1;
  #20;

  // Wait for 1 clock cycle
  @(posedge clock);

  // Wait for UART Transmitter to transmit bytes to Receiver
  #TRANSMIT_TIME;

  // Wait for uart receiver control FSM to indicate
  // that all bytes which were transmitted by uart transmitter are
  // received by uart receiver
  @(negedge message_received);

  // Wait for few cycles
  repeat(4) @(posedge clock);

  // terminate simulation
  $finish();
end

// wait for message_received to be asserted from
// uart receiver control FSM to indicate all message bytes
// have been received and stored in testbench RAM memory
always@(posedge message_received) begin
 @(negedge clock);
 // Check all correct 8-bit parallel data was received in the RAM through output of uart rx control mem_write_data port
 foreach(rom[index]) begin
    if (ram[index] == rom[index])
      $display("Test Passed - Correct Byte %0d Received time=%0t ns  expected byte data=%h   actual byte data=%h", index, $time, rom[index], ram[index]);
    else
      $display("Test Error- Incorrect Byte %0d Received time=%0t ns  expected byte data=%h   actual byte data=%h", index, $time, rom[index], ram[index]);
 end 
end

// Clock generator logic (used by both uart tx and uart rx modules)
always@(clock) begin
  #CLK_PERIOD_NS clock <= !clock;
end

endmodule