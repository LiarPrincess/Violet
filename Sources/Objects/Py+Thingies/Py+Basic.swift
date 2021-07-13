import Foundation
import BigInt
import VioletCore
import VioletBytecode

// swiftlint:disable file_length

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Int

  public func newInt<I: BinaryInteger>(_ value: I) -> PyInt {
    return self.newInt(BigInt(value))
  }

  public func newInt(_ value: Int) -> PyInt {
    return self.getInterned(int: value) ?? PyMemory.newInt(value: BigInt(value))
  }

  public func newInt(_ value: BigInt) -> PyInt {
    return self.getInterned(int: value) ?? PyMemory.newInt(value: value)
  }

  /// PyObject *
  /// PyLong_FromDouble(double dval)
  public func newInt(double value: Double) -> PyResult<PyInt> {
    if value.isInfinite {
      return .overflowError("cannot convert float infinity to integer")
    }

    if value.isNaN {
      return .valueError("cannot convert float NaN to integer")
    }

    if let int = BigInt(exactly: value) {
      return .value(Py.newInt(int))
    }

    return .valueError("cannot convert \(value) to integer")
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
    return PyMemory.newFloat(value: value)
  }

  // MARK: - Complex

  public func newComplex(real: Double, imag: Double) -> PyComplex {
    return PyMemory.newComplex(real: real, imag: imag)
  }

  // MARK: - String

  public func newString(_ value: String) -> PyString {
    return value.isEmpty ?
      self.emptyString :
      PyMemory.newString(value: value)
  }

  public func newString(scalar: UnicodeScalar) -> PyString {
    // ASCII values are used quite often, so it does not make sense to allocate
    // a new object every time.
    if scalar.isASCII {
      return self.intern(scalar: scalar)
    }

    let string = String(scalar)
    return Py.newString(string)
  }

  public func newString(_ value: String.UnicodeScalarView) -> PyString {
    if value.isEmpty {
      return self.emptyString
    }

    return PyMemory.newString(value: String(value))
  }

  public func newString(_ value: String.UnicodeScalarView.SubSequence) -> PyString {
    if value.isEmpty {
      return self.emptyString
    }

    return PyMemory.newString(value: String(value))
  }

  public func newString(_ value: CustomStringConvertible) -> PyString {
    let string = String(describing: value)
    return self.newString(string)
  }

  // MARK: - Get string

  internal enum GetStringResult {
    case string(PyString, String)
    case bytes(PyAnyBytes, String)
    case byteDecodingError(PyAnyBytes)
    case notStringOrBytes
  }

  /// Converts `Object` -> `String` (if possible).
  ///
  /// Mostly targeted towards `str`, `bytes` and `bytearray`.
  internal func getString(object: PyObject,
                          encoding: PyString.Encoding? = nil) -> GetStringResult {
    if let str = PyCast.asString(object) {
      return .string(str, str.value)
    }

    if let bytes = PyCast.asAnyBytes(object) {
      if let string = self.getString(data: bytes.elements, encoding: encoding) {
        return .bytes(bytes, string)
      }

      return .byteDecodingError(bytes)
    }

    return .notStringOrBytes
  }

  /// Decode `bytes` as string.
  ///
  /// If this fails:
  /// - Option 1: return `valueError` with following message:
  /// '\(fnName) bytes '\(bytes.ptrString)' cannot be interpreted as str'.
  /// - Option 2: return `return .byteDecodingError(bytes)`
  internal func getString(bytes: PyAnyBytes,
                          encoding: PyString.Encoding? = nil) -> String? {
    return self.getString(data: bytes.elements, encoding: encoding)
  }

  /// Decode `data` as string.
  ///
  /// If this fails:
  /// - Option 1: return `valueError` with following message:
  /// '\(fnName) bytes '\(bytes.ptrString)' cannot be interpreted as str'.
  /// - Option 2: return `return .byteDecodingError(bytes)`
  internal func getString(data: Data,
                          encoding: PyString.Encoding? = nil) -> String? {
    let e = encoding ?? Py.sys.defaultEncoding
    return e.decode(data: data)
  }

  // MARK: - Bytes

  public func newBytes(_ elements: Data) -> PyBytes {
    return elements.isEmpty ?
      self.emptyBytes :
      PyMemory.newBytes(elements: elements)
  }

  // MARK: - Byte array

  public func newByteArray(_ elements: Data) -> PyByteArray {
    return PyMemory.newByteArray(elements: elements)
  }

  // MARK: - Namespace

  public func newNamespace() -> PyNamespace {
    let dict = self.newDict()
    return self.newNamespace(dict: dict)
  }

  public func newNamespace(dict: PyDict) -> PyNamespace {
    return PyMemory.newNamespace(dict: dict)
  }

  // MARK: - Dict

  /// Returns the **builtin** (!!!!) `__dict__` instance.
  ///
  /// Extreme edge case: object has `__dict__` attribute:
  /// ```py
  /// >>> class C():
  /// ...     def __init__(self):
  /// ...             self.__dict__ = { 'a': 1 }
  /// ...
  /// >>> c = C()
  /// >>> c.__dict__
  /// {'a': 1}
  /// ```
  /// This is actually `dict` stored as '\_\_dict\_\_' in real '\_\_dict\_\_'.
  /// In such situation this function returns real '\_\_dict\_\_'
  /// (not the user property!).
  public func get__dict__(object: PyObject) -> PyDict? {
    if let owner = object as? __dict__Owner {
      return owner.getDict()
    }

    return nil
  }

  public func get__dict__(module: PyModule) -> PyDict {
    return module.__dict__
  }

  // MARK: - Id

  /// id(object)
  /// See [this](https://docs.python.org/3/library/functions.html#id)
  public func id(object: PyObject) -> PyInt {
    let unsafeMutableRawPointer = object.ptr
    let pointer = Int(bitPattern: unsafeMutableRawPointer)
    return self.newInt(pointer)
  }

  // MARK: - Dir

  internal static var dirDoc: String {
    return """
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
  }

  /// dir([object])
  /// See [this](https://docs.python.org/3/library/functions.html#dir)
  ///
  /// PyObject *
  /// PyObject_Dir(PyObject *obj)
  public func dir(object: PyObject? = nil) -> PyResult<PyObject> {
    if let object = object {
      return self.objectDir(object: object)
    }

    return self.localsDir()
  }

  /// static PyObject *
  /// _dir_object(PyObject *obj)
  private func objectDir(object: PyObject) -> PyResult<PyObject> {
    if let result = Fast.__dir__(object) {
      return result.asFunctionResult
    }

    switch self.callMethod(object: object, selector: .__dir__) {
    case .value(let o):
      // Now we need to sort them
      let dir = DirResult()
      if let e = dir.append(elementsFrom: o) {
        return .error(e)
      }

      return dir.asFunctionResult

    case .missingMethod:
      return .typeError("object does not provide __dir__")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  /// static PyObject *
  /// _dir_locals(void)
  private func localsDir() -> PyResult<PyObject> {
    guard let frame = self.delegate.frame else {
      return .systemError("frame does not exist")
    }

    let dir = DirResult()
    if let e = dir.append(keysFrom: frame.locals) {
      return .error(e)
    }

    return dir.asFunctionResult
  }

  // MARK: - Is abstract method

  public func isAbstractMethod(object: PyObject) -> PyResult<Bool> {
    if let result = Fast.__isabstractmethod__(object) {
      return result
    }

    switch self.getattr(object: object, name: .__isabstractmethod__) {
    case let .value(o):
      return self.isTrueBool(object: o)
    case let .error(e):
      return .error(e)
    }
  }
}
