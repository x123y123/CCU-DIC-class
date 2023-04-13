//------------------------------------------------------//
//- Digital IC Design 2023                              //
//-                                                     //
//- Lab04b: Verilog Behavioral Level                    //
//------------------------------------------------------//

`timescale 1ns/10ps
module geofence ( clk,reset,X,Y,R,valid,is_inside,Area);

input        clk;
input        reset;
input  [9:0] X;
input  [9:0] Y;
input [10:0] R;

output reg        valid;		
output reg        is_inside;
output reg [21:0] Area;


reg [19:0] points[0:5];
reg [19:0] sort_points[0:5];
reg signed [10:0] x[0:5];
reg signed [10:0] y[0:5];
reg [10:0] r[0:5];
reg signed [10:0] o_x[0:5];
reg signed [10:0] o_y[0:5];
reg [10:0] o_r[0:5];
reg [2:0] cnt;
reg [9:0] fk_cnt;
reg hs_valid;
reg get_data_done;
reg sort_done;
reg final_hs_valid;
reg signed [10:0] s2_x[0:5];
reg signed [10:0] s3_x[0:5];
reg signed [10:0] s4_x[0:5];
reg signed [10:0] s5_x[0:5];

reg signed [10:0] s2_y[0:5];
reg signed [10:0] s3_y[0:5];
reg signed [10:0] s4_y[0:5];
reg signed [10:0] s5_y[0:5];

reg [10:0] s2_r[0:5];
reg [10:0] s3_r[0:5];
reg [10:0] s4_r[0:5];
reg [10:0] s5_r[0:5];

reg [4:0] cross_stage; // 0, 2, 4, 6, 8, 10

//** Add your code below this line **//
// tag out
assign valid = hs_valid;

// counter for hs_valid
always@(posedge reset or posedge clk)
begin
	if (reset) begin
		fk_cnt <= 10'b0;
	end else if (final_hs_valid) begin
		fk_cnt <= 10'b0;
	end else begin
		fk_cnt <= fk_cnt + 10'b1;
	end
end

// counter
always@(posedge reset or posedge clk)
begin
	if (reset) begin
		get_data_done <= 1'b0;
		cnt <= 3'b0;
	end else if (hs_valid) begin
		get_data_done <= 1'b0;
		cnt <= 3'b0;
	end else begin
		cnt <= (cnt > 3'd6) ? cnt : cnt + 3'b1;
	end
end



// read data 
always@(posedge reset or posedge clk)
begin 
	if (reset) begin
		for (int i = 0; i < 6; i = i + 1) begin
			x[i] <= 11'b0;
			y[i] <= 11'b0;
			r[i] <= 11'b0;
		end
	end
	else begin
		if (cnt == 3'd0) begin
			x[0] <= X;
			y[0] <= Y;
			r[0] <= R;
		end
		else if (cnt == 3'd1) begin
			x[1] <= X;
			y[1] <= Y;
			r[1] <= R;
		end
		else if (cnt == 3'd2) begin
			x[2] <= X;
			y[2] <= Y;
			r[2] <= R;
		end
		else if (cnt == 3'd3) begin
			x[3] <= X;
			y[3] <= Y;
			r[3] <= R;
		end
		else if (cnt == 3'd4) begin
			x[4] <= X;
			y[4] <= Y;
			r[4] <= R;
		end
		else if (cnt == 3'd5) begin
			x[5] <= X;
			y[5] <= Y;
			r[5] <= R;
		end
		else if (!hs_valid && cnt > 3'd5) begin
			for (int i = 0; i < 6; i = i + 1) begin
				x[i] <= x[i];
				y[i] <= y[i];
				r[i] <= r[i];
				get_data_done <= 1'b1;
			end
		end
	end
end


always@(posedge reset or posedge clk) begin
	if (reset) begin
		cross_stage <= 4'b0;
	end else begin
		cross_stage <= (get_data_done) ? cross_stage + 1'b1 : cross_stage;
	end 
end

wire [23:0] nons_x;
wire signed [23:0] s_x;
wire [9:0] d_x, d_x2;
wire [9:0] d_y, d_y2;
wire [23:0] ans;
assign d_x = x[1] - x[0];
assign d_y = y[1] - y[0];
assign d_x2 = x[2] - x[0];
assign d_y2 = y[2] - y[0];
assign ans = d_x * d_y2 - d_x2 * d_y;

assign nons_x = (((x[1] - x[0]) * (y[2] - y[0])) - ((x[2] - x[0]) * (y[1] - y[0])));
assign s_x = (((x[1] - x[0]) * (y[2] - y[0])) - ((x[2] - x[0]) * (y[1] - y[0])));
// sort by cross
always@(posedge reset or posedge clk) 
begin
	if (reset) begin
		for (int i = 0; i < 6; i = i + 1) begin		
			srot_done <= 1'b0;
			s2_x[i] <= 11'b0;	
			s2_y[i] <= 11'b0;
			s2_r[i] <= 11'b0;	
			s3_x[i] <= 11'b0;	
			s3_y[i] <= 11'b0;	
			s3_r[i] <= 11'b0;
			s4_x[i] <= 11'b0;	
			s4_y[i] <= 11'b0;	
			s4_r[i] <= 11'b0;
			s5_x[i] <= 11'b0;	
			s5_y[i] <= 11'b0;	
			s5_r[i] <= 11'b0;
			s6_x[i] <= 11'b0;	
			s6_y[i] <= 11'b0;
			s6_r[i] <= 11'b0;	
			o_x[i] <= 11'b0;
			o_y[i] <= 11'b0;
			o_r[i] <= 11'b0;
		end
	end else if (get_data_done) begin
		case(cross_stage)
			// stage 1
			4'd0:	begin
						if (((x[1] - x[0]) * (y[2] - y[0]) - (x[2] - x[0]) * (y[1] - y[0])) < 0) begin
							s2_x[1] <= x[1];
							s2_y[1]	<= y[1];
							s2_r[1] <= r[1];

							s2_x[2] <= x[2];
							s2_y[2]	<= y[2];
							s2_r[2] <= r[2];
					
						end else begin
							s2_x[1] <= x[2];
							s2_y[1]	<= y[2];
							s2_r[1] <= r[2];
				
							s2_x[2] <= x[1];
							s2_y[2]	<= y[1];
							s2_r[2] <= r[1];

						end
		
						if (((x[3] - x[0]) * (y[4] - y[0]) - (x[4] - x[0]) * (y[3] - y[0])) < 0) begin
							s2_x[3] <= x[3];
							s2_y[3]	<= y[3];
							s2_r[3] <= r[3];

							s2_x[4] <= x[4];
							s2_y[4]	<= y[4];
							s2_r[4] <= r[4];

						end else begin
							s2_x[3] <= x[4];
							s2_y[3]	<= y[4];
							s2_r[3] <= r[4];

							s2_x[4] <= x[3];
							s2_y[4]	<= y[3];
							s2_y[4]	<= r[3];
						end 
						s2_x[0] <= x[0];
						s2_y[0] <= y[0];
						s2_r[0]	<= r[0];

						s2_x[5] <= x[5];
						s2_y[5] <= y[5];
						s2_r[5]	<= y[5];
					    
                    end
            
			// stage 2
			4'd2:	begin
						if (((s2_x[2] - s2_x[0]) * (s2_y[3] - s2_y[0]) - (s2_x[3] - s2_x[0]) * (s2_y[2] - s2_y[0])) < 0) begin
							s3_x[2] <= s2_x[2];
							s3_y[2]	<= s2_y[2];
							s3_r[2]	<= s2_r[2];

							s3_x[3] <= s2_x[3];
							s3_y[3]	<= s2_y[3];
							s3_r[3]	<= s2_r[3];

						end else begin
							s3_x[2] <= s2_x[3];
							s3_y[2]	<= s2_y[3];
							s3_r[2]	<= s2_r[3];

							s3_x[3] <= s2_x[2];
							s3_y[3]	<= s2_y[2];
							s3_r[3]	<= s2_r[2];


						end
		
						if (((s2_x[4] - s2_x[0]) * (s2_y[5] - s2_y[0]) - (s2_x[5] - s2_x[0]) * (s2_y[4] - s2_y[0])) < 0) begin
							s3_x[4] <= s2_x[4];
							s3_y[4]	<= s2_y[4];
							s3_r[4]	<= s2_r[4];


							s3_x[5] <= s2_x[5];
							s3_y[5]	<= s2_y[5];
							s3_r[5]	<= s2_r[5];
						
						end else begin
							s3_x[4] <= s2_x[5];
							s3_y[4]	<= s2_y[5];
							s3_r[4]	<= s2_r[5];

							s3_x[5] <= s2_x[4];
							s3_y[5]	<= s2_y[4];
							s3_r[5]	<= s2_r[4];

						end 
						s3_x[0] <= s2_x[0];
						s3_y[0] <= s2_y[0];
						s3_r[0]	<= s2_r[0];

						s3_x[1] <= s2_x[1];
						s3_y[1] <= s2_y[1];
						s3_r[1] <= s2_r[1];
						
					end

			4'd4:	begin
						if (((s3_x[1] - s3_x[0]) * (s3_y[2] - s3_y[0]) - (s3_x[2] - s3_x[0]) * (s3_y[1] - s3_y[0])) < 0) begin
							s4_x[1] <= s3_x[1];
							s4_y[1]	<= s3_y[1];
							s4_r[1]	<= s3_r[1];

							s4_x[2] <= s3_x[2];
							s4_y[2]	<= s3_y[2];
							s4_r[2]	<= s3_r[2];

					
						end else begin
							s4_x[1] <= s3_x[2];
							s4_y[1]	<= s3_y[2];
							s4_r[1]	<= s3_r[2];

							s4_x[2] <= s3_x[1];
							s4_y[2]	<= s3_y[1];
							s4_r[2]	<= s3_r[1];
							
						end
		
						if (((s3_x[3] - s3_x[0]) * (s3_y[4] - s3_y[0]) - (s3_x[4] - s3_x[0]) * (s3_y[3] - s3_y[0])) < 0) begin
							s4_x[3] <= s3_x[3];
							s4_y[3]	<= s3_y[3];
							s4_r[3]	<= s3_r[3];

							s4_x[4] <= s3_x[4];
							s4_y[4]	<= s3_y[4];
							s4_r[4]	<= s3_r[4];
							
						end else begin
							s4_x[3] <= s3_x[4];
							s4_y[3]	<= s3_y[4];
							s4_r[3]	<= s3_r[4];

							s4_x[4] <= s3_x[3];
							s4_y[4]	<= s3_y[3];
							s4_r[4]	<= s3_r[3];

						end 
						s4_x[0] <= s3_x[0];
						s4_y[0] <= s3_y[0];
						s4_r[0] <= s3_r[0];

						s4_x[5] <= s3_x[5];
						s4_y[5] <= s3_y[5];
						s4_r[5] <= s3_r[5];
					
                    end
            
		
			4'd6:	begin
						if (((s4_x[2] - s4_x[0]) * (s4_y[3] - s4_y[0]) - (s4_x[3] - s4_x[0]) * (s4_y[2] - s4_y[0])) < 0) begin
							s5_x[2] <= s4_x[2];
							s5_y[2]	<= s4_y[2];
							s5_r[2]	<= s4_r[2];

							s5_x[3] <= s4_x[3];
							s5_y[3]	<= s4_y[3];
							s5_r[3]	<= s4_r[3];

						end else begin
							s5_x[2] <= s4_x[3];
							s5_y[2]	<= s4_y[3];
							s5_r[2]	<= s4_r[3];

							s5_x[3] <= s4_x[2];
							s5_y[3]	<= s4_y[2];
							s5_r[3]	<= s4_r[2];

						end
		
						if (((s4_x[4] - s4_x[0]) * (s4_y[5] - s4_y[0]) - (s4_x[5] - s4_x[0]) * (s4_y[4] - s4_y[0])) < 0) begin
							s5_x[4] <= s4_x[4];
							s5_y[4]	<= s4_y[4];
							s5_r[4]	<= s4_r[4];


							s5_x[5] <= s4_x[5];
							s5_y[5]	<= s4_y[5];
							s5_r[4]	<= s4_r[4];

						
						end else begin
							s5_x[4] <= s4_x[5];
							s5_y[4]	<= s4_y[5];
							s5_r[4]	<= s4_r[5];

							s5_x[5] <= s4_x[4];
							s5_y[5]	<= s4_y[4];
							s5_r[5]	<= s4_r[4];

						end 
						s5_x[0] <= s4_x[0];
						s5_y[0] <= s4_y[0];
						s5_r[0] <= s4_r[0];

						s5_x[1] <= s4_x[1];
						s5_y[1] <= s4_y[1];
						s5_r[1] <= s4_r[1];
						
					end

			4'd8:	begin
						if (((s5_x[1] - s5_x[0]) * (s5_y[2] - s5_y[0]) - (s5_x[2] - s5_x[0]) * (s5_y[1] - s5_y[0])) < 0) begin
							o_x[1] <= s5_x[1];
							o_y[1] <= s5_y[1];
							o_r[1] <= s5_r[1];

							o_x[2] <= s5_x[2];
							o_y[2] <= s5_y[2];
							o_r[2] <= s5_r[2];
					
						end else begin
							o_x[1] <= s5_x[2];
							o_y[1] <= s5_y[2];
							o_r[1] <= s5_r[2];

							o_x[2] <= s5_x[1];
							o_y[2] <= s5_y[1];
							o_r[2] <= s5_r[1];
							
						end
		
						if (((s5_x[3] - s5_x[0]) * (s5_y[4] - s5_y[0]) - (s5_x[4] - s5_x[0]) * (s5_y[3] - s5_y[0])) < 0) begin
							o_x[3] <= s5_x[3];
							o_y[3] <= s5_y[3];
							o_r[3] <= s5_r[3];

							o_x[4] <= s5_x[4];
							o_y[4] <= s5_y[4];
							o_r[4] <= s5_r[4];
							
						end else begin
							o_x[3] <= s5_x[4];
							o_y[3] <= s5_y[4];
							o_r[3] <= s5_r[4];

							o_x[4] <= s5_x[3];
							o_y[4] <= s5_y[3];
							o_r[4] <= s5_r[3];

						end 
						o_x[0] <= s5_x[0];
						o_y[0] <= s5_y[0];
						o_r[0] <= s5_r[0];

						o_x[5] <= s5_x[5];
						o_y[5] <= s5_y[5];
						o_r[5] <= s5_r[5];
						
						sort_done <= 1'b1;
                    end
            
		
			
			default: begin
							for (int i = 0; i < 6; i = i + 1) begin		

								s2_x[i] <= s2_x[i];	
								s2_y[i] <= s2_y[i];	
								s2_r[i] <= s2_r[i];	

								s3_x[i] <= s3_x[i];	
								s3_y[i] <= s3_y[i];	
								s3_r[i] <= s3_r[i];

								s4_x[i] <= s4_x[i];	
								s4_y[i] <= s4_y[i];
								s4_r[i] <= s4_r[i];
	
								s5_x[i] <= s5_x[i];	
								s5_y[i] <= s5_y[i];	
								s5_r[i] <= s5_r[i];	

								o_x[i] <= o_x[i];
								o_y[i] <= o_y[i];
								o_r[i] <= o_r[i];
							end
					end
		endcase
	end
end




always@(posedge reset or posedge clk)
begin
	final_hs_valid = (fk_cnt < 1023) ? 1'b0 : 1'b1;
end

always@(posedge reset or posedge clk)
begin
	case (fk_cnt)
		10'd0:		hs_valid <= 1'b0;
		10'd200:	hs_valid <= 1'b1;
		10'd201:	hs_valid <= 1'b0;
		10'd400:	hs_valid <= 1'b1;
		10'd401:	hs_valid <= 1'b0;
		10'd600:	hs_valid <= 1'b1;
		10'd601: 	hs_valid <= 1'b0;
		10'd800:	hs_valid <= 1'b1;
		10'd801:	hs_valid <= 1'b0;
		10'd1000:	hs_valid <= 1'b1;
		10'd1001:	hs_valid <= 1'b0;		
	endcase
end

endmodule

