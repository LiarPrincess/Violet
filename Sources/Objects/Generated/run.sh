#!/bin/bash

OBJECTS=./Sources/Objects
GENERATED=./Sources/Objects/Generated

# ===========================
# Stage 1: Generate new types
# ===========================

# This stage has to be first because other stages will depend on newly created
# type definitions.

# === Builtin errors ===
# This will add new error types (as subclasses of 'PyBaseException')
echo 'Generating exception subclasses'
python3 $GENERATED/ExceptionSubclasses.py > $GENERATED/ExceptionSubclasses.swift
echo ''

# =====================================
# Stage 2: Work on all type definitions
# =====================================

# This stage has to be after 'Stage 1: Generate new types'

# === Dump types ===
# This will generate a giant file wile with of all of the Python types/methods.
# It will be used as a 'single source of truth' for later stages.
echo 'Running Sourcery'
sourcery \
  --sources $OBJECTS \
  --templates $GENERATED/Sourcery/dump.stencil \
  --output $GENERATED/Sourcery/dump.txt \
  --quiet
echo ''

# === Builtin types ===
# This will generate class that will create 'PyType' object
# for each of the builtin types.
echo 'Generating builtin type instances'
python3 $GENERATED/BuiltinTypes.py > $GENERATED/BuiltinTypes.swift
python3 $GENERATED/BuiltinErrorTypes.py > $GENERATED/BuiltinErrorTypes.swift

# === Type memory layout ===
# When creating new class we will check if all of the base classes have
# the same layout.
# So, for example we will allow this:
#   >>> class C(int, object): pass
# but do not allow this:
#   >>> class C(int, str): pass
#   TypeError: multiple bases have instance lay-out conflict
echo 'Generating type memory layouts'
python3 $GENERATED/TypeMemoryLayout.py > $GENERATED/TypeMemoryLayout.swift

# ==============
# Stage 3: Other
# ==============

# This stage does not really depend on type definitions.

# === Fast dispatch ===
# Sometimes instead of doing slow Python dispatch we will use Swift protocols.
echo 'Generating Fast (protocol based dispatch)'
python3 $GENERATED/Fast.py > $GENERATED/Fast.swift

# === Casting ===
# Sometimes we have to cast from 'PyObject' to specific Swift type.
# This file generates casting methods.
echo 'Generating PyCast (methods for casting PyObject -> specific Swift type)'
python3 $GENERATED/PyCast.py > $GENERATED/PyCast.swift

# === Memory ===
# Helper for allocating new object instances.
echo 'Generating PyMemory (helper for allocating new object instances)'
python3 $GENERATED/PyMemory.py > $GENERATED/PyMemory.swift

# === Function wrappers ===
# Helper for storing and calling Swift functions (regardless of their signature)
echo 'Generating FunctionWrapper (helper for storing and calling Swift functions)'
python3 $GENERATED/FunctionWrapper.py > $GENERATED/FunctionWrapper.swift
echo "Generating PyBuiltinFunction+Wrap (factory methods for 'builtinfunction')"
python3 $GENERATED/PyBuiltinFunction+Wrap.py > $GENERATED/PyBuiltinFunction+Wrap.swift
echo "Generating PyClassMethod+Wrap (factory methods for 'classmethod')"
python3 $GENERATED/PyClassMethod+Wrap.py > $GENERATED/PyClassMethod+Wrap.swift

# === IdString ===
# Predefined commonly used `__dict__` keys.
# Similar to `_Py_IDENTIFIER` in `CPython`.
echo "Generating IdStrings (predefined commonly used '__dict__' keys)"
python3 $GENERATED/IdStrings.py > $GENERATED/IdStrings.swift
echo ''
