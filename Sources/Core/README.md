# Core

Shared module imported by all of the other modules.

- `Extensions` - extensions to Swift types
- `Double+PythonParse.swift` — parse `Double` according to Python rules
- `NonEmptyArray.swift` — array that has at least 1 element. Used as a storage for [Elsa](https://github.com/LiarPrincess/Violet/Sources/Elsa) “+” collections (use “*” if you want to allow empty).
- `SipHash.swift` — implementation of [SipHash-2-4](https://131002.net/siphash/). Based on [reference implementation](https://github.com/veorq/SipHash).
- `SourceLocation.swift` — location in the source file.
- `Trap.swift` — our own version of `fatalError`. It is highly recommended to put a breakpoint inside.
- `Unreachable.swift` — function that should never be executed.
- `UseScalarsToHashString.swift` — Swift uses grapheme clusters in its `String` implementation. Python, however, uses unicode scalars. This can lead to all sorts of problems (especially if we use strings as keys in dictionary).
