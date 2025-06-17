class tb_cpu_seq_item extends uvm_sequence_item;

    rand bit [7:0] in_q;

    `uvm_object_utils_begin(tb_cpu_seq_item);
        `uvm_field_int(in_q, UVM_HEX)
    `uvm_object_utils_end

    function new(string name = "input");
        super.new(name);
    endfunction: new

    virtual task display();
        `uvm_info(get_type_name(), $sformatf("in_q = %x", in_q), UVM_LOW)
    endtask
endclass : tb_cpu_seq_item