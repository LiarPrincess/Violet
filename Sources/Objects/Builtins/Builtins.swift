import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

public final class Builtins {

  internal static let doc = """
    Built-in functions, exceptions, and other objects.

    Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
    """

  public lazy var `true`  = PyBool(self.context, value: true)
  public lazy var `false` = PyBool(self.context, value: false)
  public lazy var none  = PyNone(self.context)
  public lazy var ellipsis = PyEllipsis(self.context)
  public lazy var emptyTuple = PyTuple(self.context, elements: [])
  public lazy var notImplemented = PyNotImplemented(self.context)

  internal var cachedInts = [BigInt: PyInt]()

  public let types: BuiltinTypes
  public let errorTypes: BuiltinErrorTypes
  public let warningTypes: BuiltinWarningTypes
  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
    self.types = BuiltinTypes(context: context)
    self.errorTypes = BuiltinErrorTypes(context: context,
                                        types: self.types)
    self.warningTypes = BuiltinWarningTypes(context: context,
                                            types: self.types,
                                            errors: self.errorTypes)

    self.cacheIntegers()
  }

  private func cacheIntegers() {
    let min = -10
    let max = 255

    for int in min...max {
      let bigInt = BigInt(int)
      self.cachedInts[bigInt] = PyInt(self.context, value: bigInt)
    }
  }
}
