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
  // - `typeType` has `typeType` type and is subclass of `objectType`
  // The only way to produce this result is to skip `self.type` during
  // init and then fill it later.
  // There is as special `init()` and `func setType(to type: PyType)`
  // to do exactly this.

  // swiftlint:disable:next implicitly_unwrapped_optional
  private var _type: PyType!
  /// Also known as `klass`, but we are using CPython naming convention.
  public var type: PyType {
    return self._type
  }

  internal var flags: PyObjectFlags = []

  public var typeName: String {
    return self.type.getName()
  }

  internal var context: PyContext {
    return self.type.context
  }

  internal var builtins: Builtins {
    return self.context.builtins
  }

  internal var hasher: Hasher {
    return self.context.hasher
  }

  /// Object address.
  ///
  /// It should be used only for error messages
  /// (it is there mainly for CPython programmers for debugging).
  internal var ptrString: String {
    return String(describing: Unmanaged.passUnretained(self).toOpaque())
  }

  // MARK: - Init

  /// Create new Python object.
  /// When in doubt use this ctor!
  internal init(type: PyType) {
    self._type = type
  }

  /// NEVER EVER use this ctor!
  /// This is a reserved for `objectType` and `typeType` to create mutual recursion.
  /// Use `init(type: PyType)` instead.
  internal init() {
    self._type = nil
  }

  /// NEVER EVER use this function!
  /// This is a reserved for `objectType` and `typeType` to create mutual recursion.
  internal func setType(to type: PyType) {
    assert(self._type == nil, "Type is already assigned!")
    self._type = type
  }

  // MARK: - Helpers

  /// Check if this object type is **exactly** given type.
  ///
  /// Use `hasSubtype(of:)` if you want to check for possible subtype.
  public func hasType(type: PyType) -> Bool {
    return self.type === type
  }

  /// Check if this object type is subtype of a given type.
  ///
  /// Use `hasType(type:)` if you want to check if the type is **exactly** type.
  public func hasSubtype(of type: PyType) -> Bool {
    return type.isType(of: self)
  }

  /// Helper to use when implementing binary operations.
  /// [docs](https://docs.python.org/3/library/constants.html#NotImplemented).
  internal var isNotImplemented: Bool {
    return self is PyNotImplemented
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

  // MARK: - GC

  /// Remove all of the references to other Python objects.
  internal func gcClean() {
    self._type = nil
  }
}

// MARK: - Function result convertible

// 'PyObject' can be returned from Python function!
extension PyObject: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return .value(self)
  }
}
