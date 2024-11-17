///////////////////////////////////////////////////////////////////
// Function: module for pipeline register between IF and ID stage
//
// Author: Yudong Zhou
//
// Create date: 11/16/2024
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module IF_ID_Reg (
    input           clk,
    input           rstn,
    input [31:0]    inst_IF_in,

    output [31:0]   inst_ID_out
);

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            inst_ID_out <= 32'b0;
        end
        else begin
            inst_ID_out <= inst_IF_in;
        end
    end

endmodule