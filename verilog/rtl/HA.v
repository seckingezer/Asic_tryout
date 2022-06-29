`timescale 1ns / 1ps

module HA(
    input x,y,
    output cout,sum
    );
    (* dont_touch="true" *)
    
    assign cout = x & y;
    assign sum = x ^ y;
       
endmodule
