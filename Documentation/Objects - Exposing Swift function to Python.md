# Exposing Swift function to Python

After we implement all of the Python functions we have to expose them to the Python context (make them callable from Python code).

So, how do we go from:

```Swift
extension PyInstance {

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

Small note: `PyFunctionResultConvertible` is a protocol that unifies all of the types that can be returned from Python functions, it requires a single `asFunctionResult` property

```Swift
/// Represents Swift function callable from Python context.
internal struct FunctionWrapper {

  // Each kind holds a 'struct' with similar name in its payload.
  // There are many other 'kinds', but we do not need them in our example.
  internal enum Kind {
  /// `() -> PyFunctionResultConvertible`
  case void_to_Result(Void_to_Result)
  /// `() -> Void`
  case void_to_Void(Void_to_Void)
  }

  internal let kind: Kind

    /// Call the stored function with provided arguments.
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
    // Just delegate to specific wrapper.
    switch self.kind {
    case let .void_to_Result(w): return w.call(args: args, kwargs: kwargs)
    case let .void_to_Void(w): return w.call(args: args, kwargs: kwargs)
    }
  }

  /// Positional nullary: no arguments (or an empty tuple of arguments, also known as `Void` argument).
  ///
  /// `() -> PyFunctionResultConvertible`
  internal typealias Void_to_Result_Fn<R: PyFunctionResultConvertible> = () -> R

  internal struct Void_to_Result {
    fileprivate let fnName: String
    private let fn: () -> PyFunctionResult

    fileprivate init<R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Void_to_Result_Fn<R>
    ) {
        self.fnName = name
        self.fn = { () -> PyFunctionResult in
          // This function returns 'R'
          let result = fn()
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 0:
        return self.fn()
      default:
        return .typeError("'\(self.fnName)' takes no arguments (\(args.count) given)")
      }
    }
  }

  internal init<R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Void_to_Result_Fn<R>
  ) {
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
public final class PyBuiltinFunction: PyObject, AbstractBuiltinFunction {

  /// The Swift function that will be called.
  internal let function: FunctionWrapper
  /// The `__module__` attribute, can be anything.
  internal let module: PyObject?
  /// The `__doc__` attribute, or `nil`.
  internal let doc: String?

  // sourcery: pymethod = __call__
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    return self.function.call(args: args, kwargs: kwargs)
  }
}
```

### Supported arities

Now, how many signatures do we need?

Well… a lot.

For example for ternary methods (`self` + 2 args) we have:
- (PyObject, PyObject,  PyObject) -> PyFunctionResult
- (PyObject, PyObject,  PyObject?) -> PyFunctionResult
- (PyObject, PyObject?, PyObject?) -> PyFunctionResult

As we can see some ternary (and also binary and quartary) methods can be called with smaller number of arguments (in other words: some arguments are optional). On the Swift side we represent this with optional arg.

For example:
`PyString.strip(_ chars: PyObject?) -> String` has single optional argument.
- When called without argument we will pass `nil`.
- When called with single argument we will pass it.
- When called with more than 1 argument we will return error.

This is the wrapper for `PyString.strip(_ chars: PyObject?) -> String`:

```Swift
internal struct FunctionWrapper {

  /// Positional binary: `self` and then optional `object`.
  ///
  /// `(Zelf) -> (PyObject?) -> PyFunctionResultConvertible`
  internal typealias Self_then_ObjectOpt_to_Result_Fn<Zelf, R: PyFunctionResultConvertible> = (Zelf) -> (PyObject?) -> R

  internal struct Self_then_ObjectOpt_to_Result {
    fileprivate let fnName: String
    private let fn: (PyObject, PyObject?) -> PyFunctionResult

    fileprivate init<Zelf, R: PyFunctionResultConvertible>(
      name: String,
      fn: @escaping Self_then_ObjectOpt_to_Result_Fn<Zelf, R>,
      castSelf: @escaping CastSelf<Zelf>
    ) {
        self.fnName = name
        self.fn = { (arg0: PyObject, arg1: PyObject?) -> PyFunctionResult in
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }

          // This function returns 'R'
          let result = fn(zelf)(arg1)
          return result.asFunctionResult
        }
    }

    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {
        return .error(e)
      }

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {
      case 1:
        return self.fn(args[0], nil)
      case 2:
        return self.fn(args[0], args[1])
      default:
        return .typeError("expected 2 arguments, got \(args.count)")
      }
    }
  }

  internal init<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    fn: @escaping Self_then_ObjectOpt_to_Result_Fn<Zelf, R>,
    castSelf: @escaping CastSelf<Zelf>
  ) {
    let wrapper = Self_then_ObjectOpt_to_Result(name: name, fn: fn, castSelf: castSelf)
    self.kind = .self_then_ObjectOpt_to_Result(wrapper)
  }
}
```

And of course, there are also different return types to handle…

It is also a nice test to see if Swift can properly bind correct overload. Technically `TernaryFunction` is super-type of `TernaryFunction_withOptional`, because `TernaryFunction_withOptional` can be passed as an argument where `TernaryFunction` was expected (when calling the function later the optional will never be `nil`). Functions are contravariant on parameter type (or something… I always mix co/contra variance).

### `wrap` functions

To simplify creation of `builtinFunction` objects we will also provide static `wrap` functions:

```Swift
extension PyBuiltinFunction {

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Void_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    let wrapper = FunctionWrapper(name: name, fn: fn)
    return PyMemory.newBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }
}
```

## Methods

We will use `int.add` as an example:

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

Anyway, we can wrap this function inside `builtinFunction` and put it in `int.__dict__`:

```Swift
private func asInt(functionName: String, object: PyObject) -> PyResult<PyInt> {
  switch PyCast.asInt(object) {
  case .some(let o):
      return .value(o)
  case .none:
    return .typeError(
      "descriptor '\(functionName)' requires a 'int' object " +
      "but received a '\(object.typeName)'"
    )
  }
}

let fn = PyBuiltinFunction.wrap(
    name: "__add__",
    doc: nil,
    fn: PyInt.add(_:),
    castSelf: asInt
)

let intType = …

let key = Py.newString("__add__")
let dict = intType.getDict()
dict.set(key: key, to: fn)
```

## Properties

Luckily properties are much simpler than methods, because Python property is just a container of 3 functions:
- `fget` - function to be used for getting an attribute value
- `fset` - function to be used for setting an attribute value
- `fdel` - function to be used for deleting an attribute

For convenience we still have `PyProperty.wrap` methods:

```Swift
// sourcery: pytype = property, isDefault, hasGC, isBaseType
public class PyProperty: PyObject {

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyProperty {
    return PyMemory.newProperty(
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
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
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
  castSelf: asInt
)
```

Where `asInt` is exactly the same as when wrapping `PyInt.add` in wrapping methods example.
