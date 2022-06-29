`timescale 1ns / 1ps

module ALU(
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif 
    input [63:0] alu_in1,
    input [63:0] alu_in2, 
    input [6:0] sel,
    input alu_select,sladd,
    output reg [63:0] alu_out
    );

wire cout;
reg cin;
wire Z;
reg [63:0] alu_reg1;
reg [63:0] alu_reg2;
reg [63:0] adder_reg2;
wire [63:0] adder_out;
wire [31:0] src1_32;
wire [4:0] shamt;

localparam ADD_SUB = 4'b0000;
localparam XOR     = 4'b0001;
localparam OR      = 4'b0010;
localparam AND     = 4'b0011;
localparam SLTU    = 4'b0100;
localparam SLT     = 4'b0101;
localparam SRL     = 4'b0110;
localparam SRLIW   = 4'b0111;
localparam SLL     = 4'b1000;
localparam SLLIW   = 4'b1001;
localparam SRAW    = 4'b1010;
localparam SRA     = 4'b1011;
localparam BEQ     = 4'b1100;
localparam BNE     = 4'b1101;
localparam BGTU    = 4'b1110;
localparam BGT     = 4'b1111;



assign shamt = alu_in2[5:0]; // 64 bit i?in 6 32 bit i?in ilk 5 bit 
assign src1_32 = alu_in1[31:0];



always @(*) begin
    
if (alu_select)begin 

alu_reg1 = alu_in1;
alu_reg2 = alu_in2;

    if (sel[5]) // add subs karar veren 
        cin        = 0;  // karşılaştırmaları çıkarma işlemi üzerinden yaptığımız için normal durumda
    else if (sladd) begin // her zaman Cin = 1 seçip two's complement veriyoruz. 
        cin        = 0;        
        alu_reg1   = alu_in1 << 1;  // sladd gelirse, kaydırıp vericez addera 
        adder_reg2 = alu_in2;       
    end 

    else begin
        cin        = 1;
        alu_reg1   = alu_in1;
        adder_reg2 = alu_in2 ^ {64{cin}};
    end
end
else if (!alu_select) begin  // if alu is not selected the inputs does not alter to prevent 
    cin        = 0;		// dynamic power consumption 
    alu_reg1   = alu_reg1;
    alu_reg2   = alu_reg2;
    adder_reg2 = adder_reg2;   
end
end



SQRT_CSLA_ZFC adder (.A(alu_reg1),
                     .B(adder_reg2),
                     .cin(cin),
                     .Y(adder_out),    
                     .cout(cout),
                     .Z(Z)
 
);

always @(*) begin

    case(sel[4:0])
       ADD_SUB: alu_out = adder_out;                                         // ADD, ADDI, SUB      
       XOR    : alu_out = alu_reg1 ^ alu_reg2;                               // XOR, XORI   
       OR     : alu_out = alu_reg1 | alu_reg2;                               // OR , ORI    
       AND    : alu_out = alu_reg1 & alu_reg2;                               // AND, ANDI   
       SLTU   : alu_out = (~cout) ? 64'd1:64'd0;                             // SLTU,SLTIU, BLTU 
       SLT    : alu_out = (adder_out[63]) ? 64'd1 : 64'd0;                   // SLT, SLTI, BLT 
       SRL    : alu_out = ((alu_reg1)) >> shamt;                             // SRL,SRLI
       SRLIW  : alu_out = {{32{alu_reg1[31]}},(src1_32) >> shamt};           // SRLIW
       SLL    : alu_out = (alu_reg1) << shamt;                               // SLL,SLLI
       SLLIW  : alu_out = {{32{alu_reg1[31]}},((src1_32)) << shamt};         // SLLIW
       SRAW   : alu_out = {{32{alu_reg1[31]}},((src1_32)) >>> shamt};        // SRAW, SRAIW 
       SRA    : alu_out = ($signed(alu_reg1)) >>> shamt;                     // SRA, SRAI
       BEQ    : alu_out = (Z) ?  64'd1 : 64'd0;                              // BEQ
       BNE    : alu_out = (Z) ?  64'd0 : 64'd1;                              // BNE
       BGTU   : alu_out = (cout | Z) ? 64'd1 : 64'd0;                        // BGTU 
       BGT    : alu_out = (~adder_out[63] | Z) ? 64'd1 : 64'd0;              // BGT                  
endcase
end
endmodule
