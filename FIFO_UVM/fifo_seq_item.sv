package fifo_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    
    class fifo_seq_item extends uvm_sequence_item;
        `uvm_object_utils(fifo_seq_item);
        rand logic rst_n;
        rand logic wr_en;
        rand logic rd_en;
        rand logic [FIFO_WIDTH-1:0] data_in;
        logic [FIFO_WIDTH-1:0] data_out;
        logic full;
        logic almostfull;
        logic empty;
        logic almostempty;
        logic overflow;
        logic underflow;
        logic wr_ack;

        integer RD_EN_ON_DIST;
        integer WR_EN_ON_DIST;

        function new(string name = "fifo_seq_item" ,integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST = 70);
            super.new(name);   
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction 
        ///////////////constraints//////////////////////
        
        constraint c_reset {rst_n dist {1:=98, 0:=2};}
        constraint c_wr_en {wr_en dist {1:=WR_EN_ON_DIST, 0:=100-WR_EN_ON_DIST};}
        constraint c_rd_en {rd_en dist {1:=RD_EN_ON_DIST, 0:=100-RD_EN_ON_DIST};}
    

        function string convert2string();
            return $sformatf("%s rst_n =%0b , wr_en =%0b, rd_en =%0b ,data_in=%0h
                                data_out=%0h, full=%0b, almostfull=%0b, empty=%0b, almostempty=%0b,overflow=%0b, underflow=%0b, wr_ack=%0b ",super.convert2string(),
                                rst_n,wr_en, rd_en,data_in,data_out, full, almostfull, empty, almostempty, overflow, underflow, wr_ack);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst_n =%0b , wr_en =%0b, rd_en =%0b ,data_in=%0h",rst_n,wr_en, rd_en,data_in);
        endfunction
        
    endclass 

    class fifo_seq_item_disable_rst extends fifo_seq_item;
        `uvm_object_utils(fifo_seq_item_disable_rst);
        function new(string name = "fifo_seq_item_disable_rst");
            super.new(name);
        endfunction //new()

        constraint c_reset {rst_n dist {1:=100, 0:=0};}

    endclass //fifo_seq_item_disable_rst extends superClass
endpackage