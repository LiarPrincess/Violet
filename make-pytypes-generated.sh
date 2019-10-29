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

# Owner generated
sourcery \
  --sources ./Sources/Objects \
  --templates ./Sources/Objects/Types\ -\ meta/Owner+Generated.stencil \
  --output ./Sources/Objects/Types\ -\ meta/Owner+Generated.swift
