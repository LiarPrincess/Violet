import Objects

class PyFakeFileSystem: PyFileSystem {

  private let cwd: String

  init(cwd: String) {
    self.cwd = cwd
  }

  // MARK: - PyFileSystem

  var currentWorkingDirectory: String {
    return self.cwd
  }

  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    return .error(self.createOSError())
  }

  func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    return .error(self.createOSError())
  }

  func stat(fd: Int32) -> FileStatResult {
    return .error(self.createOSError())
  }

  func stat(path: String) -> FileStatResult {
    return .error(self.createOSError())
  }

  // MARK: - Helpers

  private func createOSError(fn: StaticString = #function) -> PyOSError {
    let msg = "'PyFakeFileSystem.\(fn)' is not implemented"
    return Py.newOSError(msg: msg)
  }
}
