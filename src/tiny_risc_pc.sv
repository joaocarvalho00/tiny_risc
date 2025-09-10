// The Program Counter (PC) is a special register that holds the memory address of the next instruction
// to be executed.
module tiny_risc_pc
#(
    parameter P_BASE_WIDTH = 32
)
(
    input  logic                    clk,
    input  logic                    rst,
    input  logic [P_BASE_WIDTH-1:0] i_pc,
    output logic [P_BASE_WIDTH-1:0] o_pc
);

    // Internal register to hold the PC value
    logic [P_BASE_WIDTH-1:0] pc;

    // The sequential logic for the PC
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Asynchronous reset to 0
            pc <= '0;
        end else begin
            // On the rising clock edge, update the PC with the new value
            pc <= i_pc;
        end
    end

    // The output is the current value of the PC register
    assign o_pc = pc;

endmodule