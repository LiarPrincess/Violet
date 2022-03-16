import VioletBytecode

// cSpell:ignore typeobject cmeth

// In CPython:
// Objects -> typeobject.c
// https://docs.python.org/3/library/functions.html#super

// sourcery: pytype = super, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PySuper: PyObjectMixin, HasCustomGetMethod {

  // sourcery: pytypedoc
  internal static let doc = """
    super() -> same as super(__class__, <first argument>)
    super(type) -> unbound super object
    super(type, obj) -> bound super object; requires isinstance(obj, type)
    super(type, type2) -> bound super object; requires issubclass(type2, type)
    Typical use to call a cooperative superclass method:
    class C(B):
        def meth(self, arg):
            super().meth(arg)
    This works for class methods too:
    class C(B):
        @classmethod
        def cmeth(cls, arg):
            super().cmeth(arg)
    """

  // sourcery: storedProperty
  /// Type that the user requested (`__thisclass__` in Python).
  ///
  /// For example:
  /// `super(int, True)` -> `requestedType` = `int` (even though value is `bool`).
  internal var thisClass: PyType? {
    get { self.thisClassPtr.pointee }
    nonmutating set { self.thisClassPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var object: PyObject? {
    get { self.objectPtr.pointee }
    nonmutating set { self.objectPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var objectType: PyType? {
    get { self.objectTypePtr.pointee }
    nonmutating set { self.objectTypePtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           requestedType: PyType?,
                           object: PyObject?,
                           objectType: PyType?) {
    self.initializeBase(py, type: type)
    self.thisClassPtr.initialize(to: requestedType)
    self.objectPtr.initialize(to: object)
    self.objectTypePtr.initialize(to: objectType)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PySuper(ptr: ptr)
    return "PySuper(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__repr__")
    }

    let typeName = zelf.thisClass?.getNameString() ?? "NULL"

    if let objectType = zelf.objectType {
      let objectTypeName = objectType.getNameString()
      let result = "<super: <class '\(typeName)'>, <\(objectTypeName) object>>"
      return PyResult(py, result)
    }

    return PyResult(py, "<super: <class '\(typeName)'>, NULL>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    guard let startType = zelf.objectType else {
      return Self.standardGetAttribute(py, zelf: zelf, name: name)
    }

    // We want __class__ to return the class of the super object
    // (i.e. super, or a subclass), not the class of su->obj.
    if Self.is__class__(py, name: name) {
      return Self.standardGetAttribute(py, zelf: zelf, name: name)
    }

    // CPython: 'su->type' and 'su->obj'
    // It should never be nil (nil is allowed only because it is needed in '__new__')
    guard let superType = zelf.thisClass, let superObject = zelf.object else {
      return PyResult(zelf)
    }

    // The 'zelf.objectType' determines the method resolution order to be searched.
    // The search starts from the class right after the 'zelf.type'.
    // https://docs.python.org/3/library/functions.html#super
    let mro = startType.mro
    let typeIndex = mro.firstIndex { $0 === superType } ?? mro.count
    let indexAfterTypeIndex = typeIndex + 1

    if indexAfterTypeIndex >= mro.count {
      return Self.standardGetAttribute(py, zelf: zelf, name: name)
    }

    for index in indexAfterTypeIndex..<mro.count {
      let base = mro[index]
      let dict = base.getDict(py)

      switch dict.get(py, key: name) {
      case .value(let res):
        if let descr = GetDescriptor(py, object: superObject, type: startType, attribute: res) {
          return descr.call()
        }

        return .value(res)

      case .notFound,
           .error:
        break // just go to next element (ignore error)
      }
    }

    // Just in case
    return Self.standardGetAttribute(py, zelf: zelf, name: name)
  }

  /// `skip` label in `self.getAttribute`
  internal static func standardGetAttribute(_ py: Py,
                                            zelf: PySuper,
                                            name: PyObject) -> PyResult<PyObject> {
    let zelfObject = zelf.asObject
    return AttributeHelper.getAttribute(py, object: zelfObject, name: name)
  }

  private static func is__class__(_ py: Py, name: PyObject) -> Bool {
    guard let string = py.cast.asString(name) else {
      return false
    }

    return string.value == "__class__"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Get method

  internal func getMethod(_ py: Py,
                          selector: PyString,
                          allowsCallableFromDict: Bool) -> Py.GetMethodResult {
    let selfObject = self.asObject
    let name = selector.asObject
    switch Self.__getattribute__(py, zelf: selfObject, name: name) {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if py.cast.isAttributeError(e.asObject) {
        return .notFound(e)
      }

      return .error(e)
    }
  }

  // MARK: - Getters

  internal static let thisClassDoc = "the class invoking super()"

  // sourcery: pyproperty = __thisclass__, doc = thisClassDoc
  internal static func __thisclass__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__thisclass__")
    }

    let result = zelf.thisClass?.asObject ?? py.none.asObject
    return PyResult(result)
  }

  internal static let selfDoc = "the instance invoking super(); may be None"

  // sourcery: pyproperty = __self__, doc = selfDoc
  internal static func __self__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__self__")
    }

    let result = zelf.object?.asObject ?? py.none.asObject
    return PyResult(result)
  }

  internal static let selfClassDoc = "the type of the instance invoking super(); may be None"

  // sourcery: pyproperty = __self_class__, doc = selfClassDoc
  internal static func __self_class__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__self_class__")
    }

    let result = zelf.objectType?.asObject ?? py.none.asObject
    return PyResult(result)
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal static func __get__(_ py: Py,
                               zelf: PyObject,
                               object: PyObject,
                               type: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__get__")
    }

    // Basically 'py.cast.isNone(object)'
    if py.isDescriptorStaticMarker(object) {
      return PyResult(zelf)
    }

    let isAlreadyBound = zelf.object != nil
    if isAlreadyBound {
      return PyResult(zelf)
    }

    // CPython: 'su->type'
    // It should never be nil (nil is allowed only because it is needed in '__new__')
    guard let superType = zelf.thisClass else {
      return PyResult(zelf)
    }

    // If super is an instance of a (strict) subclass of super, call its type
    if zelf.type !== py.types.super {
      let zelfType = zelf.type.asObject
      let result = py.call(callable: zelfType, args: [superType.asObject, object])
      return result.asResult
    }

    let objectType: PyType
    switch Self.checkSuper(py, zelf: zelf, type: superType, object: object) {
    case let .value(t): objectType = t
    case let .error(e): return .error(e)
    }

    let result = py.newSuper(requestedType: superType, object: object, objectType: objectType)
    return PyResult(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let result = py.memory.newSuper(py,
                                    type: type,
                                    requestedType: nil,
                                    object: nil,
                                    objectType: nil)

    return PyResult(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser(
    arguments: ["", ""],
    format: "|OO:super"
  )

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    if let e = ArgumentParser.noKwargsOrError(py,
                                              fnName: Self.pythonTypeName,
                                              kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    let noKwargs: PyDict? = nil
    switch Self.initArguments.bind(py, args: args, kwargs: noKwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let type = binding.optional(at: 0)
      let object = binding.optional(at: 1)
      return Self.__init__(py, zelf: zelf, type: type, object: object)

    case let .error(e):
      return .error(e)
    }
  }
}
