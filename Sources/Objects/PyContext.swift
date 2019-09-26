public class PyContext {

  public var `true`:  PyObject { return self.types.bool.true }
  public var `false`: PyObject { return self.types.bool.false }

  public var none: PyObject { return self.types.none.value }
  public var ellipsis: PyObject { return self.types.ellipsis.value }
  public var emptyTuple: PyObject { return self.types.tuple.empty }
  public var notImplemented: PyObject { return self.types.notImplemented.value }

  internal lazy var types = PyContextTypes(context: self)
  //    pub exceptions: exceptions::ExceptionZoo,

  public init() { }
}

internal class PyContextTypes {

  private unowned let context: PyContext

  internal lazy var none = PyNoneType(context: self.context)
  internal lazy var notImplemented = PyNotImplementedType(context: self.context)

  internal lazy var int   = PyIntType(context: self.context)
  internal lazy var float = PyFloatType(context: self.context)
  internal lazy var bool  = PyBoolType(context: self.context)

  internal lazy var tuple = PyTupleType(context: self.context)
  internal lazy var list  = PyListType(context: self.context)

  internal lazy var slice = PySliceType(context: self.context)
  internal lazy var ellipsis = PyEllipsisType(context: self.context)

  fileprivate init(context: PyContext) {
    self.context = context
  }
}
