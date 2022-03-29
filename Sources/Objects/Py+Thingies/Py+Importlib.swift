import Foundation
import FileSystem
import VioletCore

/// Importlib module spec, so that we can share code between
/// `importlib` and `importlib_external`.
private struct ModuleSpec {

  fileprivate let name: String
  fileprivate let nameObject: PyString
  fileprivate let filename: String

  fileprivate init(_ py: Py, name: String, filename: String) {
    self.name = name
    self.nameObject = py.newString(name)
    self.filename = filename
  }
}

/// When we find module on disc we will add `path` to spec
/// (to add it to eventual `ImportError`).
private struct ModuleSpecWithPath {

  private let spec: ModuleSpec

  fileprivate var name: String { return self.spec.name }
  fileprivate var nameObject: PyString { return self.spec.nameObject }
  fileprivate var filename: String { return self.spec.filename }
  fileprivate let path: Path

  fileprivate init(spec: ModuleSpec, path: Path) {
    self.spec = spec
    self.path = path
  }
}

/// Just like `PyResult`, but it will force `error` to always be `PyImportError`.
///
/// (For additional type-safety, so that we don't return any other error type)
private enum ImportlibResult<Wrapped> {
  case value(Wrapped)
  case error(PyImportError)
}

extension Py {

  // MARK: - Importlib

  /// `importlib` is the module used for importing other modules.
  public func getImportlib() -> PyResultGen<PyModule> {
    // 'self.initImportlibIfNeeded' is idempotent:
    // - if it was never called it will initialize it
    // - if we already called it then it will return module from 'sys'
    //
    // Unless you do something like 'sys.modules['importlib'] = "let it go"',
    // in such case we will reinitialize the whole thing.

    return self.initImportlibIfNeeded()
  }

  /// `importlib` is the module used for importing other modules.
  public func initImportlibIfNeeded() -> PyResultGen<PyModule> {
    let spec = ModuleSpec(
      self,
      name: "importlib",
      filename: "importlib.py"
    )

    let args = [self.sysModule.asObject, self._impModule.asObject]
    let module = self.initImportlibModule(spec: spec, installArgs: args)
    return self.toResult(module)
  }

  // MARK: - Importlib external

  public func getImportlibExternal() -> PyResultGen<PyModule> {
    let importlib = self.getImportlib()
    return importlib.flatMap(self.getImportlibExternal(importlib:))
  }

  public func getImportlibExternal(importlib: PyModule) -> PyResultGen<PyModule> {
    // 'self.initImportlibExternalIfNeeded' is idempotent (with the same caveats
    // as 'self.initImportlibIfNeeded').
    return self.initImportlibExternalIfNeeded(importlib: importlib)
  }

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
  ) -> PyResultGen<PyModule> {
    let spec = ModuleSpec(
      self,
      name: "importlib_external",
      filename: "importlib_external.py"
    )

    let args = [importlib.asObject]
    let module = self.initImportlibModule(spec: spec, installArgs: args)
    return self.toResult(module)
  }

  private func toResult(_ result: ImportlibResult<PyModule>) -> PyResultGen<PyModule> {
    switch result {
    case let .value(w):
      return .value(w)
    case let .error(e):
      return .error(e.asBaseException)
    }
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

    let path: Path
    switch self.findModuleOnDisc(spec: spec) {
    case let .value(p): path = p
    case let .error(e): return .error(e)
    }

    let code: PyCode
    let compileResult = self.compile(path: path, mode: .fileInput, optimize: .fromSys)
    let specPath = ModuleSpecWithPath(spec: spec, path: path)

    switch compileResult {
    case let .value(c): code = c
    case let .error(e):
      let message = "can't compile \(spec.name)"
      let cause = e.asBaseException
      return .error(self.newImportError(message: message, spec: specPath, cause: cause))
    }

    let module: PyModule
    switch self.createModule(spec: specPath, code: code) {
    case let .value(m): module = m
    case let .error(e): return .error(e)
    }

    if let e = self.callInstall(spec: specPath, module: module, args: installArgs) {
      return .error(e)
    }

    return .value(module)
  }
}

// MARK: - Get from sys

private enum GetModuleFromSysResult {
  case value(PyModule)
  case notFound
  case error(PyImportError)
}

extension Py {

  private func getModuleFromSys(spec: ModuleSpec) -> GetModuleFromSysResult {
    switch self.sys.getModule(name: spec.nameObject) {
    case .module(let m): // Already initialized. Nothing to do…
      return .value(m)
    case .notModule, // Override whatever we have there
         .notFound: // We have to initialize it
      return .notFound
    case .error(let e):
      let message = "error when checking if '\(spec.name)' was already initialized"
      let e = self.newImportError(message: message, spec: spec, cause: e)
      return .error(e)
    }
  }

