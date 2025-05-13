package fifo_agent_pkg;
    import uvm_pkg::*;
    import fifo_sequencer_pkg::*;
    import fifo_driver_pkg::*;
    import fifo_monitor_pkg::*;
    import fifo_config_obj_pkg::*;
    import fifo_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class fifo_agent extends uvm_agent;
        `uvm_component_utils(fifo_agent)

        fifo_sequencer sequencer;
        fifo_driver driver;
        fifo_monitor monitor;
        fifo_config_obj config_obj;
        uvm_analysis_port #(fifo_seq_item) agent_ap;
        
        function new(string name = "fifo_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(fifo_config_obj)::get(this,"","CFG_VIF", config_obj)) begin
                `uvm_fatal("build_phase","Unable to get configuration object")
            end
            if(config_obj.is_active == UVM_ACTIVE) begin
                driver = fifo_driver::type_id::create("driver", this);
                sequencer = fifo_sequencer::type_id::create("sequencer", this);
            end else begin
                `uvm_info("build_phase" , "agent passive" ,UVM_MEDIUM);
            end
            
            monitor = fifo_monitor::type_id::create("monitor", this);
            agent_ap = new("agent_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(config_obj.is_active == UVM_ACTIVE) begin
                driver.fifo_driver_vif = config_obj.fifo_config_vif;
                driver.seq_item_port.connect(sequencer.seq_item_export);
            end else begin
                `uvm_info("connect_phase" , "agent passive" ,UVM_MEDIUM);
            end
            
            monitor.fifo_monitor_vif = config_obj.fifo_config_vif;
            monitor.mon_ap.connect(agent_ap);
        endfunction

    endclass //fifo_agent extends uvm_agent;
endpackage