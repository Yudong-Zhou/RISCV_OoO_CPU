`timescale 1ns/1ps

/*
Load-Store Queue:
* Size = 16 instructions
+ ------------------------------------- +
| V | PC  | Op |   Address   | Data | I |
+ - | --- | -- | ----------- | ---- | - |
| 1 | 0x4 | S  | 0x1...      | .... | 0 |
| 1 | 0x8 | L  | 0x2...      |      | 0 | 
| 0 |     |    |             |      | 0 |
| 0 |     |    |             |      | 0 |
| 0 |     |    |             |      | 0 |
| 0 |     |    |             |      | 0 |
+ ------------------------------------- +

FUNCTIONALITY:  1. in-order dispatch,
                2. out-of-order execution,
                3. in-order issue and retirement
                4. load the most recent store data to the same address
*/

module LSQ(
    input           clk, 
    input           rstn,

    // from dispatch ... receives instruction address, whether read/write, and rs2 val if SW
    input [5:0]     reg_dis,
    input [31:0]    pcDis,
    input           memRead,
    input           memWrite,
    input [31:0]    pc_issue,
    input [31:0]    swData,

    // from LSU ... receives instruction address (to match) & computed address: rs1+offset
    input [31:0]    pcLsu,
    input [31:0]    addressLsu,

    // from retirement ... deallocate space in LSQ
    input [31:0]    pcRet1,
    input [31:0]    pcRet2,

    input           has_stored,
    input [31:0]    data_check,

    // outputs ... issues instruction; completes LW instruction if store seen in LSQ
    output reg [31:0]   pcOut,
    output reg [5:0]    regout,
    output reg [31:0]   addressOut,
    output reg [31:0]   Data_out,
    output reg          loadStore, // 0 if load, 1 if store
    output reg          already_found, // 1 if LW and data is found in LSQ
    output reg          no_issue   // 1 if no instruction is issued
);
    
    // LSQ fields ...
    reg [15:0] VALID;
    reg [31:0] PC [15:0];
    reg [15:0] OP; // 0: load, 1: store
    reg [31:0] ADDRESS [15:0];
    reg [5:0]  REG [15:0];
    reg [31:0] LSQ_DATA [15:0];
    reg [15:0] FOUND;
    reg [15:0] ISSUED;
    
    // dispatch pointer of LSQ, in-order dispatch
    reg [4:0]  dis_pointer;
    reg [4:0]  issue_pointer;
    integer i,j;
    integer k;

    always @(*) begin
        for (k = 0; k < 16; k = k + 1) begin
            if((pc_issue == PC[k]) && VALID[k] && OP[k]) begin
                LSQ_DATA[k] = swData;
            end 
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin // on reset, set all LSQ entries to 0 ...
            VALID   = 16'b0;
            OP      = 16'b0;
            ISSUED  = 16'b0;
            FOUND   = 16'b0;
            for (i = 0; i < 16; i = i + 1) begin
                PC[i]       = 32'b0;
                ADDRESS[i]  = 32'b0;
                LSQ_DATA[i] = 32'b0;
                REG[i]      = 6'b0;
            end
            pcOut           = 32'b0;
            addressOut      = 32'b0;
            Data_out        = 32'b0;
            dis_pointer     = 5'b0;
            issue_pointer   = 5'b0;
            no_issue        = 1;
            already_found   = 0;
            regout          = 6'b0;
        end 
        else begin 
            // dispatch logic ... if read/write, reserve space in LSQ
            if (memRead || memWrite) begin
                if (~VALID[dis_pointer]) begin // find vacant entry ...
                    VALID[dis_pointer]    = 1;
                    PC[dis_pointer]       = pcDis;
                    OP[dis_pointer]       = memWrite; // 0 if load, 1 if store
                    REG[dis_pointer]      = reg_dis;
                    // temporarily not consider the siutation where all LSQ entries are full
                    dis_pointer = dis_pointer + 1;
                    if (dis_pointer == 16) begin
                        dis_pointer = 0;
                    end
                end
            end
        end
    end

    always @(*) begin
        // retirement logic ... deallocate LSQ entry
        if (has_stored) begin
            for (i = 0; i < 16; i = i + 1) begin
                if (LSQ_DATA[i] == data_check) begin
                    VALID[i]    = 0;
                    PC[i]       = 0;
                    OP[i]       = 0;
                    ADDRESS[i]  = 32'b0;
                    LSQ_DATA[i] = 32'b0;
                    ISSUED[i]   = 0;
                    i = 16;
                end
            end
        end
        
        // execution logic ... if update address in LSQ entry; if load, 
        // scan LSQ to find matching addresses, provide data for latest not issued store
        for (i = 0; i < 16; i = i + 1) begin
            if (PC[i] == pcLsu) begin
                ADDRESS[i] = addressLsu;
                j = i - 1;
                for (j = i - 1; j >= 0; j = j - 1) begin
                    if ((~OP[i]) && (ADDRESS[j] == ADDRESS[i]) && OP[j]  && VALID[j]) begin
                        LSQ_DATA[i] = LSQ_DATA[j];
                        FOUND[i]    = 1;
                        // populate LW data with the most recent store to the same address
                        j = -1;
                    end
                end
                i = 16;
            end
        end

        // issue logic ... issue load data and store data of the matched PC from LSU
        for (i = 0; i < 16; i = i + 1) begin
            if ((~ISSUED[i]) && (PC[i] == pcLsu)) begin
                if(i == issue_pointer) begin
                    if ((REG[i] != 0) && ~OP[i]) begin
                        regout = REG[i];
                    end
                    pcOut           = PC[i];
                    addressOut      = ADDRESS[i];
                    Data_out        = LSQ_DATA[i];
                    already_found   = FOUND[i];
                    loadStore       = OP[i];
                    no_issue        = 0;
                    ISSUED[i]       = 1;
                    i = 16;

                    issue_pointer = issue_pointer + 1;
                    if(issue_pointer == 16) begin
                        issue_pointer = 0;
                    end
                end
                else begin
                    no_issue = 1;
                    already_found = 0;
                    i = 16;
                end
            end
            else begin
                no_issue = 1;
                already_found = 0;
            end
        end

    end

endmodule