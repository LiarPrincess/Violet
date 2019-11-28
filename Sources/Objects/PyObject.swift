import Core

// MARK: - Flags

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

// MARK: - Object

public class PyObject {

  // `self_type` has to be implicitly unwrapped optional because:
  // - `objectType` has `typeType` type
  // - `typeType` has `typeType` type and is sybclass of `objectType`
  // The only way to produce this result is to skip `self_type` during
  // init and then fill it later.
  // There is as special `init` and `func setType(to type: PyType)` methods
  // for this.

  // swiftlint:disable:next implicitly_unwrapped_optional
  private var _type: PyType!
  internal var type: PyType {
    return self._type
  }

  internal var flags: PyObjectFlags = []

  internal var typeName: String {
    return self.type.getName()
  }

  internal var context: PyContext {
    return self.type.context
  }

  internal var builtins: Builtins {
    return self.context.builtins
  }

  internal var hasher: PyHasher {
    return self.context.hasher
  }

  internal var ptrString: String {
    // This may not work exactly as in CPython, but that does not matter.
    return String(describing: Unmanaged.passUnretained(self).toOpaque())
  }

  // MARK: - Init

  /// Create new Python object.
  ///
  /// - Parameter type: Type of given `PyObject`.
  ///                   For example for `PyInt` it will be `builtins.int`
  internal init(type: PyType) {
    self._type = type
  }

  /// NEVER EVER use this ctor!
  /// This is a reserved for `objectType` and `typeType` to create mutual recursion.
  /// Use version with `type: PyType` parameter.
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

  /// Set, execute `body` and unset flag that is used to control
  /// infinite recursion in `repr`, `str`, `print` etc.
  internal func withReprLock<T>(body: () -> T) -> T {
    self.flags.formUnion(.reprLock)
    defer { self.flags.subtract(.reprLock) }

    return body()
  }
}
