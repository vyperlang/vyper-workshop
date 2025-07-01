# @version ^0.4.0
"""
@notice Demonstrates branch optimization in Venom IR
@dev Shows iszero chains and branch flipping
"""

@external
@pure
def iszero_chain_simple(x: uint256) -> bool:
    """
    @notice Simple iszero chain that gets optimized
    @dev not(not(x > 0)) can be simplified
    """
    # This creates an iszero chain in Venom IR
    return not (not (x > 0))
    # Optimizer may simplify this to just (x > 0)

@external
@pure
def iszero_chain_complex(x: uint256, y: uint256) -> bool:
    """
    @notice More complex iszero chain
    @dev Multiple negations that can be optimized
    """
    # Complex boolean expression with multiple negations
    condition1: bool = not (x == 0)  # iszero(iszero(x))
    condition2: bool = not (y == 0)  # iszero(iszero(y))
    
    # This creates a chain of iszero operations
    return not (not (condition1 and condition2))

@external
def branch_flipping_example(x: uint256, y: uint256) -> uint256:
    """
    @notice Demonstrates branch flipping optimization
    @dev Compiler may flip branches based on cost/liveness analysis
    """
    # The compiler might flip this branch if the else path
    # has fewer live variables or is less expensive
    if x == 0:
        # Expensive path with many operations
        temp1: uint256 = y * y
        temp2: uint256 = temp1 * y  
        temp3: uint256 = temp2 + 100
        temp4: uint256 = temp3 // 2
        return temp4
    else:
        # Cheap path
        return x + 1

@external
@pure
def branch_with_common_subexpr(a: uint256, b: uint256) -> uint256:
    """
    @notice Shows how branches with common subexpressions are optimized
    @dev The expensive computation might be hoisted
    """
    expensive: uint256 = (a * b) + (a // 2) + (b // 3)
    
    if expensive > 1000:
        # Use the expensive computation
        return expensive * 2
    elif expensive > 500:
        # Reuse the same expensive computation
        return expensive + 100
    else:
        # Still reuses it
        return expensive

