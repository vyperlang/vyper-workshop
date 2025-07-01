# @version ^0.4.0
"""
@notice Demonstrates comparison optimization in Venom IR
@dev Shows how comparisons are transformed for efficiency
"""

@external
@pure
def comparison_transformations(x: uint256) -> uint256:
    """
    @notice Shows basic comparison transformations
    @dev Each comparison may be optimized differently
    """
    result: uint256 = 0
    
    # x > 0 optimization
    # May become: iszero(iszero(x))
    if x > 0:
        result = result + 1
    
    # x == 0 optimization  
    # Becomes: iszero(x)
    if x == 0:
        result = result + 2
        
    # x >= 1 optimization
    # Since uint256, this is equivalent to x > 0
    # May become: iszero(iszero(x))
    if x >= 1:
        result = result + 4
        
    # x < 1 optimization
    # For uint256, equivalent to x == 0
    # Becomes: iszero(x)
    if x < 1:
        result = result + 8
        
    return result

@external
@pure
def comparison_with_constants(x: uint256) -> uint256:
    """
    @notice Comparisons with constants show interesting optimizations
    @dev Boundary values get special treatment
    """
    result: uint256 = 0
    
    # Comparisons with MAX_UINT256
    if x == max_value(uint256):  # 2^256 - 1
        result = result + 1
    
    # This is always false for uint256
    if x > max_value(uint256):
        result = result + 1000  # Dead code
    
    # Special case: comparison with 1
    # x >= 1 can be optimized to x > 0
    if x >= 1:
        result = result + 2
        
    # Chained comparisons
    if 10 <= x and x <= 20:
        result = result + 4
        
    return result

@external
@pure
def comparison_strength_reduction(x: uint256, y: uint256) -> bool:
    """
    @notice Shows comparison strength reduction
    @dev Some comparisons can be simplified
    """
    # These comparisons might be transformed:
    
    # (x + 1) > y  might become  x >= y
    if (x + 1) > y:
        return True
        
    # x > (y - 1)  might become  x >= y  (if y > 0)
    if y > 0 and x > (y - 1):
        return True
        
    return False

@external
@pure
def chained_comparisons(x: uint256) -> uint256:
    """
    @notice Multiple comparisons on same value
    @dev SCCP and branch optimization work together
    """
    # First comparison
    if x > 100:
        # SCCP knows x > 100 in this branch
        if x > 50:  # Always true, may be eliminated
            return 1
        else:
            return 0  # Dead code
    elif x > 50:
        # SCCP knows 50 < x <= 100 in this branch
        if x > 200:  # Always false, may be eliminated  
            return 2  # Dead code
        else:
            return 3  # Always taken
    else:
        # SCCP knows x <= 50
        return 4

@external
@pure
def signed_comparison_example(x: int256) -> int256:
    """
    @notice Signed comparisons have different optimizations
    @dev Shows slt, sgt, sle, sge optimizations
    """
    result: int256 = 0
    
    # Signed comparison with 0
    if x > 0:
        result = result + 1
    
    # Signed comparison with -1
    # x >= 0 might be optimized differently than x > -1
    if x >= 0:
        result = result + 2
        
    # Boundary case for signed
    if x == min_value(int256):  # -2^255
        result = result + 4
        
    return result