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

# Owner
sourcery \
  --sources ./Sources/Objects \
  --templates ./Sources/Objects/Generated/OwnerProtocols.stencil \
  --output ./Sources/Objects/Generated/OwnerProtocols.tmp

python3 ./Sources/Objects/Generated/OwnerProtocols.py > ./Sources/Objects/Generated/OwnerProtocols.swift

# sourcery \
#   --sources ./Sources/Objects \
#   --templates ./Sources/Objects/Generated/Owner+Generated.stencil \
#   --output ./Sources/Objects/Generated/Owner+Generated.swift
