// In CPython:
// Objects -> methodobject.c

// swiftlint:disable type_name
internal typealias F1 = (PyObject) -> PyObject
internal typealias F2 = (PyObject, PyObject) -> PyObject
internal typealias F3 = (PyObject, PyObject, PyObject) -> PyObject
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
  internal let _self: PyObject

  internal enum Storage {
    case f1(F1)
    case f2(F2)
    case f3(F3)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc: String?,
                            func: @escaping F1,
                            zelf: PyObject?) {
    self.init(context, name: name, doc: doc, func: .f1(`func`), zelf: zelf)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc: String?,
                            func: @escaping F2,
                            zelf: PyObject?) {
    self.init(context, name: name, doc: doc, func: .f2(`func`), zelf: zelf)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc: String?,
                            func: @escaping F3,
                            zelf: PyObject?) {
    self.init(context, name: name, doc: doc, func: .f3(`func`), zelf: zelf)
  }

  internal init(_ context: PyContext,
                name: String,
                doc: String?,
                func: PyBuiltinFunction.Storage,
                zelf: PyObject?) {
    self._name = name
    self._doc = doc
    self._func = `func`
    self._self = zelf ?? context.none
    super.init(type: context.types.builtinFunction)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
//    let name = self._func.getName()
//
//    if self._self is PyModule {
//      return "<built-in function \(name)>"
//    }
//
//    let ptr = self._self.ptrString
//    let type = self._self.typeName
//    return "<built-in method \(name) of \(type) object at \(ptr)>"
    return ""
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }
}
