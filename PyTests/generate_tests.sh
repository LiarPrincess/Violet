#!/bin/bash

PYTESTS=./PyTests
VIOLET=$PYTESTS/Violet
OUTPUT=$VIOLET/overridden_static_methods.py

echo "- $OUTPUT - override '__add__' and check if it works"
python3 "$VIOLET/generate_overridden_static_methods_test" > "$OUTPUT"
