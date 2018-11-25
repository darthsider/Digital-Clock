/*
 *  Copyright (C) 2018  Siddharth J <www.siddharth.pro>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module clock(clk,rst,dig,seg);

input clk,rst;
output reg [7:0] dig,seg;

reg [24:0] count;
reg sec_clk;
reg [23:0] time_r;
reg [3:0] seg_r;

always @(posedge clk) begin
if(rst)
count <= 0;
else if(count == 25'd32000000)
count <= 0;
else
count <= count + 1'b1;
end

always @(posedge clk) begin
if(rst)
sec_clk <= 0;
else if(count == 25'd31999999)
sec_clk <= 1'b1;
else
sec_clk <= 0;
end

always @(count[16:14] or time_r) begin
case(count[16:14])
4'd0: seg_r <= time_r[3:0];
4'd1: seg_r <= time_r[7:4];
4'd2: seg_r <= 4'd8;
4'd3: seg_r <= time_r[11:8];
4'd4: seg_r <= time_r[15:12];
4'd5: seg_r <= 4'd8;
4'd6: seg_r <= time_r[19:16];
4'd7: seg_r <= time_r[23:20];
default: seg_r <= 4'd8;
endcase
end


always @(count[16:14]) begin
case(count[16:14])
4'd0: dig <= 8'b11111110;
4'd1: dig <= 8'b11111101;
4'd2: dig <= 8'b11111111;
4'd3: dig <= 8'b11110111;
4'd4: dig <= 8'b11101111;
4'd5: dig <= 8'b11111111;
4'd6: dig <= 8'b10111111;
4'd7: dig <= 8'b01111111;
default: dig <= 8'b11111110;
endcase
end

always @(posedge clk) begin
if(rst)
seg <= 0;
else begin
case(seg_r)
4'h0:seg <= 8'h3f;		
4'h1:seg <= 8'h06;
4'h2:seg <= 8'h5b;
4'h3:seg <= 8'h4f;
4'h4:seg <= 8'h66;
4'h5:seg <= 8'h6d;
4'h6:seg <= 8'h7d;
4'h7:seg <= 8'h07;
4'h8:seg <= 8'h7f;
4'h9:seg <= 8'h6f;	
default:seg <= 8'h00;			
endcase
end
end


always @(posedge sec_clk,posedge rst)
begin
if(rst)
time_r <= 0;
else begin
time_r[3:0] <= time_r[3:0] + 1'b1;
if(time_r[3:0] == 4'h9) begin
time_r[3:0] <= 0;
time_r[7:4] <= time_r[7:4] + 1'b1;
if(time_r[7:4] == 4'h5) begin
time_r[7:4] <= 0;
time_r[11:8] <= time_r[11:8] + 1'b1;
if(time_r[11:8] == 4'h9) begin
time_r[11:8] <= 0;
time_r[15:12] <= time_r + 1'b1;
if(time_r[15:12] == 4'h5) begin
time_r[15:12] <= 0;
time_r[19:16] <= time_r + 1'b1;
if(time_r[19:16] == 4'h9) begin
time_r[19:16] <= 0;
time_r[23:20] <= time_r + 1'b1;
if(time_r[23:16] == 8'h18) begin
time_r[23:16] <= 0;
end
end
end
end
end
end
end
end


endmodule
