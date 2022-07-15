// 2to1 Multiplexor RTL code
module mux_2x1 #(parameter WIDTH=4)  
(
  input logic[WIDTH-1:0] in0, // Student to change in0 width to 4
  input logic[WIDTH-1:0] in1, // Student to change in1 width to 4
  input logic sel, 
  output logic[WIDTH-1:0] out // Student to change out width to 4
); 
  
  // always procedural block describing 2to1 Multiplexor behavior 
  always @(sel or in0 or in1)
  begin
     if(sel == 0)
        out = in0;
     else
       out = in1; 
  end
endmodule
 

