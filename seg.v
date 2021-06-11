`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 23:32:15
// Design Name: 
// Module Name: seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module seg(
rst,clk,DIG,Y,segwrite,segcs,segaddr,segwdata
    );
    input rst;
    input clk;
    input segwrite;
    input segcs;
    input[1:0] segaddr;
    input[15:0] segwdata;
    output [7:0] DIG;
    output [7:0] Y;
    
    reg clkout;
    reg [31:0] cnt;
    reg [1:0] scan_cnt;
    
    reg [6:0] Y_r_0;
    reg [6:0] Y_r_1;
    reg [6:0] Y_r_2;
    reg [6:0] Y_r_3;
    
    wire [3:0] data_0 = segwdata[3:0];
    wire [3:0] data_1 = segwdata[7:4];
    wire [3:0] data_2 = segwdata[11:8];
    wire [3:0] data_3 = segwdata[15:12];
    
    parameter period = 200000;
//    parameter period = 20;
    reg [6:0] Y_r;
    reg [7:0] DIG_r;
    assign Y={1'b1,{~Y_r[6:0]}};
    assign DIG = ~DIG_r;
    
    parameter      seg_A =  7'b1110111,seg_B = 7'b1111100,seg_C = 7'b0111001,seg_D = 7'b1011110,
                    seg_E = 7'b1111001,seg_F = 7'b1110001,seg_Zero = 7'b0111111,seg_One = 7'b0000110,seg_Two = 7'b1011011,
                    seg_Three = 7'b1001111,seg_Four = 7'b1100110,seg_Five = 7'b1101101,
                    seg_Six = 7'b1111101,seg_Seven = 7'b0100111,seg_Eight = 7'b1111111,
                    seg_Nine = 7'b1100111;
    
always @(posedge clk) begin
    if (segwrite && segcs && segaddr==2'b11)begin
        case (data_0)
                4'b0000: Y_r_0 = seg_Zero;
                4'b0001: Y_r_0 = seg_One;
                4'b0010: Y_r_0 = seg_Two;
                4'b0011: Y_r_0 = seg_Three;
                4'b0100: Y_r_0 = seg_Four;
                4'b0101: Y_r_0 = seg_Five;
                4'b0110: Y_r_0 = seg_Six;
                4'b0111: Y_r_0 = seg_Seven;
                4'b1000: Y_r_0 = seg_Eight;
                4'b1001: Y_r_0 = seg_Nine;
                4'b1010: Y_r_0 = seg_A;
                4'b1011: Y_r_0 = seg_B;
                4'b1100: Y_r_0 = seg_C;
                4'b1101: Y_r_0 = seg_D;
                4'b1110: Y_r_0 = seg_E;
                4'b1111: Y_r_0 = seg_F;
          endcase
    end
end
    
always @(posedge clk) begin
if (segwrite && segcs && segaddr==2'b11)begin
case (data_1)
            4'b0000: Y_r_1 = seg_Zero;
            4'b0001: Y_r_1 = seg_One;
            4'b0010: Y_r_1 = seg_Two;
            4'b0011: Y_r_1 = seg_Three;
            4'b0100: Y_r_1 = seg_Four;
            4'b0101: Y_r_1 = seg_Five;
            4'b0110: Y_r_1 = seg_Six;
            4'b0111: Y_r_1 = seg_Seven;
            4'b1000: Y_r_1 = seg_Eight;
            4'b1001: Y_r_1 = seg_Nine;
            4'b1010: Y_r_1 = seg_A;
            4'b1011: Y_r_1 = seg_B;
            4'b1100: Y_r_1 = seg_C;
            4'b1101: Y_r_1 = seg_D;
            4'b1110: Y_r_1 = seg_E;
            4'b1111: Y_r_1 = seg_F;
        endcase
end       
end
    
always @(posedge clk) begin
    if (segwrite && segcs && segaddr==2'b11)begin
        case (data_2)
                4'b0000: Y_r_2 = seg_Zero;
                4'b0001: Y_r_2 = seg_One;
                4'b0010: Y_r_2 = seg_Two;
                4'b0011: Y_r_2 = seg_Three;
                4'b0100: Y_r_2 = seg_Four;
                4'b0101: Y_r_2 = seg_Five;
                4'b0110: Y_r_2 = seg_Six;
                4'b0111: Y_r_2 = seg_Seven;
                4'b1000: Y_r_2 = seg_Eight;
                4'b1001: Y_r_2 = seg_Nine;
                4'b1010: Y_r_2 = seg_A;
                4'b1011: Y_r_2 = seg_B;
                4'b1100: Y_r_2 = seg_C;
                4'b1101: Y_r_2 = seg_D;
                4'b1110: Y_r_2 = seg_E;
                4'b1111: Y_r_2 = seg_F;
            endcase
    end  
end
    
always @(posedge clk) begin
        if (segwrite && segcs && segaddr==2'b11)begin
            case (data_3)
                    4'b0000: Y_r_3 = seg_Zero;
                    4'b0001: Y_r_3 = seg_One;
                    4'b0010: Y_r_3 = seg_Two;
                    4'b0011: Y_r_3 = seg_Three;
                    4'b0100: Y_r_3 = seg_Four;
                    4'b0101: Y_r_3 = seg_Five;
                    4'b0110: Y_r_3 = seg_Six;
                    4'b0111: Y_r_3 = seg_Seven;
                    4'b1000: Y_r_3 = seg_Eight;
                    4'b1001: Y_r_3 = seg_Nine;
                    4'b1010: Y_r_3 = seg_A;
                    4'b1011: Y_r_3 = seg_B;
                    4'b1100: Y_r_3 = seg_C;
                    4'b1101: Y_r_3 = seg_D;
                    4'b1110: Y_r_3 = seg_E;
                    4'b1111: Y_r_3 = seg_F;
                endcase
        end
    end
    
    
always @(posedge clkout or posedge rst)
    begin
        if(rst)
            scan_cnt <= 0;
        else begin
            scan_cnt <= scan_cnt + 1;
            if(scan_cnt == 2'd3) scan_cnt <= 0;
        end
    end
    
always @(scan_cnt)
    begin
        if (!rst)begin
            case (scan_cnt)
                    2'b00:DIG_r = 8'b0000_0001;
                    2'b01:DIG_r = 8'b0000_0010;
                    2'b10:DIG_r = 8'b0000_0100;
                    2'b11:DIG_r = 8'b0000_1000;
            endcase
        end
        else
            DIG_r = 8'b1111_1111;
    end
    
always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            cnt<=0;
            clkout <=0;
        end
        else begin
            if(cnt == (period >> 1)-1)
            begin
                clkout <= ~clkout;
                cnt <=0;
            end
            else
                cnt <= cnt+1;
        end
    end
    
always @(scan_cnt)
    begin
        if(!rst)begin
                case (scan_cnt)
                    0: Y_r = Y_r_0;
                    1: Y_r = Y_r_1;
                    2: Y_r = Y_r_2;
                    3: Y_r = Y_r_3;
                    default: Y_r = 7'b1111111;
                endcase
        end
        else Y_r = 7'b1111111;
    end
    
endmodule

