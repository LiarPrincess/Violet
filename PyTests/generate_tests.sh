#!/bin/bash

echo "=== PyTests ==="

PYTESTS=./PyTests
VIOLET=$PYTESTS/Violet

echo "- overridden_static_methods.py - overridde '__add__' and check if it works"
python3 "$VIOLET/generate_overridden_static_methods_test" > "$VIOLET/overridden_static_methods.py"
