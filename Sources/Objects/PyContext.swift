public class PyContext {

  public var `true`:  PyObject { return self.types.bool.true }
  public var `false`: PyObject { return self.types.bool.false }

  public var none: PyObject { return self.types.none.value }
  public var notImplemented: PyObject { return self.types.notImplemented.value }

  //  public var emptyTuple: PyObject { return PyObject(type: DummyType()) }
  //  public var ellipsis:   PyObject { return PyObject(type: DummyType()) }

  internal lazy var types = PyContextTypes(context: self)
  //    pub exceptions: exceptions::ExceptionZoo,

  public init() { }
}

internal class PyContextTypes {

  private unowned let context: PyContext

  internal lazy var none = PyNoneType(context: self.context)
  internal lazy var notImplemented = PyNotImplementedType()

  internal lazy var int   = PyIntType(context: self.context)
  internal lazy var float = PyFloatType(context: self.context)
  internal lazy var bool  = PyBoolType(context: self.context)

  internal lazy var tuple = PyTupleType()

  fileprivate init(context: PyContext) {
    self.context = context
  }
}
