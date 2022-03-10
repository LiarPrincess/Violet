#!/bin/bash

# This file is used when you type 'make gen' in repository root.

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated

# ===========================
# Stage 1: Generate new types
# ===========================

# This stage has to be first because other stages will depend on newly created
# type definitions.

echo "=== Builtin errors ==="
echo "Add new error types (as subclasses of 'PyBaseException')."
echo "- ExceptionSubclasses.swift"
python3 "$GENERATED/ExceptionSubclasses.py" > "$GENERATED/ExceptionSubclasses.swift"
echo

# =====================================
# Stage 2: Work on all type definitions
# =====================================

# This stage has to be after 'Stage 1: Generate new types'

echo "=== Sourcery ==="
echo "Generate a giant file wile with of all of the types/methods."
echo "It will be used as a 'single source of truth' for later stages."
echo "- Sourcery/dump.txt"
sourcery \
  --sources "$OBJECTS" \
  --templates "$GENERATED/Sourcery/dump.stencil" \
  --output "$GENERATED/Sourcery/dump.txt" \
  --quiet
echo

echo "=== Builtin types ==="
echo "Generate a type that will create and store 'PyType' object for each of the"
echo "builtin types."
echo "- BuiltinTypes.swift"
python3 "$GENERATED/BuiltinTypes.py" > "$GENERATED/BuiltinTypes.swift"
echo "- BuiltinErrorTypes.swift"
python3 "$GENERATED/BuiltinErrorTypes.py" > "$GENERATED/BuiltinErrorTypes.swift"
echo

echo "=== Type memory layout ==="
echo "When creating a new class we will check if all of the base classes have"
echo "the same layout."
echo "So, for example we will allow this: 'class C(int, object): pass'"
echo "But do not allow this: 'class C(int, str): pass'"
echo "- PyType+MemoryLayout.swift"
python3 "$GENERATED/PyType+MemoryLayout.py" > "$GENERATED/PyType+MemoryLayout.swift"
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

echo "=== Memory ==="
echo "Helper for allocating new object instances."
echo "- PyMemory.swift"
python3 "$GENERATED/PyMemory.py" > "$GENERATED/PyMemory.swift"
echo

echo "=== Function wrappers ==="
echo "Helper for storing and calling Swift functions (regardless of their signature)."
echo "- FunctionWrapper - type that will store a reference to Swift function"
python3 "$GENERATED/FunctionWrapper.py" > "$GENERATED/FunctionWrapper.swift"
echo "- PyBuiltinFunction+Wrap - factory methods for 'builtinfunction'"
python3 "$GENERATED/PyBuiltinFunction+Wrap.py" > "$GENERATED/PyBuiltinFunction+Wrap.swift"
echo "- PyClassMethod+Wrap - factory methods for 'classmethod'"
python3 "$GENERATED/PyClassMethod+Wrap.py" > "$GENERATED/PyClassMethod+Wrap.swift"
echo

echo "=== Static dispatch ==="
echo "Sometimes instead of doing slow Python dispatch we will use 'object.type.staticMethods'."
echo "- PyStaticCall.swift - interface for calling static methods"
python3 "$GENERATED/PyStaticCall.py" > "$GENERATED/PyStaticCall.swift"
echo "- PyType+StaticallyKnownMethods.swift - type responsible for storing static methods"
python3 "$GENERATED/PyType+StaticallyKnownMethods.py" > "$GENERATED/PyType+StaticallyKnownMethods.swift"
echo "- StaticMethodsForBuiltinTypes.swift - static methods defined on builtin types"
python3 "$GENERATED/StaticMethodsForBuiltinTypes.py" > "$GENERATED/StaticMethodsForBuiltinTypes.swift"
echo

echo "=== IdString ==="
echo "Predefined commonly used '__dict__' keys."
echo "Similar to '_Py_IDENTIFIER' in CPython."
echo "- IdStrings.swift"
python3 "$GENERATED/IdStrings.py" > "$GENERATED/IdStrings.swift"
