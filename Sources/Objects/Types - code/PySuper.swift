import VioletBytecode

// cSpell:ignore typeobject cmeth

// In CPython:
// Objects -> typeobject.c
// https://docs.python.org/3/library/functions.html#super

// sourcery: pytype = super, default, hasGC, baseType
public class PySuper: PyObject, HasCustomGetMethod {

  // MARK: - Doc

  internal static var doc = """
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

  /// Type that the user requested (`__thisclass__` in Python).
  ///
  /// For example:
  /// `super(int, True)` -> `requestedType` = `int` (even though value is `bool`).
  internal var thisClass: PyType?
  internal var object: PyObject?
  internal var objectType: PyType?

  override public var description: String {
    func describe(value: PyObject?) -> String {
      guard let v = value else { return "nil" }
      return String(describing: v)
    }

    let thisClass = describe(value: self.thisClass)
    let object = describe(value: self.object)
    let objectType = describe(value: self.objectType)
    return "PySuper(thisClass: \(thisClass), object: \(object), objectType: \(objectType))"
  }

  internal convenience init(requestedType: PyType?,
                            object: PyObject?,
                            objectType: PyType?) {
    self.init(type: Py.types.super,
              requestedType: requestedType,
              object: object,
              objectType: objectType)
  }

  /// Use only in `__new__`!
  private init(type: PyType,
               requestedType: PyType?,
               object: PyObject?,
               objectType: PyType?) {
    self.thisClass = requestedType
    self.object = object
    self.objectType = objectType
    super.init(type: type)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let typeName = self.thisClass?.getNameString() ?? "NULL"

    if let objectType = self.objectType {
      let objectTypeName = objectType.getName()
      return .value("<super: <class '\(typeName)'>, <\(objectTypeName) object>>")
    }

    return .value("<super: <class '\(typeName)'>, NULL>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    guard let startType = self.objectType else {
      return self.getAttributeSkip(name: name)
    }

    // We want __class__ to return the class of the super object
    // (i.e. super, or a subclass), not the class of su->obj.
    if self.is__class__(name: name) {
      return self.getAttributeSkip(name: name)
    }

    // CPython: 'su->type' and 'su->obj'
    // It should never be nil (nil is allowed only because it is needed in '__new__')
    guard let suType = self.thisClass, let suObj = self.object else {
      return .value(self)
    }

    // The 'self.objectType' determines the method resolution order to be searched.
    // The search starts from the class right after the 'self.type'.
    // https://docs.python.org/3/library/functions.html#super
    let mro = startType.getMRO()
    let typeIndex = mro.firstIndex { $0 === suType } ?? mro.count
    let indexAfterTypeIndex = typeIndex + 1

    if indexAfterTypeIndex >= mro.count {
      return self.getAttributeSkip(name: name)
    }

    for index in indexAfterTypeIndex..<mro.count {
      let base = mro[index]
      let dict = base.getDict()

      switch dict.get(key: name) {
      case .value(let res):
        if let descr = GetDescriptor(object: suObj, type: startType, attribute: res) {
          return descr.call()
        }

        return .value(res)

      case .notFound,
           .error:
        break // just go to next element (ignore error)
      }
    }

    // Just in case
    return self.getAttributeSkip(name: name)
  }

  /// `skip` label in `self.getAttribute`
  internal func getAttributeSkip(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  private func is__class__(name: PyObject) -> Bool {
    guard let string = PyCast.asString(name) else {
      return false
    }

    return string.value == "__class__"
  }

  // MARK: - Get method

  internal func getMethod(
    selector: PyString,
    allowsCallableFromDict: Bool
  ) -> PyInstance.GetMethodResult {
    switch self.getAttribute(name: selector) {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if e.isAttributeError {
        return .notFound(e)
      }

      return .error(e)
    }
  }

  // MARK: - Getters

  internal static let thisClassDoc = "the class invoking super()"

  // sourcery: pyproperty = __thisclass__, doc = thisClassDoc
  internal func getThisClass() -> PyType? {
    return self.thisClass
  }

  internal static let selfDoc = "the instance invoking super(); may be None"

  // sourcery: pyproperty = __self__, doc = selfDoc
  internal func getSelf() -> PyObject? {
    return self.object
  }

  internal static let selfClassDoc = "the type of the instance invoking super(); may be None"

  // sourcery: pyproperty = __self_class__, doc = selfClassDoc
  internal func getSelfClass() -> PyObject? {
    return self.object
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    // Basically 'object.isNone'
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    let isAlreadyBound = self.object != nil
    if isAlreadyBound {
      return .value(self)
    }

    // CPython: 'su->type'
    // It should never be nil (nil is allowed only because it is needed in '__new__')
    guard let suType = self.thisClass else {
      return .value(self)
    }

    // If su is an instance of a (strict) subclass of super, call its type
    if self.type !== Py.types.super {
      return Py.call(callable: self.type, args: [suType, object]).asResult
    }

    let objectType: PyType
    switch self.checkSuper(type: suType, object: object) {
    case let .value(t): objectType = t
    case let .error(e): return .error(e)
    }

    let result = PySuper(requestedType: suType,
                         object: object,
                         objectType: objectType)

    return .value(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PySuper> {
    let result = PySuper(type: type,
                         requestedType: nil,
                         object: nil,
                         objectType: nil)

    return .value(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["", ""],
    format: "|OO:super"
  )

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "super", kwargs: kwargs) {
      return .error(e)
    }

    switch PySuper.initArguments.bind(args: args, kwargs: nil) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let type = binding.optional(at: 0)
      let object = binding.optional(at: 1)
      return self.pyInit(type: type, object: object) // In separate file

    case let .error(e):
      return .error(e)
    }
  }
}
