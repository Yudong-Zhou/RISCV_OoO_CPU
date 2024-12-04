`timescale 1ns / 1ps

module CPU #(
    parameter   AR_SIZE     =   6,      // Architectural Register size = 2^6 = 64 registers
    parameter   AR_ARRAY    =   64,     // AR number = 64
    parameter   FU_SIZE     =   2,      // FU size  = 2^2 >= 3 units
    parameter   FU_ARRAY    =   3,      // FU number = 3
    parameter   ISSUE_NUM   =   3,      // can issue 3 instructions max at the same time
    parameter   ROB_SIZE    =   6       // ROB size = 2^6 = 64 instructions
)(
    input   clk,
    input   rstn
);
    
    // IF stage signals
    wire [31 : 0]   PC;
    reg [31 : 0]    PC_reg;
    wire [31 : 0]   instr_IF;
    wire            stop_IF;

    // ID stage signals
    wire [31 : 0]   PC_ID;
    wire [31 : 0]   instr_ID;
    wire            stop_ID;

    wire [6 : 0]    opcode_ID;
    wire [2 : 0]    funct3_ID; 
    wire [6 : 0]    funct7_ID;
    wire [4 : 0]    srcReg1_ID;
    wire [4 : 0]    srcReg2_ID;
    wire [4 : 0]    destReg_ID;
    wire [31 : 0]   imm_ID;
    wire [1 : 0]    lwSw_ID;
    wire [1 : 0]    aluOp_ID; 
    wire            regWrite_ID;
    wire            aluSrc_ID;
    wire            branch_ID;
    wire            memRead_ID;
    wire            memWrite_ID;
    wire            memToReg_ID;
    wire            hasImm_ID;
    
    // LSQ
    wire [31 : 0]   pc_from_lsq;
    wire [31 : 0]   adr_from_lsq;
    wire [31 : 0]   lwdata_from_lsq;
    wire            ls_from_lsq;
    wire            complete_from_lsq;

    // ALU output signals
    wire [31 : 0]   data_out_dr_alu0;
    wire [5 : 0]    dr_out_alu0;
    wire            FU_ready_alu0;
    wire            FU_is_using_alu0;
    wire [31 : 0]   data_out_dr_alu1;
    wire [5 : 0]    dr_out_alu1;
    wire            FU_ready_alu1;
    wire            FU_is_using_alu1;
    wire [31 : 0]   data_out_dr_alu2;
    wire [5 : 0]    dr_out_alu2;
    wire            FU_ready_alu2;
    wire            FU_is_using_alu2;

    wire [FU_ARRAY - 1 : 0]     fu_ready_from_FU;

    // Unified Issue Queue signals
    wire [3 : 0]                op_out0_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rs1_out0_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rs2_out0_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rd_out0_from_UIQ;
    wire [31 : 0]               rs1_value_out0_from_UIQ;
    wire [31 : 0]               rs2_value_out0_from_UIQ;
    wire [31 : 0]               imm_value_out0_from_UIQ;
    wire [FU_SIZE - 1 : 0]      fu_number_out0_from_UIQ;
    wire [ROB_SIZE - 1 : 0]     ROB_no_out0_from_UIQ;
    wire [31 : 0]               PC_info_out0_from_UIQ;

    wire [3 : 0]                op_out1_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rs1_out1_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rs2_out1_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rd_out1_from_UIQ;
    wire [31 : 0]               rs1_value_out1_from_UIQ;
    wire [31 : 0]               rs2_value_out1_from_UIQ;
    wire [31 : 0]               imm_value_out1_from_UIQ;
    wire [FU_SIZE - 1 : 0]      fu_number_out1_from_UIQ;
    wire [ROB_SIZE - 1 : 0]     ROB_no_out1_from_UIQ;
    wire [31 : 0]               PC_info_out1_from_UIQ; 

    wire [3 : 0]                op_out2_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rs1_out2_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rs2_out2_from_UIQ;
    wire [AR_SIZE - 1 : 0]      rd_out2_from_UIQ;
    wire [31 : 0]               rs1_value_out2_from_UIQ;
    wire [31 : 0]               rs2_value_out2_from_UIQ;
    wire [31 : 0]               imm_value_out2_from_UIQ;
    wire [FU_SIZE - 1 : 0]      fu_number_out2_from_UIQ;
    wire [ROB_SIZE - 1 : 0]     ROB_no_out2_from_UIQ;
    wire [31 : 0]               PC_info_out2_from_UIQ;

    wire [2 : 0]                tunnel_from_UIQ;

    // EX stage signals
    wire [31 : 0]   PC_EX;
    wire [6 : 0]    opcode_EX;
    wire [2 : 0]    funct3_EX; 
    wire [6 : 0]    funct7_EX;
    wire [4 : 0]    srcReg1_EX;
    wire [4 : 0]    srcReg2_EX;
    wire [4 : 0]    destReg_EX;
    wire [31 : 0]   imm_EX;
    wire [1 : 0]    lwSw_EX;
    wire            regWrite_EX;
    wire            memRead_EX;
    wire            memWrite_EX;
    wire            memToReg_EX;
    wire            hasImm_EX;

    wire [5 : 0]    p_srcReg1_EX;
    wire [5 : 0]    p_srcReg2_EX;
    wire [5 : 0]    p_destReg_EX;
    wire            stall_Rename_EX;

    
///////////////////////////////////////////////////////////////////////
//  Fetch Stage
    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            PC_reg = 32'b0;
        end
        else begin
            PC_reg = PC_reg + 4;
        end
    end
    assign PC = PC_reg;

    instructionMemory instr_mem (
        .clk            (clk),
        .PC             (PC),
        .rstn           (rstn),
        .instr          (instr_IF),
        .stop           (stop_IF)
    );

///////////////////////////////////////////////////////////////////////
//  Pipeline Registers between Fetch and Decode
    IF_ID_Reg IF_ID_Reg (
        .clk            (clk),
        .rstn           (rstn),
        .inst_IF_in     (instr_IF),
        .stop_in        (stop_IF),
        .PC_in          (PC),
        .inst_ID_out    (instr_ID),
        .stop_out       (stop_ID),
        .PC_out         (PC_ID)
    );
    
///////////////////////////////////////////////////////////////////////
//  Decode Stage
    decode decode_mod(
        .instr          (instr_ID),
        .clk            (clk),
        .rstn           (rstn),
        .opcode         (opcode_ID),
        .funct3         (funct3_ID), 
        .funct7         (funct7_ID), 
        .srcReg1        (srcReg1_ID),
        .srcReg2        (srcReg2_ID),
        .destReg        (destReg_ID),
        .hasImm         (hasImm_ID),
        .imm            (imm_ID), 
        .lwSw           (lwSw_ID),
        .aluOp          (aluOp_ID),
        .regWrite       (regWrite_ID),
        .aluSrc         (aluSrc_ID),
        .branch         (branch_ID),
        .memRead        (memRead_ID),
        .memWrite       (memWrite_ID),
        .memToReg       (memToReg_ID)
    );

///////////////////////////////////////////////////////////////////////
//  Pipeline Registers between Decode and Execution
    wire is_dispatching;

    ID_EX_Reg ID_EX_Reg (
        .clk            (clk),
        .rstn           (rstn),
        .stall          (stall_out_from_UIQ),

        .opcode_in      (opcode_ID),
        .funct3_in      (funct3_ID),
        .funct7_in      (funct7_ID),
        .srcReg1_in     (srcReg1_ID),
        .srcReg2_in     (srcReg2_ID),
        .destReg_in     (destReg_ID),
        .imm_in         (imm_ID),
        .hasImm_in      (hasImm_ID),
        .lwSw_in        (lwSw_ID),
        //.aluOp_in       (aluOp_ID),
        .regWrite_in    (regWrite_ID),
        //.aluSrc_in      (aluSrc_ID),
        //.branch_in      (branch_ID),
        .memRead_in     (memRead_ID),
        .memWrite_in    (memWrite_ID),
        .memToReg_in    (memToReg_ID),
        .PC_in          (PC_ID),

        .opcode_out     (opcode_EX),
        .funct3_out     (funct3_EX),
        .funct7_out     (funct7_EX),
        .srcReg1_out    (srcReg1_EX),
        .srcReg2_out    (srcReg2_EX),
        .destReg_out    (destReg_EX),
        .imm_out        (imm_EX),
        .lwSw_out       (lwSw_EX),
        //.aluOp_out      (aluOp_EX),
        .regWrite_out   (regWrite_EX),
        //.aluSrc_out     (aluSrc_EX),
        //.branch_out     (branch_EX),
        .memRead_out    (memRead_EX),
        .memWrite_out   (memWrite_EX),
        .memToReg_out   (memToReg_EX),
        .hasImm_out     (hasImm_EX),
        .PC_out         (PC_EX),
        .is_dispatching (is_dispatching)
    );

///////////////////////////////////////////////////////////////////////
//  Rename Process
    wire [6 : 0]        old_dr_from_rename;
    rename rename_inst (
        .rstn           (rstn),
        .sr1            (srcReg1_EX),
        .sr2            (srcReg2_EX),
        .dr             (destReg_EX),
        .opcode         (opcode_EX),
        .hasImm         (hasImm_EX),
        .imm            (imm_EX),

        .ROB_num        (),
        .sr1_p          (p_srcReg1_EX),
        .sr2_p          (p_srcReg2_EX),
        .dr_p           (p_destReg_EX),
        .old_dr         (old_dr_from_rename),
        .stall          (stall_Rename_EX)
    );

///////////////////////////////////////////////////////////////////////
// ReOrder Buffer
    wire [63 : 0]   R_ready_from_ROB;
    wire [63 : 0]   R_retire_from_ROB;
    wire            stall_from_ROB;

    ROB ROB_inst (
        .clk            (clk),
        .rstn           (rstn),
        .instr_PC_0     (PC_EX),
        .is_dispatching (is_dispatching),

        .old_dest_reg_0 (old_dr_from_rename),
        .dest_reg_0     (p_destReg_EX),
        .dest_data_0    (),
        .store_add_0    (),
        .store_data_0   (),

        .complete_pc_0  (),
        .complete_pc_1  (),
        .complete_pc_2  (),
        .complete_pc_3  (),
        .new_dr_data_0  (),
        .new_dr_data_1  (),
        .new_dr_data_2  (),
        .new_dr_data_3  (),
        
        .R_readt        (R_ready_from_ROB),
        .R_retire       (R_retire_from_ROB),
        .stall          (stall_from_ROB),
    );

///////////////////////////////////////////////////////////////////////
// Load Store Queue
    LSQ LSQ_inst (
        .clk            (clk),
        .rstn           (rstn),
        .pcDis          (PC_EX),
        .memRead        (lwSw_EX[0]),
        .memWrite       (lwSw_EX[1]),
        .swData         (),
        .pcLsu          (),
        .addressLsu     (),
        .pcRet          (),
        .retire         (),

        .pcOut          (pc_from_lsq),
        .addressOut     (adr_from_lsq),
        .lwData         (lwdata_from_lsq),
        .loadStore      (ls_from_lsq),
        .complete       (complete_from_lsq)
    );

///////////////////////////////////////////////////////////////////////
//  Unified Issue Queue
    reg [64 : 0] ROB_temp;
    integer i;
    always @(negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < 65; i = i + 1) begin
                ROB_temp[i] = 1'b1;
            end
        end
    end

    Unified_Issue_Queue UIQ (
        .clk                    (clk),
        .rstn                   (rstn),
        .opcode_in              (opcode_EX),
        .funct3_in              (funct3_EX),
        .funct7_in              (funct7_EX),
        .rs1_in                 (p_srcReg1_EX),
        .rs1_value_from_ARF_in  ('b0),
        .rs2_in                 (p_srcReg2_EX),
        .rs2_value_from_ARF_in  ('b0),
        .imm_value_in           (imm_EX),
        .rd_in                  (p_destReg_EX),
        .rs1_ready_from_ROB_in  (ROB_temp),
        .rs2_ready_from_ROB_in  (ROB_temp),
        .fu_ready_from_FU_in    (fu_ready_from_FU),
        .FU0_flag_in            (FU_is_using_alu0),
        .reg_tag_from_FU0_in    (dr_out_alu0),
        .reg_value_from_FU0_in  (data_out_dr_alu0),
        .FU1_flag_in            (FU_is_using_alu1),
        .reg_tag_from_FU1_in    (dr_out_alu1),
        .reg_value_from_FU1_in  (data_out_dr_alu1),
        .FU2_flag_in            (FU_is_using_alu2),
        .reg_tag_from_FU2_in    (dr_out_alu2),
        .reg_value_from_FU2_in  (data_out_dr_alu2),

        .op_out0                (op_out0_from_UIQ),
        .rs1_out0               (rs1_out0_from_UIQ),
        .rs2_out0               (rs2_out0_from_UIQ),
        .rd_out0                (rd_out0_from_UIQ),
        .rs1_value_out0         (rs1_value_out0_from_UIQ),
        .rs2_value_out0         (rs2_value_out0_from_UIQ),
        .imm_value_out0         (imm_value_out0_from_UIQ),
        .fu_number_out0         (fu_number_out0_from_UIQ),
        .ROB_no_out0            (ROB_no_out0_from_UIQ),
        .PC_info_out0           (PC_info_out0_from_UIQ),

        .op_out1                (op_out1_from_UIQ),
        .rs1_out1               (rs1_out1_from_UIQ),
        .rs2_out1               (rs2_out1_from_UIQ),
        .rd_out1                (rd_out1_from_UIQ),
        .rs1_value_out1         (rs1_value_out1_from_UIQ),
        .rs2_value_out1         (rs2_value_out1_from_UIQ),
        .imm_value_out1         (imm_value_out1_from_UIQ),
        .fu_number_out1         (fu_number_out1_from_UIQ),
        .ROB_no_out1            (ROB_no_out1_from_UIQ),
        .PC_info_out1           (PC_info_out1_from_UIQ),

        .op_out2                (op_out2_from_UIQ),
        .rs1_out2               (rs1_out2_from_UIQ),
        .rs2_out2               (rs2_out2_from_UIQ),
        .rd_out2                (rd_out2_from_UIQ),
        .rs1_value_out2         (rs1_value_out2_from_UIQ),
        .rs2_value_out2         (rs2_value_out2_from_UIQ),
        .imm_value_out2         (imm_value_out2_from_UIQ),
        .fu_number_out2         (fu_number_out2_from_UIQ),
        .ROB_no_out2            (ROB_no_out2_from_UIQ),
        .PC_info_out2           (PC_info_out2_from_UIQ),

        .no_issue_out           (no_issue_out_from_UIQ),
        .stall_out              (stall_out_from_UIQ),
        .tunnel_out             (tunnel_from_UIQ)
    );

///////////////////////////////////////////////////////////////////////
// ALU * 3

    ALU #(
        .ALU_NO(2'd0)
    ) alu_0 (
        .clk            (clk),
        .rstn           (rstn),
        .alu_number     (tunnel_from_UIQ),
        .optype         (op_out0_from_UIQ),
        .data_in_sr1    (rs1_value_out0_from_UIQ),
        .data_in_sr2    (rs2_value_out0_from_UIQ),
        .data_in_imm    (imm_value_out0_from_UIQ),
        .dr_in          (rd_out0_from_UIQ),

        .data_out_dr    (data_out_dr_alu0),
        .dr_out         (dr_out_alu0),
        .FU_ready       (FU_ready_alu0),
        .FU_is_using    (FU_is_using_alu0)
    );

    ALU #(
        .ALU_NO(2'd1)
    ) alu_1 (
        .clk            (clk),
        .rstn           (rstn),
        .alu_number     (tunnel_from_UIQ),
        .optype         (op_out1_from_UIQ),
        .data_in_sr1    (rs1_value_out1_from_UIQ),
        .data_in_sr2    (rs2_value_out1_from_UIQ),
        .data_in_imm    (imm_value_out1_from_UIQ),
        .dr_in          (rd_out1_from_UIQ),

        .data_out_dr    (data_out_dr_alu1),
        .dr_out         (dr_out_alu1),
        .FU_ready       (FU_ready_alu1),
        .FU_is_using    (FU_is_using_alu1)
    );

    ALU #(
        .ALU_NO(2'd2)
    ) alu_2 (
        .clk            (clk),
        .rstn           (rstn),
        .alu_number     (tunnel_from_UIQ),
        .optype         (op_out2_from_UIQ),
        .data_in_sr1    (rs1_value_out2_from_UIQ),
        .data_in_sr2    (rs2_value_out2_from_UIQ),
        .data_in_imm    (imm_value_out2_from_UIQ),
        .dr_in          (rd_out2_from_UIQ),

        .data_out_dr    (data_out_dr_alu2),
        .dr_out         (dr_out_alu2),
        .FU_ready       (FU_ready_alu2),
        .FU_is_using    (FU_is_using_alu2)
    );

    assign fu_ready_from_FU = {FU_ready_alu2, FU_ready_alu1, FU_ready_alu0};




endmodule