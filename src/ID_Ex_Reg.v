///////////////////////////////////////////////////////////////////
// Function: module for pipeline register between ID and EX stage
//
// Author: Yudong Zhou, tested Paige Larson
//
// Create date: 11/16/2024
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module ID_EX_Reg (
    input           clk,
    input           rstn,
    input           stall,
    
    input [6:0]     opcode_in,
    input [2:0]     funct3_in,
    input [6:0]     funct7_in,
    input [4:0]     srcReg1_in,
    input [4:0]     srcReg2_in,
    input [4:0]     destReg_in,
    input [31:0]    imm_in,
    input [1:0]     lwSw_in,
    input           regWrite_in,
    input           memRead_in,
    input           memWrite_in,
    input           memToReg_in,
    input           hasImm_in,
    input [31:0]    PC_in,

    output reg          hasImm_out,
    output reg [6:0]    opcode_out,
    output reg [2:0]    funct3_out,
    output reg [6:0]    funct7_out,
    output reg [4:0]    srcReg1_out,
    output reg [4:0]    srcReg2_out,
    output reg [4:0]    destReg_out,
    output reg [31:0]   imm_out,
    output reg [1:0]    lwSw_out,
    output reg          regWrite_out,
    output reg          memRead_out,
    output reg          memWrite_out,
    output reg          memToReg_out,
    output reg [31:0]   PC_out,

    output reg          is_dispatching    
);

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            opcode_out      <= 7'b0;
            funct3_out      <= 3'b0;
            funct7_out      <= 7'b0;
            srcReg1_out     <= 5'b0;
            srcReg2_out     <= 5'b0;
            destReg_out     <= 5'b0;
            imm_out         <= 32'b0;
            lwSw_out        <= 2'b0;
            regWrite_out    <= 1'b0;
            memRead_out     <= 1'b0;
            memWrite_out    <= 1'b0;
            memToReg_out    <= 1'b0;
            hasImm_out      <= 1'b0;
            PC_out          <= 32'b0;
            is_dispatching  <= 1'b0;
        end
        else begin
            opcode_out      <= opcode_in;
            funct3_out      <= funct3_in;
            funct7_out      <= funct7_in;
            srcReg1_out     <= srcReg1_in;
            srcReg2_out     <= srcReg2_in;
            destReg_out     <= destReg_in;
            imm_out         <= imm_in;
            lwSw_out        <= lwSw_in;
            regWrite_out    <= regWrite_in;
            memRead_out     <= memRead_in;
            memWrite_out    <= memWrite_in;
            memToReg_out    <= memToReg_in;
            hasImm_out      <= hasImm_in;
            PC_out          <= PC_in;
        end
        
        // if the pipeline is stalled or all instructions have been fetched, stop dispatching
        if (~stall && (opcode_in != 0))begin
            is_dispatching = 1'b1;
        end
        else begin
            is_dispatching = 1'b0;
        end
    end

endmodule