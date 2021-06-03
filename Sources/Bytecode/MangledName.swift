import VioletCore

// cSpell:ignore privateobj

// In CPython:
// Python -> compile.c
//   _Py_Mangle(PyObject *privateobj, PyObject *ident)

/// Any identifier of the form `__spam`
/// (at least two leading underscores, at most one trailing underscore)
/// is textually replaced with `_className__spam`, where `className`
/// is the current class name with leading underscore(s) stripped.
/// See [docs](https://docs.python.org/3.7/tutorial/classes.html#private-variables)
public struct MangledName: Equatable, Hashable, CustomStringConvertible {

  /// Name BEFORE mangling
  public let beforeMangling: String

  /// Name AFTER mangling
  public let value: String

  public var description: String {
    return self.value
  }

  /// Init without mangling
  public init(withoutClass name: String) {
    self.beforeMangling = name
    self.value = name
  }

  /// Init with mangling
  public init(className: String?, name: String) {
    guard let className = className else {
      self = MangledName(withoutClass: name)
      return
    }

    self.beforeMangling = name
    self.value = mangle(className: className, name: name)
  }

  public func hash(into hasher: inout Hasher) {
    UseScalarsToHashString.hash(value: self.value, into: &hasher)
  }

  public static func == (lhs: MangledName, rhs: MangledName) -> Bool {
    return UseScalarsToHashString.isEqual(lhs: lhs.value, rhs: rhs.value)
  }
}

private func mangle(className: String, name: String) -> String {
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

  // Don't mangle if class is just underscores
  return classNameStrip.isEmpty ? name : "_" + classNameStrip + name
}
