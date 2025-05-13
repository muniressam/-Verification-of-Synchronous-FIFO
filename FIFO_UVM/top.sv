import fifo_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top ();
    bit clk;
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end
    fifo_IF fifo_if(clk);
    FIFO DUT (fifo_if);
    
    bind FIFO fifo_sva sva(fifo_if);

    initial begin
        uvm_config_db #(virtual fifo_IF)::set(null ,"uvm_test_top" , "fifo_IF" ,fifo_if);
        run_test("fifo_test");
    end
endmodule
