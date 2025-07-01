# @version ^0.4.0
# Simple example to generate interesting Venom IR

counter: uint256

@external
def add_three():
    self.counter = self.counter + 1
    self.counter = self.counter + 1  
    self.counter = self.counter + 1