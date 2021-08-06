import Foundation

// swiftlint:disable discouraged_optional_boolean

public struct Path: Equatable, Comparable, CustomStringConvertible {

  internal let string: String
  internal let isDirectory: Bool?

  public var description: String {
    return self.string
  }

  public init(string: String) {
    self.init(string: string, isDirectory: nil)
  }

  internal init(string: String, isDirectory: Bool?) {
    self.string = string
    self.isDirectory = isDirectory
  }

  public init(url: URL) {
    self.init(url: url, isDirectory: nil)
  }

  internal init(url: URL, isDirectory: Bool?) {
    let path = url.path
    self.init(string: path, isDirectory: isDirectory)
  }

  public static func < (lhs: Path, rhs: Path) -> Bool {
    return lhs.string < rhs.string
  }
}
