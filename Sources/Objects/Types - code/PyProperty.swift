// cSpell:ignore descrobject getx setx delx del'ing

// In CPython:
// Objects -> descrobject.c

// sourcery: pytype = property, default, hasGC, baseType
// sourcery: subclassInstancesHave__dict__
/// Native property implemented in Swift.
public class PyProperty: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
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
    get { PyCast.isNilOrNone(self._get) ? nil : self._get }
    set { self._get = newValue }
  }

  private var _set: PyObject?
  internal var set: PyObject? {
    get { PyCast.isNilOrNone(self._set) ? nil : self._set }
    set { self._set = newValue }
  }

  private var _del: PyObject?
  internal var del: PyObject? {
    get { PyCast.isNilOrNone(self._del) ? nil : self._del }
    set { self._del = newValue }
  }

  internal private(set) var doc: PyObject?

  override public var description: String {
    var properties = [String]()
    if let o = self.get { properties.append("get: \(o)") }
    if let o = self.set { properties.append("set: \(o)") }
    if let o = self.del { properties.append("del: \(o)") }
    let p = properties.joined(separator: ", ")
    return "PyProperty(\(p))"
  }

  internal convenience init(get: PyObject?, set: PyObject?, del: PyObject?) {
    let type = Py.types.property
    self.init(type: type, get: get, set: set, del: del)
  }

  internal init(type: PyType, get: PyObject?, set: PyObject?, del: PyObject?) {
    self._get = get
    self._set = set
    self._del = del
    self.doc = nil
    super.init(type: type)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Getters

  // sourcery: pyproperty = fget
  internal func getFGet() -> PyObject? {
    return self.get
  }

  // sourcery: pyproperty = fset
  internal func getFSet() -> PyObject? {
    return self.set
  }

  // sourcery: pyproperty = fdel
  internal func getFDel() -> PyObject? {
    return self.del
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    return self.bind(to: object)
  }

  internal func bind(to object: PyObject) -> PyResult<PyObject> {
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
  internal func set(object: PyObject, value: PyObject) -> PyResult<PyObject> {
    let isDelete = PyCast.isNone(value)
    if isDelete {
      guard let fn = self.del else {
        return .attributeError("can't delete attribute")
      }

      let callResult = Py.call(callable: fn, arg: object)
      return callResult.asResult
    }

    guard let fn = self.set else {
      return .attributeError("can't set attribute")
    }

    let callResult = Py.call(callable: fn, args: [object, value])
    return callResult.asResult
  }

  // MARK: - Del

  // sourcery: pymethod = __delete__
  internal func del(object: PyObject) -> PyResult<PyObject> {
    self.set(object: object, value: Py.none)
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__, setter = setDoc
  internal func getDoc() -> PyObject? {
    return self.doc
  }

  internal func setDoc(_ object: PyObject) -> PyResult<Void> {
    if PyCast.isNone(object) {
      self.doc = nil
      return .value()
    }

    self.doc = object
    return .value()
  }

  // MARK: - Getter, setter, deleter

  internal static let getterDoc = "Descriptor to change the getter on a property."

  // sourcery: pymethod = getter, doc = getterDoc
  internal func getter(value: PyObject) -> PyResult<PyObject> {
    return self.copy(get: value, set: nil, del: nil)
  }

  internal static let setterDoc = "Descriptor to change the setter on a property."

  // sourcery: pymethod = setter
  internal func setter(value: PyObject) -> PyResult<PyObject> {
    return self.copy(get: nil, set: value, del: nil)
  }

  internal static let deleterDoc = "Descriptor to change the deleter on a property."

  // sourcery: pymethod = deleter
  internal func deleter(value: PyObject) -> PyResult<PyObject> {
    return self.copy(get: nil, set: nil, del: value)
  }

  /// static PyObject *
  /// property_copy(PyObject *old, PyObject *get, PyObject *set, PyObject *del)
  private func copy(get: PyObject?,
                    set: PyObject?,
                    del: PyObject?) -> PyResult<PyObject> {
    func resolveOverride(value: PyObject?, override: PyObject?) -> PyObject {
      if let o = override, !PyCast.isNone(o) {
        return o
      }

      return value ?? Py.none
    }

    let getArg = resolveOverride(value: self.get, override: get)
    let setArg = resolveOverride(value: self.set, override: set)
    let delArg = resolveOverride(value: self.del, override: del)

    let docArg: PyObject
    if let d = self.doc, !PyCast.isNone(d) {
      docArg = d
    } else {
      docArg = Py.none
    }

    let type = self.type
    let args = [getArg, setArg, delArg, docArg]
    let callResult = Py.call(callable: type, args: args)
    return callResult.asResult
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyProperty> {
    let isBuiltin = type === Py.types.property
    let result = isBuiltin ?
      PyMemory.newProperty(type: type, get: nil, set: nil, del: nil):
      PyPropertyHeap(type: type, get: nil, set: nil, del: nil)

    return .value(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["fget", "fset", "fdel", "doc"],
    format: "|OOOO:property"
  )

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    switch PyProperty.initArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      self.get = binding.optional(at: 0)
      self.set = binding.optional(at: 1)
      self.del = binding.optional(at: 2)
      self.doc = binding.optional(at: 3)
      return .value(Py.none)

    case let .error(e):
      return .error(e)
    }
  }
}
