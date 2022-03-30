<!-- cSpell:ignore compilerimpl -->

# Compiler

Compiler is responsible for transforming `AST` (from the “Parser” module) to `CodeObjects` (from the “Bytecode” module).

(Please read the “Bytecode” module documentation before starting this one.)

- [Compiler](#compiler)
  - [How does it work?](#how-does-it-work)
  - [Symbol table](#symbol-table)
  - [Compiler and CompilerImpl](#compiler-and-compilerimpl)
    - [Side note: Internal protocol implementation](#side-note-internal-protocol-implementation)

## How does it work?
Compiler visits all of the `AST` nodes and calls appropriate methods on `CodeObjectBuilder` to emit VM instructions. The end result is a valid `CodeObject` with the semantics corresponding to the provided `AST`. For example:

```Swift
/// Emit 'None'
internal func visit(_ node: NoneExpr) throws {
  self.builder.appendNone()
}

/// `1 if a else 3' gives us:
///
/// ```
///  0 LOAD_NAME           0 (a) // load 'a'
///  2 POP_JUMP_IF_FALSE   8     // jump to '8' if 'a' is false
///  4 LOAD_CONST          0 (1) // load constant at index 0 -> 1
///  6 RETURN_VALUE
///  8 LOAD_CONST          1 (3) // load constant at index 1 -> 3
/// 10 RETURN_VALUE
/// ```
internal func visit(_ node: IfExpr) throws {
  // 'Labels' are explained in the bytecode documentation.
  // Basically label = jump target.
  let end = self.builder.createLabel()
  let orElseStart = self.builder.createLabel()

  // Helper functions (like 'self.visit(node.body)') will emit their own code,
  // by calling other 'visit' functions.
  // In this example we will call 'func visit(_ node: IntExpr)' to emit 'LOAD_CONST 1'.
  try self.visit(node.test, andJumpTo: orElseStart, ifBooleanValueIs: false)

  try self.visit(node.body)
  self.builder.appendJumpAbsolute(to: end)

  self.builder.setLabel(orElseStart)
  try self.visit(node.orElse)

  self.builder.setLabel(end)
}
```

## Symbol table

Before we compile `AST` we will do another pass that gathers information about used symbols (by *symbol* we mean variable/class/method name etc.). This will allow us to generate code more efficiently.

For example: we will emit different instructions depending on whether the variable is function argument, local declaration or global. This is crucial when dealing with cells and free variables (you can read about those in “Bytecode” documentation).

## Compiler and CompilerImpl

If you go into the code (namely `Compiler.swift`) you will see that we have `Compiler` and `CompilerImpl` types. What is this about?

So, `Compiler` is `public` and it needs to implement `ASTVisitor` protocols which would require us to mark all of those methods as `public`. This would expose a lot of unnecessary details outside of the module.

To prevent this, we implement the whole compiler inside `internal CompilerImpl` and use it inside `public Compiler` with a single method `run`.

Btw. We do the same for `SymbolTableBuilder` which is actually implemented inside `SymbolTableBuilderImpl`.

### Side note: Internal protocol implementation

Why can't we specify that `Compiler` implements `ASTVisitor` on `internal` level (syntax would be `class Compiler: internal ASTVisitor`)?

Think about this: what if outside of the module we decide to add conformance to `ASTVisitor` again? In such case we can't just say “You can't do this because internally this type already implements `ASTVisitor`”, because nobody cares about internals. More common example: what if we implemented `internal Equatable` and someone outside of the module would decide redefine it? What would be an error message?

It also has some problems on a conceptual level, see
[Traits: Composable Units of Behavior](http://scg.unibe.ch/archive/papers/Scha03aTraits.pdf).

In theory, it could be possible to create “access modified” inheritance
(kinda like in `C++`). However, I think that idiomatic Swift prefers to use wrapper types.

For example: dictionaries/sets do not allow to provide custom `Comparer` (like in `C#`), so if you want to use different notion of “equality” than the one implemented by the type, you have to wrap in custom type. We do this inside the `Core` module where we have `struct UseScalarsToHashString` that re-defines how we should compare `Strings`.
