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

  internal private(set) var getter: PyObject?
  internal private(set) var setter: PyObject?
  internal private(set) var deleter: PyObject?
  internal private(set) var doc: PyObject?

  internal init(getter: PyObject?,
                setter: PyObject?,
                deleter: PyObject?) {
    self.getter = getter is PyNone ? nil : getter
    self.setter = setter is PyNone ? nil : setter
    self.deleter = deleter is PyNone ? nil : deleter
    self.doc = nil

    super.init(type: Py.types.property)
  }

  /// Use only in `__new__`!
  override internal init(type: PyType) {
    self.getter = nil
    self.setter = nil
    self.deleter = nil
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
  internal func getFGet() -> PyObject {
    return self.getter ?? self.builtins.none
  }

  // sourcery: pyproperty = fset
  internal func getFSet() -> PyObject {
    return self.setter ?? self.builtins.none
  }

  // sourcery: pyproperty = fdel
  internal func getFDel() -> PyObject {
    return self.deleter ?? self.builtins.none
  }

  // MARK: - Call

  // sourcery: pymethod = __get__
  internal func get(object: PyObject) -> PyResult<PyObject> {
    if object is PyNone {
      return .value(self)
    }

    guard let propGet = self.getter else {
      return .attributeError("unreadable attribute")
    }

    switch self.builtins.call(callable: propGet, args: [object]) {
    case .value(let r):
      return .value(r)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __set__
  internal func set(object: PyObject, value: PyObject) -> PyResult<PyObject> {
    let isDelete = value is PyNone
    let fnOrNil = isDelete ? self.deleter : self.setter

    guard let fn = fnOrNil else {
      let msg = isDelete ? "can't delete attribute" : "can't set attribute"
      return .attributeError(msg)
    }

    switch self.builtins.call(callable: fn, args: [object, value]) {
    case .value(let r):
      return .value(r)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __delete__
  internal func del(object: PyObject) -> PyResult<PyObject> {
    self.set(object: object, value: self.builtins.none)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === type.builtins.property
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
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    switch PyProperty.initArguments.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(bind.count <= 4, "Invalid argument count returned from parser.")
      zelf.getter = bind.count >= 1 ? PyProperty.nilIfNone(bind[0]) : nil
      zelf.setter = bind.count >= 2 ? PyProperty.nilIfNone(bind[1]) : nil
      zelf.deleter = bind.count >= 3 ? PyProperty.nilIfNone(bind[2]) : nil
      zelf.doc = bind.count >= 4 ? bind[3] : nil
      return .value(zelf.builtins.none)

    case let .error(e):
      return .error(e)
    }
  }

  private static func nilIfNone(_ value: PyObject) -> PyObject? {
    return value is PyNone ? nil : value
  }
}
