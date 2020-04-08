from Data.types import get_types

all_types = get_types()
types = all_types

if __name__ == '__main__':
  print('''\
// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable file_length

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// Basically:
// We hold 'PyObjects' on stack.
// We need to call Swift method that needs specific 'self' type.
// This file is responsible for downcasting 'PyObject' -> that specific Swift type.
''')

  print('''\
private func cast<T>(_ object: PyObject,
                     as type: T.Type,
                     typeName: String,
                     methodName: String) -> PyResult<T> {
  if let v = object as? T {
    return .value(v)
  }

  return .typeError(
    "descriptor '\(methodName)' requires a '\(typeName)' object " +
    "but received a '\(object.typeName)'"
  )
}
''')

  print('internal enum Cast {')
  print()

  for t in types:
    python_type = t.python_type
    swift_type = t.swift_type

    # We do not have to downcast 'object' -> 'object'
    if python_type == 'object':
      continue

    mark = swift_type.replace('Py', '')

    print(f'''\
  // MARK: - {mark}

  internal static func as{swift_type}(_ object: PyObject, methodName: String) -> PyResult<{swift_type}> {{
    return cast(object, as: {swift_type}.self, typeName: "{python_type}", methodName: methodName)
  }}
''')

  print('}')
