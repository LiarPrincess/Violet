import Objects
import Foundation

class PyFakeFileSystem: PyFileSystem {

  private let cwd: String

  init(cwd: String) {
    self.cwd = cwd
  }

  // MARK: - Cwd

  var currentWorkingDirectory: String {
    return self.cwd
  }

  // MARK: - Open

  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    return .error(self.createOSError())
  }

  func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    return .error(self.createOSError())
  }

  // MARK: - Stat

  func stat(fd: Int32) -> FileStatResult {
    return .error(self.createOSError())
  }

  func stat(path: String) -> FileStatResult {
    return .error(self.createOSError())
  }

  // MARK: - List dir

  func listDir(fd: Int32) -> ListDirResult {
    return .error(self.createOSError())
  }

  func listDir(path: String) -> ListDirResult {
    return .error(self.createOSError())
  }

  // MARK: - Read

  func read(fd: Int32) -> PyResult<Data> {
    return .error(self.createOSError())
  }

  func read(path: String) -> PyResult<Data> {
    return .error(self.createOSError())
  }

  // MARK: - Helpers

  private func createOSError(fn: StaticString = #function) -> PyOSError {
    let msg = "'PyFakeFileSystem.\(fn)' is not implemented"
    return Py.newOSError(msg: msg)
  }
}
