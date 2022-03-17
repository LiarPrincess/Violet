#!/bin/bash

# This file is used when you type 'make gen' in repository root.

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated

# First call to gather information about hand-written exceptions
echo "Sourcery - exceptions by hand"
sourcery \
  --sources "$OBJECTS/Types - errors" \
  --templates "$GENERATED/Sourcery/exceptions-by-hand.stencil" \
  --output "$GENERATED/Sourcery/exceptions-by-hand.txt" \
  --quiet

echo "ExceptionSubclasses"
python3 "$GENERATED/ExceptionSubclasses.py" > "$GENERATED/ExceptionSubclasses.swift"

echo "Sourcery"
sourcery \
  --sources "$OBJECTS" \
  --templates "$GENERATED/Sourcery/dump.stencil" \
  --output "$GENERATED/Sourcery/dump.txt" \
  --quiet

echo "Py+Generated"
python3 "$GENERATED/Py+Generated.py" > "$GENERATED/Py+Generated.swift"
echo "Types+Generated"
python3 "$GENERATED/Types+Generated.py" > "$GENERATED/Types+Generated.swift"
echo "PyStaticCall"
python3 "$GENERATED/PyStaticCall.py" > "$GENERATED/PyStaticCall.swift"
echo "Py+TypeDefinitions"
python3 "$GENERATED/Py+TypeDefinitions.py" > "$GENERATED/Py+TypeDefinitions.swift"
python3 "$GENERATED/Py+ErrorTypeDefinitions.py" > "$GENERATED/Py+ErrorTypeDefinitions.swift"
echo "PyCast"
python3 "$GENERATED/PyCast.py" > "$GENERATED/PyCast.swift"
echo "FunctionWrappers"
python3 "$GENERATED/FunctionWrappers.py" > "$GENERATED/FunctionWrappers.swift"
