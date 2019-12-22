import Core
import Foundation

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Int

  public func newInt(_ value: UInt8) -> PyInt {
    return PyInt(self.context, value: BigInt(value))
  }

  public func newInt(_ value: Int) -> PyInt {
    return PyInt(self.context, value: BigInt(value))
  }

  public func newInt(_ value: BigInt) -> PyInt {
    if let cached = self.cachedInts[value] {
      return cached
    }
    return PyInt(self.context, value: value)
  }

  // MARK: - Bool

  public func newBool(_ value: Bool) -> PyBool {
    return value ? self.true : self.false
  }

  public func newBool(_ value: BigInt) -> PyBool {
    return self.newBool(value.isTrue)
  }

  // MARK: - Float

  public func newFloat(_ value: Double) -> PyFloat {
    return PyFloat(self.context, value: value)
  }

  // MARK: - Complex

  public func newComplex(real: Double, imag: Double) -> PyComplex {
    return PyComplex(self.context, real: real, imag: imag)
  }

  // MARK: - String

  public func newString(_ value: String) -> PyString {
    return value.isEmpty ?
      self.emptyString :
      PyString(self.context, value: value)
  }

  public func newBytes(_ value: Data) -> PyBytes {
    return PyBytes(self.context, value: value)
  }

  public func newByteArray(_ value: Data) -> PyByteArray {
    return PyByteArray(self.context, value: value)
  }

  // MARK: - Module

  public func newModule(name: String, doc: String? = nil) -> PyModule {
    let n = self.newString(name)
    let d = doc.map(self.newString)
    return self.newModule(name: n, doc: d)
  }

  public func newModule(name: PyObject, doc: PyObject? = nil) -> PyModule {
    return PyModule(self.context, name: name, doc: doc)
  }

  // MARK: - Id

  // sourcery: pymethod: id
  /// id(object)
  /// See [this](https://docs.python.org/3/library/functions.html#id)
  public func id(_ object: PyObject) -> PyInt {
    let id = ObjectIdentifier(object)
    return self.newInt(id.hashValue)
  }

  // MARK: - Dir

  private static let dirDoc = """
    dir([object]) -> list of strings

    If called without an argument, return the names in the current scope.
    Else, return an alphabetized list of names comprising (some of) the attributes
    of the given object, and of attributes reachable from it.
    If the object supplies a method named __dir__, it will be used; otherwise
    the default dir() logic is used and returns:
      for a module object: the module's attributes.
      for a class object:  its attributes, and recursively the attributes
        of its bases.
      for any other object: its attributes, its class's attributes, and
        recursively the attributes of its class's base classes.
    """

  // sourcery: pymethod: dir
  /// dir([object])
  /// See [this](https://docs.python.org/3/library/functions.html#dir)
  public func dir(_ object: PyObject?) -> PyResult<PyObject> {
    if let object = object {
      switch self.call__dir__(on: object) {
      case .value(let o): return .value(o)
      case .notImplemented: return .typeError("object does not provide __dir__")
      case .error(let e): return .error(e)
      }
    }

    // TODO: Add '_dir_locals(void)'
    return .value(self.unimplemented)
  }

  private func call__dir__(on object: PyObject) -> FunctionResult {
    if let owner = object as? __dir__Owner {
      let result = owner.dir()
      return result.toFunctionResult(in: object.context)
    }

    switch self.callMethod(on: object, selector: "__dir__") {
    case .value(let o):
      return .value(o)
    case .notImplemented, .missingMethod:
      return .notImplemented
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}
