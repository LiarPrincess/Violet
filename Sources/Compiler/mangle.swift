// In CPython:
// Python -> compile.c
//   _Py_Mangle(PyObject *privateobj, PyObject *ident)

/// Any identifier of the form `__spam` (at least two leading underscores,
/// at most one trailing underscore) is textually replaced with
/// `_classname__spam`, where `classname` is the current class name with
/// leading underscore(s) stripped. See
/// [docs](https://docs.python.org/3.7/tutorial/classes.html#private-variables)\.
internal func mangle(className: String?, identifier: String) -> String {
  guard let className = className else {
    return identifier
  }

  if !identifier.hasPrefix("__") {
    return identifier
  }

  // Don't mangle __id__ or names with dots.
  // The only time a name with a dot can occur is when we are compiling
  // an import statement that has a package name.

  if identifier.hasSuffix("__") || identifier.contains("."){
    return identifier
  }

  // Strip leading underscores from class name
  let classNameStrip = className.drop { $0 == "_" }
  if classNameStrip.isEmpty {
    // Don't mangle if class is just underscores
    return identifier
  }

  return "_" + classNameStrip + identifier
}
