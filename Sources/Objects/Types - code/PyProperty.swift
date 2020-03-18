// In CPython:
// Objects -> descrobject.c

// sourcery: pytype = property, default, hasGC, baseType
/// Native property implemented in Swift.
public class PyProperty: PyObject {

  internal static let doc: String = """
    property(fget=None, fset=None, fdel=None, doc=None)
    --

    Property attribute.

      fget
        function to be used for getting an attribute value
      fset
        function to be used for setting an attribute value
      fdel
        function to be used for del'ing an attribute
      doc
        docstring

    Typical use is to define a managed attribute x:

    class C(object):
        def getx(self): return self._x
        def setx(self, value): self._x = value
        def delx(self): del self._x
        x = property(getx, setx, delx, \"I\'m the \'x\' property.\")

    Decorators make defining new properties or modifying existing ones easy:

    class C(object):
        @property
        def x(self):
            \"I am the \'x\' property.\"
            return self._x
        @x.setter
        def x(self, value):
            self._x = value
        @x.deleter
        def x(self):
            del self._x
    """

  private var _get: PyObject?
  internal var get: PyObject? {
    get { return self.isNilOrNone(object: self._get) ? nil : self._get }
    set { self._get = newValue }
  }

  private var _set: PyObject?
  internal var set: PyObject? {
    get { return self.isNilOrNone(object: self._set) ? nil : self._set }
    set { self._set = newValue }
  }

  private var _del: PyObject?
  internal var del: PyObject? {
    get { return self.isNilOrNone(object: self._del) ? nil : self._del }
    set { self._del = newValue }
  }

  private func isNilOrNone(object: PyObject?) -> Bool {
    return object?.isNone ?? true
  }

  internal private(set) var doc: PyObject?

  override public var description: String {
    var properties = [String]()

    if let o = self.get {
      properties.append("get: \(String(describing: o))")
    }

    if let o = self.set {
      properties.append("set: \(String(describing: o))")
    }

    if let o = self.del {
      properties.append("del: \(String(describing: o))")
    }

    let p = properties.joined(separator: ", ")
    return "PyProperty(\(p))"
  }

  internal init(get: PyObject?,
                set: PyObject?,
                del: PyObject?) {
    self._get = get
    self._set = set
    self._del = del
    self.doc = nil

    super.init(type: Py.types.property)
  }

  /// Use only in `__new__`!
  override internal init(type: PyType) {
    self._get = nil
    self._set = nil
    self._del = nil
    self.doc = nil
    super.init(type: type)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Getters

  // sourcery: pyproperty = fget
  public func getFGet() -> PyObject {
    return self.get ?? Py.none
  }

  // sourcery: pyproperty = fset
  public func getFSet() -> PyObject {
    return self.set ?? Py.none
  }

  // sourcery: pyproperty = fdel
  public func getFDel() -> PyObject {
    return self.del ?? Py.none
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  public func get(object: PyObject, type: PyObject) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    return self.bind(to: object)
  }

  public func bind(to object: PyObject) -> PyResult<PyObject> {
    guard let propGet = self.get else {
      return .attributeError("unreadable attribute")
    }

    switch Py.call(callable: propGet, args: [object]) {
    case .value(let r):
      return .value(r)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Set

  // sourcery: pymethod = __set__
  public func set(object: PyObject, value: PyObject) -> PyResult<PyObject> {
    let isDelete = value is PyNone
    let fnOrNil = isDelete ? self.del : self.set

    guard let fn = fnOrNil else {
      let msg = isDelete ? "can't delete attribute" : "can't set attribute"
      return .attributeError(msg)
    }

    switch Py.call(callable: fn, args: [object, value]) {
    case .value(let r):
      return .value(r)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Del

  // sourcery: pymethod = __delete__
  public func del(object: PyObject) -> PyResult<PyObject> {
    self.set(object: object, value: Py.none)
  }

  // MARK: - Getter, setter, deleter

  internal static let getterDoc = "Descriptor to change the getter on a property."

  // sourcery: pymethod = getter, doc = getterDoc
  public func getter(value: PyObject) -> PyResult<PyObject> {
    return self.copy(get: value, set: nil, del: nil)
  }

  internal static let setterDoc = "Descriptor to change the setter on a property."

  // sourcery: pymethod = setter
  public func setter(value: PyObject) -> PyResult<PyObject> {
    return self.copy(get: nil, set: value, del: nil)
  }

  internal static let deleterDoc = "Descriptor to change the deleter on a property."

  // sourcery: pymethod = deleter
  public func deleter(value: PyObject) -> PyResult<PyObject> {
    return self.copy(get: nil, set: nil, del: value)
  }

  /// static PyObject *
  /// property_copy(PyObject *old, PyObject *get, PyObject *set, PyObject *del)
  private func copy(get: PyObject?,
                    set: PyObject?,
                    del: PyObject?) -> PyResult<PyObject> {
    func arg(selfProperty: PyObject?, override: PyObject?) -> PyObject {
      if let o = override, !o.isNone {
        return o
      }

      return selfProperty ?? Py.none
    }

    let getArg = arg(selfProperty: self.get, override: get)
    let setArg = arg(selfProperty: self.set, override: set)
    let delArg = arg(selfProperty: self.del, override: del)

    let docArg: PyObject
    if let d = self.doc, !d.isNone {
      // make _init use __doc__ from getter
      docArg = Py.none
    } else {
      docArg = self.doc ?? Py.none
    }

    let type = self.type
    let args = [getArg, setArg, delArg, docArg]
    let callResult = Py.call(callable: type, args: args)
    return callResult.asResult
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    let isBuiltin = type === Py.types.property
    let alloca = isBuiltin ? PyProperty.init(type:) : PyPropertyHeap.init(type:)
    return .value(alloca(type))
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["fget", "fset", "fdel", "doc"],
    format: "|OOOO:property"
  )

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyProperty,
                              args: [PyObject],
                              kwargs: PyDict?) -> PyResult<PyNone> {
    switch PyProperty.initArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      zelf.get = binding.optional(at: 0)
      zelf.set = binding.optional(at: 1)
      zelf.del = binding.optional(at: 2)
      zelf.doc = binding.optional(at: 3)
      return .value(Py.none)

    case let .error(e):
      return .error(e)
    }
  }
}
