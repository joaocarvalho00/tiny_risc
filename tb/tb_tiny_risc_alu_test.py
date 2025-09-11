import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
from enum import IntEnum

# Get the parameters from the DUT
P_BASE_WIDTH = cocotb.top.P_BASE_WIDTH.value

class AluOp(IntEnum):
    ADD_OP  = 0
    SUB_OP  = 1
    AND_OP  = 2
    OR_OP   = 3
    XOR_OP  = 4
    SLT_OP  = 5
    SLTU_OP = 6

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

async def test_operation(dut, op_a, op_b, alu_op, expected_result):
    """A helper function to test a single ALU operation."""
    dut.op_a.value  = op_a
    dut.op_b.value  = op_b
    dut.alu_op.value = alu_op
    
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk) # Wait one extra cycle for the output to be registered

    if (expected_result < 0):
        assert dut.result.value.signed_integer == expected_result, \
            f"ALU test failed for {alu_op.name}:\n \
            Expected: {expected_result:#b}\n \
              actual: {dut.result.value.signed_integer}"
    else:
        assert dut.result.value == expected_result, \
            f"ALU test failed for {alu_op.name}:\n \
            Expected : {expected_result:#b}\n \
              actual : {dut.result.value}"
    
    assert dut.zero_out.value == (expected_result == 0), \
        f"Zero flag test failed for {alu_op.name}: Expected {expected_result == 0}, got {bool(dut.zero_out.value)}"
    
    dut._log.info(f"Test passed for {alu_op.name} with result {P_BASE_WIDTH}'h{dut.result.value}")


@cocotb.test()
async def alu_test(dut):
    """Simple test to verify the functionality of the ALU module."""
    clk    = dut.clk
    rst    = dut.rst
    op_a   = dut.op_a
    op_b   = dut.op_b
    alu_op = dut.alu_op
    result = dut.result
    zero_out = dut.zero_out

    # Start the clock
    await generate_clock(dut)

    # Reset the DUT and wait for it to complete
    await reset_dut(rst, 15)
    dut._log.info("Reset finished!")

    # Verify that the outputs are 0 after reset
    await RisingEdge(clk)
    assert result.value == 0, f"Result did not reset to 0. Got {result.value}"
    assert zero_out.value == 0, f"Zero flag did not reset to 0. Got {zero_out.value}"
    dut._log.info("ALU outputs reset verified.")
    
    # Test ADD operation
    await test_operation(dut, 10, 5, AluOp.ADD_OP, 15)
    await test_operation(dut, -1, 1, AluOp.ADD_OP, 0)

    # Test SUB operation
    await test_operation(dut, 10, 5, AluOp.SUB_OP, 5)
    await test_operation(dut, 5, 10, AluOp.SUB_OP, -5)

    # Test AND operation
    await test_operation(dut, 0xF0F0F0F0, 0x0F0F0F0F, AluOp.AND_OP, 0x00000000)
    await test_operation(dut, 0xAAAAAAAA, 0xCCCCCCCC, AluOp.AND_OP, 0x88888888)

    # Test OR operation
    await test_operation(dut, 0xF0F0F0F0, 0x0F0F0F0F, AluOp.OR_OP, 0xFFFFFFFF)
    await test_operation(dut, 0xAAAAAAAA, 0xCCCCCCCC, AluOp.OR_OP, 0xEEEEEEEE)
    
    # Test XOR operation
    await test_operation(dut, 0xAAAAAAAA, 0xAAAAAAAA, AluOp.XOR_OP, 0x00000000)
    await test_operation(dut, 0xAAAAAAAA, 0xCCCCCCCC, AluOp.XOR_OP, 0x66666666)
    
    # Test SLT (Set on Less Than, signed)
    await test_operation(dut, 5, 10, AluOp.SLT_OP, 1)
    await test_operation(dut, 10, 5, AluOp.SLT_OP, 0)
    await test_operation(dut, -5, -10, AluOp.SLT_OP, 0)
    await test_operation(dut, -10, -5, AluOp.SLT_OP, 1)

    # Test SLTU (Set on Less Than Unsigned)
    await test_operation(dut, 5, 10, AluOp.SLTU_OP, 1)
    await test_operation(dut, 10, 5, AluOp.SLTU_OP, 0)
    await test_operation(dut, 2**32-1, 1, AluOp.SLTU_OP, 0)
    await test_operation(dut, 1, 2**32-1, AluOp.SLTU_OP, 1)

    dut._log.info("All ALU tests finished successfully!")
