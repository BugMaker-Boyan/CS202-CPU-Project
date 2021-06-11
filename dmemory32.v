`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/07 22:09:05
// Design Name: 
// Module Name: dmemory32
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


module dmemory32(
input ram_clk_i,
input ram_wen_i,
input[31:0] ram_adr_i,
input[31:0] ram_dat_i,
output[31:0] ram_dat_o,

input upg_rst_i,
input upg_clk_i,
input upg_wen_i,
input[14:0] upg_adr_i,
input[31:0] upg_dat_i,
input upg_done_i
    );
    
    wire ram_clk = !ram_clk_i;
    
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    
    wire upg_wen = upg_wen_i & upg_adr_i[14];
    
    RAM ram(
    .addra(kickOff?ram_adr_i:upg_adr_i[13:0]),
    .wea(kickOff?ram_wen_i:upg_wen),
    .clka(kickOff?ram_clk:upg_clk_i),
    .dina(kickOff?ram_dat_i:upg_dat_i),
    .douta(ram_dat_o)
    );

endmodule
