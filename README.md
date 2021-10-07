# Violet

Violet is one of those Swift <-> Python interop thingies, except that this time we implement the whole language from scratch. Name comes from [Violet Evergarden](https://www.netflix.com/pl-en/title/80182123).

[Many](https://www.imdb.com/title/tt7923710) [unwatched](https://www.imdb.com/title/tt12451520) [k-drama](https://www.imdb.com/title/tt10220588) [hours](https://www.imdb.com/title/tt10850932) [were](https://www.imdb.com/title/tt8242904) [put](https://www.imdb.com/title/tt14169770) [into](https://www.imdb.com/title/tt13067118) [this](https://www.imdb.com/title/tt6263222), so any ⭐  would be appreciated.

If something is not working, you have an interesting idea or maybe just a question, then you can start an issue or discussion. You can also contact us on twitter [@itBrokeAgain](https://twitter.com/itBrokeAgain) (optimism, yay!).

- [Violet](#violet)
  - [Requirements](#requirements)
  - [Features](#features)
  - [Future plans](#future-plans)
  - [Sources](#sources)
  - [Tests](#tests)
  - [Code style](#code-style)
  - [License](#license)

## Requirements

- 64 bit - for `BigInt` and (probably, maybe, I think) hash
- Platform:
    - macOS - tested on 10.15.6 (Catalina) + Xcode 12.0 (Swift 5.3)
    - Ubuntu - tested on 21.04 + Swift 5.4.2
    - Docker - tested on `swift:latest` (5.4.2) on Ubuntu 21.04

## Features

We aim for compatibility with Python 3.7 feature set.

We are only interested in the language itself without additional modules. This means that importing anything except for most basic modules (`sys`, `builtins` and a few others) is not supported (although you can import other Python files).

See `Documentation` directory for a list of known unimplemented features. There is no list of unknown unimplemented features though…

## Future plans

Our current goal was to ramp up the Python functionality coverage, which mostly meant passing as many Python tests (`PyTests`) as possible. This gives us us a safety net for any future regressions.

Next we will try to improve code-base by solving any shortcuts we took.

### 1. New object model (representation of a single Python object in a memory)

Currently we are using Swift objects to represent Python instances. For example Swift `PyInt` object represents a Python `int` instance ([Sourcery](https://github.com/krzysztofzablocki/Sourcery) annotations are explained in documentation):

```Swift
// sourcery: pytype = int, isDefault, isBaseType, isLongSubclass
public class PyInt: PyObject {

  // sourcery: pymethod = __add__
  public func add(_ other: PyObject) -> PyResult<PyObject> {
    // …
  }
}
```

This is nice because:

- Is very easy to add new types/methods - which is important since we have more than 120 types and 780 methods to implement.
- Free type compatibility - which means that we can cast `object` reference (represented as `PyObject` instance) from VM stack to a specific Python type, for example `int` (represented as `PyInt` instance).

Not-so-nice things include:

- Wasted cache/memory on Swift metadata - each Swift object holds a reference to its Swift type. We do not need this since we store a reference to Python type which serves a similar function.
- Forced Swift memory management - ARC is “not the best” solution when working with circular references (which we have, for example: `object` type has `type` type and `type` type is a subclass of `object`, not to mention that `type` type has `type` as its type).
- We have to perfectly reproduce Python type hierarchy inside Swift which can cause some problems if the 2 languages have different view on a certain behavior, for example:

    ```Swift
    class PyInt {
      func and() { print("int.and") }
    }

    // `bool` is a subclass of `int` in Python.
    class PyBool: PyInt {
      override func and() { print("bool.and") }
    }

    let f = PyInt.and // This is stored inside `int.__dict__`
    f(intInstance)(rhs) // 'int.and', as expected
    f(boolInstance)(rhs) // 'bool.and'! 'int.and' was expected, since we took 'f' from 'PyInt'
    ```

There are better ways to represent a Python object, but this is a bit longer conversation in Swift. For details see [this issue](TODO: PUT ISSUE LINK HERE!).

### 2. New method representation

Currently we do something like:

```Swift
class PyInt {
  func add() { print("int.add") }
}

// Extracted function with type signature:
// (PyInt) -> (PyObject) -> PyResult<PyObject>
let swiftFn = PyInt.add

// If we wanted to call it we would have to:
let arg = Py.newInt(1)
let result = swiftFn(arg)(arg)
print(result) // 2

// To put it inside 'int.__dict__' we would:
let fn = PyBuiltinFunction.wrap(
  name: "__add__",
  doc: nil,
  fn: swiftFn,
  castSelf: asInt // asInt :: (PyObject) -> PyResult<PyInt>
)

let key = Py.newString("__add__")
let dict = intType.getDict()
dict.set(key: key, to: fn)
```

This can be simplified a bit, but it also depends on the object model, so it has to wait.

## 3. Garbage collection and memory management

As we said: currently use Swift class instances to represent Python objects (for example: instance of `PyInt` represents `int` object in Python), which means that we use Swift ARC to manage object lifetime.

Unfortunately this does not solve reference cycles, but for now we will ignore this… (how convenient!).

## Sources

Core modules
- **VioletCore** — shared module imported by all of the other modules.
    - Contains things like `NonEmptyArray`, `SourceLocation`, [SipHash](https://131002.net/siphash/), `trap` and `unreachable`.
- **BigInt** — our implementation of unlimited integers
    - While it implements all of the operations expected of `BigInt` type, in reality it mostly focuses on performance of small integers — Python has only one `int` type and small numbers are most common.
    - Under the hood it is a union (via [tagged pointer](https://en.wikipedia.org/wiki/Tagged_pointer)) of `Int32` (called `Smi`, after [V8](https://github.com/v8/v8)) and a heap allocation (magnitude + sign representation) with ARC for garbage collection.
    - While the whole Violet tries to be as easy-to-read/accessible as possible, this does not apply to `BigInt` module. Numbers are hard, and for some reason humanity decided that “division” is a thing.
- **FileSystem** — our version of `Foundation.FileManager`.
    - Main reason why we do not support other platforms (Windows etc.).
- **UnicodeData** — apparently we also bundle our own Unicode database, because why not…

Violet
- **VioletLexer** — transforms Python source code into a stream of tokens.
- **VioletParser** — transforms a stream of tokens (from `Lexer`) into an [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) (`AST`).
    - Yet Another [Recursive Descent Parser](https://en.wikipedia.org/wiki/Recursive_descent_parser) with minor hacks for ambiguous grammar.
    - `AST` type definitions are generated by `Elsa` module from `Elsa definitions/ast.letitgo`.
- **VioletBytecode** — instruction set of our VM.
    - 2-bytes per instruction.
    - No relative jumps, only absolute (via additional `labels` array).
    - `Instruction` enum is generated by `Elsa` module from `Elsa definitions/opcodes.letitgo`.
    - Use `CodeObjectBuilder` to create `CodeObjects`  (whoa… what a surprise!).
    - Includes a tiny [peephole optimizer](https://en.wikipedia.org/wiki/Peephole_optimization), because sometimes the semantics depends on it (for example for [short-circuit evaluation](https://en.wikipedia.org/wiki/Short-circuit_evaluation)) .
- **VioletCompiler** — responsible for transforming `AST` (from `Parser`) into `CodeObjects` (from `Bytecode`).
- **VioletObjects** — contains all of the Python objects and modules.
    - `Py` represents a Python context. Common usage: `Py.newInt(2)` or `Py.add(lhs, rhs)`.
    - Contains `int`, `str`, `list` and 100+ other Python types. Python object is represented as a Swift `class` instance (this will probably change in the future, but for now it is “ok”, since the whole subject is is a bit complicated in Swift). Read the docs in the `Documentation` directory!
    - Contains modules required to bootstrap Python: `builtins`, `sys`, `_imp`, `_os` and `_warnings`.
    - Does not contain `importlib` and `importlib_external` modules, because those are written in Python. They are a little bit different than CPython versions (we have 80% of the code, but only 20% of the functionality <great-success-meme.gif>).
    - `PyResult<Wrapped> = Wrapped | PyBaseException` is used for error handling.
- **VioletVM** — manipulates Python objects according to the instructions from `Bytecode.CodeObject`, so that the output vaguely resembles what `CPython` does.
    - Mainly a massive `switch` over each possible `Instruction` (branch prediction 💔).
- **Violet** — main executable (duh…).
- **PyTests** — runs tests written in Python from the `PyTests` directory.

Tools/support
- **Elsa** — tiny DSL for code generation.
    - Uses `.letitgo` files from `Elsa definitions` directory.
    - Used for `Parser.AST` and `Bytecode.Instruction` types.
- **Rapunzel** — pretty printer based on “[A prettier printer](http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf)” by Philip Wadler.
    - Used to print `AST` in digestible manner.
- **Ariel** — prints module interface - all of the `open`/`public` declarations.

## Tests

There are 2 types of tests in Violet:
- Swift tests — standard Swift unit tests stored inside the `./Tests` directory.

    You may want to disable unit tests for `BigInt` and `UnicodeData` if you are not touching those modules:
    - `BigInt` — we went with [property based testing](https://en.wikipedia.org/wiki/Property_testing) with means that we test millions of inputs to check if the general rule holds (for example: `a+b=c -> c-a=b` etc.). This takes time, but pays for itself by finding weird overflows in bit operations (we store “sign + magnitude”, so bit operations are a bit difficult to implement).
    - `UnicodeData`
        - In one of our tests we go through all of the Unicode code points and try to access various properties (crash -> fail). There are `0x11_0000` values to test, so… it is not fast.
        - We also have a few thousands of tests generated by Python. Things like: “is the `COMBINING VERTICAL LINE ABOVE (U+030d)` alpha-numeric?” (Answer: no, it is not. But you have to watch out because `HANGUL CHOSEONG THIEUTH (U+1110)` is).

- Python tests — tests written in Python stored inside the `./PyTests` directory:
    - Violet - tests written specially for “Violet”.
    - RustPython - tests taken from [github.com/RustPython](https://github.com/RustPython/RustPython).

    Those tests are executed when you run `PyTests` module.

## Code style

- 2-space indents and no tabs at all
- 80 characters per line
    - You will get a [SwiftLint](https://github.com/realm/SwiftLint) warning if you go over 100.
    - Over 120 will result in a compilation error.
    - If 80 doesn't give you enough room to code, your code is too complicated - consider using subroutines (advice from [PEP-7](https://www.python.org/dev/peps/pep-0007/)).
- Required `self` in methods and computed properties
    - All of the other method arguments are named, so we will require it for this one.
    - `Self`/`type name` for static methods is recommended, but not required.
    - I’m sure that they will depreciate the implicit `self` in the next major Swift version 🤞. All of that source breakage is completely justified.
- No whitespace at the end of the line
    - Some editors may remove it as a matter of routine and we don’t want weird git diffs.
- (pet peeve) Try to introduce a named variable for every `if` condition.
    - You can use a single logical operator - something like `if !isPrincess` or `if isDisnepCharacter && isPrincess` is allowed.
    - Do not use `&&` and `||` in the same expression, create a variable for one of them.
    - If you need parens then it is already too complicated.

Anyway, just use [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) with provided presets (see [.swiftlint.yml](.swiftlint.yml) and [.swiftformat](.swiftformat) files).

## License

“Violet” is licensed under the MIT License.
See [LICENSE](LICENSE) file for more information.
