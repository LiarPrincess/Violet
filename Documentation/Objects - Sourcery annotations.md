# Sourcery annotations

We use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) to annotate Swift code that is exposed in Python.

- [Sourcery annotations](#sourcery-annotations)
  - [Annotations](#annotations)
    - [Types](#types)
    - [Methods](#methods)
    - [Properties](#properties)
  - [Generated code](#generated-code)
    - [BuiltinTypes.swift](#builtintypesswift)
    - [BuiltinErrorTypes.swift](#builtinerrortypesswift)
    - [PyCast.swift](#pycastswift)
    - [PyMemory.swift](#pymemoryswift)
    - [StaticMethodsForBuiltinTypes.swift](#staticmethodsforbuiltintypesswift)
    - [PyType+MemoryLayout.swift](#pytypememorylayoutswift)

## Annotations

### Types

Swift class representing Python type is marked with `pytype` annotation. Additional annotations can be used to set type flags.

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public class PyInt: PyObject {
  // …
}
```

### Methods

Swift method representing Python method is marked with one of the `pymethod`, `pystaticmethod` or `pyclassmethod` annotations:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public class PyInt: PyObject {

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    // …
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyIntNew(type: PyType,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyInt> {
    // …
  }
}
```

### Properties

Swift method representing Python property getter is marked with `pyproperty` annotation. Additional `setter = <method-name>` may be also added, `del` is not supported, because it is not used.

```Swift
// sourcery: pytype = type, isDefault, hasGC, isBaseType, typeSubclass
public class PyType: PyObject {

  // sourcery: pyproperty = __name__, setter = setName
  public func getName() -> PyString {
    // …
  }

  public func setName(_ value: PyObject?) -> PyResult<Void> {
    // …
  }
}
```

## Generated code

Let us assume the following `int` definition:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public class PyInt: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    int([x]) -> integer
    int(x, base=10) -> integer
    """

  public let value: BigInt

  // sourcery: pyproperty = real
  public func asReal() -> PyObject {
    // …
  }

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    // …
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyIntNew(type: PyType,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyInt> {
    // …
  }
}
```

Firstly we use `Generated/Data/types.stencil` to dump all of the annotated data to `Generated/Data/types.txt`. This is how `int` type looks like in this representation (1st column represents the type of the line):

```
############
# int
############

Type|int|PyInt|PyObject
Annotation|baseType
Annotation|default
Annotation|pytype
Annotation|longSubclass
Doc|doc
Field|value|BigInt
PyProperty|real|asReal||PyObject|
PyMethod|__add__|add|add(_ other: PyObject)|add(_:)|PyResult<PyObject>|
PyStaticMethod|__new__|pyIntNew|pyIntNew(type: PyType, args: [PyObject], kwargs: PyDict?)|pyIntNew(type:args:kwargs:)|PyResult<PyInt>|
```

`Generated/Data/types.txt` is parsed by `Generated/Data/types.py` and exposed as Python entities (see: `get_types() -> [TypeInfo]` function inside). This data is used in a Python code that is responsible for generating Swift code.

The rule is:
> For each generated `.swift` file there is `.py` file with the same name that generated it, for example: `BuiltinTypes.py` is responsible for generating `BuiltinTypes.swift`.

### BuiltinTypes.swift

Contains:
- All of the `PyTypes` for non-error types (as in: Swift objects representing most basic non-error Python types)
- Code responsible for filling `__dict__` of every one of those `PyTypes`

It looks more or less like this (example contains only `int` type, the real file is much… much… longer):

```Swift
public final class BuiltinTypes {

  public let int: PyType

  internal init() {
    self.int = PyType.initBuiltinType(
      name: "int",
      type: self.type,
      base: self.object,
      typeFlags: [.isBaseTypeFlag, .isDefaultFlag, .isLongSubclassFlag, .subclassInstancesHave__dict__Flag],
      staticMethods: StaticMethodsForBuiltinTypes.int, // described later
      layout: PyType.MemoryLayout.PyInt // described later
    )
  }

  internal func fill__dict__() {
    self.fillInt()
  }

  private func fillInt() {
    let type = self.int
    type.setBuiltinTypeDoc(PyInt.doc)

    self.insert(type: type, name: "real", value: PyProperty.wrap(doc: nil, get: PyInt.asReal, castSelf: Self.asInt))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyInt.pyIntNew(type:args:kwargs:)))

    self.insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyInt.add(_:), castSelf: Self.asInt))
  }

  private func insert(type: PyType, name: String, value: PyObject) {
    // Insert value to type '__dict__'…
  }
}
```

### BuiltinErrorTypes.swift

The same thing as `BuiltinTypes.swift`, but for error types.

### PyCast.swift

Helper type used to safely downcast Python objects to specific Swift type.

For example:
On the `VM` stack we hold `PyObject`, at some point we may want to convert it to `PyInt`.

File content:

```Swift
public enum PyCast {

  /// Is this object an instance of `int` (or its subclass)?
  public static func isInt(_ object: PyObject) -> Bool {
    // 'int' checks are so common that we have a special flag for it.
    let typeFlags = object.type.typeFlags
    return typeFlags.isLongSubclass
  }

  /// Is this object an instance of `int` (but not its subclass)?
  public static func isExactlyInt(_ object: PyObject) -> Bool {
    return PyCast.isExactlyInstance(object, of: Py.types.int)
  }

  /// Cast this object to `PyInt` if it is an `int` (or its subclass).
  public static func asInt(_ object: PyObject) -> PyInt? {
    return PyCast.isInt(object) ? forceCast(object) : nil
  }

  /// Cast this object to `PyInt` if it is an `int` (but not its subclass).
  public static func asExactlyInt(_ object: PyObject) -> PyInt? {
    return PyCast.isExactlyInt(object) ? forceCast(object) : nil
  }

  private static func isInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type.isSubtype(of: type)
  }

  private static func isExactlyInstance(_ object: PyObject, of type: PyType) -> Bool {
    return object.type === type
  }
}
```

Usage:

```Swift
if let int = PyCast.asInt(object) {
  things…
}
```

### PyMemory.swift

Helper type for allocating new object instances.

This is basically the same thing as `init` method on Swift `class`. The thing is that at some point we may change our object representation, so that it no longer uses the Swift classes. When that happens we would have to fix every place that calls one of those `inits`. To solve this we introduce an indirection layer, so that we only have to fix the methods inside this layer and not in the whole code base.

Please note that every call of `newXXX` method allocates a new Python object! It will not reuse existing instances or do any fancy checks.

```Swift
internal enum PyMemory {

  /// Allocate a new instance of `int` type.
  internal static func newInt(
    value: BigInt
  ) -> PyInt {
    return PyInt(
      value: value
    )
  }

  /// Allocate a new instance of `int` type.
  internal static func newInt(
    type: PyType,
    value: BigInt
  ) -> PyInt {
    return PyInt(
      type: type,
      value: value
    )
  }
}
```

### StaticMethodsForBuiltinTypes.swift

Static methods have their own separate documentation, here we will just look at the generated code:

```Swift
/// Static methods defined on builtin types.
internal enum StaticMethodsForBuiltinTypes {

  internal static var int: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyInt.repr)
    result.__str__ = .init(PyInt.str)
    result.__hash__ = .init(PyInt.hash)
    result.__eq__ = .init(PyInt.isEqual(_:))
    result.__add__ = .init(PyInt.add(_:))
    // And so on…
    return result
  }()
}
```

### PyType+MemoryLayout.swift

Memory layout is described in object representation documentation, here we will just look at the generated code:

```Swift
public class MemoryLayout {

  /// Layout of the parent type.
  private let base: MemoryLayout?

  private init() {
    self.base = nil
  }

  public init(base: MemoryLayout) {
    self.base = base
  }

  /// Fields:
  /// - `_type: PyType!`
  /// - `___dict__: PyDict?`
  /// - `flags: Flags`
  public static let PyObject = MemoryLayout()

  /// Fields:
  /// - `value: BigInt`
  public static let PyInt = MemoryLayout(base: MemoryLayout.PyObject)
}
```
