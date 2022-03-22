// Most of this type body is inside '/Generated/FunctionWrapper.swift'.
// Here we have only the hand-written cases.
extension FunctionWrapper {

  // MARK: - New

  /// Python `__new__` function.
  public typealias NewFn = (Py, PyType, [PyObject], PyDict?) -> PyResult

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

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
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

  public init(type: PyType, fn: @escaping NewFn) {
    let wrapper = NewWrapper(type: type, fn: fn)
    self.kind = .new(wrapper)
  }

  // MARK: - Init

  /// Python `__init__` function.
  public typealias InitFn = (Py, PyObject, [PyObject], PyDict?) -> PyResult

  internal struct InitWrapper {
    private let fn: InitFn
    internal let fnName: String

    fileprivate init(type: PyType, fn: @escaping InitFn) {
      let typeName = type.getNameString()
      self.fn = fn
      self.fnName = typeName + ".__init__"
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      let zelf = args[0]
      let argsWithoutZelf = Array(args.dropFirst())
      return self.fn(py, zelf, argsWithoutZelf, kwargs)
    }
  }

  public init(type: PyType, fn: @escaping InitFn) {
    let wrapper = InitWrapper(type: type, fn: fn)
    self.kind = .`init`(wrapper)
  }

  // MARK: - Compare

  /// Python `__eq__`, `__ne__`, `__lt__`, `__le__`, `__gt__`, `__ge__` functions.
  public typealias CompareFn = (Py, PyObject, PyObject) -> CompareResult

  internal struct CompareWrapper {
    private let fn: CompareFn
    internal let fnName: String

    fileprivate init(name: String, fn: @escaping CompareFn) {
      self.fnName = name
      self.fn = fn
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 2:
        let result = self.fn(py, args[0], args[1])
        return PyResult(py, result)
      default:
        return .typeError(py, message: "expected 2 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping CompareFn) {
    let wrapper = CompareWrapper(name: name, fn: fn)
    self.kind = .compare(wrapper)
  }

  // MARK: - Hash

  /// Python `__hash__` function.
  public typealias HashFn = (Py, PyObject) -> HashResult

  internal struct HashWrapper {
    private let fn: HashFn
    internal let fnName: String

    fileprivate init(name: String, fn: @escaping HashFn) {
      self.fnName = name
      self.fn = fn
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        let result = self.fn(py, args[0])
        return PyResult(py, result)
      default:
        return .typeError(py, message: "expected 1 argument, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping HashFn) {
    let wrapper = HashWrapper(name: name, fn: fn)
    self.kind = .hash(wrapper)
  }

  // MARK: - Dir

  /// Python `__dir__` function.
  public typealias DirFn = (Py, PyObject) -> PyResultGen<DirResult>

  internal struct DirWrapper {
    private let fn: DirFn
    internal let fnName: String

    fileprivate init(name: String, fn: @escaping DirFn) {
      self.fnName = name
      self.fn = fn
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        let result = self.fn(py, args[0])
        return PyResult(py, result)
      default:
        return .typeError(py, message: "expected 1 argument, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping DirFn) {
    let wrapper = DirWrapper(name: name, fn: fn)
    self.kind = .dir(wrapper)
  }

  // MARK: - Class

  /// Python `__class__` function.
  public typealias ClassFn = (Py, PyObject) -> PyType

  internal struct ClassWrapper {
    private let fn: ClassFn
    internal let fnName: String

    fileprivate init(name: String, fn: @escaping ClassFn) {
      self.fnName = name
      self.fn = fn
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        let result = self.fn(py, args[0])
        return PyResult(result)
      default:
        return .typeError(py, message: "expected 1 argument, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping ClassFn) {
    let wrapper = ClassWrapper(name: name, fn: fn)
    self.kind = .class(wrapper)
  }

  // MARK: - Args kwargs function

  /// Function with *args and **kwargs.
  public typealias ArgsKwargsFunction = (Py, [PyObject], PyDict?) -> PyResult

  internal struct ArgsKwargsFunctionWrapper {
    private let fn: ArgsKwargsFunction
    internal let fnName: String

    fileprivate init(name: String, fn: @escaping ArgsKwargsFunction) {
      self.fnName = name
      self.fn = fn
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      return self.fn(py, args, kwargs)
    }
  }

  public init(name: String, fn: @escaping ArgsKwargsFunction) {
    let wrapper = ArgsKwargsFunctionWrapper(name: name, fn: fn)
    self.kind = .argsKwargsFunction(wrapper)
  }

  // MARK: - Args kwargs method

  /// Function with *args and **kwargs.
  public typealias ArgsKwargsMethod = (Py, PyObject, [PyObject], PyDict?) -> PyResult

  internal struct ArgsKwargsMethodWrapper {
    internal let fnName: String
    private let fn: ArgsKwargsMethod

    fileprivate init(name: String, fn: @escaping ArgsKwargsMethod) {
      self.fn = fn
      self.fnName = name
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      let argsWithoutArg0 = Array(args.dropFirst())
      return self.fn(py, arg0, argsWithoutArg0, kwargs)
    }
  }

  public init(name: String, fn: @escaping ArgsKwargsMethod) {
    let wrapper = ArgsKwargsMethodWrapper(name: name, fn: fn)
    self.kind = .argsKwargsMethod(wrapper)
  }

  // MARK: - Args kwargs class method

  /// Function with *args and **kwargs.
  public typealias ArgsKwargsClassMethod = (Py, PyType, [PyObject], PyDict?) -> PyResult

  internal struct ArgsKwargsClassMethodWrapper {
    internal let fnName: String
    private let fn: ArgsKwargsClassMethod

    fileprivate init(name: String, fn: @escaping ArgsKwargsClassMethod) {
      self.fn = fn
      self.fnName = name
    }

    internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      // This function has a 'type' argument that we have to cast
      let type: PyType
      switch FunctionWrapper.handleTypeArgument(py, fnName: self.fnName, args: args) {
      case let .value(t): type = t
      case let .error(e): return .error(e)
      }

      let argsWithoutType = Array(args.dropFirst())
      return self.fn(py, type, argsWithoutType, kwargs)
    }
  }

  public init(name: String, fn: @escaping ArgsKwargsClassMethod) {
    let wrapper = ArgsKwargsClassMethodWrapper(name: name, fn: fn)
    self.kind = .argsKwargsClassMethod(wrapper)
  }
}
