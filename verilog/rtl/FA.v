`timescale 1ns / 1ps


module FA(
    input x,y,ci,
    output cout, sum
    );
    (* dont_touch="true" *)

    wire c1,s1,c2;

    HA half_adder_1 (x,y,c1,s1);
    HA half_adder_2 (ci,s1,c2,sum);
    assign cout = c1 | c2;

endmodule
