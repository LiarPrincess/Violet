import VioletCore

// swiftlint:disable function_body_length
// swiftlint:disable file_length

private struct PyTypeNewArgs {
  /// First argument in `__new__` invocation
  fileprivate let metatype: PyType
  /// Args passed to original function
  fileprivate let args: [PyObject]
  /// Kwargs passed to original function
  fileprivate let kwargs: PyDict?

  /// Name string is the class name and becomes the `__name__` attribute
  /// `self.args[0] as String`
  fileprivate let name: PyString
  /// Bases tuple itemizes the base classes and becomes the __bases__ attribute;
  /// `self.args[1] as Tuple`
  fileprivate let bases: [PyType]
  /// Dict is the namespace containing definitions for class body and is copied
  /// to a standard dictionary to become the `__dict__` attribute.
  /// `self.args[2] as Dict`
  fileprivate let dict: PyDict
}

extension PyType {

  // MARK: - Python new

  private static let newArguments = ArgumentParser(
    arguments: ["name", "bases", "dict"],
    format: "OOO:type.__new__"
  )

  // sourcery: pystaticmethod = __new__
  /// static PyObject *
  /// type_new(PyTypeObject *metatype, PyObject *args, PyObject *kwds)
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    // Special case: type(x) should return x->ob_type
    if type === py.types.type {
      let hasSingleArg = args.count == 1
      let noKwargs = kwargs?.elements.isEmpty ?? true

      if hasSingleArg && noKwargs {
        let result = args[0].type
        return .value(result.asObject)
      }

      if args.count != 3 {
        return .typeError(py, message: "type() takes 1 or 3 arguments")
      }
    }

