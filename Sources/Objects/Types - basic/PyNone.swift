import VioletCore

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

// sourcery: pytype = NoneType, default
/// The Python None object, denoting lack of value.
public final class PyNone: PyObject, HasCustomGetMethod {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  override public var description: String {
    return "PyNone()"
  }

  // MARK: - Init

  override internal init() {
    // 'none' has only 1 instance and can't be subclassed,
    // so we can just pass the correct type to 'super.init'.
    super.init(type: Py.types.none)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("None")
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
    return AttributeHelper.extractName(from: name)
      .flatMap(self.getAttribute(name:))
  }

  public func getAttribute(name: PyString) -> PyResult<PyObject> {
    // (Read following sentences with Bernadette Banner voice.)
    //
    // Descriptors use a comparision with 'None' to determine if they are either
    // invoked by an instance binding or a static binding.
    // Unfortunately, if the object itself is 'None' then this detection won't work.
    // Alas, my friends, welcome to 'None-Descriptor' hack.
    assert(self.isDescriptorStaticMarker)

    let staticProperty: PyObject?
    let descriptor: GetDescriptor?

    switch self.type.lookup(name: name) {
    case .value(let p):
      staticProperty = p
      descriptor = GetDescriptor(object: self, attribute: p)
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

  public func getMethod(
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
