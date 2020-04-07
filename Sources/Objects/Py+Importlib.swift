import Core
import Foundation

/// Importlib module spec, so that we can share code between
/// `importlib` and `importlib_external`.
private struct ModuleSpec {

  fileprivate let name: String
  fileprivate let nameObject: PyString
  fileprivate let filename: String

  fileprivate init(name: String, filename: String) {
    self.name = name
    self.nameObject = Py.intern(name)
    self.filename = filename
  }
}

/// Just like `PyResult`, but it will force `error` to always be `PyImportError`.
private enum ImportlibResult<Wrapped> {
  case value(Wrapped)
  case error(PyImportError)

  fileprivate var asResult: PyResult<Wrapped> {
    switch self {
    case let .value(w):
      return .value(w)
    case let .error(e):
      return .error(e)
    }
  }
}

extension PyInstance {

  // MARK: - Importlib

  /// `importlib` is the module used for importing other modules.
  public func getImportlib() -> PyResult<PyModule> {
    // 'self.initImportlibIfNeeded' is idempotent:
    // - if it was never called it will intitialize it
    // - if we already called it then it will return module from 'sys'
    //
    // Unless you do something like 'sys.modules['importlib'] = "let it go"',
    // in such case we will reinitialize the whole thing.

    return self.initImportlibIfNeeded()
  }

  /// `importlib` is the module used for importing other modules.
  public func initImportlibIfNeeded() -> PyResult<PyModule> {
    let spec = ModuleSpec(
      name: "importlib",
      filename: "importlib.py"
    )

    let args = [self.sysModule, self._impModule]
    let module = self.initImportlibModule(spec: spec, installArgs: args)
    return module.asResult
  }

  // MARK: - Importlib external

  /// `importlib_external` is a part of `importlib` that allows us to import
  /// modules that require external filesystem access.
  /// For example: `import elsa`, where `elsa` is a file on disc.
  ///
  /// It also allows us to do a few other things, but we don't care about those.
  ///
  /// Normally this would be done in `importlib._install_external_importers`,
  /// but we will do it in Swift.
  public func initImportlibExternalIfNeeded(
    importlib: PyModule
  ) -> PyResult<PyModule> {
    let spec = ModuleSpec(
      name: "importlib_external",
      filename: "importlib_external.py"
    )

    let args = [importlib]
    let module = self.initImportlibModule(spec: spec, installArgs: args)
    return module.asResult
  }

  // MARK: - Shared

  private func initImportlibModule(
    spec: ModuleSpec,
    installArgs: [PyObject]
  ) -> ImportlibResult<PyModule> {
    switch self.getModuleFromSys(spec: spec) {
    case .value(let m): return .value(m)
    case .notFound: break // Yep, we have to import it
    case .error(let e): return .error(e)
    }

    let url: URL
    switch self.findModuleOnDisc(spec: spec) {
    case let .value(u): url = u
    case let .error(e): return .error(e)
    }

    let code: PyCode
    switch self.compile(url: url, mode: .fileInput) {
    case let .value(c): code = c
    case let .error(e):
      let msg = "can't compile \(spec.name)"
      return .error(self.newPyImportError(msg: msg, cause: e))
    }

    let module: PyModule
    switch self.createModule(spec: spec, code: code) {
    case let .value(m): module = m
    case let .error(e): return .error(e)
    }

    if let e = self.callInstall(spec: spec, module: module, args: installArgs) {
      return .error(e)
    }

    return .value(module)
  }
}

private enum GetModuleFromSysResult {
  case value(PyModule)
  case notFound
  case error(PyImportError)
}

extension PyInstance {

  private func getModuleFromSys(spec: ModuleSpec) -> GetModuleFromSysResult {
    switch Py.sys.getModule(name: spec.nameObject) {
    case .value(let o):
      if let m = o as? PyModule {
        return .value(m) // Already initialized. Nothing to do...
      }

      // override whatever we have there
      return .notFound

    case .notFound:
      // We have to initialize it
      return .notFound

    case .error(let e):
      let e = self.newPyImportError(
        msg: "error when checking if '\(spec.name)' was already initialized",
        cause: e
      )

      return .error(e)
    }
  }

