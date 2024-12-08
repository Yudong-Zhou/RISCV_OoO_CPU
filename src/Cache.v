`timescale 1ns/1ps

/*
    * 1 read/write port – can only process one instruction at a time; if another instruction pending, must stall
    * memoryHierarchy needs to handle calling to cache first (returning in one cycle), if Miss -> call to DataMemory
*/

module Cache(
    input           clk,
    input           rstn,
    input [31:0]    inst_pc,
    input [31:0]    address_in, 
    input [5:0]     reg_in,
    input [3:0]     optype,
    input [31:0]    dataSw,
    input           read_en,
    input           write_en,
    
    output reg [31:0]   inst_pc_out,
    output reg [31:0]   address_out,
    output reg [5:0]    reg_out,
    output reg [31:0]   datasw_out,
    output reg [31:0]   lwData_out,
    output reg          data_vaild_out,
    output reg          has_stored,
    output reg [31:0]   data_check,
    output reg          cache_miss,
    output reg [3:0]    optype_out
);

    parameter LB    =  4'd7;
    parameter LW    =  4'd8;
    parameter SB    =  4'd9;
    parameter SW    =  4'd10;

    reg [31:0]      CACHE [0:8096]; 
    reg [18:0]      TAG [0:8096];
    wire [31:0]     address;

    assign address = address_in << 19;
    assign address = address    >> 21;

    integer i;

    always @(posedge clk) begin
        inst_pc_out <= inst_pc;
        address_out <= address_in;
        reg_out     <= reg_in;
        datasw_out  <= dataSw;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < 8096; i = i + 1) begin
                CACHE[i] = 32'b0;
                TAG[i]   = 19'b0;
            end
            lwData_out      = 32'b0;
            data_vaild_out  = 1'b0;
            has_stored      = 1'b0;
            data_check      = 32'b0;
            cache_miss      = 1'b0;
            optype_out      = 4'b0;
        end 
        else begin
            data_vaild_out = 1'b0;
            has_stored     = 1'b0;
            cache_miss     = 1'b0;
            optype_out     = 4'b0;
            if (read_en || write_en) begin
                if ((optype == LB) && (address_in[31:13] == TAG[address])) begin
                    lwData_out      = {24'b0, CACHE[address][7:0]};
                    data_vaild_out  = 1'b1;
                end
                else begin
                    cache_miss = 1'b1;
                    optype_out = optype;
                end
                
                if ((optype == LW) && (address_in[31:13] == TAG[address])) begin
                    lwData_out      = CACHE[address];
                    data_vaild_out  = 1'b1;
                end
                else begin
                    cache_miss = 1'b1;
                    optype_out = optype;
                end

                if (optype == SB) begin
                    CACHE[address][7:0] = dataSw[7:0];
                    TAG[address]        = address_in[31:13];
                    data_check = dataSw; 
                    has_stored = 1'b1;
                end 
                else if (optype == SW) begin
                    CACHE[address]      = dataSw;
                    TAG[address]        = address_in[31:13];
                    data_check = dataSw; 
                    has_stored = 1'b1;
                end
            end
        end
    end

endmodule