import Foundation
import FileSystem
import VioletCore

// In CPython:
// Python -> sysmodule.c
// Modules -> getpath.c <-- this!

// https://docs.python.org/3.7/library/sys.html
// https://docs.python.org/3.8/using/cmdline.html
// https://docs.python.org/3/tutorial/modules.html#the-module-search-path <-- this!

/// While searching for `prefix` and `exec_prefix` we will try different
/// locations until the one containing `lib/landmark` is found.
///
/// CPython: `lib/python{VERSION}` (stored in `calculate->lib_python`)
/// Violet:  We will use `Lib` (directory in our repository root).
private let lib = "Lib"

/// While searching for `prefix` and `exec_prefix` we will try different
/// locations until the one containing `lib/landmark` is found.
///
/// CPython: `#define LANDMARK L"os.py"`
/// Violet:   We will use `importlib.py` instead.
private let landmark = "importlib.py"

extension Sys {

  // MARK: - Prefix

  public func getPrefix() -> PyResultGen<PyString> {
    return self.getString(.prefix)
  }

  public func setPrefix(_ value: PyObject) -> PyBaseException? {
    return self.set(.prefix, value: value)
  }

  /// static int
  /// search_for_prefix(const _PyCoreConfig *core_config, ...)
  internal func createInitialPrefix() -> PyString {
    // If we have override in config -> use it
    if let fromConfig = self.py.config.sys.prefix {
      return self.py.newString(fromConfig)
    }

    // If $VIOLETHOME is set, we believe it unconditionally
    if let home = self.py.config.environment.violetHome {
      return self.py.newString(home)
    }

    // CPython: Search from argv0_path, until root.
    // Violet:  We will start from executable path.
    var path = self.py.config.executablePath

    while true {
      let dir = self.py.fileSystem.dirname(path: path)
      let dirPath = dir.path
      let landmarkFile = self.py.fileSystem.join(path: dirPath, elements: lib, landmark)

      if self.isFile(path: landmarkFile) {
        return self.py.newString(dir.path)
      }

      if dir.isTop {
        break // We cannot go more 'up'
      } else {
        path = dirPath // Try parent directory
      }
    }

    let staticPrefix = Configure.createPrefix(self.py)
    return self.py.newString(staticPrefix)
  }

  private func isFile(path: Path) -> Bool {
    switch self.py.fileSystem.stat(self.py, path: path) {
    case .value(let stat):
      return stat.type == .regularFile
    case .enoent,
         .error:
      return false
    }
  }

  // MARK: - Path

  /// sys.path
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.path).
  ///
  /// A list of strings that specifies the search path for modules.
  /// Initialized from the environment variable PYTHONPATH,
  /// plus an installation-dependent default.
  ///
  /// `path[0]`, is the directory containing the script that was used to invoke
  /// the Python interpreter.
  /// If the script directory is not available, `path[0]` is the empty string,
  /// which directs Python to search modules in the current directory first.
  public func getPath() -> PyResultGen<PyList> {
    return self.getList(.path)
  }

  public func setPath(_ value: PyObject) -> PyBaseException? {
    return self.set(.path, value: value)
  }

  /// Prepend given value to `sys.path`.
  public func prependPath(_ value: Path) -> PyBaseException? {
    switch self.getPath() {
    case let .value(list):
      let string = self.py.newString(value)
      let object = string.asObject
      list.prepend(object: object)
      return nil
    case let .error(e):
      return e
    }
  }

  /// static _PyInitError
  /// calculate_module_search_path(const _PyCoreConfig *core_config, ...)
  internal func createInitialPath(prefix: PyString) -> PyList {
    // If we have override in config -> use it
    if let fromConfig = self.py.config.sys.path {
      return self.asList(values: fromConfig)
    }

    var result = [Path]()

    // Run-time value of $VIOLETPATH goes first
    let envPaths = self.py.config.environment.violetPath
    result.append(contentsOf: envPaths)

    let prefixPath = Path(string: prefix.value)

    // Next goes merge of compile-time $VIOLETPATH with dynamically located prefix.
    for suffix in Configure.pythonPath {
      let path = self.py.fileSystem.join(path: prefixPath, element: suffix)
      result.append(path)
    }

    // Violet special: add 'prefix' and 'prefix/Lib'
    // This will add 'Lib' directory from our repository root.
    result.append(prefixPath)

    let libPath = self.py.fileSystem.join(path: prefixPath, elements: lib)
    result.append(libPath)

    result.removeDuplicates()

    return self.asList(values: result)
  }

  private func asList(values: [Path]) -> PyList {
    var elements = [PyObject]()
    elements.reserveCapacity(values.count)

    for path in values {
      let string = self.py.newString(path)
      elements.append(string.asObject)
    }

    return self.py.newList(elements: elements)
  }

  // MARK: - Meta path

  public func getMetaPath() -> PyResultGen<PyList> {
    return self.getList(.meta_path)
  }

  public func setMetaPath(_ value: PyObject) -> PyBaseException? {
    return self.set(.meta_path, value: value)
  }

  // MARK: - Path hooks

  public func getPathHooks() -> PyResultGen<PyList> {
    return self.getList(.path_hooks)
  }

  public func setPathHooks(_ value: PyObject) -> PyBaseException? {
    return self.set(.path_hooks, value: value)
  }

  // MARK: - Path importer cache

  public func getPathImporterCache() -> PyResultGen<PyDict> {
    return self.getDict(.path_importer_cache)
  }

  public func setPathImporterCache(_ value: PyObject) -> PyBaseException? {
    return self.set(.path_importer_cache, value: value)
  }
}
