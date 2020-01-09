import Foundation

public enum VMError: Error, Equatable, CustomStringConvertible {
  case scriptDoesNotExist(path: String)
  case scriptDirDoesNotContain__main__(dir: String)
  case scriptIsNotReadable(path: String, encoding: String.Encoding)

  public var description: String {
    switch self {
    case let .scriptDoesNotExist(path):
      return "Can't open file '\(path)': No such file or directory"
    case let .scriptDirDoesNotContain__main__(dir):
      return "Can't find '__main__' module in '\(dir)'"
    case let .scriptIsNotReadable(dir, encoding):
      return "Can't open file '\(dir)': encoding \(encoding) isn’t applicable"
    }
  }
}
