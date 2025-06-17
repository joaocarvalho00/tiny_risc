class tb_cpu_scoreboard extends uvm_component;

    `uvm_component_utils(tb_cpu_scoreboard)

    uvm_analysis_imp #(tb_cpu_seq_item, tb_cpu_scoreboard) item_collected_export;
    virtual cpu_if vif;

    // Queue to track expected inputs
    tb_cpu_seq_item expected_q[$];

    // Track whether last cycle was in reset
    bit was_in_reset;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
        was_in_reset = 1'b1;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual cpu_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction

    virtual task write(tb_cpu_seq_item t);
        expected_q.push_back(t);

        @(posedge vif.clk);

        if (!vif.rst) begin
            `uvm_info(get_type_name(), "Reset asserted — skipping comparison.", UVM_LOW)
            expected_q = {};  // Clear expected queue during reset
            was_in_reset = 1'b1;
            return;
        end

        if (was_in_reset) begin
            `uvm_info(get_type_name(), "Just came out of reset — skipping first post-reset comparison.", UVM_LOW)
            was_in_reset = 1'b0;
            return;
        end

        if (expected_q.size() > 1) begin
            tb_cpu_seq_item prev = expected_q.pop_front();

            if (vif.out_d !== prev.in_q) begin
                `uvm_error(get_type_name(),
                    $sformatf("Mismatch! Expected d = %0x, got = %0x", prev.in_q, vif.out_d))
            end else begin
                `uvm_info(get_type_name(),
                    $sformatf("PASS: d matched q = %0x", prev.in_q), UVM_LOW)
            end
        end
    endtask

endclass : tb_cpu_scoreboard
