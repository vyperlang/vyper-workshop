# @version ^0.4.0
"""
@notice Demonstrates algebraic optimizations in Venom IR
@dev Shows constant folding, strength reduction, and identity operations
"""

@external
@pure
def demo(x: uint256) -> uint256:
    """
    @notice Show various algebraic optimizations
    @param x Input value to demonstrate non-constant optimizations
    """
    # Constant folding: 5 + 3 will be computed at compile time
    a: uint256 = 5 + 3      # -> 8
    
    # Strength reduction: multiplication by power of 2
    b: uint256 = x * 16     # -> x << 4 (shift left by 4)
    
    # Identity operations
    c: uint256 = x + 0      # -> x (adding zero)
    d: uint256 = x - x      # -> 0 (self subtraction)
    
    # Modulo by power of 2
    e: uint256 = x % 8      # -> x & 7 (bitwise AND)
    
    # Division by power of 2
    f: uint256 = x // 32    # -> x >> 5 (shift right by 5)
    
    return a + b + c + d + e + f

@external
@pure 
def constant_expressions() -> uint256:
    """
    @notice All operations here can be evaluated at compile time
    """
    # Complex constant expression
    result: uint256 = (100 + 50) * 2 - 40  # -> 260
    
    # More complex constant folding
    if 10 > 5:  # Always true, dead code elimination
        result = result + 100  # -> 360
    else:
        result = 0  # This branch is eliminated
    
    return result

@external
@pure
def algebraic_identities(x: uint256, y: uint256) -> uint256:
    """
    @notice Demonstrates various algebraic identity optimizations
    """
    # Multiplication identities
    a: uint256 = x * 1      # -> x
    b: uint256 = x * 0      # -> 0
    
    # XOR identities  
    c: uint256 = x ^ 0      # -> x
    d: uint256 = x ^ x      # -> 0
    
    # AND/OR identities
    e: uint256 = x & 0      # -> 0
    f: uint256 = x | 0      # -> x
    
    # Subtraction creating NOT
#g: uint256 = (2**256 - 1) - x  # -> ~x (bitwise NOT)
    
    return a + b + c + d + e + f