  private func findModuleOnDisc(spec: ModuleSpec) -> ImportlibResult<URL> {
    let moduleSearchPaths: [PyObject]

    switch self.toArray(iterable: self.sys.path) {
    case let .value(p):
      moduleSearchPaths = p
    case let .error(e):
      let e = self.newPyImportError(
        msg: "expected 'sys.path' to be a list of str, got \(self.sys.path.typeName)",
        cause: e
      )

      return .error(e)
    }

    var triedPaths = [URL]()
    for object in moduleSearchPaths {
      // If this is not 'str' then ignore
      guard let path = object as? PyString else {
        continue
      }

      // Try 'path/filename'
      let pathUrl = URL(fileURLWithPath: path.value)
      let moduleUrl = pathUrl.appendingPathComponent(spec.filename)

      triedPaths.append(pathUrl)

      let stat: FileStat
      switch self.fileSystem.stat(path: moduleUrl.path) {
      case .value(let s): stat = s
      case .enoent: continue // No such file - just try next 'path'
      case .error(let e):
        let e = self.newPyImportError(
          msg: "\(spec.name) spec error for '\(path.value)'",
          cause: e
        )

        return .error(e)
      }

      // Currently our 'importlib' is just a single file,
      // there is no need to support full module with '__init__' etc.
      if stat.isRegularFile {
        return .value(moduleUrl)
      }
    }

    let paths = triedPaths.map { $0.path }.joined(separator: ", ")
    let msg = "'\(spec.name)' not found, tried: \(paths)."
    return .error(self.newPyImportError(msg: msg))
  }

  private func createModule(spec: ModuleSpec,
                            code: PyCode) -> ImportlibResult<PyModule> {
    let module = Py.newModule(name: spec.name)

    let moduleDict = module.getDict()
    moduleDict.set(id: .__name__, to: spec.nameObject)
    moduleDict.set(id: .__file__, to: code.filename)

    switch Py.sys.addModule(name: spec.nameObject, module: module) {
    case .value:
      break
    case .error(let e):
      return .error(self.createModuleError(spec: spec, cause: e))
    }

    // Run the module code, using 'module.__dict__' as env
    let result = Py.delegate.eval(
      name: nil,
      qualname: nil,
      code: code,
      args: [],
      kwargs: nil,
      defaults: [],
      kwDefaults: nil,
      globals: moduleDict,
      locals: moduleDict,
      closure: nil
    )

    switch result {
    case .value:
      return .value(module)
    case .error(let e):
      return .error(self.createModuleError(spec: spec, cause: e))
    }
  }

  private func createModuleError(spec: ModuleSpec,
                                 cause: PyBaseException) -> PyImportError {
    let msg = "can't create '\(spec.name)' module"
    return self.newPyImportError(msg: msg, cause: cause)
  }

  /// Call the `_install` function from given module with sepcified `args`.
  private func callInstall(spec: ModuleSpec,
                           module: PyModule,
                           args: [PyObject]) -> PyImportError? {
    switch Py.getAttribute(module, name: "_install") {
    case let .value(fn):
      switch Py.call(callable: fn, args: args, kwargs: nil) {
      case .value:
        return nil
      case .notCallable(let e),
           .error(let e):
        return self.createModuleError(spec: spec, cause: e)
      }

    case let .error(e):
      return self.createInstallError(spec: spec, cause: e)
    }
  }

  private func createInstallError(spec: ModuleSpec,
                                  cause: PyBaseException) -> PyImportError {
    let msg = "can't install \(spec.name)"
    return self.newPyImportError(msg: msg, cause: cause)
  }

  private func newPyImportError(msg base : String,
                                cause: PyBaseException) -> PyImportError {
    let msg: String = {
      if let details = cause.message {
        return "\(base): \(details)."
      }

      return base + "."
    }()

    let result = Py.newPyImportError(msg: msg)
    result.setCause(cause)
    return result
  }
}
