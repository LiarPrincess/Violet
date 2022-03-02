// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

import Foundation
import BigInt
import VioletBytecode

public typealias PyHash = Int

public struct Py {

  public var `true`: PyBool { fatalError() }
  public var `false`: PyBool { fatalError() }
  public var none: PyNone { fatalError() }
  public var ellipsis: PyEllipsis { fatalError() }
  public var notImplemented: PyNotImplemented { fatalError() }

  public let memory = PyMemory()
  public var types: Py.Types { fatalError() }
  public var errorTypes: Py.ErrorTypes { fatalError() }
  public var cast: Py.Cast { fatalError() }

  public func newBool(_ value: Bool) -> PyBool { fatalError() }
  public func newInt(_ value: Int) -> PyInt { fatalError() }
  public func newInt(_ value: UInt8) -> PyInt { fatalError() }
  public func newInt(_ value: BigInt) -> PyInt { fatalError() }
  public func newFloat(_ value: Double) -> PyFloat { fatalError() }
  public func newComplex(real: Double, imag: Double) -> PyComplex { fatalError() }
  public func newString(_ s: String) -> PyString { fatalError() }
  public func newBytes(_ d: Data) -> PyBytes { fatalError() }
  public func newCode(code: CodeObject) -> PyString { fatalError() }
  public func newTuple(elements: [PyObject]) -> PyTuple { fatalError() }
  public func newList(elements: [PyObject]) -> PyList { fatalError() }
  public func newDict() -> PyDict { fatalError() }

  public func intern(string: String) -> PyString { fatalError() }
  public func hashNotAvailable(_ o: PyObject) -> PyBaseException { fatalError() }

  public enum GetKeysResult {
    case value(PyObject)
    case error(PyBaseException)
    case missingMethod(PyBaseException)
  }

  public func getKeys(object: PyObject) -> GetKeysResult { fatalError() }

  public enum ForEachStep {
    /// Go to the next item.
    case goToNextElement
    /// Finish iteration.
    case finish
    /// Finish iteration with given error.
    case error(PyBaseException)
  }

  public typealias ForEachFn = (PyObject) -> ForEachStep

  public func forEach(iterable: PyObject, fn: ForEachFn) -> PyBaseException? {
    fatalError()
  }

  public func isEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return .value(false)
  }
}
