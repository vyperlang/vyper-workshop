#!/usr/bin/env python3
"""
Deploy MyToken to the specified network
"""

from src import MyToken
import os
import json


def deploy():
    """Deploy the MyToken contract"""
    print("🚀 Deploying MyToken...")
    
    # Deploy the contract
    token = MyToken.deploy()
    
    print(f"✅ MyToken deployed at: {token.address}")
    print(f"   Name: {token.name()}")
    print(f"   Symbol: {token.symbol()}")
    print(f"   Decimals: {token.decimals()}")
    print(f"   Total Supply: {token.totalSupply() / 10**18:,.0f} {token.symbol()}")
    
   
    return token


def moccasin_main():
    """Entry point for moccasin"""
    return deploy()


if __name__ == "__main__":
    deploy()
