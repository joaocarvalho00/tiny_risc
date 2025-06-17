class tb_cpu_env extends uvm_env;

    `uvm_component_utils(tb_cpu_env)

    tb_cpu_agent agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = tb_cpu_agent::type_id::create("agent", this);
    endfunction

endclass : tb_cpu_env