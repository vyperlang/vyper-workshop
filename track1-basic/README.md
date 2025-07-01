# Track 1: Basic - Deploy a Token with Snekmate

> **⚠️ DEMO CODE WARNING**: All code in this track is for **DEMONSTRATION PURPOSES ONLY**. Examples may not compile, may contain bugs, and should NOT be used in production without thorough review, testing, and auditing.

In this track, you'll learn how to create and deploy an ERC20 token using the production-ready Snekmate library.

## Overview

Snekmate provides battle-tested, gas-optimized implementations of common smart contract patterns. We'll use its ERC20 module to create our own token.

## Steps

### 1. Install Dependencies

First, install the snekmate dependency:

```bash
cd /path/to/track1-basic
mox install
```

### 2. Create Your Token Contract

We'll create a simple token that uses Snekmate's ERC20 implementation. The token will have:
- A fixed supply of 1,000,000 tokens
- 18 decimal places (standard for ERC20)
- Minting capability for the owner

Check out `src/MyToken.vy` to see the implementation.

### 3. Deploy Your Token

Start a local Anvil node in a separate terminal:

```bash
anvil
```

Then deploy your token:

```bash
mox run deploy_token --network anvil --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### 4. Interact with Your Token

After deployment, you can interact with your token using the moccasin console:

```bash
mox console --network anvil
```

In the console:
```python
# Load your deployed contract
from boa.contracts.abi.abi_contract import ABIContractFactory
import json

# Load the ABI from the output
with open('out/MyToken.json') as f:
    contract_data = json.load(f)

# Get the deployed address from your deployment output
token_address = "0x..." # Replace with your deployed address

# Create contract instance
token = ABIContractFactory(
    name="MyToken",
    abi=contract_data['abi'],
    bytecode=contract_data['bytecode']['bytecode']
).at(token_address)

# Check token details
print(f"Name: {token.name()}")
print(f"Symbol: {token.symbol()}")
print(f"Total Supply: {token.totalSupply() / 10**18}")

# Check your balance
my_address = "0x..." # Your address
balance = token.balanceOf(my_address)
print(f"Your balance: {balance / 10**18} tokens")
```

### 5. Run Tests

Test your token implementation:

```bash
mox test tests/test_token.py -v
```

## Key Learning Points

1. **Vyper Modules**: Snekmate contracts are modules that you import and initialize
2. **ERC20 Standard**: Understanding the standard token interface
3. **Deployment Process**: How to deploy contracts using Moccasin
4. **Testing**: Writing tests for your smart contracts

## Exercises

1. **Understand Module Exports**: The ERC20 module already includes mint and burn functions. Explore how they work
2. **Access Control**: Add custom admin functions that don't conflict with the ERC20 exports
3. **Create a Faucet**: Create a separate contract that distributes tokens to users

## Next Steps

Once you're comfortable with basic token deployment, consider:
- Exploring other Snekmate modules (ERC721, ERC4626, etc.)
- Learning about access control patterns
- Moving to Track 2 for advanced Venom optimization