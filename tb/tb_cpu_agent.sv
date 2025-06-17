class tb_cpu_agent extends uvm_agent;

    `uvm_component_utils(tb_cpu_agent)

    // Agent components
    tb_cpu_driver     driver;
    tb_cpu_monitor    monitor;
    tb_cpu_sequencer  sequencer;

    // Virtual interface
    virtual cpu_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual cpu_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")

        // Create components
        monitor = tb_cpu_monitor::type_id::create("monitor", this);
        sequencer = tb_cpu_sequencer::type_id::create("sequencer", this);
        driver    = tb_cpu_driver::type_id::create("driver", this);

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        monitor.vif = vif;

        driver.vif = vif;
        driver.seq_item_port.connect(sequencer.seq_item_export);
        
    endfunction

endclass : tb_cpu_agent
