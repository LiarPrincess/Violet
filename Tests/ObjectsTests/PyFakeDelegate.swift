import Objects

class PyFakeDelegate: PyDelegate {

  var frame: PyFrame? {
    unreachable()
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
    unreachable()
  }
}
