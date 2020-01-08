GENERATED=./Sources/Objects/Generated

# We can't use single 'Sourcery' invocation because:
# - we have dependencies between generated files (they have to be in correct order)
# - it always generates '.swift' files that will mess up SPM
#   (not all of the generated files should be a part of the build,
#   sometimes we just generate '.tmp' files that will be inputs for next stages)

# ===========================
# Stage 1: Generate new types
# ===========================
# This stage has to be first because other stages will use type definitions.

# === Builtin errors ===
# This will:
# - add error types (as subclasses of 'PyBaseException')
# - add 'BuiltinErrorTypes' type with references to all of the error 'PyTypes'
python3 $GENERATED/Errors.py "class-definitions" > $GENERATED/PyExceptions.swift
python3 $GENERATED/Errors.py "types" > $GENERATED/BuiltinErrorTypes.swift

# === Heap types ===
# This will add new types that will be used when user subclasses one of the
# builtin types (for example 'class Rapunzel(int): pass').
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/HeapTypes.stencil \
  --output $GENERATED/HeapTypes.swift

# =====================================
# Stage 2: Work on all type definitions
# =====================================
# This stage has to be after 'Stage 1: Generate new types'

# === Builtin types ===
# This will generate a class with references to all of the builtin 'PyTypes'.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/BuiltinTypes.stencil \
  --output $GENERATED/BuiltinTypes.swift

# === Type fill ===
# This will generate a giant file responsible for filling PyTypes '__dict__'.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/BuiltinTypesFill.stencil \
  --output $GENERATED/BuiltinTypesFill.swift

# === Casts ===
# Since we use Swift methods as Python functions we have to cast 'sefl: PyObject'
# to a proper type.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/DowncastObject.stencil \
  --output $GENERATED/DowncastObject.swift

# ==============
# Stage 3: Other
# ==============
# This stage does not really depend on type definitions.

# === Modules ===
# Generate type that will create 'PyModule' instances.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/ModuleFactory.stencil \
  --output $GENERATED/ModuleFactory.swift

# Owner protocols
# Sometimes instead of doing slow Python dispatch we will use Swift protocols.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/Owners.stencil \
  --output $GENERATED/Owners.tmp

python3 $GENERATED/Owners.py "protocols" > $GENERATED/OwnerProtocols.swift
python3 $GENERATED/Owners.py "conformance" > $GENERATED/OwnerConformance.swift
