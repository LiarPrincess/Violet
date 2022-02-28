// cSpell:ignore TPFLAGS STACKLESS

extension PyType {

  internal struct TypeFlags: CustomStringConvertible, ExpressibleByArrayLiteral {

    internal static let isHeapTypeFlag = TypeFlags(objectFlags: .custom0)
    internal static let isBaseTypeFlag = TypeFlags(objectFlags: .custom1)
    internal static let hasGCFlag = TypeFlags(objectFlags: .custom2)
    internal static let isAbstractFlag = TypeFlags(objectFlags: .custom3)
    internal static let hasFinalizeFlag = TypeFlags(objectFlags: .custom4)
    internal static let isDefaultFlag = TypeFlags(objectFlags: .custom5)

    internal static let isLongSubclassFlag = TypeFlags(objectFlags: .custom8)
    internal static let isListSubclassFlag = TypeFlags(objectFlags: .custom9)
    internal static let isTupleSubclassFlag = TypeFlags(objectFlags: .custom10)
    internal static let isBytesSubclassFlag = TypeFlags(objectFlags: .custom11)
    internal static let isUnicodeSubclassFlag = TypeFlags(objectFlags: .custom12)
    internal static let isDictSubclassFlag = TypeFlags(objectFlags: .custom13)
    internal static let isBaseExceptionSubclassFlag = TypeFlags(objectFlags: .custom14)
    internal static let isTypeSubclassFlag = TypeFlags(objectFlags: .custom15)

    internal static let instancesHave__dict__Flag = TypeFlags(objectFlags: .custom20)
    internal static let subclassInstancesHave__dict__Flag = TypeFlags(objectFlags: .custom21)

    internal private(set) var objectFlags: PyObjectHeader.Flags

    // MARK: - Init

    internal init() {
      self.objectFlags = PyObjectHeader.Flags()
    }

    internal init(objectFlags: PyObjectHeader.Flags) {
      self.objectFlags = objectFlags
    }

    internal init(arrayLiteral elements: PyType.TypeFlags...) {
      self = TypeFlags()

      for flag in elements {
        self.set(flag, to: true)
      }
    }

    // MARK: - Description

    public var description: String {
      var result = "["
      var isFirst = true

      func appendIfSet(_ flag: TypeFlags, name: String) {
        guard self.objectFlags.isSet(flag.objectFlags) else {
          return
        }

        if !isFirst {
          result += ", "
        }

        result.append(name)
        isFirst = false
      }

      appendIfSet(Self.isHeapTypeFlag, name: "isHeapType")
      appendIfSet(Self.isBaseTypeFlag, name: "isBaseType")
      appendIfSet(Self.hasGCFlag, name: "hasGC")
      appendIfSet(Self.isAbstractFlag, name: "isAbstract")
      appendIfSet(Self.hasFinalizeFlag, name: "hasFinalize")
      appendIfSet(Self.isDefaultFlag, name: "isDefault")
      appendIfSet(Self.isLongSubclassFlag, name: "isLongSubclass")
      appendIfSet(Self.isListSubclassFlag, name: "isListSubclass")
      appendIfSet(Self.isTupleSubclassFlag, name: "isTupleSubclass")
      appendIfSet(Self.isBytesSubclassFlag, name: "isBytesSubclass")
      appendIfSet(Self.isUnicodeSubclassFlag, name: "isUnicodeSubclass")
      appendIfSet(Self.isDictSubclassFlag, name: "isDictSubclass")
      appendIfSet(Self.isBaseExceptionSubclassFlag, name: "isBaseExceptionSubclass")
      appendIfSet(Self.isTypeSubclassFlag, name: "isTypeSubclass")
      appendIfSet(Self.instancesHave__dict__Flag, name: "instancesHave__dict__")
      appendIfSet(Self.subclassInstancesHave__dict__Flag,
                  name: "subclassInstancesHave__dict__")

      result.append("]")
      return result
    }

    // MARK: - General

    /// Set if the type object is dynamically allocated
    /// (for example by `class` statement).
    internal var isHeapType: Bool {
      get { return self.isSet(Self.isHeapTypeFlag) }
      set { self.set(Self.isHeapTypeFlag, to: newValue) }
    }

    /// Set if the type allows sub-classing.
    internal var isBaseType: Bool {
      get { return self.isSet(Self.isBaseTypeFlag) }
      set { self.set(Self.isBaseTypeFlag, to: newValue) }
    }

    /// Objects support garbage collection.
    ///
    /// This flag was taken from CPython and is not used in Violet.
    internal var hasGC: Bool {
      get { return self.isSet(Self.hasGCFlag) }
      set { self.set(Self.hasGCFlag, to: newValue) }
    }

