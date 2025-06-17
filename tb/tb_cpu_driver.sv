class tb_cpu_driver extends uvm_driver #(tb_cpu_seq_item);

    `uvm_component_utils(tb_cpu_driver)

    // Virtual interface
    virtual cpu_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual cpu_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        tb_cpu_seq_item req;

        forever begin
            // Wait for a new sequence item
            seq_item_port.get_next_item(req);

            // Drive input on rising edge of clock
            @(posedge vif.clk);
            vif.in_q <= req.in_q;

            // Display info (optional debug)
            `uvm_info(get_type_name(), $sformatf("Driving in_q = %0x", req.in_q), UVM_LOW)

            // Indicate item is done
            seq_item_port.item_done();
        end
    endtask

endclass : tb_cpu_driver