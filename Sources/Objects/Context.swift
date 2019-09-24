// MARK: - Context

public class DummyType: PyType { }

public class Context {

  public var `true`:  PyBool { return PyBool(true) }
  public var `false`: PyBool { return PyBool(false) }

  public var none:       PyObject { return PyObject(type: DummyType()) }
  public var emptyTuple: PyObject { return PyObject(type: DummyType()) }
  public var ellipsis:   PyObject { return PyObject(type: DummyType()) }

//    pub not_implemented: PyNotImplementedRef,
  public lazy var types = ContextTypes(context: self)
//    pub exceptions: exceptions::ExceptionZoo,

  public init() { }
}

public class ContextTypes {

  private let context: Context

  public lazy var number  = PyNumberType()
  public lazy var unicode = PyUnicodeType()
  public lazy var tuple   = PyTupleType()
  public lazy var int     = PyIntType()
  public lazy var float   = PyFloatType(context: self.context)

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
