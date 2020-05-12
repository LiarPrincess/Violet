import Foundation
import VioletCore

// swiftlint:disable file_length

/// Importlib module spec, so that we can share code between
/// `importlib` and `importlib_external`.
private struct ModuleSpec {

  fileprivate let name: String
  fileprivate let nameObject: PyString
  fileprivate let filename: String

  fileprivate init(name: String, filename: String) {
    self.name = name
    self.nameObject = Py.intern(string: name)
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
  fileprivate let path: String

  fileprivate init(spec: ModuleSpec, path: String) {
    self.spec = spec
    self.path = path
  }
}

/// Just like `PyResult`, but it will force `error` to always be `PyImportError`.
///
/// (Just for additional type-safety, so that we don't return any other error type)
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

  public func getImportlibExternal() -> PyResult<PyModule> {
    let importlib = self.getImportlib()
    return importlib.flatMap(self.getImportlibExternal(importlib:))
  }

  public func getImportlibExternal(importlib: PyModule) -> PyResult<PyModule> {
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

    let path: String
    switch self.findModuleOnDisc(spec: spec) {
    case let .value(p): path = p
    case let .error(e): return .error(e)
    }

    let specPath = ModuleSpecWithPath(spec: spec, path: path)

    let code: PyCode
    switch self.compile(path: path, mode: .fileInput) {
    case let .value(c): code = c
    case let .error(e):
      let msg = "can't compile \(spec.name)"
      let e = self.newImportError(msg: msg, spec: specPath, cause: e)
      return .error(e)
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
      let msg = "error when checking if '\(spec.name)' was already initialized"
      let e = self.newImportError(msg: msg, spec: spec, cause: e)
      return .error(e)
    }
  }

  // MARK: - Find on disc

  private func findModuleOnDisc(spec: ModuleSpec) -> ImportlibResult<String> {
    let moduleSearchPaths: PyList
    switch Py.sys.getPath() {
    case let .value(l): moduleSearchPaths = l
    case let .error(e):
      let msg = "Unable to obtain 'sys.path'"
      let e = self.newImportError(msg: msg, spec: spec, cause: e)
      return .error(e)
    }

    var triedPaths = [String]()
    for object in moduleSearchPaths.elements {
      // If this is not 'str' then ignore
      guard let path = object as? PyString else {
        continue
      }

      // Try 'path/filename'
      let modulePath = Py.fileSystem.join(paths: path.value, spec.filename)
      triedPaths.append(path.value)

      let stat: FileStat
      switch self.fileSystem.stat(path: modulePath) {
      case .value(let s): stat = s
      case .enoent: continue // No such file - just try next 'path'
      case .error(let e):
        let msg = "\(spec.name) spec error for '\(path.value)'"
        let e = self.newImportError(msg: msg, spec: spec, cause: e)
        return .error(e)
      }

      // Currently our 'importlib' is just a single file,
      // there is no need to support full module with '__init__' etc.
      if stat.isRegularFile {
        return .value(modulePath)
      }
    }

    let paths = triedPaths.joined(separator: ", ")
    let msg = "'\(spec.name)' not found, tried: \(paths)."
    return .error(self.newImportError(msg: msg, moduleName: spec.name))
  }

  // MARK: - Create module

  private func createModule(spec: ModuleSpecWithPath,
                            code: PyCode) -> ImportlibResult<PyModule> {
    let module = Py.newModule(name: spec.name)

    let moduleDict = module.getDict()
    moduleDict.set(id: .__name__, to: spec.nameObject)
    moduleDict.set(id: .__file__, to: code.filename)

    if let e = Py.sys.addModule(module: module) {
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

  private func createModuleError(spec: ModuleSpecWithPath,
                                 cause: PyBaseException) -> PyImportError {
    let msg = "can't create '\(spec.name)' module"
    return self.newImportError(msg: msg, spec: spec, cause: cause)
  }

  // MARK: - Install

  /// Call the `_install` function from given module with sepcified `args`.
  private func callInstall(spec: ModuleSpecWithPath,
                           module: PyModule,
                           args: [PyObject]) -> PyImportError? {
    switch Py.getattr(object: module, name: "_install") {
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

  private func createInstallError(spec: ModuleSpecWithPath,
                                  cause: PyBaseException) -> PyImportError {
    let msg = "can't install \(spec.name)"
    return self.newImportError(msg: msg, spec: spec, cause: cause)
  }

  // MARK: - Create errors

  private func newImportError(msg: String,
                              spec: ModuleSpec,
                              cause: PyBaseException) -> PyImportError {
    let result = Py.newImportError(msg: msg, moduleName: spec.name)
    result.setCause(cause)
    return result
  }

  private func newImportError(msg: String,
                              spec: ModuleSpecWithPath,
                              cause: PyBaseException) -> PyImportError {
    let result = Py.newImportError(msg: msg,
                                   moduleName: spec.name,
                                   modulePath: spec.path)
    result.setCause(cause)
    return result
  }
}
