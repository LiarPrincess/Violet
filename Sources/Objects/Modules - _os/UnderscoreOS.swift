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

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  public let __dict__ = Py.newDict()

  // MARK: - Init

  internal init() {
    self.fill__dict__()
  }

  // MARK: - Fill dict

  private func fill__dict__() {
    // Note that capturing 'self' is intended.
    // See comment at the top of 'PyModuleImplementation' for details.
    self.setOrTrap(.getcwd, doc: nil, fn: self.getCwd)
    self.setOrTrap(.fspath, doc: nil, fn: self.getFSPath(path:))
    self.setOrTrap(.stat, doc: nil, fn: self.getStat(path:))
    self.setOrTrap(.listdir, doc: nil, fn: self.listdir(path:))
  }

  // MARK: - Cwd

  /// static PyObject *
  /// posix_getcwd(int use_bytes)
  public func getCwd() -> PyString {
    let value = Py.fileSystem.currentWorkingDirectory

    // 'cwd' tend not to change during the program runtime, so we can cache it.
    // If we ever get different value from fileSystem we will re-intern it.
    return Py.intern(path: value)
  }

  // MARK: - FSPath

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
  public func getFSPath(path: PyObject) -> PyResult<PyString> {
    return self.parsePath(object: path)
  }

  // MARK: - Stat

  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.DirEntry.stat
  ///
  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, … )
  public func getStat(path: PyObject) -> PyResult<PyObject> {
    switch self.parsePathOrDescriptor(object: path) {
    case let .descriptor(fd):
      let stat = Py.fileSystem.stat(fd: fd)
      return self.createStat(from: stat)

    case let .path(path):
      let stat = Py.fileSystem.stat(path: path)
      return self.createStat(from: stat, path: path)

    case let .error(e):
      return .error(e)
    }
  }

  private func createStat(from stat: PyFileSystem_StatResult,
                          path: Path? = nil) -> PyResult<PyObject> {
    switch stat {
    case .value(let stat):
      let result = self.createStat(from: stat)
      return result.map { $0 as PyObject }

    case .enoent:
      return .error(Py.newFileNotFoundError(path: path))
    case .error(let e):
      return .error(e)
    }
  }

  private func createStat(from stat: Stat) -> PyResult<PyNamespace> {
    let dict = Py.newDict()

    let modeKey = Py.intern(string: "st_mode")
    switch dict.set(key: modeKey, to: Py.newInt(stat.st_mode)) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    // Store mtime as 'seconds[.]nanoseconds'
    let mtime = stat.st_mtimespec
    let mtimeValue = Double(mtime.tv_sec) + 1e-9 * Double(mtime.tv_nsec)
    let mtimeKey = Py.intern(string: "st_mtime")

    switch dict.set(key: mtimeKey, to: Py.newFloat(mtimeValue)) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    let result = Py.newNamespace(dict: dict)
    return .value(result)
  }

  // MARK: - Listdir

  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.listdir
  ///
  /// static PyObject *
  /// os_listdir_impl(PyObject *module, path_t *path)
  public func listdir(path: PyObject? = nil) -> PyResult<PyObject> {
    switch self.parseListdirPath(path: path) {
    case let .descriptor(fd):
      let result = Py.fileSystem.readdir(fd: fd)
      return self.handleReaddirResult(result: result, path: nil)

    case let .path(path):
      let result = Py.fileSystem.readdir(path: path)
      return self.handleReaddirResult(result: result, path: path)

    case let .error(e):
      return .error(e)
    }
  }

  private func parseListdirPath(path: PyObject?) -> ParsePathOrDescriptorResult {
    guard let path = path else {
      return .path(Path(string: "."))
    }

    return self.parsePathOrDescriptor(object: path)
  }

  private func handleReaddirResult(result: PyFileSystem_ReaddirResult,
                                   path: Path?) -> PyResult<PyObject> {
    switch result {
    case .entries(let entries):
      let elements = entries.map(Py.newString(_:))
      let list = Py.newList(elements: elements)
      return .value(list)
    case .enoent:
      return .error(Py.newFileNotFoundError(path: path))
    case .error(let e):
      return .error(e)
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

  private func parsePath(object: PyObject) -> PyResult<PyString> {
    switch Py.getString(object: object) {
    case .string(let pyString, _):
      return .value(pyString)
    case .bytes(_, let string):
      let result = Py.newString(string)
      return .value(result)
    case .byteDecodingError:
      return .valueError("cannot decode byte path as string")
    case .notStringOrBytes:
      let msg = "path should be string or bytes, not \(object.typeName)"
      return .typeError(msg)
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
    if let pyInt = PyCast.asInt(object) {
      if let fd = Int32(exactly: pyInt.value) {
        return .descriptor(fd)
      }

      let msg = "fd is greater than maximum"
      return .error(Py.newOverflowError(msg: msg))
    }

    switch Py.getString(object: object) {
    case .string(_, let path):
      return .path(Path(string: path))
    case .bytes(_, let path):
      return .path(Path(string: path))
    case .byteDecodingError:
      let msg = "cannot decode byte path as string"
      return .error(Py.newValueError(msg: msg))
    case .notStringOrBytes:
      let msg = "path should be string, bytes or integer, not \(object.typeName)"
      return .error(Py.newTypeError(msg: msg))
    }
  }
}
