////////////////////////////////////////////////////////////////////////////////////////////
// Function: module for Architectural Register File of RISC-V Out-of-Order Processor
//
// Author: Yudong Zhou
//
// Create date: 11/25/2024
////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ARF #(
    parameter   AR_SIZE     =   6,      
    parameter   AR_ARRAY    =   64,     
)(
    input                       rstn,
    // can read 2 registers at the same time
    input [AR_SIZE - 1 : 0]     read_addr1,
    input [AR_SIZE - 1 : 0]     read_addr2,
    input                       read_en,
    // can retire 2 instructions at the same time at max
    input [AR_SIZE - 1 : 0]     write_addr1,
    input [31 : 0]              write_data1,
    input [AR_SIZE - 1 : 0]     write_addr2,
    input [31 : 0]              write_data2,
    input                       write_en,

    output reg [31 : 0]         read_data1,
    output reg [31 : 0]         read_data2,
);

    reg [31 : 0]    ar_file [AR_ARRAY - 1 : 0];
    integer         i;
    always @(*) begin
        if (~rstn) begin
            read_data1 <= 0;
            read_data2 <= 0;
            for (i = 0; i < AR_ARRAY; i = i + 1) begin
                ar_file[i] <= 0;
            end
        end
        else begin // might have problem for simutaneous read and write
            if (write_en) begin
                if (write_addr1 != 0) begin // p0 is always 0
                    ar_file[write_addr1] = write_data1;
                end
                if (write_addr2 != 0) begin
                    ar_file[write_addr2] = write_data2;
                end
            end
            if (read_en) begin
                read_data1 = ar_file[read_addr1];
                read_data2 = ar_file[read_addr2];
            end
        end
    end

endmodule