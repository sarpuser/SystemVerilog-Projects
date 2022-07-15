// FullAdder dataflow level code
module fulladder(
  input logic a, b, cin, 
  output logic sum, cout
);
  logic p, q;  
  assign p = a ^ b;
  assign q = a & b;
  assign sum = p ^ cin;
  assign cout = q | (p & cin);
endmodule

/*
// FullAdder gatelevel code
module fulladder(
  input logic a, b, cin, 
  output logic sum, cout
);
  wire w0, w1, w2;
  xor x0(w0, b, a);
  and a0(w1, b, a);   
  and a1(w2, w0, cin);
  or r0(cout, w2, w1);   
  xor x1(sum, w0, cin);
endmodule
*/
/*
// FullAdder behavioral level code
module fulladder(
  input logic a, b, cin, 
  output logic sum, cout
);
  assign {cout, sum} = a + b + cin;
endmodule
*/
