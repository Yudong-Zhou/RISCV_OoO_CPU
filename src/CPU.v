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
    //  Fetch Stage
    reg             pc_cnt;
    reg [31 : 0]    PC_IF;

    // IF stage signals
    wire [31 : 0]   PC;
    reg  [31 : 0]   PC_reg;
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
    wire            is_dispatching;

    // Rename
    wire [5 : 0]    old_dr_from_rename;

    // ROB
    wire [63 : 0]   R_ready_from_ROB;
    wire [63 : 0]   R_retire_from_ROB;
    wire            stall_from_ROB;
    wire [5 : 0]    reg_update_ARF_1;
    wire [5 : 0]    reg_update_ARF_2;
    wire [31 : 0]   value_update_ARF_1;
    wire [31 : 0]   value_update_ARF_2;
    wire            bc_from_ROB_1;    
    wire [5 : 0]    reg_bc_from_ROB_1;
    wire [5 : 0]    reg_bc_from_ROB_2;
    wire            bc__from_ROB2;
    wire [31 : 0]   value_bc_from_ROB_1;
    wire [31 : 0]   value_bc_from_ROB_2;
    reg             is_store_reg;
    wire            is_store;
    wire [5 : 0]    old_reg_1;
    wire [5 : 0]    old_reg_2;
    wire [31 : 0]   pc_retire_1_from_ROB;
    wire [31 : 0]   pc_retire_2_from_ROB;

    // ARF
    wire [31 : 0]   read_data1_ARF;
    wire [31 : 0]   read_data2_ARF;

    // LSQ
    wire [31 : 0]   pc_from_lsq;
    wire [31 : 0]   adr_from_lsq;
    wire [31 : 0]   data_from_lsq;
    wire            ls_from_lsq;
    wire            FU_write_flag;
    wire            FU_read_flag;
    wire            already_found_from_LSQ;
    wire            no_issue_from_LSQ;
    wire [5 : 0]      regout_from_lsq;

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
    wire [31 : 0]               swData_UIQ_LSQ;
    wire                        stall_out_from_UIQ;

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

    // EX_MEM pipeline register signals
    wire [31 : 0]   rd_result_fu0_MEM;
    wire [31 : 0]   pc_fu0_MEM;
    wire [31 : 0]   rd_result_fu1_MEM;
    wire [31 : 0]   pc_fu1_MEM;
    wire [31 : 0]   rd_result_fu2_MEM;
    wire [31 : 0]   pc_fu2_MEM;
    wire            op_write_MEM;
    wire            op_read_MEM;
    wire [3 : 0]    mem_op;
    wire [2 : 0]    tunnel_MEM;

    // MEM stage signals
    wire [31 : 0]   mem_addr_from_LSU;
    wire [31 : 0]   store_data_to_mem_from_LSU;
    wire [31 : 0]   load_data_to_comp_from_LSU;
    wire [31 : 0]   inst_pc_from_LSU;
    wire            write_en_from_LSU;
    wire            read_en_from_LSU;
    wire [3 : 0]    op_from_LSU;
    wire            load_data_from_lsq;
    wire [31 : 0]   inst_pc_from_mem;
    wire [31 : 0]   lwData_from_mem;
    wire            data_vaild_from_mem;

    // pipeline register between MEM and COMPLETE stage
    wire [31 : 0]   lwData_comp;
    wire [31 : 0]   pc_ls_comp;
    wire            vaild_comp;
    wire            lsq_comp;
    wire            FU_write_flag_com;
    wire            FU_read_flag_com;

    // COMPLETE stage signals
    wire [31 : 0]   rd_result_comp_0;
    wire [31 : 0]   pc_comp_0;
    wire [31 : 0]   rd_result_comp_1;
    wire [31 : 0]   pc_comp_1;
    wire [31 : 0]   rd_result_comp_2;
    wire [31 : 0]   pc_comp_2;
    wire [31 : 0]   rd_result_comp_3;
    wire [31 : 0]   pc_comp_3;
    reg  [31 : 0]   rd_result_comp_0_reg;
    reg  [31 : 0]   pc_comp_0_reg;
    reg  [31 : 0]   rd_result_comp_1_reg;
    reg  [31 : 0]   pc_comp_1_reg;
    reg  [31 : 0]   rd_result_comp_2_reg;
    reg  [31 : 0]   pc_comp_2_reg;
    reg  [31 : 0]   rd_result_comp_3_reg;
    reg  [31 : 0]   pc_comp_3_reg;

    wire [5:0]      set_rob_reg_invaild;
    wire [5:0]      regout_from_lsu;
    wire [5:0]      regout_from_lsu2;
    wire [5:0]      regout_from_dm;

    wire            has_stored;   
    wire [31 : 0]   data_check;
    wire            FU_read_flag_MEM_com;

    // Cache
    wire            cache_miss;
    wire [31:0]     adr_from_cache_to_mem;
    wire [3:0]      op_from_cache_to_mem;
    wire [31:0]     store_data_from_cache_to_mem;

    wire [31:0]     inst_pc_from_cache;
    wire [5:0]      regout_from_cache;
    wire [31:0]     lwData_from_cache;
    wire            data_vaild_from_cache;
    wire            has_stored1;
    wire [31:0]     data_check1;

