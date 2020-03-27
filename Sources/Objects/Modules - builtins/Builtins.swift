import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// sourcery: pymodule = builtins
public final class Builtins: BuiltinFunctions {

  internal static let doc = """
    Built-in functions, exceptions, and other objects.

    Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
    """

  // sourcery: pyproperty = None
  public var none: PyNone { return Py.none }
  // sourcery: pyproperty = Ellipsis
  public var ellipsis: PyEllipsis { return Py.ellipsis }
  // sourcery: pyproperty = ...
  internal var ellipsisDots: PyEllipsis { return Py.ellipsis }
  // sourcery: pyproperty = NotImplemented
  public var notImplemented: PyNotImplemented { return Py.notImplemented }

  // sourcery: pyproperty = True
  public var `true`: PyBool { return Py.`true` }
  // sourcery: pyproperty = False
  public var `false`: PyBool { return Py.`false` }

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()
}
