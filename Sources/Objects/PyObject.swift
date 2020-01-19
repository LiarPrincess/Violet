import Core

// MARK: - Flags

internal struct PyObjectFlags: OptionSet {

  let rawValue: UInt8

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  ///
  /// It is used when container objects recursively contain themselves:
  /// ```py
  /// >>> l = []
  /// >>> l.append(l)
  /// >>> l
  /// [[...]]
  /// ```
  ///
  /// Use `PyObject.withReprLock()` to automate setting/resetting this flag.
  internal static let reprLock = PyObjectFlags(rawValue: 1 << 0)
}

// MARK: - Object

/// Top of the `Python` type hierarchy.
///
/// It should be subclassed for every more-specific type.
///
/// Having single super-class simplifies a few things:
/// - we can store `PyObject` on the VM stack and it 'just works'.
/// - it has nice mental model: to implement type just add a Swift class.
/// - it makes reading Python docs more natural (meaning that you don't have
/// to go through translation step: description in docs -> our implementation).
public class PyObject: CustomStringConvertible {

  // `self_type` has to be implicitly unwrapped optional because:
  // - `objectType` has `typeType` type
  // - `typeType` has `typeType` type and is subclass of `objectType`
  // The only way to produce this result is to skip `self.type` during
  // `init` and then fill it later.
  // There is as special `init()` and `func setType(to type: PyType)`
  // to do exactly this.

  // swiftlint:disable:next implicitly_unwrapped_optional
  private var _type: PyType!
  /// Also known as `klass`, but we are using CPython naming convention.
  public final var type: PyType {
    // Not really sure if this property wrapper is needed (we could just expose
    // 'self._type' as implicitly unwrapped optional).
    // Public properties in Swift are exposed as a getter/setter anyway
    // (this is done so that we can change stored proeprty -> computed property
    // without breaking ABI - probably, I may be wrong here).
    // Anyway, it is 'final' so it should not be a problem (also most of its
    // users are inside this module, so it should optimize nicely).
    return self._type
  }

  internal var flags: PyObjectFlags = []

  /// Name of the type (mostly for convenience).
  public var typeName: String {
    return self.type.getName()
  }

  public var description: String {
    return "PyObject()"
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

  /// NEVER EVER use this ctor! It will not set `self.type`!
  ///
  /// This is a reserved for `objectType` and `typeType` to create mutual recursion.
  /// Use `init(type: PyType)` instead.
  internal init() {
    self._type = nil
  }

  /// NEVER EVER use this function!
  ///
  /// This is a reserved for `objectType` and `typeType` to create mutual recursion.
  internal func setType(to type: PyType) {
    assert(self._type == nil, "Type is already assigned!")
    self._type = type
  }

  // MARK: - Helpers

  /// Check if this object type has **exactly** the given type.
  ///
  /// Use `hasSubtype(of:)` if you want to include subtypes.
  public func hasType(type: PyType) -> Bool {
    return self.type === type
  }

  /// Check if this object type is subtype of the given type.
  ///
  /// Use `hasType(type:)` if you want to check if the type is **exactly** equal.
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

  /// Set, execute `body` and then unset `reprLock` flag
  /// (the one that is used to control recursion in `repr`, `str`, `print` etc).
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
// Yeah... I know, kind of hard to believe.
extension PyObject: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    return .value(self)
  }
}
