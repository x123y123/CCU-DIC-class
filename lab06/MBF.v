//------------------------------------------------------//
//- Digital IC Design 2023                              //
//-                                                     //
//- Lab06: Logic Synthesis                              //
//------------------------------------------------------//
`timescale 1ns/10ps

//`define H_WIDTH 11

module MBF(CLK, RESET, IN_VALID, IN_DATA, X_DATA, Y_DATA, OUT_VALID);

input   CLK;
input   RESET;
input   IN_VALID;

input       [12:0]  IN_DATA;
output  reg [12:0]  X_DATA;
output  reg [12:0]  Y_DATA;
output  reg         OUT_VALID;

//Write Your Design Here
//parameter H_WIDTH 4'd11;

// get data cnt
reg [5:0] data_cnt;
reg [12:0] s[0:10];
reg [12:0] in_data;
reg [33:0] y_h[0:11];
reg [33:0] y_l[0:11];

wire [17:0] H0, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11;
wire [17:0] L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11;

assign H0 = 18'd110592;
assign H1 = 18'd77824;
assign H2 = 18'd20480;
assign H3 = 18'd36864;
assign H4 = 18'd86016;
assign H5 = 18'd69632;
assign H6 = 18'd65536;
assign H7 = 18'd77824;
assign H8 = 18'd45056;
assign H9 = 18'd49152;
assign H10 = 18'd65536;
assign H11 = 18'd126976;

assign L0 = 18'd57344;
assign L1 = 18'd16384;
assign L2 = 18'd12288;
assign L3 = 18'd4096;
assign L4 = 18'd65536;
assign L5 = 18'd57344;
assign L6 = 18'd114688;
assign L7 = 18'd65536;
assign L8 = 18'd126976;
assign L9 = 18'd114688;
assign L10 = 18'd126976;
assign L11 = 18'd69632;

always@(posedge RESET or posedge CLK)
begin
    if (RESET) begin

        in_data <= 13'b0;
        
        s[0] <= 13'b0;
		s[1] <= 13'b0;
		s[2] <= 13'b0;
		s[3] <= 13'b0;
		s[4] <= 13'b0;
		s[5] <= 13'b0;	
		s[6] <= 13'b0;
		s[7] <= 13'b0;
		s[8] <= 13'b0;
		s[9] <= 13'b0;
		s[10] <= 13'b0;
		
 		y_h[0] <= 34'b0;
		y_h[1] <= 34'b0;
		y_h[2] <= 34'b0;
		y_h[3] <= 34'b0;
		y_h[4] <= 34'b0;
		y_h[5] <= 34'b0;	
		y_h[6] <= 34'b0;
		y_h[7] <= 34'b0;
		y_h[8] <= 34'b0;
		y_h[9] <= 34'b0;
		y_h[10] <= 34'b0;
		y_h[11] <= 34'b0;

		y_l[0] <= 34'b0;
		y_l[1] <= 34'b0;
		y_l[2] <= 34'b0;
		y_l[3] <= 34'b0;
		y_l[4] <= 34'b0;
		y_l[5] <= 34'b0;	
		y_l[6] <= 34'b0;
		y_l[7] <= 34'b0;
		y_l[8] <= 34'b0;
		y_l[9] <= 34'b0;
		y_l[10] <= 34'b0;
		y_l[11] <= 34'b0;

    end else begin

        in_data <= (IN_VALID) ? IN_DATA : 13'b0;

		s[0] <= in_data;
		s[1] <= s[0];
		s[2] <= s[1];
		s[3] <= s[2];
		s[4] <= s[3];
		s[5] <= s[4];
		s[6] <= s[5];
		s[7] <= s[6];
		s[8] <= s[7];
		s[9] <= s[8];
		s[10] <= s[9];
		
		

		y_h[0] <= H0 * in_data;
		y_h[1] <= H1 * s[0];
        y_h[2] <= H2 * s[1];
        y_h[3] <= H3 * s[2];
        y_h[4] <= H4 * s[3];
        y_h[5] <= H5 * s[4];
        y_h[6] <= H6 * s[5];
        y_h[7] <= H7 * s[6];
        y_h[8] <= H8 * s[7];
        y_h[9] <= H9 * s[8];
        y_h[10] <= H10 * s[9];
        y_h[11] <= H11 * s[10];
        
		y_l[0] <= L0 * in_data;
		y_l[1] <= L1 * s[0];
        y_l[2] <= L2 * s[1];
        y_l[3] <= L3 * s[2];
        y_l[4] <= L4 * s[3];
        y_l[5] <= L5 * s[4];
        y_l[6] <= L6 * s[5];
        y_l[7] <= L7 * s[6];
        y_l[8] <= L8 * s[7];
        y_l[9] <= L9 * s[8];
        y_l[10] <= L10 * s[9];
        y_l[11] <= L11 * s[10];
        

    end
