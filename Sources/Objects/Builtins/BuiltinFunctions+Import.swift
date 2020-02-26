// swiftlint:disable file_length

private let importArguments = ArgumentParser.createOrTrap(
  arguments: ["name", "globals", "locals", "fromlist", "level"],
  format: "U|OOOi:__import__"
)

extension BuiltinFunctions {

  internal static var importDoc: String {
    return """
    __import__(name, globals=None, locals=None, fromlist=(), level=0) -> module

    Import a module. Because this function is meant for use by the Python
    interpreter and not for general use, it is better to use
    importlib.import_module() to programmatically import a module.

    The globals argument is only used to determine the context;
    they are not modified.  The locals argument is unused.  The fromlist
    should be a list of names to emulate ``from name import ...'', or an
    empty list to emulate ``import name''.
    When importing a module from a package, note that __import__('A.B', ...)
    returns package A when fromlist is empty, but its submodule B when
    fromlist is not empty.  The level argument is used to determine whether to
    perform absolute or relative imports: 0 is absolute, while a positive number
    is the number of parent directories to search relative to the current module.
    """
  }

  // sourcery: pymethod = __import__, doc = importDoc
  /// __import__(name, globals=None, locals=None, fromlist=(), level=0)
  /// See [this](https://docs.python.org/3/library/functions.html#__import__)
  public func __import__(args: [PyObject],
                         kwargs: PyDict?) -> PyResult<PyObject> {
    fatalError()
//    switch importArguments.bind(args: args, kwargs: kwargs) {
//    case let .value(binding):
//      assert(binding.requiredCount == 1, "Invalid required argument count.")
//      assert(binding.optionalCount == 4, "Invalid optional argument count.")
//
//      let name = binding.required(at: 0)
//      let globals = binding.optional(at: 1)
//      let locals = binding.optional(at: 2)
//      let fromlist = binding.optional(at: 3)
//      let level = binding.optional(at: 3)
//
//      return self.__import__(name: name,
//                             globals: globals,
//                             locals: locals,
//                             fromlist: fromlist,
//                             level: level)
//
//    case let .error(e):
//      return .error(e)
//    }
  }
/*
  /// PyImport_ImportModuleLevelObject(PyObject *name, PyObject *globals,
  ///                                  PyObject *locals, PyObject *fromlist,
  ///                                  int level)
  public func __import__(name nameRaw: PyObject,
                         globals globalsRaw: PyObject? = nil,
                         locals localsRaw: PyObject? = nil,
                         fromlist fromlistRaw: PyObject? = nil,
                         level levelRaw: PyObject? = nil) -> PyResult<PyObject> {
    guard let name = nameRaw as? PyString else {
      return .typeError("module name must be a string")
    }

    let level: PyInt
    switch self.parseLevel(from: levelRaw) {
    case let .value(l): level = l
    case let .error(e): return .error(e)
    }

    assert(level.value >= 0)

    let absName: PyString
    if level.value == 0 {
      if name.value.isEmpty {
        return .valueError("Empty module name")
      }
      absName = Py.getInterned(name.value)
    } else {
      switch self.resolveName(name: name, globals: globalsRaw, level: level) {
      case let .value(s): absName = Py.getInterned(s)
      case let .error(e): return .error(e)
      }
    }

    let module: PyObject
    switch self.getModule(name: absName) {
    case .module(let m):
      module = m
    case .notFound:

      break
    case .error(let e):
      return .error(e)
    }

    fatalError()
  }

  // MARK: - Parse level

  private func parseLevel(from object: PyObject?) -> PyResult<PyInt> {
    guard let object = object else {
      return .value(Py.newInt(0))
    }

    guard let int = object as? PyInt else {
      return .typeError("module level must be a int")
    }

    guard int.value >= 0 else {
      return .valueError("level must be >= 0")
    }

    return .value(int)
  }

  // MARK: - Resolve name

  /// static PyObject *
  /// resolve_name(PyObject *name, PyObject *globals, int level)
  private func resolveName(name: PyString,
                           globals globalsRaw: PyObject?,
                           level: PyInt) -> PyResult<String> {
    guard let globalsRaw = globalsRaw else {
      return .keyError("'__name__' not in globals")
    }

    guard let globals = globalsRaw as? PyDict else {
      return .typeError("globals must be a dict")
    }

    let package: String
    switch self.getPackageName(globals: globals) {
    case let .value(s): package = s
    case let .error(e): return .error(e)
    }

    if package.isEmpty {
      return .importError("attempted relative import with no known parent package")
    }

    let scalars = package.unicodeScalars
    var baseScalars = scalars[..<scalars.endIndex]

    for _ in 1..<level.value {
      guard let index = baseScalars.lastIndex(of: ".") else {
        return .valueError("attempted relative import beyond top-level package")
      }

      baseScalars = scalars[..<index]
    }

    let base = String(baseScalars)
    if base.isEmpty || name.value.isEmpty {
      return .value(base)
    }

    return .value("\(base).\(name.value)")
  }

  private func getPackageName(globals: PyDict) -> PyResult<String> {
    let package: PyObject?
    switch self.get__package__(from: globals) {
    case let .value(o): package = o
    case let .error(e): return .error(e)
    }

    let spec: PyObject?
    switch self.get__spec__(from: globals) {
    case let .value(o): spec = o
    case let .error(e): return .error(e)
    }

    if let package = package {
      guard let string = package as? PyString else {
        return .typeError("package must be a string")
      }

      if let e = self.guaranteeSpecParentIsEqualToPackage(spec: spec,
                                                          package: string) {
        return .error(e)
      }

      return .value(string.value)
    }

    if let spec = spec, !spec.isNone {
      return self.getParent(spec: spec).map { $0.value }
    }

    let msg = "can't resolve package from __spec__ or __package__, " +
              "falling back on __name__ and __path__"
    if let e = Py.warn(type: .import, msg: msg) {
      return .error(e)
    }

    let name: PyString
    switch self.get__name__(from: globals) {
    case let .value(n): name = n
    case let .error(e): return .error(e)
    }

    let path: PyObject?
    switch self.get__path__(from: globals) {
    case let .value(p): path = p
    case let .error(e): return .error(e)
    }

    if path == nil {
      let nameScalars = name.value.unicodeScalars
      if let dot = nameScalars.lastIndex(of: ".") {
        let substring = nameScalars[..<dot]
        return .value(String(substring))
      }
    }

    return .value(name.value)
  }

  private func get__package__(from globals: PyDict) -> PyResult<PyObject?> {
    switch globals.getItem(id: .__package__) {
    case let .value(o):
      let isNone = o?.isNone ?? true
      return .value(isNone ? nil : o)
    case let .error(e):
      return .error(e)
    }
  }

  private func get__name__(from globals: PyDict) -> PyResult<PyString> {
    switch globals.getItem(id: .__name__) {
    case let .value(o):
      guard let object = o else {
        return .keyError("'__name__' not in globals")
      }

      guard let str = object as? PyString else {
        return .typeError("__name__ must be a string")
      }

      return .value(str)
    case let .error(e):
      return .error(e)
    }
  }

  private func get__spec__(from globals: PyDict) -> PyResult<PyObject?> {
    return globals.getItem(id: .__spec__)
  }

  private func get__path__(from globals: PyDict) -> PyResult<PyObject?> {
    return globals.getItem(id: .__path__)
  }

  private func guaranteeSpecParentIsEqualToPackage(
    spec: PyObject?,
    package: PyString
  ) -> PyBaseException? {
    // We allow no spec or None spec
    guard let spec = spec, !spec.isNone else {
      return nil
    }

    let parent: PyString
    switch self.getParent(spec: spec) {
    case let .value(o): parent = o
    case let .error(e): return e
    }

    let parentData = parent.data
    let packageData = package.data

    switch parentData.compare(to: packageData) {
    case .equal:
      return nil
    case .less,
         .greater:
      if let w = Py.warn(type: .import, msg: "__package__ != __spec__.parent") {
        return w
      }

      return nil
    }
  }

  private func getParent(spec: PyObject) -> PyResult<PyString> {
    switch Py.getAttribute(spec, name: "parent") {
    case let .value(object):
      guard let string = object as? PyString else {
        return .typeError("__spec__.parent must be a string")
      }

      return .value(string)
    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - Get module

private enum GetModuleResult {
  case module(PyObject)
  case notFound
  case error(PyBaseException)
}

extension BuiltinFunctions {

  /// PyObject *
  /// PyImport_GetModule(PyObject *name)
  private func getModule(name: PyString) -> GetModuleResult {
    let modules = self.getModulesDict()

    switch modules.getItem(at: name) {
    case let .value(m):
      return .module(m)
    case let .error(e):
      if e is PyKeyError {
        return .notFound
      }

      return .error(e)
    }
  }

  // TODO: Implement this (as property - 'sys.modules')
  /// PyObject *
  /// PyImport_GetModuleDict(void)
  private func getModulesDict() -> PyDict {
    fatalError()
  }
 */
}
