// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// TODO: Uncomment remaining types

extension Builtins {

  // sourcery: pytype: bool
  /// class bool([x])
  public var bool: PyType { return self.types.bool }

  // sourcery: pytype: bytearray
  /// class bytearray([source[, encoding[, errors]]])
  //  public var bytearray: PyType { return self.types.bytearray }

  // sourcery: pytype: bytes
  /// class bytes([source[, encoding[, errors]]])
  //  public var bytes: PyType { return self.types.bytes }

  // sourcery: pytype: complex
  /// class complex([real[, imag]])
  public var complex: PyType { return self.types.complex }

  // sourcery: pytype: dict
  /// class dict(**kwarg)
  //  public var dict: PyType { return self.types.dict }

  // sourcery: pytype: float
  /// class float([x])
  public var float: PyType { return self.types.float }

  // sourcery: pytype: frozenset
  /// class frozenset([iterable])
  //  public var frozenset: PyType { return self.types.frozenset }

  // sourcery: pytype: int
  /// class int([x])
  public var int: PyType { return self.types.int }

  // sourcery: pytype: list
  /// class list([iterable])
  public var list: PyType { return self.types.list }

  // sourcery: pytype: object
  /// class object
  public var object: PyType { return self.types.object }

  // sourcery: pytype: property
  /// class property(fget=None, fset=None, fdel=None, docne) */
  public var property: PyType { return self.types.property }

  // sourcery: pytype: set
  /// class set([iterable])
  //  public var set: PyType { return self.types.set }

  // sourcery: pytype: slice
  /// class slice(stop)
  public var slice: PyType { return self.types.slice }

  // sourcery: pytype: str
  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  //  public var str: PyType { return self.types.str }

  // sourcery: pytype: type
  /// class type(object)
  /// class type(name, bases, dict)
  public var type: PyType { return self.types.type }
}
