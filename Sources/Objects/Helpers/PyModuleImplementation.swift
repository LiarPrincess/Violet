import VioletCore

// cSpell:ignore Scooby

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

  var py: Py { get }
}

extension PyModuleImplementation {

  // MARK: - Create module

  /// Create `Python` module based on this object.
  internal func createModule() -> PyModule {
    return self.py.newModule(name: Self.moduleName,
                             doc: Self.doc,
                             dict: self.__dict__)
  }

  // MARK: - Get

  /// Get value from `self.__dict__`.
  internal func get(_ name: Properties) -> PyResult {
    let interned = self.intern(name)
    let result = self.__dict__.get(self.py, key: interned)

    switch result {
    case .value(let o):
      return .value(o)
    case .notFound:
      let key = interned.asObject
      let e = py.newKeyError(key: key)
      return .error(e.asBaseException)
    case .error(let e):
      return .error(e)
    }
  }

  /// Get value from `self.__dict__` and cast it to `int`.
  internal func getInt(_ name: Properties) -> PyResultGen<PyInt> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = py.cast.asInt(object) {
      return .value(typed)
    }

    return self.createPropertyTypeError(name, got: object, expectedType: "int")
  }

  /// Get value from `self.__dict__` and cast it to `str`.
  internal func getString(_ name: Properties) -> PyResultGen<PyString> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = py.cast.asString(object) {
      return .value(typed)
    }

    return self.createPropertyTypeError(name, got: object, expectedType: "str")
  }

  /// Get value from `self.__dict__` and cast it to `list`.
  internal func getList(_ name: Properties) -> PyResultGen<PyList> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = py.cast.asList(object) {
      return .value(typed)
    }

    return self.createPropertyTypeError(name, got: object, expectedType: "list")
  }

  /// Get value from `self.__dict__` and cast it to `tuple`.
  internal func getTuple(_ name: Properties) -> PyResultGen<PyTuple> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = py.cast.asTuple(object) {
      return .value(typed)
    }

    return self.createPropertyTypeError(name, got: object, expectedType: "tuple")
  }

  /// Get value from `self.__dict__` and cast it to `dict`.
  internal func getDict(_ name: Properties) -> PyResultGen<PyDict> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = py.cast.asDict(object) {
      return .value(typed)
    }

    return self.createPropertyTypeError(name, got: object, expectedType: "dict")
  }

  /// Get value from `self.__dict__` and cast it to `text file`.
  internal func getTextFile(_ name: Properties) -> PyResultGen<PyTextFile> {
    let object: PyObject
    switch self.get(name) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    if let typed = py.cast.asTextFile(object) {
      return .value(typed)
    }

    return self.createPropertyTypeError(name, got: object, expectedType: "textFile")
  }

  internal func createPropertyTypeError(_ name: Properties,
                                        got object: PyObject,
                                        expectedType: String) -> PyTypeError {
    let module = Self.moduleName
    let objectType = object.typeName
    let message = "expected '\(module).\(name)' to be \(expectedType) not \(objectType)"
    return self.py.newTypeError(message: message)
  }

  internal func createPropertyTypeError<T>(_ name: Properties,
                                           got object: PyObject,
                                           expectedType: String) -> PyResultGen<T> {
    let error: PyTypeError = self.createPropertyTypeError(name,
                                                          got: object,
                                                          expectedType: expectedType)

    return .error(error.asBaseException)
  }

  // MARK: - Set

  /// Set value in `self.__dict__`.
  internal func set(_ name: Properties, value: PyObject) -> PyBaseException? {
    let interned = self.intern(name)
    let result = self.__dict__.set(self.py, key: interned, value: value)

    switch result {
    case .ok:
      return nil
    case .error(let e):
      return e
    }
  }

  internal func setOrTrap<T: PyObjectMixin>(_ name: Properties, value: T) {
    let valueObject = value.asObject
    if let e = self.set(name, value: valueObject) {
      trap("Error when inserting '\(name)' to '\(Self.moduleName)': \(e)")
    }
  }

  private func setOrTrap(_ name: Properties, doc: String?, fn: FunctionWrapper) {
    let module = self.moduleToSetInFunctions.asObject
    let builtinFunction = self.py.newBuiltinFunction(fn: fn, module: module, doc: doc)

    if let e = self.set(name, value: builtinFunction.asObject) {
      trap("Error when inserting '\(name)' to '\(Self.moduleName)': \(e)")
    }
  }

  // MARK: - Set args kwargs

  internal func setOrTrap(
    _ name: Properties,
    doc: String?,
    fn: @escaping (Py, [PyObject], PyDict?) -> PyResult
  ) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  // MARK: - Set positional nonary

  internal func setOrTrap(_ name: Properties,
                          doc: String?,
                          fn: @escaping (Py) -> PyResult) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  // MARK: - Set positional unary

  internal func setOrTrap(_ name: Properties,
                          doc: String?,
                          fn: @escaping (Py, PyObject) -> PyResult) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  internal func setOrTrap(_ name: Properties,
                          doc: String?,
                          fn: @escaping (Py, PyObject?) -> PyResult) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  // MARK: - Set positional binary

  internal func setOrTrap(_ name: Properties,
                          doc: String?,
                          fn: @escaping (Py, PyObject, PyObject) -> PyResult) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  internal func setOrTrap(_ name: Properties,
                          doc: String?,
                          fn: @escaping (Py, PyObject, PyObject?) -> PyResult) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  // MARK: - Set positional ternary

  internal func setOrTrap(
    _ name: Properties,
    doc: String?,
    fn: @escaping (Py, PyObject, PyObject, PyObject) -> PyResult
  ) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  internal func setOrTrap(
    _ name: Properties,
    doc: String?,
    fn: @escaping (Py, PyObject, PyObject, PyObject?) -> PyResult
  ) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  internal func setOrTrap(
    _ name: Properties,
    doc: String?,
    fn: @escaping (Py, PyObject, PyObject?, PyObject?) -> PyResult
  ) {
    let wrapper = FunctionWrapper(name: name.description, fn: fn)
    self.setOrTrap(name, doc: doc, fn: wrapper)
  }

  // MARK: - Helpers

  private var moduleToSetInFunctions: PyString {
    return self.py.intern(string: Self.moduleName)
  }

  private func intern(_ name: Properties) -> PyString {
    let value = String(describing: name)
    return self.py.intern(string: value)
  }
}
