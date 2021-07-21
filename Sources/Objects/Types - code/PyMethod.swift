import VioletBytecode

// cSpell:ignore classobject getattro

// In CPython:
// Objects -> classobject.c

// sourcery: pytype = method, default, hasGC
/// Function bound to an object.
public final class PyMethod: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    method(function, instance)

    Create a bound instance method object.
    """

  /// The callable object implementing the method
  internal let function: PyFunction
  /// The instance it is bound to
  internal let object: PyObject

  override public var description: String {
    let name = self.function.name
    let qualname = self.function.qualname
    return "PyMethod(name: \(name), qualname: \(qualname), object: \(self.object))"
  }

  // MARK: - Init

  internal init(fn: PyFunction, object: PyObject) {
    self.function = fn
    self.object = object
    super.init(type: Py.types.method)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = PyCast.asMethod(other) else {
      return .notImplemented
    }

    switch Py.isEqualBool(left: self.function, right: other.function) {
    case .value(true): break // compare self
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    switch Py.isEqualBool(left: self.object, right: other.object) {
    case .value(let b): return .value(b)
    case .error(let e): return .error(e)
    }
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let objectRepr: String
    switch Py.reprString(object: self.object) {
    case let .value(s): objectRepr = s
    case let .error(e): return .error(e)
    }

    let functionName = self.function.qualname.value
    let result = "<bound method \(functionName) of \(objectRepr)>"
    return .value(result)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    let objectHash: PyHash
    switch Py.hash(object: self.object) {
    case let .value(h): objectHash = h
    case let .error(e): return .error(e)
    }

    let fnHash: PyHash
    switch Py.hash(object: self.function) {
    case let .value(h): fnHash = h
    case let .error(e): return .error(e)
    }

    return .value(objectHash ^ fnHash)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  /// static PyObject *
  /// method_getattro(PyObject *obj, PyObject *name)
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return self.getAttribute(name: n)
    case let .error(e):
      return .error(e)
    }
  }

  /// static PyObject *
  /// method_getattro(PyObject *obj, PyObject *name)
  internal func getAttribute(name: PyString) -> PyResult<PyObject> {
    switch self.type.lookup(name: name) {
    case .value(let value):
      if let descriptor = GetDescriptor(object: self, attribute: value) {
        return descriptor.call()
      } else {
        return .value(value)
      }

    case .notFound:
      // Take 'attribute' from function!
      // Easy to miss.
      // (In fact we totally did miss it when implementing this type)
      let function = self.function
      return AttributeHelper.getAttribute(from: function, name: name)

    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Getters

  // sourcery: pymethod = __func__
  internal func getFunction() -> PyFunction {
    return self.function
  }

  // sourcery: pymethod = __self__
  internal func getSelf() -> PyObject {
    return self.object
  }

  // sourcery: pyproperty = __doc__
  internal func getDoc() -> PyString? {
    return self.function.getDoc()
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    let result = PyMemory.newMethod(fn: self.function, object: object)
    return .value(result)
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    let realArgs = [self.object] + args
    return self.function.call(args: realArgs, kwargs: kwargs)
  }
}
