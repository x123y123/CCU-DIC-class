//------------------------------------------------------//
//- Digital IC Design 2023                              //
//-                                                     //
//- Lab03b: Verilog Gate Level                          //
//------------------------------------------------------//

`timescale 1ns/10ps
//------------------------------------------------------//
module lab03b(a, b, c, out);
    input   [7:0] a, b, c;
    output [15:0] out;
	wire    [8:0] add_out;
	wire    [16:0] mult_out;
//Examples to instantiate the cells from cell library
//AND2X1 u1(out1,a,b);
  
//** Add your code below this line **//
add8  add8_1(.in1(a[7:0]), .in2(b[7:0]), .cin(1'b0), .out(add_out[7:0]), .cout(add_out[8]));
mult8 mult8_1(.in1(add_out[8:0]), .in2(c[7:0]),	.cin(1'b0), .out(mult_out[16:0]));
shift17 shift17_1(.in(mult_out[16:0]), .sel(1'b1), .out(out[15:0]));

endmodule

//------------------------------------------------------//
module ADDF(input A,
            input B,
            input CI,
            output S,
            output CO);
wire x1, x2, x3;
xor xo1(x1, A, B);
and and1(x3, A, B);
xor xo2(S, x1, CI);
and and2(x2, x1, CI);
or  or1(CO, x2, x3);

endmodule        
//------------------------------------------------------//
module mux_2x1(input A, 
               input B, 
               input S0,
               output Y);

wire sel_n, out_0, out_1;
not n1(sel_n, S0);
and and3(out_0, A, S0);
and and4(out_1, B, sel_n);
or or2(Y, out_0, out_1);

endmodule
//------------------------------------------------------//
module add4(input  [3:0] in1,
	        input  [3:0] in2,
            input  cin,
	        output [3:0] out,
	        output cout);
wire c0, c1, c2;
ADDF U1(.A(in1[0]), .B(in2[0]), .CI(cin), .S(out[0]), .CO(c0));
ADDF U2(.A(in1[1]), .B(in2[1]), .CI(c0), .S(out[1]), .CO(c1));
ADDF U3(.A(in1[2]), .B(in2[2]), .CI(c1), .S(out[2]), .CO(c2));
ADDF U4(.A(in1[3]), .B(in2[3]), .CI(c2), .S(out[3]), .CO(cout));
	
endmodule 
//------------------------------------------------------//
module add8(input [7:0] in1,
 	        input [7:0] in2,
		    input cin,
	        output [7:0] out,
			output cout);
wire c0;
add4 add4_1(.in1(in1[3:0]), .in2(in2[3:0]), .cin(cin), .out(out[3:0]), .cout(c0));
add4 add4_2(.in1(in1[7:4]), .in2(in2[7:4]), .cin(c0), .out(out[7:4]), .cout(cout));

endmodule
//------------------------------------------------------//

module mult8(input [8:0] in1,
			 input [7:0] in2,
			 input cin,
			 output [16:0] out);
wire [7:0] add_in1, add_in2, add_in3, add_in4, add_in5, add_in6, add_in7 ,add_in8, add_in9;
wire [7:0] add_out, add_out1, add_out2, add_out3, add_out4, add_out5, add_out6, add_out7;
and a1(.A(in1[0]), .B(in2[0]), .Y(out[0]));
and a2(.A(in1[0]), .B(in2[1]), .Y(add_in1[0]));
and a3(.A(in1[0]), .B(in2[2]), .Y(add_in1[1]));
and a4(.A(in1[0]), .B(in2[3]), .Y(add_in1[2]));
and a5(.A(in1[0]), .B(in2[4]), .Y(add_in1[3]));
and a6(.A(in1[0]), .B(in2[5]), .Y(add_in1[4]));
and a7(.A(in1[0]), .B(in2[6]), .Y(add_in1[5]));
and a8(.A(in1[0]), .B(in2[7]), .Y(add_in1[6]));

and a9(.A(in1[1]), .B(in2[0]), .Y(add_in2[0]));
and a10(.A(in1[1]), .B(in2[1]), .Y(add_in2[1]));
and a11(.A(in1[1]), .B(in2[2]), .Y(add_in2[2]));
and a12(.A(in1[1]), .B(in2[3]), .Y(add_in2[3]));
and a13(.A(in1[1]), .B(in2[4]), .Y(add_in2[4]));
and a14(.A(in1[1]), .B(in2[5]), .Y(add_in2[5]));
and a15(.A(in1[1]), .B(in2[6]), .Y(add_in2[6]));
and a16(.A(in1[1]), .B(in2[7]), .Y(add_in2[7]));

add8 add8_1(.in1({cin, add_in1[6:0]}), .in2(add_in2[7:0]), .cin(cin), .out({add_out[6:0], out[1]}), .cout(add_out[7]));

and a17(.A(in1[2]), .B(in2[0]), .Y(add_in3[0]));
and a18(.A(in1[2]), .B(in2[1]), .Y(add_in3[1]));
and a19(.A(in1[2]), .B(in2[2]), .Y(add_in3[2]));
and a20(.A(in1[2]), .B(in2[3]), .Y(add_in3[3]));
and a21(.A(in1[2]), .B(in2[4]), .Y(add_in3[4]));
and a22(.A(in1[2]), .B(in2[5]), .Y(add_in3[5]));
and a23(.A(in1[2]), .B(in2[6]), .Y(add_in3[6]));
and a24(.A(in1[2]), .B(in2[7]), .Y(add_in3[7]));

add8 add8_2(.in1(add_out[7:0]), .in2(add_in3[7:0]), .cin(cin), .out({add_out1[6:0], out[2]}), .cout(add_out1[7]));

and a25(.A(in1[3]), .B(in2[0]), .Y(add_in4[0]));
and a26(.A(in1[3]), .B(in2[1]), .Y(add_in4[1]));
and a27(.A(in1[3]), .B(in2[2]), .Y(add_in4[2]));
and a28(.A(in1[3]), .B(in2[3]), .Y(add_in4[3]));
and a29(.A(in1[3]), .B(in2[4]), .Y(add_in4[4]));
and a30(.A(in1[3]), .B(in2[5]), .Y(add_in4[5]));
and a31(.A(in1[3]), .B(in2[6]), .Y(add_in4[6]));
and a32(.A(in1[3]), .B(in2[7]), .Y(add_in4[7]));

add8 add8_3(.in1(add_out1[7:0]), .in2(add_in4[7:0]), .cin(cin), .out({add_out2[6:0], out[3]}), .cout(add_out2[7]));

and a33(.A(in1[4]), .B(in2[0]), .Y(add_in5[0]));
and a34(.A(in1[4]), .B(in2[1]), .Y(add_in5[1]));
and a35(.A(in1[4]), .B(in2[2]), .Y(add_in5[2]));
and a36(.A(in1[4]), .B(in2[3]), .Y(add_in5[3]));
and a37(.A(in1[4]), .B(in2[4]), .Y(add_in5[4]));
and a38(.A(in1[4]), .B(in2[5]), .Y(add_in5[5]));
and a39(.A(in1[4]), .B(in2[6]), .Y(add_in5[6]));
and a40(.A(in1[4]), .B(in2[7]), .Y(add_in5[7]));

add8 add8_4(.in1(add_out2[7:0]), .in2(add_in5[7:0]), .cin(cin), .out({add_out3[6:0], out[4]}), .cout(add_out3[7]));

and a41(.A(in1[5]), .B(in2[0]), .Y(add_in6[0]));
and a42(.A(in1[5]), .B(in2[1]), .Y(add_in6[1]));
and a43(.A(in1[5]), .B(in2[2]), .Y(add_in6[2]));
and a44(.A(in1[5]), .B(in2[3]), .Y(add_in6[3]));
and a45(.A(in1[5]), .B(in2[4]), .Y(add_in6[4]));
and a46(.A(in1[5]), .B(in2[5]), .Y(add_in6[5]));
and a47(.A(in1[5]), .B(in2[6]), .Y(add_in6[6]));
and a48(.A(in1[5]), .B(in2[7]), .Y(add_in6[7]));

add8 add8_5(.in1(add_out3[7:0]), .in2(add_in6[7:0]), .cin(cin), .out({add_out4[6:0], out[5]}), .cout(add_out4[7]));

and a49(.A(in1[6]), .B(in2[0]), .Y(add_in7[0]));
and a50(.A(in1[6]), .B(in2[1]), .Y(add_in7[1]));
and a51(.A(in1[6]), .B(in2[2]), .Y(add_in7[2]));
and a52(.A(in1[6]), .B(in2[3]), .Y(add_in7[3]));
and a53(.A(in1[6]), .B(in2[4]), .Y(add_in7[4]));
and a54(.A(in1[6]), .B(in2[5]), .Y(add_in7[5]));
and a55(.A(in1[6]), .B(in2[6]), .Y(add_in7[6]));
and a56(.A(in1[6]), .B(in2[7]), .Y(add_in7[7]));

add8 add8_6(.in1(add_out4[7:0]), .in2(add_in7[7:0]), .cin(cin), .out({add_out5[6:0], out[6]}), .cout(add_out5[7]));

and a57(.A(in1[7]), .B(in2[0]), .Y(add_in8[0]));
and a58(.A(in1[7]), .B(in2[1]), .Y(add_in8[1]));
and a59(.A(in1[7]), .B(in2[2]), .Y(add_in8[2]));
and a60(.A(in1[7]), .B(in2[3]), .Y(add_in8[3]));
and a61(.A(in1[7]), .B(in2[4]), .Y(add_in8[4]));
and a62(.A(in1[7]), .B(in2[5]), .Y(add_in8[5]));
and a63(.A(in1[7]), .B(in2[6]), .Y(add_in8[6]));
and a64(.A(in1[7]), .B(in2[7]), .Y(add_in8[7]));

add8 add8_7(.in1(add_out5[7:0]), .in2(add_in8[7:0]), .cin(cin), .out({add_out6[6:0], out[7]}), .cout(add_out6[7]));

and a65(.A(in1[8]), .B(in2[0]), .Y(add_in9[0]));
and a66(.A(in1[8]), .B(in2[1]), .Y(add_in9[1]));
and a67(.A(in1[8]), .B(in2[2]), .Y(add_in9[2]));
and a68(.A(in1[8]), .B(in2[3]), .Y(add_in9[3]));
and a69(.A(in1[8]), .B(in2[4]), .Y(add_in9[4]));
and a70(.A(in1[8]), .B(in2[5]), .Y(add_in9[5]));
and a71(.A(in1[8]), .B(in2[6]), .Y(add_in9[6]));
and a72(.A(in1[8]), .B(in2[7]), .Y(add_in9[7]));

add8 add8_8(.in1(add_out6[7:0]), .in2(add_in9[7:0]), .cin(cin), .out(out[15:8]), .cout(out[16]));

endmodule
//------------------------------------------------------//
module shift17(input [16:0] in,
			   input sel,
			   output [16:0] out);

mux_2x1 m1(.A(in[0]), .B(in[1]), .S0(sel), .Y(out[0]));
mux_2x1 m2(.A(in[1]), .B(in[2]), .S0(sel), .Y(out[1]));
mux_2x1 m3(.A(in[2]), .B(in[3]), .S0(sel), .Y(out[2]));
mux_2x1 m4(.A(in[3]), .B(in[4]), .S0(sel), .Y(out[3]));
mux_2x1 m5(.A(in[4]), .B(in[5]), .S0(sel), .Y(out[4]));
mux_2x1 m6(.A(in[5]), .B(in[6]), .S0(sel), .Y(out[5]));
mux_2x1 m7(.A(in[6]), .B(in[7]), .S0(sel), .Y(out[6]));
mux_2x1 m8(.A(in[7]), .B(in[8]), .S0(sel), .Y(out[7]));
mux_2x1 m9(.A(in[8]), .B(in[9]), .S0(sel), .Y(out[8]));
mux_2x1 m10(.A(in[9]), .B(in[10]), .S0(sel), .Y(out[9]));
mux_2x1 m11(.A(in[10]), .B(in[11]), .S0(sel), .Y(out[10]));
mux_2x1 m12(.A(in[11]), .B(in[12]), .S0(sel), .Y(out[11]));
mux_2x1 m13(.A(in[12]), .B(in[13]), .S0(sel), .Y(out[12]));
mux_2x1 m14(.A(in[13]), .B(in[14]), .S0(sel), .Y(out[13]));
mux_2x1 m15(.A(in[14]), .B(in[15]), .S0(sel), .Y(out[14]));
mux_2x1 m16(.A(in[15]), .B(in[16]), .S0(sel), .Y(out[15]));
mux_2x1 m17(.A(in[16]), .B(1'b0), .S0(sel), .Y(out[16]));

endmodule
//------------------------------------------------------//

