import Objects

class PyFakeDelegate: PyDelegate {

  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    let e = Py.newAssertionError(msg: "'\(#function)' should not be called")
    return .error(e)
  }

  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    let e = Py.newAssertionError(msg: "'\(#function)' should not be called")
    return .error(e)
  }
}
