`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 22:52:31
// Design Name: 
// Module Name: programrom
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


module programrom(
input rom_clk_i,
input [13:0] rom_adr_i,
output [31:0] Instruction_o,

input upg_rst_i,
input upg_clk_i,
input upg_wen_i,
input [14:0] upg_adr_i,
input [31:0] upg_dat_i,
input upg_done_i
    );
    wire upg_wen = upg_wen_i & (!upg_adr_i[14]);
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    
    program instmem(
        .clka(kickOff?rom_clk_i:upg_clk_i),
        .wea(kickOff?1'b0:upg_wen),
        .addra(kickOff?rom_adr_i:upg_adr_i[13:0]),
        .dina(kickOff?32'h00000000:upg_dat_i),
        .douta(Instruction_o)
    );
endmodule
