import Core
import Foundation

public enum FileStatResult {
  /// Valid result
  case value(FileStat)
  /// No such file or directory
  case enoent
  /// Ooopps...
  case error(PyOSError)
}

/// Delegate for all of the file-related needs.
///
/// You can use dictionary-backed mock for tests.
///
/// Requires `AnyObject` to avoid cycle if the owner of `Py`
/// is also set as fileSystem.
public protocol PyFileSystem: AnyObject {

  /// The path to the program’s current directory.
  ///
  /// The current directory path is the starting point for any relative paths
  /// you specify.
  ///
  /// For example:
  /// - current directory: /tmp
  /// - relative path: reports/info.txt
  /// - resulting full path: /tmp/reports/info.txt
  ///
  /// (Docs taken from `FileManager.currentDirectoryPath`.)
  var currentWorkingDirectory: String { get }

  /// Open file with given `fd`.
  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Open file at given `path`.
  func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType>

  /// Information about given file/dir.
  ///
  /// Always chase the link.
  func stat(fd: Int32) -> FileStatResult
  /// Information about given file/dir.
  ///
  /// Always chase the link.
  func stat(path: String) -> FileStatResult
}

extension PyFileSystem {

  public func read(fd: Int32) -> PyResult<Data> {
    let fd = self.open(fd: fd, mode: .read)
    return fd.flatMap(self.readToEnd(fd:))
  }

  public func read(path: String) -> PyResult<Data> {
    let fd = self.open(path: path, mode: .read)
    return fd.flatMap(self.readToEnd(fd:))
  }

  private func readToEnd(fd: FileDescriptorType) -> PyResult<Data> {
    return fd.readToEnd()
  }
}
