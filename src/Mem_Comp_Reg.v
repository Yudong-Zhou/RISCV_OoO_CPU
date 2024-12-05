///////////////////////////////////////////////////////////////////
// Function: module for pipeline register between MEM and COMPLETE stage
//
// Author: Yudong Zhou
//
// Create date: 12/4/2024
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module MEM_Comp_Reg (
    input           clk,
    input           rstn,
    input [31:0]    from_lsq,
    input           mem_vaild,

    input [31:0]    lwData_from_LSQ_in,
    input [31:0]    lwData_from_MEM_in,
    input [31:0]    pc_from_LSU_in,
    input [31:0]    pc_from_MEM_in,

    output reg [31:0]   lwData_out,
    output reg [31:0]   pc_out,
    output reg          vaild_out,
    output reg          lsq_out
);

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            lwData_out  <= 32'b0;
            pc_out      <= 32'b0;
            vaild_out   <= 1'b0;
            lsq_out     <= 1'b0;
        end
        else begin
            if (from_lsq) begin
                lwData_out  <= lwData_from_LSQ_in;
                pc_out      <= pc_from_LSU_in;
            end
            else if (mem_vaild) begin
                lwData_out  <= lwData_from_MEM_in;
                pc_out      <= pc_from_MEM_in;
            end
            vaild_out   <= mem_vaild;
            lsq_out     <= from_lsq;
        end
    end

endmodule