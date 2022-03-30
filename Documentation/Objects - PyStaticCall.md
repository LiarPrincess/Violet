# PyStaticCall

Static call in Violet is a direct call to a non-overriden Python method implemented in Swift.

For example:

```Python
>>> l = ['alice', 'ariel', 'elsa']
>>> len(l)
3
```

We know that:
- `l` is an instance of a Python `list` type (it is important that this is a `list` and not a `list` subclass, because subclasses can override methods)
- we know which Swift method implements the `list.__len__`

With this knowledge we know which Swift method will be invoked when we call `len(l)`, so we can go directly there, skipping the standard Python dispatch.

## Python dispatch

This is how standard Python method dispatch looks like (example for `list.__len__`):
1. Lookup `__len__` in object [`MRO` (method resolution order)](https://www.python.org/download/releases/2.3/mro/)
    2. Get object type — in our case it would be a `list` or its subclass
    3. Get `MRO` table
    4. Look for `__len__` in each subsequent `type.__dict__`
2. Create bound object
    3. This creates either a `builtinMethod` or `method` Python object
3. Dispatch the function call
    4. Look up the `__call__` method on the  method object — this means another `MRO` lookup etc.
    5. Execute the code — it will (eventually) call `PyList.__len__` in Swift (or if this was a `list` subclass with overrides `__len__` it would execute the code contained in `CodeObject` for this method)

This is rather slow (and really annoying when you have to go through this in `lldb`).

## Static dispatch in Violet

1. Store references to Swift methods implementing most common Python methods on `type`.

    Method container:

    ```Swift
    internal struct StaticallyKnownNotOverriddenMethods {

      // Other methods are also present.
      // But we do not need them in this example.
      internal var __len__: GetLengthWrapper?

      internal struct GetLengthWrapper {

        internal let fn: (Py, PyObject) -> PyResult

        internal init(_ fn: @escaping (Py, PyObject) -> PyResult) {
          self.fn = fn
        }
      }
    }
    ```

    Stored on type:

    ```Swift
    // sourcery: pytype = type
    public struct PyType: PyObjectMixin {

      private var name: String
      private var qualname: String
      private var base: PyType?
      private var bases: [PyType]
      private var mro: [PyType]
      private var subclasses: [WeakRef] = []
      internal let staticMethods: StaticallyKnownNotOverriddenMethods
    }
    ```

2. When calling Python method try the static method first.

    `builtins.len` implementation:

    ```Swift
    extension Py {

      /// len(s)
      /// See [this](https://docs.python.org/3/library/functions.html#len)
      public func len(iterable: PyObject) -> PyResult {
        if let result = PyStaticCall.__len__(self, iterable: iterable) {
          return result
        }

        switch self.callMethod(object: iterable, selector: .__len__) {
        case .value(let o):
          return .value(o)
        case .missingMethod:
          return .typeError("object of type '\(iterable.typeName)' has no len()")
        case .error(let e),
             .notCallable(let e):
          return .error(e)
        }
      }
    }
    ```

    Actual static call:

    ```Swift
    internal enum PyStaticCall {
      internal static func __len__(_ py: Py, iterable: PyObject) -> PyResult? {
        if let method = object.type.staticMethods.__len__?.fn {
          return method(object)
        }

        return nil
      }
    }
    ```

Pros:
- Debugging — static calls in lldb look like this:
    1. Check if `list` has stored `__len__` function pointer (lldb: `n`)
    2. Go into method wrapper (lldb: `s`)
    3. Step over `self` cast (lldb: `n`)
    4. Go into the final method (lldb: `s`)
- Allows us to call Python methods during `Py.initialize` — when not all of the types are yet fully initialized.

    For example when we have not yet added `__hash__` to `str.__dict__` we can still call this method because we know (statically) that `str` does implement this operation. This has a side-effect of using `str.__hash__` (via static call) to insert `__hash__` inside `str.__dict__`.


## Method override

One edge case that we have to take care of is when `list` subclass overrides the `__len__` method. In such situation we have to call the overriden implementation and not our Swift method.

So, each time we create a new class:
1. Copy the static methods from base class
2. Remove overriden static methods

Something like this:

```Swift
internal struct StaticallyKnownNotOverriddenMethods {

  /// Special init for heap types (types created on-the-fly,
  /// for example by 'class' statement).
  ///
  /// We can't just use 'base' type, because each type has a different method
  /// resolution order (MRO) and we have to respect this.
  internal init(
    mroWithoutCurrentlyCreatedType mro: MRO,
    dictForCurrentlyCreatedType dict: PyDict
  ) {
    self = StaticallyKnownNotOverriddenMethods()

    // We need to start from the back (the most base type, probably 'object').
    for type in mro.resolutionOrder.reversed() {
      self.removeOverriddenMethods(from: type.__dict__)
      self.copyMethods(from: type.staticMethods)
    }

    self.removeOverriddenMethods(from: dict)
  }
}
```
