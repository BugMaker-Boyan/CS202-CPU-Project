`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/11 23:34:50
// Design Name: 
// Module Name: MemoryOrIO
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


module MemoryOrIO(
input mRead, // read memory, from control32 
input mWrite, // write memory, from control32 
input ioRead, // read IO, from control32 
input ioWrite, // write IO, from control32 

input[31:0] addr_in, // from alu_result in executs32
output[31:0] addr_out, // address to memory 

input[31:0] m_rdata, // data read from memory 
input[15:0] io_rdata1, // data read from io,16 bits 
input[15:0] io_rdata2, // data read from io,16 bits 
output[31:0] r_wdata, // data to idecode32(register file) 

input[31:0] r_rdata, // data read from idecode32(register file) 
output reg[31:0] write_data, // data to memory or I/O£¨m_wdata, io_wdata£© 
output LEDCtrl, // LED Chip Select 
output SwitchCtrl, // Switch Chip Select
output SegCtrl,
output BoardCtrl,
output[1:0] lowAddr,
output [15:0] ledLowData
);

assign lowAddr = addr_in[1:0];
assign ledLowData = write_data[15:0];

assign addr_out = addr_in;
wire [15:0] io_rdata;

assign io_rdata = (lowAddr==2'b11)?{io_rdata2}:{io_rdata1};

assign r_wdata = (mRead==1'B1)?m_rdata:{16'B0,io_rdata};

assign LEDCtrl = ioWrite==1?1'B1:1'B0;
assign SwitchCtrl = ioRead==1?1'B1:1'B0;
assign SegCtrl = ioWrite==1?1'B1:1'B0;
assign BoardCtrl = ioRead==1?1'B1:1'B0;


always @* begin
    if ((mWrite == 1) || (ioWrite == 1)) begin
        write_data = r_rdata;
    end
    else begin
        write_data = 32'hZZZZZZZZ;
    end
end

endmodule
