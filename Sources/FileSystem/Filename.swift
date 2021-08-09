/// Name of the file.
///
/// Some functions (like `readdir`) return a list of entries. If we just used
/// `String` then the user would not know whether those entries represent
/// full paths of just names. We will solve this on type level.
public struct Filename: Equatable, Comparable, Hashable,
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

  // We want to implement this manually to be able to put breakpoint inside.
  public static func == (lhs: Filename, rhs: Filename) -> Bool {
    return lhs.string == rhs.string
  }

  public static func == (lhs: Filename, rhs: String) -> Bool {
    return lhs.string == rhs
  }

  public static func == (lhs: String, rhs: Filename) -> Bool {
    return lhs == rhs.string
  }

  public static func < (lhs: Filename, rhs: Filename) -> Bool {
    return lhs.string < rhs.string
  }
}