    /// Type is abstract and cannot be instantiated
    ///
    /// This flag was taken from CPython and is not used in Violet..
    internal var isAbstract: Bool {
      get { return self.isSet(Self.isAbstractFlag) }
      set { self.set(Self.isAbstractFlag, to: newValue) }
    }

    /// Type structure has `tp_finalize` member (3.4)
    ///
    /// This flag was taken from CPython and is not used in Violet.
    internal var hasFinalize: Bool {
      get { return self.isSet(Self.hasFinalizeFlag) }
      set { self.set(Self.hasFinalizeFlag, to: newValue) }
    }

    /// ```c
    /// #define Py_TPFLAGS_DEFAULT  ( \
    ///     Py_TPFLAGS_HAVE_STACKLESS_EXTENSION | \
    ///     Py_TPFLAGS_HAVE_VERSION_TAG)
    /// ```
    ///
    /// This flag was taken from CPython and is not used in Violet.
    internal var isDefault: Bool {
      get { return self.isSet(Self.isDefaultFlag) }
      set { self.set(Self.isDefaultFlag, to: newValue) }
    }

      // MARK: - Is XXX

    /// This type is a `int` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isLongSubclass: Bool {
      get { return self.isSet(Self.isLongSubclassFlag) }
      set { self.set(Self.isLongSubclassFlag, to: newValue) }
    }

    /// This type is a `list` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isListSubclass: Bool {
      get { return self.isSet(Self.isListSubclassFlag) }
      set { self.set(Self.isListSubclassFlag, to: newValue) }
    }

    /// This type is a `tuple` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isTupleSubclass: Bool {
      get { return self.isSet(Self.isTupleSubclassFlag) }
      set { self.set(Self.isTupleSubclassFlag, to: newValue) }
    }

    /// This type is a `bytes` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isBytesSubclass: Bool {
      get { return self.isSet(Self.isBytesSubclassFlag) }
      set { self.set(Self.isBytesSubclassFlag, to: newValue) }
    }

    /// This type is a `str` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isUnicodeSubclass: Bool {
      get { return self.isSet(Self.isUnicodeSubclassFlag) }
      set { self.set(Self.isUnicodeSubclassFlag, to: newValue) }
    }

    /// This type is a `dict` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isDictSubclass: Bool {
      get { return self.isSet(Self.isDictSubclassFlag) }
      set { self.set(Self.isDictSubclassFlag, to: newValue) }
    }

    /// This type is a `baseException` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isBaseExceptionSubclass: Bool {
      get { return self.isSet(Self.isBaseExceptionSubclassFlag) }
      set { self.set(Self.isBaseExceptionSubclassFlag, to: newValue) }
    }

    /// This type is a `type` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isTypeSubclass: Bool {
      get { return self.isSet(Self.isTypeSubclassFlag) }
      set { self.set(Self.isTypeSubclassFlag, to: newValue) }
    }

    // MARK: - Violet

    /// (VIOLET ONLY) Flag used to denote that instances of this type have access
    /// to `__dict__`.
    internal var instancesHave__dict__: Bool {
      get { return self.isSet(Self.instancesHave__dict__Flag) }
      set { self.set(Self.instancesHave__dict__Flag, to: newValue) }
    }

    /// (VIOLET ONLY) Flag used to denote that instances of subclass of this type
    /// have access to `__dict__` (yeah… I know that sounds complicated).
    ///
    /// Normally most builtin types (like `int`, `float` etc.) do not have `__dict__`:
    /// ``` py
    /// >>> (1).__dict__
    /// Traceback (most recent call last):
    ///   File "<stdin>", line 1, in <module>
    /// AttributeError: 'int' object has no attribute '__dict__'
    /// ```
    ///
    /// But if we subclass them, then the `__dict__` becomes available:
    /// ```py
    /// >>> class MyInt(int): pass
    /// >>> MyInt().__dict__
    /// { }
    /// ```
    internal var subclassInstancesHave__dict__: Bool {
      get { return self.isSet(Self.subclassInstancesHave__dict__Flag) }
      set { self.set(Self.subclassInstancesHave__dict__Flag, to: newValue) }
    }

    // MARK: - Methods

    /// Is given flag set?
    private func isSet(_ flag: TypeFlags) -> Bool {
      let objectFlags = flag.objectFlags
      return self.objectFlags.isSet(objectFlags)
    }

    /// Append/remove given flag.
    internal mutating func set(_ flag: TypeFlags, to value: Bool) {
      let objectFlags = flag.objectFlags
      self.objectFlags.set(objectFlags, to: value)
    }
  }
}
