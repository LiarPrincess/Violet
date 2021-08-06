import Foundation

public struct Path: Equatable, Comparable, CustomStringConvertible {

  internal let string: String

  public var description: String {
    return self.string
  }

  public init(string: String) {
    self.string = string
  }

  public init(url: URL) {
    let string = url.path
    self.init(string: string)
  }

  // We want to implement this manually to be able to put breakpoint inside.
  public static func == (lhs: Path, rhs: Path) -> Bool {
    return lhs.string == rhs.string
  }

  public static func < (lhs: Path, rhs: Path) -> Bool {
    return lhs.string < rhs.string
  }
}
