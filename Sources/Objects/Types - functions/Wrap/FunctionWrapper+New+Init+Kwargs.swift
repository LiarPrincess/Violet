// Most of this type body is inside '/Generated/FunctionWrapper.swift'.
// Here we have only the hand-written cases.
extension FunctionWrapper {

  // MARK: - New

  /// Python `__new__` function.
  internal typealias NewFn<Zelf: PyObject> =
    (PyType, [PyObject], PyDict?) -> PyResult<Zelf>

  internal struct New {
    private let type: PyType
    private let fn: NewFn<PyObject>

    internal var fnName: String {
      let typeName = self.type.getNameString()
      return typeName + ".__new__"
    }

    fileprivate init<Zelf>(type: PyType, fn: @escaping NewFn<Zelf>) {
      self.type = type
      self.fn = { (type: PyType, args: [PyObject], kwargs: PyDict?) -> PyFunctionResult in
        // This function returns PyResult<Zelf>,
        // we just need to convert it to PyResult<PyObject>
        let resultAsZelf = fn(type, args, kwargs)
        return resultAsZelf.map { $0 as PyObject }
      }
    }

    internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      guard args.any else {
        return .typeError("\(self.fnName)(): not enough arguments")
      }

      let arg0 = args[0]
      guard let subtype = PyCast.asType(arg0) else {
        return .typeError("\(self.fnName)(X): X is not a type object (\(arg0))")
      }

      // For example: type(int).__new__(None)
      guard subtype.isSubtype(of: self.type) else {
        let t = self.type.getNameString()
        let s = subtype.getNameString()
        return .typeError("\(t).__new__(\(s)): \(s) is not a subtype of \(t)")
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      let argsWithoutType = Array(args.dropFirst())
      return self.fn(subtype, argsWithoutType, kwargs)
    }
  }

  internal init<Zelf>(type: PyType, newFn: @escaping NewFn<Zelf>) {
    let wrapper = New(type: type, fn: newFn)
    self.kind = .new(wrapper)
  }

  // MARK: - Init

  /// Python `__init__` function.
  internal typealias InitAsMethodFn<Zelf: PyObject> =
    (Zelf) -> ([PyObject], PyDict?) -> PyResult<PyNone>

  /// Python `__init__` function.
  internal typealias InitAsStaticFunctionFn<Zelf: PyObject> =
    (Zelf, [PyObject], PyDict?) -> PyResult<PyNone>

  internal struct Init {
    internal let fnName: String
    private let fn: InitAsStaticFunctionFn<PyObject>

    fileprivate init<Zelf: PyObject>(
      type: PyType,
      fn: @escaping InitAsMethodFn<Zelf>,
      castSelf: @escaping CastSelfOptional<Zelf>
    ) {
      let (typeName, fnName) = Self.getTypeNameAndFnName(type: type)

      self.fnName = fnName
      self.fn = { (arg0: PyObject, args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> in
        guard let zelf = castSelf(arg0) else {
          return Self.createInvalidArg0TypeError(expectedType: typeName, arg0: arg0)
        }

        let result = fn(zelf)(args, kwargs)
        return result
      }
    }

    fileprivate init<Zelf: PyObject>(
      type: PyType,
      fn: @escaping InitAsStaticFunctionFn<Zelf>,
      castSelf: @escaping CastSelfOptional<Zelf>
    ) {
      let (typeName, fnName) = Self.getTypeNameAndFnName(type: type)

      self.fnName = fnName
      self.fn = { (arg0: PyObject, args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> in
        guard let zelf = castSelf(arg0) else {
          return Self.createInvalidArg0TypeError(expectedType: typeName, arg0: arg0)
        }

        let result = fn(zelf, args, kwargs)
        return result
      }
    }

    private static func getTypeNameAndFnName(type: PyType) -> (String, String) {
      let typeName = type.getNameString()
      let fnName = typeName + ".__init__"
      return (typeName, fnName)
    }

    private static func createInvalidArg0TypeError(
      expectedType: String,
      arg0: PyObject
    ) -> PyResult<PyNone> {
      let t = arg0.typeName
      return .typeError(
        "descriptor '__init__' requires a '\(expectedType)' object but received a '\(t)'"
      )
    }

    internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      guard args.any else {
        return .typeError("\(self.fnName)(): not enough arguments")
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      let zelf = args[0]
      let argsWithoutZelf = Array(args.dropFirst())
      return self.fn(zelf, argsWithoutZelf, kwargs).map { $0 as PyObject }
    }
  }

  internal init<Zelf>(type: PyType,
                      initFn: @escaping InitAsMethodFn<Zelf>,
                      castSelf: @escaping CastSelfOptional<Zelf>) {
    let wrapper = Init(type: type, fn: initFn, castSelf: castSelf)
    self.kind = .`init`(wrapper)
  }

  internal init<Zelf>(type: PyType,
                      initFn: @escaping InitAsStaticFunctionFn<Zelf>,
                      castSelf: @escaping CastSelfOptional<Zelf>) {
    let wrapper = Init(type: type, fn: initFn, castSelf: castSelf)
    self.kind = .`init`(wrapper)
  }

  // MARK: - Args kwargs method

  /// Function with *args and **kwargs.
  internal typealias ArgsKwargsAsMethodFn<Zelf, R: PyFunctionResultConvertible> =
    (Zelf) -> ([PyObject], PyDict?) -> R

  internal struct ArgsKwargsAsMethod {
    internal let fnName: String
    private let fn: ArgsKwargsAsMethodFn<PyObject, PyFunctionResult>

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping ArgsKwargsAsMethodFn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
      self.fnName = name
      self.fn = { (arg0: PyObject) in { (args: [PyObject], kwargs: PyDict?) -> PyFunctionResult in
        // This function has a 'self' argument that we have to cast
        let zelf: Zelf
        switch castSelf(name, arg0) {
        case let .value(z): zelf = z
        case let .error(e): return .error(e)
        }

        // This function returns 'R'
        let result = fn(zelf)(args, kwargs)
        return result.asFunctionResult
      }}
    }

    internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      guard args.any else {
        return .typeError("\(self.fnName)(): not enough arguments")
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      let arg0 = args[0]
      let argsWithoutArg0 = Array(args.dropFirst())
      return self.fn(arg0)(argsWithoutArg0, kwargs)
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping ArgsKwargsAsMethodFn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = ArgsKwargsAsMethod(name: name, fn: fn, castSelf: castSelf)
    self.kind = .argsKwargsAsMethod(wrapper)
  }

  // MARK: - Args kwargs static function

  /// Function with *args and **kwargs.
  internal typealias ArgsKwargsAsStaticFunctionFn<R: PyFunctionResultConvertible> =
    ([PyObject], PyDict?) -> R

  internal struct ArgsKwargsAsStaticFunction {
    internal let fnName: String
    private let fn: ArgsKwargsAsStaticFunctionFn<PyFunctionResult>

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping ArgsKwargsAsStaticFunctionFn<R>
    ) {
      self.fnName = name
      self.fn = { (args: [PyObject], kwargs: PyDict?) -> PyFunctionResult in
        // This function returns 'R'
        let result = fn(args, kwargs)
        return result.asFunctionResult
      }
    }

    internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      return self.fn(args, kwargs)
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping ArgsKwargsAsStaticFunctionFn<R>
  ) {
    let wrapper = ArgsKwargsAsStaticFunction(name: name, fn: fn)
    self.kind = .argsKwargsAsStaticFunction(wrapper)
  }
}
