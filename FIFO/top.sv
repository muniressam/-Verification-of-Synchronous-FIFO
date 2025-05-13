module top ();
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk; // Generate a clock signal
        end
    end

    FIFO_interface fifo_if (clk);

    FIFO DUT (fifo_if);
    FIFO_tb TB (fifo_if);
    FIFO_monitor MONITOR (fifo_if);

endmodule