`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 21:10:03
// Design Name: 
// Module Name: process
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


module process(
input start_pg,
input fpga_clk,
input fpga_rst,
output reg upg_rst,
output wire rst
    );
    wire spg_bufg;
    BUFG U1(.I(start_pg),.O(spg_bufg));
    always @(posedge fpga_clk)begin
        if(spg_bufg) upg_rst=0;
        if(!fpga_rst) upg_rst=1;
    end
    
    assign rst = fpga_rst | !upg_rst;
    
endmodule
