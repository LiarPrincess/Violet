# Error handling

- [Error handling](#error-handling)
  - [Unrecoverable errors](#unrecoverable-errors)
  - [Possible solutions](#possible-solutions)
  - [Approach 1: Designated error value](#approach-1-designated-error-value)
  - [Approach 2: Global `error` variable](#approach-2-global-error-variable)
  - [Approach 3: Swift exceptions](#approach-3-swift-exceptions)
  - [Approach 4: `Result` type](#approach-4-result-type)
  - [Final verdict](#final-verdict)
  - [Side-notes](#side-notes)
    - [Monads) (aka. the scarry m-word)](#monads-aka-the-scarry-m-word)
    - [Effect handlers](#effect-handlers)

We have to decide on error handling approach.

By “error handling” we mean:
> Given a function that returns some result, how can we indicate the possibility of failure?

For example, given a following function:

```Swift
func div(_ dividend: Int, by divisor: Int) -> Int {
  return dividend / divisor
}
```

We can add possibility of returning an error by adding `throws` annotation:

```Swift
enum DivError: Error {
  case divisorIsZero
}

func divThrowing(_ dividend: Int, by divisor: Int) throws -> Int {
  if divisor == 0 {
    throw DivError.divisorIsZero
  }

  return dividend / divisor
}
```

Fundamental operations for errors are:
- **reduction** - after which an error no longer impacts our chain of operations:

      ```Swift
      func withErrorHandling() {
        do {
          _ = try divThrowing(10, by: 0)
        } catch {
          print("Error:", error)
        }
      }
      ```

      Note that `withErrorHandling` function no longer requires `throws` annotation (even though it calls `divThrowing` which has it). Error handling is not required in topmost file (`main.swift`), which means that you can just type `_ = try divThrowing(10, by: 0)` without the `do` block.

- **propagation** - after which we still have an error to handle:

      ```Swift
      func withPropagation() throws {
        _ = try divThrowing(10, by: 0)
      }
      ```

## Unrecoverable errors

Please note that there is a subset of errors that are not recoverable and they can not (or should not) be handled in a way that would allow the program to resume.

The classic example is the `ENOMEM` where the system does not have enough memory to continue. Well… we can try to do *something* with it, but if we try to allocate again we will get yet another `ENOMEM`. How often do you see a code where a programmer properly handled a `NULL` return of `malloc`?

To deal with such situation we have:
- `trap` from `VioletCore` module — call this when one of the core invariants is broken and it may not be safe to continue.
- `unreachable` from `VioletCore` module — call this when you know that it is not possible to reach a certain code path, but the Big Bad Evil Guy (aka. Swift) keeps nagging you about it.

This is the end of “unrecoverable errors” and we will never speak of them again. From now on, all of the errors are “recoverable”.

## Possible solutions

We will focus on following techniques:
1. [Designated error value](##%20Approach%201:%20Designated%20error%20value)
2. [Global `error` variable](##%20Approach%202:%20Global%20`error`%20variable)
3. [Swift exceptions](##%20Approach%203:%20Swift%20exceptions)
4. [`Result` type](##%20Approach%204:%20`Result`%20type) (spoiler: we went with this one, see [Final verdict](##%20Final%20verdict) for justification)

Ofc. there are some other methods. Unfortunately, they are non-idiomatic (or downright impossible) in Swift. [M-thingies](https://en.wikipedia.org/wiki/Monad_(functional_programming)) and effect handlers are discussed later in [Side-notes](#Side-notes) (because some people are going to ask about them).

Please note that this document was not meant to be a review of all possible error handling solutions in different languages etc. (for this see something like [Error Handling Rationale and Proposal](https://github.com/apple/swift/blob/main/docs/ErrorHandlingRationale.rst) from Swift repository).

## Approach 1: Designated error value

In this approach we will take the result type domain and designate a single value to signal an error. This value will *always* mean an error, which implies that if the return type had a finite number of possible values, then one of them will become *unrepresentable*.

This method is *sometimes* used in CPython, for example `CPython/Python/pyhash.c` has following comment at the top:

> All the utility functions (_Py_Hash*()) return "-1" to signify an error.

This is how it looks like when implementing a method (again from `CPython/Python/pyhash.c`):

```c
Py_hash_t
_Py_HashDouble(double v) {
  // some things…

  if (x == (Py_uhash_t) - 1)
    x = (Py_uhash_t) - 2;

  return (Py_hash_t) x;
}
```

This is how call site looks like (from: `CPython/Objects/complexobject.c`):

```c
static Py_hash_t
complex_hash(PyComplexObject *v)
{
    Py_uhash_t hashreal, hashimag, combined;

    hashreal = (Py_uhash_t)_Py_HashDouble(v->cval.real);
    if (hashreal == (Py_uhash_t)-1)
        return -1;

    hashimag = (Py_uhash_t)_Py_HashDouble(v->cval.imag);
    if (hashimag == (Py_uhash_t)-1)
        return -1;

    /* Note:  if the imaginary part is 0, hashimag is 0 now,
     * so the following returns hashreal unchanged.  This is
     * important because numbers of different types that
     * compare equal must have the same hash value, so that
     * hash(x + 0*j) must equal hash(x).
     */
    combined = hashreal + _PyHASH_IMAG * hashimag;
    if (combined == (Py_uhash_t)-1)
        combined = (Py_uhash_t)-2;
    return (Py_hash_t)combined;
}
```

This is also the technique behind the `nullptr/null/nil` checks. With this approach when a function says that it returns a pointer to an object, it may return a special pointer called `nullptr`, then the caller is responsible for checking if the received object is valid.

Pros:
- Almost no overhead - we are returning exactly the same type as before. We still have to check for invalid value, but this is a part of the semantics and it does not depend on the exact error-handling strategy.

Cons:
- Convention only — requires documentation to be understood by other programmers, new programmers may not know it.
- Not enforced by type system — programmer is responsible for remembering about handling possible errors, and we know how it goes when programmers have “to remember” something…

    Btw. I have written enough `C#` code to have “Object reference not set to an instance of an object” error message engraved inside my skull, although, to be fair, it is already [starting to fade](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-8#nullable-reference-types).

## Approach 2: Global `error` variable

In this approach we create global variable to store (possible) error value, while the function return type stays the same. This gives us following flow:
1. Call the function
2. If the function wants to signal an error it sets `global error variable`
3. Function finishes execution
4. Caller checks `global error variable`, if it is set then the error did occur

This is the approach taken by CPython, where they use:
- `PyErr_Format` (or similar method) to signal an error
- `PyErr_Occurred` to check if error occurred

For example (from `CPython/Objects/tupleobject.c`):

```c
static PyObject*
tuplesubscript(PyTupleObject* self, PyObject* item)
{
    if (PyIndex_Check(item)) {
        Py_ssize_t i = PyNumber_AsSsize_t(item, PyExc_IndexError);
        if (i == -1 && PyErr_Occurred())
            return NULL;

        if (i < 0)
            i += PyTuple_GET_SIZE(self);

        return tupleitem(self, i);
    }
    else if (PySlice_Check(item)) {
      // Removed for readability
    }
    else {
        PyErr_Format(PyExc_TypeError,
                     "tuple indices must be integers or slices, not %.200s",
                     Py_TYPE(item)->tp_name);
        return NULL;
    }
}
```

This technique is also used for Unix [errno](https://www.man7.org/linux/man-pages/man3/errno.3.html):
> The <errno.h> header file defines the integer variable errno, which is set by system calls and some library functions in the event of an error to indicate what went wrong.
>
> (...)
>
> The value in errno is significant only when the return value of the call indicated an error (i.e., -1 from most system calls; -1 or NULL from most library functions); a function that succeeds is allowed to change errno.  The value of errno is never set to zero by any system call or library function.

Although, please note that in this case (as opposed to CPython example) the function return value is also affected and checking the `errno` is not a correct way of checking for errors (according to [glibc](https://www.gnu.org/software/libc/manual/html_node/Checking-for-Errors.html) docs):
> Warning: Many library functions may set errno to some meaningless non-zero value even if they did not encounter any errors, and even if they return error codes directly. Therefore, it is usually incorrect to check whether an error occurred by inspecting the value of errno. The proper way to check for error is documented for each function.

Pros:
- ?

Cons:
- Not enforced by type system - programmer is responsible for remembering about handling possible errors (and we all know how it goes when “programmer is responsible for…”).
- Convention only - requires documentation to be understood by other programmers, new programmers may not know it.
- Not thread safe - although we can make it so by storing error in thread-local storage or protecting it. Although, thread safety does not matter in Violet.

## Approach 3: Swift exceptions

Throwing errors as described in [The swift programming language -> Error Handling](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html).

This is the solution used in [PyPy](https://www.pypy.org) (they use Python exceptions to represent Python VM exceptions).

Pros:
- Idiomatic.
- Compiler forces us to handle all exceptions.
- Fast - I don't remember the details, but I think that the error pointer is stored in separate register.

Cons:
- Handling errors on “auto pilot” means that we would just insert `try` and `throws`  without thinking if we should actually handle this error.
- It tangles Python and Swift errors assuming similar behavior. This may not be the case, which could lead to some very subtle errors, especially in already complicated code inside `VM` that deals with error handling/propagation.

## Approach 4: `Result` type

This is similar to Swift standard library [Result](https://developer.apple.com/documentation/swift/result) type (see: [SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md)).

In this method we will create an additional `PyResult` type:

```Swift
/// Result of a `Python` operation.
///
/// It is the truth universally acknowledged that EVERYTHING FAILS.
///
/// On a type-system level:
/// given a type `Wrapped` it will add an `error` possibility to it.
public enum PyResult<Wrapped> {
  /// Use this ctor for ordinary (non-error) values.
  ///
  /// It can still hold an `error` (meaning subclass of `BaseException`),
  /// but in this case it is just a local variable, not object to be raised.
  case value(Wrapped)
  /// Use this ctor to raise error in VM.
  case error(PyBaseException)
}
```

Now, for every function that returns type `T` we will return `PyResult<T>` to indicate the possibility of failure, for example this is the global `next` function:

```Swift
/// next(iterator[, default])
/// See [this](https://docs.python.org/3/library/functions.html#next)
public func next(iterator: PyObject,
                  default: PyObject? = nil) -> PyResult<PyObject> { // (1)
  switch self.callNext(iterator: iterator) {
  case .value(let r):
    return .value(r)

  case .error(let e):
    if let d = `default`, PyCast.isStopIteration(e) { // (2)
      return .value(d)
    }

    return .error(e) // (3)
  }
}

private func callNext(iterator: PyObject) -> PyResult<PyObject> {
  // 'PyStaticCall' will not be discussed here, please just skip it
  if let result = PyStaticCall.__next__(iterator) {
    return result
  }

  switch self.callMethod(object: iterator, selector: .__next__) { // (4)
  case .value(let o):
    return .value(o)
  case .missingMethod:
    return .typeError("'\(iterator.typeName)' object is not an iterator") // (5)
  case .notCallable(let e),
       .error(let e):
    return .error(e)
  }
}
```

In this example we can see:
- (1) — error return - calling `next` with an iterator should produce `PyObject` instance. However, this call may also fail, so we change the return type to `PyResult<PyObject>`.
- (2) — error handling - if the call to `self.callNext` failed with an `StopIteration` error and the user provided `default` value we should return `default`.
- (3) — error propagation - if the call to `self.callNext` failed then the whole call to `next(iterator:default:)` failed
- (4) — idiomatic extended results - `PyResult` can contain either `value` or `error`, but sometimes we may need more cases. For example this is `CallMethodResult`:

      ```Swift
      public enum CallMethodResult {
        case value(PyObject)
        /// Such method does not exists.
        case missingMethod(PyBaseException)
        /// Method exists, but it is not callable.
        case notCallable(PyBaseException)
        case error(PyBaseException)
      }
      ```

      As we can see handling errors from `self.callMethod` is very similar to errors from `self.callNext` (both are `switch` statements).

- (5) — helper method for error creation:

      ```Swift
      extension PyResult {
        public static func typeError(_ msg: String) -> PyResult<Wrapped> {
          return PyResult.error(Py.newTypeError(msg: msg))
        }
      }
      ```

**Performance?**

On the CPU side there is nothing *that* interesting to talk about (yes, there is slight overhead, but it should be negligible).

However, on the memory side…

Facts first:

```Swift
class PyObject {}
class PyError: PyObject {}

enum PyResult<Wrapped> {
  case value(Wrapped)
  case error(PyError)
}

typealias T = PyResult<PyObject>
print("size:", MemoryLayout<T>.size) // 9
print("stride:", MemoryLayout<T>.stride) // 16
```

One would expect the  `MemoryLayout<T>.size` to be `8` with the [tag hidden inside the pointer](https://en.wikipedia.org/wiki/Tagged_pointer), but that did not happen. It would happen if we used non-generic approach (as described in [github.com/apple/swift/TypeLayout.rst](https://github.com/apple/swift/blob/main/docs/ABI/TypeLayout.rst)):

```Swift
enum PyResultNonGeneric {
  case value(PyObject)
  case error(PyError)
}

print("size:", MemoryLayout<PyResultNonGeneric>.size) // 8
print("stride:", MemoryLayout<PyResultNonGeneric>.stride) // 8
```

Tbh. I am not sure why it works this way, generic enums in Swift are sized based on the generic type (for example: if we used `PyResult` with struct that contains 4x `Int64` the size would be `4*8 + 1 = 33`).
In this case the mechanism responsible for finding common spare bits did not trigger (or Swift designers decided that this not that useful).

Anyway, pros:
- Idiomatic — Swift already has an `Result` type.
- Compiler forces us to handle all exceptions.

Cons:
- Annoying to write — `switch` statements everywhere. We can partially mitigate this with `map` and `flatMap`, but those are difficult to debug (C# solves this with [DebuggerStepThrough](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.debuggerstepthroughattribute?view=net-5.0) attribute where “Step Into” skips annotated frame and goes directly to children).
- Performance will probably be worse than using Swift exceptions.

## Final verdict

So, which one did we choose?

- **[Approach 1: Designated error value](##%20Approach%201:%20Designated%20error%20value)**
- **[Approach 2: Global `error` variable](##%20Approach%202:%20Global%20`error`%20variable)**

  Both of them are not checked by compiler and rely on programmer to remember to handle errors which makes them difficult to use.

  NOPE.

- **[Approach 3: Swift exceptions](##%20Approach%203:%20Swift%20exceptions)**

  The main problem is that it tangles Python and Swift errors which could really bite us in some unspecified way. Given that the error handling code inside the `VM` is already very complicated we have to pass on this one.

  NOPE.

- **[Approach 4: `Result` type](##%20Approach%204:%20`Result`%20type)**

  The main difficulty when using this method is that it requires a lot of typing (mostly `switch` statements). While we *could* write Swift preprocessor to solve this, it is hardly worth the effort (also c'mon…). Btw. I'm not trying to be *that* person, but [Rust has solved it](https://doc.rust-lang.org/rust-by-example/std/result/question_mark.html) ([this](https://www.lpalmieri.com/posts/error-handling-rust/#the-error-trait) is also good). Btw. they have macros.

  Anyway, this is the winner. Yay!

  Btw. we did a small modification, so that we have a separate:
  - `PyResultGen<Wrapped>` - either `Wrapped` or `PyBaseException`.
  - `PyResult` - either `PyObject` or `PyBaseException`. This is basically the same thing as `PyResultGen<PyObject>`, but without generics, so the compiler should be able to emit better code.

## Side-notes

Somebody will ask about those, so we can deal with them now.

### [Monads](https://en.wikipedia.org/wiki/Monad_\(functional_programming\)) (aka. the scarry m-word)

Monads are an abstract concept with multiple possible implementations (especially when we take into account that Swift is impure by design). For example both `Result` and `exceptions` are based on monads (`Result` is basically `Either` and `try` its “[do notation](https://en.wikibooks.org/wiki/Haskell/do_notation)”). Thus, speaking about *monadic error handling* is kinda… *huh…?*.

### [Effect handlers](https://www.eff-lang.org/handlers-tutorial.pdf)

This is not possible in Swift, but we can discuss it.

In this approach we introduce an `effect` with very precise definition of:

> something that the function does in addition to returning value.

For example an `effect` can be:
- IO operation — like reading form a hard drive or downloading a cat picture from the internet.
- `async` — where the function can suspend waiting for an operation to finish (possibly allowing other functions to run). Note that `async` is orthogonal to concurrency, as in: `async` does not imply that there are multiple operations running at the same time (serial schedulers/queues are a thing).
- Calling another function — for example calling `+` when evaluating `2 + 2`.
- Errors — oh wait…

When a function wants to perform an `effect` it `yields` (via coroutine) following tuple:
- `effect value` — for example:
    - instance of `struct ReadFileEffect { let path: String }`
    - instance of a type that conforms to an `Error` protocol (hmm… seems familiar)
- `continuation function` — function that should be called if we want to continue execution on the current path. Seems scary, but compiler can deal with it.

Then an `effect handler` deals with this `effect`:
- Reduction — it does the action and calls `continuation function` with the result.
- Propagation — it passes the (`effect value`, `continuation function`) tuple to another handler/reducer.

All this looks more-or-less like this (in pseudo-Swift):

```Swift
/// `Effect` is a marker protocol, just like `Error`.
struct ReadFileEffect: Effect {
  let path: String
}

/// In this notation we will specify effects before `->`
/// (similar to how we add `throws` to signal possible errors).
func readAllFiles(paths: String) ReadFileEffect -> [String] {
  var result = [String]()

  for path in paths {
    // 'continuation' is implicit (and managed by compiler)
    let content = yield ReadFileEffect(path: path)
    result.append(content)
  }

  return result
}

// In main.swift:
do {
  let filePaths = ["./cat.txt", "./rabbit.txt"]
  let fileContents = readAllFiles(paths: filePaths)
} catch ReadFileEffect(let path) {
  // Read single file (specified by 'path') and call continuation function
  let content = String(contentsOf: path)
  // Resume execution inside `readAllFiles`
  resume(with: content)
}
```

Note that there is no connection between a `readAllFiles(paths:)` and a code responsible for actually reading the file, this is great for unit testing (or test environments like Swift Playgrounds).

In addition, the language could come with some “built-in” effect handlers, just like Swift currently allows to use `try` without `do/catch` inside the `main.swift` (because it knows how to handle an error).

How could we use this in Violet?

Well, we are not interested in the whole `resume(with: content)` thing (we would never resume the function on error). What we are interested in would be effect inference where the language automatically discovers the effects emitted by a function and then forces us to handle them. This would solve the problem of writing a lot of the `switch` statements, although this could still mean that we would automatically propagate errors without thinking instead of handling them.

But still, this machinery is not available in Swift.
