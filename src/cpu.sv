module cpu
(
    input  logic       clk,
    input  logic       rst,

    input  logic [7:0] q,
    output logic [7:0] d
);

always_ff @ (posedge clk or negedge rst) begin
    if (!rst)
        d <= 8'b0;
    else
        d <= q;
end

endmodule;