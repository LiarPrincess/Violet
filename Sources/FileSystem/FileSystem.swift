import Foundation
import VioletCore

// This code was based on:
// https://github.com/apple/swift-corelibs-foundation/blob/master/Sources/
// Foundation/FileManager.swift

#if os(Windows)
internal let pathSeparators: [Character] = ["\\", "/"]
#else
internal let pathSeparators: [Character] = ["/"]
#endif

// TODO: Try again if interrupted (while true)

/// Wrapper around 'FileManager' and other file-system related things.
public struct FileSystem {

  internal let fileManager: FileManagerType

  public static let `default` = FileSystem(fileManager: FileManager.default)

  internal init(fileManager: FileManagerType) {
    self.fileManager = fileManager
  }

  // MARK: - Root dir

  public enum RepositoryRootResult {
    case value(Path)
    case notFound
    case error(Path, errno: Int32)
  }

  /// Find the repository root going from this `FileSystem` module up  to
  /// directory containing provided `marker`.
  public func getRepositoryRoot(startingFrom: String = #file,
                                marker: String = "Sources") -> RepositoryRootResult {
    let filePath = Path(string: startingFrom)
    var childPath = filePath

    while true {
      let dirname = self.dirname(path: childPath)
      let path = dirname.path

      switch self.readdir(path: path) {
      case let .value(entries):
        let hasMarker = entries.contains { $0.string == marker }
        if hasMarker {
          return .value(path)
        }
      case .enoent:
        // Somebody deleted the dir while we were searching.
        // Treat it as if we arrived to top dir.
        // This is a weird case, but we don't want to bother our caller.
        return .notFound
      case .error(errno: let e):
        return .error(path, errno: e)
      }

      if dirname.isTop {
        return .notFound
      }

      // Go to parent directory
      childPath = path
    }
  }

  public func getRepositoryRootOrTrap(startingFrom: String = #file,
                                      marker: String = "Sources") -> Path {
    switch self.getRepositoryRoot(marker: marker) {
    case .value(let p):
      return p
    case .notFound:
      trap("Unable to find repository root using '\(marker)' as a marker")
    case let .error(p, errno: e):
      if let msg = String(errno: e) {
        trap("\(msg): \(p)")
      } else {
        trap("Unable to find repository root, (errno: \(e), for \(p).")
      }
    }
  }

  // MARK: - CWD

  public var currentWorkingDirectory: Path {
    let cwd = self.fileManager.currentDirectoryPath
    return Path(string: cwd)
  }

  public func setCurrentWorkingDirectoryOrTrap(path: Path) {
    let result = self.fileManager.changeCurrentDirectoryPath(path.string)
    if !result {
      trap("Unable to set cwd to: '\(path)'")
    }
  }

  // MARK: - Helpers

  /// `FileManager.fileSystemRepresentation` does not accept empty path.
  /// We will prevent that on the type level.
  ///
  /// Otherwise we would have 'to remember' to check this every time.
  /// And you know how it works when programmers have 'to remember' stuff…
  internal struct NonEmptyPath {

    internal let string: String

    internal init?(from path: Path) {
      switch NonEmptyPath(from: path.string) {
      case .some(let p): self = p
      case .none: return nil
      }
    }

    internal init?<S: StringProtocol>(from string: S) {
      if string.isEmpty {
        return nil
      }

      self.string = String(string)
    }
  }

  /// Important: memory will be deallocated after `body` finishes!
  ///
  /// If you want to use it later then use one of the
  /// `self.string(withFileSystemRepresentation:)` methods.
  /// Do not use `String(cString)`!
  internal func withFileSystemRepresentation<ResultType>(
    path: NonEmptyPath,
    body: (UnsafePointer<Int8>) -> ResultType
  ) -> ResultType {
    // This will copy the path, which is what we want since most of the methods
    // we are using may modify the argument.
    // (yes, even https://linux.die.net/man/3/basename is allowed to do this)
    let fsRep = self.fileManager.fileSystemRepresentation(withPath: path.string)
    let result = body(fsRep)
    fsRep.deallocate()
    return result
  }

  internal func withMutableFileSystemRepresentation<ResultType>(
    path: NonEmptyPath,
    body: (UnsafeMutablePointer<Int8>) -> ResultType
  ) -> ResultType {
    return self.withFileSystemRepresentation(path: path) { fsRep -> ResultType in
      let fsRepMut = UnsafeMutablePointer(mutating: fsRep)
      return body(fsRepMut)
    }
  }

  internal func string(withFileSystemRepresentation str: UnsafePointer<Int8>,
                       length len: Int) -> String {
    return self.fileManager.string(withFileSystemRepresentation: str, length: len)
  }

  internal func string(
    nullTerminatedWithFileSystemRepresentation str: UnsafePointer<Int8>
  ) -> String {
    let len = LibC.strlen(str: str)
    return self.string(withFileSystemRepresentation: str, length: len)
  }

  internal func isPathSeparator(char: Character) -> Bool {
    return pathSeparators.contains(char)
  }
}
