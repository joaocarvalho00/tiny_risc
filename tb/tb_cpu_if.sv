interface cpu_if(input logic clk);

    logic rst;              // Active-low asynchronous reset
    logic [7:0] in_q;       // Input to DUT
    logic [7:0] out_d;      // Output from DUT

endinterface : cpu_if