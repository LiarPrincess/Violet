import Core
import Objects
import Foundation

private let importlib = "importlib"
private let importlibFilename = "importlib.py"

extension VM {

  // MARK: - Importlib

  internal func initImportlibIfNeeded() throws -> PyModule {
    let interned = Py.getInterned(importlib)

    switch Py.sys.getModule(name: interned) {
    case .value(let o):
      if let m = o as? PyModule {
        return m // Already initialized. Nothing to do...
      }
      // else: override whatever we have there

    case .notFound:
      break // We have to initialize it
    case .error(let e):
      throw VMError.importlibAlreadyInitializedCheckFailed(e)
    }

    let url = try self.findImportlib()
    let source = try self.read(url: url)
    let code = try self.compile(filename: importlibFilename,
                                source: source,
                                mode: .fileInput)

    let module = Py.newModule(name: interned)

    let moduleDict = module.getDict()
    moduleDict.set(id: .__name__, to: interned)
    moduleDict.set(id: .__file__, to: code.filename)

    switch Py.sys.addModule(name: interned, module: module) {
    case .value: break
    case .error(let e): throw VMError.importlibCreationFailed(e)
    }

    switch self.eval(code: code, globals: moduleDict, locals: moduleDict) {
    case .value: break
    case .error(let e): throw VMError.importlibCreationFailed(e)
    }

    try self.installImportlib(module: module)
    return module
  }

  private func findImportlib() throws -> URL {
    let paths = self.configuration.moduleSearchPaths
    var triedPaths = [URL]()

    for path in paths {
      // TODO: Finish this thingie
      let url = URL(fileURLWithPath: path)
        .appendingPathComponent("Lib")
        .appendingPathComponent(importlibFilename)

      if self.fileManager.fileExists(atPath: url.path) {
        return url
      }

      triedPaths.append(url)
    }

    throw VMError.importlibNotFound(triedPaths: triedPaths)
  }

  private func read(url: URL) throws -> String {
    let encoding = String.Encoding.utf8

    do {
      return try String(contentsOf: url, encoding: encoding)
    } catch {
      throw VMError.importlibIsNotReadable(url: url, encoding: encoding)
    }
  }

  /// Call the `_install` function from `importlib` module.
  private func installImportlib(module: PyModule) throws {
    switch Py.getAttribute(module, name: "_install") {
    case let .value(install):
      let args = [Py.sysModule, Py._impModule]
      switch Py.call(callable: install, args: args, kwargs: nil) {
      case .value:
        return
      case .notCallable(let e),
           .error(let e):
        throw VMError.importlibInstallError(e)
      }

    case let .error(e):
      throw VMError.importlibInstallError(e)
    }
  }
}
