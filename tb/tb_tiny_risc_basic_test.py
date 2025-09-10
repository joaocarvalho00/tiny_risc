import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge


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
async def my_second_test(dut):
    """Simple test to check compilation and running a sim is working"""
    clk     = dut.clk
    reset_n = dut.rst
    q_in    = dut.q
    d_out   = dut.d

    # Start clock
    await generate_clock(dut)

    # Execution will block until reset_dut has completed
    await reset_dut(reset_n, 15)
    dut._log.debug("After reset")

    for i in range(0, 33):
        await RisingEdge(clk)
        q_in.value = i
        dut._log.info(f"Q_IN = {i}\t D_OUT = {d_out.value.integer}")
        if (i < 2): continue
        else       : assert (d_out.value.integer == (i-2))
