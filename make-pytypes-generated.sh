GENERATED=./Sources/Objects/Generated

# Builtin types
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/BuiltinTypes.stencil \
  --output $GENERATED/BuiltinTypes.swift

# Builtin errors
python3 $GENERATED/Errors.py "class-definitions" > $GENERATED/PyExceptions.swift
python3 $GENERATED/Errors.py "types" > $GENERATED/BuiltinErrorTypes.swift

# Type fill
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/BuiltinTypesFill.stencil \
  --output $GENERATED/BuiltinTypesFill.swift

# Modules
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/ModuleFactory.stencil \
  --output $GENERATED/ModuleFactory.swift

# Casts
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/DowncastObject.stencil \
  --output $GENERATED/DowncastObject.swift

# Heap types
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/HeapTypes.stencil \
  --output $GENERATED/HeapTypes.swift

# Owner protocols
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/Owners.stencil \
  --output $GENERATED/Owners.tmp

python3 $GENERATED/Owners.py "protocols" > $GENERATED/OwnerProtocols.swift
python3 $GENERATED/Owners.py "conformance" > $GENERATED/OwnerConformance.swift