  // MARK: - Find on disc

  private func findModuleOnDisc(spec: ModuleSpec) -> ImportlibResult<Path> {
    let moduleSearchPaths: PyList
    switch self.sys.getPath() {
    case let .value(l): moduleSearchPaths = l
    case let .error(e):
      let message = "Unable to obtain 'sys.path'"
      let e = self.newImportError(message: message, spec: spec, cause: e)
      return .error(e)
    }

    var triedPaths = [Path]()
    for object in moduleSearchPaths.elements {
      // If this is not 'str' then ignore
      guard let dirPyString = self.cast.asString(object) else {
        continue
      }

      // Try 'dir/filename'
      let dir = Path(string: dirPyString.value)
      let modulePath = self.fileSystem.join(path: dir, element: spec.filename)
      triedPaths.append(dir)

      let stat: Stat
      switch self.fileSystem.stat(self, path: modulePath) {
      case .value(let s): stat = s
      case .enoent: continue // No such file - just try next 'path'
      case .error(let e):
        let message = "\(spec.name) spec error for '\(dir)'"
        let cause = e.asBaseException
        return .error(self.newImportError(message: message, spec: spec, cause: cause))
      }

      // Currently our 'importlib' is just a single file,
      // there is no need to support full module with '__init__' etc.
      switch stat.type {
      case .regularFile: return .value(modulePath)
      case .directory: trap("Ooo… 'importlib' is now a directory?")
      default: trap("Unsupported 'importlib' type '\(stat.type)'.")
      }
    }

    let paths = triedPaths.lazy.map { $0.string }.joined(separator: ", ")
    let message = "'\(spec.name)' not found, tried: \(paths)."
    return .error(self.newImportError(message: message, spec: spec))
  }

  // MARK: - Create module

  private func createModule(spec: ModuleSpecWithPath,
                            code: PyCode) -> ImportlibResult<PyModule> {
    let module = self.newModule(name: spec.name, doc: nil, dict: nil)
    let dict = module.getDict(self)

    let nameObject = spec.nameObject.asObject
    dict.set(self, id: .__name__, value: nameObject)

    let filenameObject = code.filename.asObject
    dict.set(self, id: .__file__, value: filenameObject)

    if let e = self.sys.addModule(module: module) {
      return .error(self.createModuleError(spec: spec, cause: e))
    }

    // Run the module code, using 'module.__dict__' as env
    let result = self.delegate.eval(self,
                                    name: nil,
                                    qualname: nil,
                                    code: code,
                                    args: [],
                                    kwargs: nil,
                                    defaults: [],
                                    kwDefaults: nil,
                                    globals: dict,
                                    locals: dict,
                                    closure: nil)

    switch result {
    case .value:
      return .value(module)
    case .error(let e):
      return .error(self.createModuleError(spec: spec, cause: e))
    }
  }

  private func createModuleError(spec: ModuleSpecWithPath,
                                 cause: PyBaseException) -> PyImportError {
    let message = "can't create '\(spec.name)' module"
    return self.newImportError(message: message, spec: spec, cause: cause)
  }

  // MARK: - Install

  /// Call the `_install` function from given module with specified `args`.
  private func callInstall(spec: ModuleSpecWithPath,
                           module: PyModule,
                           args: [PyObject]) -> PyImportError? {
    let moduleObject = module.asObject
    switch self.getAttribute(object: moduleObject, name: "_install") {
    case let .value(fn):
      switch self.call(callable: fn, args: args, kwargs: nil) {
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

  private func createInstallError(spec: ModuleSpecWithPath,
                                  cause: PyBaseException) -> PyImportError {
    let message = "can't install \(spec.name)"
    return self.newImportError(message: message, spec: spec, cause: cause)
  }

  // MARK: - Create errors

  private func newImportError(message: String,
                              spec: ModuleSpec,
                              cause: PyBaseException? = nil) -> PyImportError {
    let result = self.newImportError(message: message, moduleName: spec.name)
    self.setCause(error: result, cause: cause)
    return result
  }

  private func newImportError(message: String,
                              spec: ModuleSpecWithPath,
                              cause: PyBaseException) -> PyImportError {
    let result = self.newImportError(message: message,
                                     moduleName: spec.name,
                                     modulePath: spec.path)
    self.setCause(error: result, cause: cause)
    return result
  }

  private func setCause(error: PyImportError, cause: PyBaseException?) {
    if let cause = cause {
      let base = error.asBaseException
      self.setCause(exception: base, cause: cause)
    }
  }
}
