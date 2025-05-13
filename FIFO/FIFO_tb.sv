import shared_pkg::*;
import FIFO_transaction_pkg::*;
module FIFO_tb (FIFO_interface.TB fifo_if);
    
    FIFO_transaction tr = new();
    
    initial begin
        
        fifo_if.wr_en = 0;
        fifo_if.rd_en = 0;
        fifo_if.data_in = 0;
        // test_finished = 0;
        // error_count = 0;
        // correct_count = 0;
        #0;
        fifo_if.rst_n=1;
        #0;
        task_reset();
        
        fifo_if.wr_en = 1;
        fifo_if.rd_en = 0;
        fifo_if.data_in = 0'h9999;            
        -> etrigger;
        @(negedge fifo_if.clk);

        fifo_if.wr_en = 1;
        fifo_if.rd_en = 1;
        fifo_if.data_in = 0'h7777;           
        -> etrigger;

        @(negedge fifo_if.clk);

        fifo_if.wr_en = 0;
        fifo_if.rd_en = 1;
        fifo_if.data_in = 0'h8888;           
        -> etrigger;
        @(negedge fifo_if.clk);
       
        repeat(10) begin
            assert(tr.randomize());
            fifo_if.wr_en = 1;
            fifo_if.rd_en = 0;
            fifo_if.data_in = tr.data_in;           
            -> etrigger;
            @(negedge fifo_if.clk);
            
        end
        fifo_if.wr_en = 1;
        fifo_if.rd_en = 1;
        fifo_if.data_in = tr.data_in;           
        -> etrigger;
        @(negedge fifo_if.clk);

        fifo_if.wr_en = 1;
        fifo_if.rd_en = 1;
        fifo_if.data_in = tr.data_in;
        //fifo_if.rst_n = tr.rst_n;            
        -> etrigger;
        @(negedge fifo_if.clk);

        repeat(10) begin
            assert(tr.randomize());
            fifo_if.wr_en = 0;
            fifo_if.rd_en = 1;
            fifo_if.data_in = tr.data_in;
            //fifo_if.rst_n = tr.rst_n;
            -> etrigger;
            @(negedge fifo_if.clk);
            
        end
        repeat(10) begin
            assert(tr.randomize());
            fifo_if.wr_en = 1;
            fifo_if.rd_en = 1;
            fifo_if.data_in = tr.data_in;
            //fifo_if.rst_n = tr.rst_n;
            -> etrigger;
            @(negedge fifo_if.clk);
            
        end

        repeat(100) begin
            assert(tr.randomize());
            fifo_if.wr_en = tr.wr_en;
            fifo_if.rd_en = tr.rd_en;
            fifo_if.data_in = tr.data_in;
            //fifo_if.rst_n = tr.rst_n;
            -> etrigger;
            @(negedge fifo_if.clk);
            
        end
        
         repeat(100) begin
            assert(tr.randomize());
            fifo_if.wr_en = tr.wr_en;
            fifo_if.rd_en = tr.rd_en;
            fifo_if.data_in = tr.data_in;
            fifo_if.rst_n = tr.rst_n;
            -> etrigger;
            @(negedge fifo_if.clk);
            
        end
        
        -> etrigger;
        //@(negedge fifo_if.clk);
        test_finished = 1;
        $display("Test Finished:",test_finished);
        
    end

    task task_reset ();
        fifo_if.rst_n = 0;
        -> etrigger;
        @(negedge fifo_if.clk);
        fifo_if.rst_n = 1;
        -> etrigger;
         @(negedge fifo_if.clk);
    endtask 
    
endmodule