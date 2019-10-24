// In CPython:
// Objects -> descrobject.c

//static PyMethodDef property_methods[] = {
//  {"getter", property_getter, METH_O, getter_doc},
//  {"setter", property_setter, METH_O, setter_doc},
//  {"deleter", property_deleter, METH_O, deleter_doc},

// sourcery: pytype = property
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

    #warning("Add to PyContext")
    super.init()
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }
}
