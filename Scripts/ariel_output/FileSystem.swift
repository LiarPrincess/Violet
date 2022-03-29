============================
=== FileDescriptor.swift ===
============================

public class FileDescriptor: CustomStringConvertible {
  public enum ErrorType {}
  public enum Operation {}
  public struct Error: Swift.Error {
    public let errno: Int32
    public let operation: Operation
    public var type: ErrorType { get }
    public var str: String { get }
  }
  public var raw: Int32 { get }
  public var description: String { get }
  public init(fileDescriptor fd: Int32, closeOnDealloc closeopt: Bool)
  public convenience init(fileDescriptor fd: Int32)
  public init?(path: String, flags: Int32, createMode: Int)
  public func readLine() throws -> Data
  public func readToEnd() throws -> Data
  public func read(upToCount count: Int) throws -> Data
  public func write<T: DataProtocol>(contentsOf data: T) throws
  public func offset() throws -> UInt64
  @discardableResult
  public func seekToEnd() throws -> UInt64
  public func seek(toOffset offset: UInt64) throws
  public func truncate(atOffset offset: UInt64) throws
  public func synchronize() throws
  public func close() throws
}

extension FileDescriptor {
  public static let standardInput = FileDescriptor(
      fileDescriptor: STDIN_FILENO,
      closeOnDealloc: false
    )
  public static let standardOutput = FileDescriptor(
      fileDescriptor: STDOUT_FILENO,
      closeOnDealloc: false
    )
  public static let standardError = FileDescriptor(
      fileDescriptor: STDERR_FILENO,
      closeOnDealloc: false
    )
  public static let nullDevice = _nulldeviceFileDescriptor
}

extension FileDescriptor {
  public convenience init?(forReadingAtPath path: String)
  public convenience init?(forWritingAtPath path: String)
  public convenience init?(forUpdatingAtPath path: String)
  public static func _openFileDescriptorForURL(_ url: URL, flags: Int32, reading: Bool) throws -> Int32
  public convenience init(forReadingFrom url: URL) throws
  public convenience init(forWritingTo url: URL) throws
  public convenience init(forUpdating url: URL) throws
}

==============================
=== FileSystem+Creat.swift ===
==============================

extension FileSystem {
  public enum CreatResult {}
  public func creat(path: Path, mode: mode_t? = nil) -> CreatResult
}

=============================
=== FileSystem+Join.swift ===
=============================

extension FileSystem {
  public func join(path: Path, element: PathPartConvertible) -> Path
  public func join(path: Path, elements: PathPartConvertible...) -> Path
  public func join<S: Sequence>(path: Path, elements: S) -> Path where S.Element: PathPartConvertible
}

==============================
=== FileSystem+Mkdir.swift ===
==============================

extension FileSystem {
  public enum MkdirResult {}
  public func mkdir(path: Path, mode: mode_t? = nil) -> MkdirResult
  public func mkdir<S: StringProtocol>(string: S, mode: mode_t?) -> MkdirResult
  public enum MkdirpResult {}
  public func mkdirp(path: Path, mode: mode_t? = nil) -> MkdirpResult
  public enum MkdirpOrTrapResult {}
  public func mkdirpOrTrap(path: Path, mode: mode_t? = nil) -> MkdirpOrTrapResult
}

==============================
=== FileSystem+Names.swift ===
==============================

extension FileSystem {
  public func basename(path: Path) -> Filename
  public func basenameWithoutExt(filename: Filename) -> Filename
  public func basenameWithoutExt(path: Path) -> Filename
  public func extname(filename: Filename) -> String
  public func extname(path: Path) -> String
  public func addExt(filename: Filename, ext: String) -> Filename
  public func addExt(path: Path, ext: String) -> Path
  public struct DirnameResult {
    public let path: Path
    public let isTop: Bool
  }
  public func dirname(path: Path) -> DirnameResult
}

================================
=== FileSystem+Readdir.swift ===
================================

public struct Readdir: Collection {
  public var startIndex: Int { get }
  public var endIndex: Int { get }
  public init(entries: [Filename])
  public subscript(index: Int) -> Filename { get }
  public func index(after index: Int) -> Int
  public mutating func sort()
}

extension FileSystem {
  public enum ReaddirResult {}
  public func readdir(fd: Int32) -> ReaddirResult
  public func readdir(path: Path) -> ReaddirResult
  public func readdirOrTrap(path: Path) -> Readdir
}

public struct ReaddirRec: Collection {
  public struct Entry {
    public let name: Filename
    public let relativePath: Path
    public let stat: Stat
  }
  public var startIndex: Int { get }
  public var endIndex: Int { get }
  public init(entries: [Entry])
  public subscript(index: Int) -> Entry { get }
  public func index(after index: Int) -> Int
  public mutating func sort<T: Comparable>(by key: KeyPath<Entry, T>)
}

extension FileSystem {
  public enum ReaddirRecResult {}
  public func readdirRec(path: Path) -> ReaddirRecResult
  public func readdirRecOrTrap(path: Path) -> ReaddirRec
}

=============================
=== FileSystem+Stat.swift ===
=============================

public struct Stat {
  public enum EntryType: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
  public let st_mode: mode_t
  public let st_mtimespec: timespec
  public var type: EntryType { get }
  public init(st_mode: mode_t, st_mtimespec: timespec)
  public init(stat: Foundation.stat)
}

extension FileSystem {
  public enum StatResult {}
  public func stat(fd: Int32) -> StatResult
  public func stat(path: Path) -> StatResult
  public func statOrTrap(path: Path) -> Stat
  public func exists(path: Path) -> Bool
}

========================
=== FileSystem.swift ===
========================

public struct FileSystem {
  public static let `default` = FileSystem(fileManager: FileManager.default)
  public enum RepositoryRootResult {}
  public func getRepositoryRoot(startingFrom: String = #file, marker: String = "Sources") -> RepositoryRootResult
  public func getRepositoryRootOrTrap(startingFrom: String = #file, marker: String = "Sources") -> Path
  public var currentWorkingDirectory: Path { get }
  public func setCurrentWorkingDirectoryOrTrap(path: Path)
}

======================
=== Filename.swift ===
======================

public struct Filename: Equatable, Comparable, Hashable, CustomStringConvertible, PathPartConvertible {
  public internal(set) var string: String
  public var description: String { get }
  public var pathPart: String { get }
  public init<S: StringProtocol>(string: S)
  public static func ==(lhs: Filename, rhs: Filename) -> Bool
  public static func ==(lhs: Filename, rhs: String) -> Bool
  public static func ==(lhs: String, rhs: Filename) -> Bool
  public static func <(lhs: Filename, rhs: Filename) -> Bool
}

==================
=== Path.swift ===
==================

public struct Path: Equatable, Comparable, Hashable, CustomStringConvertible, PathPartConvertible {
  public internal(set) var string: String
  public var description: String { get }
  public var pathPart: String { get }
  public init<S: StringProtocol>(string: S)
  public init(url: URL)
  public static func ==(lhs: Path, rhs: Path) -> Bool
  public static func ==(lhs: Path, rhs: String) -> Bool
  public static func ==(lhs: String, rhs: Path) -> Bool
  public static func <(lhs: Path, rhs: Path) -> Bool
}

extension URL {
  public init(path: Path)
  public init(path: Path, isDirectory: Bool)
}

=================================
=== PathPartConvertible.swift ===
=================================

public protocol PathPartConvertible {}
extension String: PathPartConvertible {
  public var pathPart: String { get }
}

