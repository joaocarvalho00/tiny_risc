class tb_cpu_test extends uvm_test;

    `uvm_component_utils(tb_cpu_test)

    tb_cpu_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = tb_cpu_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        tb_cpu_sequence seq;
        phase.raise_objection(this);

        seq = tb_cpu_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);

        phase.drop_objection(this);
    endtask

endclass : tb_cpu_test
