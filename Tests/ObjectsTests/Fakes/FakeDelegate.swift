import Foundation
import VioletCore
import VioletObjects

class FakeDelegate: PyDelegate {

  var frame: PyFrame? {
    shouldNotBeCalled()
  }

  var currentlyHandledException: PyBaseException? {
    shouldNotBeCalled()
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
            closure: PyTuple?) -> PyResult<PyObject> {
    shouldNotBeCalled()
  }
}
