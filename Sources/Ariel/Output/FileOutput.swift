import FileSystem
import Foundation
import VioletCore

private func createFileHandle(path: Path) -> FileHandle {
  // First we have to make sure that the fill path exists
  let dir = fileSystem.dirname(path: path)
  switch fileSystem.mkdirp(path: dir.path) {
  case .ok:
    printVerbose("Created '\(dir)'")
  case .eexist:
    break
  case let .parentRemovedAfterCreation(p):
    printErrorAndExit("Parent was removed after creating: \(p)")
  case let .error(p, errno: err):
    let msg = String(errno: err) ?? "Unable to mkdirp"
    printErrorAndExit("\(msg): \(p)")
  }

  // 'forWritingAtPath' will fail if the file does not exists
  if let fh = FileHandle(forWritingAtPath: path.string) {
    return fh
  }

  // Try to create this file
  switch fileSystem.creat(path: path) {
  case .fd(let fd):
    return FileHandle(fileDescriptor: fd)
  case .emptyPath:
    printErrorAndExit("Unable to open a file with empty path!")
  case .eexist:
    // File exists?
    printErrorAndExit("Unable to open '\(path)' for writing.")
  case .error(errno: let err):
    let msg = String(errno: err) ?? "Unable to stat"
    printErrorAndExit("\(msg): \(path)")
  }
}

class FileOutput: Output {

  private let name: String
  private let fileHandle: FileHandle
  private let encoding: String.Encoding

  init(path: Path, encoding: String.Encoding) {
    self.name = path.string
    self.fileHandle = createFileHandle(path: path)
    self.encoding = encoding
  }

  func write(_ string: String) {
    guard let data = string.data(using: self.encoding) else {
      printErrorAndExit("Unable to encode '\(string)' using \(self.encoding).")
    }

    self.fileHandle.write(data)
  }

  func close() {
    if #available(OSX 10.15, *) {
      do {
        try self.fileHandle.close()
      } catch {
        printErrorAndExit("Unable to close '\(name)': \(error)")
      }
    } else {
      self.fileHandle.closeFile()
    }
  }
}
