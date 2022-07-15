// FullAdder gate level code
module fulladder_dataflow(
  input logic a, b, cin, 
  output logic sum, cout
);
  logic p, q;  
  assign p = a ^ b;
  assign q = a & b;
  assign sum = p ^ cin;
  assign cout = q | (p & cin);
endmodule
