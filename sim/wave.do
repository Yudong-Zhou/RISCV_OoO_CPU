onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 /CPU_tb/cpu/clk
add wave -noupdate -height 30 /CPU_tb/cpu/rstn
add wave -noupdate -height 30 /CPU_tb/cpu/PC
add wave -noupdate -height 30 /CPU_tb/cpu/PC_reg
add wave -noupdate -height 30 /CPU_tb/cpu/instr_IF
add wave -noupdate -height 30 /CPU_tb/cpu/stop_IF
add wave -noupdate -height 30 /CPU_tb/cpu/instr_ID
add wave -noupdate -height 30 /CPU_tb/cpu/stop_ID
add wave -noupdate -height 30 /CPU_tb/cpu/opcode_ID
add wave -noupdate -height 30 /CPU_tb/cpu/funct3_ID
add wave -noupdate -height 30 /CPU_tb/cpu/funct7_ID
add wave -noupdate -color Yellow -height 30 /CPU_tb/cpu/srcReg1_ID
add wave -noupdate -color Yellow -height 30 /CPU_tb/cpu/srcReg2_ID
add wave -noupdate -color Yellow -height 30 /CPU_tb/cpu/destReg_ID
add wave -noupdate -height 30 /CPU_tb/cpu/imm_ID
add wave -noupdate -height 30 /CPU_tb/cpu/lwSw_ID
add wave -noupdate -height 30 /CPU_tb/cpu/srcReg1_EX
add wave -noupdate -height 30 /CPU_tb/cpu/srcReg2_EX
add wave -noupdate -height 30 /CPU_tb/cpu/destReg_EX
add wave -noupdate -height 30 /CPU_tb/cpu/imm_EX
add wave -noupdate -height 30 /CPU_tb/cpu/lwSw_EX
add wave -noupdate -color Yellow -height 30 /CPU_tb/cpu/p_srcReg1_EX
add wave -noupdate -color Yellow -height 30 /CPU_tb/cpu/p_srcReg2_EX
add wave -noupdate -color Yellow -height 30 /CPU_tb/cpu/p_destReg_EX
add wave -noupdate -height 30 /CPU_tb/cpu/stall_Rename_EX
add wave -noupdate -height 30 /CPU_tb/cpu/rename_inst/RAT
add wave -noupdate -height 30 /CPU_tb/cpu/rename_inst/free_pool
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/valid
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/operation
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/dest_reg
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/src_reg1
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/src1_ready
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/src1_data
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/src_reg2
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/src2_ready
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/src2_data
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/imm
add wave -noupdate -height 30 /CPU_tb/cpu/UIQ/fu_number
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2962 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 351
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {56497 ps}
