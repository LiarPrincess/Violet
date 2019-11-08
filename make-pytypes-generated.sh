GENERATED=./Sources/Objects/Generated

# Type definitions
sourcery \
  --sources ./Sources/Objects \
  --templates ./Sources/Objects/Types\ -\ meta/PyType+Generated.stencil \
  --output ./Sources/Objects/Types\ -\ meta/PyType+Generated.swift

# Builtin types
sourcery \
  --sources ./Sources/Objects \
  --templates ./Sources/Objects/Builtins/BuiltinTypes.stencil \
  --output ./Sources/Objects/Builtins/BuiltinTypes.swift

# Builtin errors
python3 $GENERATED/Errors.py "class-definitions" > $GENERATED/PyExceptions.swift
python3 $GENERATED/Errors.py "types" > $GENERATED/BuiltinErrorTypes.swift

# Owner protocols
sourcery \
  --sources ./Sources/Objects \
  --templates ./Sources/Objects/Generated/Owners.stencil \
  --output ./Sources/Objects/Generated/Owners.tmp

python3 $GENERATED/Owners.py "protocols" > $GENERATED/OwnerProtocols.swift
python3 $GENERATED/Owners.py "conformance" > $GENERATED/OwnerConformance.swift
