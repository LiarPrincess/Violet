# Objects

This file describes a Violet representation of a single Python object.

It is recommended to read the “Sourcery annotations” documentation first.

- [Objects](#objects)
  - [Requirements](#requirements)
  - [CPython](#cpython)
  - [Violet](#violet)
  - [Problems (and solutions)](#problems-and-solutions)
    - [`__dict__` presence](#__dict__-presence)
    - [`pymethod` override](#pymethod-override)
    - [`object` type is full of overridden `pymethods`](#object-type-is-full-of-overridden-pymethods)
    - [Memory layout](#memory-layout)
  - [Alternatives](#alternatives)
    - [`struct` + type punning](#struct--type-punning)
    - [Manual alignment](#manual-alignment)
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

While we could try copy the CPython approach (more about this in “Alternatives” section), at first we will try a bit simpler representation. Our main goal would be ramp up Python functionality coverage without worrying about unnecessary details (like memory management) and later transition to more optimised solution (hoping that our tests will catch any regressions).

The main rule is quite simple:
> For every Python `type` there is a Swift `class` that covers its functionality. For example Python `int` type is represented as Swift `PyInt` class.
> This also means that our Swift class hierarchy will reflect Python type hierarchy.
> Glue code required to make everything work is generated automatically (see “Sourcery annotations” documentation).

Pros:

- This makes writing new types and methods trivial — this is important since we have more than 120 types and 780 methods to implement. However complicated the “glue” is, it can be written/generated once and we will forget about it.

- It is extremely idiomatic — it is as if we were implementing Python objects using Swift. There is no “mental translation step” where programmer has to think about memory representation etc.

      For example this is how `int.__add__` method is implemented (`sourcery` annotations are used for code generation, `Py` represents python context):

      ```Swift
      // sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
      public class PyInt: PyObject {

        public let value: BigInt

        // sourcery: pymethod = __add__
        public func add(_ other: PyObject) -> PyResult<PyObject> {
          guard let other = PyCast.asInt(other) else {
            return .value(Py.notImplemented)
          }

          let result = self.value + other.value
          return .value(Py.newInt(result))
        }
      }
      ```

- Easy to pick up - Python `type` is just a Swift `class`, so as long as you are familiar with Swift `classes` you can contribute to Violet. Meanwhile, in other representations we would have to use more advanced features (like `UnsafePointers`). They are not scary _per se_, but definitely less popular than `classes`).

Cons:

- Wasted memory on Swift metadata - each Swift object holds an reference to its Swift type. We do not need this since we also store an reference to Python type which serves similar function.

- Forced Swift memory management - ARC is “not the best” solution when working with circular references (which we have). For now we will just accept this, but this means that we could possibly waste a lot of memory.

- We have to perfectly reproduce Python type hierarchy inside Swift which can cause some problems if the 2 languages have different view on a certain behavior (spoiler: they have).

If you think:

> Hmm… it looks like they started from using Swift objects to represent Python objects and then did everything to make it work.

Then… yes, this is more-or-less what happened. You just can’t beat the simplicity and easiness of writing new code with this approach (even with all of its drawbacks).

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

- Dynamically allocate class instances: if the object has `__dict__` then allocate more space.
- For each class that does not have a `__dict__` create a subclass that hast it. Then when creating a new object (`__new__` method) use the `__dict__` version if we are allocating subclass.
- Put `__dict__` in every object. Then, on every use, perform a runtime check to see if this object can access it. If the check fails we will pretend that the `__dict__` does not exists.

Option 1 — not possible in Swift — all of the class instances have to have exactly the same size.

Option 2 — only the objects that actually have a `__dict__` would get it. The main problem with this method is that it is quite non-intuitive and complicated to explain. It also spans across the whole code base (every `__new__` method, every `__dict__` access etc.) which makes it difficult to maintain. Btw. we did actually implement this, but later we decided to go with:

Option 3 — this is the simplest option, so we went with it. It increases the size of each object by a single word, but whatever…

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
public class PyInt: PyObject {
  // Things…
}
```

#### Attribute access

To speed up the lookup process we will copy the `__dict__` flag from type to every instance (so that we do not need to fetch the type every time):

```Swift
public class PyObject: CustomStringConvertible {

  internal final var has__dict__: Bool {
    return self.flags.isSet(.has__dict__)
  }

  // Called when creating an instance.
  private final func copyFlagsFromType() {
    let typeFlags = self.type.typeFlags

    let has__dict__ = typeFlags.instancesHave__dict__
    self.flags.set(.has__dict__, to: has__dict__)
  }
}
```

Then if we wanted to get/set certain attribute (or just access `__dict__`) we just check the flag:

```Swift
/// Returns the **builtin** (!!!!) `__dict__` instance.
///
/// Extreme edge case: object has `__dict__` attribute:
/// ```py
/// >>> class C():
/// ...     def __init__(self):
/// ...             self.__dict__ = { 'a': 1 }
/// ...
/// >>> c = C()
/// >>> c.__dict__
/// {'a': 1}
/// ```
/// This is actually `dict` stored as '\_\_dict\_\_' in real '\_\_dict\_\_'.
/// In such situation this function returns real '\_\_dict\_\_'
/// (not the user property!).
public func get__dict__(object: PyObject) -> PyDict? {
  if object.has__dict__ {
    return object.__dict__
  }

  return nil
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

### `pymethod` override

`pymethod` is our [Sourcery](https://github.com/krzysztofzablocki/Sourcery) annotation for Swift method implementing Python method. The problem arises when we override such method in a subclass:

> When calling a base class method on a subclass instance Swift will call the subclass override.

```Swift
class PyInt {
  func and() { print("int.and") }
}

class PyBool: PyInt {
  override func and() { print("bool.and") }
}

let intInstance = PyInt()
intInstance.and() // 'int.and', as expected

let boolInstance = PyBool()
boolInstance.and() // 'bool.and', as expected

let f = PyInt.and // This is what our “glue code” will do to fill `int.__dict__`
f(intInstance)() // 'int.and', as expected
f(boolInstance)() // 'bool.and'! 'int.and' was expected, since we took 'f' from 'PyInt'
```

How often does this happen?
- `int` and `bool`: `__and__`, `__rand__`, `__or__`, `__ror__`, `__xor__`, `__rxor__`
- exceptions - a lot of methods are overridden, most notably `__new__` and `__init__`

How to solve it?

Since most of our code naturally avoids this issue (only 6 methods on `bool` matter, because we automatically generate the code for exceptions), we can just use different selectors:

```Swift
class PyIntFixed {
  func and(zelf: PyIntFixed) { print("int.and") }
}

class PyBoolFixed: PyIntFixed {
  func andBool(zelf: PyBoolFixed) { print("bool.and") }
}

let intFixedInstance = PyIntFixed()
let boolFixedInstance = PyBoolFixed()

let g = PyIntFixed.and(int:)
g(intFixedInstance) // 'int.and', as expected
g(boolFixedInstance) // 'int.and', as expected
```

### `object` type is full of overridden `pymethods`

(Partially connected to the above.)

Python `object` type (root of the type hierarchy) contains a lot of methods that could be overridden in subclasses (for example: `__eq__`, `__ne__`, `__lt__`, `__le__`, `__gt__`, `__ge__`, `__hash__`, `__repr__`, `__str__`, `__dir__`, `__getattribute__`, `__setattr__`, `__delattr__`, `__init__`).

We could put them inside `PyObject` class, but apart from the “overridden `pymethod` problem” there is also a conceptual issue:
> `PyObject` will be on top of our Swift class hierarchy (for example: it would be the type stored on the VM stack) and also it would contain Python methods. Those 2 usages are not related in any way, so it feels weird to put them inside single class.

To solve this we will put all of those methods in a separate class (not connected to our `PyObject` type hierarchy) and use them to fill `__dict__` inside `object` type (tbh. we did this before we even knew that overridden `pymethods` are a problem).

It works like this:

- `PyObject.swift` — top-most `class` in a Swift class hierarchy
    - responsible for basic memory layout of every Python object
    - stored on the VM stack
    - does not contain any methods attached to Python `object` type

      ```Swift
      public class PyObject {
        internal let type: PyType
        internal var flags: PyObject.Flags = []

        internal init(type: PyType) {
          self.type = type
        }
      }
      ```

- `PyObjectType.swift`
    - stores methods attached to Python `object` type (the ones used when filling `object` type `__dict__`)

          ```Swift
          // sourcery: default, isBaseType
          /// Container for things attached to `object` type
          /// (root of `Python` type hierarchy).
          internal enum PyObjectType {

            // sourcery: pymethod = __eq__
            internal static func isEqual(zelf: PyObject,
                                        other: PyObject) -> CompareResult {
              if zelf === other {
                return .value(true)
              }

              return .notImplemented
            }

            // Other methods here…
          }
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

#### Memory layout in Violet

Going back to Violet, this is how we represent `int`, `bool` and `str`:

```Swift
public class PyObject {
  private var _type: PyType!
  internal var flags: PyObjectFlags
}

// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public class PyInt: PyObject {
  public let value: BigInt
}

// sourcery: pytype = bool, isDefault
public class PyBool: PyInt {
  // No new fields compared to 'PyInt'
}

// sourcery: pytype = str, isDefault, isBaseType, unicodeSubclass
public class PyString: PyObject {
  internal let value: String
}
```

#### Solution

How can we discover whether the base classes have an instance layout conflict?

What we need to do is to look at the fields that are added in a given `PyObject` subclass:
- Are we adding new fields to a parent `class`? — we need to somehow denote the new memory layout. For example, `PyInt` has different memory layout than `PyObject` since it adds `value: BigInt` field.
- Do we use the same fields as the parent `class`? — reuse parent layout. For example, both `PyInt` and `PyBool` use the same layout because `PyBool` does not add any new fields to `PyInt`.

This is how the actual implementation looks like:

```Swift
extension PyType {

  /// Layout of a given type in memory.
  /// If types share the same layout then it means that they look exactly
  /// the same in memory.
  ///
  /// We don't actually need a list of fields etc.
  /// We will just use identity.
  public class MemoryLayout {
    /// Layout of the parent type.
    private let base: MemoryLayout?

    /// Fields:
    /// - `_type: PyType!`
    /// - `flags: PyObjectFlags`
    public static let PyObject = MemoryLayout()
    /// Fields:
    /// - `value: BigInt`
    public static let PyInt = MemoryLayout(base: MemoryLayout.PyObject)
    /// `PyBool` uses the same layout as it s base type (`PyInt`).
    public static let PyBool = MemoryLayout.PyInt
    /// Fields:
    /// - `data: PyStringData`
    public static let PyString = MemoryLayout(base: MemoryLayout.PyObject)
  }
}
```

Then when creating new `type` we will check if all of the base classes have the same layout (it is also allowed for one layout to extend other layout, in which case the layout with the most fields wins). The type that contains this layout is called _solid base_:

```Swift
extension PyType {

  /// Solid base - traverse class hierarchy (from derived to base)
  /// until we reach something with defined layout.
  ///
  /// For example:
  ///   Given:   Bool -> Int -> Object
  ///   Returns: Int layout
  ///   Reason: 'Bool' and 'Int' have the same layout (single BigInt property),
  ///            but 'Int' and 'Object' have different layouts.
  ///
  /// static PyTypeObject *
  /// best_base(PyObject *bases)
  private static func getSolidBase(bases: [PyType]) -> PyResult<PyType> {
    assert(bases.any)

    var result: PyType?

    for candidate in bases {
      guard let currentResult = result else {
        result = candidate
        continue
      }

      let layout = candidate.layout
      if layout.isEqual(to: currentResult.layout) {
        // do nothing…
        // class A(int): pass
        // class B(int): pass
        // class C(A, B): pass <- equal layout of A and B
      } else if layout.isAddingNewProperties(to: currentResult.layout) {
        result = candidate
      } else if currentResult.layout.isAddingNewProperties(to: layout) {
        // nothing, 'currentResult' has already more fields
      } else {
        // we are in different 'branches' of layout hierarchy
        return .typeError("multiple bases have instance lay-out conflict")
      }
    }

    // We can force unwrap because we checked 'bases.any' at the top.
    // swiftlint:disable:next force_unwrapping
    return .value(result!)
  }
}
```

Going back to our `class Elsa(int, str)` example:
1. Call `getSolidBase(bases:)` with `[int, str]` as arguments
2. Set `int` as a `result`
3. Check if `str` and `int` have the same layout
    - _no_
4. Check if `str` layout is adding new properties to `int`
    - the answer is _no_ because `str` and `int` are completely unrelated layouts (although both of them are based on `object` layout, but then they branch out in different directions)
5. Check if `int` layout is adding new properties to `str`
    - again _no_
6. Those are 2 unrelated layouts -> error

## Alternatives

This section contains alternatives to our “Swift object is a Python object” approach.

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
public final class PyTuple: PyObject, AbstractSequence {
  public let elements: [PyObject]
}

// sourcery: pytype = list, isDefault, hasGC, isBaseType, isListSubclass
// sourcery: subclassInstancesHave__dict__
/// This subtype of PyObject represents a Python list object.
public final class PyList: PyObject, AbstractSequence {
  internal var elements: [PyObject]
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

### Manual alignment

We can just allocate a block of memory and manually assign where do each field start and end:

```Swift
struct PyInt {

  private let ptr: UnsafePointer

  // `PyObjectHeader` holds `type/flags` (and maybe `__dict__`).
  internal var header: PyObjectHeader {
    return PyObjectHeader(ptr: self.ptr)
  }

  // Without using [flexible array member](https://en.wikipedia.org/wiki/Flexible_array_member)
  internal var value: BigInt {
    let ptr = self.ptr + PyObjectHeader.size
    return ptr.pointee
  }
}
```

This a bit complicated, so it will not be described here in detail (also, there is a new episode of [Penthouse](https://www.imdb.com/title/tt13067118/) available, so…).

### Using `C`

If we declare our objects in C we will get the C-layout. Then we can import them into Swift. This is nice because C layout is predictable and well described (see: [cppreference.com: type](https://en.cppreference.com/w/c/language/type)).

Unfortunately this has its own problems, most notably that some of the properties on our Swift types are not trivially representable in C.
