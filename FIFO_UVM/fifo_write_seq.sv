package fifo_write_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;
    
    class fifo_write_seq extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(fifo_write_seq)
        fifo_seq_item seq_item;
        // Constructor
        function new(string name = "fifo_write_seq");
            super.new(name);
        endfunction
        
        // Body of the sequence
        virtual task body();
            seq_item = fifo_seq_item::type_id::create("seq_item");

            repeat(10) begin
                start_item(seq_item);
                assert (seq_item.randomize());
                seq_item.rst_n =1;
                seq_item.rd_en =0;
                seq_item.wr_en =1;
                finish_item(seq_item);
            end
            
        endtask
    endclass //fifo_write_seq extends uvm_sequence #(fifo_seq_item);
endpackage