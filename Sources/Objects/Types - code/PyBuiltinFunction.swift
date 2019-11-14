// In CPython:
// Objects -> methodobject.c

// swiftlint:disable type_name
internal typealias F1 = (PyObject) -> PyObject
internal typealias F2 = (PyObject, PyObject) -> PyObject
internal typealias F3 = (PyObject, PyObject, PyObject) -> PyObject
internal typealias F4 = (PyObject, PyObject, PyObject, PyObject) -> PyObject
// swiftlint:enable type_name

// sourcery: pytype = builtinFunction
/// Native function implemented in Swift.
internal final class PyBuiltinFunction: PyObject {

  /// The name of the built-in function/method
  internal let _name: String
  /// The `__doc__` attribute, or NULL
  internal let _doc: String?
  /// The Swift function that implements it
  internal let _func: PyBuiltinFunction.Storage
  /// The instance it is bound to
  internal let _self: PyObject?

  internal enum Storage {
    case f1(F1)
    case f2(F2)
    case f3(F3)
    case f4(F4)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc: String?,
                            func fn: @escaping F1,
                            zelf: PyObject?) {
    self.init(context, name: name, doc: doc, func: .f1(fn), zelf: zelf)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc: String?,
                            func fn: @escaping F2,
                            zelf: PyObject?) {
    self.init(context, name: name, doc: doc, func: .f2(fn), zelf: zelf)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc: String?,
                            func fn: @escaping F3,
                            zelf: PyObject?) {
    self.init(context, name: name, doc: doc, func: .f3(fn), zelf: zelf)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc: String?,
                            func fn: @escaping F4,
                            zelf: PyObject?) {
    self.init(context, name: name, doc: doc, func: .f4(fn), zelf: zelf)
  }

  internal init(_ context: PyContext,
                name: String,
                doc: String?,
                func fn: PyBuiltinFunction.Storage,
                zelf: PyObject?) {
    self._name = name
    self._doc = doc
    self._func = fn
    self._self = zelf
    super.init(type: context.builtins.types.builtinFunction)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .notImplemented
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    guard let zelf = self._self else {
      return .value("<built-in function \(self._name)>")
    }

    if self._self is PyModule {
      return .value("<built-in function \(self._name)>")
    }

    let ptr = zelf.ptrString
    let type = zelf.typeName
    return .value("<built-in method \(self._name) of \(type) object at \(ptr)>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Properties

  // sourcery: pyproperty = __name__
  internal func getName() -> String {
    return self._name
  }

  // sourcery: pyproperty = __qualname__
  internal func getQualname() -> String {
    // If __self__ is a module or NULL, return m.__name__
    // (e.g. len.__qualname__ == 'len')
    //
    // If __self__ is a type, return m.__self__.__qualname__ + '.' + m.__name__
    // (e.g. dict.fromkeys.__qualname__ == 'dict.fromkeys')
    //
    // Otherwise return type(m.__self__).__qualname__ + '.' + m.__name__
    // (e.g. [].append.__qualname__ == 'list.append')

    guard let zelf = self._self else {
      return self._name
    }

    if zelf is PyModule {
      return self._name
    }

    var type = zelf.type
    if let caseWhenZelfIsType = zelf as? PyType {
      type = caseWhenZelfIsType
    }

    let typeQualname = type.getQualname()
    return typeQualname + "." + self._name
  }

  // sourcery: pyproperty = __text_signature__
  internal func getTextSignature() -> String? {
    return self._doc.map(DocHelper.getSignature)
  }

  // sourcery: pyproperty = __module__
  internal func getModule() -> PyResult<String> {
    return .value("builtins")
  }

  // sourcery: pyproperty = __self__
  internal func getSelf() -> PyObject {
    return self._self ?? context.none
  }
}
