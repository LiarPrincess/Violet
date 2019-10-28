import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

public final class Builtins {

  internal static let doc = """
    Built-in functions, exceptions, and other objects.

    Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
    """

  internal lazy var `true`  = PyBool(self.context, value: true)
  internal lazy var `false` = PyBool(self.context, value: false)
  internal lazy var none  = PyNone(self.context)
  internal lazy var ellipsis = PyEllipsis(self.context)
  internal lazy var emptyTuple = PyTuple(self.context, elements: [])
  internal lazy var notImplemented = PyNotImplemented(self.context)

  public let types: BuiltinTypes
  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
    self.types = BuiltinTypes(context: context)
  }
}
