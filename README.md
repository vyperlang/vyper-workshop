# Vyper Workshop: From Smart Contracts to Venom Optimization

Welcome to the Vyper workshop! This workshop features two tracks to accommodate different skill levels and interests.

> **⚠️ IMPORTANT**: All code in this workshop is for **DEMO PURPOSES ONLY**. The examples may not compile, may contain bugs, and are NOT production-ready. They are designed to illustrate concepts and should not be used in real applications without thorough review and testing.

## Prerequisites

### Required Tools
- Python 3.10 or higher
- UV (Python package manager) - Install with: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Anvil (local Ethereum node) - Part of Foundry toolkit

### Quick Setup

1. Install UV if you haven't already:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

2. Install Moccasin (Vyper development framework):
```bash
uv tool install moccasin
```

3. Install Foundry (for Anvil):
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

## Workshop Structure

### Track 1: Basic - Deploy a Token with Snekmate =

**Goal**: Learn Vyper basics by deploying an ERC20 token using the battle-tested Snekmate library.

**What you'll learn**:
- Vyper contract structure and syntax
- Using Snekmate modules for production-ready contracts
- Deploying contracts with Moccasin
- Interacting with deployed contracts

**Time**: 45-60 minutes

### Track 2: Advanced - Venom IR Optimization =%

**Goal**: Dive deep into Vyper's intermediate representation (Venom) and optimize gas usage at the IR level.

**What you'll learn**:
- Understanding Venom IR structure
- Identifying optimization opportunities
- Comparing manual optimizations with compiler optimizations
- Benchmarking gas improvements

**Time**: 90-120 minutes

## Getting Started

### Initial Setup

Clone this repository:
```bash
git clone <repo-url>
cd vyper-workshop
```

### Choose Your Track

#### Track 1: Basic Token Deployment

Navigate to the basic track:
```bash
cd track1-basic
```

Follow the instructions in `track1-basic/README.md`

#### Track 2: Venom Optimization

Navigate to the advanced track:
```bash
cd track2-advanced
```

Follow the instructions in `track2-advanced/README.md`

## Project Structure

```
vyper-workshop/
├── README.md                    # This file
├── track1-basic/               # Basic track: Token deployment
│   ├── README.md
│   ├── moccasin.toml          # Moccasin configuration for track 1
│   ├── src/
│   │   └── MyToken.vy
│   ├── script/
│   │   └── deploy_token.py
│   └── tests/
│       └── test_token.py
└── track2-advanced/            # Advanced track: Venom optimization
    ├── README.md
    ├── src/
    │   ├── algebraic_demo.vy
    │   ├── branch_demo.vy
    │   ├── comparison_demo.vy
    │   ├── sccp_demo.vy
    │   ├── sccp_complex_demo.vy
    │   ├── sccp_simultaneous_demo.vy
    │   ├── storage_demo.vy
    │   └── unoptimized/
    │       ├── counter.vy
    │       └── simple_example.vy
    ├── scripts/
    │   └── show_optimizations.py
    └── venom_examples/
        ├── sccp_complex.venom
        └── sccp_simultaneous.venom
```

## Helpful Resources

- [Vyper Documentation](https://docs.vyperlang.org/)
- [Snekmate Repository](https://github.com/pcaversaccio/snekmate)
- [Moccasin Documentation](https://cyfrin.github.io/moccasin/)
- [Venom IR Documentation](https://docs.vyperlang.org/en/latest/compiler-exceptions.html)

## Troubleshooting

### Common Issues

1. **UV not found**: Make sure to restart your terminal after installing UV
2. **Moccasin commands not working**: Try `uv tool install --force moccasin`
3. **Import errors**: Ensure you're running commands with `uv run` prefix

### Getting Help

- Check the track-specific README files for detailed instructions
- Ask workshop facilitators for assistance
- Join the Vyper Discord for community support

## After the Workshop

- Star the [Snekmate repo](https://github.com/pcaversaccio/snekmate) if you found it useful
- Contribute to Vyper ecosystem projects
- Share your learnings with the community

Happy coding! =