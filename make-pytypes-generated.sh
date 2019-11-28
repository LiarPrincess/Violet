GENERATED=./Sources/Objects/Generated

# Type factory
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/TypeFactory+Generated.stencil \
  --output $GENERATED/TypeFactory+Generated.swift

# Heap types
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/HeapTypes.stencil \
  --output $GENERATED/HeapTypes.swift

# Builtin types
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/BuiltinTypes.stencil \
  --output $GENERATED/BuiltinTypes.swift

# Builtin errors
python3 $GENERATED/Errors.py "class-definitions" > $GENERATED/PyExceptions.swift
python3 $GENERATED/Errors.py "types" > $GENERATED/BuiltinErrorTypes.swift

# Owner protocols
sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/Owners.stencil \
  --output $GENERATED/Owners.tmp

python3 $GENERATED/Owners.py "protocols" > $GENERATED/OwnerProtocols.swift
python3 $GENERATED/Owners.py "conformance" > $GENERATED/OwnerConformance.swift
