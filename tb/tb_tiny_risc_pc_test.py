import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

# Get the parameters from the DUT
P_BASE_WIDTH = cocotb.top.P_BASE_WIDTH.value

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
async def pc_test(dut):
    """Simple test to verify the functionality of the PC module."""
    clk    = dut.clk
    rst    = dut.rst
    i_pc   = dut.i_pc
    o_pc   = dut.o_pc

    # Start the clock
    await generate_clock(dut)

    # Reset the DUT and wait for it to complete
    await reset_dut(rst, 15)
    dut._log.info("Reset finished!")

    # Verify that the PC is 0 after reset
    await RisingEdge(clk)
    assert o_pc.value == 0, f"PC did not reset to 0. Got {int(o_pc.value)}"
    dut._log.info(f"PC reset verified. Value: {int(o_pc.value)}")

    # Test basic functionality: update PC value
    dut._log.info("Testing PC update functionality.")
    
    # Set the input and wait for the next clock edge
    i_pc.value = 4
    await RisingEdge(clk)
    
    # Wait another clock cycle for the registered output to be updated
    await RisingEdge(clk)
    
    # Verify that the output has been updated
    assert o_pc.value == 4, f"PC update failed. Expected 4, got {int(o_pc.value)}"
    dut._log.info(f"PC updated to {int(o_pc.value)}, as expected.")

    # Set the input to another value and wait for the next clock edge
    i_pc.value = 8
    await RisingEdge(clk)
    
    # Wait another clock cycle for the registered output to be updated
    await RisingEdge(clk)
    
    # Verify the second update
    assert o_pc.value == 8, f"PC update failed. Expected 8, got {int(o_pc.value)}"
    dut._log.info(f"PC updated to {int(o_pc.value)}, as expected.")
    
    dut._log.info("PC test finished successfully!")
