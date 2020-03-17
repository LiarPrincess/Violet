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

  private var _getter: PyObject?
  internal var getter: PyObject? {
    get { return self._getter is PyNone ? nil : self._getter }
    set { self._getter = newValue }
  }

  private var _setter: PyObject?
  internal var setter: PyObject? {
    get { return self._getter is PyNone ? nil : self._getter }
    set { self._getter = newValue }
  }

  private var _deleter: PyObject?
  internal var deleter: PyObject? {
    get { return self._getter is PyNone ? nil : self._getter }
    set { self._getter = newValue }
  }

  internal private(set) var doc: PyObject?

  override public var description: String {
    return "PyProperty()"
  }

  internal init(getter: PyObject?,
                setter: PyObject?,
                deleter: PyObject?) {
    self._getter = getter
    self._setter = setter
    self._deleter = deleter
    self.doc = nil

    super.init(type: Py.types.property)
  }

  /// Use only in `__new__`!
  override internal init(type: PyType) {
    self._getter = nil
    self._setter = nil
    self._deleter = nil
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
    return self.getter ?? Py.none
  }

  // sourcery: pyproperty = fset
  public func getFSet() -> PyObject {
    return self.setter ?? Py.none
  }

  // sourcery: pyproperty = fdel
  public func getFDel() -> PyObject {
    return self.deleter ?? Py.none
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
    guard let propGet = self.getter else {
      return .attributeError("unreadable attribute")
    }

    switch Py.call(callable: propGet, args: [object]) {
    case .value(let r):
      return .value(r)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Getter

  // sourcery: pyproperty = getter, setter = setGetter
  public func getGetter() -> PyObject {
    return self.getter ?? Py.none
  }

  public func setGetter(value: PyObject) -> PyResult<()> {
    self._getter = value
    return .value()
  }

  // MARK: - Set

  // sourcery: pymethod = __set__
  public func set(object: PyObject, value: PyObject) -> PyResult<PyObject> {
    let isDelete = value is PyNone
    let fnOrNil = isDelete ? self.deleter : self.setter

    guard let fn = fnOrNil else {
      let msg = isDelete ? "can't delete attribute" : "can't set attribute"
      return .attributeError(msg)
    }

    switch Py.call(callable: fn, args: [object, value]) {
    case .value(let r):
      return .value(r)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Setter

  // sourcery: pyproperty = setter, setter = setSetter
  public func getSetter() -> PyObject {
    return self.setter ?? Py.none
  }

  public func setSetter(value: PyObject) -> PyResult<()> {
    self._setter = value
    return .value()
  }

  // MARK: - Del

  // sourcery: pymethod = __delete__
  public func del(object: PyObject) -> PyResult<PyObject> {
    self.set(object: object, value: Py.none)
  }

  // MARK: - Deleter

  // sourcery: pyproperty = deleter, deleter = setDeleter
  public func getDeleter() -> PyObject {
    return self.deleter ?? Py.none
  }

  public func setDeleter(value: PyObject) -> PyResult<()> {
    self._deleter = value
    return .value()
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
      zelf.getter = binding.optional(at: 0)
      zelf.setter = binding.optional(at: 1)
      zelf.deleter = binding.optional(at: 2)
      zelf.doc = binding.optional(at: 3)
      return .value(Py.none)

    case let .error(e):
      return .error(e)
    }
  }
}
