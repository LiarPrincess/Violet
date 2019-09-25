// MARK: - Context

public class DummyType: PyType { }

public class Context {

  public var `true`:  PyBool { return self.types.bool.true }
  public var `false`: PyBool { return self.types.bool.false }

  public var none: PyObject { return self.types.none.value }
  public var notImplemented: PyObject { return self.types.notImplemented.value }

//  public var emptyTuple: PyObject { return PyObject(type: DummyType()) }
//  public var ellipsis:   PyObject { return PyObject(type: DummyType()) }

  public lazy var types = ContextTypes(context: self)
//    pub exceptions: exceptions::ExceptionZoo,

  public init() { }
}

public class ContextTypes {

  private let context: Context

  public lazy var none = PyNoneType(context: self.context)
  public lazy var notImplemented = PyNotImplementedType()

  public lazy var int    = PyIntType(context: self.context)
  public lazy var float  = PyFloatType(context: self.context)
  public lazy var bool   = PyBoolType(context: self.context)
  public lazy var number = PyNumberType()

  public lazy var unicode = PyUnicodeType()
  public lazy var tuple   = PyTupleType()

  fileprivate init(context: Context) {
    self.context = context
  }
}

// MARK: - Owner

public protocol ContextOwner {
  var context: Context { get }
}

extension ContextOwner {
  public var types: ContextTypes {
    return self.context.types
  }
}
