onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_tb/cpu/Rename_inst/clk
add wave -noupdate /CPU_tb/cpu/Rename_inst/rstn
add wave -noupdate /CPU_tb/cpu/Rename_inst/sr1
add wave -noupdate /CPU_tb/cpu/Rename_inst/sr2
add wave -noupdate /CPU_tb/cpu/Rename_inst/dr
add wave -noupdate /CPU_tb/cpu/Rename_inst/opcode
add wave -noupdate /CPU_tb/cpu/Rename_inst/hasImm
add wave -noupdate /CPU_tb/cpu/Rename_inst/imm
add wave -noupdate /CPU_tb/cpu/Rename_inst/retire_from_ROB
add wave -noupdate /CPU_tb/cpu/Rename_inst/is_dispatching
add wave -noupdate /CPU_tb/cpu/Rename_inst/ROB_num
add wave -noupdate /CPU_tb/cpu/Rename_inst/sr1_p
add wave -noupdate /CPU_tb/cpu/Rename_inst/sr2_p
add wave -noupdate /CPU_tb/cpu/Rename_inst/dr_p
add wave -noupdate /CPU_tb/cpu/Rename_inst/old_dr
add wave -noupdate /CPU_tb/cpu/Rename_inst/stall
add wave -noupdate /CPU_tb/cpu/Rename_inst/free_pool
add wave -noupdate /CPU_tb/cpu/Rename_inst/RAT
add wave -noupdate /CPU_tb/cpu/Rename_inst/i
add wave -noupdate /CPU_tb/cpu/Rename_inst/j
add wave -noupdate /CPU_tb/cpu/Rename_inst/old_index
add wave -noupdate /CPU_tb/cpu/Rename_inst/retire_var
add wave -noupdate /CPU_tb/cpu/Rename_inst/free_var
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88145 ps} 0}
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
WaveRestoreZoom {41910 ps} {145793 ps}
