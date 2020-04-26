import Core

// swiftlint:disable file_length

private struct PyTypeNewArgs {
  /// First argument in `__new__` invocation
  fileprivate let metatype: PyType
  /// Args passed to orginal function
  fileprivate let args: [PyObject]
  /// Kwargs passed to orginal function
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

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["name", "bases", "dict"],
    format: "OOO:type.__new__"
  )

// swiftlint:disable function_body_length

  // sourcery: pymethod = __new__
  /// static PyObject *
  /// type_new(PyTypeObject *metatype, PyObject *args, PyObject *kwds)
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    // swiftlint:enable function_body_length

    // Special case: type(x) should return x->ob_type
    if type === Py.types.type {
      let noKwargs = kwargs?.data.isEmpty ?? true
      if args.count == 1 && noKwargs {
        return .value(args[0].type)
      }

      if args.count != 3 {
        return .typeError("type() takes 1 or 3 arguments")
      }
    }

    // class type(name, bases, dict)
    switch newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 3, "Invalid required argument count.")
      assert(binding.optionalCount == 0, "Invalid optional argument count.")

      let fn = "type.__new__()"

      let arg0 = binding.required(at: 0)
      guard let name = arg0 as? PyString else {
        return .typeError("\(fn) argument 1 must be str, not \(arg0.typeName)")
      }

      let arg1 = binding.required(at: 1)
      guard let bases = arg1 as? PyTuple else {
        return .typeError("\(fn) argument 2 must be tuple, not \(arg1.typeName)")
      }

      let arg2 = binding.required(at: 2)
      guard let dict = arg2 as? PyDict else {
        return .typeError("\(fn) argument 3 must be dict, not \(arg2.typeName)")
      }

      var baseTypes = [PyType]()
      switch PyType.guaranteeAllBasesAreTypes(bases: bases) {
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

      return PyType.pyNew(args: args)

    case let .error(e):
      return .error(e)
    }
  }

  private static func guaranteeAllBasesAreTypes(
    bases: PyTuple
  ) -> PyResult<[PyType]> {
    var result = [PyType]()
    for object in bases.elements {
      guard let base = object as? PyType else {
        return .typeError("bases must be types")
      }

      guard base.isBaseType else {
        let baseName = base.getNameRaw()
        return .typeError("type '\(baseName)' is not an acceptable base type")
      }

      result.append(base)
    }

    return .value(result)
  }

  // swiftlint:disable function_body_length

  /// static PyObject *
  /// type_new(PyTypeObject *metatype, PyObject *args, PyObject *kwds)
  private static func pyNew(args: PyTypeNewArgs) -> PyResult<PyObject> {
    // swiftlint:enable function_body_length

    let base: PyType
    var bases = args.bases
    var metatype = args.metatype

    if bases.isEmpty {
      base = Py.types.object
      bases = [base]
    } else {
      // Search the bases for the proper metatype to deal with this
      switch PyType.calculateMetaclass(metatype: metatype, bases: bases) {
      case let .value(t): metatype = t
      case let .error(e): return .error(e)
      }

      // Calculate best base using bases memory layout (layout confilct -> error)
      switch PyType.bestBase(bases: bases) {
      case let .value(r): base = r
      case let .error(e): return .error(e)
      }
    }

    // Assumming we don't have slots
    let mro: MRO
    switch MRO.linearize(baseClasses: bases) {
    case let .value(r): mro = r
    case let .typeError(msg): return .typeError(msg)
    case let .valueError(msg): return .valueError(msg)
    }

    // Create type object
    let type = PyType(
      name: args.name.value,
      qualname: args.name.value, // May be overriden later (if we have it in dict)
      type: metatype,
      base: base,
      mro: mro
    )

    // Flags have to be set ASAP!
    // Setter methods will check 'heapType' (because it should not be possible
    // to modify builtin types, but it is 'ok' for heap types).
    type.setFlag([.default, .heapType, .baseType, .hasFinalize])
    if base.hasGC {
      type.setFlag(.hasGC)
    }

    // Initialize '__dict__' from passed-in dict
    // Also: we have to COPY the kwargs! Swift COW will take care of this.
    let dict = Py.newDict(data: args.dict.data)
    type.setDict(value: dict)

    // =========================================================================
    // === We filled flags and set __dict__, so the 'core' type is finished. ===
    // === Now we *just* need to fill some additional properties             ===
    // =========================================================================

    // Set __module__ (but remember that we may already have it)
    if let e = Self.setModuleFromCurrentFrameGlobalsIfNotPresent(type: type) {
      return .error(e)
    }

    // Set qualname to dict['__qualname__'] if available.
    // Otherwise it will stay the same as during 'init' (see ctor call above).
    if let e = Self.setQualnameFromDictIfPresent(type: type) {
      return .error(e)
    }

    // In CPython they set '__doc__' now.
    // We don't have to, because we store '__doc__' in dict (and not as property).

    // Special-case __new__: if it's a plain function, make it a static
    Self.convertFunctionToStaticMethodIfNeeded(type: type, name: .__new__)

    // Special-case '__init_subclass__' and '__class_getitem__':
    // if they are plain functions, make them classmethodss
    Self.convertFunctionToClassMethodIfNeeded(type: type, name: .__init_subclass__)
    Self.convertFunctionToClassMethodIfNeeded(type: type, name: .__class_getitem__)

    // Add properties/methods connected to '__dict__'
    Self.add__dict__PropertyIfNotPresent(type: type)
    Self.add__getattribute__MethodIfNotPresent(type: type)
    Self.add__setattr__MethodIfNotPresent(type: type)

    // Store type in class cell if one is supplied
    // class Elsa:
    //   def let_it_go(self):
    //     c = __class__ # <-- this uses '__class__' cell
    if let e = Self.fill__classcell__(type: type) {
      return .error(e)
    }

    // Call '__set_name__' on all descriptors in a newly generated type
    if let e = Self.call__set_name__OnDictEntries(type: type) {
      return .error(e)
    }

    // Call '__init_subclass__' on the parent of a newly generated type
    if let e = Self.call__init_subclass__OnParent(type: type, kwargs: args.kwargs) {
      return .error(e)
    }

    return .value(type)
  }

  // MARK: - Metaclass

  /// Determine the most derived metatype.
  /// PyTypeObject *
  /// _PyType_CalculateMetaclass(PyTypeObject *metatype, PyObject *bases)
  internal static func calculateMetaclass(metatype: PyType,
                                          bases: [PyObject]) -> PyResult<PyType> {
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

      return .typeError("metaclass conflict: the metaclass of a derived class " +
        "must be a (non-strict) subclass of the metaclasses of all its bases")
    }

    return .value(winner)
  }

  // MARK: - Best base

  /// static PyTypeObject *
  /// best_base(PyObject *bases)
  private static func bestBase(bases: [PyType]) -> PyResult<PyType> {
    assert(bases.any)

    var result: SolidBase?

    for b in bases {
      let candidate = PyType.solidBase(type: b)

      guard let currentResult = result else {
        result = candidate
        continue
      }

      if candidate.layout.isAddingNewProperties(to: currentResult.layout) {
        result = candidate
      } else if currentResult.layout.isAddingNewProperties(to: candidate.layout) {
        // nothing
      } else {
        return .typeError("multiple bases have instance lay-out conflict")
      }
    }

    assert(result != nil) // basically the same check as 'bases.any' at top
    return .value(result!.type) // swiftlint:disable:this force_unwrapping
  }

  private struct SolidBase {
    fileprivate let type: PyType
    fileprivate let layout: TypeLayout
  }

  /// static PyTypeObject *
  /// solid_base(PyTypeObject *type)
  private static func solidBase(type: PyType) -> SolidBase {
    // Traverse class hierarchy (from derieved to base) until we reach
    // something with defined layout.
    // For example:
    //   Given:   Bool -> Int -> Object
    //   Returns: Int layout
    //   Reason: 'Bool' and 'Int' have the same layout (single BigInt property),
    //           but 'Int' and 'Object' have different layouts.

    var typeOrNil: PyType? = type

    while let candidate = typeOrNil {
      assert(
        candidate.layout != nil,
        "Unknown memory layout for \(candidate.getNameRaw())." +
        "'PyType.layout' should be set. (Is this type from external module? Ooo!)"
      )

      if let layout = candidate.layout {
        return SolidBase(type: type, layout: layout)
      }

      typeOrNil = candidate.getBase()
    }

    // 'Object' type (the one at the top of the lattice) has defined layout.
    // It should be used if anything else fails.
    let typeName = type.getNameRaw()
    trap("'\(typeName)' type does not derieve from 'object'.")
  }

  // MARK: - __module__

  private static func setModuleFromCurrentFrameGlobalsIfNotPresent(
    type: PyType
  ) -> PyBaseException? {

    let dict = type.getDict()
    let isAlreadyPresent = dict.get(id: .__module__) != nil
    if isAlreadyPresent {
      return nil
    }

    let globals: PyDict
    switch Py.globals() {
    case let .value(g): globals = g
    case let .error(e): return e
    }

    if let module = globals.get(id: .__name__) {
      switch type.setModule(module) {
      case .value: break
      case .error(let e): return e
      }
    }

    return nil
  }

  // MARK: - __qualname__

  private static func setQualnameFromDictIfPresent(
    type: PyType
  ) -> PyBaseException? {
    let dict = type.getDict()

    // Otherwise it will stay the same as during 'init'
    if let qualname = dict.get(id: .__qualname__) {
      switch type.setQualname(qualname) {
      case .value: break
      case .error(let e): return e
      }
    }

    return nil
  }

  // MARK: - Function -> Static/class method

  private static func convertFunctionToStaticMethodIfNeeded(
    type: PyType,
    name: IdString
  ) {
    let dict = type.getDict()

    guard let object = dict.get(id: name) else {
      return
    }

    guard let function = object as? PyFunction else {
      return
    }

    let method = PyStaticMethod(callable: function)
    dict.set(id: name, to: method)
  }

  private static func convertFunctionToClassMethodIfNeeded(
    type: PyType,
    name: IdString
  ) {
    let dict = type.getDict()

    guard let object = dict.get(id: name) else {
      return
    }

    guard let function = object as? PyFunction else {
      return
    }

    let method = PyClassMethod(callable: function)
    dict.set(id: name, to: method)
  }

  // MARK: - __dict__ property

  private static func add__dict__PropertyIfNotPresent(type: PyType) {
    // If any base class has '__dict__' then we don't have to re-add it.
    // To be really honest, I'm not really sure if this check is needed.
    // Even if we have custom '__dict__' getter what else can it return?
    // Anyway, we will not override it.

    if Self.anyBaseClassExceptForObjectHas(type: type, name: .__dict__) {
      return
    }

    let getter = PyBuiltinFunction.wrap(
      name: "__dict__",
      doc: nil,
      fn: Self.getHeapType__dict__
    )

    let property = PyProperty(
      get: getter,
      set: nil,
      del: nil
    )

    let dict = type.getDict()
    dict.set(id: .__dict__, to: property)
  }

  private static func anyBaseClassExceptForObjectHas(
    type: PyType,
    name: IdString
  ) -> Bool {
    func has(base: PyType) -> Bool {
      let isObject = base === Py.types.object
      if isObject {
        return false // 'except for object' <- see this method name
      }

      let value = base.lookup(name: name)
      return value != nil
    }

    let mro = type.getMRORaw()
    return mro.contains(where: has(base:))
  }

  /// This method will be called when we get '__dict__' property
  /// on heap type instance.
  private static func getHeapType__dict__(object: PyObject) -> PyResult<PyDict> {
    assert(object.type.isHeapType)

    if let dict = Py.get__dict__(object: object) {
      return .value(dict)
    }

    // Should not be possible, heap types are all about adding '__dict__'
    let e = Py.newAttributeError(object: object, hasNoAttribute: "__dict__")
    return .error(e)
  }

  // MARK: - __getattribute__ method

  private static func add__getattribute__MethodIfNotPresent(type: PyType) {
    // If any base class has '__getattribute__' then we don't have to re-add it.
    if Self.anyBaseClassExceptForObjectHas(type: type, name: .__getattribute__) {
      return
    }

    let getattribute = PyBuiltinFunction.wrap(
      name: "__getattribute__",
      doc: nil,
      fn: AttributeHelper.getAttribute(from:name:)
    )

    let dict = type.getDict()
    dict.set(id: .__getattribute__, to: getattribute)
  }

  // MARK: - __setattr__ method

  private static func add__setattr__MethodIfNotPresent(type: PyType) {
    // If any base class has '__setattr__' then we don't have to re-add it.
    if Self.anyBaseClassExceptForObjectHas(type: type, name: .__setattr__) {
      return
    }

    let setattr = PyBuiltinFunction.wrap(
      name: "__setattr__",
      doc: nil,
      fn: AttributeHelper.setAttribute(on:name:to:)
    )

    let dict = type.getDict()
    dict.set(id: .__setattr__, to: setattr)
  }

  // MARK: - __classcell__

  private static func fill__classcell__(type: PyType) -> PyBaseException? {
    let dict = type.getDict()

    guard let __classcell__ = dict.get(id: .__classcell__) else {
      return nil
    }

    guard let cell = __classcell__ as? PyCell else {
      let t = __classcell__.typeName
      let msg = "__classcell__ must be a nonlocal cell, not \(t)"
      return Py.newTypeError(msg: msg)
    }

    cell.content = type
    _ = dict.del(id: .__classcell__)
    return nil
  }

  // MARK: - Call __set_name__

  /// static int
  /// set_names(PyTypeObject *type)
  private static func call__set_name__OnDictEntries(
    type: PyType
  ) -> PyBaseException? {
    let dict = type.getDict()

    for entry in dict.data {
      let key = entry.key.object
      let value = entry.value

      // Do we even have such thingie?
      guard let __set_name__ = value.type.lookup(name: .__set_name__) else {
        continue
      }

      let args = [type, key]
      let callResult = Py.call(callable: __set_name__, args: args, kwargs: nil)

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
    type: PyType,
    kwargs: PyDict?
  ) -> PyBaseException? {

    let superInstance: PyObject
    let superType = Py.types.super

    switch Py.call(callable: superType, args: [type, type], kwargs: nil) {
    case let .value(s):
      superInstance = s
    case let .notCallable(e),
         let .error(e):
      return e
    }

    let __init_subclass__: PyObject
    switch Py.getattr(object: superInstance, name: .__init_subclass__) {
    case let .value(i):
      __init_subclass__ = i
    case let .error(e):
      if e.isAttributeError {
        return nil
      }

      return e
    }

    switch Py.call(callable: __init_subclass__, args: [], kwargs: kwargs) {
    case .value:
      return nil
    case .notCallable(let e),
         .error(let e):
       return e
    }
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyType,
                              args: [PyObject],
                              kwargs: PyDict?) -> PyResult<PyNone> {
    if let kwargs = kwargs {
      if args.count == 1 && kwargs.data.any {
        return .typeError("type.__init__() takes no keyword arguments")
      }
    }

    guard args.count == 1 || args.count == 3 else {
      return . typeError("type.__init__() takes 1 or 3 arguments")
    }

    // Call object.__init__(self) now.
    return PyObjectType.pyInit(zelf: zelf, args: [], kwargs: nil)
  }
}
