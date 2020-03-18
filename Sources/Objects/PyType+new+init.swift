import Core

private struct PyTypeNewArgs {
  /// First argument in `__new__` invocation
  fileprivate let metatype: PyType
  /// Args passed to orginal function
  fileprivate let args: [PyObject]
  /// Kwargs passed to orginal function
  fileprivate let kwargs: PyDict?

  /// Name string is the class name and becomes the `__name__` attribute
  /// `self.args[0] as String`
  fileprivate let name: String
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
      switch PyType.guaranteeBaseTypes(bases.elements) {
      case let .value(r): baseTypes = r
      case let .error(e): return .error(e)
      }

      return PyType.pyNew(args: PyTypeNewArgs(metatype: type,
                                              args: args,
                                              kwargs: kwargs,
                                              name: name.value,
                                              bases: baseTypes,
                                              dict: dict))
    case let .error(e):
      return .error(e)
    }
  }

  private static func guaranteeBaseTypes(_ objects: [PyObject]) -> PyResult<[PyType]> {
    var result = [PyType]()
    for object in objects {
      guard let base = object as? PyType else {
        return .typeError("bases must be types")
      }

      guard base.isBaseType else {
        return .typeError("type '\(base.getName())' is not an acceptable base type")
      }

      result.append(base)
    }

    return .value(result)
  }

  // swiftlint:disable:next function_body_length
  private static func pyNew(args: PyTypeNewArgs) -> PyResult<PyObject> {
    let base: PyType
    var bases = args.bases
    var metatype = args.metatype

    if bases.isEmpty {
      base = Py.types.object
      bases = [base]
    } else {
      // Search the bases for the proper metatype to deal with this
      switch PyType.calculateMetaclass(metatype: args.metatype, bases: args.bases) {
      case let .value(t): metatype = t
      case let .error(e): return .error(e)
      }

      // Calculate best base using bases memory layout (layout confilct -> error)
      switch PyType.bestBase(bases: args.bases) {
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
    let type = PyType(name: args.name,
                      qualname: args.name, // May be overriden below
                      type: metatype,
                      base: base,
                      mro: mro)

    type.setFlag([.default, .heapType, .baseType, .hasFinalize])
    if base.typeFlags.contains(.hasGC) {
      type.setFlag(.hasGC)
    }

    // Initialize '__dict__' from passed-in dict
    let dict = Py.newDict(data: args.dict.data)
    type.setDict(value: dict)

    // Set __module__ in the dict

    if dict.get(id: .__module__) == nil {
      switch self.setModuleFromCurrentFrameGlobals(type: type) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    // Set qualname to dict['__qualname__'] if available.
    if let qualname = dict.get(id: .__qualname__) {
      switch type.setQualname(qualname) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    // TODO: Special-case __new__: if it's a plain function, make it a static function
    // TODO: if (init_subclass(type, kwds) < 0)

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
      if let layout = candidate.layout {
        return SolidBase(type: type, layout: layout)
      }

      typeOrNil = candidate.getBase()
    }

    // 'Object' type (the one at the top of the lattice) has defined layout.
    // It should be used if anything else fails.
    let name = type.getName()
    trap("'\(name)' type does not derieve from 'object'.")
  }

  // MARK: - Module

  private static func setModuleFromCurrentFrameGlobals(
    type: PyType
  ) -> PyResult<()> {
    switch Py.getGlobals() {
    case let .value(globals):
      if let module = globals.get(id: .__name__) {
        return type.setModule(module)
      }

      return .value()

    case let .error(e):
      return .error(e)
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
    return PyBaseObject.pyInit(zelf: zelf, args: [], kwargs: nil)
  }
}
