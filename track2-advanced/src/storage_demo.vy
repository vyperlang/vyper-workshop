# @version ^0.4.0
"""
@notice Demonstrates storage optimization in Venom IR
@dev Shows how redundant SLOAD operations are eliminated
"""

stored_value: public(uint256)
threshold: public(uint256)

@external
def redundant_loads() -> uint256:
    """
    @notice Multiple reads from same storage slot
    @dev Compiler will optimize to single SLOAD
    """
    # First SLOAD of self.stored_value
    if self.stored_value > 100:
        # Reuses the loaded value (no second SLOAD)
        return self.stored_value * 2
    elif self.stored_value > 50:
        # Still reuses the first SLOAD
        return self.stored_value + 10
    else:
        # Still reuses the first SLOAD
        return self.stored_value

@external
def complex_storage_access() -> uint256:
    """
    @notice More complex storage access pattern
    @dev Shows optimization across multiple uses
    """
    # Load once
    val: uint256 = self.stored_value
    threshold_val: uint256 = self.threshold
    
    result: uint256 = 0
    
    # Multiple uses of storage values
    if val > threshold_val:
        result = val - threshold_val
        # Even though we reference self.stored_value again,
        # compiler may optimize if it knows value hasn't changed
        result = result + self.stored_value
    else:
        result = threshold_val - val
        result = result + self.threshold
    
    return result

@external  
def interleaved_storage() -> uint256:
    """
    @notice Storage access with potential aliasing
    @dev Shows when optimization might not occur
    """
    total: uint256 = 0
    
    # First access to stored_value
    total = total + self.stored_value
    
    # Access to different storage slot
    total = total + self.threshold
    
    # Second access to stored_value - compiler must be careful
    # about optimizing this if there's any possibility of aliasing
    total = total + self.stored_value
    
    return total