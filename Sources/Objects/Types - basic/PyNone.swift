import VioletCore

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

// sourcery: pytype = NoneType, isDefault
/// The Python None object, denoting lack of value.
public struct PyNone: PyObjectMixin, HasCustomGetMethod {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyNoneLayout()

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
}

/* MARKER

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "None"
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> Bool {
    return false
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return self.getAttribute(name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal func getAttribute(name: PyString) -> PyResult<PyObject> {
    // (Read following sentences with Bernadette Banner voice.)
    //
    // Descriptors use a comparision with 'None' to determine if they are either
    // invoked by an instance binding or a static binding.
    // Unfortunately, if the object itself is 'None' then this detection won't work.
    // Alas, my friends, welcome to 'None-Descriptor' hack.
    assert(self.isDescriptorStaticMarker)

    let staticProperty: PyObject?
    let descriptor: GetDescriptor?

    switch self.type.mroLookup(name: name) {
    case .value(let l):
      staticProperty = l.object
      descriptor = GetDescriptor(object: self, attribute: l.object)
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
      return unbound.flatMap(self.bindToSelf(object:))
    }

    if let p = staticProperty {
      return .value(p)
    }

    return .error(Py.newAttributeError(object: self, hasNoAttribute: name))
  }

  private func bindToSelf(object: PyObject) -> PyResult<PyObject> {
    if let fn = PyCast.asBuiltinFunction(object) {
      return .value(fn.bind(to: self))
    }

    if let fn = PyCast.asFunction(object) {
      return .value(fn.bind(to: self))
    }

    if let prop = PyCast.asProperty(object) {
      return prop.bind(to: self)
    }

    // No re-binding needed.
    return .value(object)
  }

  // MARK: - Get method

  internal func getMethod(
    selector: PyString,
    allowsCallableFromDict: Bool
  ) -> PyInstance.GetMethodResult {
    // Ignore 'allowsCallableFromDict' because… well we do not have '__dict__'.
    let result = self.getAttribute(name: selector)
    switch result {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if PyCast.isAttributeError(e) {
        return .notFound(e)
      }

      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNone> {
    let noArgs = args.isEmpty
    let noKwargs = kwargs?.elements.isEmpty ?? true
    guard noArgs && noKwargs else {
      return .typeError("NoneType takes no arguments")
    }

    return .value(Py.none)
  }
}

*/
