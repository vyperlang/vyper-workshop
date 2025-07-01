#!/usr/bin/env python3
"""
Deploy MyToken to the specified network
"""

from boa.contracts.abi.abi_contract import ABIContractFactory
from moccasin.boa_tools import VyperContract
import os
import json


def deploy():
    """Deploy the MyToken contract"""
    print("🚀 Deploying MyToken...")
    
    # Deploy the contract
    token = VyperContract("track1-basic/src/MyToken.vy")
    
    print(f"✅ MyToken deployed at: {token.address}")
    print(f"   Name: {token.name()}")
    print(f"   Symbol: {token.symbol()}")
    print(f"   Decimals: {token.decimals()}")
    print(f"   Total Supply: {token.totalSupply() / 10**18:,.0f} {token.symbol()}")
    
    # Save deployment info
    deployment_info = {
        "address": token.address,
        "name": token.name(),
        "symbol": token.symbol(),
        "decimals": token.decimals(),
        "totalSupply": str(token.totalSupply())
    }
    
    # Create deployments directory if it doesn't exist
    os.makedirs("track1-basic/deployments", exist_ok=True)
    
    # Save deployment info
    with open("track1-basic/deployments/MyToken.json", "w") as f:
        json.dump(deployment_info, f, indent=2)
    
    print(f"\n💾 Deployment info saved to track1-basic/deployments/MyToken.json")
    
    return token


def moccasin_main():
    """Entry point for moccasin"""
    return deploy()


if __name__ == "__main__":
    deploy()