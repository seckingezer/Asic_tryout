module RCA #(parameter SIZE = 4)(
 
    input [SIZE-1:0] x,y,
    input ci,
    output cout,
    output [SIZE-1:0] sum
);
(* dont_touch="true" *)  wire [SIZE:0] carries;
assign carries[0] = ci;
assign cout = carries[SIZE];

genvar c;
generate 
    for( c=0; c<SIZE; c=c+1)
        begin: loop
          FA full_adder(x[c],y[c],carries[c],carries[c+1],sum[c]);
        end 
endgenerate
endmodule
