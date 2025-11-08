# LLVM-Passes: Loop optimization passes in LLVM (LICM and Derived Induction variable Elimination)

This repository contains the implementation of two LLVM compiler passes for the Advanced Compilers course:

1. Simple LICM (Loop Invariant Code Motion) pass that uses a worklist to detect register-to-register loop invariant instructions.

2. Derived Induction Variable Elimination (IVE) pass that identifies and eliminates induction variables in nested loops. 

All code is built on the [llvm-tutor](https://github.com/banach-space/llvm-tutor) infrastructure.



## Build Instructions

1. Clean and build from the project Root 

   rm -rf build
   mkdir build
   cd build

   cmake
   make 


## Output Files

SimpleLICM.dylib and DerivedInductionVar.dylib libraries appear in llvm-tutor/build/lib/


## Testing
1. cd build 
mkdir -p outputs

2. Test LICM 
opt -load-pass-plugin ./lib/libSimpleLICM.dylib \
    -passes=simple-licm \
    -S -o outputs/licm_basic_optimized.ll inputs/licm_basic.ll


3. Test Derived Induction Variable Analysis and Elimination 
opt -load-pass-plugin ./lib/libDerivedInductionVar.dylib \
    -passes=derived-iv \
    -S -o outputs/div_nested_after.ll inputs/div_nested.ll



4. Test Derived Induction Variable Analysis Detection
opt -load-pass-plugin ./lib/libDerivedInductionVar.dylib \
    -passes=derived-iv \
    -S -o outputs/div_simple_after.ll inputs/div_simple.ll