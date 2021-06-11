`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 10:37:44
// Design Name: 
// Module Name: Executs32
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


module Executs32(
input [31:0] Read_data_1,
input [31:0] Read_data_2,
input [31:0] Imme_extend,
input [5:0] Function_opcode,
input [5:0] opcode,
input [1:0] ALUOp,
input [4:0] Shamt,
input Sftmd,
input ALUSrc,
input I_format,
input Jr,
input [31:0] PC_plus_4,
output Zero,
output reg [31:0] ALU_Result,
output [31:0] Addr_Result,
output [21:0] ALU_ResultHigh
    );
    
    wire [31:0] Ainput;
    wire [31:0] Binput;
    //wire [31:0] signAinput;
    //wire [31:0] signBinput;
    wire [5:0] Exe_code;
    wire [2:0] ALU_ctl;
    wire [2:0] Sftm;
    reg [31:0] ALU_output_mux;
    reg [31:0] Shift_Result;
    wire [32:0] Branch_Addr;
    
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc==0)?Read_data_2:Imme_extend;
    //assign signAinput = $signed(Ainput);
    //assign signBinput = $signed(Binput);

    assign Exe_code = (I_format==0)?Function_opcode:{3'b000,opcode[2:0]};
    
    assign ALU_ctl[0] = (Exe_code[0]|Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2])|(!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    assign Zero = (ALU_output_mux == 32'b0)?1'b1:1'b0;
    
    assign ALU_ResultHigh = ALU_Result[31:10];
    
    always @(ALU_ctl or Ainput or Binput) begin
        case(ALU_ctl)
            3'b000: ALU_output_mux = Ainput & Binput;
            3'b001: ALU_output_mux = Ainput | Binput;
            3'b010: ALU_output_mux = $signed(Ainput) + $signed(Binput); // sign
            3'b011: ALU_output_mux = Ainput + Binput; // unsign
            3'b100: ALU_output_mux = Ainput ^ Binput;
            3'b101: ALU_output_mux = ~(Ainput | Binput);
            3'b110: ALU_output_mux = $signed(Ainput) - $signed(Binput); // sign
            3'b111: ALU_output_mux = Ainput - Binput; // unsign
            default: ALU_output_mux = 32'h00000000;
        endcase
    end
    
    assign Sftm = Function_opcode[2:0];
    assign Branch_Addr = (PC_plus_4[31:2]) + Imme_extend;
    assign Addr_Result = Branch_Addr[31:0];
    always @(*) begin
        if(Sftmd) begin
            case(Sftm)
                3'b000: Shift_Result = Binput << Shamt;
                3'b010: Shift_Result = Binput >> Shamt;
                3'b100: Shift_Result = Binput << Ainput;
                3'b110: Shift_Result = Binput >> Ainput;
                3'b011: Shift_Result = $signed(Binput) >>> Shamt;
                3'b111: Shift_Result = $signed(Binput) >>> Ainput;
                default: Shift_Result = Binput;
            endcase
        end
        else begin
            Shift_Result = Binput;
        end
    end
    
    always @(*) begin 
        //set type operation (slt, slti, sltu, sltiu) 
        if((ALU_ctl==3'b111) && (Exe_code[3:0]==4'b1011)) //sltu
           ALU_Result = (Ainput-Binput<0); 
        else if((ALU_ctl==3'b111) && (Exe_code[3:0]==4'b1010)) //slt
            ALU_Result = ($signed(Ainput)-$signed(Binput)<0); 
        else if((ALU_ctl==3'b111) && (Exe_code[3:0]==4'b0011) && I_format == 1'b1) //sltiu
            ALU_Result = (Ainput-Binput<0);
        else if((ALU_ctl==3'b110) && (Exe_code[3:0]==4'b0010) &&I_format == 1'b1) //slti
           ALU_Result = ($signed(Ainput)-$signed(Binput)<0); 
        //if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1)))
        //    ALU_Result = ($signed($signed(Ainput)-$signed(Binput))<0);   
                                 
        //lui operation 
        else if((ALU_ctl==3'b101) && (I_format==1)) 
            ALU_Result[31:0]={Binput[15:0],{16{1'b0}}}; 
    
        //shift operation 
        else if(Sftmd==1) 
            ALU_Result = Shift_Result ; 
    
        //other types of operation in ALU (arithmatic or logic calculation) 
        else 
            ALU_Result = ALU_output_mux[31:0]; 
        end
           
    
endmodule


  
//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////

//module Executs32(Read_data_1,Read_data_2,Imme_extend,Function_opcode,opcode,ALUOp,
//                 Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4,ALU_ResultHigh
//                 );
//    input[31:0]  Read_data_1;		// 从译码单元的Read_data_1中来
//    input[31:0]  Read_data_2;		// 从译码单元的Read_data_2中来
//    input[31:0]  Imme_extend;		// 从译码单元来的扩展后的立即数
//    input[5:0]   Function_opcode;  	// 取址单元来的r-类型指令功能码,r-form instructions[5:0]
//    input[5:0]   opcode;  		// 取址单元来的操作码,取指单元来的操作码，instruction[31:26] 
//    input[1:0]   ALUOp;             // 来自控制单元的运算指令控制编码
//    input[4:0]   Shamt;             // 来自取址单元的instruction[10:6]，指定移位次数
//    input  		 Sftmd;            // 来自控制单元的，表明是移位指令
//    input        ALUSrc;            // 来自控制单元，表明第二个操作数是立即数（beq，bne除外）
//    input        I_format;          // 来自控制单元，表明是除beq, bne, LW, SW之外的I-类型指令
//    input        Jr;               // 来自控制单元，书名是JR指令
//    output       Zero;              // 为1表明计算值为0 
//    output[31:0] ALU_Result;        // 计算的数据结果
//    output[31:0] Addr_Result;		// 计算的地址结果        
//    input[31:0]  PC_plus_4;         // 来自取指单元的PC+4
//output [21:0] ALU_ResultHigh;
//    wire [4:0]Shamt;
////    reg [4:0] Shamt;
//    reg[31:0] ALU_Result;
//    wire[31:0] Ainput,Binput;
//    reg[31:0] Sinput;
//    reg[31:0] ALU_output_mux;
//    wire[32:0] Branch_Add;
//    wire[2:0] ALU_ctl;
//    wire[5:0] Exe_code;
//    wire[2:0] Sftm;
//    wire Sftmd;
    
//    assign Sftm = Function_opcode[2:0];   // 实际有用的只有低三位(移位指令）
//    assign Exe_code = (I_format==0) ? Function_opcode : {3'b000,opcode[2:0]};
//    assign Ainput = Read_data_1;
//    assign Binput = (ALUSrc == 0) ? Read_data_2 : Imme_extend[31:0]; //R/LW,SW  sft  else的时候含LW和SW
//    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];      //24H AND 
//    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
//    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
//    assign ALU_ResultHigh = ALU_Result[31:10];


//always @* begin  // 6种移位指令
//       if(Sftmd)
//        case(Sftm[2:0])
//            3'b000:Sinput = Binput << Shamt	;   //Sll rd,rt,shamt  00000
//            3'b010:Sinput = Binput >> Shamt;  		       //Srl rd,rt,shamt  00010
//            3'b100:Sinput = Binput << Ainput;               //Sllv rd,rt,rs 000100
//            3'b110:Sinput = Binput >> Ainput;                   //Srlv rd,rt,rs 000110
//            3'b011:Sinput = $signed(Binput) >>> Shamt;     		//Sra rd,rt,shamt 00011
//            3'b111:Sinput = Binput >>> Ainput;       //Srav rd,rt,rs 00111
//            default:Sinput = Binput;
//        endcase
//       else Sinput = Binput;
//    end
 
//    always @* begin
//        if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1))) //slti(sub)  处理所有SLT类的问题
//           ALU_Result = ALU_output_mux[31]==1? 1:0;
//        else if((ALU_ctl==3'b101) && (I_format==1)) ALU_Result[31:0] = { {Binput[15:0]} , {16{1'b0}} }  ;   //lui data
//        else if(Sftmd==1) ALU_Result = Sinput  ;   //  移位
//        else  ALU_Result = ALU_output_mux[31:0];   //otherwise
//    end
 
//    assign Branch_Add = PC_plus_4[31:2] +  Imme_extend[31:0];
//    assign Addr_Result = Branch_Add[31:0];   //算出的下一个PC值已经做了除4处理，所以不需左移2位
//    assign Zero = (ALU_output_mux[31:0] == 32'h00000000) ? 1'b1 : 1'b0;
    
//    always @(ALU_ctl or Ainput or Binput) begin
//        case(ALU_ctl)
//            3'b000:ALU_output_mux = Ainput & Binput;
//            3'b001:ALU_output_mux = Ainput | Binput;
//            3'b010:ALU_output_mux = Ainput + Binput;
//            3'b011:ALU_output_mux = Ainput + Binput;
//            3'b100:ALU_output_mux = Ainput ^ Binput;
//            3'b101:ALU_output_mux = ~(Ainput | Binput);
//            3'b110:ALU_output_mux = Ainput-Binput;
//            3'b111:ALU_output_mux = Ainput-Binput;
//            default:ALU_output_mux = 32'h00000000;
//        endcase
//    end
//endmodule