    // class type(name, bases, dict)
    switch self.newArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 3, "Invalid required argument count.")
      assert(binding.optionalCount == 0, "Invalid optional argument count.")

      let arg0 = binding.required(at: 0)
      guard let name = py.cast.asString(arg0) else {
        let t = arg0.typeName
        return .typeError(py, message: "type.__new__() argument 1 must be str, not \(t)")
      }

      let arg1 = binding.required(at: 1)
      guard let bases = py.cast.asTuple(arg1) else {
        let t = arg1.typeName
        return .typeError(py, message: "type.__new__() argument 2 must be tuple, not \(t)")
      }

      let arg2 = binding.required(at: 2)
      guard let dict = py.cast.asDict(arg2) else {
        let t = arg2.typeName
        return .typeError(py, message: "type.__new__() argument 3 must be dict, not \(t)")
      }

      var baseTypes = [PyType]()
      switch PyType.guaranteeAllBasesAreTypes(py, bases: bases) {
      case let .value(r): baseTypes = r
      case let .error(e): return .error(e)
      }

      let args = PyTypeNewArgs(
        metatype: type,
        args: args,
        kwargs: kwargs,
        name: name,
        bases: baseTypes,
        dict: dict
      )

      return PyType.__new__(py, args: args)

    case let .error(e):
      return .error(e)
    }
  }

  private static func guaranteeAllBasesAreTypes(
    _ py: Py,
    bases: PyTuple
  ) -> PyResult<[PyType]> {
    var result = [PyType]()
    result.reserveCapacity(bases.elements.count)

    for object in bases.elements {
      guard let base = py.cast.asType(object) else {
        return .typeError(py, message: "bases must be types")
      }

      guard base.typeFlags.isBaseType else {
        let baseName = base.getNameString()
        let message = "type '\(baseName)' is not an acceptable base type"
        return .typeError(py, message: message)
      }

      result.append(base)
    }

    return .value(result)
  }

  /// static PyObject *
  /// type_new(PyTypeObject *metatype, PyObject *args, PyObject *kwds)
  private static func __new__(_ py: Py, args: PyTypeNewArgs) -> PyResult<PyObject> {
    let base: PyType
    var bases = args.bases
    var metatype = args.metatype

    if bases.isEmpty {
      base = py.types.object
      bases = [base]
    } else {
      // Search the bases for the proper metatype to deal with this
      switch Self.calculateMetaclass(py, metatype: metatype, bases: bases) {
      case let .value(t): metatype = t
      case let .error(e): return .error(e)
      }

      // Calculate best base using bases memory layout (layout conflict -> error).
      // We will call this base 'solid' - our new type will have the same memory
      // layout (+- '__dict__' because it does not matter).
      switch Self.getSolidBase(py, bases: bases) {
      case let .value(r): base = r
      case let .error(e): return .error(e)
      }
    }

    // Assuming we don't have slots
    let mro: MethodResolutionOrder
    switch MethodResolutionOrder.linearize(py, baseClasses: bases) {
    case let .value(r): mro = r
    case let .error(e): return .error(e)
    }

    // Create type object
    let name = args.name.value

    var typeFlags = TypeFlags()
    typeFlags.isDefault = true
    typeFlags.isHeapType = true
    typeFlags.isBaseType = true
    typeFlags.hasFinalize = true
    typeFlags.hasGC = base.typeFlags.hasGC

    typeFlags.isLongSubclass = base.typeFlags.isLongSubclass
    typeFlags.isListSubclass = base.typeFlags.isListSubclass
    typeFlags.isTupleSubclass = base.typeFlags.isTupleSubclass
    typeFlags.isBytesSubclass = base.typeFlags.isBytesSubclass
    typeFlags.isUnicodeSubclass = base.typeFlags.isUnicodeSubclass
    typeFlags.isDictSubclass = base.typeFlags.isDictSubclass
    typeFlags.isBaseExceptionSubclass = base.typeFlags.isBaseExceptionSubclass
    typeFlags.isTypeSubclass = base.typeFlags.isTypeSubclass

    typeFlags.instancesHave__dict__ = base.typeFlags.instancesHave__dict__
      || base.typeFlags.subclassInstancesHave__dict__

    let staticMethods = PyStaticCall.KnownNotOverriddenMethods(
      py,
      mroWithoutCurrentlyCreatedType: mro.resolutionOrder,
      dictForCurrentlyCreatedType: args.dict
    )

    let type = py.memory.newType(
      py,
      type: metatype, // <- Important!
      name: name,
      qualname: name, // May be overridden later (if we have it in dict)
      flags: typeFlags,
      base: base,
      bases: mro.baseClasses,
      mroWithoutSelf: mro.resolutionOrder,
      subclasses: [],
      layout: base.layout,
      staticMethods: staticMethods,
      debugFn: base.debugFn,
      deinitialize: base.deinitialize
    )

    // Initialize '__dict__' from passed-in dict
    // Also: we have to COPY it! Swift COW will take care of this.
    let dict = args.dict.copy()
    type.__dict__ = dict

    // =========================================================================
    // === We filled flags and set __dict__, so the 'core' type is finished. ===
    // ===       Now we *just* need to fill some additional properties       ===
    // =========================================================================

    // Set __module__ (but remember that we may already have it)
    if let e = Self.setModuleFromCurrentFrameGlobalsIfNotPresent(py, type: type) {
      return .error(e)
    }

    // Set qualname to dict['__qualname__'] if available.
    // Otherwise it will stay the same as during 'init' (see ctor call above).
    if let e = Self.setQualnameFromDictIfPresent(py, type: type) {
      return .error(e)
    }

    // In CPython they set '__doc__' now.
    // We don't have to, because we store '__doc__' in dict (and not as property).

    // Special-case __new__: if it's a plain function, make it a static
    Self.convertFunctionToStaticMethodIfNeeded(py, type: type, fnName: .__new__)

    // Special-case '__init_subclass__' and '__class_getitem__':
    // if they are plain functions, make them class methods
    Self.convertFunctionToClassMethodIfNeeded(py, type: type, fnName: .__init_subclass__)
    Self.convertFunctionToClassMethodIfNeeded(py, type: type, fnName: .__class_getitem__)

    // Add properties/methods connected to '__dict__'
    Self.add__dict__PropertyIfNotPresent(py, type: type)
    Self.add__getattribute__MethodIfNotPresent(py, type: type)
    Self.add__setattr__MethodIfNotPresent(py, type: type)

    // Store type in class cell if one is supplied
    // class Elsa:
    //   def let_it_go(self):
    //     c = __class__ # <-- this uses '__class__' cell
    if let e = Self.fill__classcell__(py, type: type) {
      return .error(e.asBaseException)
    }

    // Call '__set_name__' on all descriptors in a newly generated type
    if let e = Self.call__set_name__OnDictEntries(py, type: type) {
      return .error(e)
    }

    // Call '__init_subclass__' on the parent of a newly generated type
    if let e = Self.call__init_subclass__OnParent(py, type: type, kwargs: args.kwargs) {
      return .error(e.asBaseException)
    }

    return .value(type.asObject)
  }

  // MARK: - Metaclass

  /// Determine the most derived metatype.
  /// PyTypeObject *
  /// _PyType_CalculateMetaclass(PyTypeObject *metatype, PyObject *bases)
  internal static func calculateMetaclass(_ py: Py,
                                          metatype: PyType,
                                          bases: [PyType]) -> PyResult<PyType> {
    var winner = metatype
    for tmp in bases {
      let tmpType = tmp.type

      // Get to the most specific type (lowest subclass)
      if winner.isSubtype(of: tmpType) {
        continue
      }

      if tmpType.isSubtype(of: winner) {
        winner = tmpType
        continue
      }

      let message = "metaclass conflict: the metaclass of a derived class " +
      "must be a (non-strict) subclass of the metaclasses of all its bases"

      return .typeError(py, message: message)
    }

    return .value(winner)
  }

  // MARK: - Best base

  /// Solid base - traverse class hierarchy (from derived to base)
  /// until we reach something with defined layout.
  ///
  /// For example:
  ///   Given:   Bool -> Int -> Object
  ///   Returns: Int layout
  ///   Reason: 'Bool' and 'Int' have the same layout (single BigInt property),
  ///            but 'Int' and 'Object' have different layouts.
  ///
  /// static PyTypeObject *
  /// best_base(PyObject *bases)
  private static func getSolidBase(_ py: Py, bases: [PyType]) -> PyResult<PyType> {
    assert(bases.any)

    var result: PyType?

    for candidate in bases {
      guard let currentResult = result else {
        result = candidate
        continue
      }

      let layout = candidate.layout
      if layout.isEqual(to: currentResult.layout) {
        // do nothing…
        // class A(int): pass
        // class B(int): pass
        // class C(A, B): pass <- equal layout of A and B
      } else if layout.isAddingNewProperties(to: currentResult.layout) {
        result = candidate
      } else if currentResult.layout.isAddingNewProperties(to: layout) {
        // nothing, 'currentResult' has already more fields
      } else {
        // we are in different 'branches' of layout hierarchy
        let message = "multiple bases have instance lay-out conflict"
        return .typeError(py, message: message)
      }
    }

    // We can force unwrap because we checked 'bases.any' at the top.
    // swiftlint:disable:next force_unwrapping
    return .value(result!)
  }

  // MARK: - __module__

  private static func setModuleFromCurrentFrameGlobalsIfNotPresent(
    _ py: Py,
    type: PyType
  ) -> PyBaseException? {
    let dict = type.__dict__
    let isAlreadyPresent = dict.get(id: .__module__) != nil
    if isAlreadyPresent {
      return nil
    }

    let globals: PyDict
    switch py.globals() {
    case let .value(g): globals = g
    case let .error(e): return e
    }

    if let module = globals.get(id: .__name__) {
      switch type.setModule(py, value: module) {
      case .value: break
      case .error(let e): return e
      }
    }

    return nil
  }

  // MARK: - __qualname__

  private static func setQualnameFromDictIfPresent(
    _ py: Py,
    type: PyType
  ) -> PyBaseException? {
    let dict = type.__dict__

    // Otherwise it will stay the same as during 'init'
    if let qualname = dict.get(id: .__qualname__) {
      switch type.setQualname(py, value: qualname) {
      case .value: break
      case .error(let e): return e
      }
    }

    return nil
  }

  // MARK: - Function -> Static/class method

  private static func convertFunctionToStaticMethodIfNeeded(
    _ py: Py,
    type: PyType,
    fnName: IdString
  ) {
    let dict = type.__dict__

    guard let object = dict.get(id: fnName) else {
      return
    }

    guard let function = py.cast.asFunction(object) else {
      return
    }

    let method = py.newStaticMethod(callable: function)
    dict.set(id: fnName, to: method.asObject)
  }

  private static func convertFunctionToClassMethodIfNeeded(
 _ py: Py,
    type: PyType,
    fnName: IdString
  ) {
    let dict = type.__dict__

    guard let object = dict.get(id: fnName) else {
      return
    }

    guard let function = py.cast.asFunction(object) else {
      return
    }

    let method = py.newClassMethod(callable: function)
    dict.set(id: fnName, to: method.asObject)
  }

  // MARK: - __dict__ property

  private static func add__dict__PropertyIfNotPresent(_ py: Py, type: PyType) {
    // If any base class has '__dict__' then we don't have to re-add it.
    // To be really honest, I'm not really sure if this check is needed.
    // Even if we have custom '__dict__' getter what else can it return?
    // Anyway, we will not override it.

    if Self.isInMroExcludingObject(py, type: type, name: .__dict__) {
      return
    }

    let property = PyProperty.wrap(
      doc: nil,
      get: Self.getHeapType__dict__(_:zelf:),
      set: Self.setHeapType__dict__(_:zelf:value:),
      del: Self.delHeapType__dict__(_:zelf:)
    )

    let dict = type.__dict__
    dict.set(id: .__dict__, to: property.asObject)
  }

  private static func isInMroExcludingObject(_ py: Py,
                                             type: PyType,
                                             name: IdString) -> Bool {
    let mro = type.mro

    for base in mro {
      let isObject = base === py.types.object
      if isObject {
        // 'Excluding object' <- see this method name
        // 'break' because object is always last in 'mro'
        break
      }

      let lookup = base.mroLookup(name: name)
      if lookup != nil {
        return true
      }
    }

    return false
  }

  /// This method will be called when we get `__dict__` property
  /// on heap type instance.
  private static func getHeapType__dict__(_ py: Py,
                                          zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = py.cast.asType(zelf) else {
      return Self.invalidSelfArgumentFor__dict__(py, object: zelf)
    }

    let result = zelf.__dict__
    return .value(result.asObject)
  }

  private static func setHeapType__dict__(_ py: Py,
                                          zelf: PyObject,
                                          value: PyObject) -> PyResult<PyObject> {
    guard let zelf = py.cast.asType(zelf) else {
      return Self.invalidSelfArgumentFor__dict__(py, object: zelf)
    }

    guard let dict = py.cast.asDict(value) else {
      let message = "__dict__ must be set to a dictionary, not a '\(value.typeName)'"
      return .typeError(py, message: message)
    }

    zelf.__dict__ = dict
    return .none(py)
  }

  private static func delHeapType__dict__(_ py: Py,
                                          zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = py.cast.asType(zelf) else {
      return Self.invalidSelfArgumentFor__dict__(py, object: zelf)
    }

    // There always has to be an dict:
    // >>> class Princess(): pass
    // ...
    // >>> elsa = Princess() # well, technically Elsa is a queen
    // >>> del elsa.__dict__
    // >>> print(elsa.__dict__)
    // {}
    zelf.__dict__ = py.newDict()
    return .none(py)
  }

  private static func invalidSelfArgumentFor__dict__(
    _ py: Py,
    object: PyObject
  ) -> PyResult<PyObject> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: "type",
                                               fnName: "__dict__")
    return .error(error.asBaseException)
  }

  // MARK: - __getattribute__ method

  private static func add__getattribute__MethodIfNotPresent(_ py: Py, type: PyType) {
    // If any base class has '__getattribute__' then we don't have to re-add it.
    if Self.isInMroExcludingObject(py, type: type, name: .__getattribute__) {
      return
    }

    let getattribute = PyBuiltinFunction.wrap(
      name: "__getattribute__",
      doc: nil,
      fn: AttributeHelper.getAttribute(_:object:name:)
    )

    let dict = type.__dict__
    dict.set(id: .__getattribute__, to: getattribute.asObject)
  }

  // MARK: - __setattr__ method

  private static func add__setattr__MethodIfNotPresent(_ py: Py, type: PyType) {
    // If any base class has '__setattr__' then we don't have to re-add it.
    if Self.isInMroExcludingObject(py, type: type, name: .__setattr__) {
      return
    }

    let setattr = PyBuiltinFunction.wrap(
      name: "__setattr__",
      doc: nil,
      fn: AttributeHelper.setAttribute(_:object:name:value:)
    )

    let dict = type.__dict__
    dict.set(id: .__setattr__, to: setattr.asObject)
  }

  // MARK: - __classcell__

  private static func fill__classcell__(_ py: Py,
                                        type: PyType) -> PyTypeError? {
    let dict = type.__dict__

    guard let __classcell__ = dict.get(id: .__classcell__) else {
      return nil
    }

    guard let cell = py.cast.asCell(__classcell__) else {
      let t = __classcell__.typeName
      let message = "__classcell__ must be a nonlocal cell, not \(t)"
      return py.newTypeError(message: message)
    }

    cell.content = type.asObject
    _ = dict.del(id: .__classcell__)
    return nil
  }

  // MARK: - Call __set_name__

  /// static int
  /// set_names(PyTypeObject *type)
  private static func call__set_name__OnDictEntries(
    _ py: Py,
    type: PyType
  ) -> PyBaseException? {
    let dict = type.__dict__

    for entry in dict.elements {
      let key = entry.key.object
      let value = entry.value

      // Do we even have such thingie?
      guard let lookup = value.type.mroLookup(name: .__set_name__) else {
        continue
      }

      let callable = lookup.object
      let args = [type.asObject, key]
      let callResult = py.call(callable: callable, args: args, kwargs: nil)

      switch callResult {
      case .value:
        break
      case .notCallable(let e),
           .error(let e):
        return e
      }
    }

    return nil
  }

  // MARK: - Call __init_subclass__

  /// static int
  /// init_subclass(PyTypeObject *type, PyObject *kwds)
  private static func call__init_subclass__OnParent(
    _ py: Py,
    type: PyType,
    kwargs: PyDict?
  ) -> PyBaseException? {
    let superType = py.types.super.asObject

    let superInstance: PyObject
    switch py.call(callable: superType, args: [type.asObject, type.asObject], kwargs: nil) {
    case let .value(s):
      superInstance = s
    case let .notCallable(e),
         let .error(e):
      return e
    }

    let __init_subclass__: PyObject
    switch py.getAttribute(object: superInstance, name: .__init_subclass__) {
    case let .value(i):
      __init_subclass__ = i
    case let .error(e):
      if py.cast.isAttributeError(e.asObject) {
        return nil
      }

      return e
    }

    switch py.call(callable: __init_subclass__, args: [], kwargs: kwargs) {
    case .value:
      return nil
    case .notCallable(let e),
         .error(let e):
       return e
    }
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static  func __init__(_ py: Py,
                                 zelf: PyObject,
                                 args: [PyObject],
                                 kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    if let kwargs = kwargs {
      let hasSingleArg = args.count == 1
      let hasKwargs = kwargs.elements.any

      if hasSingleArg && hasKwargs {
        let message = "type.__init__() takes no keyword arguments"
        return .typeError(py, message: message)
      }
    }

    guard args.count == 1 || args.count == 3 else {
      let message = "type.__init__() takes 1 or 3 arguments"
      return .typeError(py, message: message)
    }

    // Call object.__init__(self) now.
    return PyObject.__init__(py, zelf: zelf.asObject, args: [], kwargs: nil)
  }
}
