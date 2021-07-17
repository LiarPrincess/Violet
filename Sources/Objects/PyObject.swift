import VioletCore

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

  // MARK: - Properties

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
    // Anyway, it is 'final' so it should not be a problem (also most of its
    // users are inside this module, so it should optimize nicely).
    return self._type
  }

  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// It can also be used to store `Bool` properties (via `custom` flags).
  public var flags = Flags()

  /// Name of the type (mostly for convenience).
  public var typeName: String {
    return self.type.getNameString()
  }

  public var description: String {
    return "PyObject(type: \(self.typeName))"
  }

  /// Object address.
  ///
  /// It should be used only for:
  /// - `builtins.id` function
  /// - error messages (for debugging).
  internal var ptr: UnsafeMutableRawPointer {
    return Unmanaged.passUnretained(self).toOpaque()
  }

  // MARK: - Init

  /// Create new Python object.
  /// When in doubt use this ctor!
  internal init(type: PyType) {
    self._type = type
  }

  /// NEVER EVER use this `init`! It will not set `self.type`!
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

  // MARK: - Repr

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal var hasReprLock: Bool {
    return self.flags.isSet(.reprLock)
  }

  /// Set, execute `body` and then unset `reprLock` flag
  /// (the one that is used to control recursion in `repr`, `str`, `print` etc).
  internal func withReprLock<T>(body: () -> T) -> T {
    // We do not need 'defer' because 'body' is not throwing
    self.flags.set(.reprLock)
    let result = body()
    self.flags.unset(.reprLock)
    return result
  }

  // MARK: - GC

  /// Remove all of the references to other Python objects.
  internal func gcClean() {
    self._type = nil
  }
}

// MARK: - Function result convertible

// 'PyObject' can be returned from Python function!
// Yeah… I know, kind of hard to believe.
extension PyObject: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    return .value(self)
  }
}
