vlib work
vlog -f src_files.list +cover -covercells
transcript file simulation_log.txt
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all 
run 0
add wave -position insertpoint sim:/top/DUT/*
coverage save FIFO.ucdb -onexit -du FIFO  -du fifo_sva
run -all

#quit -sim
vcover report FIFO.ucdb -details -annotate -all -output coverage_FIFO.txt