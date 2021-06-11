`timescale 1ns / 1ps

module Ifetc32(
branch_base_addr,Addr_result,
Read_data_1,
Branch,nBranch,
Jmp,Jal,Jr,
Zero,
clock,reset,
link_addr,
opcode,shamt,func,rom_adr_o,Instruction_i,Instruction_o
    );
    input [31:0] Instruction_i;
    output[31:0] Instruction_o; // the instruction fetched from this module
    output[31:0] branch_base_addr; // (pc+4) to ALU which is used by branch type instruction
    input[31:0] Addr_result; // the calculated address from ALU
    input[31:0] Read_data_1; // the address of instruction used by jr instruction
    input Branch; // while Branch is 1,it means current instruction is beq
    input nBranch; // while nBranch is 1,it means current instruction is bnq
    input Jmp; // while Jmp 1,it means current instruction is jump
    input Jal; // while Jal is 1,it means current instruction is jal
    input Jr; // while Jr is 1,it means current instruction is jr
    
    input Zero; // while Zero is 1, it means the ALUresult is zero

    input clock,reset; // Clock and reset
    
    output reg[31:0] link_addr; // (pc+4) to decoder which is used by jal instruction
    output [5:0] opcode;
    output [4:0] shamt;
    output [5:0] func;
    output [13:0] rom_adr_o;
    assign opcode = Instruction_i[31:26];
    assign shamt = Instruction_i[10:6];
    assign func = Instruction_i[5:0];

    reg[31:0] PC,Next_PC;
    assign rom_adr_o = PC[15:2];
    assign branch_base_addr = PC + 32'd4;
    assign Instruction_o = Instruction_i;

    always@* begin
        if(((Branch == 1'b1) && (Zero == 1'b1 )) || ((nBranch == 1'b1) && (Zero == 1'b0)))
            Next_PC = Addr_result * 4;
        else if(Jr == 1'b1)
            Next_PC = Read_data_1 * 4;
        else 
            Next_PC = PC + 32'd4;
    end
    
    always @(Jal or Jmp)begin
        if(Jal == 1'b1 || Jmp == 1'b1) begin
            link_addr <= (PC + 32'd4)/4;
        end
    end
    
    always@(negedge clock)begin
        if(reset == 1'b1)
            PC <= 32'h00000000;
        else if(Jal == 1'b1 || Jmp == 1'b1)begin
            PC <= {PC[31:28],Instruction_i[25:0],2'b00};
            end
        else PC <= Next_PC;
    end
endmodule