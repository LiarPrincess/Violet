import Bytecode
import Objects

class PyFakeDelegate: PyDelegate {

  var frame: PyFrame? {
    assert(false)
    return nil
  }

  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    let e = Py.newSystemError(msg: "'\(#function)' should not be called")
    return .error(e)
  }

  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    let e = Py.newSystemError(msg: "'\(#function)' should not be called")
    return .error(e)
  }

  // swiftlint:disable:next function_parameter_count
  func eval(name: PyString?,
            qualname: PyString?,
            code: PyCode,

            args: [PyObject],
            kwargs: PyDict?,
            defaults: [PyObject],
            kwDefaults: PyDict?,

            globals: PyDict,
            locals: PyDict,
            closure: PyTuple?)  -> PyResult<PyObject> {
    let e = Py.newSystemError(msg: "'\(#function)' should not be called")
    return .error(e)
  }
}
