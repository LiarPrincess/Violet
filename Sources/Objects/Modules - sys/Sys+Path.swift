import Core
import Foundation

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

  // MARK: - Meta path

  // sourcery: pyproperty = meta_path
  internal var metaPath: PyObject {
    return self.get(key: .meta_path) ?? Py.newList()
  }

  // MARK: - Path hooks

  // sourcery: pyproperty = path_hooks
  internal var pathHooks: PyObject {
    return self.get(key: .path_hooks) ?? Py.newList()
  }

  // MARK: - Path importer cache

  // sourcery: pyproperty = path_importer_cache
  internal var pathImporterCache: PyObject {
    return self.get(key: .path_importer_cache) ?? Py.newDict()
  }

  // MARK: - Path

  // sourcery: pyproperty = path, setter = setPath
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
  internal var path: PyObject {
    if let value = self.get(key: .path) {
      return value
    }

    let strings = self.createDefaultPath()
    let objects = strings.map(Py.newString(_:))
    return Py.newList(objects)
  }

  internal func setPath(to value: PyObject) -> PyResult<()> {
    self.set(key: .path, value: value)
    return .value()
  }

  public func prependPath(value: String) -> PyResult<PyNone> {
    guard let list = self.path as? PyList else {
      let t = self.argv.typeName
      let pikachu = "<surprised Pikachu face>"
      return .typeError("expected 'sys.path' to be a list not \(t) \(pikachu)")
    }

    let object = Py.newString(value)
    list.data.prepend(object)
    return .value(Py.none)
  }

  /// static _PyInitError
  /// calculate_module_search_path(const _PyCoreConfig *core_config,
  ///                              PyCalculatePath *calculate,
  ///                              const wchar_t *prefix,
  ///                              const wchar_t *exec_prefix,
  ///                              _PyPathConfig *config)
  private func createDefaultPath() -> [String] {
    var result = [String]()

    // Run-time value of $VIOLETPATH goes first
    let envPaths = Py.config.environment.violetPath
    result.append(contentsOf: envPaths)

    // Next goes merge of compile-time $VIOLETPATH with dynamically located prefix.
    let prefix = self.getPrefixAsStringOrTrap()
    let prefixUrl = URL(fileURLWithPath: prefix.value)

    for suffix in Configure.pythonPath {
      let url = prefixUrl.appendingPathComponent(suffix)
      result.append(url.path)
    }

    // Violet special: add 'prefix' and 'prefix/Lib'
    // This will add 'Lib' directory from our repository root.
    result.append(prefixUrl.path)
    result.append(prefixUrl.appendingPathComponent(lib).path)

    result.removeDuplicates()
    return result
  }

  // MARK: - Prefix

  // sourcery: pyproperty = prefix
  internal var prefix: PyObject {
    if let value = self.get(key: .prefix) {
      return value
    }

    let result = self.createDefaultPrefix()
    return Py.newString(result)
  }

  private func getPrefixAsStringOrTrap() -> PyString {
    if let str = self.prefix as? PyString {
      return str
    }

    trap("Expected 'sys.prefix' to be a str.")
  }

  /// static int
  /// search_for_prefix(const _PyCoreConfig *core_config, ...)
  private func createDefaultPrefix() -> String {
    // If $VIOLETHOME is set, we believe it unconditionally
    if let home = Py.config.environment.violetHome {
      return home
    }

    // CPython: Search from argv0_path, until root.
    // Violet:  We will start from executable path.
    let executablePath = Py.config.executablePath
    var candidate = URL(fileURLWithPath: executablePath)

    var depth = 0
    let maxDepth = candidate.pathComponents.count

    while depth < maxDepth {
      let landmarkUrl = candidate
        .appendingPathComponent(lib)
        .appendingPathComponent(landmark)

      if self.isFile(path: landmarkUrl.path) {
        return candidate.path
      }

      candidate.deleteLastPathComponent()
      depth += 1
    }

    return Configure.prefix
  }

  // MARK: - Helpers

  private func isFile(path: String) -> Bool {
    switch Py.fileSystem.stat(path: path) {
    case .value(let s):
      return s.isRegularFile
    case .enoent,
         .error:
      return false
    }
  }
}
