// =============================================================================
// Automatically generated from: ./Sources/Objects/Generated/FunctionWrappers.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// =============================================================================

// swiftlint:disable type_name
// swiftlint:disable identifier_name
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Wraps a Swift function callable from Python context.
///
/// Why do we need so many different signatures?
///
/// For example for ternary methods (self + 2 args) we have:
/// - (PyObject, PyObject,  PyObject) -> PyResult<PyObject>
/// - (PyObject, PyObject,  PyObject?) -> PyResult<PyObject>
/// - (PyObject, PyObject?, PyObject?) -> PyResult<PyObject>
///
/// So:
/// Some ternary (and also binary and quartary) methods can be called with
/// smaller number of arguments (in other words: some arguments are optional).
/// On the Swift side we represent this with optional arg.
///
/// For example:
/// `PyString.strip(zelf: PyObject, chars: PyObject?) -> String` has an required
/// `zelf` argument and an single optional `chars` argument.
/// When called with 1 argument we will call: `zelf: arg0, chars: nil`.
/// When called with 2 arguments we will call: `zelf: arg0, chars: arg1`.
/// When called with more than 2 arguments we will return an error (hopefully).
///
/// And of course, there are also different return types to handle…
///
/// It is also a nice test to see if Swift can properly bind correct overload of `wrap`.
/// Technically 'TernaryFunction' is super-type of 'TernaryFunction with optional',
/// because any function passed to 'TernaryFunction' can also be used in
/// 'TernaryFunction with optional' (functions are contravariant on parameter type).
public struct FunctionWrapper: CustomStringConvertible {

  // MARK: - Kind

