# Documentation

## Most important files (recommended read)

- **BigInt** — documentation for `BigInt` module (\<surprised Pikachu face\>), including:
    - Main goals — this is important since it impacts overall performance and influences expected usage patterns.
    - Reasoning on the internal implementation with possible alternatives.

- **Bytecode**
    - Discussion about instruction size.
    - Reasoning behind excluding relative jumps and  using only absolute jumps (via labels).
    - Explanation of the `cell` and `free` mechanism.

- **Bytecode - Instructions** — every bytecode instruction with explanation.
    - Overall our instruction set is very similar to the CPython one.

- **Objects - Py** — `Py` represents a Python context. It is used to create and manipulate Python objects (for example `‌Py.newInt(2)` or `Py.add(lhs, rhs)`).
    - Describes initialisation of Python context (arguments, environment, IO streams etc.).
    - Contains various tips, quirks and idioms of `Py`.

- **Objects - Error handling** — discussion about possible error handling models and reasoning behind going with `PyResult<T>`.

- **Objects - Sourcery annotations** — explanation of all of the `// sourcery: pytype|pymethod|pystaticmethod|pyclassmethod|pyproperty` comments.

- **Objects - Object representation** — discussion about representation of a single Python object in memory. Contains the reasoning behind our (oh so weird…) `Swift object = Python object` model.

Other files are… there if you need them, but they are not that important.

## Bonus

- **unimplemented_builtins** — for each basic Python type it will print:
    - Missing - the method is not implemented
    - This should not be here - this method should not be implemented on this type