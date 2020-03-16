// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

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
  public func __import__(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    switch importArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 4, "Invalid optional argument count.")

      let name = binding.required(at: 0)
      let globals = binding.optional(at: 1)
      let locals = binding.optional(at: 2)
      let fromlist = binding.optional(at: 3)
      let level = binding.optional(at: 4)

      return self.__import__(name: name,
                             globals: globals,
                             locals: locals,
                             fromlist: fromlist,
                             level: level)

    case let .error(e):
      return .error(e)
    }
  }

  /// PyImport_ImportModuleLevelObject(PyObject *name, PyObject *globals,
  ///                                  PyObject *locals, PyObject *fromlist,
  ///                                  int level)
  // swiftlint:disable:next function_body_length
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
    switch self.getModule(absName: absName) {
    case let .value(m): module = m
    case let .error(e): return .error(e)
    }

    var hasFrom = false
    if let fromlist = fromlistRaw, !fromlist.isNone {
      switch Py.isTrueBool(fromlist) {
      case let .value(b): hasFrom = b
      case let .error(e): return .error(e)
      }
    }

    var finalMod: PyObject = Py.none
    if !hasFrom { // TODO: Reverse this
      let nameScalars = name.value.unicodeScalars
      if level.value == 0 || nameScalars.any {
        if let dotIndex = nameScalars.firstIndex(of: ".") {
          if level.value == 0 {
            let front = nameScalars[..<dotIndex]
//            self.__import__(name: String(front),
//                            globals: nil,
//                            locals: nil,
//                            fromlist: nil,
//                            level: nil)
            fatalError()
          } else {
//            let cutOff = nameScalars.count - dotIndex
//            let absNameLen = absName.value.unicodeScalars.count
            fatalError()
          }
        } else {
          // No dot in module name, simple exit
          finalMod = module
        }
      } else {
        finalMod = module
      }
    } else {
      // final_mod = _PyObject_CallMethodIdObjArgs(interp->importlib,
      //                                           &PyId__handle_fromlist, mod,
      //                                           fromlist, interp->import_func,
      //                                           NULL);
      fatalError()
    }

    // TODO: if (final_mod == NULL) remove_importlib_frames();
    return .value(finalMod)
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
    let spec = globals.get(id: .__spec__)

    if let package = globals.get(id: .__package__) {
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

    let path = globals.get(id: .__path__)

    if path == nil {
      if let dot = name.value.lastIndex(of: ".") {
        let substring = name.value[..<dot]
        return .value(String(substring))
      }
    }

    return .value(name.value)
  }

  private func get__name__(from globals: PyDict) -> PyResult<PyString> {
    guard let object = globals.get(id: .__name__) else {
      return .keyError("'__name__' not in globals")
    }

    guard let str = object as? PyString else {
      return .typeError("__name__ must be a string")
    }

    return .value(str)
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

  // MARK: - Get module

  /// PyObject *
  /// PyImport_GetModule(PyObject *name)
  private func getModule(absName: PyString) -> PyResult<PyObject> {
    switch Py.sys.modules.get(name: absName) {
    case let .value(m):
      if m.isNone {
        return self.loadModule(absName: absName)
      }

      return .value(m)

    case .notFound:
      return self.loadModule(absName: absName)

    case let .error(e):
      if e is PyKeyError {
        return self.loadModule(absName: absName)
      }

      return .error(e)
    }
  }

  /// mod = import_find_and_load(abs_name);
  private func loadModule(absName: PyString) -> PyResult<PyObject> {
    fatalError()
  }
}
