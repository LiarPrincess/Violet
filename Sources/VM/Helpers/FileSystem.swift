import Objects
import Foundation

#if canImport(Darwin)
import Darwin
private let _stat = Darwin.stat(_:_:)
#elseif canImport(Glibc)
import Glibc
private let _stat = Darwin.stat(_:_:)
#endif

internal struct FileSystem {

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

  internal func exists(path: String, isDirectory: inout Bool) -> Bool {
    var isDirResult: ObjCBool = false
    let existsResult = self.fileManager.fileExists(atPath: path,
                                                   isDirectory: &isDirResult)

    isDirectory = isDirResult.boolValue
    return existsResult
  }

  // MARK: - Read

  /// Read the whole file at specified `path`.
  internal func read(path: String) -> Data? {
    return self.fileManager.contents(atPath: path)
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

  /// static PyObject *
  /// os_stat_impl(PyObject *module, path_t *path, int dir_fd, int follow_symlinks)
  internal func stat(path: String) -> PyResult<FileStat> {
    do {
      let res = try self.withFileSystemRepresentation(path: path, self.stat(fsRep:))
      return .value(res)
    } catch let StatError.errno(errno) {
      if let e = Py.newOSError(errno: errno) {
        return .error(e)
      }

      let msg = "unknown stat error (errno: \(errno))"
      return .error(Py.newOSError(msg: msg))
    } catch {
      let msg = "unknown stat error"
      return .error(Py.newOSError(msg: msg))
    }
  }

  private enum StatError: Error {
    case errno(Int32)
  }

  private func stat(fsRep: UnsafePointer<Int8>) throws -> FileStat {
    // By default we will follow symlinks.

    var info = Foundation.stat()
    guard _stat(fsRep, &info) == 0 else {
      throw StatError.errno(errno)
    }

    let st_mode = info.st_mode

    let time = info.st_mtimespec
    let sec = time.tv_sec
    let nsec = time.tv_nsec
    let st_mtime = Double(sec) + 1e-9 * Double(nsec)

    return FileStat(st_mode: st_mode, st_mtime: st_mtime)
  }

  private func withFileSystemRepresentation<ResultType>(
    path: String,
    _ body: (UnsafePointer<Int8>) throws -> ResultType
  ) rethrows -> ResultType {
    let fsRep = self.fileManager.fileSystemRepresentation(withPath: path)
    defer { fsRep.deallocate() }
    return try body(fsRep)
  }
}
