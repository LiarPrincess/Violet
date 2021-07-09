import Foundation
import VioletCore

// swiftlint:disable nesting
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable file_length

// MARK: - Path

struct Path: Equatable, Comparable, CustomStringConvertible {

  /// Do not use unless you really have to!
  /// Let the `FileSystem` methods deal with it!
  let url: URL
  fileprivate let isDirectory: Bool?

  /// Do not use unless you really have to!
  /// Let the `FileSystem` methods deal with it!
  var string: String {
    return self.url.path
  }

  var description: String {
    return self.string
  }

  static func < (lhs: Path, rhs: Path) -> Bool {
    return lhs.string < rhs.string
  }
}

// MARK: - FileSystem

private let fm = FileManager.default

/// Wrapper around 'FileManager' and other file-system related things.
enum FileSystem { }

// MARK: - Root dir

extension FileSystem {

  static func getRepositoryRoot(marker: String = "Sources") -> Path {
    let fileUrl = URL(fileURLWithPath: #file)
    var currentDirUrl = fileUrl.deletingLastPathComponent()

    let depth = currentDirUrl.pathComponents.count
    for _ in 0..<depth {
      let currentPath = Path(url: currentDirUrl, isDirectory: true)
      let entries = Self.readdirOrTrap(path: currentPath)

      let hasMarker = entries.contains { $0.name == marker }
      if hasMarker {
        return currentPath
      }

      currentDirUrl.deleteLastPathComponent()
    }

    fatalError("Unable to find repository root using '\(marker)' as a marker")
  }
}

// MARK: - Join

extension FileSystem {

  static func join(path: Path, element: String) -> Path {
    var url = path.url
    url.appendPathComponent(element)
    return Path(url: url, isDirectory: nil)
  }

  static func join(path: Path, element: Path) -> Path {
    var url = path.url
    var isDirectory: Bool?

    switch element.isDirectory {
    case .some(let isDir):
      isDirectory = isDir
      url.appendPathComponent(element.string, isDirectory: isDir)
    case .none:
      url.appendPathComponent(element.string)
    }

    return Path(url: url, isDirectory: isDirectory)
  }
}

// MARK: - Dirname

extension FileSystem {

  static func dirname(path: Path) -> String {
    let url = path.url
    return url.lastPathComponent
  }
}

// MARK: - CWD

extension FileSystem {

  static func setCurrentWorkingDirectoryOrTrap(path: Path) {
    let result = fm.changeCurrentDirectoryPath(path.string)
    if !result {
      trap("Unable to set cwd to: '\(path)'")
    }
  }
}

// MARK: - Stat

extension FileSystem {

  struct Stat {
    enum Mode: Equatable {
      case directory
      case regularFile
      case other
    }

    let mode: Mode
  }

  static func stat(path: Path) -> Stat? {
    do {
      let attributes = try fm.attributesOfItem(atPath: path.string)

      let mode: Stat.Mode
      // swiftlint:disable:next force_cast
      let typeAttribute = attributes[FileAttributeKey.type] as! FileAttributeType
      switch typeAttribute {
      case FileAttributeType.typeDirectory: mode = .directory
      case FileAttributeType.typeRegular: mode = .regularFile
//      case FileAttributeType.typeSymbolicLink: break
//      case FileAttributeType.typeSocket: break
//      case FileAttributeType.typeCharacterSpecial: break
//      case FileAttributeType.typeBlockSpecial: break
//      case FileAttributeType.typeUnknown: break
      default: mode = .other
      }

      return Stat(mode: mode)
    } catch {
      return nil
    }
  }

  static func statOrTrap(path: Path) -> Stat {
    guard let result = Self.stat(path: path) else {
      trap("Unable to stat '\(path)'")
    }

    return result
  }
}

// MARK: - Readdir collection

/// Helper protocol to add `Collection` conformance for free.
protocol ReaddirCollection: Collection where Index == Int {
  var elements: [Element] { get set }
}

extension ReaddirCollection {

  var startIndex: Index {
    self.elements.startIndex
  }

  var endIndex: Index {
    self.elements.endIndex
  }

