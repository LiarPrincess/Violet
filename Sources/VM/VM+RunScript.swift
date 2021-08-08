import Foundation
import FileSystem
import VioletCore
import VioletObjects

// cSpell:ignore closeit zipfile PYTHONSTARTUP

// In CPython:
// Python -> main.c

extension VM {

  // MARK: - Run script

  /// int
  /// PyRun_SimpleFileExFlags(FILE *fp, const char *filename, int closeit, ...)
  internal func run(scriptPath: Path) -> PyResult<PyObject> {
    // From 'https://docs.python.org/3.7/using/cmdline.html':
    // Execute the Python code contained in script, which must be a filesystem path
    // (absolute or relative) referring to either a Python file, a directory
    // containing a __main__.py file, or a zipfile containing a __main__.py file.
    // - 1st element of sys.argv will be the script name as given on the command line
    // - If the script name refers to a Python file,
    //   the directory containing that file is added to the start of sys.path,
    //   and the file is executed as the __main__ module.
    // - If the script name refers to a directory or zipfile,
    //   the script name is added to the start of sys.path and
    //   the __main__.py file in that location is executed as the __main__ module.
    // Btw. we don't support 'PYTHONSTARTUP'!

    let script: ScriptLocation
    switch self.getScriptLocation(path: scriptPath) {
    case let .value(s): script = s
    case let .error(e): return .error(e)
    }

    let code: PyCode
    let compileResult = Py.compile(path: script.__main__, mode: .fileInput)
    switch compileResult.asResult() {
    case let .value(c): code = c
    case let .error(e): return .error(e)
    }

    if let e = self.setArgv0(value: scriptPath) {
      return .error(e)
    }

    if let e = self.prependPath(value: script.directory) {
      return .error(e)
    }

    let main: PyModule
    switch self.add__main__Module(loader: .sourceFileLoader, ifAlreadyExists: .use) {
    case let .value(m): main = m
    case let .error(e): return .error(e)
    }

    // Set '__file__' (remember to cleanup later!).
    let mainDict = Py.get__dict__(module: main)
    mainDict.set(id: .__file__, to: Py.newString(scriptPath))
    defer { _ = mainDict.del(id: .__file__) }

    return self.eval(code: code, globals: mainDict, locals: mainDict)
  }

  // MARK: - Script location

  private struct ScriptLocation {
    /// File to execute.
    fileprivate let __main__: Path
    /// Directory to add to `sys.path`.
    fileprivate let directory: Path
  }

  private func getScriptLocation(path: Path) -> PyResult<ScriptLocation> {
    let stat: Stat
    switch self.fileSystem.stat(path: path) {
    case .value(let s):
      stat = s
    case .enoent:
      return .error(Py.newFileNotFoundError(path: path))
    case .error(let e):
      return .error(e)
    }

    switch stat.type {
    case .regularFile:
      let dir = self.fileSystem.dirname(path: path)
      let location = ScriptLocation(__main__: path, directory: dir.path)
      return .value(location)
    case .directory:
      return self.try__main__(inside: path)
    default:
      let msg = "'\(path)' is neither file nor directory (mode: \(stat.st_mode))"
      return .error(Py.newOSError(msg: msg))
    }
  }

  private func try__main__(inside dir: Path) -> PyResult<ScriptLocation> {
    let main = self.fileSystem.join(path: dir, elements: "__main__.py")

    switch self.fileSystem.stat(path: main) {
    case .value(let stat):
      switch stat.type {
      case .regularFile:
        let location = ScriptLocation(__main__: main, directory: dir)
        return .value(location)
      default:
        let msg = "'\(main)' is not a file (mode: \(stat.st_mode))"
        return .error(Py.newOSError(msg: msg))
      }

    case .enoent:
      return .error(Py.newFileNotFoundError(path: main))
    case .error(let e):
      return .error(e)
    }
  }
}
