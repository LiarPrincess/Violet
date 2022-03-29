// cSpell:ignore initimport sysmod

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension Py {

  // MARK: - Get __import__

  /// In CPython: interp->import_func
  ///
  /// This value is set in:
  /// 'initimport(PyInterpreterState *interp, PyObject *sysmod)'
  public func get__import__() -> PyResult {
    let dict = self.builtins.__dict__

    if let fn = dict.get(self, id: .__import__) {
      return .value(fn)
    }

    let message = "'__import__' function not found inside builtins module"
    let error = self.newAttributeError(message: message)
    return .error(error.asBaseException)
  }

  // MARK: - __import__

  /// __import__(name, globals=None, locals=None, fromlist=(), level=0)
  /// See [this](https://docs.python.org/3/library/functions.html#__import__)
  ///
  /// PyImport_ImportModuleLevelObject(PyObject *name, PyObject *globals,
  ///                                  PyObject *locals, PyObject *fromlist,
  ///                                  int level)
  public func __import__(name nameArg: PyObject,
                         globals: PyObject? = nil,
                         locals: PyObject? = nil,
                         fromList: PyObject? = nil,
                         level levelArg: PyObject? = nil) -> PyResult {
    guard let name = self.cast.asString(nameArg) else {
      return .typeError(self, message: "module name must be a string")
    }

    let level: PyInt
    switch self.parseLevel(from: levelArg) {
    case let .value(l): level = l
    case let .error(e): return .error(e)
    }

    assert(level.value >= 0)

    // 'level' specifies whether to use absolute or relative imports.
    // - 0 (default) - absolute import - module or package from 'sys.path'
    // - positive value - relative import - number of parent directories to search
    //   relative to the directory of the module calling __import__()
    // (see PEP 328 for the details).
    //
    // Example:
    // name = frozen.elsa
    // level = 1
    //
    // importing from = disnep.tangled.rapunzel <-- owner of 'globals'
    // globals.package = disnep.tangled
    // globals.package adjusted by level (which is 1) = disnep
    //
    // absName = (globals.package adjusted by level) + name = disnep.frozen.elsa

    let absName: PyString
    switch self.resolveLevel(name: name, level: level, globals: globals) {
    case let .value(s): absName = self.intern(string: s)
    case let .error(e): return .error(e)
    }

    let module: PyObject
    switch self.getExistingOrLoadModule(absName: absName) {
    case let .value(m): module = m
    case let .error(e): return .error(e)
    }

    return self.handleFromList(name: name,
                               absName: absName,
                               level: level,
                               module: module,
                               fromList: fromList)
  }

  // MARK: - Parse level

  private func parseLevel(from object: PyObject?) -> PyResultGen<PyInt> {
    guard let object = object else {
      return .value(self.newInt(0))
    }

    guard let int = self.cast.asInt(object) else {
      return .typeError(self, message: "module level must be a int")
    }

    guard int.value >= 0 else {
      return .valueError(self, message: "level must be >= 0")
    }

    return .value(int)
  }

  // MARK: - Handle level

  /// Get `name` after resolving `level`.
  /// `globals` will be used for package name (but only if we have `level`).
  ///
  /// Mostly based on:
  /// static PyObject *
  /// resolve_name(PyObject *name, PyObject *globals, int level)
  private func resolveLevel(name: PyString,
                            level: PyInt,
                            globals: PyObject?) -> PyResultGen<String> {
    if level.value == 0 {
      if name.isEmpty {
        return .valueError(self, message: "Empty module name")
      }

      return .value(name.value)
    }

    // Oh no… we have 'level'
    // We need to find package and then 'go up' a few 'levels'

    let package: String // In example: package = 'disnep.tangled'
    switch self.getPackage(globals: globals) {
    case let .value(s): package = s
    case let .error(e): return .error(e)
    }

    if package.isEmpty {
      return .importError(self, message: "attempted relative import with no known parent package")
    }

    var base = package[package.startIndex...]

    // Go up a few levels. In example: base = disnep
    for _ in 1..<level.value {
      guard let index = base.lastIndex(of: ".") else {
        return .valueError(self, message: "attempted relative import beyond top-level package")
      }

      base = base[..<index]
    }

    let result = base.isEmpty || name.isEmpty ?
      "\(base)" :
      "\(base).\(name.value)" // In example: 'disnep' + '.' + 'frozen.elsa'

    return .value(result)
  }

  private func getPackage(globals globalsArg: PyObject?) -> PyResultGen<String> {
    // 'globals' represent 'module.__dict__'
    guard let globalsObject = globalsArg else {
      return .keyError(self, message: "'__name__' not in globals")
    }

    guard let globals = self.cast.asDict(globalsObject) else {
      return .typeError(self, message: "globals must be a dict")
    }

    // Try to get 'globals.__package__':
    if let package = globals.get(self, id: .__package__), !self.cast.isNone(package) {
      guard let result = self.cast.asString(package) else {
        return .typeError(self, message: "package must be a string")
      }

      // We should compare if string == __spec__.parent, but we are lazy
      return .value(result.value)
    }

    // Try to get 'globals.__spec__.parent':
    if let spec = globals.get(self, id: .__spec__), !self.cast.isNone(spec) {
      return self.getParent(spec: spec).map { $0.value }
    }

    // Last resort '__name__' and '__path__':
    let message = "can't resolve package from __spec__ or __package__, " +
      "falling back on __name__ and __path__"
    if let e = self.warn(type: .import, message: message) {
      return .error(e)
    }

    let name: PyString
    switch self.get__name__(globals: globals) {
    case let .value(n): name = n
    case let .error(e): return .error(e)
    }

    // If we don't have '__path__' then we will just slice last component:
    let path = globals.get(self, id: .__path__)

    if path == nil {
      if let dot = name.value.lastIndex(of: ".") {
        let substring = name.value[..<dot]
        return .value(String(substring))
      }
    }

    return .value(name.value)
  }

  private func getParent(spec: PyObject) -> PyResultGen<PyString> {
    switch self.getAttribute(object: spec, name: "parent") {
    case let .value(object):
      guard let string = self.cast.asString(object) else {
        return .typeError(self, message: "__spec__.parent must be a string")
      }

      return .value(string)
    case let .error(e):
      return .error(e)
    }
  }

  private func get__name__(globals: PyDict) -> PyResultGen<PyString> {
    guard let object = globals.get(self, id: .__name__) else {
      return .keyError(self, message: "'__name__' not in globals")
    }

    guard let str = self.cast.asString(object) else {
      return .typeError(self, message: "__name__ must be a string")
    }

    return .value(str)
  }

  // MARK: - Get/load module

  /// PyObject *
  /// PyImport_GetModule(PyObject *name)
  private func getExistingOrLoadModule(absName: PyString) -> PyResult {
    switch self.sys.getModule(name: absName) {
    case let .module(m):
      return .value(m.asObject)
    case .notModule,
         .notFound:
      return self.call_find_and_load(absName: absName)
    case let .error(e):
      assert(!self.cast.isKeyError(e.asObject), "KeyError means not found")
      return .error(e)
    }
  }

  /// static PyObject *
  /// import_find_and_load(PyObject *abs_name)
  private func call_find_and_load(absName: PyString) -> PyResult {
    let __import__: PyObject
    switch self.get__import__() {
    case let .value(i): __import__ = i
    case let .error(e): return .error(e)
    }

    let args = [absName.asObject, __import__]
    let callResult = self.callImportlibMethod(selector: ._find_and_load, args: args)
    return callResult.asResult
  }

  private func callImportlibMethod(selector: IdString, args: [PyObject]) -> CallResult {
    let importlib: PyModule
    switch self.getImportlib() {
    case let .value(m): importlib = m
    case let .error(e): return .error(e)
    }

    // We need to 'allowsCallableFromDict' because we don't want to call
    // PyModule method, but our own 'def'.

    let importlibObject = importlib.asObject
    let selectorString = self.resolve(id: selector)
    switch self.getMethod(object: importlibObject,
                          selector: selectorString,
                          allowsCallableFromDict: true) {
    case let .value(method):
      return self.call(callable: method, args: args, kwargs: nil)
    case let .notFound(e),
         let .error(e):
      return .error(e)
    }
  }

  // MARK: - Handle 'from'

  private func handleFromList(name: PyString,
                              absName: PyString,
                              level: PyInt,
                              module: PyObject,
                              fromList: PyObject?) -> PyResult {
    // If we have 'fromList' then call '_handle_fromlist' from 'importlib'
    if let fl = fromList, !self.cast.isNone(fl) {
      switch self.isTrueBool(object: fl) {
      case .value(true):
        return self.call_handle_fromlist(module: module, fromList: fl)
      case .value(false):
        break // We do not have 'fromList'
      case .error(let e):
        return .error(e)
      }
    }

    // No dot in module name, simple exit.
    // It will also handle case of empty name.
    let nameScalars = name.elements
    guard let nameDotIndex = nameScalars.firstIndex(of: ".") else {
      return .value(module)
    }

    // Absolute import, this is easy, we don't have to do anything special
    // to extract 'toplevel' name.
    if level.value == 0 {
      let front = String(nameScalars[..<nameDotIndex])
      let frontObject = self.newString(front)
      let level = self.newInt(0)
      return self.__import__(name: frontObject.asObject,
                             globals: nil,
                             locals: nil,
                             fromList: nil,
                             level: level.asObject)
    }

    // Extract toplevel module (the one that is bound by the import statement)
    // name = frozen.elsa
    // absName = disnep.frozen.elsa
    // absTopLevel = disnep.frozen
    let absTopLevel = self.getTopLevelModuleAbsName(name: name.value,
                                                    nameDotIndex: nameDotIndex,
                                                    absName: absName.value)

    let interned = self.intern(string: absTopLevel)
    switch self.sys.getModule(name: interned) {
    case .module(let m):
      return .value(m.asObject)
    case .notModule(let o):
      // This is an interesting case,
      // but we will trust that import knows its stuff.
      return .value(o)
    case .notFound:
      return .keyError(self, message: "\(absTopLevel) not in sys.modules as expected")
    case .error(let e):
      return .error(e)
    }
  }

  /// And yes, `_handle_fromlist` is the `Python` selector.
  /// We have not changed our naming convention.
  private func call_handle_fromlist(module: PyObject, fromList: PyObject) -> PyResult {
    let __import__: PyObject
    switch self.get__import__() {
    case let .value(i): __import__ = i
    case let .error(e): return .error(e)
    }

    let args = [module, fromList, __import__]
    let callResult = self.callImportlibMethod(selector: ._handle_fromlist, args: args)
    return callResult.asResult
  }

  private func getTopLevelModuleAbsName(name: String,
                                        nameDotIndex: String.Index,
                                        absName: String) -> String {
    // Example:
    // name = frozen.elsa
    // level = 1
    //
    // importingFrom = disnep.tangled.rapunzel
    // importingFrom package = disnep.tangled
    // importingFrom package including level = disnep
    //
    // absName = (importingFrom package withLevel) + name = disnep.frozen.elsa

    // --- code --

    // Extract toplevel module (the one that is bound by the import statement)
    // frozen.elsa
    //       ^ cutOff - we take only 'frozen'
    let cutOff = name.distance(from: nameDotIndex, to: name.endIndex)

    // Now we take 'absName' and cut off the 'cutOff'
    // disnep.frozen.elsa
    //              ^ absWithoutCutOffIndex - we take 'disnep.frozen'
    let topLevelAbsEnd = absName.index(absName.endIndex, offsetBy: -cutOff)

    // result = disnep.frozen
    let topLevelAbs = absName[..<topLevelAbsEnd]
    return String(topLevelAbs)
  }
}
