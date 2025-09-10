import tiny_risc_pkg::*;

module tiny_risc_regfile
#(
    parameter P_BASE_WIDTH    = 32,
    parameter P_REGFILE_DEPTH = 32
)
(
    input  logic                            clk,
    input  logic                            rst,

    input  wr_rd_enable                     enable,

    input  logic [        P_BASE_WIDTH-1:0] wr_data,
    input  logic [$clog2(P_BASE_WIDTH)-1:0] wr_addr,

    input  logic [$clog2(P_BASE_WIDTH)-1:0] rd_addr,
    output logic [        P_BASE_WIDTH-1:0] rd_data
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
            if (enable == WRITE) begin
                regs[wr_addr] <= wr_data;
                rd_data       <= {P_BASE_WIDTH{1'b0}};
            end
            // ** Read **
            if (enable == READ) begin
                rd_data       <= regs[rd_addr];
            end
        end
    end

endmodule