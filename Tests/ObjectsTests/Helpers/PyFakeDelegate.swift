import Bytecode
import Objects

class PyFakeDelegate: PyDelegate {

  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    let e = Py.newSystemError(msg: "'\(#function)' should not be called")
    return .error(e)
  }

  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    let e = Py.newSystemError(msg: "'\(#function)' should not be called")
    return .error(e)
  }

  // swiftlint:disable:next function_parameter_count
  func eval(name: String?,
            qualname: String?,
            code: CodeObject,
            args: [PyObject],
            kwArgs: Attributes?,
            defaults: [PyObject],
            kwDefaults: Attributes?,
            globals: Attributes,
            locals: Attributes) -> PyResult<PyObject> {
    let e = Py.newSystemError(msg: "'\(#function)' should not be called")
    return .error(e)
  }
}
