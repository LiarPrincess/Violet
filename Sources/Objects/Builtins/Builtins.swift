import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

public final class Builtins {

  internal static let doc = """
    Built-in functions, exceptions, and other objects.

    Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
    """

/*
  // sourcery: pytype: bool
  /// class bool([x])
  internal let bool: PyType

  // sourcery: pytype: bytearray
  /// class bytearray([source[, encoding[, errors]]])
  internal let bytearray: PyType

  // sourcery: pytype: bytes
  /// class bytes([source[, encoding[, errors]]])
  internal let bytes: PyType

  // sourcery: pytype: complex
  /// class complex([real[, imag]])
  internal let complex: PyType

  // sourcery: pytype: dict
  /// class dict(**kwarg)
  internal let dict: PyType

  // sourcery: pytype: float
  /// class float([x])
  internal let float: PyType

  // sourcery: pytype: frozenset
  /// class frozenset([iterable])
  internal let frozenset: PyType

  // sourcery: pytype: int
  /// class int([x])
  internal let int: PyType

  // sourcery: pytype: list
  /// class list([iterable])
  internal let list: PyType

  // sourcery: pytype: object
  /// class object
  internal let object: PyType

  // sourcery: pytype: property
  /// class property(fget=None, fset=None, fdel=None, doc=None)
  internal let property: PyType

  // sourcery: pytype: set
  /// class set([iterable])
  internal let set: PyType

  // sourcery: pytype: slice
  /// class slice(stop)
  internal let slice: PyType

  // sourcery: pytype: str
  /// class str(object='')
  internal let str: PyType

  // sourcery: pytype: type
  /// class type(object)
  internal let type: PyType
*/

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }
}
