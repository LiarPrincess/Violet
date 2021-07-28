import VioletCore

// swiftlint:disable file_length
// cSpell:ignore Scooby

// Module implementation is based on pre-specialization (partial application)
// of function to module object and then wrapping remaining function.
//
// For example:
//   Builtins.add :: (self: Builtins) -> (left: PyObject, right: PyObject) -> Result
// would be specialized to 'Builtins' instance leaving us with:
//   add :: (left: PyObject, right: PyObject) -> Result
// which would be wrapped and exposed to Python runtime.
//
// So when you are working on Python 'builtins' you are actually working on
// (Scooby-Doo reveal incoming…)
// 'Py.builtins' object (which gives us stateful modules).
// (and we would have gotten away with it without you meddling kids!)
// https://www.youtube.com/watch?v=b4JLLv1lE7A

/// Helper for classes that will be used as a `Python` module implementation.
internal protocol PyModuleImplementation: AnyObject {

  /// For each module we will create helper type with restricted set of values
  /// representing all of the properties.
  ///
  /// Then we will use those values as keys in `__dict__` to prevent typos
  /// (otherwise we would have to use strings and you know how great those are).
  associatedtype Properties: CustomStringConvertible

  /// Module name. 'nuff said.
  static var moduleName: String { get }

  /// Module documentation.
  ///
  /// Required. Because why not.
  static var doc: String { get }

  /// Module dictionary.
  ///
  /// Shared between this object and `PyModule`.
  var __dict__: PyDict { get }
}

extension PyModuleImplementation {

  // MARK: - Create module

  /// Create `Python` module based on this object.
  internal func createModule() -> PyModule {
    return Py.newModule(
      name: Self.moduleName,
      doc: Self.doc,
      dict: self.__dict__
    )
  }

  // MARK: - Get

  /// Get value from `self.__dict__`.
  internal func get(_ name: Properties) -> PyResult<PyObject> {
    let interned = self.intern(name)
    let result = self.__dict__.get(key: interned)

    switch result {
    case .value(let o):
      return .value(o)
    case .notFound:
      let e = Py.newKeyError(key: interned)
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  /// Get value from `self.__dict__` and cast it to `int`.
  internal func getInt(_ name: Properties) -> PyResult<PyInt> {
    return self.get(name, castFn: PyCast.asInt, typeName: "int")
  }

  /// Get value from `self.__dict__` and cast it to `str`.
  internal func getString(_ name: Properties) -> PyResult<PyString> {
    return self.get(name, castFn: PyCast.asString, typeName: "str")
  }

  /// Get value from `self.__dict__` and cast it to `list`.
  internal func getList(_ name: Properties) -> PyResult<PyList> {
    return self.get(name, castFn: PyCast.asList, typeName: "list")
  }

  /// Get value from `self.__dict__` and cast it to `tuple`.
  internal func getTuple(_ name: Properties) -> PyResult<PyTuple> {
    return self.get(name, castFn: PyCast.asTuple, typeName: "tuple")
  }

  /// Get value from `self.__dict__` and cast it to `dict`.
  internal func getDict(_ name: Properties) -> PyResult<PyDict> {
    return self.get(name, castFn: PyCast.asDict, typeName: "dict")
  }

  /// Get value from `self.__dict__` and cast it to `text file`.
  internal func getTextFile(_ name: Properties) -> PyResult<PyTextFile> {
    return self.get(name, castFn: PyCast.asTextFile, typeName: "textFile")
  }

  /// Call `self.get(_:)` and then cast to specific type.
  private func get<T>(
    _ name: Properties,
    castFn: (PyObject) -> T?,
    typeName: String
  ) -> PyResult<T> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = castFn(object) {
      return .value(typed)
    }

    let msg = self.createPropertyTypeError(name,
                                           got: object,
                                           expectedType: typeName)

    return .typeError(msg)
  }

  internal func createPropertyTypeError(_ name: Properties,
                                        got object: PyObject,
                                        expectedType: String) -> String {
    let module = Self.moduleName
    let objectType = object.typeName
    return "expected '\(module).\(name)' to be \(expectedType) not \(objectType)"
  }

  // MARK: - Set

  /// Set value in `self.__dict__`.
  internal func set(_ name: Properties, to value: PyObject) -> PyBaseException? {
    let interned = self.intern(name)
    let result = self.__dict__.set(key: interned, to: value)

    switch result {
    case .ok:
      return nil
    case .error(let e):
      return e
    }
  }

  // MARK: - Helpers

  private var moduleToSetInFunctions: PyString {
    return Py.intern(string: Self.moduleName)
  }

  private func intern(_ name: Properties) -> PyString {
    let value = String(describing: name)
    return Py.intern(string: value)
  }

  // MARK: - Set property

  internal func setOrTrap(_ name: Properties, to value: PyObject) {
    if let e = self.set(name, to: value) {
      trap("Error when inserting '\(name)' to '\(Self.moduleName)': \(e)")
    }
  }

  // MARK: - Set args kwargs

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping ([PyObject], PyDict?) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  // MARK: - Set positional nullary

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping () -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  // MARK: - Set positional unary

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping (PyObject) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping (PyObject?) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  // MARK: - Set positional binary

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping (PyObject, PyObject) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping (PyObject, PyObject?) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  // MARK: - Set positional ternary

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping (PyObject, PyObject, PyObject) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping (PyObject, PyObject, PyObject?) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }

  internal func setOrTrap<R: PyFunctionResultConvertible>(
    _ name: Properties,
    doc: String?,
    fn: @escaping (PyObject, PyObject?, PyObject?) -> R
  ) {
    let object = PyBuiltinFunction.wrap(
      name: String(describing: name),
      doc: doc,
      fn: fn,
      module: self.moduleToSetInFunctions
    )
    self.setOrTrap(name, to: object)
  }
}
