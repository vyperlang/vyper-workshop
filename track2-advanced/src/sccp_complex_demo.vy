# @version ^0.4.0
"""
@notice Complex SCCP example that's hard to optimize by hand
@dev Shows interprocedural constant propagation and complex control flow
"""

@internal
@pure
def helper_a(x: uint256) -> uint256:
    """Helper function that SCCP can partially evaluate"""
    if x < 50:
        return x * 2
    else:
        return x + 100

@internal
@pure
def helper_b(x: uint256, y: uint256) -> uint256:
    """Another helper with multiple parameters"""
    if x > y:
        return x - y
    else:
        return y - x

@external
@pure
def sccp_interprocedural() -> uint256:
    """
    @notice SCCP can trace constants through function calls
    @dev This creates complex control flow that's hard to optimize manually
    """
    # Constants that will be propagated
    a: uint256 = 25
    b: uint256 = 75
    c: uint256 = 0
    
    # SCCP knows a=25, so helper_a returns 50
    result1: uint256 = self.helper_a(a)  # -> 50
    
    # SCCP knows b=75, so helper_a returns 175
    result2: uint256 = self.helper_a(b)  # -> 175
    
    # SCCP knows result1=50, result2=175
    # So helper_b returns 125
    c = self.helper_b(result1, result2)  # -> 125
    
    # Complex conditional based on computed values
    if c > 100:  # SCCP knows c=125, so always true
        # SCCP can evaluate this entire expression
        return (c * 2) + (result1 // 5) - result2  # (250) + (10) - 175 = 85
    else:
        # Dead code that SCCP eliminates
        return 0

@external
@pure
def sccp_loop_unrolling_simulation() -> uint256:
    """
    @notice Simulates what SCCP can do with bounded loops
    @dev Creates many intermediate values that SCCP tracks
    """
    # Initial values
    accumulator: uint256 = 0
    multiplier: uint256 = 1
    
    # Iteration 1 (simulated unrolled loop)
    if multiplier == 1:  # SCCP knows this is true
        accumulator = accumulator + (multiplier * 10)  # 0 + 10 = 10
        multiplier = multiplier * 2  # 2
    
    # Iteration 2
    if multiplier == 2:  # SCCP knows this is true
        accumulator = accumulator + (multiplier * 10)  # 10 + 20 = 30
        multiplier = multiplier * 2  # 4
    
    # Iteration 3
    if multiplier == 4:  # SCCP knows this is true
        accumulator = accumulator + (multiplier * 10)  # 30 + 40 = 70
        multiplier = multiplier * 2  # 8
    
    # Complex final computation
    if accumulator > 50 and multiplier < 10:  # SCCP: 70 > 50 and 8 < 10 = true
        # More complex arithmetic that SCCP evaluates
        temp: uint256 = accumulator // multiplier  # 70 // 8 = 8
        return (accumulator * 2) + (temp * 5)  # 140 + 40 = 180
    else:
        return accumulator  # Dead code

@external
@pure
def sccp_diamond_pattern() -> uint256:
    """
    @notice Creates a diamond control flow pattern
    @dev SCCP must track values through multiple converging paths
    """
    # Starting values
    x: uint256 = 42
    y: uint256 = 0
    z: uint256 = 0
    
    # First split
    if x > 40:  # SCCP: always true
        y = x * 2  # y = 84
        if x < 50:  # SCCP: always true
            z = y + 10  # z = 94
        else:
            z = y - 10  # Dead code
    else:
        y = x + 100  # Dead code
        z = y * 2    # Dead code
    
    # Convergence point - SCCP knows y=84, z=94
    result: uint256 = 0
    
    # Second split based on computed values
    if y + z > 150:  # SCCP: 84 + 94 = 178 > 150 = true
        if z - y > 0:  # SCCP: 94 - 84 = 10 > 0 = true
            result = (z - y) * (z + y)  # 10 * 178 = 1780
        else:
            result = 1000  # Dead code
    else:
        result = 500  # Dead code
    
    # Final convergence
    return result // 10  # 178