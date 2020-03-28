import Objects
import Foundation

#if canImport(Darwin)
import Darwin
private let _stat = Darwin.stat(_:_:)
#elseif canImport(Glibc)
import Glibc
private let _stat = Darwin.stat(_:_:)
#endif

internal class FileSystemImpl: PyFileSystem {

  private let fileManager: FileManager

  internal init(manager: FileManager) {
    self.fileManager = manager
  }

  // MARK: - Cwd

  internal var currentWorkingDirectory: String {
    return self.fileManager.currentDirectoryPath
  }

  // MARK: - Exists

  /// Check if the file at given path exists.
  internal func exists(path: String) -> Bool {
    var isDir = false
    return self.exists(path: path, isDirectory: &isDir)
  }

  /// Check if the file at given path exists.
  internal func exists(path: String, isDirectory: inout Bool) -> Bool {
    var isDirResult: ObjCBool = false
    let existsResult = self.fileManager.fileExists(atPath: path,
                                                   isDirectory: &isDirResult)

    isDirectory = isDirResult.boolValue
    return existsResult
  }

  // MARK: - Open

  internal func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    // When we get raw descriptor we assume that the user knows what they
    // are doing, which means that we can ignore 'mode'.
    let result = FileDescriptor(fileDescriptor: fd, closeOnDealloc: false)
    return .value(FileDescriptorAdapter(for: result))
  }

  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, ... )
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
      return .value(FileDescriptorAdapter(for: fd))
    }

    return .osError("unable to open '\(path)' (mode: \(mode))")
  }

  // MARK: - Stat

  internal func stat(fd: Int32) -> FileStatResult {
    var info = Foundation.stat()
    guard fstat(fd, &info) == 0 else {
      return self.handleStatError(path: nil)
    }

    let result = self.createStat(from: info)
    return .value(result)
  }

  internal func stat(path: String) -> FileStatResult {
    return self.withFileSystemRepresentation(path: path) { fsRep in
      var info = Foundation.stat()
      guard _stat(fsRep, &info) == 0 else {
        return self.handleStatError(path: path)
      }

      let result = self.createStat(from: info)
      return .value(result)
    }
  }

  private func createStat(from stat: stat) -> FileStat {
    return FileStat(
      st_mode: stat.st_mode,
      st_mtime: stat.st_mtimespec
    )
  }

  private func handleStatError(path: String?) -> FileStatResult {
    if errno == ENOENT {
      return .enoent
    }

    if let p = path {
      return .error(Py.newOSError(errno: errno, path: p))
    }

    return .error(Py.newOSError(errno: errno))
  }

  // MARK: - Helpers

  private func withFileSystemRepresentation<ResultType>(
    path: String,
    _ body: (UnsafePointer<Int8>) -> ResultType
  ) -> ResultType {
    let fsRep = self.fileManager.fileSystemRepresentation(withPath: path)
    defer { fsRep.deallocate() }
    return body(fsRep)
  }
}
