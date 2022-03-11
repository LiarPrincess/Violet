#!/bin/bash

# This file is used when you type 'make gen' in repository root.

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated

echo "ExceptionSubclasses"
python3 "$GENERATED/ExceptionSubclasses.py" > "$GENERATED/ExceptionSubclasses.swift"

echo "Sourcery"
sourcery \
  --sources "$OBJECTS" \
  --templates "$GENERATED/Sourcery/dump.stencil" \
  --output "$GENERATED/Sourcery/dump.txt" \
  --quiet

echo "Types+Memory"
python3 "$GENERATED/Types+Memory.py" > "$GENERATED/Types+Memory.swift"
echo "PyStaticCall"
python3 "$GENERATED/PyStaticCall.py" > "$GENERATED/PyStaticCall.swift"
echo "Py+TypeDefinitions"
python3 "$GENERATED/Py+TypeDefinitions.py" > "$GENERATED/Py+TypeDefinitions.swift"
python3 "$GENERATED/Py+ErrorTypeDefinitions.py" > "$GENERATED/Py+ErrorTypeDefinitions.swift"
echo "PyCast"
python3 "$GENERATED/PyCast.py" > "$GENERATED/PyCast.swift"
echo "FunctionWrappers"
python3 "$GENERATED/FunctionWrappers.py" > "$GENERATED/FunctionWrappers.swift"
