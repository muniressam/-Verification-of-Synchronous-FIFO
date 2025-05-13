package FIFO_scoreboard_pkg;
    import shared_pkg::*;
    import FIFO_transaction_pkg::*;

    class FIFO_scoreboard;
        logic [FIFO_WIDTH-1:0] data_out_ref; 

        bit [FIFO_WIDTH-1:0] mem [$];

        function void check_data (input FIFO_transaction tr);
            reference_model(tr);
            if (tr.data_out === data_out_ref  ) begin
                $display("rst_n=%0b ,wr_en=%0b ,rd_en=%0b,data_in=%0h",tr.rst_n, tr.wr_en, tr.rd_en,tr.data_in);
                $display("Expected: data_out=%0h", data_out_ref);
                $display("Received: data_out=%0h", tr.data_out);

                correct_count++;
             
            end else begin
                $display("Errorrrrrrrrrrrrrr: Data mismatch at time %0t", $time);
                $display("rst_n=%0b ,wr_en=%0b ,rd_en=%0b,data_in=%0h",tr.rst_n, tr.wr_en, tr.rd_en,tr.data_in);
                $display("Expected: data_out=%0h", data_out_ref);
                $display("Received: data_out=%0h", tr.data_out);

                error_count++;
            end
        endfunction 

       function void reference_model (input FIFO_transaction tr);
            // Reference model logic to update reference signals based on FIFO operations
            if (!tr.rst_n) begin
                mem.delete();
            end else begin
                //FIFO_1
            if (tr.wr_en && !tr.rd_en) begin
                if (!full_ref()) begin
                    mem.push_back(tr.data_in);
                end
                
            end
                //FIFO_2
            else if (tr.rd_en && !tr.wr_en) begin
                if (!empty_ref()) begin
                    data_out_ref = mem.pop_front();
                end
                    
            end
            else if (tr.wr_en && tr.rd_en) begin
                if (empty_ref() ) begin
                    mem.push_back(tr.data_in);
                    
                end
                else if (full_ref() ) begin
                    data_out_ref = mem.pop_front();
                    
                end 
                else  if (!empty_ref() && !full_ref() ) begin
                    data_out_ref = mem.pop_front();
                    mem.push_back(tr.data_in);
                    
                end
            end
        end      
          //  full_ref = (mem.size == FIFO_DEPTH )? 1 : 0;
          //  empty_ref = (mem.size == 0)? 1 : 0;   
        
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


    endclass 

endpackage