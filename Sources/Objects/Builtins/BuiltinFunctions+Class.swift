import Core

extension BuiltinFunctions {

  internal static var buildClassDoc: String {
    return """
    __build_class__(func, name, *bases, metaclass=None, **kwds) -> class

    Internal helper function used by the class statement.
    """
  }

  // sourcery: pymethod = __build_class__, doc = buildClassDoc
  public func buildClass(args: [PyObject],
                         kwargs: PyDict?) -> PyResult<PyObject> {
    if args.count < 2 {
      return .typeError("__build_class__: not enough arguments")
    }

    guard let fn = args[0] as? PyFunction else {
      return .typeError("__build_class__: func must be a function")
    }

    guard let name = args[1] as? PyString else {
      return .typeError("__build_class__: name is not a string")
    }

    let bases = Py.newTuple(Array(args[2...]))

    let metatype: PyObject
    switch self.calculateMetaclass(bases: bases, kwargs: kwargs) {
    case let .value(m): metatype = m
    case let .error(e): return .error(e)
    }

    let namespace: PyDict
    switch self.createNamespace(name: name, bases: bases, metatype: metatype) {
    case let .value(n): namespace = n
    case let .error(e): return .error(e)
    }

    let cell: PyObject
    switch self.createCell(fn: fn, namespace: namespace) {
    case let .value(c): cell = c
    case let .error(e): return .error(e)
    }

    let margs = [name, bases, namespace]
    let cls = Py.call(callable: metatype, args: margs, kwargs: kwargs).asResult
    // if (cls != NULL && PyType_Check(cls) && PyCell_Check(cell)) {

    fatalError()
  }

  private func createCell(fn: PyFunction,
                          namespace: PyDict) -> PyResult<PyObject> {
    // TODO: locals: namespace
    // TODO: closure PyFunction_GET_CLOSURE(func)
    let code = fn.code.codeObject
    let locals = Py.newDict()

    return Py.delegate.eval(
      name: nil,
      qualname: nil,
      code: code,
      args: [],
      kwargs: nil,
      defaults: [],
      kwDefaults: nil,
      globals: fn.globals,
      locals: locals
    )
  }
}

// MARK: - Metaclass

extension BuiltinFunctions {

  private func calculateMetaclass(bases: PyTuple,
                                  kwargs: PyDict?) -> PyResult<PyObject> {
    var result: PyObject

    switch self.getMetaclassRaw(kwargs: kwargs) {
    case .value(let m):
      // TODO: if (_PyDict_DelItemId(mkw, &PyId_metaclass) < 0)
      result = m
    case .notFound:
      result = bases.elements.first?.type ?? Py.types.type
    case .error(let e):
      return .error(e)
    }

    // meta is really a class, so check for a more derived
    // metaclass, or possible metaclass conflicts:
    if let metaType = result as? PyType {
      switch PyType.calculateMetaclass(metatype: metaType, bases: bases.elements) {
      case let .value(winner):
        result = winner
      case let .error(e):
        return .error(e)
      }
    }
    // else: meta is not a class, so we cannot do the metaclass
    // calculation, so we will use the explicitly given object as it is

    return .value(result)
  }

  private var metaclassKey: PyDictKey {
    let id = IdString.metaclass
    return PyDictKey(hash: id.hash, object: id.value)
  }

  private func getMetaclassRaw(kwargs: PyDict?) -> PyDict.GetResult {
    guard let kwargs = kwargs else {
      return .notFound
    }

    let key = self.metaclassKey
    return kwargs.get(key: key)
  }
}

// MARK: - Namespace

private enum PrepareCallResult {
  case value(PyObject)
  case none
  case error(PyBaseException)
}

extension BuiltinFunctions {

  private func createNamespace(name: PyString,
                               bases: PyTuple,
                               metatype: PyObject) -> PyResult<PyDict> {
    switch self.get__prepare__(metatype: metatype) {
    case .value(let prepare):
      let object: PyObject
      switch Py.call(callable: prepare, args: [name, bases], kwargs: nil) {
      case let .value(o):
        object = o
      case let .error(e),
           let .notCallable(e):
        return .error(e)
      }

      guard let dict = object as? PyDict else {
        let t = metatype.typeName
        let msg = "\(t).__prepare__() must return a mapping, not \(object.typeName)"
        return .typeError(msg)
      }

      return .value(dict)

    case .none:
      return .value(Py.newDict())

    case .error(let e):
      return .error(e)
    }
  }

  private func get__prepare__(metatype: PyObject) -> PrepareCallResult {
    switch Py.getAttribute(metatype, name: "__prepare__") {
    case let .value(o):
      return .value(o)

    case let .error(e):
      if e.isAttributeError {
        return .none
      }

      return .error(e)
    }
  }
}
