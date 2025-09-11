package tiny_risc_pkg;

    // Enum for write/read enable signal in the register file.
    typedef enum {NONE, 
                  READ, 
                  WRITE} t_wr_rd_enable;

    // Enum for the ALU operation.
    // Based on RISC-V integer instructions.
    typedef enum logic [2:0] {
        ADD_OP,     // Addition
        SUB_OP,     // Subtraction
        AND_OP,     // Bitwise AND
        OR_OP,      // Bitwise OR
        XOR_OP,     // Bitwise XOR
        SLT_OP,     // Set on Less Than (signed)
        SLTU_OP     // Set on Less Than Unsigned
    } t_alu_op;

endpackage