#!/bin/bash

# This file is used when you type 'make gen' in repository root.

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated2

# echo "=== Sourcery ==="
# echo "Generate a giant file wile with of all of the types/methods."
# echo "It will be used as a 'single source of truth' for later stages."
# echo "- Sourcery/dump.txt"
sourcery \
  --sources "$OBJECTS" \
  --templates "$GENERATED/Sourcery/dump.stencil" \
  --output "$GENERATED/Sourcery/dump.txt" \
  --quiet
# echo

python3 "$GENERATED/PyMemory+Types.py" > "$GENERATED/PyMemory+Types.swift"
