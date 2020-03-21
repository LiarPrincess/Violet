import Objects
import Foundation

public enum VMError: Error, CustomStringConvertible {

  // MARK: - Importlib

  case importlibAlreadyInitializedCheckFailed(PyBaseException)
  case importlibNotFound(triedPaths: [URL])
  case importlibIsNotReadable(url: URL, encoding: String.Encoding)
  case importlibCreationFailed(PyBaseException)

  // MARK: - Script

  case scriptDoesNotExist(path: String)
  case scriptDirDoesNotContain__main__(dir: String)
  case scriptIsNotReadable(url: URL, encoding: String.Encoding)

  // MARK: - Description

  public var description: String {
    switch self {
    case let .importlibAlreadyInitializedCheckFailed(e):
      let details = e.message.map { ": '\($0)'." } ?? "."
      return "Error when checking if 'importlib' was already initialized\(details)"
    case let .importlibNotFound(triedPaths):
      let paths = triedPaths.map { $0.path }.joined(separator: ", ")
      return "'importlib' not found, tried: \(paths)."
    case let .importlibIsNotReadable(url, encoding):
      return "Can't open 'importlib' file '\(url.path)': " +
             "encoding \(encoding) isn’t applicable."
    case let .importlibCreationFailed(e):
      let details = e.message.map { ": '\($0)'." } ?? "."
      return "Can't create 'importlib' module\(details)."

    case let .scriptDoesNotExist(path):
      return "Can't open file '\(path)': No such file or directory."
    case let .scriptDirDoesNotContain__main__(dir):
      return "Can't find '__main__' module in '\(dir)'."
    case let .scriptIsNotReadable(url, encoding):
      return "Can't open file '\(url.path)': " +
             "encoding \(encoding) isn’t applicable."
    }
  }
}
