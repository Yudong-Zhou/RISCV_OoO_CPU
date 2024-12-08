onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_tb/cpu/DataMem/clk
add wave -noupdate /CPU_tb/cpu/DataMem/address_in
add wave -noupdate /CPU_tb/cpu/DataMem/optype_in
add wave -noupdate /CPU_tb/cpu/DataMem/dataSw_in
add wave -noupdate /CPU_tb/cpu/DataMem/lwData_out
add wave -noupdate /CPU_tb/cpu/DataMem/DATAMEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76648 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 337
configure wave -valuecolwidth 145
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
WaveRestoreZoom {72660 ps} {183829 ps}
