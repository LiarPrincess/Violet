import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

public final class Builtins {

  internal static let doc = """
    Built-in functions, exceptions, and other objects.

    Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
    """

  /// Internal API to look for a name through the MRO.
  internal func lookup(_ object: PyObject, name: String) -> PyObject? {
    return object.type.lookup(name: name)
  }

  internal func call(_ fn: PyObject,
                     args: [PyObject]) -> PyResult<PyObject> {
    fatalError("To be done")
  }
}
