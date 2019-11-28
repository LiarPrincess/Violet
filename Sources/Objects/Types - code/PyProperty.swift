// In CPython:
// Objects -> descrobject.c

// sourcery: pytype = property
/// Native property implemented in Swift.
internal final class PyProperty: PyObject {

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

  internal let _getter: PyObject?
  internal let _setter: PyObject?
  internal let _deleter: PyObject?
  internal let _doc: PyObject?

  internal init(_ context: PyContext,
                getter: PyObject?,
                setter: PyObject?,
                deleter: PyObject?) {
    self._getter = getter is PyNone ? nil : getter
    self._setter = setter is PyNone ? nil : setter
    self._deleter = deleter is PyNone ? nil : deleter
    self._doc = nil

    super.init(type: context.builtins.types.property, hasDict: false)
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
    return self._getter ?? self.builtins.none
  }

  // sourcery: pyproperty = fset
  internal func getFSet() -> PyObject {
    return self._setter ?? self.builtins.none
  }

  // sourcery: pyproperty = fdel
  internal func getFDel() -> PyObject {
    return self._deleter ?? self.builtins.none
  }

  // MARK: - Call

  // sourcery: pymethod = __get__
  internal func get(object: PyObject) -> PyResult<PyObject> {
    if object is PyNone {
      return .value(self)
    }

    guard let propGet = self._getter else {
      return .attributeError("unreadable attribute")
    }

    return self.context.call(propGet, args: [object])
  }

  // sourcery: pymethod = __set__
  internal func set(object: PyObject, value: PyObject) -> PyResult<PyObject> {
    let isDelete = value is PyNone
    let fnOrNil = isDelete ? self._deleter : self._setter

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
}