end
reg [12:0] fk_x;
reg [12:0] fk_y;

always @ (posedge RESET or posedge CLK)
begin
	if (RESET) begin
		X_DATA <= 13'b0;
		Y_DATA <= 13'b0;
		fk_x <= 13'b0;
		fk_y <= 13'b0;
		OUT_VALID <= 1'b0;
	end else begin
		
		fk_y <= (((y_h[0] + y_h[1] + y_h[2] + y_h[3] + y_h[4] + y_h[5] + y_h[6] + y_h[7] + y_h[8] + y_h[9] + y_h[10] + y_h[11]) >> 20) & 14'd1) ? 
				(((y_h[0] + y_h[1] + y_h[2] + y_h[3] + y_h[4] + y_h[5] + y_h[6] + y_h[7] + y_h[8] + y_h[9] + y_h[10] + y_h[11]) >> 20) + 1'b1) >> 1 :
				((y_h[0] + y_h[1] + y_h[2] + y_h[3] + y_h[4] + y_h[5] + y_h[6] + y_h[7] + y_h[8] + y_h[9] + y_h[10] + y_h[11]) >> 21);
        
		fk_x <= (((y_l[0] + y_l[1] + y_l[2] + y_l[3] + y_l[4] + y_l[5] + y_l[6] + y_l[7] + y_l[8] + y_l[9] + y_l[10] + y_l[11]) >> 20) & 14'd1) ? 
				(((y_l[0] + y_l[1] + y_l[2] + y_l[3] + y_l[4] + y_l[5] + y_l[6] + y_l[7] + y_l[8] + y_l[9] + y_l[10] + y_l[11]) >> 20) + 1'b1) >> 1 :
				((y_l[0] + y_l[1] + y_l[2] + y_l[3] + y_l[4] + y_l[5] + y_l[6] + y_l[7] + y_l[8] + y_l[9] + y_l[10] + y_l[11]) >> 21);

		X_DATA <= fk_x;
		Y_DATA <= fk_y;
		
		OUT_VALID <= (fk_x) ? 1'b1 : 1'b0;
	end
end
/*
assign Y_DATA = (((y_h[0] + y_h[1] + y_h[2] + y_h[3] + y_h[4] + y_h[5] + y_h[6] + y_h[7] + y_h[8] + y_h[9] + y_h[10] + y_h[11]) >> 20) & 14'd1) ? 
				(((y_h[0] + y_h[1] + y_h[2] + y_h[3] + y_h[4] + y_h[5] + y_h[6] + y_h[7] + y_h[8] + y_h[9] + y_h[10] + y_h[11]) >> 20) + 1'b1) >> 1 :
				((y_h[0] + y_h[1] + y_h[2] + y_h[3] + y_h[4] + y_h[5] + y_h[6] + y_h[7] + y_h[8] + y_h[9] + y_h[10] + y_h[11]) >> 21);

assign X_DATA = (((y_l[0] + y_l[1] + y_l[2] + y_l[3] + y_l[4] + y_l[5] + y_l[6] + y_l[7] + y_l[8] + y_l[9] + y_l[10] + y_l[11]) >> 20) & 14'd1) ? 
				(((y_l[0] + y_l[1] + y_l[2] + y_l[3] + y_l[4] + y_l[5] + y_l[6] + y_l[7] + y_l[8] + y_l[9] + y_l[10] + y_l[11]) >> 20) + 1'b1) >> 1 :
				((y_l[0] + y_l[1] + y_l[2] + y_l[3] + y_l[4] + y_l[5] + y_l[6] + y_l[7] + y_l[8] + y_l[9] + y_l[10] + y_l[11]) >> 21);

assign OUT_VALID = (X_DATA) ? 1'b1 : 1'b0;
*/


endmodule
