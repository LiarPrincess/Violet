import Foundation
import FileSystem

// cSpell:ignore posixmodule fileio nameobj

// In CPython:
// Python -> Modules -> posixmodule.c

/// Please note that this is not a full implementation of `_os`.
/// We implement just enough to make `importlib` work.
public final class UnderscoreOS: PyModuleImplementation {

  internal static let moduleName = "_os"

  internal static let doc = """
    Low level os module.
    It is a helper module to speed up interpreter start-up.
    """

  /// This dict will be used inside our `PyModule` instance.
  internal let __dict__: PyDict
  internal let py: Py

  internal init(_ py: Py) {
    self.py = py
    self.__dict__ = self.py.newDict()
    self.fill__dict__()
  }

  // MARK: - Fill dict

  private func fill__dict__() {
    self.setOrTrap(.getcwd, doc: nil, fn: Self.getcwd(_:))
    self.setOrTrap(.fspath, doc: nil, fn: Self.fspath(_:path:))
    self.setOrTrap(.stat, doc: nil, fn: Self.stat(_:path:))
    self.setOrTrap(.listdir, doc: nil, fn: Self.listdir(_:path:))
  }

  // MARK: - Cwd

  internal static func getcwd(_ py: Py) -> PyResult {
    let result = py._os.getCwd()
    return PyResult(result)
  }

  /// static PyObject *
  /// posix_getcwd(int use_bytes)
  public func getCwd() -> PyString {
    // 'cwd' tend not to change during the program runtime, so we can cache it.
    // If we ever get different value from fileSystem we will re-intern it.
    let value = self.py.fileSystem.currentWorkingDirectory
    return self.py.intern(path: value)
  }

  // MARK: - FSPath

  internal static func fspath(_ py: Py, path: PyObject) -> PyResult {
    let result = py._os.getFSPath(path: path)
    return PyResult(result)
  }

  /// Return the file system representation of the path.
  ///
  /// If str or bytes is passed in, it is returned unchanged.
  ///
  /// In all other cases, TypeError is raised.
  ///
  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.fspath
  ///
  /// PyObject *
  /// PyOS_FSPath(PyObject *path)
  public func getFSPath(path: PyObject) -> PyResultGen<PyString> {
    return self.parsePath(object: path)
  }

  // MARK: - Stat

