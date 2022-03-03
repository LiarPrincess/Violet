import VioletCore

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

// sourcery: pytype = NoneType, isDefault
/// The Python None object, denoting lack of value.
public struct PyNone: PyObjectMixin, HasCustomGetMethod {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType) {
    self.header.initialize(py, type: type)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyNone(ptr: ptr)
    return "PyNone(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard py.cast.isNone(zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let result = py.intern(string: "None")
    return .value(result.asObject)
  }

  // MARK: - As bool

  // sourcery: pymethod = __bool__
  internal static func __bool__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard py.cast.isNone(zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let result = py.false
    return .value(result.asObject)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = py.cast.asNone(zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return zelf.getAttribute(py, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal func getAttribute(_ py: Py, name: PyString) -> PyResult<PyObject> {
    // (Read following sentences with Bernadette Banner voice.)
    //
    // Descriptors use a comparision with 'None' to determine if they are either
    // invoked by an instance binding or a static binding.
    // Unfortunately, if the object itself is 'None' then this detection won't work.
    // Alas, my friends, welcome to 'None-Descriptor' hack.
    assert(py.isDescriptorStaticMarker(self.asObject))

    let staticProperty: PyObject?
    let descriptor: GetDescriptor?

    switch self.type.mroLookup(name: name) {
    case .value(let l):
      staticProperty = l.object
      descriptor = GetDescriptor(py, object: self.asObject, attribute: l.object)
    case .notFound:
      staticProperty = nil
      descriptor = nil
    case .error(let e):
      return .error(e)
    }

    if let descr = descriptor {
      // We know that this thingie has a '__get__' method.
      // When we call it with 'None' as a 'object' it will return unbound 'self'.
      // Then we will try to bind it manually.

      let unbound = descr.call()
      switch unbound {
      case let .value(o):
        return self.bindToSelf(py, object: o)
      case let .error(e):
        return .error(e)
      }
    }

    if let p = staticProperty {
      return .value(p)
    }

    let e = py.newAttributeError(object: self.asObject, hasNoAttribute: name)
    return .error(e.asBaseException)
  }

  private func bindToSelf(_ py: Py, object: PyObject) -> PyResult<PyObject> {
    if let fn = py.cast.asBuiltinFunction(object) {
      let method = fn.bind(to: self.asObject)
      return .value(method.asObject)
    }

    if let fn = py.cast.asFunction(object) {
      let method = fn.bind(to: self.asObject)
      return .value(method.asObject)
    }

    if let prop = py.cast.asProperty(object) {
      return prop.bind(to: self.asObject)
    }

    // No re-binding needed.
    return .value(object)
  }


  // MARK: - Get method

  internal func getMethod(_ py: Py,
                          selector: PyString,
                          allowsCallableFromDict: Bool) -> Py.GetMethodResult {
    // Ignore 'allowsCallableFromDict' because… well we do not have '__dict__'.
    let result = self.getAttribute(py, name: selector)
    switch result {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if py.cast.isAttributeError(e.asObject) {
        return .notFound(e)
      }

      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError(py, message: "NoneType takes no arguments")
    }

    let result = py.none
    return .value(result.asObject)
  }

  // MARK: - Helpers

  internal static func invalidSelfArgument(
    _ py: Py,
    _ object: PyObject,
    swiftFnName: StaticString = #function
  ) -> PyResult<PyObject> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: "NoneType",
                                               swiftFnName: swiftFnName)

    return .error(error.asBaseException)
  }
}
