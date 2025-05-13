package fifo_scoreboard_pkg;
    import uvm_pkg::*;
    import fifo_seq_item_pkg::*;
    `include "uvm_macros.svh"

    parameter FIFO_DEPTH = 8;
    parameter FIFO_WIDTH = 16;
    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)
        uvm_analysis_export #(fifo_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
        fifo_seq_item seq_item_sb;
       
        logic [FIFO_WIDTH-1:0] data_out_ref; 
        bit [FIFO_WIDTH-1:0] mem [$];

        int correct_count;
        int error_count;

        function new(string name = "fifo_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_fifo = new("sb_fifo", this);
            sb_export = new("sb_export", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);     
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);           
            forever begin
                sb_fifo.get(seq_item_sb);
                reference_model(seq_item_sb);
                if (seq_item_sb.data_out === data_out_ref) begin
                    `uvm_info("SCOREBOARD run_phase", $sformatf("Correct fifo out: %s ",seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count++;           
                end else begin
                    `uvm_error("SCOREBOARD run_phase", $sformatf("Compartion faild, Transaction recived by DUT: %s  While the Refrence data_out_ref:0h %0h ", seq_item_sb.convert2string(),data_out_ref));
                    error_count++;
                end
            end
        endtask 

        function void reference_model (fifo_seq_item seq_item_chk);
            // Reference model logic to update reference signals based on FIFO operations
            if (!seq_item_chk.rst_n) begin
                mem.delete();
            end else begin
                //FIFO_1
            if (seq_item_chk.wr_en && !seq_item_chk.rd_en) begin
                if (!full_ref()) begin
                    mem.push_back(seq_item_chk.data_in);
                end
                
            end
                //FIFO_2
            else if (seq_item_chk.rd_en && !seq_item_chk.wr_en) begin
                if (!empty_ref()) begin
                    data_out_ref = mem.pop_front();
                end
                    
            end
            else if (seq_item_chk.wr_en && seq_item_chk.rd_en) begin
                if (empty_ref() ) begin
                    mem.push_back(seq_item_chk.data_in);
                    
                end
                else if (full_ref() ) begin
                    data_out_ref = mem.pop_front();
                    
                end 
                else  if (!empty_ref() && !full_ref() ) begin
                    data_out_ref = mem.pop_front();
                    mem.push_back(seq_item_chk.data_in);
                    
                end
            end
        end 
            
        endfunction //reference_model

        function  bit full_ref();
            if (mem.size() == FIFO_DEPTH ) 
                return 1;
            return 0;
        endfunction

        function  bit empty_ref();
            if (mem.size() == 0 ) 
                return 1;
            return 0;
        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SCOREBOARD report_phase", $sformatf("Total Successful transactions: %0d", correct_count), UVM_MEDIUM);
            `uvm_info("SCOREBOARD report_phase", $sformatf("Total Faild transactions: %0d", error_count), UVM_MEDIUM);
        endfunction
    endclass  
endpackage