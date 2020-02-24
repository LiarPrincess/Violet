import Core

// swiftlint:disable file_length

private struct PyTypeNewArgs {
  /// First argument in `__new__` invocation
  fileprivate let metatype: PyType
  /// Args passed to orginal function
  fileprivate let args: [PyObject]
  /// Kwargs passed to orginal function
  fileprivate let kwargs: PyDictData?

  /// Name string is the class name and becomes the `__name__` attribute
  /// `self.args[0] as String`
  fileprivate let name: String
  /// Bases tuple itemizes the base classes and becomes the __bases__ attribute;
  /// `self.args[1] as Tuple`
  fileprivate let bases: [PyType]
  /// Dict is the namespace containing definitions for class body and is copied
  /// to a standard dictionary to become the `__dict__` attribute.
  /// `self.args[2] as Dict`
  fileprivate let dict: PyDictData
}

extension PyType {

  // MARK: - Python new

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["name", "bases", "dict"],
    format: "OOO:type.__new__"
  )

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    // Special case: type(x) should return x->ob_type
    if type === Py.types.type {
      let noKwargs = kwargs?.isEmpty ?? true
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
                                              dict: dict.data))
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
      switch PyType.calculateMetaclass(args: args) {
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

    // Initialize dict from passed-in dict
    let attributes: Attributes
    switch PyType.createAttributes(from: args.dict) {
    case let .value(a): attributes = a
    case let .error(e): return .error(e)
    }

    type.setAttributes(attributes)

    // Set __module__ in the dict
    if !attributes.has(key: "__module__") {
      let globals = Py.getGlobals()
      if let module = globals["__name__"] {
        switch type.setModule(module) {
        case .value: break
        case .error(let e): return .error(e)
        }
      }
    }

    // Set ht_qualname to dict['__qualname__'] if available, else to __name__.
    // The __qualname__ accessor will use for self.qualname.
    if let qualname = attributes.get(key: "__qualname__") {
      switch type.setQualname(qualname) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    // TODO: Special-case __new__: if it's a plain function, make it a static function
    // TODO: if (init_subclass(type, kwds) < 0)

    return .value(type)
  }

  private static func create__dict__(from dict: PyDictData) -> PyResult<PyDict> {
    let result = Py.newDict()

    for entry in dict {
      guard let key = entry.key.object as? PyString else {
        return .typeError("Dictionary key mus be a str.")
      }

      switch result.setItem(at: key, to: entry.value) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Metaclass

  /// Determine the most derived metatype.
  /// PyTypeObject *
  /// _PyType_CalculateMetaclass(PyTypeObject *metatype, PyObject *bases)
  private static func calculateMetaclass(args: PyTypeNewArgs) -> PyResult<PyType> {
    return PyType.calculateMetaclass(metatype: args.metatype,
                                     bases: args.bases)
  }

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

    var base: PyType?
    var winner: PyType?

    for b in bases {
      let candidate = PyType.solidBase(type: b)
      guard let currentWinner = winner  else {
        winner = candidate
        base = b
        continue
      }

      if currentWinner.isSubtype(of: candidate) {
        // nothing
      } else if candidate.isSubtype(of: currentWinner) {
        winner = candidate
        base = b
      } else {
        return .typeError("multiple bases have instance lay-out conflict")
      }
    }

    assert(base != nil) // basically the same check as 'bases.any' at top
    return .value(base!) // swiftlint:disable:this force_unwrapping
  }

  /// static PyTypeObject *
  /// solid_base(PyTypeObject *type)
  private static func solidBase(type: PyType) -> PyType {
    // Traverse class hierarchy (from derieved to base).
    // Stop when base class has different memory layout than 'us'.
    // Return 'us'.
    // For example:
    //   Given:   Bool -> Int -> Object
    //   Returns: Int
    //   Reason: 'Bool' and 'Int' have the same layout (single BigInt property),
    //           but 'Intĺ and 'Object' have different layouts.

    // Special case for BaseObject
    guard let base = type.getBase() else {
      return type
    }

    return PyType.hasExtraProperties(type: type, base: base) ? type : base
  }

  /// static int
  /// extra_ivars(PyTypeObject *type, PyTypeObject *base)
  private static func hasExtraProperties(type: PyType, base: PyType) -> Bool {
    // This is aproximation of the correct behavior.

    let isTypeHeap = type is HeapType
    let isBaseHeap = base is HeapType

    let isBuiltinDerievedFromBuiltin = !isTypeHeap && !isBaseHeap
    if isBuiltinDerievedFromBuiltin {
      // We assume that every builtin subclass adds something new.
      // Not really true (for example: Bool and Int both have only BigInt property),
      // but whatever (you can't subclass Bool anyway).
      return true
    }

    let isUserTypeDerievedFromBuiltin = isTypeHeap && !isBaseHeap
    if isUserTypeDerievedFromBuiltin {
      // All of the user types (heap types) add `__dict__`.
      return true
    }

    let isUserTypeDerievedFromUserType = isTypeHeap && isBaseHeap
    if isUserTypeDerievedFromUserType {
      // No change here (we already have `__dict__`).
      // And we do not allow extensions.
      return false
    }

    // Remaining case: !isTypeHeap && isBaseHeap
    trap("Builtin type derieved from user type.")
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyType,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    // swiftlint:disable:next empty_count
    if let kwargs = kwargs, args.count == 1 && kwargs.count != 0 {
      return .typeError("type.__init__() takes no keyword arguments")
    }

    guard args.count == 1 || args.count == 3 else {
      return . typeError("type.__init__() takes 1 or 3 arguments")
    }

    // Call object.__init__(self) now.
    return PyBaseObject.pyInit(zelf: zelf, args: [], kwargs: nil)
  }
}
