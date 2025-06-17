class tb_cpu_monitor extends uvm_monitor;
    `uvm_component_utils(tb_cpu_monitor)

    // Virtual interface
    virtual cpu_if vif;

    // Analysis port to send observed items to scoreboard or other components
    uvm_analysis_port #(tb_cpu_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual cpu_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        tb_cpu_seq_item item;

        forever begin
            @(posedge vif.clk);

            item = tb_cpu_seq_item::type_id::create("item");

            item.in_q = vif.in_q;
            // You can optionally capture output if needed:
            // bit [7:0] out_val = vif.out_q;

            item.display();

            // Send to analysis port for further checking
            ap.write(item);
        end
    endtask

endclass : tb_cpu_monitor