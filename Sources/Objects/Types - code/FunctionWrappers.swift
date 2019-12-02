import Core

// MARK: - Function wrapper

internal protocol FunctionWrapper {
  /// The name of the built-in function/method.
  var name: String { get }
  /// Call the stored function with provided arguments.
  func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult
}

extension FunctionWrapper {

  fileprivate func isNilOrEmpty(kwargs: PyDictData?) -> Bool {
    if let kwargs = kwargs {
      return kwargs.isEmpty
    }
    return false
  }

  /// Use when you have unexpected keyword arguments.
  fileprivate func noKeywordError() -> FunctionResult {
    return .typeError("'\(self.name)' takes no keyword arguments")
  }
}

// MARK: - New

internal typealias NewFunction = (PyType, [PyObject], PyDictData?) -> PyResult<PyObject>

internal struct NewFunctionWrapper: FunctionWrapper {

  internal let typeName: String
  internal let fn: NewFunction

  internal var name: String {
    return self.typeName + ".__new__"
  }

  /// static PyObject *
  /// tp_new_wrapper(PyObject *self, PyObject *args, PyObject *kwds)
  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard args.any else {
      return .typeError("\(self.name)(): not enough arguments")
    }

    let arg0 = args[0]
    guard let type = arg0 as? PyType else {
      return .typeError("\(self.name)(X): X is not a type object (\(arg0))")
    }

    let argsWithoutType = Array(args.dropFirst())
    return self.fn(type, argsWithoutType, kwargs).asResultOrNot
  }
}

// MARK: - Unary

internal typealias UnaryFunction = (PyObject) -> FunctionResult

internal struct UnaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: UnaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    if args.count != 1 {
      let msg = "'\(self.name)' takes exactly one argument (\(args.count) given)"
      return .typeError(msg)
    }

    return self.fn(args[0])
  }
}

// MARK: - Binary

internal typealias BinaryFunction    = (PyObject, PyObject) -> FunctionResult
internal typealias BinaryFunctionOpt = (PyObject, PyObject?) -> FunctionResult

internal struct BinaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: BinaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 2:
      return self.fn(args[0], args[1])
    default:
      return .typeError("expected 2 arguments, got \(args.count)")
    }
  }
}

internal struct BinaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: BinaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 1:
      return self.fn(args[0], nil)
    case 2:
      return self.fn(args[0], args[1])
    default:
      return .typeError("expected 2 arguments, got \(args.count)")
    }
  }
}

// MARK: - Ternary

internal typealias TernaryFunction =
  (PyObject, PyObject, PyObject) -> FunctionResult
internal typealias TernaryFunctionOpt =
  (PyObject, PyObject, PyObject?) -> FunctionResult
internal typealias TernaryFunctionOptOpt =
  (PyObject, PyObject?, PyObject?) -> FunctionResult

internal struct TernaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 3:
      return self.fn(args[0], args[1], args[2])
    default:
      return .typeError("expected 3 arguments, got \(args.count)")
    }
  }
}

internal struct TernaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 2:
      return self.fn(args[0], args[1], nil)
    case 3:
      return self.fn(args[0], args[1], args[2])
    default:
      return .typeError("expected 3 arguments, got \(args.count)")
    }
  }
}

internal struct TernaryFunctionOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunctionOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 1:
      return self.fn(args[0], nil, nil)
    case 2:
      return self.fn(args[0], args[1], nil)
    case 3:
      return self.fn(args[0], args[1], args[2])
    default:
      return .typeError("expected 3 arguments, got \(args.count)")
    }
  }
}

// MARK: - Quartary

internal typealias QuartaryFunction =
  (PyObject, PyObject, PyObject, PyObject) -> FunctionResult
internal typealias QuartaryFunctionOpt =
  (PyObject, PyObject, PyObject, PyObject?) -> FunctionResult
internal typealias QuartaryFunctionOptOpt =
  (PyObject, PyObject, PyObject?, PyObject?) -> FunctionResult
internal typealias QuartaryFunctionOptOptOpt =
  (PyObject, PyObject?, PyObject?, PyObject?) -> FunctionResult

internal struct QuartaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 4:
      return self.fn(args[0], args[1], args[2], args[3])
    default:
      return .typeError("expected 4 arguments, got \(args.count)")
    }
  }
}

internal struct QuartaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 3:
      return self.fn(args[0], args[1], args[2], nil)
    case 4:
      return self.fn(args[0], args[1], args[2], args[3])
    default:
      return .typeError("expected 4 arguments, got \(args.count)")
    }
  }
}

internal struct QuartaryFunctionOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 2:
      return self.fn(args[0], args[1], nil, nil)
    case 3:
      return self.fn(args[0], args[1], args[2], nil)
    case 4:
      return self.fn(args[0], args[1], args[2], args[3])
    default:
      return .typeError("expected 4 arguments, got \(args.count)")
    }
  }
}

internal struct QuartaryFunctionOptOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOptOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard self.isNilOrEmpty(kwargs: kwargs) else {
      return self.noKeywordError()
    }

    switch args.count {
    case 1:
      return self.fn(args[0], nil, nil, nil)
    case 2:
      return self.fn(args[0], args[1], nil, nil)
    case 3:
      return self.fn(args[0], args[1], args[2], nil)
    case 4:
      return self.fn(args[0], args[1], args[2], args[3])
    default:
      return .typeError("expected 4 arguments, got \(args.count)")
    }
  }
}

// MARK: - Quintary
// We are not doing this!
// We have already gone too far with 'QuartaryFunctionOptOptOptWrapper'.
