# Violet

Violet is one of those Swift <-> Python interop thingies. Except that this time we implement the whole language from scratch.

Why?

Well… what else can you do during COVID-19 lockdown ([apart](https://www.imdb.com/title/tt10850932/) [from](https://www.imdb.com/title/tt12451520/) [watching](https://www.imdb.com/title/tt10220588/) [k-dramas](https://www.imdb.com/title/tt6263222/))? Also… it is -16°C outside ❄️, so you don't want to leave your house anyway.

## Features

TODO: 3.8
We aim for compatibility with Python 3.6 feature set:
- only the language itself without additional modules

TODO: IO type
TODO: Separate file + VIOLET_TODO.md?
TODO: Stable sort?
Not supported:
- **encoding other than `utf-8`** - trying to set it to other value (for example by using `'# -*- coding: xxx -*-'` or `'# vim:fileencoding=xxx'`) will fail. This is not really a big problem since most of the Python files are in utf-8 - [PEP-3120](https://www.python.org/dev/peps/pep-3120/)).
- **named unicode escapes** - escapes in form of `\N{UNICODE_NAME}` (for example: `\N{Em Dash}`) will fail.
- **formatted string nested above level 1** - for example:
```py
>>> elsa = 5
>>> f'elsa: {elsa}' # supported - no nesting
>>> f'elsa: {f"{elsa}"}' # supported - level 1 nesting
>>> f'elsa: {f"""{f"{elsa}"}"""}' # not supported - level 2 nesting
```
- **expression in formatted string format specifier** (huh… thats mouthful) - it is “ok” to use expressions in formatted strings, just not in format specifiers. For example:
```py
>>> width = 10
>>> f"width: {width}" # supported
>>> f"Let it {'go':>{width}}!" # not supported
```

- **comprehensions** - supported in lexer and parser, will throw in compiler. Loops can be used as semantic-equivalent. Side note: lack of comprehensions is one of the major differences between our version `importlib.py` and the one inside CPython (`importlib.py` is a Python module responsible for… well… importing things).

- **`yield`** - supported in lexer, parser and complier, will throw inside VM. Kinda complicated feature, definitely not a part of a 1.0 version.

- **`async/await`** - supported in lexer, parser, will throw in complier and VM. Yet another complicated feature that will have to wait.

- **relative jumps** - we always use absolute jumps (via `CodeObject.labels`). Relative jumps in compiler would require changing already emitted code. Since our instruction set is fixed at 2-bytes-per-instruction that would (sometimes) require insertion of `ExtendedArg` opcode (for jumps above 255) which could break other jump targets.

- **Advanced formatting** - advanced formatting, for example: `[[fill]align][sign][#][0][minimumwidth][.precision][type]`, will fail. Simple formatting (and specifying no format at all) should work just fine. See [PEP-3101](https://www.python.org/dev/peps/pep-3101/#standard-format-specifiers) to discover all of the ways to crash Violet. Btw. there is no technical reason for this, it is just that the code dealing with strings is rather uninteresting to write.

- **`command` (`-c`) and `module` (`-m`) command line arguments**

- **garbage collection** - we currently use Swift class instances to represent Python objects (for example: instance of `PyInt` represents `int` object in Python), which means that we use Swift ARC to manage object lifetime. Unfortunately that does not solve problem of cycles.
// TODO: New object model

- **missing types** - we do not have: `memoryview`, `mappingproxy`, `weakref`. Those are not that important.

- **frozen modules** - kind of ironic given that one of our modules is named Elsa and we have tons of other Disnep references.

- **[PEP 401 -- BDFL Retirement](https://www.python.org/dev/peps/pep-0401)** - requires variadic generics which Swift does not support. This means that `barry_as_FLUFL` import will not be recognized (sorry Barry…).

In general we tried to group all of the not implemented features inside the files with `+UNIMPLEMENTED` suffix (for example: `Compiler+UNIMPLEMENTED.swift`).

## Compilation and Installation

64bit
mac or Linux
TODO: https://github.com/mono/mono
TODO: Usage

### Building the Software
### Testing and Installation

## Project planning + phases

## Source map

- [Definitions](Definitions) - contains `ast.letitgo` and `opcodes.letitgo` which are used as an input to `Elsa` (our code-generation tool).

- [Lib](Lib) - Python standard library. Currently it contains only `importlib.py` - Python code used for importing modules. Please note that `importlib.py` is a little bit different than CPython version (we have 80% of the code, but only 20% of the functionality).

- [PyTests](PyTests) - tests written in Python, mostly taken from [RustPython](https://github.com/RustPython/RustPython).

- [Scripts](Scripts) - various scripts responsible for: code generation, dumping CPython state (AST, code objects), finding unimplemented Python methods etc. Each script has its own documentation.

- [Sources](Sources)

  - [Core](Sources/Core) - shared module imported by all of the other modules. It contains: common extensions, `NonEmptyArray` type, [SipHash](https://131002.net/siphash/) implementation, song lyrics, `SourceLocation` type etc.

  - [BigInt](Sources/BigInt) - our custom `BigInt` implementation (which is actually more of a *general-purpose unlimited integer*, see details in module README file).

  - [Lexer](Sources/Lexer) - transformation from Python source code to stream of tokens.

  - [Parser](Sources/Parser) - transformation from tokens to `AST`. Just a standard [recursive descent parser](https://en.wikipedia.org/wiki/Recursive_descent_parser) (+minor hacks for ambiguous grammar). `AST` type definitions are generated by `Elsa` from [Definitions/ast.letitgo](Definitions/ast.letitgo).

  - [Bytecode](Sources/Bytecode) - `CodeObject` and `Instructions` definitions. It also contains `CodeObjectBuilder` used as a helper when creating `CodeObjects`. `Instructions` are generated by `Elsa` from [Definitions/opcodes.letitgo](Definitions/opcodes.letitgo).

  - [Compiler](Sources/Compiler) - transformation from `AST` to `CodeObject`. The main type is `Compiler` (whoa… what a surprise!), but it also contains `SymbolTable` and `SymbolTableBuilder`.

  - [Objects](Sources/Objects) - Python objects (for example: `int`, `str` and `list`) and modules (for example: `builtins`, `sys`, `_warnings`, `_imp`, `_os`). It also contains `Py` type which represents Python context (it is the owner of all of the Python objects). This is the biggest module in this project.

  - [VM](Sources/VM) - interpret bytecode from `CodeObjects` to manipulate Python objects, so that the output vaguely resembles what `CPython` does.

  - [Violet](Sources/Violet) - main executable. It contains only a single file: `main.swift` that instantiates `VM` and runs code provided in arguments.

  - [PyTests](Sources/PyTests) - executable that runs Python tests from [PyTests](PyTests) directory.

  - [Elsa](Sources/Elsa) - our code generation tool. It uses `.letitgo` files from [Definitions](Definitions) directory.

  - [Rapunzel](Sources/Rapunzel) - pretty printer based on “[A prettier printer](http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf)” by Philip Wadler. We use it to print `AST` in digestible manner.

- [Tests](Tests) - unit tests (written in Swift)

## Code style

- 2-space indents and no tabs at all
- 80 characters per line - you will get a [SwiftLint](https://github.com/realm/SwiftLint) warning if you go over 100 (120 will fail to compile). If 80 doesn't give you enough room to code, your code is too complicated - consider using subroutines (advice from [PEP-7](https://www.python.org/dev/peps/pep-0007/)).
- required `self` - because we want to be explicit about passing class closure as a 1st parameter. `Self` for static methods is recommended, but not required.
- no line should end in whitespace - some editors may remove it as a matter of routine

In general: just use [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) with provided presets (see [.swiftlint.yml](.swiftlint.yml) and [.swiftformat](.swiftformat) files).

## License

“Violet” is licensed under the MIT License.
See [LICENSE](LICENSE) file for more information.
