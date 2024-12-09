onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_tb/cpu/Cache/clk
add wave -noupdate /CPU_tb/cpu/Cache/rstn
add wave -noupdate /CPU_tb/cpu/Cache/inst_pc
add wave -noupdate /CPU_tb/cpu/Cache/address_in
add wave -noupdate /CPU_tb/cpu/Cache/reg_in
add wave -noupdate /CPU_tb/cpu/Cache/optype
add wave -noupdate /CPU_tb/cpu/Cache/dataSw
add wave -noupdate /CPU_tb/cpu/Cache/read_en
add wave -noupdate /CPU_tb/cpu/Cache/write_en
add wave -noupdate /CPU_tb/cpu/Cache/inst_pc_out
add wave -noupdate /CPU_tb/cpu/Cache/address_out
add wave -noupdate /CPU_tb/cpu/Cache/reg_out
add wave -noupdate /CPU_tb/cpu/Cache/datasw_out
add wave -noupdate /CPU_tb/cpu/Cache/lwData_out
add wave -noupdate /CPU_tb/cpu/Cache/data_vaild_out
add wave -noupdate /CPU_tb/cpu/Cache/has_stored
add wave -noupdate /CPU_tb/cpu/Cache/data_check
add wave -noupdate /CPU_tb/cpu/Cache/cache_miss
add wave -noupdate /CPU_tb/cpu/Cache/optype_out
add wave -noupdate /CPU_tb/cpu/Cache/CACHE
add wave -noupdate /CPU_tb/cpu/Cache/TAG
add wave -noupdate /CPU_tb/cpu/Cache/address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {399356 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 332
configure wave -valuecolwidth 154
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
WaveRestoreZoom {111510 ps} {222358 ps}
