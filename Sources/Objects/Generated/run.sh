#!/bin/bash

# This file is used when you type 'make gen' in repository root.

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated

# ===========================
# Stage 1: Generate new types
# ===========================

# This stage has to be first because other stages will depend on newly created
# type definitions.

echo "=== Exception subclasses ==="
echo "Add new error types (as subclasses of 'PyBaseException')."
echo "- ExceptionSubclasses.swift"

# Gather information about hand-written exceptions
sourcery \
  --sources "$OBJECTS/Types - errors" \
  --templates "$GENERATED/Sourcery/exceptions-by-hand.stencil" \
  --output "$GENERATED/Sourcery/exceptions-by-hand.txt" \
  --quiet

python3 "$GENERATED/ExceptionSubclasses.py" > "$GENERATED/ExceptionSubclasses.swift"
echo

# =====================================
# Stage 2: Work on all type definitions
# =====================================

# This stage has to be after 'Stage 1: Generate new types'

echo "=== Sourcery ==="
echo "Generate a giant file wile with of all of the types/properties/methods."
echo "It will be used as a 'single source of truth' for later stages."
echo "- Sourcery/dump.txt"
sourcery \
  --sources "$OBJECTS" \
  --templates "$GENERATED/Sourcery/dump.stencil" \
  --output "$GENERATED/Sourcery/dump.txt" \
  --quiet
echo

echo "=== Type definitions ==="
echo "Generate a type that will create and store 'PyType' object for each of the"
echo "builtin types."
echo "- Py+TypeDefinitions.swift"
python3 "$GENERATED/Py+TypeDefinitions.py" > "$GENERATED/Py+TypeDefinitions.swift"
echo "- Py+ErrorTypeDefinitions.swift"
python3 "$GENERATED/Py+ErrorTypeDefinitions.py" > "$GENERATED/Py+ErrorTypeDefinitions.swift"
echo

echo "=== Type + generated ==="
echo "Generate tons of stuff for a single type, for example:"
echo "  - layout - field offsets for stored properties"
echo "  - [PROPERTY_NAME]Ptr - pointer to stored property (with offset from layout)"
echo "  - func initializeBase(...) - call base initializer"
echo "  - func deinitialize(ptr: RawPtr) - to deinitialize this object before deletion"
echo "  - PyMemory.new[TYPE_NAME] - to create new object of this type"
echo "- Types+Generated.swift"
python3 "$GENERATED/Types+Generated.py" > "$GENERATED/Types+Generated.swift"
echo

echo "=== Py + generated ==="
echo "Generate some stuff for py:"
echo "  - layout - field offsets for stored properties"
echo "  - [PROPERTY_NAME]Ptr - pointer to stored property (with offset from layout)"
echo "  - func deinitialize() - to deinitialize 'py' before deletion"
echo "- Py+Generated.swift"
python3 "$GENERATED/Py+Generated.py" > "$GENERATED/Py+Generated.swift"
echo

# ==============
# Stage 3: Other
# ==============

# This stage does not really depend on type definitions.

echo "=== Casting ==="
echo "Sometimes we have to cast from 'PyObject' to a specific Swift type."
echo "This file generates casting methods."
echo "- PyCast.swift"
python3 "$GENERATED/PyCast.py" > "$GENERATED/PyCast.swift"
echo

echo "=== Static dispatch ==="
echo "Sometimes instead of doing a slow Python dispatch we will use 'object.type.staticMethods'."
echo "- PyStaticCall.swift"
python3 "$GENERATED/PyStaticCall.py" > "$GENERATED/PyStaticCall.swift"
echo

echo "=== Function wrappers ==="
echo "Helper type for storing and calling Swift functions (regardless of their signature)."
echo "- FunctionWrappers.swift"
python3 "$GENERATED/FunctionWrappers.py" > "$GENERATED/FunctionWrappers.swift"
echo

echo "=== IdString ==="
echo "Predefined commonly used '__dict__' keys."
echo "Similar to '_Py_IDENTIFIER' in CPython."
echo "- IdStrings.swift"
python3 "$GENERATED/IdStrings.py" > "$GENERATED/IdStrings.swift"
echo
