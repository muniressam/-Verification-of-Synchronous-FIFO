package fifo_coverage_pkg;
    import uvm_pkg::*;
    import fifo_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class fifo_coverage extends uvm_component;
        `uvm_component_utils(fifo_coverage)
        fifo_seq_item seq_item_cov;
        uvm_analysis_export #(fifo_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;

        //////////// coverage group /////////////
        covergroup FIFO_cvg; 
            // coverpoints
            //FIFO_1
            cp_wr_en: coverpoint seq_item_cov.wr_en;
            //FIFO_2
            cp_rd_en: coverpoint seq_item_cov.rd_en;
            //FIFO_3
            cp_full: coverpoint seq_item_cov.full;
            //FIFO_4
            cp_empty: coverpoint seq_item_cov.empty;
            //FIFO_5
            cp_almostfull: coverpoint seq_item_cov.almostfull;
            //FIFO_6
            cp_almostempty: coverpoint seq_item_cov.almostempty; 
            //FIFO_7
            cp_overflow: coverpoint seq_item_cov.overflow;
            //FIFO_8
            cp_underflow: coverpoint seq_item_cov.underflow;
            //FIFO_9
            cp_ack: coverpoint seq_item_cov.wr_ack;

            // cross coverage
            //FIFO_3
            cross_wr_rd_en_full: cross cp_wr_en, cp_rd_en, cp_full{
                illegal_bins one_rd_one_full = binsof(cp_rd_en) intersect {1} && binsof(cp_full) intersect {1}; 
            } // full signal can't be high if there is read 
            //FIFO_4
            cross_wr_rd_en_empty: cross cp_wr_en, cp_rd_en, cp_empty; // no illegal_bins like full as reset make it empty and can't write when there is a reset
            //FIFO_5
            cross_wr_rd_en_almostfull : cross cp_wr_en, cp_rd_en, cp_almostfull; 
            //FIFO_6
            cross_wr_rd_en_almostempty: cross cp_wr_en, cp_rd_en, cp_almostempty; 
             //FIFO_7
            cross_wr_rd_en_wr_ack: cross cp_wr_en, cp_rd_en, cp_ack{
                illegal_bins zero_wr_one_ack = binsof(cp_wr_en) intersect {0} && binsof(cp_ack) intersect {1}; 
            } // wr_ack can't be done if the wr_en is zero 
            //FIFO_8
            cross_wr_rd_en_overflow: cross cp_wr_en, cp_rd_en, cp_overflow{
                illegal_bins zero_wr_one_overflow = binsof(cp_wr_en) intersect {0} && binsof(cp_overflow) intersect {1}; 
            } // overflow can't be done if there is no wr_en
            //FIFO_9
            cross_wr_rd_en_underflow: cross cp_wr_en, cp_rd_en, cp_underflow{
                illegal_bins zero_rd_one_underflow = binsof(cp_rd_en) intersect {0} && binsof(cp_underflow) intersect {1};
            } // underflow can't be done if no read occurs
            
        endgroup

        function new(string name = "fifo_coverage", uvm_component parent = null);
            super.new(name, parent);
            FIFO_cvg = new();
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);           
            forever begin
                cov_fifo.get(seq_item_cov);
                // sample the coverage group 
                FIFO_cvg.sample();
                
            end
        endtask
    endclass
endpackage