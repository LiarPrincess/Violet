import Foundation
import FileSystem
import VioletObjects

// cSpell:ignore fileio nameobj

internal class PyFileSystem: PyFileSystemType {

  private let fileSystem: FileSystem

  internal init(fileSystem: FileSystem) {
    self.fileSystem = fileSystem
  }

  // MARK: - Cwd

  internal var currentWorkingDirectory: Path {
    return self.fileSystem.currentWorkingDirectory
  }

  // MARK: - Open

  internal func open(_ py: Py,
                     fd: Int32,
                     mode: FileMode) -> PyResultGen<PyFileDescriptorType> {
    // When we get raw descriptor we assume that the user knows what they
    // are doing, which means that we can ignore 'mode'.
    let result = FileDescriptor(fileDescriptor: fd, closeOnDealloc: false)
    let adapter = PyFileDescriptor(fd: result, path: nil)
    return .value(adapter)
  }

  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, … )
  internal func open(_ py: Py,
                     path: Path,
                     mode: FileMode) -> PyResultGen<PyFileDescriptorType> {
    var flags: Int32 = 0
    switch mode {
    case .read: flags |= O_RDONLY
    case .write: flags |= O_WRONLY | O_CREAT | O_TRUNC
    case .create: flags |= O_WRONLY | O_EXCL | O_CREAT
    case .append: flags |= O_WRONLY | O_APPEND | O_CREAT
    case .update: flags |= O_RDWR
    }

    let createMode: Int = 0o666
    if let fd = FileDescriptor(path: path.string,
                               flags: flags,
                               createMode: createMode) {
      let adapter = PyFileDescriptor(fd: fd, path: path.string)
      return .value(adapter)
    }

    switch self.stat(py, path: path) {
    case .enoent:
      let error = py.newFileNotFoundError(path: path)
      return .error(error.asBaseException)
    case .value,
        .error:
      // Maybe we could check 'stat' for permissions?
      return .osError(py, message: "unable to open '\(path)' (mode: \(mode))")
    }
  }

  // MARK: - Stat

  internal func stat(_ py: Py, fd: Int32) -> PyFileSystemStatResult {
    let result = self.fileSystem.stat(fd: fd)
    return self.handleStatResult(py, result: result, path: nil)
  }

  internal func stat(_ py: Py, path: Path) -> PyFileSystemStatResult {
    let result = self.fileSystem.stat(path: path)
    return self.handleStatResult(py, result: result, path: path)
  }

  private func handleStatResult(_ py: Py,
                                result: FileSystem.StatResult,
                                path: Path?) -> PyFileSystemStatResult {
    switch result {
    case let .value(stat):
      return .value(stat)

    case .enoent:
      return .enoent

    case let .error(errno: e):
      assert(e != ENOENT)

      if let p = path {
        let error = py.newOSError(errno: errno, path: p)
        return .error(error)
      }

      let error = py.newOSError(errno: errno)
      return .error(error)
    }
  }

  // MARK: - Read dir

  internal func readdir(_ py: Py, fd: Int32) -> PyFileSystemReaddirResult {
    let result = self.fileSystem.readdir(fd: fd)
    return self.handleReaddirResult(py, result: result, path: nil)
  }

  internal func readdir(_ py: Py, path: Path) -> PyFileSystemReaddirResult {
    let result = self.fileSystem.readdir(path: path)
    return self.handleReaddirResult(py, result: result, path: path)
  }

  private func handleReaddirResult(_ py: Py,
                                   result: FileSystem.ReaddirResult,
                                   path: Path?) -> PyFileSystemReaddirResult {
    switch result {
    case let .value(readdir):
      return .entries(readdir)

    case .enoent:
      return .enoent

    case let .error(errno: e):
      assert(e != ENOENT)

      if let p = path {
        let error = py.newOSError(errno: errno, path: p)
        return .error(error)
      }

      let error = py.newOSError(errno: errno)
      return .error(error)
    }
  }

  // MARK: - Basename

  internal func basename(path: Path) -> Filename {
    return self.fileSystem.basename(path: path)
  }

  // MARK: - Dirname

  internal func dirname(path: Path) -> FileSystem.DirnameResult {
    return self.fileSystem.dirname(path: path)
  }

  // MARK: - Join

  internal func join(path: Path, element: PathPartConvertible) -> Path {
    return self.fileSystem.join(path: path, element: element)
  }

  internal func join<T: PathPartConvertible>(path: Path, elements: T...) -> Path {
    return self.fileSystem.join(path: path, elements: elements)
  }

  internal func join<T: PathPartConvertible>(path: Path, elements: [T]) -> Path {
    return self.fileSystem.join(path: path, elements: elements)
  }
}
