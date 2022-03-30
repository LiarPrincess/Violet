<!-- cSpell:ignore memorylayouttoffsetof -->

# Objects

This file describes a Violet representation of a single Python object.

It is recommended to read the “Sourcery annotations” documentation first.

- [Objects](#objects)
  - [Requirements](#requirements)
  - [CPython](#cpython)
  - [Violet](#violet)
  - [Problems (and solutions)](#problems-and-solutions)
    - [`__dict__` presence](#__dict__-presence)
    - [Memory layout](#memory-layout)
    - [Type casting](#type-casting)
  - [Alternatives](#alternatives)
    - [`struct` + type punning](#struct--type-punning)
    - [`MemoryLayout<T>.offset(of: key)`](#memorylayouttoffsetof-key)
    - [Using `C`](#using-c)

## Requirements

- Support for *some form* of garbage collection

- Each object has to remember its type. This is sometimes referred as [`klass` pointer](http://openjdk.java.net/groups/hotspot/docs/HotSpotGlossary.html).

      ```py
      >>> o = 'Elsa'
      >>> type(o)
      <class 'str'>
      ```

- Objects have to be able to store inline value (payload). For example in `int` object we need to store integer value in addition to all of the standard object fields.

- `object` and `type` have an circular dependencies:
    - `object` type has `type` type and no base class

        ```py
        >>> object
        <class 'object'>
        >>> type(object)
        <class 'type'>
        >>> object.__bases__
        ()
        ```

    - `type` type has `type` type (self-reference) and `object` as a base class

        ```py
        >>> type
        <class 'type'>
        >>> type(type)
        <class 'type'>
        >>> type.__bases__
        (<class 'object'>,)
        ```

- (blank statement for any other requirement mentioned later in this file)

## CPython

This is how `int` type is declared in CPython:

- Objects -> object.h

```c
#define _PyObject_HEAD_EXTRA

/* Nothing is actually declared to be a PyObject, but every pointer to
* a Python object can be cast to a PyObject*.  This is inheritance built
* by hand.  Similarly every pointer to a variable-size Python object can,
* in addition, be cast to PyVarObject*.
*/
typedef struct _object {
  _PyObject_HEAD_EXTRA
  Py_ssize_t ob_refcnt;
  struct _typeobject *ob_type;
} PyObject;

typedef struct {
  PyObject ob_base;
  Py_ssize_t ob_size; /* Number of items in variable part */
} PyVarObject;

/* PyObject_VAR_HEAD defines the initial segment of all variable-size
* container objects.  These end with a declaration of an array with 1
* element, but enough space is malloc'ed so that the array actually
* has room for ob_size elements.  Note that ob_size is an element count,
* not necessarily a byte count.
*/
#define PyObject_VAR_HEAD      PyVarObject ob_base;
```

- Objects -> longobject.h

```c
typedef struct _longobject PyLongObject;
```

- Python -> longintrepr.h (`int` in Python is immutable, so the full value can be stored inline with [flexible array member](https://en.wikipedia.org/wiki/Flexible_array_member), we will talk about this later):

```c
struct _longobject {
  PyObject_VAR_HEAD
  digit ob_digit[1];
};
```

And this is how it is allocated (from: Objects -> longobject.h):

```c
PyLongObject *
_PyLong_New(Py_ssize_t size)
{
    PyLongObject *result;
    /* Number of bytes needed is: offsetof(PyLongObject, ob_digit) +
       sizeof(digit)*size.  Previous incarnations of this code used
       sizeof(PyVarObject) instead of the offsetof, but this risks being
       incorrect in the presence of padding between the PyVarObject header
       and the digits. */
    if (size > (Py_ssize_t)MAX_LONG_DIGITS) {
        PyErr_SetString(PyExc_OverflowError,
                        "too many digits in integer");
        return NULL;
    }
    result = PyObject_MALLOC(offsetof(PyLongObject, ob_digit) +
                             size*sizeof(digit));
    if (!result) {
        PyErr_NoMemory();
        return NULL;
    }
    return (PyLongObject*)PyObject_INIT_VAR(result, &PyLong_Type, size);
}
```

where:

```c
return (PyLongObject*)PyObject_INIT_VAR(result, &PyLong_Type, size);
```

expands to:

```c
Py_SIZE(result) = (size) // setting 'ob_size'
Py_TYPE(result) = (PyLong_Type) // setting 'ob_type'
_Py_NewReference((PyObject *)(result)) // reference count book-keeping
```

## Violet

In Swift we can't copy the CPython approach because the language does not guarantee that the memory layout will be the same as declaration order, there are also has some problems when we start nesting `structs` (more about this in “Alternatives” section).

Instead we will calculate offsets manually and by “manually” I mean we will use code generation (the `sourcery` annotations).

For example this is how `object` and `int` look like:

```Swift
// sourcery: pytype = object, isDefault, isBaseType
// sourcery: subclassInstancesHave__dict__
/// Top of the `Python` type hierarchy.
public struct PyObject: PyObjectMixin {

  // sourcery: storedProperty
  /// Also known as `klass`, but we are using CPython naming convention.
  public var type: PyType {
    return self.typePtr.pointee
  }

  // sourcery: storedProperty
  /// Things that `PyMemory` asked us to hold.
  internal var memoryInfo: PyMemory.ObjectHeader {
    get { return self.memoryInfoPtr.pointee }
    nonmutating set { self.memoryInfoPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// Internal dictionary of attributes for the specific instance.
  internal var __dict__: PyObject.Lazy__dict__ {
    return self.__dict__Ptr.pointee
  }

  // sourcery: storedProperty
  /// Various flags that describe the current state of the `PyObject`.
  public var flags: PyObject.Flags {
    get { return self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    self.typePtr.initialize(to: type)
    // Initialize other fields…
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}
}

// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyInt: PyObjectMixin {

  // sourcery: storedProperty
  // Do not add 'set' to 'self.value' - we cache most used ints!
  public var value: BigInt { self.valuePtr.pointee }

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, value: BigInt) {
    self.initializeBase(py, type: type)
    self.valuePtr.initialize(to: value)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}
}
```

Main things:
- each Python type is represented as a `struct` with `Py` prefix. For example `PyObject`, `PyType` and `PyBool`.
- each `struct` contains a single stored property `ptr: RawPtr` initalized in `init(ptr: RawPtr)`. This pointer points to heap allocated memory that stores the *actual stored properties*.
- *actual stored properties* are Swift computed properties with `sourcery: storedProperty` annotations. Code generation is used to transform those annotations into an actual memory layout giving us `Ptr` properties. For example `value: BigInt` -> `valuePtr: Ptr<BigInt>`, where `valuePtr` is a `self.ptr + layout.valueOffset`.
- each type has to have at least 1 `initialize` function: `func initialize(_ py: Py, other args…)`. This function is called just after memory allocation to initialize memory for an instance.
- each type has exactly 1 `beforeDeinitialize` function: `func beforeDeinitialize(_ py: Py)`. This function is called just before object is destroyed. This allows you to close file descriptors or deallocate any unmanaged memory.

Anyway, following code will be generated for `int` (`Sources/Objects/Generated/Types+Generated.swift`):

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

Ugh… that was long and complicated. But luckily it was generated for us.

## Problems (and solutions)

### `__dict__` presence

Lets look at the following Python code:

```py
# Setting 'elsa' property on `int`
>>> (1).elsa = 2
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'int' object has no attribute 'elsa'
>>> (1).__dict__
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'int' object has no attribute '__dict__'

# Setting 'elsa' property on `int` subclass
>>> class FrozenMovie(int): pass
>>> frozen = FrozenMovie(1)
>>> frozen.elsa = 2
>>> frozen.__dict__
{'elsa': 2}
```

As we can see:
- builtin `int` type does not have a `__dict__` and does not allow setting arbitrary properties
- `int` subclass has a `__dict__` and does allow setting arbitrary properties

How do we translate this into our object representation?

#### Solutions

- Dynamically calculate the instance size: if the object has `__dict__` then allocate more space.
- Put `__dict__` in every object. On every use, perform a runtime check to see if this object can access it. If the check fails we will pretend that the `__dict__` does not exists.

We went with option 2 — it is way simpler. It increases the size of each object by a single word, but whatever…

#### Flags on type

To manage `__dict__` access we will create 2 flags on type:
- `instancesHave__dict__` — used to denote that instances of this type have access to `__dict__`.
- `subclassInstancesHave__dict__` — used to denote that instances of subclass of this type have access to `__dict__`.

Going back to the `int` example:

```py
# Setting 'elsa' property on `int`
>>> (1).elsa = 2
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'int' object has no attribute 'elsa'

# Setting 'elsa' property on `int` subclass
>>> class FrozenMovie(int): pass
>>> frozen = FrozenMovie(1)
>>> frozen.elsa = 2
```

As we can see `int` does not have an access to `__dict__`, so we can’t use the `instancesHave__dict__` flag. But, the `FrozenMovie(int)` has, which means that in this case `subclassInstancesHave__dict__` should be used:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
// sourcery: subclassInstancesHave__dict__
/// All integers are implemented as “long” integer objects.
public struct PyInt: PyObjectMixin {
  // Things…
}
```

The whole magic happens on `PyObject`:

```Swift
// sourcery: pytype = object, isDefault, isBaseType
// sourcery: subclassInstancesHave__dict__
/// Top of the `Python` type hierarchy.
public struct PyObject: PyObjectMixin {

  internal enum Lazy__dict__ {
    /// There is no spoon… (aka. `self.type` does not allow `__dict__`)
    case noDict
    /// `__dict__` is available, but not yet created
    case notCreated
    case created(PyDict)
  }

  // sourcery: storedProperty
  /// Internal dictionary of attributes for the specific instance.
  internal var __dict__: PyObject.Lazy__dict__ {
    // We don't want 'nonmutating set' on this field!
    // See the comment above 'get__dict__' for details.
    return self.__dict__Ptr.pointee
  }

  internal func get__dict__(_ py: Py) -> PyDict? {
    // 'switch' on 'self.__dict__'
  }

  internal func set__dict__(_ value: PyDict) {
    self.__dict__Ptr.pointee = .created(value)
  }

  internal func initialize(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    let lazy__dict__: Lazy__dict__
    if let value = __dict__ {
      lazy__dict__ = .created(value)
    } else if type.typeFlags.instancesHave__dict__ {
      lazy__dict__ = .notCreated
    } else {
      lazy__dict__ = .noDict
    }

    self.__dict__Ptr.initialize(to: lazy__dict__)

    // Other things…
  }
}
```

#### Another edge case

Btw. this is also important (`int` subclass but inside `__new__` we return ordinary `int`):

```py
>>> class BeautyAndTheBeastMovie(int):
...     def __new__(typ, value):
...             return 1
...
>>> beauty_and_the_beast = BeautyAndTheBeastMovie(5)
>>> beauty_and_the_beast.elsa = 5
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'int' object has no attribute 'elsa'
>>> beauty_and_the_beast.__dict__
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'int' object has no attribute '__dict__'
```

### Memory layout

Now lets talk about this:

```py
>>> class Elsa(int, str): pass
...
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: multiple bases have instance lay-out conflict
```

As we can see it is not possible to create a `class` that is a subclass of both `int` and `str` (even though we are able to calculate a valid [MRO - method resolution order](https://www.python.org/download/releases/2.3/mro/)).

The error `TypeError: multiple bases have instance lay-out conflict` means that Python is not able to determine the memory layout of resulting object.

#### Memory layout in CPython

This is the `int` layout:

```c
typedef struct _object {
    _PyObject_HEAD_EXTRA
    Py_ssize_t ob_refcnt;
    struct _typeobject *ob_type;
} PyObject;

typedef struct {
    PyObject ob_base;
    Py_ssize_t ob_size; /* Number of items in variable part */
} PyVarObject;

#define PyObject_VAR_HEAD      PyVarObject ob_base;

struct _longobject {
    PyObject_VAR_HEAD
    digit ob_digit[1];
};

typedef struct _longobject PyLongObject;
```

And this is `str` (simplified, with removed some comments):

```c
#define PyObject_HEAD                   PyObject ob_base;

/* ASCII-only strings created through PyUnicode_New use the PyASCIIObject structure. */
typedef struct {
  PyObject_HEAD
  Py_ssize_t length; /* Number of code points in the string */
  Py_hash_t hash;    /* Hash value; -1 if not set */
  struct {
      /*
        SSTATE_NOT_INTERNED (0)
        SSTATE_INTERNED_MORTAL (1)
        SSTATE_INTERNED_IMMORTAL (2)
      */
      unsigned int interned:2;
      /* Character size:
        - PyUnicode_WCHAR_KIND (0):
        - PyUnicode_1BYTE_KIND (1):
        - PyUnicode_2BYTE_KIND (2):
        - PyUnicode_4BYTE_KIND (4):
      */
      unsigned int kind:3;
      /* Compact unicode objects only require one memory block while non-compact objects use one block for the PyUnicodeObject struct and another for its data buffer. */
      unsigned int compact:1;
      /* The string only contains characters in the range U+0000-U+007F (ASCII) and the kind is PyUnicode_1BYTE_KIND. */
      unsigned int ascii:1;
      /* The ready flag indicates whether the object layout is initialized completely. */
      unsigned int ready:1;
      /* Padding to ensure that PyUnicode_DATA() is always aligned to 4 bytes (see issue #19537 on m68k). */
      unsigned int :24;
  } state;
  wchar_t *wstr; /* wchar_t representation (null-terminated) */
} PyASCIIObject;
```

(Note for non-C programmers: `struct` member with a number is called [bit field](https://en.cppreference.com/w/c/language/bit_field), the number defines the bit width of this filed.)

Anyway, merger of those 2 types would have to store both `digit ob_digit[1]` (from `int`) and `wchar_t *wstr` (from `str`). _Technically_ this is _possible_, but it is so complicated that nobody is going to do this (basically the whole language implementation would have to be designed around it).

#### Violet solution
On each `PyType` store the size in memory (`instanceSizeWithoutTail: Int`).

Then when creating new type:
1. For each `type` find the `base` type responsible for `instanceSizeWithoutTail`:

    ```Swift
    private static func getBaseTypeResponsibleForSize(startingFrom type: PyType) -> PyType {
      var result = type
      var resultSize = result.instanceSizeWithoutTail

      while let base = result.base, base.instanceSizeWithoutTail == resultSize {
        result = base
        resultSize = base.instanceSizeWithoutTail
      }

      return result
    }
    ```

2. Check the relationship of those types:
- if one is a subclass of the other - it is “ok”. For example: `int` and `object` are “ok” because `int` is a subclass of `object`. In other words: `int` adds new stored properties to `object`.
- if there is no relationship then we have a layout conflict. For example: `int` and `str` are “not ok”.

### Type casting

Since for each type we have a different Swift type then how do we cast between them?

#### Casting to `PyObject`

Each type conforms to `PyObjectMixin` which gives us `asObject` property:

```Swift
/// Common things for all of the Python objects.
public protocol PyObjectMixin: CustomStringConvertible {
  /// Pointer to an object.
  ///
  /// Each object starts with the same fields as `PyObject`.
  var ptr: RawPtr { get }
}

extension PyObjectMixin {

  /// [Convenience] Convert this object to `PyObject`.
  public var asObject: PyObject {
    return PyObject(ptr: self.ptr)
  }
}
```

#### Downcasting

```Swift
if let int = py.cast.asInt(object) {
  things…
}
```

`py.cast` is generated automatically:

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

## Alternatives

### `struct` + type punning

The other approach would be to use `struct` and type punning to create object hierarchy by hand (this is more-or-less what CPython does):

```Swift
struct Ref<Pointee> {
  let ptr: UnsafeMutablePointer<Pointee>
}

struct PyObjectHeader {
  var type: Ref<PyType>
  var flags: UInt32
  private let padding = UInt32.max
}

// This struct describes the memory layout.
// Later we will allocate it in the heap: Ptr<PyObject> and Ptr<PyInt>.
struct PyObject {
  var header: PyObjectHeader
}

struct PyInt {
  var header: PyObjectHeader
  var value: Int
}

func newInt(value: Int) -> Ref<PyInt> {
  // Basically malloc(sizeof(PyInt)) + filling properties
}

// 'int' is a Python object representing number '2'
let int = newInt(value: 2)

// Cast it to 'PyObject' — this is really important since
// we will need to do this to store object on VM stack.
// (spoiler: this is not legal!)
let object = Ref<PyObject>(ptr: int.ptr)
```

As we can see both `PyObject` and `PyInt` start with `PyObjectHeader`, so one could assume that they can easily convert from `PyInt` to `PyObject`.

[Actually…](https://youtu.be/lGnRoMbVan4?t=29) (<- spoiler from first 10 min of Galavant S01E01)

Well… Swift does not guarantee that the memory layout will be the same as declaration order (yes, this *is* what happens right now, but it may change in the future). There are some exceptions, for example:
- `struct` with single member will have the same layout as this member
- `enum` with single `case` with payload will have the payload layout
- homogenous tuples will look “as expected”
- `@frozen` thingies with library-evolution enabled

But, none of them applies in our case.

Related resources:
- [WWDC 2020: Safely manage pointers in Swift](https://developer.apple.com/videos/play/wwdc2020/10167)
- [Swift forum: “Guarantee (in-memory) tuple layout…or don’t” thread by Jordan Rose](https://forums.swift.org/t/guarantee-in-memory-tuple-layout-or-dont/40122)
- [Swift docs: TypeSafeMemory.rst](https://github.com/atrick/swift/blob/type-safe-mem-docs/docs/TypeSafeMemory.rst)
- [Swift evolution: UnsafeRawPointer API](https://github.com/apple/swift-evolution/blob/master/proposals/0107-unsaferawpointer.md)

#### Trivia - flexible array member

In Python `list` and `tuple` types are quite similar (as in: they support similar range of operations). The only difference is that `tuples` are immutable, while `lists` are mutable.

To implement them in Violet we just store `elements: [PyObject]`:

```Swift
// sourcery: pytype = tuple, isDefault, hasGC, isBaseType, isTupleSubclass
// sourcery: subclassInstancesHave__dict__
/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
public struct PyTuple: PyObjectMixin, AbstractSequence {
  // sourcery: storedProperty
  internal var elements: [PyObject] {
    self.elementsPtr.pointee
  }
}

// sourcery: pytype = list, isDefault, hasGC, isBaseType, isListSubclass
// sourcery: subclassInstancesHave__dict__
/// This subtype of PyObject represents a Python list object.
public struct PyList: PyObjectMixin, AbstractSequence {
  // sourcery: storedProperty
  internal var elements: [PyObject] {
    self.elementsPtr.pointee
  }
}
```

While this allows us to treat `list` and `tuple` in exactly the same way (see `AbstractSequence` protocol), there is a better representation (which we do not use in Violet, but it is still worth describing).

First lets look at the following facts:
- `tuples` are immutable which means that the `tuple` size does not change during its lifetime. More importantly, this also means that we know the exact element count during the object allocation. This does not apply to `list` which elements can be added and that could result in overgrowing the initial allocation.
- [flexible array member](https://en.wikipedia.org/wiki/Flexible_array_member) gives us a nice way of accessing space after the allocated `struct` (we are talking about `C`, not Swift). For example:

      ```c
      struct vectord {
        short len;    // There must be at least one other data member
        double arr[]; // Flexible array member must be last
        // The compiler may reserve extra padding space here, like it can between struct members
      };
      ```

      This is how one would create `vectord`:

      ```c
      struct vectord*
      vectord_init(int len) {
        int malloc_size = sizeof(struct vectord) + len * sizeof(double);

        // Skipping error handling
        struct vectord *result = malloc(malloc_size);
        result->len = len;

        return result;
      }
      ```

      And then use:

      ```c
      struct vectord* vec = vectord_init(5);
      vec->arr[0] = 1.0;
      ```

All this is used in CPython implementation of `tuple` type (removed code irrelevant to discussed technique):

```c
// CPython/Objects/tupleobject.h

typedef struct {
    PyObject_VAR_HEAD
    PyObject *ob_item[1];

    /* ob_item contains space for 'ob_size' elements.
     * Items must normally not be NULL, except during construction when
     * the tuple is not yet visible outside the function that builds it.
     */
} PyTupleObject;

// CPython/Objects/tupleobject.c

PyObject *
PyTuple_New(Py_ssize_t size)
{
  PyTupleObject *op;
  Py_ssize_t i;
  if (size < 0) {
    PyErr_BadInternalCall();
    return NULL;
  }

  /* Check for overflow */
  if ((size_t)size > ((size_t)PY_SSIZE_T_MAX - sizeof(PyTupleObject) - sizeof(PyObject *)) / sizeof(PyObject *)) {
    return PyErr_NoMemory();
  }

  op = PyObject_GC_NewVar(PyTupleObject, &PyTuple_Type, size);
  if (op == NULL)
    return NULL;

  for (i=0; i < size; i++)
    op->ob_item[i] = NULL;

  _PyObject_GC_TRACK(op);
  return (PyObject *) op;
}

// Python/objimpl.h

#define PyObject_GC_NewVar(type, typeobj, n) \
                ( (type *) _PyObject_GC_NewVar((typeobj), (n)) )

// This is needed in the next code fragment
#define _PyObject_VAR_SIZE(typeobj, nitems)     \
    _Py_SIZE_ROUND_UP((typeobj)->tp_basicsize + \
        (nitems)*(typeobj)->tp_itemsize,        \
        SIZEOF_VOID_P)

// Modules/gcmodule.c

PyVarObject *
_PyObject_GC_NewVar(PyTypeObject *tp, Py_ssize_t nitems)
{
  size_t size;
  PyVarObject *op;

  if (nitems < 0) {
    PyErr_BadInternalCall();
    return NULL;
  }

  size = _PyObject_VAR_SIZE(tp, nitems);
  op = (PyVarObject *) _PyObject_GC_Malloc(size);
  if (op != NULL)
      op = PyObject_INIT_VAR(op, tp, nitems);

  return op;
}
```

`list` type is mutable which means that the element storage may need to be reallocated at some point (for example when we want to add new item to already full list). This prevents CPython programmers from using this technique:

```c
// Objects/listobject.h

typedef struct {
  PyObject_VAR_HEAD
  /* Vector of pointers to list elements.  list[0] is ob_item[0], etc. */
  PyObject **ob_item;
  Py_ssize_t allocated;
} PyListObject;


// Objects/listobject.c

PyObject *
PyList_New(Py_ssize_t size)
{
  PyListObject *op;

  if (size < 0) {
    PyErr_BadInternalCall();
    return NULL;
  }

  op = PyObject_GC_New(PyListObject, &PyList_Type);
  if (op == NULL)
    return NULL;

  if (size <= 0)
    op->ob_item = NULL;
  else {
    op->ob_item = (PyObject **) PyMem_Calloc(size, sizeof(PyObject *));
    if (op->ob_item == NULL) {
      Py_DECREF(op);
      return PyErr_NoMemory();
    }
  }

  Py_SIZE(op) = size;
  op->allocated = size;
  _PyObject_GC_TRACK(op);
  return (PyObject *) op;
}
```

Anyway, going back to alternative Python object representations:

### `MemoryLayout<T>.offset(of: key)`

Technically Swift has [`MemoryLayout<T>.offset(of: key)`](https://developer.apple.com/documentation/swift/memorylayout/2996397-offset), but to use it we would have to create `struct` for every Python type (it would be responsible for layout + offsets) and then create a `extension` to `Ptr<StructType>` to access properties with given offsets.

I think that our solution is a bit simpler.

### Using `C`

If we declare our objects in C we will get the C-layout. Then we can import them into Swift. This is nice because C layout is predictable and well described (see: [cppreference.com: type](https://en.cppreference.com/w/c/language/type)).

Unfortunately this has its own problems, most notably that some of the properties on our Swift types are not trivially representable in C.
