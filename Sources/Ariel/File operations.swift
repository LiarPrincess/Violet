import Foundation

// MARK: - FileSystem

/// Wrapper around 'FileManager' and other file-system related things.
private enum FileSystem {

  private static let fileManager = FileManager.default

  typealias FileExists = (exists: Bool, isDirectory: Bool)

  fileprivate static func fileExists(path: String) -> FileExists {
    var isDirectory: ObjCBool = false
    let exists = Self.fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
    return (exists, isDirectory.boolValue)
  }

  fileprivate static func contentsOfDirectory(path: String) throws -> [String] {
    try Self.fileManager.contentsOfDirectory(atPath: path)
  }

  fileprivate static func getAbsolutePath(directoryPath: String, filename: String) -> String {
    let directoryUrl = URL(fileURLWithPath: directoryPath, isDirectory: true)
    let fileUrl = directoryUrl.appendingPathComponent(filename)
    return fileUrl.path
  }
}

// MARK: - Stat

struct Stat {

  let isDirectory: Bool
  var isFile: Bool { !self.isDirectory }

  /// Will return `nil` if the file does not exist.
  init?(path: String) {
    let (exists, isDirectory) = FileSystem.fileExists(path: path)

    if exists {
      self.isDirectory = isDirectory
      return
    }

    return nil
  }

  /// Will trap if the file does not exist.
  init(existingFilePath path: String) {
    guard let result = Stat(path: path) else {
      fatalError("File does not exists: '\(path)'")
    }

    self = result
  }
}

// MARK: - ListDir

/// `listdir()` returns a list containing the entries in the directory given by `path`.
/// The list is in arbitrary order.
struct ListDir: ListDirCollection {

  struct Element {
    let name: String
    let absolutePath: String
  }

  internal var elements = [Element]()

  init(path: String) throws {
    let pathContent = try FileSystem.contentsOfDirectory(path: path)

    for name in pathContent {
      let absolutePath = FileSystem.getAbsolutePath(directoryPath: path, filename: name)
      self.elements.append(Element(name: name, absolutePath: absolutePath))
    }
  }
}

/// Same as `ListDir` but it will go into directories and list their items.
/// The list is in arbitrary order.
struct ListDirRec: ListDirCollection {

  struct Element {
    let name: String
    let absolutePath: String
    /// Path relative to the `path` given as an argument.
    let relativePath: String
    let stat: Stat
  }

  internal var elements = [Element]()

  init(path: String) throws {
    var directoriesToScan = [path]

    while let dirPath = directoriesToScan.popLast() {
      let dirContent = try ListDir(path: dirPath)

      for entry in dirContent {
        let stat = Stat(existingFilePath: entry.absolutePath)

        var relativePath = entry.absolutePath.replacingOccurrences(of: path, with: "")
        if relativePath.hasPrefix("/") {
          relativePath = String(relativePath.dropFirst())
        }

        let element = Element(name: entry.name,
                              absolutePath: entry.absolutePath,
                              relativePath: relativePath,
                              stat: stat)

        self.elements.append(element)

        if stat.isDirectory {
          directoriesToScan.append(entry.absolutePath)
        }
      }
    }
  }
} // Sooo many brackets!

/// Helper protocol to add `Collection` conformance for free
protocol ListDirCollection: Collection where Index == Int {
  var elements: [Element] { get set }
}

extension ListDirCollection {

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
