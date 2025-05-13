package FIFO_transaction_pkg;
    import shared_pkg::*;

    class FIFO_transaction;
        rand bit rst_n;
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

        function new(integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction 

        //Reset
        constraint c_reset {rst_n dist {1:=10, 0:=90};}
        //FIFO_1
        constraint c_wr_en {wr_en dist {1:=WR_EN_ON_DIST, 0:=100-WR_EN_ON_DIST};}
        //FIFO_2
        constraint c_rd_en {rd_en dist {1:=RD_EN_ON_DIST, 0:=100-RD_EN_ON_DIST};}
    
    endclass 
    
endpackage