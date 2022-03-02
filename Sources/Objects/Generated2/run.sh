#!/bin/bash

# This file is used when you type 'make gen' in repository root.

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated2

sourcery \
  --sources "$OBJECTS" \
  --templates "$GENERATED/Sourcery/dump.stencil" \
  --output "$GENERATED/Sourcery/dump.txt" \
  --quiet

python3 "$GENERATED/Types+Memory.py" > "$GENERATED/Types+Memory.swift"
python3 "$GENERATED/PyStaticCall.py" > "$GENERATED/PyStaticCall.swift"
python3 "$GENERATED/Py+TypeDefinitions.py" > "$GENERATED/Py+TypeDefinitions.swift"
