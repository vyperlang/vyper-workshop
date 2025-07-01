"""
Tests for MyToken contract
"""

import pytest
from src import MyToken
import boa


def test_token_deployment(owner, alice):
    """Test basic token deployment"""
    # Deploy token
    token = MyToken.deploy()
    
    # Check token metadata
    assert token.name() == "Workshop Token"
    assert token.symbol() == "WSHOP"
    assert token.decimals() == 18
    
    # Check initial supply went to deployer
    expected_supply = 1_000_000 * 10**18
    assert token.totalSupply() == expected_supply
    assert token.balanceOf(owner) == expected_supply
    assert token.balanceOf(alice) == 0


def test_transfer(owner, alice, bob):
    """Test token transfers"""
    token = MyToken.deploy()
    
    # Transfer tokens from owner to alice
    transfer_amount = 1000 * 10**18
    
    # Record balances before
    owner_balance_before = token.balanceOf(owner)
    
    # Execute transfer
    tx = token.transfer(alice, transfer_amount, sender=owner)
    
    # Check balances after
    assert token.balanceOf(owner) == owner_balance_before - transfer_amount
    assert token.balanceOf(alice) == transfer_amount
    
    # Test alice transferring to bob
    alice_transfer = 100 * 10**18
    token.transfer(bob, alice_transfer, sender=alice)
    
    assert token.balanceOf(alice) == transfer_amount - alice_transfer
    assert token.balanceOf(bob) == alice_transfer


def test_approve_and_transfer_from(owner, alice, bob):
    """Test approval and transferFrom mechanism"""
    token = MyToken.deploy()
    
    # Owner approves alice to spend tokens
    approval_amount = 500 * 10**18
    token.approve(alice, approval_amount, sender=owner)
    
    # Check allowance
    assert token.allowance(owner, alice) == approval_amount
    
    # Alice transfers tokens from owner to bob
    transfer_amount = 200 * 10**18
    owner_balance_before = token.balanceOf(owner)
    
    token.transferFrom(owner, bob, transfer_amount, sender=alice)
    
    # Check balances
    assert token.balanceOf(owner) == owner_balance_before - transfer_amount
    assert token.balanceOf(bob) == transfer_amount
    
    # Check remaining allowance
    assert token.allowance(owner, alice) == approval_amount - transfer_amount


def test_mint_as_owner(owner, alice):
    """Test minting new tokens (owner only)"""
    token = MyToken.deploy()
    
    # Get initial supply
    initial_supply = token.totalSupply()
    
    # Mint new tokens to alice
    mint_amount = 10_000 * 10**18
    token.mint(alice, mint_amount, sender=owner)
    
    # Check new balances
    assert token.balanceOf(alice) == mint_amount
    assert token.totalSupply() == initial_supply + mint_amount


def test_mint_as_non_owner_fails(owner, alice):
    """Test that non-owners cannot mint"""
    token = MyToken.deploy()
    
    # Alice tries to mint (should fail)
    with boa.reverts("erc20: access is denied"):
        token.mint(alice, 1000 * 10**18, sender=alice)


def test_burn(owner, alice):
    """Test burning tokens"""
    token = MyToken.deploy()
    
    # Transfer some tokens to alice first
    transfer_amount = 1000 * 10**18
    token.transfer(alice, transfer_amount, sender=owner)
    
    # Alice burns some tokens
    burn_amount = 300 * 10**18
    initial_supply = token.totalSupply()
    
    token.burn(burn_amount, sender=alice)
    
    # Check balances
    assert token.balanceOf(alice) == transfer_amount - burn_amount
    assert token.totalSupply() == initial_supply - burn_amount


def test_cannot_burn_more_than_balance(alice):
    """Test that users cannot burn more than they have"""
    token = MyToken.deploy()
    
    # Alice has no tokens, tries to burn
    with boa.reverts():
        token.burn(100 * 10**18, sender=alice)


# Fixtures
@pytest.fixture
def owner():
    """Get the default account (deployer)"""
    return boa.env.eoa


@pytest.fixture 
def alice():
    """Get a test account"""
    return boa.env.generate_address("alice")


@pytest.fixture
def bob():
    """Get another test account"""
    return boa.env.generate_address("bob")