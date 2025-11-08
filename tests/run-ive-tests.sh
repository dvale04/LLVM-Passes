#!/bin/bash

PASS_LIB=../lib/libDerivedInductionVar.dylib
INPUT_DIR=.
OUTPUT_DIR=./outputs

mkdir -p $OUTPUT_DIR


TESTS=("div_nested.ll" "div_simple.ll")

for test in "${TESTS[@]}"; do
    input_file="$INPUT_DIR/$test"
    output_file="$OUTPUT_DIR/${test%.ll}_after.ll"
    echo "Running IVE on $test..."
    opt -load-pass-plugin $PASS_LIB -passes=derived-iv -S -o $output_file $input_file
done

echo "IVE tests completed. Outputs are in $OUTPUT_DIR."
