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
    let value = Py.delegate.currentWorkingDirectory

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
    return self.parsePath(path: path)
  }

  private func parsePath(path: PyObject) -> PyResult<PyString> {
    if let str = path as? PyString {
       return .value(str)
     }

     if let bytes = path as? PyBytesType {
       if let str = bytes.data.string {
         let result = Py.newString(str)
         return .value(result)
       }

       return .valueError("cannot decode byte path as string")
     }

     let msg = "expected str or bytes object, not \(path.typeName)"
     return .typeError(msg)
  }

  // MARK: - Stat

  // sourcery: pymethod = stat
  /// Doc:
  /// https://docs.python.org/3/library/os.html#os.DirEntry.stat
  ///
  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, ... )
  public func getStat(path pathArg: PyObject) -> PyResult<PyObject> {
    let path: PyString
    switch self.parsePath(path: pathArg) {
    case let .value(p): path = p
    case let .error(e): return .error(e)
    }

    let stat: FileStat
    switch Py.delegate.stat(path: path.value) {
    case let .value(s): stat = s
    case let .error(e): return .error(e)
    }

    let result = self.createStat(from: stat)
    return result.map { $0 as PyObject }
  }

  private func createStat(from stat: FileStat) -> PyResult<PyNamespace> {
    let dict = Py.newDict()

    let modeKey = Py.getInterned("st_mode")
    switch dict.set(key: modeKey, to: Py.newInt(stat.st_mode)) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    let mtimeKey = Py.getInterned("st_mtime")
    switch dict.set(key: mtimeKey, to: Py.newFloat(stat.st_mtime)) {
    case .ok: break
    case .error(let e): return .error(e)
    }

    let result = Py.newNamespace(dict: dict)
    return .value(result)
  }
}
