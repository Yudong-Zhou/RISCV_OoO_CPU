onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_tb/cpu/LSQ_inst/clk
add wave -noupdate /CPU_tb/cpu/LSQ_inst/VALID
add wave -noupdate /CPU_tb/cpu/LSQ_inst/PC
add wave -noupdate /CPU_tb/cpu/LSQ_inst/OP
add wave -noupdate /CPU_tb/cpu/LSQ_inst/ADDRESS
add wave -noupdate /CPU_tb/cpu/LSQ_inst/REG
add wave -noupdate /CPU_tb/cpu/LSQ_inst/LSQ_DATA
add wave -noupdate /CPU_tb/cpu/LSQ_inst/FOUND
add wave -noupdate /CPU_tb/cpu/LSQ_inst/ISSUED
add wave -noupdate /CPU_tb/cpu/LSQ_inst/pcRet1
add wave -noupdate /CPU_tb/cpu/LSQ_inst/pcRet2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {255234 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 453
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
WaveRestoreZoom {305593 ps} {404969 ps}
