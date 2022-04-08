// cSpell:ignore descrobject getx setx delx del'ing

// In CPython:
// Objects -> descrobject.c

// sourcery: pytype = property, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
/// Native property implemented in Swift.
public struct PyProperty: PyObjectMixin {

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

  // MARK: - Properties

  // sourcery: storedProperty
  internal var _get: PyObject? {
    get { self._getPtr.pointee }
    nonmutating set { self._getPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var _set: PyObject? {
    get { self._setPtr.pointee }
    nonmutating set { self._setPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var _del: PyObject? {
    get { self._delPtr.pointee }
    nonmutating set { self._delPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var doc: PyObject? {
    get { self.docPtr.pointee }
    nonmutating set { self.docPtr.pointee = newValue }
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           get: PyObject?,
                           set: PyObject?,
                           del: PyObject?,
                           doc: PyObject?) {
    self.initializeBase(py, type: type)
    self._getPtr.initialize(to: get)
    self._setPtr.initialize(to: set)
    self._delPtr.initialize(to: del)
    self.docPtr.initialize(to: doc)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyProperty(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "get", value: zelf._get as Any)
    result.append(name: "set", value: zelf._set as Any)
    result.append(name: "del", value: zelf._del as Any)
    result.append(name: "doc", value: zelf.doc as Any)
    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Getters

  // sourcery: pyproperty = fget
  internal static func fget(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "fget")
    }

    return PyResult(py, zelf._get)
  }

  // sourcery: pyproperty = fset
  internal static func fset(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "fset")
    }

    return PyResult(py, zelf._set)
  }

  // sourcery: pyproperty = fdel
  internal static func fdel(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "fdel")
    }

    return PyResult(py, zelf._del)
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal static func __get__(_ py: Py,
                               zelf _zelf: PyObject,
                               object: PyObject,
                               type: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__get__")
    }

    if py.isDescriptorStaticMarker(object) {
      return PyResult(zelf)
    }

    return zelf.bind(py, object: object)
  }

  internal func bind(_ py: Py, object: PyObject) -> PyResult {
    guard let propGet = self._get, !py.cast.isNone(propGet) else {
      return .attributeError(py, message: "unreadable attribute")
    }

    switch py.call(callable: propGet, args: [object]) {
    case .value(let r):
      return .value(r)
    case .error(let e),
        .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Set

  // sourcery: pymethod = __set__
  internal static func __set__(_ py: Py,
                               zelf _zelf: PyObject,
                               object: PyObject,
                               value: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__set__")
    }

    return Self.setOrDelete(py, zelf: zelf, object: object, value: value)
  }

  private static func setOrDelete(_ py: Py,
                                  zelf: PyProperty,
                                  object: PyObject,
                                  value: PyObject) -> PyResult {
    let isDelete = py.cast.isNone(value)
    if isDelete {
      guard let fn = zelf._del, !py.cast.isNone(fn) else {
        return .attributeError(py, message: "can't delete attribute")
      }

      let callResult = py.call(callable: fn, arg: object)
      return callResult.asResult
    }

    guard let fn = zelf._set, !py.cast.isNone(fn) else {
      return .attributeError(py, message: "can't set attribute")
    }

    let callResult = py.call(callable: fn, args: [object, value])
    return callResult.asResult
  }

  // MARK: - Del

  // sourcery: pymethod = __delete__
  internal static func __delete__(_ py: Py,
                                  zelf _zelf: PyObject,
                                  object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delete__")
    }

    let none = py.none.asObject
    return Self.setOrDelete(py, zelf: zelf, object: object, value: none)
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__, setter
  internal static func __doc__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__doc__")
    }

    return PyResult(py, zelf.doc)
  }

  internal static func __doc__(_ py: Py,
                               zelf _zelf: PyObject,
                               value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__doc__")
    }

    guard let value = value, !py.cast.isNone(value) else {
      zelf.doc = nil
      return .none(py)
    }

    zelf.doc = value
    return .none(py)
  }

  // MARK: - Getter, setter, deleter

  internal static let getterDoc = "Descriptor to change the getter on a property."

  // sourcery: pymethod = getter, doc = getterDoc
  internal static func getter(_ py: Py,
                              zelf _zelf: PyObject,
                              value: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "getter")
    }

    return zelf.copy(py, get: value, set: nil, del: nil)
  }

  internal static let setterDoc = "Descriptor to change the setter on a property."

  // sourcery: pymethod = setter
  internal static func setter(_ py: Py,
                              zelf _zelf: PyObject,
                              value: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "setter")
    }

    return zelf.copy(py, get: nil, set: value, del: nil)
  }

  internal static let deleterDoc = "Descriptor to change the deleter on a property."

  // sourcery: pymethod = deleter
  internal static func deleter(_ py: Py,
                               zelf _zelf: PyObject,
                               value: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "deleter")
    }

    return zelf.copy(py, get: nil, set: nil, del: value)
  }

  /// static PyObject *
  /// property_copy(PyObject *old, PyObject *get, PyObject *set, PyObject *del)
  private func copy(_ py: Py,
                    get: PyObject?,
                    set: PyObject?,
                    del: PyObject?) -> PyResult {
    func resolveOverride(value: PyObject?, override: PyObject?) -> PyObject {
      if let o = override, !py.cast.isNone(o) {
        return o
      }

      return value ?? py.none.asObject
    }

    let getArg = resolveOverride(value: self._get, override: get)
    let setArg = resolveOverride(value: self._set, override: set)
    let delArg = resolveOverride(value: self._del, override: del)

    let docArg: PyObject
    if let d = self.doc, !py.cast.isNone(d) {
      docArg = d
    } else {
      docArg = py.none.asObject
    }

    let type = self.type.asObject
    let args = [getArg, setArg, delArg, docArg]
    let callResult = py.call(callable: type, args: args)
    return callResult.asResult
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let result = py.memory.newProperty(type: type,
                                       get: nil,
                                       set: nil,
                                       del: nil,
                                       doc: nil)

    return PyResult(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["fget", "fset", "fdel", "doc"],
    format: "|OOOO:property"
  )

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }

    switch PyProperty.initArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      zelf._get = binding.optional(at: 0)
      zelf._set = binding.optional(at: 1)
      zelf._del = binding.optional(at: 2)
      zelf.doc = binding.optional(at: 3)
      return .none(py)

    case let .error(e):
      return .error(e)
    }
  }
}
