#!/usr/bin/env python3
"""
Script to show Venom IR optimizations by comparing optimized vs unoptimized output
"""

import subprocess
import sys
import os
from pathlib import Path

def run_vyper(contract_path: str, args: list[str]) -> str:
    """Run vyper compiler with given arguments"""
    cmd = ["vyper"] + args + [contract_path]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running vyper: {e}")
        print(f"stderr: {e.stderr}")
        sys.exit(1)

def compare_venom_ir(contract_path: str):
    """Generate and compare optimized vs unoptimized Venom IR"""
    print(f"\n{'='*60}")
    print(f"Analyzing: {Path(contract_path).name}")
    print(f"{'='*60}\n")
    
    # Generate unoptimized Venom IR
    print("1. Generating UNOPTIMIZED Venom IR...")
    unoptimized = run_vyper(contract_path, ["--no-optimize", "-f", "bb_runtime"])
    
    # Generate optimized Venom IR
    print("2. Generating OPTIMIZED Venom IR...")
    optimized = run_vyper(contract_path, ["-f", "bb_runtime"])
    
    # Show the difference
    print("\n--- UNOPTIMIZED VENOM IR ---")
    print(unoptimized[:1000] + "..." if len(unoptimized) > 1000 else unoptimized)
    
    print("\n--- OPTIMIZED VENOM IR ---")
    print(optimized[:1000] + "..." if len(optimized) > 1000 else optimized)
    
    # Save full outputs
    output_dir = Path("venom_output")
    output_dir.mkdir(exist_ok=True)
    
    base_name = Path(contract_path).stem
    with open(output_dir / f"{base_name}_unoptimized.venom", "w") as f:
        f.write(unoptimized)
    with open(output_dir / f"{base_name}_optimized.venom", "w") as f:
        f.write(optimized)
    
    print(f"\nFull output saved to venom_output/{base_name}_*.venom")
    
    # Basic statistics
    unopt_lines = len(unoptimized.splitlines())
    opt_lines = len(optimized.splitlines())
    reduction = ((unopt_lines - opt_lines) / unopt_lines) * 100 if unopt_lines > 0 else 0
    
    print(f"\nOptimization Statistics:")
    print(f"  Unoptimized: {unopt_lines} lines")
    print(f"  Optimized:   {opt_lines} lines")
    print(f"  Reduction:   {reduction:.1f}%")

def main():
    """Main entry point"""
    contracts = [
        "track2-advanced/src/algebraic_demo.vy",
        "track2-advanced/src/storage_demo.vy",
        "track2-advanced/src/sccp_demo.vy",
        "track2-advanced/src/sccp_simultaneous_demo.vy",
        "track2-advanced/src/branch_demo.vy",
        "track2-advanced/src/comparison_demo.vy",
    ]
    
    print("Vyper Venom IR Optimization Comparison Tool")
    print("==========================================")
    
    for contract in contracts:
        if os.path.exists(contract):
            compare_venom_ir(contract)
        else:
            print(f"Warning: {contract} not found, skipping...")
    
    print("\n✅ Analysis complete! Check venom_output/ for full IR code.")
    print("\nKey things to look for:")
    print("  - Constant folding (literal values computed at compile time)")
    print("  - Dead code elimination (unreachable blocks removed)")
    print("  - Strength reduction (mul/div by powers of 2 → shifts)")
    print("  - Comparison optimizations (iszero chains)")
    print("  - SCCP results (complex constant propagation)")

if __name__ == "__main__":
    main()