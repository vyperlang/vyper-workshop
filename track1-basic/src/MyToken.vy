# @version ^0.4.0
"""
@title MyToken - Workshop ERC20 Token
@author Vyper Workshop
@notice A simple ERC20 token using Snekmate's battle-tested implementation
"""

from ethereum.ercs import IERC20
from snekmate.tokens import erc20
from snekmate.auth import ownable

# We initialize the modules we're using
initializes: ownable
initializes: erc20[ownable := ownable]

# Re-export the ERC20 interface functions
exports: erc20.IERC20

# Token configuration
name: public(constant(String[25])) = "Workshop Token"
symbol: public(constant(String[5])) = "WSHOP"
decimals: public(constant(uint8)) = 18
_INITIAL_SUPPLY: constant(uint256) = 1_000_000 * 10**18  # 1 million tokens


@deploy
def __init__():
    """
    @notice Deploy the token with initial supply to deployer
    @dev Initializes ERC20 and Ownable modules
    """
    # Initialize ownable - sets deployer as owner
    ownable.__init__()

    # Initialize the ERC20 module with our token details
    erc20.__init__(name, symbol, decimals, name, "1.0.0")

    # Mint initial supply to the deployer
    erc20._mint(msg.sender, _INITIAL_SUPPLY)


@external
def mint(to: address, amount: uint256):
    """
    @notice Mint new tokens (owner only)
    @param to Address to mint tokens to
    @param amount Amount of tokens to mint
    """
    ownable._check_owner()
    erc20._mint(to, amount)


@external
def burn(amount: uint256):
    """
    @notice Burn tokens from caller's balance
    @param amount Amount of tokens to burn
    """
    erc20._burn(msg.sender, amount)