  // Each kind holds a 'struct' with similar name in its payload.
  internal enum Kind {
  /// Python `__new__` function.
  case __new__(NewWrapper)
  /// Python `__init__` function.
  case __init__(InitWrapper)
  /// Function with `*args` and `**kwargs`.
  case argsKwargsFunction(ArgsKwargsFunction)
  /// Method with `*args` and `**kwargs`.
  case argsKwargsMethod(ArgsKwargsMethod)
  /// `(Py, PyObject) -> PyResult<PyObject>`
  case object_to_Result(Object_to_Result)
  /// `(Py, PyType) -> PyResult<PyObject>`
  case type_to_Result(Type_to_Result)
  /// `(Py, PyObject, PyObject) -> PyResult<PyObject>`
  case object_Object_to_Result(Object_Object_to_Result)
  /// `(Py, PyObject, PyObject?) -> PyResult<PyObject>`
  case object_ObjectOpt_to_Result(Object_ObjectOpt_to_Result)
  /// `(Py, PyObject?, PyObject?) -> PyResult<PyObject>`
  case objectOpt_ObjectOpt_to_Result(ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyType, PyObject) -> PyResult<PyObject>`
  case type_Object_to_Result(Type_Object_to_Result)
  /// `(Py, PyType, PyObject?) -> PyResult<PyObject>`
  case type_ObjectOpt_to_Result(Type_ObjectOpt_to_Result)
  /// `(Py, PyObject, PyObject, PyObject) -> PyResult<PyObject>`
  case object_Object_Object_to_Result(Object_Object_Object_to_Result)
  /// `(Py, PyObject, PyObject, PyObject?) -> PyResult<PyObject>`
  case object_Object_ObjectOpt_to_Result(Object_Object_ObjectOpt_to_Result)
  /// `(Py, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>`
  case object_ObjectOpt_ObjectOpt_to_Result(Object_ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  case objectOpt_ObjectOpt_ObjectOpt_to_Result(ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyType, PyObject, PyObject) -> PyResult<PyObject>`
  case type_Object_Object_to_Result(Type_Object_Object_to_Result)
  /// `(Py, PyType, PyObject, PyObject?) -> PyResult<PyObject>`
  case type_Object_ObjectOpt_to_Result(Type_Object_ObjectOpt_to_Result)
  /// `(Py, PyType, PyObject?, PyObject?) -> PyResult<PyObject>`
  case type_ObjectOpt_ObjectOpt_to_Result(Type_ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyObject, PyObject, PyObject, PyObject) -> PyResult<PyObject>`
  case object_Object_Object_Object_to_Result(Object_Object_Object_Object_to_Result)
  /// `(Py, PyObject, PyObject, PyObject, PyObject?) -> PyResult<PyObject>`
  case object_Object_Object_ObjectOpt_to_Result(Object_Object_Object_ObjectOpt_to_Result)
  /// `(Py, PyObject, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>`
  case object_Object_ObjectOpt_ObjectOpt_to_Result(Object_Object_ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyObject, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  case object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyObject?, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  case objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyType, PyObject, PyObject, PyObject) -> PyResult<PyObject>`
  case type_Object_Object_Object_to_Result(Type_Object_Object_Object_to_Result)
  /// `(Py, PyType, PyObject, PyObject, PyObject?) -> PyResult<PyObject>`
  case type_Object_Object_ObjectOpt_to_Result(Type_Object_Object_ObjectOpt_to_Result)
  /// `(Py, PyType, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>`
  case type_Object_ObjectOpt_ObjectOpt_to_Result(Type_Object_ObjectOpt_ObjectOpt_to_Result)
  /// `(Py, PyType, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  case type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result)
  }

  // MARK: - Properties

  internal let kind: Kind

  // MARK: - Name

  /// The name of the built-in function/method.
  public var name: String {
    // Just delegate to specific wrapper.
    switch self.kind {
    case let .__new__(w): return w.fnName
    case let .__init__(w): return w.fnName
    case let .argsKwargsFunction(w): return w.fnName
    case let .argsKwargsMethod(w): return w.fnName
    case let .object_to_Result(w): return w.fnName
    case let .type_to_Result(w): return w.fnName
    case let .object_Object_to_Result(w): return w.fnName
    case let .object_ObjectOpt_to_Result(w): return w.fnName
    case let .objectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .type_Object_to_Result(w): return w.fnName
    case let .type_ObjectOpt_to_Result(w): return w.fnName
    case let .object_Object_Object_to_Result(w): return w.fnName
    case let .object_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .object_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .objectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .type_Object_Object_to_Result(w): return w.fnName
    case let .type_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .type_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .object_Object_Object_Object_to_Result(w): return w.fnName
    case let .object_Object_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .object_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .type_Object_Object_Object_to_Result(w): return w.fnName
    case let .type_Object_Object_ObjectOpt_to_Result(w): return w.fnName
    case let .type_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    case let .type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.fnName
    }
  }

  // MARK: - Call

  /// Call the stored function with provided arguments.
  public func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    // Just delegate to specific wrapper.
    switch self.kind {
    case let .__new__(w): return w.call(py, args: args, kwargs: kwargs)
    case let .__init__(w): return w.call(py, args: args, kwargs: kwargs)
    case let .argsKwargsFunction(w): return w.call(py, args: args, kwargs: kwargs)
    case let .argsKwargsMethod(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_Object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_Object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_Object_Object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_Object_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_Object_Object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_Object_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_Object_Object_Object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_Object_Object_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_Object_Object_Object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_Object_Object_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_Object_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    }
  }

  // MARK: - Description

  public var description: String {
    let name = self.name
    let fn = self.describeKind()
    return "FunctionWrapper(name: \(name), fn: \(fn))"
  }

  private func describeKind() -> String {
    switch self.kind {
    case .__new__: return "(Type, *args, **kwargs) -> PyResult<PyObject>"
    case .__init__: return "(Object, *args, **kwargs) -> PyResult<PyObject>"
    case .argsKwargsFunction: return "(*args, **kwargs) -> PyResult<PyObject>"
    case .argsKwargsMethod: return "(Object, *args, **kwargs) -> PyResult<PyObject>"
    case .object_to_Result: return "(Py, PyObject) -> PyResult<PyObject>"
    case .type_to_Result: return "(Py, PyType) -> PyResult<PyObject>"
    case .object_Object_to_Result: return "(Py, PyObject, PyObject) -> PyResult<PyObject>"
    case .object_ObjectOpt_to_Result: return "(Py, PyObject, PyObject?) -> PyResult<PyObject>"
    case .objectOpt_ObjectOpt_to_Result: return "(Py, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .type_Object_to_Result: return "(Py, PyType, PyObject) -> PyResult<PyObject>"
    case .type_ObjectOpt_to_Result: return "(Py, PyType, PyObject?) -> PyResult<PyObject>"
    case .object_Object_Object_to_Result: return "(Py, PyObject, PyObject, PyObject) -> PyResult<PyObject>"
    case .object_Object_ObjectOpt_to_Result: return "(Py, PyObject, PyObject, PyObject?) -> PyResult<PyObject>"
    case .object_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .objectOpt_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .type_Object_Object_to_Result: return "(Py, PyType, PyObject, PyObject) -> PyResult<PyObject>"
    case .type_Object_ObjectOpt_to_Result: return "(Py, PyType, PyObject, PyObject?) -> PyResult<PyObject>"
    case .type_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyType, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .object_Object_Object_Object_to_Result: return "(Py, PyObject, PyObject, PyObject, PyObject) -> PyResult<PyObject>"
    case .object_Object_Object_ObjectOpt_to_Result: return "(Py, PyObject, PyObject, PyObject, PyObject?) -> PyResult<PyObject>"
    case .object_Object_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyObject, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyObject, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyObject?, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .type_Object_Object_Object_to_Result: return "(Py, PyType, PyObject, PyObject, PyObject) -> PyResult<PyObject>"
    case .type_Object_Object_ObjectOpt_to_Result: return "(Py, PyType, PyObject, PyObject, PyObject?) -> PyResult<PyObject>"
    case .type_Object_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyType, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>"
    case .type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result: return "(Py, PyType, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>"
    }
  }

  // MARK: - (Py, PyObject) -> PyResult<PyObject>

  /// Positional unary: single `self` argument.
  ///
  /// `(Py, PyObject) -> PyResult<PyObject>`
  public typealias Object_to_Result_Fn = (Py, PyObject) -> PyResult<PyObject>

  internal struct Object_to_Result {
    private let fn: Object_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        return self.fn(py, args[0])
      default:
        return .typeError(py, message: "'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_to_Result_Fn ) {
    let wrapper = Object_to_Result(name: name, fn: fn)
    self.kind = .object_to_Result(wrapper)
  }

  // MARK: - (Py, PyType) -> PyResult<PyObject>

  /// Positional unary: `classmethod` with no arguments.
  ///
  /// `(Py, PyType) -> PyResult<PyObject>`
  public typealias Type_to_Result_Fn = (Py, PyType) -> PyResult<PyObject>

  internal struct Type_to_Result {
    private let fn: Type_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 1:
        return self.fn(py, type)
      default:
        return .typeError(py, message: "'\(self.fnName)' takes exactly one argument (\(args.count) given)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_to_Result_Fn ) {
    let wrapper = Type_to_Result(name: name, fn: fn)
    self.kind = .type_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject) -> PyResult<PyObject>

  /// Positional binary: `self` and `object`.
  ///
  /// `(Py, PyObject, PyObject) -> PyResult<PyObject>`
  public typealias Object_Object_to_Result_Fn = (Py, PyObject, PyObject) -> PyResult<PyObject>

  internal struct Object_Object_to_Result {
    private let fn: Object_Object_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_Object_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 2:
        return self.fn(py, args[0], args[1])
      default:
        return .typeError(py, message: "expected 2 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_Object_to_Result_Fn ) {
    let wrapper = Object_Object_to_Result(name: name, fn: fn)
    self.kind = .object_Object_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject?) -> PyResult<PyObject>

  /// Positional binary: `self` and optional `object`.
  ///
  /// `(Py, PyObject, PyObject?) -> PyResult<PyObject>`
  public typealias Object_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject?) -> PyResult<PyObject>

  internal struct Object_ObjectOpt_to_Result {
    private let fn: Object_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        return self.fn(py, args[0], nil)
      case 2:
        return self.fn(py, args[0], args[1])
      default:
        return .typeError(py, message: "expected 2 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_ObjectOpt_to_Result_Fn ) {
    let wrapper = Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional binary: 2 `objects` (both optional).
  ///
  /// `(Py, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct ObjectOpt_ObjectOpt_to_Result {
    private let fn: ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 0:
        return self.fn(py, nil, nil)
      case 1:
        return self.fn(py, args[0], nil)
      case 2:
        return self.fn(py, args[0], args[1])
      default:
        return .typeError(py, message: "expected 2 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject) -> PyResult<PyObject>

  /// Positional binary: `classmethod` with a single argument.
  ///
  /// `(Py, PyType, PyObject) -> PyResult<PyObject>`
  public typealias Type_Object_to_Result_Fn = (Py, PyType, PyObject) -> PyResult<PyObject>

  internal struct Type_Object_to_Result {
    private let fn: Type_Object_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_Object_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 2:
        return self.fn(py, type, args[1])
      default:
        return .typeError(py, message: "expected 2 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_Object_to_Result_Fn ) {
    let wrapper = Type_Object_to_Result(name: name, fn: fn)
    self.kind = .type_Object_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject?) -> PyResult<PyObject>

  /// Positional binary: `classmethod` with a single optional argument.
  ///
  /// `(Py, PyType, PyObject?) -> PyResult<PyObject>`
  public typealias Type_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject?) -> PyResult<PyObject>

  internal struct Type_ObjectOpt_to_Result {
    private let fn: Type_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 1:
        return self.fn(py, type, nil)
      case 2:
        return self.fn(py, type, args[1])
      default:
        return .typeError(py, message: "expected 2 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_ObjectOpt_to_Result_Fn ) {
    let wrapper = Type_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .type_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject, PyObject) -> PyResult<PyObject>

  /// Positional ternary: `self` and 2 `objects`.
  ///
  /// `(Py, PyObject, PyObject, PyObject) -> PyResult<PyObject>`
  public typealias Object_Object_Object_to_Result_Fn = (Py, PyObject, PyObject, PyObject) -> PyResult<PyObject>

  internal struct Object_Object_Object_to_Result {
    private let fn: Object_Object_Object_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_Object_Object_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 3:
        return self.fn(py, args[0], args[1], args[2])
      default:
        return .typeError(py, message: "expected 3 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_Object_Object_to_Result_Fn ) {
    let wrapper = Object_Object_Object_to_Result(name: name, fn: fn)
    self.kind = .object_Object_Object_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject, PyObject?) -> PyResult<PyObject>

  /// Positional ternary: `self` and 2 `objects` (last one is optional).
  ///
  /// `(Py, PyObject, PyObject, PyObject?) -> PyResult<PyObject>`
  public typealias Object_Object_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject, PyObject?) -> PyResult<PyObject>

  internal struct Object_Object_ObjectOpt_to_Result {
    private let fn: Object_Object_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_Object_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 2:
        return self.fn(py, args[0], args[1], nil)
      case 3:
        return self.fn(py, args[0], args[1], args[2])
      default:
        return .typeError(py, message: "expected 3 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_Object_ObjectOpt_to_Result_Fn ) {
    let wrapper = Object_Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional ternary: `self` and 2 `objects` (both optional).
  ///
  /// `(Py, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias Object_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct Object_ObjectOpt_ObjectOpt_to_Result {
    private let fn: Object_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        return self.fn(py, args[0], nil, nil)
      case 2:
        return self.fn(py, args[0], args[1], nil)
      case 3:
        return self.fn(py, args[0], args[1], args[2])
      default:
        return .typeError(py, message: "expected 3 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = Object_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional ternary: 3 `objects` (all optional).
  ///
  /// `(Py, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    private let fn: ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 0:
        return self.fn(py, nil, nil, nil)
      case 1:
        return self.fn(py, args[0], nil, nil)
      case 2:
        return self.fn(py, args[0], args[1], nil)
      case 3:
        return self.fn(py, args[0], args[1], args[2])
      default:
        return .typeError(py, message: "expected 3 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject, PyObject) -> PyResult<PyObject>

  /// Positional ternary: `classmethod` with 2 arguments.
  ///
  /// `(Py, PyType, PyObject, PyObject) -> PyResult<PyObject>`
  public typealias Type_Object_Object_to_Result_Fn = (Py, PyType, PyObject, PyObject) -> PyResult<PyObject>

  internal struct Type_Object_Object_to_Result {
    private let fn: Type_Object_Object_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_Object_Object_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 3:
        return self.fn(py, type, args[1], args[2])
      default:
        return .typeError(py, message: "expected 3 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_Object_Object_to_Result_Fn ) {
    let wrapper = Type_Object_Object_to_Result(name: name, fn: fn)
    self.kind = .type_Object_Object_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject, PyObject?) -> PyResult<PyObject>

  /// Positional ternary: `classmethod` with 2 arguments (last one is optional).
  ///
  /// `(Py, PyType, PyObject, PyObject?) -> PyResult<PyObject>`
  public typealias Type_Object_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject, PyObject?) -> PyResult<PyObject>

  internal struct Type_Object_ObjectOpt_to_Result {
    private let fn: Type_Object_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_Object_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 2:
        return self.fn(py, type, args[1], nil)
      case 3:
        return self.fn(py, type, args[1], args[2])
      default:
        return .typeError(py, message: "expected 3 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_Object_ObjectOpt_to_Result_Fn ) {
    let wrapper = Type_Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .type_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional ternary: `classmethod` with 2 arguments (both optional).
  ///
  /// `(Py, PyType, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias Type_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct Type_ObjectOpt_ObjectOpt_to_Result {
    private let fn: Type_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 1:
        return self.fn(py, type, nil, nil)
      case 2:
        return self.fn(py, type, args[1], nil)
      case 3:
        return self.fn(py, type, args[1], args[2])
      default:
        return .typeError(py, message: "expected 3 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = Type_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .type_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject, PyObject, PyObject) -> PyResult<PyObject>

  /// Positional quartary: `self` and 3 `objects`.
  ///
  /// `(Py, PyObject, PyObject, PyObject, PyObject) -> PyResult<PyObject>`
  public typealias Object_Object_Object_Object_to_Result_Fn = (Py, PyObject, PyObject, PyObject, PyObject) -> PyResult<PyObject>

  internal struct Object_Object_Object_Object_to_Result {
    private let fn: Object_Object_Object_Object_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_Object_Object_Object_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 4:
        return self.fn(py, args[0], args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_Object_Object_Object_to_Result_Fn ) {
    let wrapper = Object_Object_Object_Object_to_Result(name: name, fn: fn)
    self.kind = .object_Object_Object_Object_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject, PyObject, PyObject?) -> PyResult<PyObject>

  /// Positional quartary: `self` and 3 `objects` (last one is optional).
  ///
  /// `(Py, PyObject, PyObject, PyObject, PyObject?) -> PyResult<PyObject>`
  public typealias Object_Object_Object_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject, PyObject, PyObject?) -> PyResult<PyObject>

  internal struct Object_Object_Object_ObjectOpt_to_Result {
    private let fn: Object_Object_Object_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_Object_Object_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 3:
        return self.fn(py, args[0], args[1], args[2], nil)
      case 4:
        return self.fn(py, args[0], args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_Object_Object_ObjectOpt_to_Result_Fn ) {
    let wrapper = Object_Object_Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_Object_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional quartary: `self` and 3 `objects` (2nd and 3rd are optional).
  ///
  /// `(Py, PyObject, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct Object_Object_ObjectOpt_ObjectOpt_to_Result {
    private let fn: Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 2:
        return self.fn(py, args[0], args[1], nil, nil)
      case 3:
        return self.fn(py, args[0], args[1], args[2], nil)
      case 4:
        return self.fn(py, args[0], args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = Object_Object_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_Object_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional quartary: `self` and 3 `objects` (all optional).
  ///
  /// `(Py, PyObject, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    private let fn: Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        return self.fn(py, args[0], nil, nil, nil)
      case 2:
        return self.fn(py, args[0], args[1], nil, nil)
      case 3:
        return self.fn(py, args[0], args[1], args[2], nil)
      case 4:
        return self.fn(py, args[0], args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyObject?, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional quartary: `4 `objects` (all optional).
  ///
  /// `(Py, PyObject?, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject?, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    private let fn: ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 0:
        return self.fn(py, nil, nil, nil, nil)
      case 1:
        return self.fn(py, args[0], nil, nil, nil)
      case 2:
        return self.fn(py, args[0], args[1], nil, nil)
      case 3:
        return self.fn(py, args[0], args[1], args[2], nil)
      case 4:
        return self.fn(py, args[0], args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .objectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject, PyObject, PyObject) -> PyResult<PyObject>

  /// Positional quartary: `classmethod` with 3 arguments.
  ///
  /// `(Py, PyType, PyObject, PyObject, PyObject) -> PyResult<PyObject>`
  public typealias Type_Object_Object_Object_to_Result_Fn = (Py, PyType, PyObject, PyObject, PyObject) -> PyResult<PyObject>

  internal struct Type_Object_Object_Object_to_Result {
    private let fn: Type_Object_Object_Object_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_Object_Object_Object_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 4:
        return self.fn(py, type, args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_Object_Object_Object_to_Result_Fn ) {
    let wrapper = Type_Object_Object_Object_to_Result(name: name, fn: fn)
    self.kind = .type_Object_Object_Object_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject, PyObject, PyObject?) -> PyResult<PyObject>

  /// Positional quartary: `classmethod` with 3 arguments (last one is optional).
  ///
  /// `(Py, PyType, PyObject, PyObject, PyObject?) -> PyResult<PyObject>`
  public typealias Type_Object_Object_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject, PyObject, PyObject?) -> PyResult<PyObject>

  internal struct Type_Object_Object_ObjectOpt_to_Result {
    private let fn: Type_Object_Object_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_Object_Object_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 3:
        return self.fn(py, type, args[1], args[2], nil)
      case 4:
        return self.fn(py, type, args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_Object_Object_ObjectOpt_to_Result_Fn ) {
    let wrapper = Type_Object_Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .type_Object_Object_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional quartary: `classmethod` with 3 arguments (2nd and 3rd are optional).
  ///
  /// `(Py, PyType, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias Type_Object_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct Type_Object_ObjectOpt_ObjectOpt_to_Result {
    private let fn: Type_Object_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_Object_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 2:
        return self.fn(py, type, args[1], nil, nil)
      case 3:
        return self.fn(py, type, args[1], args[2], nil)
      case 4:
        return self.fn(py, type, args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_Object_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = Type_Object_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .type_Object_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

  // MARK: - (Py, PyType, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  /// Positional quartary: `classmethod` with 3 arguments (all optional).
  ///
  /// `(Py, PyType, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>`
  public typealias Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject?, PyObject?, PyObject?) -> PyResult<PyObject>

  internal struct Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result {
    private let fn: Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      // This function has a 'type' argument that we have to cast
      guard args.any else {
        return .typeError(py, message: "\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let type = py.cast.asType(arg0) else {
        return .typeError(py, message: "\(self.fnName)(X): X is not a type object (\(arg0.typeName))")
      }

      switch args.count {
      case 1:
        return self.fn(py, type, nil, nil, nil)
      case 2:
        return self.fn(py, type, args[1], nil, nil)
      case 3:
        return self.fn(py, type, args[1], args[2], nil)
      case 4:
        return self.fn(py, type, args[1], args[2], args[3])
      default:
        return .typeError(py, message: "expected 4 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn ) {
    let wrapper = Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result(wrapper)
  }

}
