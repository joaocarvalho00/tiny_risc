import tiny_risc_pkg::*;

// A simple Arithmetic Logic Unit (ALU) for a RISC-V core.
// This module performs a variety of operations based on the alu_op input.
module tiny_risc_alu
#(
    // The width of the data operands.
    parameter P_BASE_WIDTH = 32
)
(
    input  logic                    clk,
    input  logic                    rst,

    // ALU input operands
    input  logic [P_BASE_WIDTH-1:0] op_a,
    input  logic [P_BASE_WIDTH-1:0] op_b,

    // Control signal to select the operation
    input  t_alu_op                 alu_op,

    // ALU outputs
    output logic [P_BASE_WIDTH-1:0] result,
    output logic                    zero_out
);

    logic [P_BASE_WIDTH-1:0] alu_result;

    // Combinational logic for the ALU operations
    always_comb begin
        alu_result = '0; // Default value
        case (alu_op)
            ADD_OP:  alu_result = op_a + op_b;
            SUB_OP:  alu_result = op_a - op_b;
            AND_OP:  alu_result = op_a & op_b;
            OR_OP:   alu_result = op_a | op_b;
            XOR_OP:  alu_result = op_a ^ op_b;
            SLT_OP:  alu_result = ($signed(op_a) < $signed(op_b)) ? 1 : 0;
            SLTU_OP: alu_result = (op_a < op_b) ? 1 : 0;
            default: alu_result = '0;
        endcase
    end

    // Sequential logic to register the result and zero flag
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            result   <= '0;
            zero_out <= 1'b0;
        end else begin
            result   <= alu_result;
            zero_out <= (alu_result == '0);
        end
    end

endmodule
