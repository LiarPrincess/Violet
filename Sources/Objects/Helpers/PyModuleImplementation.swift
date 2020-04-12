import Core

// Module implementation is based on pre-specialization (partial application)
// of function to module object and then wrapping remaining function.
//
// So, for example:
//   Builtins.add :: (self: Builtins) -> (left: PyObject, right: PyObject) -> Result
// would be specialized to 'Builtins' instance giving us:
//   add :: (left: PyObject, right: PyObject) -> Result
// which would be wrapped and exposed to Python runtime.
//
// So when you are working on Python 'builtins' you are actually working on
// (Scooby-Doo reveal incomming...)
// 'Py.builtins' object (which gives us stateful modules).
// (and we would have gotten away with it without you meddling kids!)
// https://www.youtube.com/watch?v=b4JLLv1lE7A

/// Class that will be used as a `Python` module implementation.
internal protocol PyModuleImplementation {

  /// For each module we will create helper type with restricted set of values
  /// representing all of the properties.
  ///
  /// Then we will use those values as keys in `__dict__` to prevent typos
  /// (otherwise we would have to use strings and you know how great those are).
  associatedtype Properties: CustomStringConvertible

  static var moduleName: String { get }
  static var doc: String { get }

  var __dict__: PyDict { get }
}

extension PyModuleImplementation {

  // MARK: - Create module

  internal func createModule() -> PyModule {
    return Py.newModule(
      name: Self.moduleName,
      doc: Self.doc,
      dict: self.__dict__
    )
  }

  // MARK: - Get from __dict__

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

  /// Get value from `self.__dict__` and try to convert it to `string`.
  internal func getString(_ name: Properties) -> PyResult<PyString> {
    return self.get(name, andCastAs: PyString.self, typeName: "str")
  }

  /// Get value from `self.__dict__` and try to convert it to `list`.
  internal func getList(_ name: Properties) -> PyResult<PyList> {
    return self.get(name, andCastAs: PyList.self, typeName: "list")
  }

  /// Get value from `self.__dict__` and try to convert it to `tuple`.
  internal func getTuple(_ name: Properties) -> PyResult<PyTuple> {
    return self.get(name, andCastAs: PyTuple.self, typeName: "tuple")
  }

  /// Get value from `self.__dict__` and try to convert it to `dict`.
  internal func getDict(_ name: Properties) -> PyResult<PyDict> {
    return self.get(name, andCastAs: PyDict.self, typeName: "dict")
  }

  /// Get value from `self.__dict__` and try to convert it to `text file`.
  internal func getTextFile(_ name: Properties) -> PyResult<PyTextFile> {
    return self.get(name, andCastAs: PyTextFile.self, typeName: "textFile")
  }

  /// Call `self.get(_:)` and then cast to specific type.
  private func get<T>(
    _ name: Properties,
    andCastAs type: T.Type,
    typeName: String
  ) -> PyResult<T> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = object as? T {
      return .value(typed)
    }

    let msg = "expected '\(Self.moduleName).\(name)' to be \(typeName) " +
              "not \(object.typeName) <surprised Pikachu face>"
    return .typeError(msg)
  }

  // MARK: - Set in __dict__

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

  internal func setOrTrap(_ name: Properties, to value: PyObject) {
    if let e = self.set(name, to: value) {
      trap("Error when inserting '\(name)' to '\(Self.moduleName)': \(e)")
    }
  }

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

  private var moduleToSetInFunctions: PyString {
    return Py.intern(Self.moduleName)
  }

  // MARK: - Helpers

  private func intern(_ name: Properties) -> PyString {
    let value = String(describing: name)
    return Py.intern(value)
  }
}