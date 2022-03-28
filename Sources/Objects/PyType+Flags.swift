// cSpell:ignore TPFLAGS STACKLESS

extension PyType {

  public struct Flags: CustomStringConvertible, ExpressibleByArrayLiteral {

    public static let isHeapTypeFlag = Flags(objectFlags: .custom0)
    public static let isBaseTypeFlag = Flags(objectFlags: .custom1)
    public static let hasGCFlag = Flags(objectFlags: .custom2)
    public static let isAbstractFlag = Flags(objectFlags: .custom3)
    public static let hasFinalizeFlag = Flags(objectFlags: .custom4)
    public static let isDefaultFlag = Flags(objectFlags: .custom5)

    public static let isLongSubclassFlag = Flags(objectFlags: .custom8)
    public static let isListSubclassFlag = Flags(objectFlags: .custom9)
    public static let isTupleSubclassFlag = Flags(objectFlags: .custom10)
    public static let isBytesSubclassFlag = Flags(objectFlags: .custom11)
    public static let isUnicodeSubclassFlag = Flags(objectFlags: .custom12)
    public static let isDictSubclassFlag = Flags(objectFlags: .custom13)
    public static let isBaseExceptionSubclassFlag = Flags(objectFlags: .custom14)
    public static let isTypeSubclassFlag = Flags(objectFlags: .custom15)

    public static let instancesHave__dict__Flag = Flags(objectFlags: .custom20)
    public static let subclassInstancesHave__dict__Flag = Flags(objectFlags: .custom21)

    internal private(set) var objectFlags: PyObject.Flags

    // MARK: - Init

    public init() {
      self.objectFlags = PyObject.Flags()
    }

    public init(objectFlags: PyObject.Flags) {
      self.objectFlags = objectFlags
    }

    public init(arrayLiteral elements: PyType.Flags...) {
      self = Flags()

      for flag in elements {
        self.set(flag, value: true)
      }
    }

    // MARK: - Description

    public var description: String {
      var result = "["
      var isFirst = true

      func appendIfSet(_ flag: Flags, name: String) {
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
    public var isHeapType: Bool {
      get { return self.isSet(Self.isHeapTypeFlag) }
      set { self.set(Self.isHeapTypeFlag, value: newValue) }
    }

    /// Set if the type allows sub-classing.
    public var isBaseType: Bool {
      get { return self.isSet(Self.isBaseTypeFlag) }
      set { self.set(Self.isBaseTypeFlag, value: newValue) }
    }

    /// Objects support garbage collection.
    ///
    /// This flag was taken from CPython and is not used in Violet.
    public var hasGC: Bool {
      get { return self.isSet(Self.hasGCFlag) }
      set { self.set(Self.hasGCFlag, value: newValue) }
    }

    /// Type is abstract and cannot be instantiated
    ///
    /// This flag was taken from CPython and is not used in Violet..
    public var isAbstract: Bool {
      get { return self.isSet(Self.isAbstractFlag) }
      set { self.set(Self.isAbstractFlag, value: newValue) }
    }

    /// Type structure has `tp_finalize` member (3.4)
    ///
    /// This flag was taken from CPython and is not used in Violet.
    public var hasFinalize: Bool {
      get { return self.isSet(Self.hasFinalizeFlag) }
      set { self.set(Self.hasFinalizeFlag, value: newValue) }
    }

    /// ```c
    /// #define Py_TPFLAGS_DEFAULT  ( \
    ///     Py_TPFLAGS_HAVE_STACKLESS_EXTENSION | \
    ///     Py_TPFLAGS_HAVE_VERSION_TAG)
    /// ```
    ///
    /// This flag was taken from CPython and is not used in Violet.
    public var isDefault: Bool {
      get { return self.isSet(Self.isDefaultFlag) }
      set { self.set(Self.isDefaultFlag, value: newValue) }
    }

      // MARK: - Is XXX subclass

    /// This type is a `int` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isLongSubclass: Bool {
      get { return self.isSet(Self.isLongSubclassFlag) }
      set { self.set(Self.isLongSubclassFlag, value: newValue) }
    }

    /// This type is a `list` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isListSubclass: Bool {
      get { return self.isSet(Self.isListSubclassFlag) }
      set { self.set(Self.isListSubclassFlag, value: newValue) }
    }

    /// This type is a `tuple` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isTupleSubclass: Bool {
      get { return self.isSet(Self.isTupleSubclassFlag) }
      set { self.set(Self.isTupleSubclassFlag, value: newValue) }
    }

    /// This type is a `bytes` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isBytesSubclass: Bool {
      get { return self.isSet(Self.isBytesSubclassFlag) }
      set { self.set(Self.isBytesSubclassFlag, value: newValue) }
    }

    /// This type is a `str` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isUnicodeSubclass: Bool {
      get { return self.isSet(Self.isUnicodeSubclassFlag) }
      set { self.set(Self.isUnicodeSubclassFlag, value: newValue) }
    }

    /// This type is a `dict` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isDictSubclass: Bool {
      get { return self.isSet(Self.isDictSubclassFlag) }
      set { self.set(Self.isDictSubclassFlag, value: newValue) }
    }

    /// This type is a `baseException` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isBaseExceptionSubclass: Bool {
      get { return self.isSet(Self.isBaseExceptionSubclassFlag) }
      set { self.set(Self.isBaseExceptionSubclassFlag, value: newValue) }
    }

    /// This type is a `type` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    public var isTypeSubclass: Bool {
      get { return self.isSet(Self.isTypeSubclassFlag) }
      set { self.set(Self.isTypeSubclassFlag, value: newValue) }
    }

    // MARK: - Violet

    /// (VIOLET ONLY) Flag used to denote that instances of this type have access
    /// to `__dict__`.
    public var instancesHave__dict__: Bool {
      get { return self.isSet(Self.instancesHave__dict__Flag) }
      set { self.set(Self.instancesHave__dict__Flag, value: newValue) }
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
    public var subclassInstancesHave__dict__: Bool {
      get { return self.isSet(Self.subclassInstancesHave__dict__Flag) }
      set { self.set(Self.subclassInstancesHave__dict__Flag, value: newValue) }
    }

    // MARK: - Methods

    /// Is given flag set?
    private func isSet(_ flag: Flags) -> Bool {
      let objectFlags = flag.objectFlags
      return self.objectFlags.isSet(objectFlags)
    }

    /// Append/remove given flag.
    internal mutating func set(_ flag: Flags, value: Bool) {
      let objectFlags = flag.objectFlags
      self.objectFlags.set(objectFlags, value: value)
    }
  }
}
