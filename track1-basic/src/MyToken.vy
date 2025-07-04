# @version ^0.4.0
"""
@title MyToken - Workshop ERC20 Token
@author Vyper Workshop
@notice A simple ERC20 token using Snekmate's battle-tested implementation
"""

from ethereum.ercs import IERC20
from ethereum.ercs import IERC20Detailed

from snekmate.tokens import erc20
from snekmate.auth import ownable

implements: IERC20
implements: IERC20Detailed

# We initialize the modules we're using
initializes: ownable
initializes: erc20[ownable := ownable]

# Re-export the ERC20 interface functions
exports: erc20.__interface__

# Token configuration
NAME: constant(String[25]) = "Workshop Token"
SYMBOL: constant(String[5]) = "WSHOP"
DECIMALS: constant(uint8) = 18
INITIAL_SUPPLY: constant(uint256) = 1_000_000 * 10**18  # 1 million tokens


@deploy
def __init__():
    """
    @notice Deploy the token with initial supply to deployer
    @dev Initializes ERC20 and Ownable modules
    """
    # Initialize ownable - sets deployer as owner
    ownable.__init__()

    # Initialize the ERC20 module with our token details
    erc20.__init__(NAME, SYMBOL, DECIMALS, NAME, "1.0.0")

    # Mint initial supply to the deployer
    erc20._mint(msg.sender, INITIAL_SUPPLY)