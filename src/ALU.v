`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Paige Larson
// 
// Create Date: 11/25/2024 02:30:50 AM
// Design Name: 
// Module Name: ALU
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

module ALU #(
    parameter ALU_NO = 0
)(
    // inputs: clk, restart
    // in an array for each instr: data from src1 and src2/imm, aluOp, which FU they go to 
    input           clk, 
    input           rstn,
    input [2:0]     alu_number,
    input [3:0]     optype,

    input [31:0]    data_in_sr1,
    input [31:0]    data_in_sr2,
    input [31:0]    data_in_imm,
    input [5:0]     dr_in,

    //outputs: data for dest reg
    output reg [31:0]   data_out_dr,
    output reg [5:0]    dr_out,
    output reg          FU_ready,
    output reg          FU_is_using
);
        
    always @(*) begin
        if (~rstn) begin
            data_out_dr = 32'b0;
            dr_out      = 6'b0;
            FU_ready    = 1'b1;
            FU_is_using = 1'b0;
        end 
        else begin
            FU_is_using = 1'b0;
            if (alu_number[ALU_NO] == 1) begin
                dr_out      = dr_in;
                FU_ready    = 1'b0;  
                FU_is_using = 1'b1;
                case(optype)
                    4'd1:
                        //ADD
                        data_out_dr = data_in_sr1 + data_in_sr2;
                    4'd2:
                        //ADDI
                        data_out_dr = data_in_sr1 + data_in_imm;
                    4'd3:
                        //LUI
                        data_out_dr = data_in_imm << 12;
                    4'd4:
                        //ORI
                        data_out_dr = data_in_sr1 | data_in_imm;
                    4'd5:
                        //XOR
                        data_out_dr = data_in_sr1 ^ data_in_sr2;
                    4'd6:
                        //SRAI
                        data_out_dr = data_in_sr1 >> data_in_imm[4:0];
                    4'd7:
                        //LB
                        data_out_dr = data_in_sr1 + data_in_imm;
                    4'd8:
                        //LW
                        data_out_dr = data_in_sr1 + data_in_imm;
                    4'd8:
                        //SB
                        data_out_dr = data_in_sr1 + data_in_imm;
                    4'd9:
                        //SW
                        data_out_dr = data_in_sr1 + data_in_imm;
                endcase                     

                FU_ready    = 1'b1;
            end 
        end
    end

endmodule