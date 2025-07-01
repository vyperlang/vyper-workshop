# @version ^0.4.0
"""
@notice Unoptimized counter with redundant storage operations
"""

count: public(uint256)

@external
def increment():
    """
    @notice Increment counter three times (inefficiently)
    """
    # Each line causes a separate SLOAD and SSTORE
    self.count = self.count + 1
    self.count = self.count + 1
    self.count = self.count + 1

@external
def increment_by(amount: uint256):
    """
    @notice Add amount to counter (with redundant operations)
    """
    temp: uint256 = self.count
    temp = temp + amount
    self.count = temp
    # Redundant load and store
    if self.count > 0:
        self.count = self.count