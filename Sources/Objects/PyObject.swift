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

  // MARK: - Type field

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

  /// Name of the type (mostly for convenience when creating error messages).
  public final var typeName: String {
    return self.type.getNameString()
  }

  // MARK: - __dict__ field

  // Note 3x '_' prefix!
  private var ___dict__: PyDict?

  /// Internal dictionary of attributes for the specific instance.
  ///
  /// We will reserve space for `PyDict` reference on EVERY object, even though
  /// not all of them can actually use it:
  /// ``` py
  /// >>> (1).__dict__
  /// Traceback (most recent call last):
  ///   File "<stdin>", line 1, in <module>
  /// AttributeError: 'int' object has no attribute '__dict__'
  /// ```
  ///
  /// Whether the object has access to `__dict__` or not is controlled by
  /// `has__dict__` flag.
  ///
  /// Alternative approach:
  /// For every type that can access `__dict__` create a Swift subclass that adds
  /// this property (+ some runtime magic). We actually did that (at some point),
  /// but it relied too much on Swift runtime, so we moved to current approach.
  ///
  /// - Important:
  /// Accessing `__dict__` on object that does not have it will trap!
  /// Use `Py.get__dict__` instead.
  public internal(set) final var __dict__: PyDict {
    get {
      self.assertHas__dict__()

      // Lazy property written by hand (without thread safety).
      if let dict = self.___dict__ {
        return dict
      }

      let dict = Py.newDict()
      self.___dict__ = dict
      return dict
    }
    set {
      self.assertHas__dict__()
      self.___dict__ = newValue
    }
  }

  internal final var has__dict__: Bool {
    return self.flags.isSet(.has__dict__)
  }

  private final func assertHas__dict__() {
    if !self.has__dict__ {
      trap("\(self.typeName) does not even '__dict__'.")
    }
  }

  // MARK: - Flags field

  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// It can also be used to store `Bool` properties (via `custom` flags).
  public var flags = Flags()

  // MARK: - Ptr

  /// Object address.
  ///
  /// It should be used only for:
  /// - `builtins.id` function
  /// - error messages (for debugging).
  internal final var ptr: UnsafeMutableRawPointer {
    return Unmanaged.passUnretained(self).toOpaque()
  }

  // MARK: - Init

  /// Create new Python object.
  /// When in doubt use this `init`!
  internal init(type: PyType) {
    self._type = type
    self.copyFlagsFromType()
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
  internal final func setType(to type: PyType) {
    assert(self._type == nil, "Type is already assigned!")
    self._type = type
    self.copyFlagsFromType()
  }

  private final func copyFlagsFromType() {
    let typeFlags = self.type.typeFlags

    let has__dict__ = typeFlags.instancesHave__dict__
    self.flags.set(.has__dict__, to: has__dict__)
  }

  // MARK: - Repr

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal final var hasReprLock: Bool {
    return self.flags.isSet(.reprLock)
  }

  /// Set, execute `body` and then unset `reprLock` flag
  /// (the one that is used to control recursion in `repr`, `str`, `print` etc).
  internal final func withReprLock<T>(body: () -> T) -> T {
    // We do not need 'defer' because 'body' is not throwing
    self.flags.set(.reprLock)
    let result = body()
    self.flags.unset(.reprLock)
    return result
  }

  // MARK: - Description

  public var description: String {
    let swiftType = String(describing: Swift.type(of: self))
    var result = "\(swiftType)(type: \(self.typeName), flags: \(self.flags)"

    let hasDescriptionLock = self.flags.isSet(.descriptionLock)
    if hasDescriptionLock {
      result.append(", RECURSIVE ENTRY)")
      return result
    }

    self.flags.set(.descriptionLock)
    defer { self.flags.unset(.descriptionLock) }

    let mirror = Mirror(reflecting: self)
    self.appendProperties(from: mirror, to: &result)

    result.append(")")
    return result
  }

  private func appendProperties(from mirror: Mirror,
                                to string: inout String,
                                propertyIndex: Int = 0) {
    var index = propertyIndex
    for child in mirror.children {
      let label = child.label ?? "property\(index)"

      let value = child.value
      var valueString = String(describing: value)

      // If the value is 'Optional' then want to print as if it was not.
      if valueString.starts(with: "Optional(") {
        // Remove 'Optional(' prefix and ')' suffix.
        let startIndex = valueString.index(valueString.startIndex, offsetBy: 9)
        let endIndex = valueString.index(valueString.endIndex, offsetBy: -1)
        let nonOptionalValue = valueString[startIndex..<endIndex]
        valueString = String(nonOptionalValue)
      }

      // If value is 'String' then add quotes.
      // This will not work on optional string, but whatever.
      if value is String {
        valueString = "'" + valueString + "'"
      }

      string.append(", \(label): \(valueString)")
      index += 1
    }

    if let superclassMirror = mirror.superclassMirror {
      // We already handled 'PyObject' by printing 'type: XXX'
      let isObject = superclassMirror.subjectType == PyObject.self
      if !isObject {
        self.appendProperties(from: superclassMirror,
                              to: &string,
                              propertyIndex: index)
      }
    }
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
