import Foundation
import VioletCore

// This code was based on:
// https://github.com/apple/swift-corelibs-foundation/blob/master/Sources/
// Foundation/FileManager.swift

// MARK: - Readdir

public struct Readdir: Collection {

  private var entries: [Filename]

  public var startIndex: Int {
    self.entries.startIndex
  }

  public var endIndex: Int {
    return self.entries.endIndex
  }

  public init(entries: [Filename]) {
    self.entries = entries
  }

  public subscript(index: Int) -> Filename {
    return self.entries[index]
  }

  public func index(after index: Int) -> Int {
    return self.entries.index(after: index)
  }

  public mutating func sort() {
    self.entries.sort { $0 < $1 }
  }
}

extension FileSystem {

  public enum ReaddirResult {
    case value(Readdir)
    case enoent
    case error(errno: Int32)

    fileprivate init(err: Int32) {
      switch err {
      case ENOENT: self = .enoent
      default: self = .error(errno: err)
      }
    }
  }

  // MARK: - Readdir

  /// `readdir()` returns a list containing the entries in the directory given by `fd`.
  /// The list is in arbitrary order.
  public func readdir(fd: Int32) -> ReaddirResult {
    /// https://linux.die.net/man/3/fdopendir
    guard let dir = Foundation.fdopendir(fd) else {
      let err = errno
      errno = 0
      return ReaddirResult(err: err)
    }

    return self.readdirAndClose(dir: dir)
  }

  /// `readdir()` returns a list containing the entries in the directory given by `path`.
  /// The list is in arbitrary order.
  public func readdir(path: Path) -> ReaddirResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      return .enoent
    }

    return self.withFileSystemRepresentation(path: nonEmpty) { fsRep in
      // https://linux.die.net/man/3/opendir
      guard let dir = opendir(fsRep) else {
        let err = errno
        errno = 0
        return ReaddirResult(err: err)
      }

      return self.readdirAndClose(dir: dir)
    }
  }

  private func readdirAndClose(dir: UnsafeMutablePointer<DIR>) -> ReaddirResult {
    var result = [Filename]()

    var entry = dirent()
    var nilOnEnd: UnsafeMutablePointer<dirent>?

    // https://linux.die.net/man/3/readdir_r
    while true {
      let err = Foundation.readdir_r(dir, &entry, &nilOnEnd)
      guard err == 0 else {
        return ReaddirResult(err: err)
      }

      if nilOnEnd == nil {
        break
      }

      let length = Int(entry.d_namlen)
      let name = withUnsafePointer(to: &entry.d_name) { ptr -> String in
        let namePtr = UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self)
        return self.string(withFileSystemRepresentation: namePtr, length: length)
      }

      if name != "." && name != ".." {
        let filename = Filename(string: name)
        result.append(filename)
      }
    }

    // https://linux.die.net/man/3/closedir
    switch Foundation.closedir(dir) {
    case 0:
      return .value(Readdir(entries: result))
    case let err:
      // Should not happen, the only possible thing is:
      // EBADF - Invalid directory stream descriptor dirp.
      return ReaddirResult(err: err)
    }
  }

  /// `readdir()` returns a list containing the entries in the directory given by `path`.
  /// The list is in arbitrary order.
  public func readdirOrTrap(path: Path) -> Readdir {
    switch self.readdir(path: path) {
    case .value(let r):
      return r
    case .enoent:
      trap("Unable to readdir: No such file or directory: \(path)")
    case .error(let err):
      let msg = String(errno: err) ?? "Unknown error"
      trap("Unable to readdir: \(msg): \(path)")
    }
  }
}

// MARK: - Readdir rec

public struct ReaddirRec: Collection {

  public struct Entry {
    public let name: Filename
    /// Path relative to the `path` given as an argument.
    public let relativePath: Path
    public let stat: Stat
  }

  internal var entries = [Entry]()

  public var startIndex: Int {
    return self.entries.startIndex
  }

  public var endIndex: Int {
    return self.entries.endIndex
  }

  public init(entries: [Entry]) {
    self.entries = entries
  }

  public subscript(index: Int) -> Entry {
    return self.entries[index]
  }

  public func index(after index: Int) -> Int {
    return self.entries.index(after: index)
  }

  public mutating func sort<T: Comparable>(by key: KeyPath<Entry, T>) {
    self.entries.sort { lhs, rhs in
      let lhsValue = lhs[keyPath: key]
      let rhsValue = rhs[keyPath: key]
      return lhsValue < rhsValue
    }
  }
}

extension FileSystem {

  public enum ReaddirRecResult {
    case value(ReaddirRec)
    case unableToStat(Path, errno: Int32)
    case unableToListContents(Path, errno: Int32)
  }

  /// Same as `readdir` but it will go into directories and list their items.
  /// The list is in arbitrary order.
  public func readdirRec(path: Path) -> ReaddirRecResult {
    var directoriesToScan = [path]
    var result = [ReaddirRec.Element]()

    while let dirPath = directoriesToScan.popLast() {
      let dirContent: Readdir
      switch self.readdir(path: dirPath) {
      case .value(let r): dirContent = r
      case .enoent: continue // Entry was removed after previous 'readdir'
      case .error(errno: let e): return .unableToListContents(dirPath, errno: e)
      }

      for entry in dirContent {
        let entryPath = self.join(path: dirPath, element: entry)

        let stat: Stat
        switch self.stat(path: entryPath) {
        case .value(let s): stat = s
        case .enoent: continue // Entry was removed after 'readdir'
        case .error(errno: let e): return .unableToStat(entryPath, errno: e)
        }

        let relativePath = self.getRelativePath(dir: path, entry: entryPath)
        let element = ReaddirRec.Element(name: entry,
                                         relativePath: relativePath,
                                         stat: stat)

        result.append(element)

        switch stat.type {
        case .directory: directoriesToScan.append(entryPath)
        default: break
        }
      }
    }

    return .value(ReaddirRec(entries: result))
  }

  /// Same as `readdir` but it will go into directories and list their items.
  /// The list is in arbitrary order.
  public func readdirRecOrTrap(path: Path) -> ReaddirRec {
    switch self.readdirRec(path: path) {
    case let .value(r):
      return r
    case let .unableToStat(path, errno: e):
      let msg = String(errno: e) ?? "Unable to stat"
      trap("\(msg): \(path)")
    case let .unableToListContents(path, errno: e):
      let msg = String(errno: e) ?? "Unable to list contents of"
      trap("\(msg): \(path)")
    }
  }

  private func getRelativePath(dir: Path, entry: Path) -> Path {
    let dirString = dir.string
    let entryString = entry.string

    var relativeString = entryString.replacingOccurrences(of: dirString, with: "")
    if relativeString.hasPrefix("/") {
      relativeString = String(relativeString.dropFirst())
    }

    return Path(string: relativeString)
  }
}
