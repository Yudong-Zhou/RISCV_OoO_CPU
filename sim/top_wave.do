onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_tb/clk
add wave -noupdate /CPU_tb/rstn
add wave -noupdate /CPU_tb/cpu/PC
add wave -noupdate /CPU_tb/cpu/instr_IF
add wave -noupdate /CPU_tb/cpu/stop_IF
add wave -noupdate -color Yellow /CPU_tb/cpu/srcReg1_ID
add wave -noupdate -color Yellow /CPU_tb/cpu/srcReg2_ID
add wave -noupdate -color Yellow /CPU_tb/cpu/destReg_ID
add wave -noupdate -color Yellow /CPU_tb/cpu/imm_ID
add wave -noupdate -color Salmon /CPU_tb/cpu/is_dispatching
add wave -noupdate -color Salmon /CPU_tb/cpu/Rename_inst/dr
add wave -noupdate -color Salmon /CPU_tb/cpu/Rename_inst/dr_p
add wave -noupdate -color Salmon /CPU_tb/cpu/Rename_inst/RAT
add wave -noupdate -color Salmon /CPU_tb/cpu/Rename_inst/free_pool
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/p_srcReg1_EX
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/p_srcReg2_EX
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/p_destReg_EX
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/imm_EX
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/set_rob_reg_invaild
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/ROB_inst/ROB
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/R_ready_from_ROB
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/R_retire_from_ROB
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/op_out0_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs1_out0_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs2_out0_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rd_out0_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs1_value_out0_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs2_value_out0_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/imm_value_out0_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/op_out1_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs1_out1_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs2_out1_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rd_out1_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs1_value_out1_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs2_value_out1_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/imm_value_out1_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/op_out2_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs1_out2_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs2_out2_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rd_out2_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs1_value_out2_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/rs2_value_out2_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/imm_value_out2_from_UIQ
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/UIQ/fu_taken
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/UIQ/fu_ready_from_FU_in
add wave -noupdate -color {Medium Orchid} /CPU_tb/cpu/tunnel_from_UIQ
add wave -noupdate -color {Indian Red} /CPU_tb/cpu/data_out_dr_alu0
add wave -noupdate -color {Indian Red} /CPU_tb/cpu/dr_out_alu0
add wave -noupdate -color {Indian Red} /CPU_tb/cpu/data_out_dr_alu1
add wave -noupdate -color {Indian Red} /CPU_tb/cpu/dr_out_alu1
add wave -noupdate -color {Indian Red} /CPU_tb/cpu/data_out_dr_alu2
add wave -noupdate -color {Indian Red} /CPU_tb/cpu/dr_out_alu2
add wave -noupdate /CPU_tb/cpu/rd_result_comp_0
add wave -noupdate /CPU_tb/cpu/pc_comp_0
add wave -noupdate /CPU_tb/cpu/rd_result_comp_1
add wave -noupdate /CPU_tb/cpu/pc_comp_1
add wave -noupdate /CPU_tb/cpu/rd_result_comp_2
add wave -noupdate /CPU_tb/cpu/pc_comp_2
add wave -noupdate /CPU_tb/cpu/vaild_comp
add wave -noupdate /CPU_tb/cpu/lsq_comp
add wave -noupdate /CPU_tb/cpu/rd_result_comp_3
add wave -noupdate /CPU_tb/cpu/pc_comp_3
add wave -noupdate -color Yellow /CPU_tb/cpu/DataMem/optype_in
add wave -noupdate -color Yellow /CPU_tb/cpu/DataMem/address_in
add wave -noupdate -color Yellow /CPU_tb/cpu/DataMem/dataSw_in
add wave -noupdate -color Yellow /CPU_tb/cpu/DataMem/lwData_out
add wave -noupdate -color Yellow /CPU_tb/cpu/DataMem/DATAMEM
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/ARF_inst/write_addr1
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/ARF_inst/write_data1
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/ARF_inst/write_addr2
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/ARF_inst/write_data2
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/ARF_inst/ar_file
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 391
configure wave -valuecolwidth 195
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
WaveRestoreZoom {0 ps} {103883 ps}