  subscript(index: Index) -> Element {
    self.elements[index]
  }

  func index(after index: Index) -> Index {
    self.elements.index(after: index)
  }

  mutating func sort<T: Comparable>(by key: KeyPath<Element, T>) {
    self.elements.sort { lhs, rhs in
      let lhsValue = lhs[keyPath: key]
      let rhsValue = rhs[keyPath: key]
      return lhsValue < rhsValue
    }
  }
}

// MARK: - Readdir

extension FileSystem {

  struct Readdir: ReaddirCollection {
    struct Element {
      let name: String
      let path: Path
    }

    var elements = [Element]()
  }

  /// `readdir()` returns a list containing the entries in the directory given by `path`.
  /// The list is in arbitrary order.
  static func readdir(path: Path) -> Readdir? {
    do {
      let entries = try fm.contentsOfDirectory(atPath: path.string)
      var result = [Readdir.Element]()

      for name in entries {
        let childUrl = path.url.appendingPathComponent(name)
        let childPath = Path(url: childUrl, isDirectory: nil)
        let element = Readdir.Element(name: name, path: childPath)
        result.append(element)
      }

      return Readdir(elements: result)
    } catch {
      return nil
    }
  }

  /// `listdir()` returns a list containing the entries in the directory given by `path`.
  /// The list is in arbitrary order.
  static func readdirOrTrap(path: Path) -> Readdir {
    guard let result = Self.readdir(path: path) else {
      trap("Unable to list contents of '\(path)'")
    }

    return result
  }
}

// MARK: - Readdir rec

extension FileSystem {

  struct ReaddirRec: ReaddirCollection {
    struct Element {
      let name: String
      let absolutePath: Path
      /// Path relative to the `path` given as an argument.
      let relativePath: Path
      let stat: Stat
    }

    var elements = [Element]()
  }

  enum ReaddirRecResult {
    case value(ReaddirRec)
    case unableToListContentsOf(Path)
  }

  /// Same as `readdir` but it will go into directories and list their items.
  /// The list is in arbitrary order.
  static func readdirRec(path: Path) -> ReaddirRecResult {
    var directoriesToScan = [path]
    var result = [ReaddirRec.Element]()

    while let dirPath = directoriesToScan.popLast() {
      guard let dirContent = Self.readdir(path: dirPath) else {
        return .unableToListContentsOf(dirPath)
      }

      for entry in dirContent {
        let stat = Self.statOrTrap(path: entry.path)
        let isDirectory = stat.mode == .directory

        // We know if 'entry' is directory or not because we have stat,
        // 'listdir' does not have this information.
        let absolutePath = Path(url: entry.path.url, isDirectory: isDirectory)

        let relativePath = Self.getRelativePath(dir: path,
                                                entry: entry,
                                                isDirectory: isDirectory)

        let element = ReaddirRec.Element(name: entry.name,
                                         absolutePath: absolutePath,
                                         relativePath: relativePath,
                                         stat: stat)

        result.append(element)

        if isDirectory {
          directoriesToScan.append(entry.path)
        }
      }
    }

    return .value(ReaddirRec(elements: result))
  }

  /// Same as `readdir` but it will go into directories and list their items.
  /// The list is in arbitrary order.
  static func readdirRecOrTrap(path: Path) -> ReaddirRec {
    switch Self.readdirRec(path: path) {
    case let .value(r):
      return r
    case let .unableToListContentsOf(p):
      trap("Unable to list contents of '\(p)'")
    }
  }

  private static func getRelativePath(dir: Path,
                                      entry: Readdir.Element,
                                      isDirectory: Bool) -> Path {
    let dirPath = dir.string
    let entryPath = entry.path.string

    var relativePathString = entryPath.replacingOccurrences(of: dirPath, with: "")
    if relativePathString.hasPrefix("/") {
      relativePathString = String(relativePathString.dropFirst())
    }

    guard let url = URL(string: relativePathString) else {
      fatalError("Unable to create relative path url: '\(relativePathString)'")
    }

    return Path(url: url, isDirectory: isDirectory)
  }
}
