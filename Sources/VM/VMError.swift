import Objects
import Foundation

public enum VMError: Error, CustomStringConvertible {

  // MARK: - Importlib

  case importlibCheckInSysFailed(PyBaseException)
  case importlibNotFound(triedPaths: [URL])
  case importlibIsNotReadable(url: URL, encoding: String.Encoding)
  case importlibCreationFailed(PyBaseException)
  case importlibInstallError(PyBaseException)

  // MARK: - Importlib external

  case importlibExternalCheckInSysFailed(PyBaseException)
  case importlibExternalNotFound(triedPaths: [URL])
  case importlibExternalIsNotReadable(url: URL, encoding: String.Encoding)
  case importlibExternalCreationFailed(PyBaseException)
  case importlibExternalInstallError(PyBaseException)

  // MARK: - Script

  case scriptDoesNotExist(path: String)
  case scriptDirDoesNotContain__main__(dir: String)
  case scriptIsNotReadable(url: URL, encoding: String.Encoding)

  // MARK: - Description

  public var description: String {
    let importlib = "importlib"
    let importlibExternal = "importlib_external"

    switch self {
    case let .importlibCheckInSysFailed(e):
      return self.importlibCheckInSysFailed(module: importlib, e: e)
    case let .importlibNotFound(triedPaths):
      return self.importlibNotFoundDescription(module: importlib,
                                               triedPaths: triedPaths)
    case let .importlibIsNotReadable(url, encoding):
      return self.importlibIsNotReadableDescription(module: importlib,
                                                    url: url,
                                                    encoding: encoding)
    case let .importlibCreationFailed(e):
      return self.importlibCreationFailedDescription(module: importlib, e: e)
    case let .importlibInstallError(e):
      return self.importlibInstallErrorDescription(module: importlib, e: e)

    case let .importlibExternalCheckInSysFailed(e):
      return self.importlibCheckInSysFailed(module: importlibExternal, e: e)
    case let .importlibExternalNotFound(triedPaths):
      return self.importlibNotFoundDescription(module: importlibExternal,
                                               triedPaths: triedPaths)
    case let .importlibExternalIsNotReadable(url, encoding):
      return self.importlibIsNotReadableDescription(module: importlibExternal,
                                                    url: url,
                                                    encoding: encoding)
    case let .importlibExternalCreationFailed(e):
      return self.importlibCreationFailedDescription(module: importlibExternal, e: e)
    case let .importlibExternalInstallError(e):
      return self.importlibInstallErrorDescription(module: importlibExternal, e: e)

    case let .scriptDoesNotExist(path):
      return "Can't open file '\(path)': No such file or directory."
    case let .scriptDirDoesNotContain__main__(dir):
      return "Can't find '__main__' module in '\(dir)'."
    case let .scriptIsNotReadable(url, encoding):
      return "Can't open file '\(url.path)': " +
      "encoding \(encoding) isn’t applicable."
    }
  }

  private func importlibCheckInSysFailed(
    module: String,
    e: PyBaseException
  ) -> String {
    let details = e.message.map { ": '\($0)'." } ?? "."
    return "Error when checking if '\(module)' was already initialized\(details)"
  }

  private func importlibNotFoundDescription(
    module: String,
    triedPaths: [URL]
  ) -> String {
    let paths = triedPaths.map { $0.path }.joined(separator: ", ")
    return "'\(module)' not found, tried: \(paths)."
  }

  private func importlibIsNotReadableDescription(
    module: String,
    url: URL,
    encoding: String.Encoding
  ) -> String {
    return "Can't open '\(module)' file '\(url.path)': " +
    "encoding \(encoding) isn’t applicable."
  }

  private func importlibCreationFailedDescription(
    module: String,
    e: PyBaseException
  ) -> String {
    let details = e.message.map { ": '\($0)'." } ?? "."
    return "Can't create '\(module)' module\(details)."
  }

  private func importlibInstallErrorDescription(
    module: String,
    e: PyBaseException
  ) -> String {
    let details = e.message.map { ": '\($0)'." } ?? "."
    return "Can't install '\(module)' module\(details)."
  }
}
