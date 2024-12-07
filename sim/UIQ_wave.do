onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_tb/cpu/UIQ/clk
add wave -noupdate /CPU_tb/cpu/UIQ/rstn
add wave -noupdate /CPU_tb/cpu/UIQ/PC
add wave -noupdate /CPU_tb/cpu/UIQ/fu_ready_from_FU_in
add wave -noupdate -color Yellow /CPU_tb/cpu/UIQ/FU0_flag_in
add wave -noupdate -color Yellow /CPU_tb/cpu/UIQ/reg_tag_from_FU0_in
add wave -noupdate -color Yellow /CPU_tb/cpu/UIQ/reg_value_from_FU0_in
add wave -noupdate -color Pink /CPU_tb/cpu/UIQ/FU1_flag_in
add wave -noupdate -color Pink /CPU_tb/cpu/UIQ/reg_tag_from_FU1_in
add wave -noupdate -color Pink /CPU_tb/cpu/UIQ/reg_value_from_FU1_in
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/UIQ/FU2_flag_in
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/UIQ/reg_tag_from_FU2_in
add wave -noupdate -color {Sky Blue} /CPU_tb/cpu/UIQ/reg_value_from_FU2_in
add wave -noupdate -color Yellow /CPU_tb/cpu/UIQ/ROB_bc1
add wave -noupdate -color Yellow /CPU_tb/cpu/UIQ/reg_from_ROB_in1
add wave -noupdate -color Yellow /CPU_tb/cpu/UIQ/value_from_ROB_in1
add wave -noupdate -color Pink /CPU_tb/cpu/UIQ/ROB_bc2
add wave -noupdate -color Pink /CPU_tb/cpu/UIQ/reg_from_ROB_in2
add wave -noupdate -color Pink /CPU_tb/cpu/UIQ/value_from_ROB_in2
add wave -noupdate /CPU_tb/cpu/UIQ/lwData_from_LSU_in
add wave -noupdate /CPU_tb/cpu/UIQ/reg_from_LSU_in
add wave -noupdate /CPU_tb/cpu/UIQ/set_rob_reg_invaild
add wave -noupdate /CPU_tb/cpu/UIQ/rs1_in
add wave -noupdate /CPU_tb/cpu/UIQ/rs2_in
add wave -noupdate /CPU_tb/cpu/UIQ/rs1_ready_from_ROB_in
add wave -noupdate /CPU_tb/cpu/UIQ/rs2_ready_from_ROB_in
add wave -noupdate /CPU_tb/cpu/UIQ/src_reg1
add wave -noupdate /CPU_tb/cpu/UIQ/src1_ready
add wave -noupdate /CPU_tb/cpu/UIQ/valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {128005 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 401
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
WaveRestoreZoom {83129 ps} {189625 ps}
