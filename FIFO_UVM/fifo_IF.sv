interface fifo_IF ( input bit clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    
    // FIFO interface signals
   
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;
    logic full;
    logic almostfull;
    logic empty;
    logic almostempty;
    logic overflow;
    logic underflow;
    logic wr_ack;
    
    modport DUT (
        input data_in, wr_en, rd_en, clk, rst_n,
        output full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out
    );
    
endinterface