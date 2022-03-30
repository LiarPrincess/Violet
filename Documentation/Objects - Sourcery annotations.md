<!-- cSpell:ignore typesgeneratedswift pyerrortypedefinitionsswift pycastswift -->

# Sourcery annotations

We use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) to annotate Swift code that is exposed in Python. Use `make gen` in the repository root to refresh the generated code.

- [Sourcery annotations](#sourcery-annotations)
  - [Annotations](#annotations)
    - [Types](#types)
    - [Type documentation](#type-documentation)
    - [Stored property](#stored-property)
    - [Methods](#methods)
    - [Properties](#properties)
  - [Generated code](#generated-code)
    - [Sourcery](#sourcery)
    - [Types+Generated.swift](#typesgeneratedswift)
    - [Py+\[Error\]TypeDefinitions.swift](#pyerrortypedefinitionsswift)
    - [PyCast.swift](#pycastswift)

## Annotations

### Types

- `pytype = PYTHON_TYPE_NAME` - Swift `struct` representing a Python type.
- `pybase = PYTHON_BASE_TYPE_NAME` - denotes a base type. If the `pybase` is not present then `object` is assumed (except for `object` which does not have a base class).

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyInt: PyObjectMixin { … }

// sourcery: pytype = bool, pybase = int, isDefault, isLongSubclass
public struct PyBool: PyObjectMixin { … }
```

Other flags:

- `isBaseType` - flag denotes a `class` that can be subclassed. Attempting to derive from non base type (like `bool`) should end in an error. This flag is also present in CPython.
- `instancesHave__dict__` - instances of this type have `__dict__`. Examples include `type`, `module`, `SimpleNamespace` etc:
  ```py
  >>> type.__dict__
  mappingproxy(…)

  >>> import builtins
  >>> builtins.__dict__
  {…}
  ```
- `subclassInstancesHave__dict__` - instances of this type do not have a `__dict__`, but if we subclass it then it will be present. Example for `int`:
  ```py
  >>> (1).__dict__
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  AttributeError: 'int' object has no attribute '__dict__'

  >>> class MyInt(int): pass
  >>> MyInt().__dict__
  {}
  ```

- `isXxxSubclass` - flags used by `PyCast` to avoid traversal of type hierarchy. They are also present in CPython.
  - `isLongSubclass`
  - `isListSubclass`
  - `isTupleSubclass`
  - `isBytesSubclass`
  - `isUnicodeSubclass`
  - `isDictSubclass`
  - `isBaseExceptionSubclass`
  - `isTypeSubclass`

  For example we can use `isLongSubclass` to quickly check if the object is an instance of `int`, `int subclass` or `bool`. Otherwise we would have to traverse the type hierarchy looking for `int`.

  ```Swift
  public struct PyCast {
    /// Is this object an instance of `int` (or its subclass)?
    public func isInt(_ object: PyObject) -> Bool {
      // 'int' checks are so common that we have a special flag for it.
      let typeFlags = object.type.typeFlags
      return typeFlags.isLongSubclass
    }
  }
  ```

CPython annotations not used in Violet:
- `isDefault`
- `hasFinalize`
- `hasGC`

### Type documentation

Static property with `pytypedoc` annotation denotes a type documentation.

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyBool: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    bool(x) -> bool

    Returns True when the argument x is true, False otherwise.
    The builtins True and False are the only two instances of the class bool.
    The class bool is a subclass of the class int, and cannot be subclassed.
    """
}
```

This will be transferred to Python:
```py
>>> bool.__doc__
'bool(x) -> bool\n\nReturns True when the argument x is true, False otherwise.\nThe builtins True and False are the only two instances of the class bool.\nThe class bool is a subclass of the class int, and cannot be subclassed.'
```

### Stored property

Each python object contains a single `ptr: RawPtr` stored property. The actual data is stored on the heap (this is where the `ptr` points to).

To store data on the heap write an computed property with a `storedProperty` annotation. This will generate an extension to your type with the pointer to a property value stored on the heap.

Example for `int` with an `value: BigInt` stored property:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public struct PyInt: PyObjectMixin {

  // sourcery: storedProperty
  public var value: BigInt { self.valuePtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }
}
```

Generated code (from `Sources/Objects/Generated/Types+Generated.swift`):

```Swift
extension PyInt {

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyInt` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() { … }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property: `PyInt.value`.
  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.valueOffset) }
}
```

### Methods

Swift `static` method can be marked with one of the following annotations:
- `pymethod` - Python method. It has at least 2 arguments:
  - `py: Py` - representing a Python context in which this method is run.
  - `zelf: PyObject` - `self` argument. Use `Self.downcast(py, zelf)` to downcast to a specific type (like `PyInt`).
- `pystaticmethod` - Python `staticmethod`.
- `pyclassmethod` - Python `classmethod`. It has at least 2 arguments:
  - `py: Py` - representing a Python context in which this method is run.
  - `type: PyObject` - type on which the method was called. Use `py.cast.asType(type)` to downcast to `PyType`.

All of those annotation can have an optional  `doc = SWIFT_STATIC_PROPERTY_WITH_DOCUMENTATION` annotation.

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public struct PyInt: PyObjectMixin {

  // sourcery: pymethod = __add__
  internal static func __add__(_ py: Py,
                               zelf: PyObject,
                               other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, fnName)
    }

    …
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    …
  }
}

// sourcery: pytype = type, isDefault, hasGC, isBaseType, isTypeSubclass
// sourcery: instancesHave__dict__
public struct PyType: PyObjectMixin {

  internal static let prepareDoc = """
    __prepare__() -> dict
    --

    used to create the namespace for the class statement
    """

  // sourcery: pyclassmethod = __prepare__, doc = prepareDoc
  internal static func __prepare__(_ py: Py,
                                   type: PyObject,
                                   args: [PyObject],
                                   kwargs: PyDict?) -> PyResult {
    …
  }
}
```

### Properties

Swift method representing Python property getter is marked with `pyproperty` annotation. Additional `setter` may be also added, `del` is not supported, because it is not used.

```Swift
// sourcery: pytype = type, isDefault, hasGC, isBaseType, typeSubclass
public class PyType: PyObject {

  // sourcery: pyproperty = __name__, setter = setName
  internal static func __name__(_ py: Py, zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__name__")
    }

    // …
  }

  internal static func __name__(_ py: Py, zelf: PyObject, value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__name__")
    }

    // …
  }
}
```

## Generated code

### Sourcery

Firstly we use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) with `./Sources/Objects/Generated/Sourcery/dump.stencil` template to dump all of the annotated data to `Sources/Objects/Generated/Sourcery/dump.txt`.

Let us assume the following `int` definition:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public struct PyInt: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    int([x]) -> integer
    int(x, base=10) -> integer
    """

  // sourcery: storedProperty
  public var value: BigInt { self.valuePtr.pointee }

  // sourcery: pyproperty = real
  internal static func real(_ py: Py, zelf: PyObject) -> PyResult {
    // …
  }

  // sourcery: pymethod = __add__
  internal static func __add__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    // …
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    // …
  }
}
```

This is how this type looks like in `dump.txt` (1st column represents the type of the line):

```
############
# int
############

Type|PyInt|int|
Annotation|baseType
Annotation|default
Annotation|pytype
Annotation|longSubclass
Doc|doc
SwiftStoredProperty|value|BigInt|0|
PyProperty|real||
PyMethod|__add__|__add__(_ py: Py, zelf: PyObject, other: PyObject)|PyResult|
PyStaticMethod|__new__|__new__(_ py: Py, type: PyType, args: [PyObject], kwargs: PyDict?)|PyResult|
```

`dump.txt` is parsed by `Sources/Objects/Generated/Sourcery/TypeInfo_get.py` and exposed as Python entities (see: `get_types() -> [TypeInfo]` function inside). This data is used in a Python code that is responsible for generating Swift code.

For each generated `.swift` file there is `.py` file with the same name that generated it. For example: `Types+Generated.py` is responsible for generating `Types+Generated.swift`.

### Types+Generated.swift

For each type this file contains an extension with:
- `static let pythonTypeName` - name of the type in Python
- `static let layout` - field offsets for memory layout
- `var xxxPtr` - pointer to each stored property
- `var xxx` - property from base class
- `func initializeBase(...)` - call base initializer (the same thing as `super.init()` in native Swift `class`)
- `static func deinitialize(ptr: RawPtr)` - to deinitialize this object before deletion (similar to `deinit` in native Swift `class`)
- `static func downcast(py: Py, object: PyObject) -> [TYPE_NAME]?` - cast from `PyObject` to `Self`
- `static func invalidZelfArgument<T>(py: Py, object: PyObject, fnName: String) -> PyResult` - error when method 1st argument has invalid type.
- `PyMemory.new[TYPE_NAME]` - to create new object of this type

Example:

```Swift
extension PyInt {

  /// Name of the type in Python.
  public static let pythonTypeName = "int"

  /// Arrangement of fields in memory.
  ///
  /// This type was automatically generated based on `PyInt` properties
  /// with `sourcery: storedProperty` annotation.
  internal struct Layout {
    internal let valueOffset: Int
    internal let size: Int
    internal let alignment: Int

    internal init() {
      assert(MemoryLayout<PyInt>.size == MemoryLayout<RawPtr>.size, "Only 'RawPtr' should be stored.")

      let layout = GenericLayout(
        initialOffset: PyObject.layout.size,
        initialAlignment: PyObject.layout.alignment,
        fields: [
          GenericLayout.Field(BigInt.self) // PyInt.value
        ]
      )

      assert(layout.offsets.count == 1)
      self.valueOffset = layout.offsets[0]
      self.size = layout.size
      self.alignment = layout.alignment
    }
  }

  /// Arrangement of fields in memory.
  internal static let layout = Layout()

  /// Property from base class: `PyObject.type`.
  internal var typePtr: Ptr<PyType> { Ptr(self.ptr, offset: PyObject.layout.typeOffset) }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__Ptr: Ptr<PyObject.Lazy__dict__> { Ptr(self.ptr, offset: PyObject.layout.__dict__Offset) }
  /// Property from base class: `PyObject.flags`.
  internal var flagsPtr: Ptr<PyObject.Flags> { Ptr(self.ptr, offset: PyObject.layout.flagsOffset) }
  /// Property: `PyInt.value`.
  internal var valuePtr: Ptr<BigInt> { Ptr(self.ptr, offset: Self.layout.valueOffset) }

  /// Property from base class: `PyObject.type`.
  internal var type: PyType { self.typePtr.pointee }
  /// Property from base class: `PyObject.__dict__`.
  internal var __dict__: PyObject.Lazy__dict__ {
    get { self.__dict__Ptr.pointee }
    nonmutating set { self.__dict__Ptr.pointee = newValue }
  }
  /// Property from base class: `PyObject.flags`.
  internal var flags: PyObject.Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  internal func initializeBase(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let base = PyObject(ptr: self.ptr)
    base.initialize(py, type: type, __dict__: __dict__)
  }

  internal static func deinitialize(_ py: Py, ptr: RawPtr) {
    let zelf = PyInt(ptr: ptr)
    zelf.beforeDeinitialize(py)

    // Call 'deinitialize' on all of our own properties.
    zelf.valuePtr.deinitialize()

    // Call 'deinitialize' on base type.
    // This will also call base type 'beforeDeinitialize'.
    PyObject.deinitialize(py, ptr: ptr)
  }

  internal static func downcast(_ py: Py, _ object: PyObject) -> PyInt? {
    return py.cast.asInt(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}

extension PyMemory {

  /// Allocate a new instance of `int` type.
  public func newInt(type: PyType, value: BigInt) -> PyInt {
    let typeLayout = PyInt.layout
    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)

    let result = PyInt(ptr: ptr)
    result.initialize(self.py, type: type, value: value)

    return result
  }
}
```

### Py+\[Error\]TypeDefinitions.swift

Both `Py+TypeDefinitions.swift` and `Py+ErrorTypeDefinitions.swift` are containers for `PyType` instances. They are also responsible for filling `__dict__` of every one of those `PyTypes`

```Swift

extension Py {

  public final class Types {

    public let bool: PyType
    public let builtinFunction: PyType
    public let builtinMethod: PyType
    public let bytearray: PyType
    public let bytearray_iterator: PyType
    public let bytes: PyType
    public let bytes_iterator: PyType
    public let callable_iterator: PyType
    // And so on…

    internal init(_ py: Py) {
      let memory = py.memory

      // 'self.type' and 'self.object' are generated first,
      // but we will skip them in this example.

      self.bool = memory.newType(
        type: self.type,
        name: "bool",
        qualname: "bool",
        flags: [.isDefaultFlag, .isLongSubclassFlag],
        base: self.int,
        bases: [self.int],
        mroWithoutSelf: [self.int, self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyBool.layout.size,
        staticMethods: Py.Types.boolStaticMethods,
        debugFn: PyBool.createDebugInfo(ptr:),
        deinitialize: PyBool.deinitialize(_:ptr:)
      )

      // Other type initializations…
    }

    internal func fill__dict__(_ py: Py) {
      self.fillBool(py)
      self.fillBuiltinFunction(py)
      self.fillBuiltinMethod(py)
      self.fillByteArray(py)
      self.fillByteArrayIterator(py)
      self.fillBytes(py)

      // And so on…
    }

    private func fillBool(_ py: Py) {
      let type = self.bool
      type.setBuiltinTypeDoc(py, value: PyBool.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBool.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBool.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyBool.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyBool.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __and__ = FunctionWrapper(name: "__and__", fn: PyBool.__and__(_:zelf:other:))

      // And so on…
    }

    // Read the 'PyStaticCall' documentation for explanation.
    internal static var boolStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.intStaticMethods.copy()
      result.__repr__ = .init(PyBool.__repr__(_:zelf:))
      result.__str__ = .init(PyBool.__str__(_:zelf:))
      result.__and__ = .init(PyBool.__and__(_:zelf:other:))
      result.__or__ = .init(PyBool.__or__(_:zelf:other:))
      result.__xor__ = .init(PyBool.__xor__(_:zelf:other:))
      result.__rand__ = .init(PyBool.__rand__(_:zelf:other:))
      result.__ror__ = .init(PyBool.__ror__(_:zelf:other:))
      result.__rxor__ = .init(PyBool.__rxor__(_:zelf:other:))
      return result
    }()
}
```

### PyCast.swift

Helper type used to safely downcast Python objects to specific Swift type.

For example:
On the `VM` stack we hold `PyObject`, at some point we may want to convert it to `PyInt`.

```Swift
public struct PyCast {

  private let types: Py.Types
  private let errorTypes: Py.ErrorTypes

  internal init(types: Py.Types, errorTypes: Py.ErrorTypes) {
    self.types = types
    self.errorTypes = errorTypes
  }

  private func isInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type.isSubtype(of: type)
  }

  private func isExactlyInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type === type
  }

  /// Is this object an instance of `int` (or its subclass)?
  public func isInt(_ object: PyObject) -> Bool {
    // 'int' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isLongSubclass
  }

  /// Is this object an instance of `int` (but not its subclass)?
  public func isExactlyInt(_ object: PyObject) -> Bool {
    return self.isExactlyInstance(object, of: self.types.int)
  }

  /// Cast this object to `PyInt` if it is an `int` (or its subclass).
  public func asInt(_ object: PyObject) -> PyInt? {
    return self.isInt(object) ? PyInt(ptr: object.ptr) : nil
  }

  /// Cast this object to `PyInt` if it is an `int` (but not its subclass).
  public func asExactlyInt(_ object: PyObject) -> PyInt? {
    return self.isExactlyInt(object) ? PyInt(ptr: object.ptr) : nil
  }
}
```

Usage:

```Swift
if let int = py.cast.asInt(object) {
  things…
}
```
