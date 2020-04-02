import Foundation

// In CPython:
// Python -> Modules -> posixmodule.c

// sourcery: pymodule = _os
/// Please note that this is not a full implementation of `_os`.
/// We implement just enough to make `importlib` work.
public final class UnderscoreOS {

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()

  // MARK: - Cwd

  // sourcery: pymethod = getcwd
  /// static PyObject *
  /// posix_getcwd(int use_bytes)
  public func getCwd() -> PyString {
    let value = Py.fileSystem.currentWorkingDirectory

    // 'cwd' tend not to change during the program runtime, so we can cache it.
    return Py.getInterned(value)
  }

  // MARK: - FSPath

  // sourcery: pymethod = fspath
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

  // sourcery: pymethod = stat
  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.DirEntry.stat
  ///
  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, ... )
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

  private func createStat(from stat: FileStatResult,
                          path: String? = nil) -> PyResult<PyObject> {
    switch stat {
    case .value(let stat):
      let result = self.createStat(from: stat)
      return result.map { $0 as PyObject }

    case .enoent:
      return .error(Py.newFileNotFoundError())
    case .error(let e):
      return .error(e)
    }
  }

  private func createStat(from stat: FileStat) -> PyResult<PyNamespace> {
    let dict = Py.newDict()

    let modeKey = Py.getInterned("st_mode")
    switch dict.set(key: modeKey, to: Py.newInt(stat.st_mode)) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    // Store mtime as 'seconds[.]nanoseconds'
    let mtime = stat.st_mtimespec
    let mtimeValue = Double(mtime.tv_sec) + 1e-9 * Double(mtime.tv_nsec)
    let mtimeKey = Py.getInterned("st_mtime")

    switch dict.set(key: mtimeKey, to: Py.newFloat(mtimeValue)) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    let result = Py.newNamespace(dict: dict)
    return .value(result)
  }

  // MARK: - Listdir

  // sourcery: pymethod = listdir
  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.listdir
  ///
  /// static PyObject *
  /// os_listdir_impl(PyObject *module, path_t *path)
  public func listDir(path: PyObject? = nil) -> PyResult<PyObject> {
    switch self.parseListDirPath(path: path) {
    case let .descriptor(fd):
      let result = Py.fileSystem.listDir(fd: fd)
      return self.handleListDirResult(result: result)

    case let .path(path):
      let result = Py.fileSystem.listDir(path: path)
      return self.handleListDirResult(result: result)

    case let .error(e):
      return .error(e)
    }
  }

  private func parseListDirPath(path: PyObject?) -> ParsePathOrDescriptorResult {
    guard let path = path else {
      return .path(".")
    }

    return self.parsePathOrDescriptor(object: path)
  }

  private func handleListDirResult(result: ListDirResult) -> PyResult<PyObject> {
    switch result {
    case .entries(let entries):
      let elements = entries.map(Py.newString(_:))
      let list = Py.newList(elements)
      return .value(list)
    case .enoent:
      return .error(Py.newFileNotFoundError())
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  private func parsePath(object: PyObject) -> PyResult<PyString> {
    if let str = object as? PyString {
      return .value(str)
    }

    if let bytes = object as? PyBytesType {
      if let str = bytes.data.string {
        let result = Py.newString(str)
        return .value(result)
      }

      return .valueError("cannot decode byte path as string")
    }

    let msg = "path should be string or bytes, not \(object.typeName)"
    return .typeError(msg)
  }

  private enum ParsePathOrDescriptorResult {
    case descriptor(Int32)
    case path(String)
    case error(PyBaseException)
  }

  private func parsePathOrDescriptor(
    object: PyObject
  ) -> ParsePathOrDescriptorResult {
    if let pyInt = object as? PyInt {
      if let fd = Int32(exactly: pyInt.value) {
        return .descriptor(fd)
      }

      let msg = "fd is greater than maximum"
      return .error(Py.newOverflowError(msg: msg))
    }

    if let str = object as? PyString {
      return .path(str.value)
    }

    if let bytes = object as? PyBytesType {
      if let str = bytes.data.string {
        return .path(str)
      }

      let msg = "cannot decode byte path as string"
      return .error(Py.newValueError(msg: msg))
    }

    let msg = "path should be string, bytes or integer, not \(object.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }
}
