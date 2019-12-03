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

  internal let getter: PyObject?
  internal let setter: PyObject?
  internal let deleter: PyObject?
  internal let doc: PyObject?

  internal init(_ context: PyContext,
                getter: PyObject?,
                setter: PyObject?,
                deleter: PyObject?) {
    self.getter = getter is PyNone ? nil : getter
    self.setter = setter is PyNone ? nil : setter
    self.deleter = deleter is PyNone ? nil : deleter
    self.doc = nil

    super.init(type: context.builtins.types.property)
  }

  /// Use in `__new__`!
  internal override init(type: PyType) {
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

    return self.context.call(propGet, args: [object])
  }

  // sourcery: pymethod = __set__
  internal func set(object: PyObject, value: PyObject) -> PyResult<PyObject> {
    let isDelete = value is PyNone
    let fnOrNil = isDelete ? self.deleter : self.setter

    guard let fn = fnOrNil else {
      let msg = isDelete ? "can't delete attribute" : "can't set attribute"
      return .attributeError(msg)
    }

    return self.context.call(fn, args: [object, value])
  }

  // sourcery: pymethod = __delete__
  internal func del(object: PyObject) -> PyResult<PyObject> {
    self.set(object: object, value: self.builtins.none)
  }

  // MARK: - Python new/init

  // sourcery: pymethod = __new__
  internal static func new(type: PyType,
                           args: [PyObject],
                           kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === type.builtins.property
    let alloca = isBuiltin ? PyProperty.init(type:) : PyPropertyHeap.init(type:)
    return .value(alloca(type))
  }
}
