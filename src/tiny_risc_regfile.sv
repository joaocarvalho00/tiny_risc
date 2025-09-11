import tiny_risc_pkg::*;

module tiny_risc_regfile
#(
    parameter P_BASE_WIDTH    = 32,
    parameter P_REGFILE_DEPTH = 32
)
(
    input  logic                            clk,
    input  logic                            rst,

    input  t_wr_rd_enable                   i_enable,

    input  logic [        P_BASE_WIDTH-1:0] i_wr_data,
    input  logic [$clog2(P_BASE_WIDTH)-1:0] i_wr_addr,

    input  logic [$clog2(P_BASE_WIDTH)-1:0] i_rd_addr,
    output logic [        P_BASE_WIDTH-1:0] o_rd_data
);

    logic [P_REGFILE_DEPTH-1:0] regs [P_BASE_WIDTH-1:0];

    always_ff @ (posedge clk or negedge rst) begin
        if (!rst) begin
            for (int i=0; i<P_REGFILE_DEPTH; i++) begin
                regs[i] <= 32'b0;
            end
        end
        else begin
            // ** Write **
            if (i_enable == WRITE) begin
                regs[wr_addr] <= i_wr_data;
                o_rd_data       <= {P_BASE_WIDTH{1'b0}};
            end
            // ** Read **
            if (i_enable == READ) begin
                o_rd_data       <= regs[i_wr_addr];
            end
        end
    end

endmodule