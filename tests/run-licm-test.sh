#!/bin/bash

# Paths
PASS_LIB=../lib/libSimpleLICM.dylib
INPUT_DIR=.
OUTPUT_DIR=./outputs

mkdir -p $OUTPUT_DIR

for file in $INPUT_DIR/*.ll; do
    filename=$(basename "$file")
    output="$OUTPUT_DIR/$filename"
    echo "Running LICM on $filename..."
    opt -load-pass-plugin $PASS_LIB -passes=simple-licm -S $file -o $output
done

echo "All tests completed. "
