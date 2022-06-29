`timescale 1ns / 1ps

module SQRT_CSLA_ZFC(

    input [63:0] A,B,
    input cin,
    output [63:0] Y,
    output cout,Z
    );

wire [63:0] temp;
wire [12:0] carries;
wire [11:0] csel;
//// stage 1   
RCA #(2) rca1 (A[1:0],B[1:0],cin,carries[0],Y[1:0]);
///// stage 2
RCA_nocin #(2) rca2(A[3:2],B[3:2],carries[1],temp[3:2]);
ZFC #(2) zfc1 (temp[3:2],carries[0],carries[1],Y[3:2],csel[0]);
///// stage 3 
RCA_nocin #(3) rca3 (A[6:4],B[6:4],carries[2],temp[6:4]);
ZFC #(3) zfc2 (temp[6:4],csel[0],carries[2],Y[6:4],csel[1]);
///// stage 4
RCA_nocin #(4) rca4 (A[10:7],B[10:7],carries[3],temp[10:7]);
ZFC #(4) zfc3 (temp[10:7],csel[1],carries[3],Y[10:7],csel[2]);
///// stage 5 
RCA_nocin #(6) rca5 (A[16:11],B[16:11],carries[4],temp[16:11]);
ZFC #(6) zfc4 (temp[16:11],csel[2],carries[4],Y[16:11],csel[3]);
///// stage 6 
RCA_nocin #(7) rca6 (A[23:17],B[23:17],carries[5],temp[23:17]);
ZFC #(7) zfc5 (temp[23:17],csel[3],carries[5],Y[23:17],csel[4]);
///// stage 7 
RCA_nocin #(7) rca7 (A[30:24],B[30:24],carries[6],temp[30:24]);
ZFC #(7) zfc6 (temp[30:24],csel[4],carries[6],Y[30:24],csel[5]);
///// stage 8
RCA_nocin #(3) rca8 (A[33:31],B[33:31],carries[7],temp[33:31]);
ZFC #(3) zfc7 (temp[33:31],csel[5],carries[7],Y[33:31],csel[6]);
///// stage 9
RCA_nocin #(4) rca9 (A[37:34],B[37:34],carries[8],temp[37:34]);
ZFC #(4) zfc8 (temp[37:34],csel[6],carries[8],Y[37:34],csel[7]);
///// stage 10
RCA_nocin #(5) rca10 (A[42:38],B[42:38],carries[9],temp[42:38]);
ZFC #(5) zfc9 (temp[42:38],csel[7],carries[9],Y[42:38],csel[8]);
///// stage 11
RCA_nocin #(6) rca11 (A[48:43],B[48:43],carries[10],temp[48:43]);
ZFC #(6) zfc10 (temp[48:43],csel[8],carries[10],Y[48:43],csel[9]);
///// stage 12
RCA_nocin #(7) rca12 (A[55:49],B[55:49],carries[11],temp[55:49]);
ZFC #(7) zfc11 (temp[55:49],csel[9],carries[11],Y[55:49],csel[10]);
///// stage 13
RCA_nocin #(8) rca13 (A[63:56],B[63:56],carries[12],temp[63:56]);
ZFC #(8) zfc12 (temp[63:56],csel[10],carries[12],Y[63:56],csel[11]);

assign cout = csel[11];

assign Z = (Y == 0)? 1 : 0;   
    
endmodule
