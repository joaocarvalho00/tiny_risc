import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
from enum import IntEnum

# Get the parameters from the DUT
P_BASE_WIDTH    = cocotb.top.P_BASE_WIDTH.value
P_REGFILE_DEPTH = cocotb.top.P_REGFILE_DEPTH.value

class wr_rd_enable(IntEnum):
    NONE  = 0
    READ  = 1
    WRITE = 2
    

async def generate_clock(dut):
    """Generate clock pulses."""
    initial_delay = 1
    await Timer(initial_delay, units="ns")

    c = Clock(dut.clk, 10, 'ns')
    await cocotb.start(c.start())

async def reset_dut(reset_n, duration_ns):
    """Reset pulse."""
    reset_n.value = 0
    await Timer(duration_ns, units="ns")
    reset_n.value = 1
    reset_n._log.debug("Reset complete")


@cocotb.test()
async def regfile_read_write_test(dut):
    """Simple test to check read/write capabilities of the regfile"""
    clk        = dut.clk
    rst        = dut.rst

    enable     = dut.enable
    wr_data    = dut.wr_data
    wr_addr    = dut.wr_addr
    rd_data    = dut.rd_data
    rd_addr    = dut.rd_addr

    # Start clock
    await generate_clock(dut)

    # Execution will block until reset_dut has completed
    await reset_dut(rst, 15)
    dut._log.info("Reset finished!")

    # Deassert all control signals
    enable.value = wr_rd_enable.NONE
    wr_data.value = 0
    wr_addr.value = 0
    rd_addr.value = 0
    await RisingEdge(clk)

     # 1. Check if all registers are 0 after reset
    dut._log.info("= ------------------ =\n" \
                  "Phase 1: Verifying all registers are 0 after reset.\n" \
                  "= ------------------ =")
    enable.value = wr_rd_enable.READ
    for i in range(P_REGFILE_DEPTH):
        rd_addr.value = i
        await RisingEdge(clk)
        # Wait an extra cycle for the registered output to become stable
        await RisingEdge(clk)
        expected_value = 0
        assert rd_data.value == expected_value, \
            f"Register {i} readback failed: Expected {expected_value}, got {int(rd_data.value)}"
        dut._log.info(f"Register {i} verified to be 0.")

    # 2. Write an increasing value into each register
    dut._log.info("= ------------------ =\n" \
                  "Phase 2: Writing increasing values to each register.\n" \
                  "= ------------------ =")
    enable.value = wr_rd_enable.WRITE
    for i in range(P_REGFILE_DEPTH):
        value_to_write = i + 1
        wr_addr.value = i
        wr_data.value = value_to_write
        await RisingEdge(clk)
        dut._log.info(f"Wrote {value_to_write} to register {i}.")

    enable.value = wr_rd_enable.READ
    await RisingEdge(clk)

    # 3. Read back and verify the written values
    dut._log.info("= ------------------ =\n" \
                  "Phase 3: Reading back and verifying written values.\n"
                  "= ------------------ =")
    for i in range(P_REGFILE_DEPTH):
        rd_addr.value = i
        await RisingEdge(clk)
        # Wait an extra cycle for the registered output to become stable
        await RisingEdge(clk)
        expected_value = i + 1
        assert rd_data.value == expected_value, \
            f"Readback failed for register {i}: Expected {expected_value}, got {int(rd_data.value)}"
        dut._log.info(f"Read back {int(rd_data.value)} from register {i}, as expected.")

    dut._log.info("Test finished successfully!")
