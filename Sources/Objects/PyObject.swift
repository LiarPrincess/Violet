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
  private var _type: PyType!
  internal var type: PyType {
    return self._type
  }

  internal var typeName: String {
    return self.type.getName()
  }

  internal var ptrString: String {
    // This may not work exactly as in CPython, but that does not matter.
    return String(describing: Unmanaged.passUnretained(self).toOpaque())
  }

  // MARK: - Init

  internal init(type: PyType) {
    self._type = type
  }

  // MARK: - BaseObject and Type

  /// NEVER EVER use this ctor!
  /// This is a reserved for `objectType` and `typeType`.
  /// Use version with 'type: PyType' parameter.
  internal init() {
    self._type = nil
  }

  /// NEVER EVER use this function!
  /// This is a reserved for `objectType` and `typeType`.
  internal func setType(to type: PyType) {
    assert(self._type == nil, "Type is already assigned!")
    self._type = type
  }

  // MARK: - Helpers

  internal var context: PyContext {
    return self.type.context
  }

  internal func int(_ value: BigInt) -> PyInt {
    return self.context._int(value)
  }

  internal func int(_ value: Int) -> PyInt {
    return self.context._int(value)
  }

  internal func bool(_ value: Bool) -> PyBool {
    return value ? self.context._true : self.context._false
  }

  internal func float(_ value: Double) -> PyFloat {
    return self.context._float(value)
  }

  internal func complex(real: Double, imag: Double) -> PyComplex {
    return self.context._complex(real: real, imag: imag)
  }

  internal func tuple(_ elements: PyObject...) -> PyTuple {
    return self.context._tuple(elements)
  }

  internal func tuple(_ elements: [PyObject]) -> PyTuple {
    return self.context._tuple(elements)
  }

  internal func list(_ elements: PyObject...) -> PyList {
    return self.context._list(elements)
  }

  internal func list(_ elements: [PyObject]) -> PyList {
    return self.context._list(elements)
  }

  internal func range(stop: PyInt) -> PyResult<PyRange> {
    return self.context._range(stop: stop)
  }

  internal func range(start: PyInt, stop: PyInt, step: PyInt?) -> PyResult<PyRange> {
    return self.context._range(start: start, stop: stop, step: step)
  }

  // MARK: - Class

  // sourcery: pymethod = __class_
  internal func getClass() -> PyType {
    return self.type
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
