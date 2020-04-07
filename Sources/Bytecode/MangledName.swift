import Core

// In CPython:
// Python -> compile.c
//   _Py_Mangle(PyObject *privateobj, PyObject *ident)

/// Any identifier of the form `__spam`
/// (at least two leading underscores, at most one trailing underscore)
/// is textually replaced with `_classname__spam`, where `classname`
/// is the current class name with leading underscore(s) stripped.
/// See [docs](https://docs.python.org/3.7/tutorial/classes.html#private-variables)
public struct MangledName: Equatable, Hashable {

  /// Name BEFORE mangling
  public let base: String

  /// Name AFTER mangling
  public let value: String

  /// Init without mangling
  public init(from name: String) {
    self.base = name
    self.value = name
  }

  /// Init with mangling
  public init(className: String?, name: String) {
    self.base = name
    self.value = mangle(className: className, name: name)
  }

  public func hash(into hasher: inout Hasher) {
    UseScalarsToHashString.hash(value: self.value, into: &hasher)
  }

  public static func == (lhs: MangledName, rhs: MangledName) -> Bool {
    return UseScalarsToHashString.isEqual(lhs: lhs.value, rhs: rhs.value)
  }
}

extension MangledName: ConstantString {
  public var constant: String { return self.value }
}

extension MangledName: CustomStringConvertible {
  public var description: String {
    return self.value
  }
}

private func mangle(className: String?, name: String) -> String {
  guard let className = className else {
    return name
  }

  guard name.hasPrefix("__") else {
    return name
  }

  // Don't mangle __id__ or names with dots.
  // The only time a name with a dot can occur is when we are compiling
  // an import statement that has a package name.

  if name.hasSuffix("__") || name.contains(".") {
    return name
  }

  // Strip leading underscores from class name
  let classNameStrip = className.drop { $0 == "_" }

  return classNameStrip.isEmpty ? // Don't mangle if class is just underscores
    name :
    "_" + classNameStrip + name
}
