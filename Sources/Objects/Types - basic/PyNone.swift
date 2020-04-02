import Core

// In CPython:
// Objects -> object.c
// https://docs.python.org/3.7/c-api/none.html

// sourcery: pytype = NoneType, default
/// The Python None object, denoting lack of value.
public class PyNone: PyObject {

  override public var description: String {
    return "PyNone()"
  }

  // MARK: - Init

  override internal init() {
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
    // Unfortunatelly, if the object itself is 'None' then this detection won't work.
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
      // When we call it with 'None' as a 'object' it will return unbinded 'self'.
      // Then we will try to bind it manually.

      let unbinded = descr.call()
      return unbinded.flatMap(self.bindToSelf(object:))
    }

    if let p = staticProperty {
      return .value(p)
    }

    let msg = "\(self.typeName) object has no attribute '\(name.reprRaw())'"
    return .attributeError(msg)
  }

  private func bindToSelf(object: PyObject) -> PyResult<PyObject> {
    if let fn = object as? PyBuiltinFunction {
      return .value(fn.bind(to: self))
    }

    if let fn = object as? PyFunction {
      return .value(fn.bind(to: self))
    }

    if let prop = object as? PyProperty {
      return prop.bind(to: self)
    }

    // No re-binding needed.
    return .value(object)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    let noKwargs = kwargs?.data.isEmpty ?? true
    guard args.isEmpty && noKwargs else {
      return .typeError("NoneType takes no arguments")
    }

    return .value(Py.none)
  }
}
