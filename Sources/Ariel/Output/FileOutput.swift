import FileSystem
import Foundation
import VioletCore

class FileOutput: Output {

  private let path: Path
  private let encoding: String.Encoding
  private var fileHandle: FileHandle?

  init(path: Path, encoding: String.Encoding) {
    self.path = path
    self.encoding = encoding
  }

  func write(_ string: String) {
    guard let data = string.data(using: self.encoding) else {
      trap("Unable to encode '\(string)' using \(self.encoding).")
    }

    let fileHandle = self.getFileHandle()
    fileHandle.write(data)
  }

  private func getFileHandle() -> FileHandle {
    if let fh = self.fileHandle {
      return fh
    }

    let dir = fileSystem.dirname(path: self.path)
    switch fileSystem.mkdirpOrTrap(path: dir.path) {
    case .ok:
      printVerbose("Created '\(dir)'")
    case .eexist:
      break
    }

    let path = self.path.string
    if let fh = FileHandle(forWritingAtPath: path) {
      self.fileHandle = fh
      return fh
    }

    trap("Unable to open '\(path)' for writing.")
  }

  func close() {
    self.fileHandle?.closeFile()
  }
}
