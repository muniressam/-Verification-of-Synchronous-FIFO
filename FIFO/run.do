vlib work
vlog -f src_files.list +cover -covercells +define+SIM
transcript file simulation_log.txt
vsim -voptargs=+acc work.top -cover 
run 0
add wave -position insertpoint sim:/top/DUT/*
coverage save FIFO.ucdb -onexit -du FIFO -du FIFO_coverage
run -all

#quit -sim
vcover report FIFO.ucdb -details -annotate -all -output coverage_FIFO.txt