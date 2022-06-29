module RCA_nocin #(parameter SIZE = 4)(
 
    input [SIZE-1:0] x,y,
    output cout,
    output [SIZE-1:0] sum
);
(* dont_touch="true" *)  wire [SIZE-1:0] carries;

assign cout = carries[SIZE-1];
HA half_adder(x[0],y[0],carries[0],sum[0]);
genvar c;
generate 
    for( c=1; c<SIZE; c=c+1)
        begin: loop
          FA full_adder(x[c],y[c],carries[c-1],carries[c],sum[c]);
        end 
endgenerate
endmodule
