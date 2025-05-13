interface FIFO_interface (clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    // FIFO interface signals
    input bit clk;
    bit rst_n;
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
    modport TB (
        input clk,full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out,
        output data_in, wr_en, rd_en, rst_n
    );
    modport MONITOR (
        input data_in, wr_en, rd_en, clk, rst_n,
        full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out
    );
    
endinterface