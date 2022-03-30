# Unimplemented

This file lists all of the known not available Python features. In the source code they are mostly grouped inside of the files with `+UNIMPLEMENTED` suffix (for example: `Compiler+UNIMPLEMENTED.swift`).

There is also a separate file that list all of the missing things from Python `builtins` module -> `Unimplemented builtins.txt`.

## Lexer and parser

- **encoding other than `utf-8`** — trying to set it to other value (for example by using `'# -*- coding: xxx -*-'` or `'# vim:fileencoding=xxx'`) will fail. This is not really a big problem since [most of the Python files are in `utf-8`](https://www.python.org/dev/peps/pep-3120/).

- **named unicode escapes** — escapes in form of `\N{UNICODE_NAME}` will fail. For example:

    ```py
    >>> princess = 'Frozen\N{Em Dash}Elsa' # not supported
    ```

- **formatted string nested above level 1** — nesting an f-string inside of an another f-string, will fail:

    ```py
    >>> elsa = 5
    >>> f'elsa: {elsa}' # supported - no nesting
    >>> f'elsa: {f"{elsa}"}' # supported - level 1 nesting
    >>> f'elsa: {f"""{f"{elsa}"}"""}' # not supported - level 2 nesting
    ```

- **expression in formatted string format specifier** (huh… thats mouthful) — it is “ok” to use expressions in formatted strings, just not in format specifiers. For example:

    ```py
    >>> width = 10
    >>> f"width: {width}" # supported
    >>> f"Let it {'go':>{width}}!" # not supported
    ```

## Compiler

All of the those things are supported in lever and parser, but will fail in the compiler:

- **comprehensions** — loops can be used as semantic-equivalent.

    Side note: lack of comprehensions is one of the major differences between our version `importlib.py` and the one inside CPython (`importlib.py` is a Python module responsible for… well… importing things).

- **`yield`** — kinda complicated feature, definitely not a part of our initial release.

- **`async/await`** — yet another complicated feature that will have to wait.

- **relative jumps** — we always use absolute jumps (via `CodeObject.labels`). Relative jumps in compiler would require changing already emitted code. Since our instruction set is fixed at 2-bytes-per-instruction that would (sometimes) require insertion of `ExtendedArg` opcode (for jumps above 255) which could break other jump targets.

## VM

- **`command` (`-c`) and `module` (`-m`) command line arguments**

- **advanced string formatting** — formatting like: `[[fill]align][sign][#][0][minimumwidth][.precision][type]`, will fail. Simple formatting (and specifying no format at all) should work just fine. See [PEP-3101](https://www.python.org/dev/peps/pep-3101/#standard-format-specifiers) to discover all of the ways to crash Violet. Btw. there is no technical reason for this, it is just that the code dealing with strings is rather uninteresting to write.

- **missing types** — we do not have: `memoryview`, `mappingproxy`, `weakref`. Those types are not that important.

- **frozen modules** — kind of ironic given that one of our modules is named Elsa and we have tons of other Disnep references.

- **garbage collection** - we create all objects without carrying about memory. Later, `py.destroy()` will deallocate them all. There is no *destroy-object-during-runtime* feature.

- **[PEP 401 -- BDFL Retirement](https://www.python.org/dev/peps/pep-0401)** - requires variadic generics which Swift does not support. This means that `barry_as_FLUFL` import will not be recognized (sorry Barry…).
