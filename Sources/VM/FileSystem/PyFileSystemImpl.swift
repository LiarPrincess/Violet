import Foundation
import FileSystem
import VioletObjects

internal class PyFileSystemImpl: PyFileSystem {

  private let bundle: Bundle
  private let fileSystem: FileSystem

  internal init(bundle: Bundle, fileSystem: FileSystem) {
    self.bundle = bundle
    self.fileSystem = fileSystem
  }

  // MARK: - Executable

  internal var executablePath: String? {
    return self.bundle.executablePath
  }

  // MARK: - Cwd

  internal var currentWorkingDirectory: String {
    return self.fileSystem.currentWorkingDirectory
  }

  // MARK: - Open

  internal func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    // When we get raw descriptor we assume that the user knows what they
    // are doing, which means that we can ignore 'mode'.
    let result = FileDescriptor(fileDescriptor: fd, closeOnDealloc: false)
    let adapter = FileDescriptorAdapter(fd: result, path: nil)
    return .value(adapter)
  }

  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, … )
  internal func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    var flags: Int32 = 0
    let createMode: Int = 0o666

    switch mode {
    case .read: flags |= O_RDONLY
    case .write: flags |= O_WRONLY | O_CREAT | O_TRUNC
    case .create: flags |= O_WRONLY | O_EXCL | O_CREAT
    case .append: flags |= O_WRONLY | O_APPEND | O_CREAT
    case .update: flags |= O_RDWR
    }

    if let fd = FileDescriptor(path: path,
                               flags: flags,
                               createMode: createMode) {
      let adapter = FileDescriptorAdapter(fd: fd, path: path)
      return .value(adapter)
    }

    switch self.stat(path: path) {
    case .enoent:
      return .error(Py.newFileNotFoundError(path: path))
    case .value,
         .error:
      // Maybe we could check 'stat' for permissions?
      return .osError("unable to open '\(path)' (mode: \(mode))")
    }
  }

  // MARK: - Stat

  internal func stat(fd: Int32) -> PyFileSystem_StatResult {
    let result = self.fileSystem.stat(fd: fd)
    return self.handleStatResult(result: result, path: nil)
  }

  internal func stat(path: String) -> PyFileSystem_StatResult {
    let p = Path(string: path)
    let result = self.fileSystem.stat(path: p)
    return self.handleStatResult(result: result, path: path)
  }

  private func handleStatResult(result: FileSystem.StatResult,
                                path: String?) -> PyFileSystem_StatResult {
    switch result {
    case let .value(s):
      let stat = PyFileSystem_Stat(
        st_mode: s.st_mode,
        st_mtime: s.st_mtimespec
      )

      return .value(stat)

    case .enoent:
      return .enoent

    case let .error(errno: e):
      assert(e != ENOENT)

      if let p = path {
        return .error(Py.newOSError(errno: errno, path: p))
      }

      return .error(Py.newOSError(errno: errno))
    }
  }

  // MARK: - List dir

  internal func listdir(fd: Int32) -> PyFileSystem_ListdirResult {
    let result = self.fileSystem.readdir(fd: fd)
    return self.handleReaddirResult(result: result, path: nil)
  }

  internal func listdir(path: String) -> PyFileSystem_ListdirResult {
    let p = Path(string: path)
    let result = self.fileSystem.readdir(path: p)
    return self.handleReaddirResult(result: result, path: path)
  }

  private func handleReaddirResult(result: FileSystem.ReaddirResult,
                                   path: String?) -> PyFileSystem_ListdirResult {
    switch result {
    case let .value(readdir):
      let array = Array(readdir)
      return .entries(array)

    case .enoent:
      return .enoent

    case let .error(errno: e):
      assert(e != ENOENT)

      if let p = path {
        return .error(Py.newOSError(errno: errno, path: p))
      }

      return .error(Py.newOSError(errno: errno))
    }
  }

  // MARK: - Basename

  internal func basename(path: String) -> String {
    let p = Path(string: path)
    return self.fileSystem.basename(path: p)
  }

  // MARK: - Dirname

  internal func dirname(path: String) -> PyFileSystem_DirnameResult {
    let p = Path(string: path)
    let result = self.fileSystem.dirname(path: p)

    return PyFileSystem_DirnameResult(path: result.path.string,
                                      isTop: result.isTop)
  }

  // MARK: - Join

  internal func join(paths: String...) -> String {
    guard let first = paths.first else {
      return ""
    }

    let firstPath = Path(string: first)
    let rest = paths.dropFirst()
    let result = self.fileSystem.join(path: firstPath, elements: rest)
    return result.string
  }
}
