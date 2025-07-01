# Track 2: Advanced - Understanding Vyper's Venom IR Optimizations

> **⚠️ DEMO CODE WARNING**: All code in this track is for **DEMONSTRATION PURPOSES ONLY**. Examples may not compile, may contain bugs, and should NOT be used in production. The Venom IR examples are particularly experimental and may not represent actual compiler output.

This track explores how Vyper's compiler optimizes code at the Venom IR level, demonstrating what optimizations are performed and why they matter.

## Prerequisites

- Solid understanding of Vyper and EVM
- Interest in compiler optimizations
- Basic understanding of intermediate representations

## Overview

We'll explore Vyper's optimization passes by:
1. Writing contracts that showcase specific optimizations
2. Comparing unoptimized vs optimized Venom IR
3. Understanding how these optimizations reduce gas costs
4. Learning what the compiler can and cannot optimize

## Tools

Vyper provides two key tools:
- `vyper -f bb_runtime contract.vy` - Generate Venom IR from Vyper
- `vyper/cli/venom_main.py` - Compile Venom IR to bytecode

## Key Optimizations Demonstrated

### 1. Algebraic Optimizations
- **Constant Folding**: `5 + 3` → `8`
- **Strength Reduction**: `x * 16` → `x << 4`
- **Identity Operations**: `x + 0` → `x`
- **Modulo Optimization**: `x % 8` → `x & 7`

### 2. SCCP (Sparse Conditional Constant Propagation)
- Propagates constants through control flow
- Resolves branches when conditions are compile-time constant
- More powerful than simple constant folding
- Can optimize complex patterns like the "simultaneous condition" example

### 3. Storage Optimization
- Eliminates redundant SLOAD operations
- Reuses loaded values across basic blocks

### 4. Branch Optimization
- Optimizes iszero chains
- Flips branches based on liveness analysis
- Removes dead code

### 5. Comparison Optimization
- Transforms comparisons for efficiency
- `x > 0` → `iszero(iszero(x))`
- `x == 0` → `iszero(x)`

## Quick Start

### 1. Run the Optimization Comparison Script

```bash
cd /home/charles/vyper-workshop
python track2-advanced/scripts/show_optimizations.py
```

This will:
- Generate both optimized and unoptimized Venom IR
- Show side-by-side comparisons
- Save full output to `venom_output/` directory

### 2. Examine Specific Examples

Look at the example contracts in `src/`:
- `algebraic_demo.vy` - Basic arithmetic optimizations
- `sccp_demo.vy` - Constant propagation through control flow
- `sccp_simultaneous_demo.vy` - Complex SCCP pattern (like the I=J example)
- `storage_demo.vy` - Storage access optimization
- `branch_demo.vy` - Branch and iszero optimizations
- `comparison_demo.vy` - Comparison transformations

### 3. Understanding the Output

When examining Venom IR, look for:
- Missing basic blocks (dead code elimination)
- Literal values instead of computations
- Fewer instructions overall
- Changed operation types (mul → shl)

## Manual Venom IR Optimization

While the focus is on understanding what the compiler does, you can also experiment with manual optimization:

### Working with Raw Venom

1. Generate Venom IR:
```bash
vyper -f bb_runtime contract.vy > contract.venom
```

2. Edit the Venom IR manually

3. Compile your modified Venom:
```bash
python vyper/cli/venom_main.py contract.venom
```

### Example: Manual SCCP

The `venom_examples/` directory contains:
- `sccp_complex.venom` - Shows a complex pattern before optimization
- `sccp_simultaneous.venom` - The I=J pattern in raw Venom

## Deep Dive Topics

### SCCP Power

SCCP is particularly powerful because it:
- Tracks values through control flow graphs
- Resolves conditions based on propagated constants
- Eliminates entire branches when conditions are known
- Works in one pass (linear time) vs iterative constant folding

### Why These Optimizations Matter

Gas costs breakdown:
- SLOAD: 2100 gas (cold) / 100 gas (warm)
- SSTORE: 20000 gas (cold) / 2900 gas (warm)
- Arithmetic: 3-5 gas
- Comparisons: 3 gas

Even small optimizations add up!

## Resources

- Vyper optimization passes: `vyper/venom/passes/`
- EVM opcode reference: https://www.evm.codes/
- Venom IR source: `vyper/venom/`

## Next Steps

1. Study the actual optimization pass implementations
2. Try modifying the compiler to add new optimizations
3. Build analysis tools for Venom IR
4. Contribute optimizations back to Vyper