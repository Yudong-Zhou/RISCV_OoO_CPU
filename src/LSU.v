///////////////////////////////////////////////////////////////////
// Function: module for Load / Store Unit
//
// Author: Yudong Zhou
//
// Create date: 12/4/2024
//
// Implementation details:
//
///////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module LSU(
    input [31 : 0]          mem_addr_in,
    input [5 : 0]           reg_in,
    input [31 : 0]          inst_pc_in,
    input [3 : 0]           op_in,
    input [31 : 0]          lwData_from_LSQ_in,
    input [31 : 0]          store_data_from_LSQ_in,
    input                   loadstore_from_LSQ_in,
    input                   already_found_from_LSQ_in,
    input                   no_issue_from_LSQ_in,

    output reg [31 : 0]     mem_addr_out,
    output reg [5:0]        reg_out1,
    output reg [5:0]        reg_out2,
    output reg [31 : 0]     inst_pc_out,
    output reg [3 : 0]      op_out,
    output reg [31 : 0]     store_data_to_mem_out,
    output reg [31 : 0]     load_data_to_comp_out,
    output reg              write_en_out,
    output reg              read_en_out,
    output reg              from_lsq
);

    parameter LB    =  4'd7;
    parameter LW    =  4'd8;
    parameter SB    =  4'd9;
    parameter SW    =  4'd10;

    wire is_LS;
    assign is_LS = (op_in == LB) || (op_in == LW) || (op_in == SB) || (op_in == SW);
    always @(*) begin
        if (is_LS) begin
            inst_pc_out     = inst_pc_in;
            mem_addr_out    = mem_addr_in;
            op_out          = op_in;
            if (~no_issue_from_LSQ_in) begin // issue vaild from lsq
                if (~loadstore_from_LSQ_in) begin // inst is read
                    if (already_found_from_LSQ_in) begin // data is found in LSQ
                        load_data_to_comp_out = lwData_from_LSQ_in;
                        from_lsq              = 1'b1;
                        read_en_out           = 1'b0; // no need to read from memory
                    end
                    else begin  // data is not found in LSQ
                        from_lsq              = 1'b0;
                        read_en_out           = 1'b1; // read from memory
                    end
                end
                else begin // inst is write
                    store_data_to_mem_out = store_data_from_LSQ_in;
                    write_en_out          = 1'b1;
                end
            end
            else begin
                read_en_out     = 1'b0;
                from_lsq        = 1'b0;
                write_en_out    = 1'b0;
            end
            if ((op_in == LB || op_in == LW) && (from_lsq)) begin
                reg_out1 = reg_in;
            end
            else if ((op_in == LB || op_in == LW) && read_en_out) begin
                reg_out2 = reg_in;
            end
            else begin 
                reg_out1 = 6'b0;
                reg_out2 = 6'b0;
            end
        end
        else begin
                read_en_out     = 1'b0;
                from_lsq        = 1'b0;
                write_en_out    = 1'b0;
        end
    end
    
endmodule