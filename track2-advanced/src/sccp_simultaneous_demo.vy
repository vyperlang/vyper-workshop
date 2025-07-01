# @version ^0.4.0
"""
@notice Demonstrates simultaneous condition evaluation + constant propagation
@dev Shows a pattern where SCCP can optimize but simple constant folding cannot
"""

@internal
@pure
def f(x: uint256) -> uint256:
    """Simulates some computation"""
    # Returns some value based on x
    return x + 10

@external
@pure
def simultaneous_example(n: uint256) -> uint256:
    """
    @notice SCCP can determine the result even with complex control flow
    @param n Number of iterations (doesn't affect the result!)
    """
    i: uint256 = 1
    
    # Bounded loop for Vyper
    for counter: uint256 in range(10):
        if counter >= n:
            break
            
        j: uint256 = i          # J = I (captures old value)
        i = self.f(counter)     # I = f(...) (gets new value)
        
        # The key: this condition is always true
        # because j equals the old i, which starts at 1
        if j > 0:
            i = j    # Always executes, restoring i to previous value
    
    # SCCP can determine that i is always 1
    return i

@external
@pure
def variant_with_multiplication(n: uint256) -> uint256:
    """
    @notice Another variant showing SCCP's power
    @dev Even with multiplication, SCCP tracks the invariant
    """
    x: uint256 = 2
    y: uint256 = 3
    
    for k: uint256 in range(5):
        if k >= n:
            break
            
        # Save current values
        old_x: uint256 = x
        old_y: uint256 = y
        
        # Complex updates
        x = old_y * 2        # x becomes 6, 10, 14, 18, 22...
        y = old_x + 2        # y becomes 4, 8, 12, 16, 20...
        
        # But wait! This condition restores the pattern
        if old_x * old_y == 6:  # Only true in first iteration (2*3=6)
            x = 2
            y = 3
        
    # SCCP can determine x=2, y=3 throughout all iterations
    return x + y  # Always returns 5

@external
@pure
def deep_nesting_example() -> uint256:
    """
    @notice Shows SCCP working through deeply nested conditions
    @dev Multiple levels of interdependent conditions
    """
    a: uint256 = 10
    b: uint256 = 20
    c: uint256 = 0
    
    # First level
    if a < b:  # Always true (10 < 20)
        temp: uint256 = a
        a = b      # a = 20
        b = temp   # b = 10
        
        # Second level  
        if a > b:  # Always true (20 > 10)
            c = a - b  # c = 10
            
            # Third level
            if c == temp:  # Always true (10 == 10)
                # Restore original values
                a = temp    # a = 10
                b = a * 2   # b = 20
    
    # SCCP determines a=10, b=20, c=10
    return a + b + c  # Always returns 40