import Core

// swiftlint:disable file_length

// MARK: - Function wrapper

internal protocol FunctionWrapper {
  /// The name of the built-in function/method.
  var name: String { get }
  /// Call the stored function with provided arguments.
  func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult
}

// MARK: - New

internal typealias NewFunction = (PyType, [PyObject], PyDictData?) -> PyResult<PyObject>

/// Wrapper dedicated to `__new__` function
internal struct NewFunctionWrapper: FunctionWrapper {

  internal let type: PyType
  internal let fn: NewFunction

  internal var name: String {
    return "__new__"
  }

  /// static PyObject *
  /// tp_new_wrapper(PyObject *self, PyObject *args, PyObject *kwds)
  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    guard args.any else {
      return .typeError("\(self.name)(): not enough arguments")
    }

    let arg0 = args[0]
    guard let subtype = arg0 as? PyType else {
      return .typeError("\(self.name)(X): X is not a type object (\(arg0))")
    }

    // For example: type(int).__new__(None)
    guard subtype.isSubtype(of: self.type) else {
      let t = self.type.getName()
      let s = subtype.getName()
      return .typeError("\(t).__new__(\(s)): \(s) is not a subtype of \(t)")
    }

    let argsWithoutType = Array(args.dropFirst())
    return self.fn(subtype, argsWithoutType, kwargs)
  }
}

// MARK: - Init

internal typealias InitFunction<Zelf: PyObject> =
  (Zelf, [PyObject], PyDictData?) -> PyResult<PyNone>

/// Wrapper dedicated to `__init__` function
internal struct InitFunctionWrapper: FunctionWrapper {

  internal let type: PyType
  internal let fn: InitFunction<PyObject>

  internal var name: String {
    return "__init__"
  }

  internal init<Zelf: PyObject>(type: PyType,
                                fn: @escaping InitFunction<Zelf>) {
    self.type = type
    self.fn = InitFunctionWrapper.eraseZelf(type: type, fn: fn)
  }

  /// Convert from `InitFunction<Zelf>` to `InitFunction<PyObject>`
  private static func eraseZelf<Zelf: PyObject>(
    type: PyType,
    fn: @escaping InitFunction<Zelf>) -> InitFunction<PyObject> {

    return { (object: PyObject, args: [PyObject], kwargs: PyDictData?) -> PyResult<PyNone> in
      guard let zelf = object as? Zelf else {
        return .typeError(
          "descriptor '__init__' requires a '\(type.getName())' object " +
          "but received a '\(object.type)'")
      }

      return fn(zelf, args, kwargs)
    }
  }

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    guard args.any else {
      return .typeError("\(self.name)(): not enough arguments")
    }

    let zelf = args[0]
    let argsWithoutZelf = Array(args.dropFirst())
    return self.fn(zelf, argsWithoutZelf, kwargs).map { $0 as PyObject }
  }
}

// MARK: - Args kwargs function

internal typealias ArgsKwargsFunction =
  ([PyObject], PyDictData?) -> PyFunctionResult

/// Wrapper dedicated to function that takes `args` and `kwargs` arguments.
internal struct ArgsKwargsFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: ArgsKwargsFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    return self.fn(args, kwargs)
  }
}

// MARK: - Args kwargs method

internal typealias ArgsKwargsMethod =
  (PyObject, [PyObject], PyDictData?) -> PyFunctionResult

/// Wrapper dedicated to method that takes `args` and `kwargs` arguments.
/// First argument in `args` will be treeated as `self`.
internal struct ArgsKwargsMethodWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: ArgsKwargsMethod

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    guard args.any else {
      return .typeError("\(self.name)(): not enough arguments")
    }

    let zelf = args[0]
    let argsWithoutZelf = Array(args.dropFirst())
    return self.fn(zelf, argsWithoutZelf, kwargs)
  }
}

// MARK: - Positional nullary

internal typealias NullaryFunction = () -> PyFunctionResult

/// Wrapper dedicated to method that takes no arguments.
internal struct NullaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: NullaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if args.any {
      let msg = "'\(self.name)' takes no arguments (\(args.count) given)"
      return .typeError(msg)
    }

    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
    }

    return self.fn()
  }
}

// MARK: - Positional unary

internal typealias UnaryFunction = (PyObject) -> PyFunctionResult

/// Wrapper dedicated to method that takes 1 arguments.
internal struct UnaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: UnaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if args.count != 1 {
      let msg = "'\(self.name)' takes exactly one argument (\(args.count) given)"
      return .typeError(msg)
    }

    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
    }

    return self.fn(args[0])
  }
}

// MARK: - Positional binary

internal typealias BinaryFunction    = (PyObject, PyObject) -> PyFunctionResult
internal typealias BinaryFunctionOpt = (PyObject, PyObject?) -> PyFunctionResult

/// Wrapper dedicated to method that takes 2 arguments.
internal struct BinaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: BinaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
    }

    switch args.count {
    case 2:
      return self.fn(args[0], args[1])
    default:
      return .typeError("expected 2 arguments, got \(args.count)")
    }
  }
}

/// Wrapper dedicated to method that takes 2 arguments (1 of them is optional).
internal struct BinaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: BinaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
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

// MARK: - Positional ternary

internal typealias TernaryFunction =
  (PyObject, PyObject, PyObject) -> PyFunctionResult
internal typealias TernaryFunctionOpt =
  (PyObject, PyObject, PyObject?) -> PyFunctionResult
internal typealias TernaryFunctionOptOpt =
  (PyObject, PyObject?, PyObject?) -> PyFunctionResult

/// Wrapper dedicated to method that takes 3 arguments.
internal struct TernaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
    }

    switch args.count {
    case 3:
      return self.fn(args[0], args[1], args[2])
    default:
      return .typeError("expected 3 arguments, got \(args.count)")
    }
  }
}

/// Wrapper dedicated to method that takes 3 arguments (1 of them is optional).
internal struct TernaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
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

/// Wrapper dedicated to method that takes 3 arguments (2 of them are optional).
internal struct TernaryFunctionOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunctionOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
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

// MARK: - Positional quartary

internal typealias QuartaryFunction =
  (PyObject, PyObject, PyObject, PyObject) -> PyFunctionResult
internal typealias QuartaryFunctionOpt =
  (PyObject, PyObject, PyObject, PyObject?) -> PyFunctionResult
internal typealias QuartaryFunctionOptOpt =
  (PyObject, PyObject, PyObject?, PyObject?) -> PyFunctionResult
internal typealias QuartaryFunctionOptOptOpt =
  (PyObject, PyObject?, PyObject?, PyObject?) -> PyFunctionResult

/// Wrapper dedicated to method that takes 4 arguments.
internal struct QuartaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
    }

    switch args.count {
    case 4:
      return self.fn(args[0], args[1], args[2], args[3])
    default:
      return .typeError("expected 4 arguments, got \(args.count)")
    }
  }
}

/// Wrapper dedicated to method that takes 4 arguments (1 of them is optional).
internal struct QuartaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
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

/// Wrapper dedicated to method that takes 4 arguments (2 of them are optional).
internal struct QuartaryFunctionOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
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

/// Wrapper dedicated to method that takes 4 arguments (3 of them are optional).
internal struct QuartaryFunctionOptOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOptOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
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

// MARK: - Positional quintary
// We are not doing this!
// We have already gone too far with 'QuartaryFunctionOptOptOptWrapper'.
