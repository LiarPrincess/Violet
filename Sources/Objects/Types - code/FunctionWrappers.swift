import Core

// swiftlint:disable file_length

// MARK: - Function wrapper

internal protocol FunctionWrapper {
  /// The name of the built-in function/method.
  var name: String { get }
  /// Call the stored function with provided arguments.
  func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult
}

// MARK: - New

internal typealias NewFunction = (PyType, [PyObject], PyDictData?) -> PyResult<PyObject>

// TODO: Add 'tp_new_wrapper(PyObject *self, PyObject *args, PyObject *kwds)' + init
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

// MARK: - Init

internal typealias InitFunction<Zelf: PyObject> =
  (Zelf, [PyObject], PyDictData?) -> PyResult<PyNone>

internal struct InitFunctionWrapper: FunctionWrapper {

  internal let typeName: String
  internal let fn: InitFunction<PyObject>

  internal var name: String {
    return self.typeName + ".__init__"
  }

  internal init<Zelf: PyObject>(typeName: String,
                                fn: @escaping InitFunction<Zelf>) {
    self.typeName = typeName
    self.fn = InitFunctionWrapper.downcastZelf(typeName: typeName, fn: fn)
  }

  private static func downcastZelf<Zelf: PyObject>(
    typeName: String,
    fn: @escaping InitFunction<Zelf>) -> InitFunction<PyObject> {

    return { (object: PyObject, args: [PyObject], kwargs: PyDictData?) -> PyResult<PyNone> in
      guard let zelf = object as? Zelf else {
        return .typeError(
          "descriptor '__init__' requires a '\(typeName)' object " +
          "but received a '\(object.type)'")
      }

      return fn(zelf, args, kwargs)
    }
  }

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard args.any else {
      return .typeError("\(self.name)(): not enough arguments")
    }

    let arg0 = args[0]
    guard let type = arg0 as? PyType else {
      return .typeError("\(self.name)(X): X is not a type object (\(arg0))")
    }

    let argsWithoutType = Array(args.dropFirst())
    return self.fn(type, argsWithoutType, kwargs)
      .map { $0 as PyObject }
      .asResultOrNot
  }
}

// MARK: - Args kwargs

internal typealias ArgsKwargsFunction =
  (PyObject, [PyObject], PyDictData?) -> FunctionResult

internal struct ArgsKwargsFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: ArgsKwargsFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    guard args.any else {
      return .typeError("\(self.name)(): not enough arguments")
    }

    let zelf = args[0]
    let argsWithoutZelf = Array(args.dropFirst())
    return self.fn(zelf, argsWithoutZelf, kwargs)
  }
}

// MARK: - Positional unary

internal typealias UnaryFunction = (PyObject) -> FunctionResult

internal struct UnaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: UnaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
    }

    if args.count != 1 {
      let msg = "'\(self.name)' takes exactly one argument (\(args.count) given)"
      return .typeError(msg)
    }

    return self.fn(args[0])
  }
}

// MARK: - Positional binary

internal typealias BinaryFunction    = (PyObject, PyObject) -> FunctionResult
internal typealias BinaryFunctionOpt = (PyObject, PyObject?) -> FunctionResult

internal struct BinaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: BinaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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

internal struct BinaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: BinaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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
  (PyObject, PyObject, PyObject) -> FunctionResult
internal typealias TernaryFunctionOpt =
  (PyObject, PyObject, PyObject?) -> FunctionResult
internal typealias TernaryFunctionOptOpt =
  (PyObject, PyObject?, PyObject?) -> FunctionResult

internal struct TernaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunction

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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

internal struct TernaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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

internal struct TernaryFunctionOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: TernaryFunctionOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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

internal struct QuartaryFunctionOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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

internal struct QuartaryFunctionOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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

internal struct QuartaryFunctionOptOptOptWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: QuartaryFunctionOptOptOpt

  internal func call(args: [PyObject], kwargs: PyDictData?) -> FunctionResult {
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
