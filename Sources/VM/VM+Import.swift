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

    let locals = Py.newDict()
    switch eval(code: code, globals: moduleDict, locals: locals) {
    case .value: break
    case .error(let e): throw VMError.importlibCreationFailed(e)
    }

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
}
