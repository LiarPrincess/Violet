import Core
import Objects
import Foundation

extension VM {

  // MARK: - Importlib

  /// `importlib` is the module used for importing other modules.
  internal func initImportlibIfNeeded() throws -> PyModule {
    let interned = Py.getInterned("importlib")

    switch self.getModuleFromSys(name: interned) {
    case .value(let m): return m
    case .notFound: break
    case .error(let e): throw VMError.importlibCheckInSysFailed(e)
    }

    let url = try self.findModuleOnDisc(
      filename: "importlib.py",
      onError: VMError.importlibNotFound
    )

    let source = try self.read(
      url: url,
      onError: VMError.importlibIsNotReadable
    )

    let code = try self.compile(
      filename: url.lastPathComponent,
      source: source,
      mode: .fileInput
    )

    let module = try self.createModule(
      name: interned,
      code: code,
      onError: VMError.importlibCreationFailed
    )

    try self.callInstall(
      module: module,
      args: [Py.sysModule, Py._impModule],
      onError: VMError.importlibInstallError
    )

    return module
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
  internal func initImportlibExternalIfNeeded(
    importlib: PyModule
  ) throws -> PyModule {
    let interned = Py.getInterned("importlib_external")

    switch self.getModuleFromSys(name: interned) {
    case .value(let m): return m
    case .notFound: break
    case .error(let e): throw VMError.importlibExternalCheckInSysFailed(e)
    }

    let url = try self.findModuleOnDisc(
      filename: "importlib_external.py",
      onError: VMError.importlibExternalNotFound
    )

    let source = try self.read(
      url: url,
      onError: VMError.importlibExternalIsNotReadable
    )

    let code = try self.compile(
      filename: url.lastPathComponent,
      source: source,
      mode: .fileInput
    )

    let module = try self.createModule(
      name: interned,
      code: code,
      onError: VMError.importlibExternalCreationFailed
    )

    try self.callInstall(
      module: module,
      args: [importlib],
      onError: VMError.importlibExternalInstallError
    )

    try self.addExternalToImportlib(importlib: importlib, external: module)
    return module
  }

  /// Add `importlib_external` as `_bootstrap_external` in `importlib`.
  private func addExternalToImportlib(importlib: PyModule,
                                      external: PyModule) throws {
    let dict = importlib.getDict()
    let name = Py.newString("_bootstrap_external")

    switch dict.set(key: name, to: external) {
    case .ok:
      return
    case .error(let e):
      throw VMError.importlibExternalInstallError(e)
    }
  }
}

// MARK: - Helpers

private enum GetModuleFromSysResult {
  case value(PyModule)
  case notFound
  case error(PyBaseException)
}

extension VM {

  private func getModuleFromSys(name: PyString) -> GetModuleFromSysResult {
    switch Py.sys.getModule(name: name) {
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
      return .error(e)
    }
  }

  private func findModuleOnDisc(
    filename: String,
    onError: ([URL]) -> Error
  ) throws -> URL {
    let paths = self.configuration.moduleSearchPaths
    var triedPaths = [URL]()

    for path in paths {
      // Try 'path/filename'
      let urlPath = URL(fileURLWithPath: path)
        .appendingPathComponent(filename)

      if self.fileSystem.exists(path: urlPath.path) {
        return urlPath
      }

      // Same as above but 'path/Lib/file'
      let urlLibPath = URL(fileURLWithPath: path)
        .appendingPathComponent("Lib")
        .appendingPathComponent(filename)

      if self.fileSystem.exists(path: urlLibPath.path) {
        return urlLibPath
      }

      triedPaths.append(urlPath)
      triedPaths.append(urlLibPath)
    }

    throw onError(triedPaths)
  }

  private func createModule(
    name: PyString,
    code: PyCode,
    onError: (PyBaseException) -> Error
  ) throws -> PyModule {
    let module = Py.newModule(name: name)

    let moduleDict = module.getDict()
    moduleDict.set(id: .__name__, to: name)
    moduleDict.set(id: .__file__, to: code.filename)

    switch Py.sys.addModule(name: name, module: module) {
    case .value: break
    case .error(let e): throw onError(e)
    }

    switch self.eval(code: code, globals: moduleDict, locals: moduleDict) {
    case .value: break
    case .error(let e): throw onError(e)
    }

    return module
  }

  /// Call the `_install` function from given module with sepcified `args`.
  private func callInstall(
    module: PyModule,
    args: [PyObject],
    onError: (PyBaseException) -> Error
  ) throws {
    switch Py.getAttribute(module, name: "_install") {
    case let .value(fn):
      switch Py.call(callable: fn, args: args, kwargs: nil) {
      case .value:
        return

      case .notCallable(let e),
           .error(let e):
        throw onError(e)
      }

    case let .error(e):
      throw onError(e)
    }
  }
}
