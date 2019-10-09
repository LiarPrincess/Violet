import Core

internal struct PyObjectFlags: OptionSet {
  let rawValue: UInt8

  /// This flag is used to control infinite recursion in `repr`, `str`, `print`
  /// etc.
  ///
  /// Container objects that may recursively contain themselves, e.g. builtin
  /// dictionaries and lists, should use `withReprLock()` to avoid infinite
  /// recursion.
  internal static let reprLock = PyObjectFlags(rawValue: 1 << 0)
}

public class PyObject {

  internal var flags: PyObjectFlags = []

  // swiftlint:disable:next implicitly_unwrapped_optional
  private let _type: PyType!
  internal var type: PyType {
    return self._type
  }

  // MARK: - Init

  /// NEVER EVER use this ctor! It is reserved for PyType!
  /// Use version with 'type: PyType' parameter.
  internal init() {
    self._type = nil
  }

  internal init(type: PyType) {
    self._type = type
  }

  // MARK: - Shared helpers

  internal var context: PyContext {
    return self.type.context
  }

  internal var types: PyContextTypes {
    return self.context.types
  }

  internal func int(_ value: BigInt) -> PyInt {
    return self.types.int.new(value)
  }

  internal func int(_ value: Int) -> PyInt {
    return self.types.int.new(value)
  }

  internal func bool(_ value: Bool) -> PyBool {
    return self.types.bool.new(value)
  }

  internal func float(_ value: Double) -> PyFloat {
    return self.types.float.new(value)
  }

  internal func complex(real: Double, imag: Double) -> PyComplex {
    return self.types.complex.new(real: real, imag: imag)
  }

  internal func tuple(_ elements: PyObject...) -> PyTuple {
    return self.types.tuple.new(elements)
  }

  internal func tuple(_ elements: [PyObject]) -> PyTuple {
    return self.types.tuple.new(elements)
  }

  internal func list(_ elements: PyObject...) -> PyList {
    return self.types.list.new(elements)
  }

  internal func list(_ elements: [PyObject]) -> PyList {
    return self.types.list.new(elements)
  }

  internal func range(stop: PyInt) -> PyResult<PyRange> {
    return self.types.range.new(stop: stop)
  }

  internal func range(start: PyInt, stop: PyInt, step: PyInt?) -> PyResult<PyRange> {
    return self.types.range.new(start: start, stop: stop, step: step)
  }

  // MARK: - Repr

  /// This flag is used to control infinite recursion in `repr`, `str`, `print`
  /// etc.
  internal var hasReprLock: Bool {
    return self.flags.contains(.reprLock)
  }

  /// Set flag that is used to control infinite recursion in `repr`, `str`,
  /// `print` etc.
  internal func withReprLock<T>(body: () -> T) -> T {
    self.flags.formUnion(.reprLock)
    defer { _ = self.flags.subtracting(.reprLock) }

    return body()
  }
}
