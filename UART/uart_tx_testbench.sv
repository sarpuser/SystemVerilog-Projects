//UART TX Testbench Code
`timescale 1ns/1ns
module uart_tx_testbench;

// number of clocks per bit will be used by 
// within uart receiver this will be used for counting 
// to find mid point of serial data bit and then sample data
parameter NUM_CLKS_PER_BIT = 16;

// Uart Receiver each clock time period
// CLK_PERIOD_NS * 2 = 10 x 2 = 20ns
parameter CLK_PERIOD_NS = 10;

// Each serial data bit period. 
// Uart Transmitter each clock time period
parameter BIT_PERIOD_NS = 320;

// Effectively both transmitter and receiver are having same bit period
// Uart Tx Bit Period = BIT_PERIOD_NS  (320ns)
// Uart Rx Bit Period = NUM_CLKS_PER_BIT * CLK_PERIOD_NS * 2 (16 x 20 = 320ns)

logic clock, clock_by_n, rstn;
logic rx, start, done;
logic [7:0] din;
logic[7:0] byte_data;

// Instantiate design under test
uart_tx #(.NUM_CLKS_PER_BIT(NUM_CLKS_PER_BIT)) DUT(
.clk(clock),
.rstn(rstn),
.tx(tx),
.start(start),
.done(done),
.din(din)
);

initial begin
// Initialize Inputs
rstn = 0;
clock = 0;
clock_by_n = 0;
//rx = 0;
start = 0;

// Wait 20 ns for global reset to finish 
#20;
rstn = 1;
//rx = 1; 
#20;

// Initialize data to be transmitted into uart rx
byte_data = 8'hA2;
//@(posedge clock);
// start = 1;
//@(posedge clock);
//start = 0;
//@(posedge clock);
// din = byte_data;
// Send 8-bit of data serially 4 times into uart tx module
for(integer i=0; i<4; i++) begin

@(posedge clock);
 start = 1;
@(posedge clock);
 start = 0;
 // Create 8-bit data packet with some random value
 byte_data = byte_data + 8'h3;

 // Wait for 1 clock period
//@(posedge clock_by_n);
//@(posedge clock);
 din = byte_data;
 // Transmit 8-bit data serially to uart rx
 //uart_write_byte(byte_data);
            
 // Check that the correct 8-bit parallel data was received at the output of uart rx on dout port 
 //if (dout == byte_data)
 // $display("Test Passed - Correct Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);
 //else
 // $display("Test Error- Incorrect Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);

 // Wait for half a clock edge of rx transmitting data rate 
 //#(BIT_PERIOD_NS);

#3200;

@(negedge done);
end


// Wait for some time
#500ns;

// terminate simulation
$finish();
end

/*
// Drive 8-bit serial data on uart receiver rx port 
task uart_write_byte (input logic [7:0] data);
 begin
  // Send Start Bit
  rx = 1'b0;
  #(BIT_PERIOD_NS);
 
  // Send Data Byte serially
  for (int i=0; i<8; i=i+1) begin
   rx = data[i];
   #(BIT_PERIOD_NS);
  end
      
  // Send Stop Bit
  rx <= 1'b1;
 end
endtask
*/
// Clock generator logic (faster clock for uart receiver to operate on)
always@(clock) begin
  #CLK_PERIOD_NS clock <= !clock;
end

// Clock generator logic.
// Slower clock. Each serial data bit will be generated in uart transmitter
// using this clock and sent to uart receiver asynchronously
always@(clock_by_n) begin
  #BIT_PERIOD_NS clock_by_n <= !clock_by_n;
end
endmodule