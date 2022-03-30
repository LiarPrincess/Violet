# Exposing Swift function to Python

- [Exposing Swift function to Python](#exposing-swift-function-to-python)
  - [Functions](#functions)
    - [Supported arities](#supported-arities)
  - [Methods](#methods)
  - [Properties](#properties)

After we implement all of the Python functions we have to expose them to the Python context (make them callable from Python code).

So, how do we go from:

```Swift
extension Py {

  /// any(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#any)
  public func any(iterable: PyObject) -> PyResult<Bool> {
    return self.reduce(iterable: iterable, initial: false) { _, object in
      switch self.isTrueBool(object: object) {
      case .value(true): return .finish(true)
      case .value(false): return .goToNextElement
      case .error(let e): return .error(e)
      }
    }
  }
}
```

To:

```Python
>>> any([False, False, True, False])
True
```

## Functions

The main difficulty is that there are many possible [function arities](https://en.wikipedia.org/wiki/Arity) that we have to cover (for example: some functions take only the `self` argument, some can take more).

So the first step is to unify them and expose a single `call` method. So, let’s introduce a `FunctionWrapper` type.

```Swift
/// Represents Swift function callable from Python context.
public struct FunctionWrapper {

  // Each kind holds a 'struct' with similar name in its payload.
  // There are many other 'kinds', but we do not need them in our example.
  internal enum Kind {
  /// `(Py) -> PyResult`
  case void_to_Result(Void_to_Result)
  /// `(Py, PyObject) -> PyResult`
  case object_to_Result(Object_to_Result)
  }

  internal let kind: Kind

    /// Call the stored function with provided arguments.
  public func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
    // Just delegate to specific wrapper.
    switch self.kind {
    case let .void_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    case let .object_to_Result(w): return w.call(py, args: args, kwargs: kwargs)
    }
  }

  /// Positional nullary: no arguments (or an empty tuple of arguments, also known as `Void` argument).
  ///
  /// `(Py) -> PyResult`
  public typealias Void_to_Result_Fn = (Py) -> PyResult

  internal struct Void_to_Result {
    private let fn: Void_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Void_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 0:
        return self.fn(py)
      default:
        return .typeError(py, message: "'\(self.fnName)' takes no arguments (\(args.count) given)")
      }
    }
  }

  public init(name: String, fn: @escaping Void_to_Result_Fn ) {
    let wrapper = Void_to_Result(name: name, fn: fn)
    self.kind = .void_to_Result(wrapper)
  }

  // And so on… for every argument/return type combination
}
```

Then we would store the `FunctionWrapper` in `builtinFunction` object and delegate any `__call__` to it:

```Swift
// sourcery: pytype = builtinFunction, isDefault, hasGC
/// This is about the type `builtin_function_or_method`,
/// not Python methods in user-defined classes.
public struct PyBuiltinFunction: PyObjectMixin, AbstractBuiltinFunction {

  // sourcery: storedProperty
  /// The Swift function that will be called.
  internal var function: FunctionWrapper { self.functionPtr.pointee }

  // sourcery: pymethod = __call__
  internal static func __call__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__call__")
    }

    return zelf.function.call(py, args: args, kwargs: kwargs)
  }
}
```

### Supported arities

Now, how many signatures do we need?

Well… a lot.

For example for ternary methods (`self` + 2 args) we have:
- `(PyObject, PyObject,  PyObject) -> PyResult`
- `(PyObject, PyObject,  PyObject?) -> PyResult`
- `(PyObject, PyObject?, PyObject?) -> PyResult`

As we can see some ternary (and also binary and quartary) methods can be called with smaller number of arguments (in other words: some arguments are optional). On the Swift side we represent this with optional arg.

For example:
`PyString.strip(_ py: Py, zelf: PyObject, chars: PyObject?) -> PyResult` has:
  - required `zelf: PyObject` argument
  - optional `chars: PyObject?` argument

This works in the following way:
  - When called with 1 argument we will pass `nil` as `chars`.
  - When called with 2 arguments we will pass them according to their position.
  - When called with more than 2 argument we will return error.

This is the wrapper for `PyString.strip(_ py: Py, zelf: PyObject, chars: PyObject?) -> PyResult`:

```Swift
internal struct FunctionWrapper {

  /// Positional binary: `self` and optional `object`.
  ///
  /// `(Py, PyObject, PyObject?) -> PyResult`
  public typealias Object_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject?) -> PyResult

  internal struct Object_ObjectOpt_to_Result {
    private let fn: Object_ObjectOpt_to_Result_Fn
    fileprivate let fnName: String

    fileprivate init(name: String, fn: @escaping Object_ObjectOpt_to_Result_Fn) {
      self.fnName = name
      self.fn = fn
    }

    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {
        return .error(e.asBaseException)
      }

      switch args.count {
      case 1:
        return self.fn(py, args[0], nil)
      case 2:
        return self.fn(py, args[0], args[1])
      default:
        return .typeError(py, message: "expected 2 arguments, got \(args.count)")
      }
    }
  }

  public init(name: String, fn: @escaping Object_ObjectOpt_to_Result_Fn) {
    let wrapper = Object_ObjectOpt_to_Result(name: name, fn: fn)
    self.kind = .object_ObjectOpt_to_Result(wrapper)
  }
}
```

And of course, there are also different return types to handle…

It is also a nice test to see if Swift can properly bind correct overload. Technically `TernaryFunction` is super-type of `TernaryFunction_withOptional`, because `TernaryFunction_withOptional` can be passed as an argument where `TernaryFunction` was expected (when calling the function later the optional will never be `nil`). Functions are contravariant on parameter type (or something… I always mix co/contra variance).

## Methods

We will use `int.add` as an example:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public struct PyInt: PyObjectMixin {

  public let value: BigInt

  // sourcery: pymethod = __add__
  public static func add(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, fnName)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented(py)
    }

    let result = zelf.value + other.value
    return PyResult(py, result)
  }
}
```

This is how we would extract and call this function in Swift context:

```Swift
// Extracted function with type signature:
// (Py, PyObject, PyObject) -> PyResult
let f = PyInt.__add__(_:zelf:other:)

let arg = Py.newInt(1)
let result = f(py, arg, arg)
print(result) // 2
```

Clearly our function has 2 arguments (ignoring `Py`):
- 1st one is the `self` argument (instance of the `PyInt` class), it is used as a left operand for `__add__` operation
- 2nd one is any Python object (instance of `PyObject` class), it is used as a right operand for `__add__` operation

Anyway, we can wrap this function inside `builtinFunction` and put it in `int.__dict__`:

```Swift
let __add__ = FunctionWrapper(name: "__add__", fn: PyInt.__add__(_:zelf:other:))
let builtinFunction = py.newBuiltinFunction(fn: __add__, module: nil, doc: nil)

let dict = intType.getDict(py)
let interned = py.intern(string: "__add__")
dict.set(py, key: interned, value: builtinFunction.asObject)
```

## Properties

Python property is just a container of 3 functions:
- `fget` - function to be used for getting an attribute value
- `fset` - function to be used for setting an attribute value
- `fdel` - function to be used for deleting an attribute

Example for `int.real`:

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public struct PyInt: PyObjectMixin {

  // sourcery: pyproperty = real
  internal static func real(_ py: Py, zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, fnName)
    }

    return PyResult(zelf)
  }
}
```

And then:

```Swift
// Btw. function name for property has to be one of:
// __get__/__set__/__del__
let real = FunctionWrapper(name: "__get__", fn: PyInt.real(_:zelf:))
let property = py.newProperty(get: get, set: nil, del: nil, doc: doc)

let dict = intType.getDict(py)
let interned = py.intern(string: "real")
dict.set(py, key: interned, value: property.asObject)
```
