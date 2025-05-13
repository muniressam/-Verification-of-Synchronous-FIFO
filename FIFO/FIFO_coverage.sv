package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;
    
    class FIFO_coverage;
        FIFO_transaction  F_cvg_txn =new(); 

        covergroup FIFO_cvg; 
            // coverpoints
            //FIFO_1
            cp_wr_en: coverpoint F_cvg_txn.wr_en;
            //FIFO_2
            cp_rd_en: coverpoint F_cvg_txn.rd_en;
            //FIFO_3
            cp_full: coverpoint F_cvg_txn.full;
            //FIFO_4
            cp_empty: coverpoint F_cvg_txn.empty;
            //FIFO_5
            cp_almostfull: coverpoint F_cvg_txn.almostfull;
            //FIFO_6
            cp_almostempty: coverpoint F_cvg_txn.almostempty; 
            //FIFO_7
            cp_ack: coverpoint F_cvg_txn.wr_ack;
            //FIFO_8
            cp_overflow: coverpoint F_cvg_txn.overflow;
            //FIFO_9
            cp_underflow: coverpoint F_cvg_txn.underflow;
            
            // cross coverage
            // FIFO_3
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

        function new;
            FIFO_cvg = new();
        endfunction

        function void sample_data(input FIFO_transaction F_txn );
            F_cvg_txn = F_txn;
            FIFO_cvg.sample();
        endfunction
    endclass

    
endpackage