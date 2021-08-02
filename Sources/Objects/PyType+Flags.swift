// cSpell:ignore TPFLAGS STACKLESS

private let isHeapTypeFlag = PyObject.Flags.custom0
private let isBaseTypeFlag = PyObject.Flags.custom1
private let hasGCFlag = PyObject.Flags.custom2
private let isAbstractFlag = PyObject.Flags.custom3
private let hasFinalizeFlag = PyObject.Flags.custom4
private let isDefaultFlag = PyObject.Flags.custom5

private let isLongSubclassFlag = PyObject.Flags.custom8
private let isListSubclassFlag = PyObject.Flags.custom9
private let isTupleSubclassFlag = PyObject.Flags.custom10
private let isBytesSubclassFlag = PyObject.Flags.custom11
private let isUnicodeSubclassFlag = PyObject.Flags.custom12
private let isDictSubclassFlag = PyObject.Flags.custom13
private let isBaseExceptionSubclassFlag = PyObject.Flags.custom14
private let isTypeSubclassFlag = PyObject.Flags.custom15

private let instancesHave__dict__Flag = PyObject.Flags.custom20
private let subclassInstancesHave__dict__Flag = PyObject.Flags.custom21

extension PyType {

  internal struct TypeFlags {

    internal var objectFlags: PyObject.Flags

    internal init(objectFlags: PyObject.Flags) {
      self.objectFlags = objectFlags
    }

    // MARK: - General

    /// Set if the type object is dynamically allocated
    /// (for example by `class` statement).
    internal var isHeapType: Bool {
      get { return self.objectFlags.isSet(isHeapTypeFlag) }
      set { self.objectFlags.set(isHeapTypeFlag, to: newValue) }
    }

    /// Set if the type allows sub-classing.
    internal var isBaseType: Bool {
      get { return self.objectFlags.isSet(isBaseTypeFlag) }
      set { self.objectFlags.set(isBaseTypeFlag, to: newValue) }
    }

    /// Objects support garbage collection.
    ///
    /// This flag was taken from CPython and is not used in Violet.
    internal var hasGC: Bool {
      get { return self.objectFlags.isSet(hasGCFlag) }
      set { self.objectFlags.set(hasGCFlag, to: newValue) }
    }

    /// Type is abstract and cannot be instantiated
    ///
    /// This flag was taken from CPython and is not used in Violet..
    internal var isAbstract: Bool {
      get { return self.objectFlags.isSet(isAbstractFlag) }
      set { self.objectFlags.set(isAbstractFlag, to: newValue) }
    }

    /// Type structure has `tp_finalize` member (3.4)
    ///
    /// This flag was taken from CPython and is not used in Violet.
    internal var hasFinalize: Bool {
      get { return self.objectFlags.isSet(hasFinalizeFlag) }
      set { self.objectFlags.set(hasFinalizeFlag, to: newValue) }
    }

    /// ```c
    /// #define Py_TPFLAGS_DEFAULT  ( \
    ///     Py_TPFLAGS_HAVE_STACKLESS_EXTENSION | \
    ///     Py_TPFLAGS_HAVE_VERSION_TAG)
    /// ```
    ///
    /// This flag was taken from CPython and is not used in Violet.
    internal var isDefault: Bool {
      get { return self.objectFlags.isSet(isDefaultFlag) }
      set { self.objectFlags.set(isDefaultFlag, to: newValue) }
    }

      // MARK: - Is XXX

    /// This type is a `int` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isLongSubclass: Bool {
      get { return self.objectFlags.isSet(isLongSubclassFlag) }
      set { self.objectFlags.set(isLongSubclassFlag, to: newValue) }
    }

    /// This type is a `list` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isListSubclass: Bool {
      get { return self.objectFlags.isSet(isListSubclassFlag) }
      set { self.objectFlags.set(isListSubclassFlag, to: newValue) }
    }

    /// This type is a `tuple` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isTupleSubclass: Bool {
      get { return self.objectFlags.isSet(isTupleSubclassFlag) }
      set { self.objectFlags.set(isTupleSubclassFlag, to: newValue) }
    }

    /// This type is a `bytes` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isBytesSubclass: Bool {
      get { return self.objectFlags.isSet(isBytesSubclassFlag) }
      set { self.objectFlags.set(isBytesSubclassFlag, to: newValue) }
    }

    /// This type is a `str` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isUnicodeSubclass: Bool {
      get { return self.objectFlags.isSet(isUnicodeSubclassFlag) }
      set { self.objectFlags.set(isUnicodeSubclassFlag, to: newValue) }
    }

    /// This type is a `dict` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isDictSubclass: Bool {
      get { return self.objectFlags.isSet(isDictSubclassFlag) }
      set { self.objectFlags.set(isDictSubclassFlag, to: newValue) }
    }

    /// This type is a `baseException` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isBaseExceptionSubclass: Bool {
      get { return self.objectFlags.isSet(isBaseExceptionSubclassFlag) }
      set { self.objectFlags.set(isBaseExceptionSubclassFlag, to: newValue) }
    }

    /// This type is a `type` subclass.
    ///
    /// It is used for fast path in `PyCast`.
    internal var isTypeSubclass: Bool {
      get { return self.objectFlags.isSet(isTypeSubclassFlag) }
      set { self.objectFlags.set(isTypeSubclassFlag, to: newValue) }
    }

    // MARK: - Violet

    /// (VIOLET ONLY) Flag used to denote that instances of this type have access
    /// to `__dict__`.
    internal var instancesHave__dict__: Bool {
      get { return self.objectFlags.isSet(instancesHave__dict__Flag) }
      set { self.objectFlags.set(instancesHave__dict__Flag, to: newValue) }
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
      get { return self.objectFlags.isSet(subclassInstancesHave__dict__Flag) }
      set { self.objectFlags.set(subclassInstancesHave__dict__Flag, to: newValue) }
    }
  }
}
