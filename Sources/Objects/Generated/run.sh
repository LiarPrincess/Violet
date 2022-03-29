#!/bin/bash

# This file is used when you type 'make gen' in repository root.

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated

# ===========================
# Stage 1: Generate new types
# ===========================

# This stage has to be first because other stages will depend on newly created
# type definitions.

echo "- ExceptionSubclasses.swift - error types not written by hand"

# Gather information about hand-written exceptions
sourcery \
  --sources "$OBJECTS/Types - errors" \
  --templates "$GENERATED/Sourcery/exceptions-by-hand.stencil" \
  --output "$GENERATED/Sourcery/exceptions-by-hand.txt" \
  --quiet

python3 "$GENERATED/ExceptionSubclasses.py" > "$GENERATED/ExceptionSubclasses.swift"

# =====================================
# Stage 2: Work on all type definitions
# =====================================

# This stage has to be after 'Stage 1: Generate new types'

echo "- Sourcery/dump.txt - a giant file with of all of the Python types/properties/methods"
sourcery \
  --sources "$OBJECTS" \
  --templates "$GENERATED/Sourcery/dump.stencil" \
  --output "$GENERATED/Sourcery/dump.txt" \
  --quiet
echo

echo "- Py+Generated.swift - things generated for 'Py': property offsets, deinitialize etc."
python3 "$GENERATED/Py+Generated.py" > "$GENERATED/Py+Generated.swift"

echo "- Types+Generated.swift - things generated for a every type: property offsets, deinitialize, 'PyMemory.new' etc."
python3 "$GENERATED/Types+Generated.py" > "$GENERATED/Types+Generated.swift"
echo

echo "- Py+TypeDefinitions.swift - container for 'PyType' objects for builtin types"
python3 "$GENERATED/Py+TypeDefinitions.py" > "$GENERATED/Py+TypeDefinitions.swift"
echo "- Py+ErrorTypeDefinitions.swift - container for 'PyType' objects for builtin error types"
python3 "$GENERATED/Py+ErrorTypeDefinitions.py" > "$GENERATED/Py+ErrorTypeDefinitions.swift"
echo

# ==============
# Stage 3: Other
# ==============

# This stage does not really depend on type definitions.

echo "- PyCast.swift - downcast from 'PyObject' to a specific Swift type (like 'PyInt')"
python3 "$GENERATED/PyCast.py" > "$GENERATED/PyCast.swift"

echo "- PyStaticCall.swift - method dispatch via 'object.type.staticMethods'"
python3 "$GENERATED/PyStaticCall.py" > "$GENERATED/PyStaticCall.swift"

echo "- FunctionWrappers.swift - store and call Swift function (regardless of its signature)"
python3 "$GENERATED/FunctionWrappers.py" > "$GENERATED/FunctionWrappers.swift"

echo "- IdStrings.swift - predefined commonly used '__dict__' keys"
python3 "$GENERATED/IdStrings.py" > "$GENERATED/IdStrings.swift"
