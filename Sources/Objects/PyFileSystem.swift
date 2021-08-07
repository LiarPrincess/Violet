import Foundation
import FileSystem
import VioletCore

// swiftlint:disable type_name
// cSpell:ignore asdf

// MARK: - Stat

public enum PyFileSystem_StatResult {
  /// Valid result
  case value(Stat)
  /// No such file or directory
  case enoent
  /// Ooops…
  case error(PyOSError)
}

// MARK: - Listdir

public enum PyFileSystem_ListdirResult {
  /// List containing names of the entries
  case entries([String])
  /// No such file or directory
  case enoent
  /// Ooops…
  case error(PyOSError)
}

// MARK: - Dirname

public struct PyFileSystem_DirnameResult {

  public let path: String
  /// Is file system (or local) root.
  ///
  /// Calling `dirname` again will return the same result.
  public let isTop: Bool

  public init(path: String, isTop: Bool) {
    self.path = path
    self.isTop = isTop
  }
}

// MARK: - PyFileSystem

/// Delegate for all of the file-related needs.
///
/// You can use dictionary-backed mock for tests.
///
/// Requires `AnyObject` to avoid cycle if the owner of `Py`
/// is also set as fileSystem.
public protocol PyFileSystem: AnyObject {

  // MARK: - Cwd

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
  /// (Docs taken from `Foundation.FileManager.currentDirectoryPath`.)
  var currentWorkingDirectory: String { get }

  // MARK: - Open

  /// Open file with given `fd`.
  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Open file at given `path`.
  func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType>

  // MARK: - Stat

  /// Information about given file/dir.
  ///
  /// Always chase the link.
  func stat(fd: Int32) -> PyFileSystem_StatResult
  /// Information about given file/dir.
  ///
  /// Always chase the link.
  func stat(path: String) -> PyFileSystem_StatResult

  // MARK: - List dir

  /// List containing the names of the entries in the directory given by `fd`.
  func listdir(fd: Int32) -> PyFileSystem_ListdirResult
  /// List containing the names of the entries in the directory given by `path`.
  func listdir(path: String) -> PyFileSystem_ListdirResult

  // MARK: - Read

  /// Read the whole file.
  ///
  /// Default implementation available.
  func read(fd: Int32) -> PyResult<Data>
  /// Read the whole file.
  ///
  /// Default implementation available.
  func read(path: String) -> PyResult<Data>

  // MARK: - Basename

  /// Returns the last portion of a path, similar to the Unix `basename` command.
  /// Trailing directory separators are ignored.
  ///
  /// Example:
  /// ```
  /// basename('/foo/bar/baz/asdf/quux.html')
  /// Returns: 'quux.html'
  /// ```
  ///
  /// This doc was sponsored (aka. shamelessly stolen) by Node.
  func basename(path: String) -> String

  // MARK: - Dirname

  /// Returns the directory name of a path, similar to the Unix `dirname` command.
  /// Trailing directory separators are ignored.
  ///
  /// Example:
  /// ```
  /// dirname('/foo/bar/baz/asdf/quux')
  /// Returns: '/foo/bar/baz/asdf'
  /// ```
  ///
  /// This doc was sponsored (aka. shamelessly stolen) by Node.
  func dirname(path: String) -> PyFileSystem_DirnameResult

  // MARK: - Join

  /// Joins all given `path` segments together using the platform-specific
  /// separator as a delimiter.
  ///
  /// Zero-length path segments are ignored.
  ///
  /// Example:
  /// ```
  /// join('/foo', 'bar', 'baz/asdf');
  /// Returns: '/foo/bar/baz/asdf'
  /// ```
  ///
  /// This doc was sponsored (aka. shamelessly stolen) by Node.
  func join(paths: String...) -> String
}

// MARK: - Default implementations

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

  public var topDirname: String { return "." }
}
