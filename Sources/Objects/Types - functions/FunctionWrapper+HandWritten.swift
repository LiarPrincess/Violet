// Most of this type body is inside '/Generated/FunctionWrapper.swift'.
// Here we have only the hand-written cases.
extension FunctionWrapper {

  // MARK: - New

  /// Python `__new__` function.
  internal typealias NewFn = (Py, PyType, [PyObject], PyDict?) -> PyResult<PyObject>

  internal struct NewWrapper {
    private let fn: NewFn
    private let type: PyType
    internal let fnName: String

    fileprivate init(type: PyType, fn: @escaping NewFn) {
      let typeName = type.getNameString()
      self.fn = fn
      self.type = type
      self.fnName = typeName + ".__new__"
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      guard args.any else {
        let message = "\(self.fnName)(): not enough arguments"
        return .typeError(py, message: message)
      }

      let arg0 = args[0]
      guard let subtype = py.cast.asType(arg0) else {
        let message = "\(self.fnName)(X): X is not a type object (\(arg0))"
        return .typeError(py, message: message)
      }

      // For example: type(int).__new__(None)
      guard subtype.isSubtype(of: self.type) else {
        let t = self.type.getNameString()
        let s = subtype.getNameString()
        let message = "\(t).__new__(\(s)): \(s) is not a subtype of \(t)"
        return .typeError(py, message: message)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      let argsWithoutType = Array(args.dropFirst())
      return self.fn(py, subtype, argsWithoutType, kwargs)
    }
  }

  internal init(type: PyType, fn: @escaping NewFn) {
    let wrapper = NewWrapper(type: type, fn: fn)
    self.kind = .__new__(wrapper)
  }

  // MARK: - Init

  /// Python `__init__` function.
  internal typealias InitFn = (Py, PyObject, [PyObject], PyDict?) -> PyResult<PyObject>

  internal struct InitWrapper {
    private let fn: InitFn
    internal let fnName: String

    fileprivate init(type: PyType, fn: @escaping InitFn) {
      let typeName = type.getNameString()
      self.fn = fn
      self.fnName = typeName + ".__init__"
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      let zelf = args[0]
      let argsWithoutZelf = Array(args.dropFirst())
      return self.fn(py, zelf, argsWithoutZelf, kwargs)
    }
  }

  internal init(type: PyType, fn: @escaping InitFn) {
    let wrapper = InitWrapper(type: type, fn: fn)
    self.kind = .__init__(wrapper)
  }

  // MARK: - Args kwargs method

  /// Function with *args and **kwargs.
  internal typealias ArgsKwargsMethodFn = (Py, PyObject, [PyObject], PyDict?) -> PyResult<PyObject>

  internal struct ArgsKwargsMethod {
    internal let fnName: String
    private let fn: ArgsKwargsMethodFn

    fileprivate init(name: String, fn: @escaping ArgsKwargsMethodFn) {
      self.fn = fn
      self.fnName = name
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      let arg0 = args[0]
      let argsWithoutArg0 = Array(args.dropFirst())
      return self.fn(py, arg0, argsWithoutArg0, kwargs)
    }
  }

  internal init(name: String, fn: @escaping ArgsKwargsMethodFn) {
    let wrapper = ArgsKwargsMethod(name: name, fn: fn)
    self.kind = .argsKwargsMethod(wrapper)
  }

  // MARK: - Args kwargs function

  /// Function with *args and **kwargs.
  internal typealias ArgsKwargsFunctionFn = (Py, [PyObject], PyDict?) -> PyResult<PyObject>

  internal struct ArgsKwargsFunction {
    private let fn: ArgsKwargsFunctionFn
    internal let fnName: String

    fileprivate init(name: String, fn: @escaping ArgsKwargsFunctionFn) {
      self.fnName = name
      self.fn = fn
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      return self.fn(py, args, kwargs)
    }
  }

  internal init(name: String, fn: @escaping ArgsKwargsFunctionFn) {
    let wrapper = ArgsKwargsFunction(name: name, fn: fn)
    self.kind = .argsKwargsFunction(wrapper)
  }
}
