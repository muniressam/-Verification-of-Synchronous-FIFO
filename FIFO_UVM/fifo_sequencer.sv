package fifo_sequencer_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import fifo_seq_item_pkg::*;

    class fifo_sequencer extends uvm_sequencer #(fifo_seq_item);
        `uvm_component_utils(fifo_sequencer)

        function new(string name = "fifo_sequencer" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

    endclass //reset_seq extends superClass
endpackage