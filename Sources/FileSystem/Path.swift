import Foundation

public struct Path: Equatable, Comparable, Hashable,
                    CustomStringConvertible, PathPartConvertible {

  /// Most of the time you don't need this!
  /// Just use relevant method from `FileSystem`.
  ///
  /// But if you really need it, then it is here.
  public internal(set) var string: String

  public var description: String {
    return self.string
  }

  public var pathPart: String {
    return self.string
  }

  public init<S: StringProtocol>(string: S) {
    self.string = String(string)
  }

  public init(url: URL) {
    let string = url.path
    self.init(string: string)
  }

  // We want to implement this manually to be able to put breakpoint inside.
  public static func == (lhs: Path, rhs: Path) -> Bool {
    return lhs.string == rhs.string
  }

  public static func == (lhs: Path, rhs: String) -> Bool {
    return lhs.string == rhs
  }

  public static func == (lhs: String, rhs: Path) -> Bool {
    return lhs == rhs.string
  }

  public static func < (lhs: Path, rhs: Path) -> Bool {
    return lhs.string < rhs.string
  }
}

extension URL {

  public init(path: Path) {
    self = URL(fileURLWithPath: path.string)
  }

  public init(path: Path, isDirectory: Bool) {
    self = URL(fileURLWithPath: path.string, isDirectory: isDirectory)
  }
}
