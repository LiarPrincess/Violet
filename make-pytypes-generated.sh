GENERATED=./Sources/Objects/Generated

# ===========================
# Stage 1: Generate new types
# ===========================
# This stage has to be first because other stages will depend on newly created
# type definitions.

# === Builtin errors ===
# This will add new error types (as subclasses of 'PyBaseException')
python3 $GENERATED/ExceptionSubclasses.py > $GENERATED/ExceptionSubclasses.swift

# === Heap types ===
# This will add new types that will be used when user subclasses one of the
# builtin types (for example 'class Rapunzel(int): pass' is a subclass
# of builtin 'int' class).
# It is mainly there to add '__dict__'.
# We use CPython naming convention where user generated types are 'heap' types,
# even though in Violet all of the types are technically 'heap' types.
python3 $GENERATED/HeapTypes.py > $GENERATED/HeapTypes.swift

# =====================================
# Stage 2: Work on all type definitions
# =====================================
# This stage has to be after 'Stage 1: Generate new types'

# === Dump types ===
# This will generate a giant file wile with of all of the Python types/operations.
# It will be used as a 'single source of truth' for later stages.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/Data/types.stencil \
  --output $GENERATED/Data/types.txt

# === Builtin types ===
# This will generate class that will create 'PyType' object
# for each of the builtin types.
python3 $GENERATED/BuiltinTypes.py > $GENERATED/BuiltinTypes.swift
python3 $GENERATED/BuiltinErrorTypes.py > $GENERATED/BuiltinErrorTypes.swift

# === TypeLayout ===
# When creating new class we will check if all of the base classes have
# the same layout.
# So, for example we will allow this:
#   >>> class C(int, object): pass
# but do not allow this:
#   >>> class C(int, str): pass
#   TypeError: multiple bases have instance lay-out conflict
python3 $GENERATED/TypeLayout.py > $GENERATED/TypeLayout.swift

# ==============
# Stage 3: Other
# ==============
# This stage does not really depend on type definitions.

# === Fast dispatch ===
# Sometimes instead of doing slow Python dispatch we will use Swift protocols.
python3 $GENERATED/Fast.py > $GENERATED/Fast.swift

# === IdString ===
# Predefined commonly used `__dict__` keys.
# Similiar to `_Py_IDENTIFIER` in `CPython`.
python3 $GENERATED/IdStrings.py > $GENERATED/IdStrings.swift
