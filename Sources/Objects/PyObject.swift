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

  internal var context: PyContext {
    return self.type.context
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