  internal static func stat(_ py: Py, path: PyObject) -> PyResult {
    let result = py._os.getStat(path: path)
    return PyResult(result)
  }

  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.DirEntry.stat
  ///
  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, … )
  public func getStat(path: PyObject) -> PyResultGen<PyNamespace> {
    switch self.parsePathOrDescriptor(object: path) {
    case let .descriptor(fd):
      let stat = self.py.fileSystem.stat(self.py, fd: fd)
      return self.createStatObject(stat: stat)

    case let .path(path):
      let stat = self.py.fileSystem.stat(self.py, path: path)
      return self.createStatObject(stat: stat, path: path)

    case let .error(e):
      return .error(e)
    }
  }

  private func createStatObject(stat: PyFileSystemStatResult,
                                path: Path? = nil) -> PyResultGen<PyNamespace> {
    switch stat {
    case .value(let stat):
      return self.createStatObject(stat: stat)
    case .enoent:
      let error = self.py.newFileNotFoundError(path: path)
      return .error(error.asBaseException)
    case .error(let e):
      return .error(e.asBaseException)
    }
  }

  private func createStatObject(stat: Stat) -> PyResultGen<PyNamespace> {
    let dict = self.py.newDict()

    let modeKey = self.py.intern(string: "st_mode")
    let modeObject = self.py.newInt(stat.st_mode)

    switch dict.set(self.py, key: modeKey, value: modeObject.asObject) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    // Store mtime as 'seconds[.]nanoseconds'
    let mtimeKey = self.py.intern(string: "st_mtime")
    let mtime = stat.st_mtimespec
    let mtimeValue = Double(mtime.tv_sec) + 1e-9 * Double(mtime.tv_nsec)
    let mtimeObject = self.py.newFloat(mtimeValue)

    switch dict.set(self.py, key: mtimeKey, value: mtimeObject.asObject) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    let result = self.py.newNamespace(dict: dict)
    return .value(result)
  }

  // MARK: - Listdir

  internal static func listdir(_ py: Py, path: PyObject?) -> PyResult {
    let result = py._os.listdir(path: path)
    return PyResult(result)
  }

  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.listdir
  ///
  /// static PyObject *
  /// os_listdir_impl(PyObject *module, path_t *path)
  public func listdir(path: PyObject?) -> PyResultGen<PyList> {
    switch self.parseListdirPath(path: path) {
    case let .descriptor(fd):
      let result = self.py.fileSystem.readdir(self.py, fd: fd)
      return self.createObject(result: result, path: nil)

    case let .path(path):
      let result = self.py.fileSystem.readdir(self.py, path: path)
      return self.createObject(result: result, path: path)

    case let .error(e):
      return .error(e)
    }
  }

  private func parseListdirPath(path: PyObject?) -> ParsePathOrDescriptorResult {
    guard let path = path else {
      let result = Path(string: ".")
      return .path(result)
    }

    return self.parsePathOrDescriptor(object: path)
  }

  private func createObject(result: PyFileSystemReaddirResult,
                            path: Path?) -> PyResultGen<PyList> {
    switch result {
    case .entries(let entries):
      var elements = [PyObject]()
      elements.reserveCapacity(entries.count)

      for filename in entries {
        let string = self.py.newString(filename)
        elements.append(string.asObject)
      }

      let list = self.py.newList(elements: elements)
      return .value(list)

    case .enoent:
      let error = self.py.newFileNotFoundError(path: path)
      return .error(error.asBaseException)
    case .error(let e):
      return .error(e.asBaseException)
    }
  }

  // MARK: - Properties

  internal struct Properties: CustomStringConvertible {
    internal static let getcwd = Properties(value: "getcwd")
    internal static let fspath = Properties(value: "fspath")
    internal static let stat = Properties(value: "stat")
    internal static let listdir = Properties(value: "listdir")

    private let value: String

    internal var description: String {
      return self.value
    }

    // Private so we can't create new values from the outside.
    private init(value: String) {
      self.value = value
    }
  }

  // MARK: - Helpers

  private func parsePath(object: PyObject) -> PyResultGen<PyString> {
    switch self.py.getString(object: object, encoding: .default) {
    case .string(let pyString, _):
      return .value(pyString)
    case .bytes(_, let string):
      let result = self.py.newString(string)
      return .value(result)
    case .byteDecodingError:
      let message = "cannot decode byte path as string"
      return .valueError(self.py, message: message)
    case .notStringOrBytes:
      let message = "path should be string or bytes, not \(object.typeName)"
      return .typeError(self.py, message: message)
    }
  }

  private enum ParsePathOrDescriptorResult {
    case descriptor(Int32)
    case path(Path)
    case error(PyBaseException)
  }

  private func parsePathOrDescriptor(
    object: PyObject
  ) -> ParsePathOrDescriptorResult {
    if let pyInt = self.py.cast.asInt(object) {
      if let fd = Int32(exactly: pyInt.value) {
        return .descriptor(fd)
      }

      let error = self.py.newOverflowError(message: "fd is greater than maximum")
      return .error(error.asBaseException)
    }

    switch self.py.getString(object: object, encoding: .default) {
    case .string(_, let path):
      return .path(Path(string: path))
    case .bytes(_, let path):
      return .path(Path(string: path))
    case .byteDecodingError:
      let message = "cannot decode byte path as string"
      let error = self.py.newValueError(message: message)
      return .error(error.asBaseException)
    case .notStringOrBytes:
      let message = "path should be string, bytes or integer, not \(object.typeName)"
      let error = self.py.newTypeError(message: message)
      return .error(error.asBaseException)
    }
  }
}
