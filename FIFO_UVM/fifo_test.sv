package fifo_test_pkg;
import uvm_pkg::*;
import fifo_env_pkg::*;
import fifo_config_obj_pkg::*;
import fifo_reset_seq_pkg::*;
import fifo_write_seq_pkg::*;
import fifo_read_seq_pkg::*;
import fifo_write_read_seq_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"

class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;
    fifo_config_obj config_obj;
    fifo_reset_seq reset_seq;
    fifo_write_seq write_seq;
    fifo_read_seq  read_seq;
    fifo_write_read_seq write_read_seq;
    
    //virtual fifo_IF fifo_test_vif ;

    function new(string name = "fifo_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env",this);
        config_obj = fifo_config_obj::type_id::create("config_obj");
        reset_seq = fifo_reset_seq::type_id::create("reset_seq");
        write_seq = fifo_write_seq::type_id::create("write_seq");
        read_seq = fifo_read_seq::type_id::create("read_seq");
        write_read_seq = fifo_write_read_seq::type_id::create("write_read_seq");
        if(!uvm_config_db#(virtual fifo_IF)::get(this,"","fifo_IF",config_obj.fifo_config_vif)) begin
            `uvm_fatal("build_phase","fifo_IF not found in uvm_config_db")
        end
        config_obj.is_active = UVM_ACTIVE;
        uvm_config_db#(fifo_config_obj)::set(this,"*","CFG_VIF",config_obj);
        
        set_type_override_by_type(fifo_seq_item:: get_type(),fifo_seq_item_disable_rst::get_type());
    endfunction

    task run_phase(uvm_phase phase);
        
        super.run_phase(phase);
        
        phase.raise_objection(this);
        
        //reset_sequence
        `uvm_info("TEST run_phase","RESET is Asserted", UVM_MEDIUM);
        reset_seq.start(env.agent.sequencer);
        
        `uvm_info("TEST run_phase","RESET is Deasserted", UVM_MEDIUM);

        //write_sequence
        `uvm_info("TEST run_phase","Stimulus Generation write Started", UVM_MEDIUM);
        write_seq.start(env.agent.sequencer);
        `uvm_info("TEST run_phase","Stimulus Generation write Ended", UVM_MEDIUM);

        //read_sequence
        `uvm_info("TEST run_phase","Stimulus Generation read Started", UVM_MEDIUM);
        read_seq.start(env.agent.sequencer);
        `uvm_info("TEST run_phase","Stimulus Generation read Ended", UVM_MEDIUM);

        //write_read_sequence
        `uvm_info("TEST run_phase","Stimulus Generation write_read Started", UVM_MEDIUM);
        write_read_seq.start(env.agent.sequencer);
        `uvm_info("TEST run_phase","Stimulus Generation write_read Ended", UVM_MEDIUM);
        
        phase.drop_objection(this);
    endtask
endclass 
endpackage