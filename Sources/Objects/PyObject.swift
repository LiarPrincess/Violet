import Core

internal struct PyObjectFlags: OptionSet {

  let rawValue: UInt8

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
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

  internal var context: PyContext {
    return self.type.context
  }

  internal var builtins: Builtins {
    return self.context.builtins
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
  /// This is a reserved for `objectType` and `typeType` to create mutual recursion.
  /// Use version with 'type: PyType' parameter.
  internal init() {
    self._type = nil
  }

  /// NEVER EVER use this function!
  /// This is a reserved for `objectType` and `typeType` to create mutual recursion.
  internal func setType(to type: PyType) {
    assert(self._type == nil, "Type is already assigned!")
    self._type = type
  }

  // MARK: - Repr

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal var hasReprLock: Bool {
    return self.flags.contains(.reprLock)
  }

  /// Set flag that is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal func enterReprLock() {
    self.flags.formUnion(.reprLock)
  }

  /// Unset flag that is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal func leaveReprLock() {
    _ = self.flags.subtracting(.reprLock)
  }

  /// Set flag that is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal func withReprLock<T>(body: () -> T) -> T {
    self.enterReprLock()
    defer { self.leaveReprLock() }

    return body()
  }
}
