# Objects

This file describes a Violet representation of an single Python object.

## Requirements

- support for *some form* of garbage collection

- each object has to remember its type. This is sometimes referred as [`klass` pointer](http://openjdk.java.net/groups/hotspot/docs/HotSpotGlossary.html).
  ```py
  >>> o = 'Elsa'
  >>> type(o)
  <class 'str'>
  ```

- objects have to be able to store inline value (payload). For example in `int` object we need to store integer value in addition to all of the standard object fields.

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
  typedef struct _longobject PyLongObject; /* Revealed in longintrepr.h */
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

where
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

While we could copy the CPython approach, at first we will go with a bit simpler representation. Our main goal would be ramp up our Python functionality coverage without worrying about unnecessary details (like memory management) and then later transition to more optimized solution (hoping that our tests will catch any regressions).

The main rule is quite simple:
> For every Python `type` there is a Swift `class` that covers its functionality, for example Python `int` type is represented as Swift `PyInt` class.
> This also means that our Swift class hierarchy will reflect Python type hierarchy.
> Glue code required to make everything work will be generated automatically.

Pros:

- this makes writing new types and methods trivial - this is important since we have more than 120 types and 780 methods to implement. However complicated the “glue” is, it can be written/generated once and we will forget about it.

- extremely idiomatic - it is as if we were implementing Python objects using Swift, there is no “translation step” where programmer would have to think about memory representation / casting etc.

  For example this is how `int.__add__` method is implemented (`sourcery` annotations are used for code generation, `Py` represents python context):
  ```Swift
  // sourcery: pytype = int, default, baseType, longSubclass
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

- easy to pick up - Python `type` is just a Swift `class`, so as long as you are familiar with Swift `classes` you can contribute to Violet. Meanwhile, in other representations we would have to use more advanced features (like `UnsafePointers`). They are not scarry _per se_, but definitely less popular than `classes`).

Cons:

- forced Swift memory management - ARC is “not the best” solution when working with circular references (which we will have). For now we will just accept this, but this means that we will waste a lot of memory.

- we have to perfectly reproduce Python type hierarchy inside Swift which can cause some problems if the 2 languages have different semantics (spoiler: they have).

If you think: “hmm… it looks like they started from using Swift objects as Python objects and then did everything to make it work”, then… yes, this is more-or-less what happened.

### Alternative - `struct` + type punning

The other approach would be to use `struct` and type punning to create object hierarch by hand (this is more-or-less what CPython does):

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

func initInt(value: Int) -> Ref<PyInt> {
  // Basically malloc(sizeof(PyInt)) + filling properties
}

let int = initInt(value: 2)
let object = Ref<PyObject>(ptr: int.ptr) // It is not legal to use such 'Ref'
let intAgain = Ref<PyInt>(ptr: object.ptr) // It is not legal to use such 'Ref'
```

As we can see both `PyObject` and `PyInt` start with `PyObjectHeader`, so one could assume that they can easily convert from `PyInt` to `PyObject` (something that we would have to do to store it on the `VM` stack).

[Actually…](https://youtu.be/lGnRoMbVan4?t=29)

Well… Swift does not guarantee that the memory layout will be the same as declaration order (yes, this *is* what happens right now, but it may change in the future). There are some exceptions, for example:
- `struct` with single member will have the same layout as this member
- `enum` with single `case` with payload will have the payload layout
- homogenous tuples will look “as expected”
- `@frozen` thingies with library-evolution enabled

But, none of them applies in our case, as far as I know the only ways to archive this are:
- declare this object in `C` to get `C`-style layout
- use `classes` which trivially can be converted from subclass to superclass (and vice-versa)

Related resources:
- [WWDC 2020: Safely manage pointers in Swift](https://developer.apple.com/videos/play/wwdc2020/10167)
- [Swift forum: “Guarantee (in-memory) tuple layout…or don’t” thread by Jordan Rose](https://forums.swift.org/t/guarantee-in-memory-tuple-layout-or-dont/40122)
- [Swift docs: TypeSafeMemory.rst](https://github.com/atrick/swift/blob/type-safe-mem-docs/docs/TypeSafeMemory.rst)
- [Swift volution: UnsafeRawPointer API](https://github.com/apple/swift-evolution/blob/master/proposals/0107-unsaferawpointer.md)
- [cppreference.com: Compatible types](https://en.cppreference.com/w/c/language/type)

## Problems (and solutions)

### - `pymethod` override

`pymethod` is our [Sourcery](https://github.com/krzysztofzablocki/Sourcery) annotation for Swift method implementing Python method. The problem arises when we override such method in a subclass: when calling base class method on a subclass instance Swift will call the subclass override:

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

Since most of our code naturally avoids this issue (only 6 methods on `bool` matter, because we automatically generate the code for exceptions), we can just use different selectors (we also get bonus points for cute `zelf`):

```Swift
class PyIntFixed {
  static func and(int zelf: PyIntFixed) { print("int.and") }
}

class PyBoolFixed: PyIntFixed {
  static func and(bool zelf: PyBoolFixed) { print("bool.and") }
}

let intFixedInstance = PyIntFixed()
let boolFixedInstance = PyBoolFixed()

let g = PyIntFixed.and(int:)
g(intFixedInstance) // 'int.and', as expected
g(boolFixedInstance) // 'int.and', as expected
```

### - `object` type is full of overridden `pymethods`

(Partially connected to the above.)

Python `object` type (root of the type hierarchy) contains a lot of methods that could be overridden in subclasses (for example: `__eq__`, `__ne__`, `__lt__`, `__le__`, `__gt__`, `__ge__`, `__hash__`, `__repr__`, `__str__`, `__dir__`, `__getattribute__`, `__setattr__`, `__delattr__`, `__init__`).

We could put them inside `PyObject` class, but apart from the “overridden `pymethod` problem” there is also an conceptual issue:
> `PyObject` would be on top of our Swift class hierarchy (for example: it would be the type stored on the VM stack) and also it will contain Python methods. Those 2 usages are not related in any way, so it feels weird to put them inside single class.

To solve this we will put all of those methods in a separate class (not connected to our `PyObject` type hierarchy) and use them to fill `__dict__` inside `object` type (tbh. we did this before we even knew that overridden `pymethods` are even a problem).

It works like this:

- `PyObject.swift` - top-most `class` in a Swift class hierarchy
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
  // sourcery: default, baseType
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

### - Heap types

Lets look at the following Python code:

```py
# Setting 'elsa' property on `int`
>>> little_mermaid = 1
>>> little_mermaid.elsa = 2
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'int' object has no attribute 'elsa'
>>> little_mermaid.__dict__
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
Well… we could say that every Python object has a `__dict__` and perform the check when we want to use it. If the check fails we will pretend that the `__dict__` does not exists. Unfortunately this check would not be trivial to write. Also, this solution increases the size of each object by a single word.

Other way would be to:
- for every `class` that can have a subclass create subclass with an `__dict__` (naming convention: name of the class wth `Heap` suffix)
- when creating new object (`__new__` method):
  - use standard class if this is base class
  - use `Heap` class if this is subclass
- create the `HeapType protocol` implemented by every object that has `__dict__`

In code:

```Swift
internal protocol HeapType: AnyObject {
  var __dict__: PyDict { get set }
}

/// Type used when we subclass builtin `int` class.
/// For example: `class Rapunzel(int): pass`.
internal final class PyIntHeap: PyInt, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = Py.newDict()
}
```

Then later inside `int.__new__` we select whether we want to allocate `PyInt` or `PyIntHeap`:

```Swift
public class PyInt: PyObject {

  // sourcery: pystaticmethod = __new__
  internal static func pyIntNew(type: PyType,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyInt> {
    let isBuiltin = type === Py.types.int
    let alloca = isBuiltin ? Self.newInt(type:value:) : PyIntHeap.init(type:value:)

    // Thingies…
  }

  /// This will use interned value if possible or allocate new `PyInt` if not.
  private static func newInt(type: PyType, value: BigInt) -> PyInt {
    return Py.newInt(value)
  }
}
```

Then if we wanted to get/set certain attribute (or access `__dict__`) we can just check if the type conforms to `HeapType` protocol:

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
/// This is actually `dict` stored as '__dict__' in real '__dict__'.
/// In such situation this function returns real '\_\_dict\_\_'
/// (not the user property!).
internal func get__dict__(object: PyObject) -> PyDict? {
  if let owner = object as? HeapType {
    return owner.__dict__
  }

  return nil
}
```

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

## Method/property objects

### Methods

Now, since we dealt with all of the problems, let's look how we would wrap Swift function and make it available/callable in Python context. We will use `int.add` as an example:

```Swift
// sourcery: pytype = int, default, baseType, longSubclass
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

This is how we would extract and call this function in Swift context:

```Swift
// Extracted function with type signature:
// (PyInt) -> (PyObject) -> PyResult<PyObject>
let f = PyInt.add

let arg = Py.newInt(1)
let result = f(arg)(arg)
print(result) // 2
```

Clearly our function has 2 arguments:
- 1st one is the `self` argument (instance of the `PyInt` class), it is used as a left operand for `__add__` operation
- 2nd one is any Python object (instance of `PyObject` class), it is used as a right operand for `__add__` operation

Since there are many other possible [function arities](https://en.wikipedia.org/wiki/Arity) that we have to cover (for example: some functions take only the `self` argument, some can take more), lets unify them with a single `FunctionWrapper` protocol.

```Swift
/// Represents Swift function callable from Python context.
internal protocol FunctionWrapper {
  /// The name of the built-in function/method.
  var name: String { get }
  /// Call the stored function with provided arguments.
  func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult
}

internal typealias BinaryFunction = (PyObject, PyObject) -> PyFunctionResult

/// Wrapper dedicated to method that takes 2 arguments.
internal struct BinaryFunctionWrapper: FunctionWrapper {

  internal let name: String
  internal let fn: BinaryFunction

  internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.name, kwargs: kwargs) {
      return .error(e)
    }

    switch args.count {
    case 2:
      return self.fn(args[0], args[1])
    default:
      return .typeError("expected 2 arguments, got \(args.count)")
    }
  }
}
```

Now, since we unified all of the possible functions under the `FunctionWrapper` banner, we can finally create Python object representing it (instance of `PyBuiltinFunction` class):

```Swift
// sourcery: pytype = builtinFunction, default, hasGC
public class PyBuiltinFunction: PyObject {

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    return PyMemory.newBuiltinFunction(
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1) }
        return result.asFunctionResult
      },
      module: module,
      doc: doc
    )
  }
}
```

Minor notes:
- `Zelf` - the type of the `self` argument inside the Swift method, so for `PyInt.add` it would be `PyInt`
- `PyFunctionResultConvertible` is a protocol that unifies all of the types that can be returned from Python functions, it requires a single `asFunctionResult` property
- `castSelf` argument is responsible for converting from `PyObject` to correct Swift type (for example: `PyObject` -> `PyInt`)

This is how one would call `PyBuiltinFunction.wrap` to wrap `PyInt.add` method:

```Swift
PyBuiltinFunction.wrap(
  name: "__add__",
  doc: nil,
  fn: PyInt.add(_:),
  castSelf: asInt
)

private static func asInt(_ object: PyObject, methodName: String) -> PyResult<PyInt> {
  return cast(
    object,
    as: PyInt.self,
    typeName: "int",
    methodName: methodName
  )
}

/// Basically:
/// We hold 'PyObjects' on stack.
/// We need to call Swift method that needs specific 'self' type.
/// This method is responsible for downcasting 'PyObject' -> specific Swift type.
private static func cast<T>(_ object: PyObject,
                            as type: T.Type,
                            typeName: String,
                            methodName: String) -> PyResult<T> {
  if let v = object as? T {
    return .value(v)
  }

  return .typeError(
    "descriptor '\(methodName)' requires a '\(typeName)' object " +
    "but received a '\(object.typeName)'"
  )
}
```

Other notes:
- we need as many function wrapper types and `PyBuiltinFunction.wrap` overloads as there are possible arities
- optional arguments also have to be supported, so for example for ternary methods (`self` + 2 args) we have:
  - `TernaryFunction       = (PyObject, PyObject,  PyObject) -> PyFunctionResult`
  - `TernaryFunctionOpt    = (PyObject, PyObject,  PyObject?) -> PyFunctionResult`
  - `TernaryFunctionOptOpt = (PyObject, PyObject?, PyObject?) -> PyFunctionResult`

  It is also nice test to see if Swift can properly bind correct overload of `PyBuiltinFunction.wrap`. Technically `TernaryFunction` is super-type of `TernaryFunctionOpt`, because any function passed to `TernaryFunction` can also be used in `TernaryFunctionOpt` (functions are contravariant on parameter type).

### Properties

Luckily properties are much simpler than methods, because Python property is just a container of 3 functions:
- `fget` - function to be used for getting an attribute value
- `fset` - function to be used for setting an attribute value
- `fdel` - function to be used for deleting an attribute

For convenience we still have `PyProperty.wrap` methods:

```Swift
// sourcery: pytype = property, default, hasGC, baseType
public class PyProperty: PyObject {

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyProperty {
    return PyProperty(
      get: self.wrapGetter(get: get, castSelf: castSelf),
      set: nil,
      del: nil
    )
  }

  private static func wrapGetter<Zelf, R: PyFunctionResultConvertible>(
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyBuiltinFunction {
    return PyBuiltinFunction.wrap(
      name: "__get__",
      doc: nil,
      fn: get,
      castSelf: castSelf
    )
  }
}
```

If we wanted to use it to wrap `PyInt.asReal`:

```Swift
// sourcery: pytype = int, default, baseType, longSubclass
public class PyInt: PyObject {

  // sourcery: pyproperty = real
  public func asReal() -> PyObject {
    // We cannot just return 'self' because of 'bool':
    // if we call 'True.real' then the result should be '1' not 'True'.
    return Py.newInt(self.value)
  }
}
```

Then to actually wrap it we would call:

```Swift
PyProperty.wrap(
  doc: nil,
  get: PyInt.asReal,
  castSelf: Self.asInt
)
```

Where `Self.asInt` is exactly the same as when wrapping `PyInt.add` in wrapping methods example.

## PyStatic

Sometimes instead of doing slow Python dispatch we will use Swift `protocols`. For example: when user has an `list` and ask for `__len__` we could:
1. lookup this method in [MRO (method resolution order)](https://www.python.org/download/releases/2.3/mro/)
2. create bound object
3. dispatch it function call

But this is a lot of work.
We can also: check if this method was overridden (`list` can be subclassed), if not then we can go directly to our Swift implementation.
We could do this for all of the common magic methods (methods that start and end with `__`, for example: `__len__`).

Other reasons:
- Debugging (trust me, you don't want to debug raw Python dispatch)

  Even for simple `len([])` will have:
  1. Check if `list` implements `__len__`
  2. Create bound method that will wrap `list.__len__` function
  3. Call this method - it will (eventually) call `PyList.__len__` in Swift

  That's a lot of work for such a simple operation. Now imagine going through this in `lldb`.

  With `PyStatic` dispatch we will:
  1. Check if `list` implements `__len__Owner protocol`
  2. Check user has not overridden `__len__`
  3. Directly call `PyList.__len__` in Swift

  In `lldb` this is: `n` (check `protocol`), `n` (check override), `s` (step into Swift method).

  Ofc. if this fails (for example `__len__` method is overridden) we will use standard Python dispatch.

- Static calls during `Py.initialize`

  This also allows us to call Python methods during `Py.initialize`,
  when not all of the types are yet fully initialized.

  For example when we have not yet added `__hash__` to `str.__dict__`
  we can still call this method because:
  - `str` conforms to `__hash__Owner` protocol
  - it does not override builtin `str.__hash__` method

Is this bullet-proof? Not really.
If one would remove one of the `builtin` methods from a type, then static protocol conformance would still remain. But most of the time you can't do this:

```py
>>> del list.__len__
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: can't set attributes of built-in/extension type 'list'
```

The code for this is automatically generated (see: [Generated/PyStatic.swift](Generated/PyStatic.swift)), and it looks like this (example for `__len__`):

```Swift
// 1. Owner protocol definition - protocols for each operation
private protocol __len__Owner { func getLength() -> BigInt }

// 2. func hasOverriddenBuiltinMethod
/// Check if the user has overridden given method.
private func hasOverriddenBuiltinMethod(
  object: PyObject,
  selector: IdString
) -> Bool {
  // Content…
}

// 3. PyStatic enum - try to call given function with protocol dispatch
internal enum PyStatic {

  internal static func __len__(_ zelf: PyObject) -> BigInt? {
    if let owner = zelf as? __len__Owner,
       !hasOverriddenBuiltinMethod(object: zelf, selector: .__len__) {
      return owner.getLength()
    }

    return nil
  }
}

// 4. Owner protocol conformance - this type supports given operation/protocol
extension PyByteArray: __len__Owner { }
extension PyBytes: __len__Owner { }
extension PyDict: __len__Owner { }
extension PyDictItems: __len__Owner { }
extension PyDictKeys: __len__Owner { }
extension PyDictValues: __len__Owner { }
extension PyFrozenSet: __len__Owner { }
extension PyList: __len__Owner { }
extension PyRange: __len__Owner { }
extension PySet: __len__Owner { }
extension PyString: __len__Owner { }
extension PyTuple: __len__Owner { }
```

In CPython they store the function pointer directly on type (so it can be called without problems) and use `CheckExact` methods (for example: `PyLong_CheckExact`) to check if method was overridden.

## Memory layout

Now lets talk about this:

```py
>>> class Elsa(int, str): pass
...
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: multiple bases have instance lay-out conflict
```

As we can see it is not possible to create a `class` that is a subclass of both `int` and `str` (even though we are able to calculate a valid [MRO - method resolution order](https://www.python.org/download/releases/2.3/mro/)).

The error `TypeError: multiple bases have instance lay-out conflict` means that CPython is not able to determine the memory layout of resulting object.

For completeness this is the `int` layout:

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

Going back to Violet, this is how we represent `int`, `bool` and `str`:

```Swift
public class PyObject {
  private var _type: PyType!
  internal var flags: PyObjectFlags
}

// sourcery: pytype = int, default, baseType, longSubclass
public class PyInt: PyObject {
  public let value: BigInt
}

// sourcery: pytype = bool, default
public class PyBool: PyInt {
  // No new fields compared to 'PyInt'
}

// sourcery: pytype = str, default, baseType, unicodeSubclass
public class PyString: PyObject {
  internal let data: PyStringData
}

internal struct PyStringData {
  internal let value: String
}
```

To solve this problem we will look at the fields that are added in a given `PyObject` subclass:
- are we adding new fields to a parent `class`? -> we need to somehow denote the new memory layout. For example, `PyInt` has different memory layout than `PyObject` since it adds `value: BigInt` field.
- do we use the same fields as the parent `class`? -> reuse parent layout. For example, both `PyInt` and `PyBool` use the same layout because `PyBool` does not add new fields to `PyInt`.

This is how the actual implementation looks like ([Generated/TypeMemoryLayout.swift](Generated/TypeMemoryLayout.swift)):

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
1. we enter `getSolidBase(bases:)` with `[int, str]` as arguments
2. we set `int` as a `result`
3. we check if `str` and `int` have the same layout
    - _no_
4. we check if `str` layout is adding new properties to `int`
    - the answer is _no_ because `str` and `int` are completely unrelated layouts (although both of them are based on `object` layout, but then they branch out in different directions)
5. we check if `int` layout is adding new properties to `str`
    - again _no_
6. those are 2 unrelated layouts -> error

## Code generation

Now when we have all of the smaller pieces, it's time to describe the glue that holds them together (aka. code generation).

### Sourcery markup

We will use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) for code generation:

- mark every Swift class representing Python type with `pytype` annotation

  ```Swift
  // sourcery: pytype = int, default, baseType, longSubclass
  public class PyInt: PyObject {
    // …
  }
  ```

- mark every Swift method representing Python property getter with `pyproperty`, if this property also contains setter add `setter = <method-name>` annotation (`del` is not supported, because it is not used):

  ```Swift
  // sourcery: pytype = type, default, hasGC, baseType, typeSubclass
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

- mark every Swift method representing Python method as either: `pymethod`, `pystaticmethod` or `pyclassmethod`:

  ```Swift
  // sourcery: pytype = int, default, baseType, longSubclass
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

### Generated files

Let us assume following `int` definition:

```Swift
// sourcery: pytype = int, default, baseType, longSubclass
public class PyInt: PyObject {

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

Firstly we use [Generated/Data/types.stencil](Generated/Data/types.stencil) to dump all of the annotated data to [Generated/Data/types.txt](Generated/Data/types.txt). This is how `int` type looks like in this representation (1st column represents the type of the line):

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

[Generated/Data/types.txt](Generated/Data/types.txt) is parsed by [Generated/Data/types.py](Generated/Data/types.py) and exposed as Python entities (see: `get_types() -> [TypeInfo]` function inside). This data is used in a Python code that is responsible for generating Swift code. The rule is: for each generated `.swift` file there is `.py` file with the same name that generated it, for example: `BuiltinTypes.py` is responsible for generating `BuiltinTypes.swift`.

Following files are generated:

- [Generated/BuiltinTypes.swift](Generated/BuiltinTypes.swift) - this file contains:
  - all of the `PyTypes` for non-error types (as in: Swift objects representing most basic non-error Python types)
  - code responsible for filling `__dict__` of every one of those `PyTypes`

  It looks more or less like this (example contains only `int` type, the real file is much… much… longer):

  ```Swift
  public final class BuiltinTypes {

    public let int: PyType

    internal init() {
      self.int = PyType.initBuiltinType(name: "int", type: self.type, base: self.object, layout: .PyInt)
    }

    internal func fill__dict__() {
      self.fillInt()
    }

    private func fillInt() {
      let type = self.int
      type.setBuiltinTypeDoc(PyInt.doc)
      type.setFlag(.baseType)
      type.setFlag(.default)
      type.setFlag(.longSubclass)

      self.insert(type: type, name: "real", value: PyProperty.wrap(doc: nil, get: PyInt.asReal, castSelf: Self.asInt))

      self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyInt.pyIntNew(type:args:kwargs:)))

      self.insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyInt.add(_:), castSelf: Self.asInt))
    }
  }

  private func insert(type: PyType, name: String, value: PyObject) {
    // Insert value to type '__dict__'…
  }
  ```

- [Generated/BuiltinErrorTypes.swift](Generated/BuiltinErrorTypes.swift) - the same thing as [Generated/BuiltinTypes.swift](Generated/BuiltinTypes.swift), but for error types.

- [Generated/ExceptionSubclasses.swift](Generated/ExceptionSubclasses.swift) - generating code for Swift error subclasses, for example:

  ```Swift
  // sourcery: pyerrortype = KeyboardInterrupt, default, baseType, hasGC, baseExceptionSubclass
  public final class PyKeyboardInterrupt: PyBaseException {

    override internal class var doc: String {
      return "Program interrupted by user."
    }

    /// Type to set in `init`.
    override internal class var pythonType: PyType {
      return Py.errorTypes.keyboardInterrupt
    }

    // sourcery: pystaticmethod = __new__
    internal class func pyKeyboardInterruptNew(
      type: PyType,
      args: [PyObject],
      kwargs: PyDict?
    ) -> PyResult<PyKeyboardInterrupt> {
      let argsTuple = Py.newTuple(args)
      return .value(PyKeyboardInterrupt(args: argsTuple, type: type))
    }
  }
  ```

- [Generated/PyStatic.swift](Generated/PyStatic.swift) - already described in one of the previous sections
- [Generated/HeapTypes.swift](Generated/HeapTypes.swift) - already described in one of the previous sections
- [Generated/TypeMemoryLayout.swift](Generated/TypeMemoryLayout.swift) - already described in one of the previous sections

# `Data` entities

(This is not really connected to our `Object` model, but it is interesting in its own way.)

When we look at the `list` and `tuple` types (in Python) we will see a massive overlap of functionality. For example both of them have: `__hash__`, `__repr__`, `__eq__`, `__ne__`, `__lt__`, `__le__`, `__gt__`, `__ge__`, `__len__`, `__contains__`, `__getitem__`, `count`, `index`, `__add__`, `__mul__` and `__rmul__` with exactly the same implementation.

To avoid code repetition we will introduce `PySequenceData` type and make both `PyList` and `PyTuple` delegate calls to its instance. For example:

```Swift
/// Main logic for Python sequences.
/// Used in `PyTuple` and `PyList`.
internal struct PySequenceData {

  internal typealias Elements = [PyObject]
  internal typealias Index = Elements.Index
  internal typealias SubSequence = Elements.SubSequence

  internal private(set) var elements: Elements

  internal func isEqual(to other: PySequenceData) -> CompareResult {
    guard self.count == other.count else {
      return .value(false)
    }

    for (l, r) in zip(self.elements, other.elements) {
      switch Py.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }
}

// sourcery: pytype = list, default, hasGC, baseType, listSubclass
/// This subtype of PyObject represents a Python list object.
public class PyList: PyObject {

  internal var data: PySequenceData

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isEqual(to: $1) }
  }

  private func compare(
    with other: PyObject,
    using compareFn: (PySequenceData, PySequenceData) -> CompareResult
  ) -> CompareResult {
    guard let other = PyCast.asList(other) else {
      return .notImplemented
    }

    return compareFn(self.data, other.data)
  }
}

// sourcery: pytype = tuple, default, hasGC, baseType, tupleSubclass
/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
public class PyTuple: PyObject {

  internal let data: PySequenceData

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isEqual(to: $1) }
  }

  // 'compare' is almost the same as in 'PyList'.
}
```

(Btw. we do the same inside our `dict`, `set`, `frozenset`, `str`, `bytes` and `bytearray` implementations, where we name our data entities `PyDictData`, `PySetData`, `PyStringData` and `PyBytesData`).

While this allows us to treat `list` and `tuple` in exactly the same way (which simplifies our code), there is a better way (which we do not use in Violet, but it is still worth describing).

First lets look at the following facts:
- `tuples` are immutable which means that the `tuple` size does not change during its lifetime. More importantly, this also means that we know the exact element count during the object allocation. This does not apply to `list` to which elements can be added, which could result in overgrowing the initial allocation.
- [flexible array member](https://en.wikipedia.org/wiki/Flexible_array_member) gives us a nice way of accessing space after the allocated `struct` (we are talking about `C`, not Swift). For example (based on the Wikipedia article linked above):
  ```c
  struct vectord {
    short len;    // there must be at least one other data member
    double arr[]; // the flexible array member must be last
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

This is used in CPython implementation of `tuple` type (removed code irrelevant to discussed technique):

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
