class tb_cpu_sequence extends uvm_sequence #(tb_cpu_seq_item);

    `uvm_object_utils(tb_cpu_sequence)

    virtual cpu_if vif;

    function new(string name = "tb_cpu_sequence");
        super.new(name);
    endfunction

    virtual task pre_body();
        // Call reset before starting stimulus
        tb_cpu_reset_seq reset_seq = tb_cpu_reset_seq::type_id::create("reset_seq");

        if (!uvm_config_db#(virtual cpu_if)::get(null, "*", "vif", vif))
            `uvm_fatal(get_type_name(), "Failed to get vif in tb_cpu_sequence")

        reset_seq.vif = vif;
        reset_seq.start(null);  // No sequencer needed since this doesn't drive items
    endtask

    virtual task body();
        tb_cpu_seq_item req;
        for (int i = 0; i < 10; i++) begin
            req = tb_cpu_seq_item::type_id::create("req");
            assert(req.randomize());
            start_item(req);
            finish_item(req);
        end
    endtask

endclass : tb_cpu_sequence
