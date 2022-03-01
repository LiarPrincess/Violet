// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

import Foundation
import BigInt
import VioletBytecode

public typealias PyHash = Int

public let Py = PyContext()

public struct PyContext {

  public var `true`: PyBool { fatalError() }
  public var `false`: PyBool { fatalError() }
  public var none: PyBool { fatalError() }
  public var ellipsis: PyBool { fatalError() }

  public func newInt(_ value: BigInt) -> PyInt { fatalError() }
  public func newFloat(_ value: Double) -> PyFloat { fatalError() }
  public func newComplex(real: Double, imag: Double) -> PyComplex { fatalError() }
  public func newString(_ s: String) -> PyString { fatalError() }
  public func newBytes(_ d: Data) -> PyBytes { fatalError() }
  public func newCode(code: CodeObject) -> PyString { fatalError() }
  public func newTuple(elements: [PyObject]) -> PyTuple { fatalError() }
  public func newDict() -> PyDict { fatalError() }

  public func intern(string: String) -> PyString { fatalError() }

  public func isEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return .value(false)
  }

  public enum Types {
    public static let objectMemoryLayout = PyType.MemoryLayout()
    public static let objectStaticMethods = PyType.StaticallyKnownNotOverriddenMethods()
    public static let typeMemoryLayout = PyType.MemoryLayout()
    public static let typeStaticMethods = PyType.StaticallyKnownNotOverriddenMethods()
  }
}
