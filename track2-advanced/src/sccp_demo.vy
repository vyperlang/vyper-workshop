# @version ^0.4.0
"""
@notice Demonstrates SCCP (Sparse Conditional Constant Propagation)
@dev Shows how SCCP can resolve constants through control flow
"""

@external
@pure
def sccp_basic(x: uint256) -> uint256:
    """
    @notice SCCP propagates constants through branches
    @param x Runtime value - prevents full compile-time evaluation
    """
    # These are compile-time constants
    a: uint256 = 10
    b: uint256 = 0
    
    # SCCP can propagate 'a' through both branches
    if x > 5:
        b = a * 2  # SCCP knows a=10, so b=20
    else:
        b = a + 5  # SCCP knows a=10, so b=15
    
    # At this point, SCCP knows b is either 20 or 15
    # but can't resolve further without knowing x
    return b

@external
@pure
def sccp_full_resolution() -> uint256:
    """
    @notice This entire function can be resolved by SCCP at compile time
    @dev No runtime computation needed
    """
    x: uint256 = 7
    y: uint256 = 3
    
    # SCCP knows x=7, so this condition is True
    if x > 5:
        y = y * 2  # y = 6
    else:
        y = y + 10  # Dead code - eliminated
    
    # SCCP knows y=6
    if y < 10:
        return y + x  # Returns 13
    else:
        return 0  # Dead code - eliminated

@external
@pure
def sccp_complex_propagation() -> uint256:
    """
    @notice Shows SCCP propagating through multiple branches and operations
    """
    a: uint256 = 5
    b: uint256 = 10
    c: uint256 = 0
    
    # First branch - SCCP knows a=5, b=10
    if a < b:  # Always true
        c = a + b  # c = 15
    else:
        c = 100  # Dead code
    
    # Second branch - SCCP knows c=15
    if c == 15:  # Always true
        c = c * 2  # c = 30
    else:
        c = 0  # Dead code
    
    # Final computation - SCCP knows c=30
    return c + a  # Returns 35

@external
@pure
def sccp_vs_simple_folding(x: uint256) -> uint256:
    """
    @notice Demonstrates what SCCP can do that simple constant folding cannot
    @dev SCCP handles control flow, not just arithmetic
    """
    result: uint256 = 0
    flag: bool = True
    
    # Simple constant folding would handle this
    base: uint256 = 10 + 20  # -> 30
    
    # But SCCP is needed for this pattern
    if x > 100:
        flag = False
        result = base * 2  # SCCP knows base=30, so result=60
    
    # SCCP tracks that flag is True if x<=100, False if x>100
    if flag:
        result = base + 5  # SCCP knows base=30, so result=35
    else:
        result = result + 1  # result=61 when x>100
    
    return result