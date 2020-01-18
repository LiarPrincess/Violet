GENERATED=./Sources/Objects/Generated

# We can't use single 'Sourcery' invocation because:
# - we have dependencies between generated files (they have to be in correct order),
#   and Sourcery does not guarantee order
# - it always generates '.swift' files that will mess up SPM
#   (not all of the generated files should be a part of the build,
#   sometimes we just generate '.tmp' files that will be inputs for next stages)

# Also, we will be removing Sourcery header/marker from generated files.
# So, normally Sourcery skips other generated files using this marker to recognize
# which files were generated and which not.
# We can force Sourcery to take into account other generated files using
# '--force-parse FILTER' option. This will allow any file that contains '.FILTER.'
# in its path to also be included. The dot at the end of this pattern makes it
# unsuitable for us.
# We could patch Sourcery (*), but then we would force everyone to update.
# Or we can just remove this marker and call it a day.

# (*) This is not really an error in Sourcery, normally they add '.generated.'
# in the name of the file, so it works for them (although, the method responsible
# for checking this is named 'hasExtension', which is not how it works).

# ===========================
# Stage 1: Generate new types
# ===========================
# This stage has to be first because other stages will use new type definitions.

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

python3 $GENERATED/remove-sourcery-header.py HeapTypes.swift

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

python3 $GENERATED/remove-sourcery-header.py BuiltinTypes.swift

# === Type fill ===
# This will generate a giant file responsible for filling PyTypes '__dict__'.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/BuiltinTypesFill.stencil \
  --output $GENERATED/BuiltinTypesFill.swift

python3 $GENERATED/remove-sourcery-header.py BuiltinTypesFill.swift

# === Casts ===
# Since we use Swift methods as Python functions we have to cast 'self: PyObject'
# to a proper type (for example PyObject -> PyInt).
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/DowncastObject.stencil \
  --output $GENERATED/DowncastObject.swift

python3 $GENERATED/remove-sourcery-header.py DowncastObject.swift

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

python3 $GENERATED/remove-sourcery-header.py ModuleFactory.swift

# Owner protocols
# Sometimes instead of doing slow Python dispatch we will use Swift protocols.
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/Owners.stencil \
  --output $GENERATED/Owners.tmp

python3 $GENERATED/Owners.py "protocols" > $GENERATED/OwnerProtocols.swift
python3 $GENERATED/Owners.py "conformance" > $GENERATED/OwnerConformance.swift
