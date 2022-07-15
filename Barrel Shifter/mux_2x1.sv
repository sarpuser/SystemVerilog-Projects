// 2to1 Multiplexor behavioral code
module mux_2x1(
  input logic in0, in1, 
  input logic sel, 
  output logic out
); 
  always @(sel or in0 or in1)
  begin
     if(sel == 0)
       out = in0;
     else
       out = in1; 
  end
endmodule
 

