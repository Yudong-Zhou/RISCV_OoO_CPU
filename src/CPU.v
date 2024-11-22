module CPU(
    input   clk
);

    reg [31:0] PC;

    reg [31:0] instr;
    reg stop;

    reg [6:0] opcode;
    reg [2:0] funct3; 
    reg [6:0] funct7;
    reg [4:0] srcReg1;
    reg [4:0] srcReg2;
    reg [4:0] destReg;
    reg [31:0] imm; 
    reg [1:0] lwSw;
    reg [1:0] aluOp; 
    reg regWrite;
    reg aluSrc;
    reg branch;
    reg memRead;
    reg memWrite;
    reg memToReg;

    instructionMemory instrMem_mod (
        .clk(clk),
        .PC(PC),

        .instr(instr),
        .stop(stop)
    );

    IF_ID_Reg IF_ID_mod (
        .clk(clk),
        .rstn(1'b1),
        .inst_IF_in(instr),
        .stop_in(stop),

        .inst_ID_out(instr),
        .stop_out(stop)
    );

    decode decode_mod(
        .instr(instr),
        .clk(clk),

        .opcode(opcode),
        .funct3(funct3), 
        .funct7(funct7), 
        .srcReg1(srcReg1),
        .srcReg2(srcReg2),
        .destReg(destReg),
        .imm(imm), 
        .lwSw(lwSw),
        .aluOp(aluOp),
        .regWrite(regWrite),
        .aluSrc(aluSrc),
        .branch(branch),
        .memRead(memRead),
        .memWrite(memWrite),
        .memToReg(memToReg)
    );

    ID_EX_Reg ID_EX_mod (
        .clk(clk),
        .rstn(1'b1),
        .opcode_in(opcode),
        .funct3_in(funct3),
        .funct7_in(funct7),
        .srcReg1_in(srcReg1),
        .srcReg2_in(srcReg2),
        .destReg_in(destReg),
        .imm_in(imm),
        .lwSw_in(lwSw),
        //.aluOp_in(aluOp),
        .regWrite_in(regWrite),
        //.aluSrc_in(aluSrc),
        //.branch_in(branch),
        .memRead_in(memRead),
        .memWrite_in(memWrite),
        .memToReg_in(memToReg),

        .opcode_out(opcode),
        .funct3_out(funct3),
        .funct7_out(funct7),
        .srcReg1_out(srcReg1),
        .srcReg2_out(srcReg2),
        .destReg_out(destReg),
        .imm_out(imm),
        .lwSw_out(lwSw),
        //.aluOp_out(aluOp),
        .regWrite_out(regWrite),
        //.aluSrc_out(aluSrc),
        //.branch_out(branch),
        .memRead_out(memRead),
        .memWrite_out(memWrite),
        .memToReg_out(memToReg)
    );

    rename rename_mod (
        .sr1(sr1),
        .sr2(sr2),
        .dr(dr),
        .aluOp(aluOp),
        .imm(imm),
        .sr1_p(sr1_p),
        .sr2_p(sr2_p),
        .dr_p(dr_p),
        .aluOp_out(aluOp_out),
        .s1_ready(s1_ready),
        .s2_ready(s2_ready),
        .imm_out(imm_out),
        .FU(FU),
        .ROB_num(ROB_num)
    );

    initial begin
        PC = 32'b0;
    end

endmodule