///////////////////////////////////////////////////////////////////////
//  Fetch Stage
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            PC_reg = 32'b0;
            pc_cnt = 0;
        end
        else if (stall_out_from_UIQ || stall_Rename_EX || stall_from_ROB) begin
            PC_reg = PC_reg;
        end
        else if (pc_cnt) begin
            PC_reg = PC_reg + 4;
        end
        else begin
            PC_reg = PC_reg;
            pc_cnt = 1;
        end
    end
    assign PC = PC_reg;

    always @(posedge clk) begin
        PC_IF <= PC;
    end

    instructionMemory instr_mem (
        .clk            (clk),
        .rstn           (rstn),
        .PC             (PC),
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
        .PC_in          (PC_IF),
        .inst_ID_out    (instr_ID),
        .stop_out       (stop_ID),
        .PC_out         (PC_ID)
    );
    
///////////////////////////////////////////////////////////////////////
//  Decode Stage
    Decode Decode_mod(
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
    ID_EX_Reg ID_EX_Reg (
        .clk            (clk),
        .rstn           (rstn),
        .stall          (stall_out_from_UIQ || stall_Rename_EX || stall_from_ROB || stop_ID),

        .opcode_in      (opcode_ID),
        .funct3_in      (funct3_ID),
        .funct7_in      (funct7_ID),
        .srcReg1_in     (srcReg1_ID),
        .srcReg2_in     (srcReg2_ID),
        .destReg_in     (destReg_ID),
        .imm_in         (imm_ID),
        .hasImm_in      (hasImm_ID),
        .lwSw_in        (lwSw_ID),
        .regWrite_in    (regWrite_ID),
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
        .regWrite_out   (regWrite_EX),
        .memRead_out    (memRead_EX),
        .memWrite_out   (memWrite_EX),
        .memToReg_out   (memToReg_EX),
        .hasImm_out     (hasImm_EX),
        .PC_out         (PC_EX),
        .is_dispatching (is_dispatching)
    );

///////////////////////////////////////////////////////////////////////
// Rename Process
    Rename Rename_inst (
        .clk            (clk),
        .rstn           (rstn),
        .sr1            (srcReg1_EX),
        .sr2            (srcReg2_EX),
        .dr             (destReg_EX),
        .opcode         (opcode_EX),
        .hasImm         (hasImm_EX),
        .imm            (imm_EX),
        .retire_from_ROB(R_retire_from_ROB),
        .is_dispatching (is_dispatching),

        .ROB_num        (),
        .sr1_p          (p_srcReg1_EX),
        .sr2_p          (p_srcReg2_EX),
        .dr_p           (p_destReg_EX),
        .old_dr         (old_dr_from_rename),
        .stall          (stall_Rename_EX)
    );

///////////////////////////////////////////////////////////////////////
// ReOrder Buffer
    ROB ROB_inst (
        .clk                (clk),
        .rstn               (rstn),
        .instr_PC_0         (PC_EX),
        .is_dispatching     (is_dispatching),

        .old_dest_reg_0     (old_dr_from_rename),
        .dest_reg_0         (p_destReg_EX),
        .dest_data_0        (),
        .store_add_0        (),
        .store_data_0       (),

        .complete_pc_0      (pc_comp_0),
        .complete_pc_1      (pc_comp_1),
        .complete_pc_2      (pc_comp_2),
        .complete_pc_3      (pc_comp_3),
        .new_dr_data_0      (rd_result_comp_0),
        .new_dr_data_1      (rd_result_comp_1),
        .new_dr_data_2      (rd_result_comp_2),
        .new_dr_data_3      (rd_result_comp_3),
        .is_store           (is_store),
        .set_invaild_from_UIQ(set_rob_reg_invaild),
        
        .R_ready            (R_ready_from_ROB),
        .R_retire           (R_retire_from_ROB),
        .stall              (stall_from_ROB),
        .reg_update_ARF_1   (reg_update_ARF_1),
        .reg_update_ARF_2   (reg_update_ARF_2),
        .value_update_ARF_1 (value_update_ARF_1),
        .value_update_ARF_2 (value_update_ARF_2),
        .old_reg_1          (old_reg_1),
        .old_reg_2          (old_reg_2),

        .bc_1               (bc_from_ROB_1),
        .reg_bc_1           (reg_bc_from_ROB_1),
        .value_bc_1         (value_bc_from_ROB_1),
        .bc_2               (bc_from_ROB_2),
        .reg_bc_2           (reg_bc_from_ROB_2),
        .value_bc_2         (value_bc_from_ROB_2),

        .pc_retire_1        (pc_retire_1_from_ROB),
        .pc_retire_2        (pc_retire_2_from_ROB)
    );

///////////////////////////////////////////////////////////////////////
// ARF
    ARF ARF_inst (
        .clk            (clk),
        .rstn           (rstn),
        .read_addr1     (p_srcReg1_EX),
        .read_addr2     (p_srcReg2_EX),
        .read_en        (1'b1),
        .write_addr1    (reg_update_ARF_1),
        .write_data1    (value_update_ARF_1),
        .old_addr1      (old_reg_1),
        .old_addr2      (old_reg_2),
        .write_addr2    (reg_update_ARF_2),
        .write_data2    (value_update_ARF_2),
        .write_en       (1'b1),

        .read_data1     (read_data1_ARF),
        .read_data2     (read_data2_ARF)
    );

///////////////////////////////////////////////////////////////////////
// Load Store Queue
    LSQ LSQ_inst (
        .clk            (clk),
        .rstn           (rstn),
        .reg_dis        (p_destReg_EX),
        .pcDis          (PC_EX),
        .memRead        (memRead_EX),
        .memWrite       (memWrite_EX),
        .pc_issue       (PC_info_out2_from_UIQ),
        .swData         (swData_UIQ_LSQ),
        .pcLsu          (inst_pc_from_LSU),
        .addressLsu     (mem_addr_from_LSU),
        .data_check     (data_check),
        .has_stored     (has_stored),
        .pcRet1         (pc_retire_1_from_ROB),
        .pcRet2         (pc_retire_1_from_ROB),
        
        .pcOut          (pc_from_lsq),
        .regout         (regout_from_lsq),
        .addressOut     (adr_from_lsq),
        .Data_out       (data_from_lsq),
        .loadStore      (ls_from_lsq),
        .already_found  (already_found_from_LSQ),
        .no_issue       (no_issue_from_LSQ)
    );

///////////////////////////////////////////////////////////////////////
// Unified Issue Queue
    Unified_Issue_Queue UIQ (
        .clk                    (clk),
        .rstn                   (rstn),
        .PC                     (PC_EX),
        .is_dispatching         (is_dispatching),
        .opcode_in              (opcode_EX),
        .funct3_in              (funct3_EX),
        .funct7_in              (funct7_EX),
        .rs1_in                 (p_srcReg1_EX),
        .rs1_value_from_ARF_in  (read_data1_ARF),
        .rs2_in                 (p_srcReg2_EX),
        .rs2_value_from_ARF_in  (read_data2_ARF),
        .imm_value_in           (imm_EX),
        .rd_in                  (p_destReg_EX),
        .rs1_ready_from_ROB_in  (R_ready_from_ROB),
        .rs2_ready_from_ROB_in  (R_ready_from_ROB),
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

        .ROB_bc1                (bc_from_ROB_1),
        .reg_from_ROB_in1       (reg_bc_from_ROB_1),
        .value_from_ROB_in1     (value_bc_from_ROB_1),
        .ROB_bc2                (bc_from_ROB_2),
        .reg_from_ROB_in2       (reg_bc_from_ROB_2),
        .value_from_ROB_in2     (value_bc_from_ROB_2),

        .lwData_from_LSU_in     (load_data_to_comp_from_LSU),
        .reg_from_LSU_in        (regout_from_lsu),
        .lwdata_from_mem_in     (lwData_from_mem),
        .reg_from_mem_in        (regout_from_dm),

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
        .swdata_to_LSQ_out2     (swData_UIQ_LSQ),

        .no_issue_out           (no_issue_out_from_UIQ),
        .stall_out              (stall_out_from_UIQ),
        .tunnel_out             (tunnel_from_UIQ),
        .set_rob_reg_invaild    (set_rob_reg_invaild)
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

///////////////////////////////////////////////////////////////////////
// pipeline register between ex and mem stage
    assign FU_write_flag = ((tunnel_from_UIQ[2]) && 
                            ((op_out2_from_UIQ == 4'd9) || (op_out2_from_UIQ == 4'd10)));
    assign FU_read_flag =  ((tunnel_from_UIQ[2]) && 
                            ((op_out2_from_UIQ == 4'd7) || (op_out2_from_UIQ == 4'd8)));

    EX_MEM_Reg EX_MEM_Reg_inst(
        .clk                (clk),
        .rstn               (rstn),
        .tunnel_in          (tunnel_from_UIQ),
        .rd_result_fu0_in   (data_out_dr_alu0),
        .pc_fu0_in          (PC_info_out0_from_UIQ),
        .rd_result_fu1_in   (data_out_dr_alu1),
        .pc_fu1_in          (PC_info_out1_from_UIQ),
        .rd_result_fu2_in   (data_out_dr_alu2),
        .pc_fu2_in          (PC_info_out2_from_UIQ),
        .op_write_in        (FU_write_flag),
        .op_read_in         (FU_read_flag),
        .op_in              (op_out2_from_UIQ),

        .tunnel_out         (tunnel_MEM),
        .rd_result_fu0_out  (rd_result_fu0_MEM),
        .pc_fu0_out         (pc_fu0_MEM),
        .rd_result_fu1_out  (rd_result_fu1_MEM),
        .pc_fu1_out         (pc_fu1_MEM),
        .rd_result_fu2_out  (rd_result_fu2_MEM),
        .pc_fu2_out         (pc_fu2_MEM),
        .op_write_out       (op_write_MEM),
        .op_read_out        (op_read_MEM),
        .op_out             (mem_op)
    );

///////////////////////////////////////////////////////////////////////
// MEM stage
    LSU LSU_inst (
        .mem_addr_in                (rd_result_fu2_MEM),
        .reg_in                     (regout_from_lsq),
        .inst_pc_in                 (pc_fu2_MEM),
        .op_in                      (mem_op),
        .lwData_from_LSQ_in         (data_from_lsq),
        .store_data_from_LSQ_in     (data_from_lsq), 
        .loadstore_from_LSQ_in      (ls_from_lsq), 
        .already_found_from_LSQ_in  (already_found_from_LSQ),
        .no_issue_from_LSQ_in       (no_issue_from_LSQ),         

        .mem_addr_out               (mem_addr_from_LSU),
        .reg_out1                   (regout_from_lsu),
        .reg_out2                   (regout_from_lsu2),
        .store_data_to_mem_out      (store_data_to_mem_from_LSU),
        .load_data_to_comp_out      (load_data_to_comp_from_LSU),
        .inst_pc_out                (inst_pc_from_LSU),
        .write_en_out               (write_en_from_LSU),
        .read_en_out                (read_en_from_LSU),
        .op_out                     (op_from_LSU),
        .from_lsq                   (load_data_from_lsq)
    );

    Cache Cache (
        .clk            (clk),
        .rstn           (rstn),
        .inst_pc        (inst_pc_from_LSU),
        .address_in     (mem_addr_from_LSU),
        .reg_in         (regout_from_lsu2),
        .optype         (op_from_LSU),
        .dataSw         (store_data_to_mem_from_LSU),
        .read_en        (1'b1),
        .write_en       (1'b1),

        .inst_pc_out    (inst_pc_from_cache),
        .reg_out        (regout_from_cache),
        .lwData_out     (lwData_from_cache),
        .data_vaild_out (data_vaild_from_cache),
        .has_stored     (has_stored1),
        .data_check     (data_check1),
        .cache_miss     (cache_miss),
        .optype_out     (op_from_cache_to_mem),
        .address_out    (adr_from_cache_to_mem),
        .datasw_out     (store_data_from_cache_to_mem)
    );

    DataMemory DataMem (
        .clk            (clk),
        .rstn           (rstn),
        .inst_pc_in     (inst_pc_from_LSU),
        .address_in     (mem_addr_from_LSU),
        .reg_in         (regout_from_lsu2),
        .optype_in      (op_from_LSU),
        .dataSw_in      (store_data_to_mem_from_LSU),
        .read_en        (1'b1),
        .write_en_in    (1'b1),
        .cacheMiss      (cache_miss),

        .inst_pc_out    (inst_pc_from_mem),
        .reg_out        (regout_from_dm),
        .lwData_out     (lwData_from_mem),
        .data_vaild_out (data_vaild_from_mem),
        .has_stored     (has_stored),
        .data_check     (data_check)
    );

///////////////////////////////////////////////////////////////////////
// pipeline register between MEM and COMPLETE stage
    MEM_Comp_Reg MEM_Comp_Reg_inst (
        .clk                (clk),
        .rstn               (rstn),
        .from_lsq           (load_data_from_lsq),
        .mem_vaild          (data_vaild_from_mem),
        .lwData_from_LSQ_in (load_data_to_comp_from_LSU),
        .lwData_from_MEM_in (lwData_from_mem),
        .pc_from_LSU_in     (inst_pc_from_LSU),
        .pc_from_MEM_in     (inst_pc_from_mem),
        .FU_write_flag      (FU_write_flag),
        .FU_read_flag       (FU_read_flag),
        .FU_read_flag_MEM   (op_read_MEM),

        .lwData_out         (lwData_comp),
        .pc_out             (pc_ls_comp),
        .vaild_out          (vaild_comp),
        .lsq_out            (lsq_comp),
        .FU_write_flag_com  (FU_write_flag_com),
        .FU_read_flag_com   (FU_read_flag_com),
        .FU_read_flag_MEM_com(FU_read_flag_MEM_com)
    );

///////////////////////////////////////////////////////////////////////
// COMPLETE logic
    always @(*) begin
        is_store_reg = 1'b0;
        if(tunnel_MEM[0]) begin
            rd_result_comp_0_reg    = rd_result_fu0_MEM;
            pc_comp_0_reg           = pc_fu0_MEM;
        end
        else begin
            rd_result_comp_0_reg    = 32'd1;
            pc_comp_0_reg           = 32'd1;
        end

        if(tunnel_MEM[1]) begin
            rd_result_comp_1_reg    = rd_result_fu1_MEM;
            pc_comp_1_reg           = pc_fu1_MEM;
        end
        else begin
            rd_result_comp_1_reg    = 32'd1;
            pc_comp_1_reg           = 32'd1;
        end
        
        if (~FU_read_flag_com) begin
            if(tunnel_MEM[2]) begin
                pc_comp_2_reg           = pc_fu2_MEM;
                if (FU_write_flag_com && ~FU_read_flag_MEM_com) begin
                    is_store_reg = 1'b1;
                end
                else begin
                    rd_result_comp_2_reg = rd_result_fu2_MEM;
                end
            end
            else begin
                rd_result_comp_2_reg    = 32'd1;
                pc_comp_2_reg           = 32'd1;
            end
        end

        if(vaild_comp || lsq_comp) begin
            rd_result_comp_3_reg    = lwData_comp;
            pc_comp_3_reg           = pc_ls_comp;
        end
        else begin
            rd_result_comp_3_reg    = 32'd1;
            pc_comp_3_reg           = 32'd1;
        end
    end

    assign rd_result_comp_0 = rd_result_comp_0_reg;
    assign pc_comp_0        = pc_comp_0_reg;
    assign rd_result_comp_1 = rd_result_comp_1_reg;
    assign pc_comp_1        = pc_comp_1_reg;
    assign rd_result_comp_2 = rd_result_comp_2_reg;
    assign pc_comp_2        = pc_comp_2_reg;
    assign rd_result_comp_3 = rd_result_comp_3_reg;
    assign pc_comp_3        = pc_comp_3_reg; 
    assign is_store         = is_store_reg;   

endmodule