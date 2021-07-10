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

  // MARK: - Flags

  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// Some of the flags are the same on every object (for example `reprLock`).
  /// The rest (the ones starting with `custom`) depend on the object type
  /// (so basically, you can use `Flags` to store `Bool` properties).
  ///
  /// Btw. it does not implement 'OptionSet', its interface is a bit awkward.
  public struct Flags {

    private var rawValue: UInt32

    /// This flag is used to control infinite recursion
    /// in `repr`, `str`, `print` etc.
    ///
    /// It is used when container objects recursively contain themselves:
    /// ```py
    /// >>> l = [1]
    /// >>> l.append(l)
    /// >>> l
    /// [1, [...]]
    /// ```
    ///
    /// Use `PyObject.withReprLock()` to automate setting/resetting this flag.
    public static let reprLock = Flags(rawValue: 1 << 0)

    // Flags present on every 'PyObject'.
    // Not assigned (for now), but we expect garbage collection to use some of them.
//    public static let reserved1 = Flags(rawValue: 1 << 1)
//    public static let reserved2 = Flags(rawValue: 1 << 2)
//    public static let reserved3 = Flags(rawValue: 1 << 3)
//    public static let reserved4 = Flags(rawValue: 1 << 4)
//    public static let reserved5 = Flags(rawValue: 1 << 5)
//    public static let reserved6 = Flags(rawValue: 1 << 6)
//    public static let reserved7 = Flags(rawValue: 1 << 7)
//    public static let reserved8 = Flags(rawValue: 1 << 8)
//    public static let reserved9 = Flags(rawValue: 1 << 9)
//    public static let reserved10 = Flags(rawValue: 1 << 10)
//    public static let reserved11 = Flags(rawValue: 1 << 11)
//    public static let reserved12 = Flags(rawValue: 1 << 12)
//    public static let reserved13 = Flags(rawValue: 1 << 13)
//    public static let reserved14 = Flags(rawValue: 1 << 14)
//    public static let reserved15 = Flags(rawValue: 1 << 15)

    /// Flag `0` that can be used based on object type.
    public static let custom0 = Flags(rawValue: 1 << 16)
    /// Flag `1` that can be used based on object type.
    public static let custom1 = Flags(rawValue: 1 << 17)
    /// Flag `2` that can be used based on object type.
    public static let custom2 = Flags(rawValue: 1 << 18)
    /// Flag `3` that can be used based on object type.
    public static let custom3 = Flags(rawValue: 1 << 19)
    /// Flag `4` that can be used based on object type.
    public static let custom4 = Flags(rawValue: 1 << 20)
    /// Flag `5` that can be used based on object type.
    public static let custom5 = Flags(rawValue: 1 << 21)
    /// Flag `6` that can be used based on object type.
    public static let custom6 = Flags(rawValue: 1 << 22)
    /// Flag `7` that can be used based on object type.
    public static let custom7 = Flags(rawValue: 1 << 23)
    /// Flag `8` that can be used based on object type.
    public static let custom8 = Flags(rawValue: 1 << 24)
    /// Flag `9` that can be used based on object type.
    public static let custom9 = Flags(rawValue: 1 << 25)
    /// Flag `10` that can be used based on object type.
    public static let custom10 = Flags(rawValue: 1 << 26)
    /// Flag `11` that can be used based on object type.
    public static let custom11 = Flags(rawValue: 1 << 27)
    /// Flag `12` that can be used based on object type.
    public static let custom12 = Flags(rawValue: 1 << 28)
    /// Flag `13` that can be used based on object type.
    public static let custom13 = Flags(rawValue: 1 << 29)
    /// Flag `14` that can be used based on object type.
    public static let custom14 = Flags(rawValue: 1 << 30)
    /// Flag `15` that can be used based on object type.
    public static let custom15 = Flags(rawValue: 1 << 31)

    /// Is given flag set?
    public func isSet(_ flag: Flags) -> Bool {
      return (self.rawValue & flag.rawValue) == flag.rawValue
    }

    /// Append given flag.
    public mutating func set(_ flag: Flags) {
      self.rawValue = self.rawValue | flag.rawValue
    }

    /// Append/remove given flag.
    public mutating func set(_ flag: Flags, to value: Bool) {
      if value {
        self.set(flag)
      } else {
        self.unset(flag)
      }
    }

    /// Remove given flag.
    public mutating func unset(_ flag: Flags) {
      let flagNegated = ~flag.rawValue
      self.rawValue = self.rawValue & flagNegated
    }

    public init() {
      self.rawValue = 0
    }

    private init(rawValue: UInt32) {
      self.rawValue = rawValue
    }
  }

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

  // MARK: - Type predicates

  /// Is this `None`?
  public var isNone: Bool {
    return PyCast.isNone(self)
  }

  /// Helper to use when implementing binary operations.
  /// [docs](https://docs.python.org/3/library/constants.html#NotImplemented).
  public var isNotImplemented: Bool {
    return PyCast.isNotImplemented(self)
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
