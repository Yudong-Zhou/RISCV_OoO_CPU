`timescale 1ns/1ps

/*
    * 1 read/write port – can only process one instruction at a time; if another instruction pending, must stall
    * memoryHierarchy needs to handle calling to cache first (returning in one cycle), if Miss -> call to DataMemory
*/

module DataMemory(
    input           clk,
    input           rstn,
    input [31:0]    inst_pc_in,
    input [31:0]    address_in, 
    input [5:0]     reg_in,
    input [3:0]     optype,
    input [31:0]    dataSw_in,
    input           read_en,
    input           write_en_in,
    input           cacheMiss,
    
    output reg [31:0]   inst_pc_out,
    output reg [5:0]    reg_out,
    output reg [31:0]   lwData_out,
    output reg          data_vaild_out
);

    parameter LB    =  4'd7;
    parameter LW    =  4'd8;
    parameter SB    =  4'd9;
    parameter SW    =  4'd10;

    reg [31:0]    DATAMEM [0:1024]; 

    reg [5:0]       reg0;
    reg [5:0]       reg1;
    reg [5:0]       reg2;
    reg [5:0]       reg3;
    reg [5:0]       reg4;
    reg [5:0]       reg5;
    reg [5:0]       reg6;
    reg [5:0]       reg7;
    reg [5:0]       reg8;
    reg [5:0]       reg9;

    reg [31:0]      addr1;
    reg [31:0]      addr2;
    reg [31:0]      addr3;
    reg [31:0]      addr4;
    reg [31:0]      addr5;
    reg [31:0]      addr6;
    reg [31:0]      addr7;
    reg [31:0]      addr8;
    reg [31:0]      addr9;
    reg [31:0]      address;

    reg             write_en;
    reg             write_en1;
    reg             write_en2;
    reg             write_en3;
    reg             write_en4;
    reg             write_en5;
    reg             write_en6;
    reg             write_en7;
    reg             write_en8;
    reg             write_en9;

    reg [31:0]      dataSw;
    reg [31:0]      dataSw1;
    reg [31:0]      dataSw2;
    reg [31:0]      dataSw3;
    reg [31:0]      dataSw4;
    reg [31:0]      dataSw5;
    reg [31:0]      dataSw6;
    reg [31:0]      dataSw7;
    reg [31:0]      dataSw8;
    reg [31:0]      dataSw9;

    reg [31:0]      lwData;
    reg [31:0]      lwData1; 
    reg [31:0]      lwData2;
    reg [31:0]      lwData3;
    reg [31:0]      lwData4;
    reg [31:0]      lwData5;
    reg [31:0]      lwData6;
    reg [31:0]      lwData7;
    reg [31:0]      lwData8;
    reg [31:0]      lwData9;

    reg             data_vaild;
    reg             data_vaild1;
    reg             data_vaild2;
    reg             data_vaild3;
    reg             data_vaild4;
    reg             data_vaild5;
    reg             data_vaild6;
    reg             data_vaild7;
    reg             data_vaild8;
    reg             data_vaild9;

    reg [31:0]      inst_pc1;
    reg [31:0]      inst_pc2;
    reg [31:0]      inst_pc3;
    reg [31:0]      inst_pc4;
    reg [31:0]      inst_pc5;
    reg [31:0]      inst_pc6;
    reg [31:0]      inst_pc7;
    reg [31:0]      inst_pc8;
    reg [31:0]      inst_pc9;

    integer i;

    always @(posedge clk) begin // 10cc delay of l/s datas
        reg1    <= reg0;
        reg2    <= reg1;
        reg3    <= reg2;
        reg4    <= reg3;
        reg5    <= reg4;
        reg6    <= reg5;
        reg7    <= reg6;
        reg8    <= reg7;
        reg9    <= reg8;
        reg_out <= reg9;

        addr1   <= address_in;
        addr2   <= addr1;
        addr3   <= addr2;
        addr4   <= addr3;
        addr5   <= addr4;
        addr6   <= addr5;
        addr7   <= addr6;
        addr8   <= addr7;
        addr9   <= addr8;
        address <= addr9;

        write_en1 <= write_en_in;
        write_en2 <= write_en1;
        write_en3 <= write_en2;
        write_en4 <= write_en3;
        write_en5 <= write_en4;
        write_en6 <= write_en5;
        write_en7 <= write_en6;
        write_en8 <= write_en7;
        write_en9 <= write_en8;
        write_en  <= write_en9;

        dataSw1   <= dataSw_in;
        dataSw2   <= dataSw1;
        dataSw3   <= dataSw2;
        dataSw4   <= dataSw3;
        dataSw5   <= dataSw4;
        dataSw6   <= dataSw5;
        dataSw7   <= dataSw6;
        dataSw8   <= dataSw7;
        dataSw9   <= dataSw8;
        dataSw    <= dataSw9;

        lwData1         <= lwData;
        lwData2         <= lwData1;
        lwData3         <= lwData2;
        lwData4         <= lwData3;
        lwData5         <= lwData4;
        lwData6         <= lwData5;
        lwData7         <= lwData6;
        lwData8         <= lwData7;
        lwData9         <= lwData8;
        lwData_out      <= lwData9;

        data_vaild1     <= data_vaild;
        data_vaild2     <= data_vaild1;
        data_vaild3     <= data_vaild2;
        data_vaild4     <= data_vaild3;
        data_vaild5     <= data_vaild4;
        data_vaild6     <= data_vaild5;
        data_vaild7     <= data_vaild6;
        data_vaild8     <= data_vaild7;
        data_vaild9     <= data_vaild8;
        data_vaild_out  <= data_vaild9;

        inst_pc1        <= inst_pc_in;
        inst_pc2        <= inst_pc1;
        inst_pc3        <= inst_pc2;
        inst_pc4        <= inst_pc3;
        inst_pc5        <= inst_pc4;
        inst_pc6        <= inst_pc5;
        inst_pc7        <= inst_pc6;
        inst_pc8        <= inst_pc7;
        inst_pc9        <= inst_pc8;
        inst_pc_out     <= inst_pc9;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < 1024; i = i + 1) begin
                DATAMEM[i] = 32'b0;
            end
            lwData_out      = 32'b0;
            data_vaild_out  = 1'b0;
        end 
        else begin
            if ((read_en || write_en) && cacheMiss) begin
                if (read_en) begin
                    if (optype == LB) begin
                        lwData = {24'b0, DATAMEM[address][7:0]};
                    end
                    else if (optype == LW) begin
                        lwData = DATAMEM[address];
                    end
                    data_vaild = 1'b1;
                    reg0 = reg_in;
                end
                else if (write_en) begin
                    if (optype == SB) begin
                        DATAMEM[address][7:0] = dataSw[7:0];
                    end 
                    else if (optype == SW) begin
                        DATAMEM[address]      = dataSw;
                    end
                end
            end
            else begin
                data_vaild = 1'b0;
            end
        end
    end

endmodule