`timescale 1ns / 1ps

module ZFC #(parameter SIZE = 4)(
    
    input [SIZE-1:0] Z,
    input cin,
    input rca_cin,
    output [SIZE-1:0] B,
    output csel
    
    );
    
    wire [SIZE-1:0] conn;
    wire [SIZE-1:0] wireB;
assign conn[0] = Z[0]&cin;
assign wireB[0] = Z[0]^cin;
genvar i;
    generate 
    for (i = 0; i <SIZE-1; i=i+1)
        begin: loop
            assign conn[i+1] = conn[i] & Z[i+1];
        end 
    endgenerate

genvar k;
    generate 
    for (k = 0; k <SIZE-1; k=k+1)
        begin: loop2
    assign wireB[k+1] = conn[k] ^ Z[k+1];
    end 
    endgenerate 
 assign B = wireB;
 assign csel =  conn[SIZE-1] ^ rca_cin;  
endmodule