import Foundation
import FileSystem
import VioletCore

// cSpell:ignore asdf

// MARK: - Stat

public enum PyFileSystemStatResult {
  /// Valid result
  case value(Stat)
  /// No such file or directory
  case enoent
  /// Ooops…
  case error(PyOSError)
}

// MARK: - Readdir

public enum PyFileSystemReaddirResult {
  /// List containing names of the entries
  case entries(Readdir)
  /// No such file or directory
  case enoent
  /// Ooops…
  case error(PyOSError)
}

// MARK: - PyFileSystem

/// Delegate for all of the file-related needs.
///
/// You can use dictionary-backed mock for tests.
///
/// Requires `AnyObject` to avoid cycle if the owner of `Py`
/// is also set as fileSystem.
public protocol PyFileSystemType: AnyObject {

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
  var currentWorkingDirectory: Path { get }

  // MARK: - Open

  /// Open file with given `fd`.
  func open(_ py: Py, fd: Int32, mode: FileMode) -> PyResultGen<PyFileDescriptorType>
  /// Open file at given `path`.
  func open(_ py: Py, path: Path, mode: FileMode) -> PyResultGen<PyFileDescriptorType>

  // MARK: - Stat

  /// Information about given file/dir.
  ///
  /// Always chase the link.
  func stat(_ py: Py, fd: Int32) -> PyFileSystemStatResult
  /// Information about given file/dir.
  ///
  /// Always chase the link.
  func stat(_ py: Py, path: Path) -> PyFileSystemStatResult

  // MARK: - Read dir

  /// List containing the names of the entries in the directory given by `fd`.
  func readdir(_ py: Py, fd: Int32) -> PyFileSystemReaddirResult
  /// List containing the names of the entries in the directory given by `path`.
  func readdir(_ py: Py, path: Path) -> PyFileSystemReaddirResult

  // MARK: - Read

  /// Read the whole file.
  ///
  /// Default implementation available.
  func read(_ py: Py, fd: Int32) -> PyResultGen<Data>
  /// Read the whole file.
  ///
  /// Default implementation available.
  func read(_ py: Py, path: Path) -> PyResultGen<Data>

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
  /// This doc was sponsored by Node (aka. shamelessly stolen).
  func basename(path: Path) -> Filename

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
  /// This doc was sponsored by Node (aka. shamelessly stolen).
  func dirname(path: Path) -> FileSystem.DirnameResult

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
  /// This doc was sponsored by Node (aka. shamelessly stolen).
  func join(path: Path, element: PathPartConvertible) -> Path
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
  /// This doc was sponsored by Node (aka. shamelessly stolen).
  func join<T: PathPartConvertible>(path: Path, elements: T...) -> Path
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
  /// This doc was sponsored by Node (aka. shamelessly stolen).
  func join<T: PathPartConvertible>(path: Path, elements: [T]) -> Path
}

// MARK: - Default implementations

extension PyFileSystemType {

  public func read(_ py: Py, fd: Int32) -> PyResultGen<Data> {
    switch self.open(py, fd: fd, mode: .read) {
    case let .value(fd):
      return self.readToEnd(py, fd: fd)
    case let .error(e):
      return .error(e)
    }
  }

  public func read(_ py: Py, path: Path) -> PyResultGen<Data> {
    switch self.open(py, path: path, mode: .read) {
    case let .value(fd):
      return self.readToEnd(py, fd: fd)
    case let .error(e):
      return .error(e)
    }
  }

  private func readToEnd(_ py: Py, fd: PyFileDescriptorType) -> PyResultGen<Data> {
    return fd.readToEnd(py)
  }
}
