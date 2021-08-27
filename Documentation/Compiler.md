# Compiler

Compiler is responsible for transforming `AST` (from the “Parser” module) to `CodeObjects` (from “Bytecode” module).

## Important types

- `Compiler` - main type (duh…). Compiler visits all of the `AST` nodes and calls appropriate methods on `CodeObjectBuilder` instance to emit VM instructions. The end result is a valid `CodeObject` with the semantics corresponding to the provided `AST`. For example:

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
    // 'Labels' will be explained later, for now just assume that label = jump target.
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

- `CompilerUnit` - single `AST` may produce multiple `CodeObjects`, for example: *module* may contain *class* which contains *methods* and each of them will produce separate `CodeObject`. To remember to which `CodeObjects` we are currently emitting instructions we will store them on the stack of units (`CompilerUnit` = `CodeObject` + `SymbolScope` + some other things). For example:

  ```py
  class Frozen:
    def elsa(self):
      pass <- we are emitting here
  ```

  Generates following unit stack: *module -> Frozen class -> elsa method*. We are currently emitting to the *elsa method* because it is at the top of the stack.

- `BlockType` - blocks are for example: `loops`, `try`, `except`. We will create the stack of `BlockTypes` to remember the context of the code we are currently emitting.

- `SymbolTableBuilder` - before we compile `AST` we will do another pass that gathers information about used symbols (by *symbol* we mean mean variable/class/method name etc.). This will allow us to generate code more efficiently. For example: we will emit different instructions depending on whether the variable is function argument, local declaration or global.

## Jumps and labels

### Relative jumps

We do not support relative jumps, we always use absolute ones. In some cases relative jumps would require changes to already emitted code. For example: `if` condition failed, we have to jump forward, but we have not yet emitted the code to jump over. After we emit this code we have to go back to our jump and fix its argument.

Since our instruction set is fixed at 2-bytes-per-instruction this would (sometimes) require  insertion of `ExtendedArg` opcode (for jumps above 255) which could break other jump targets. Well… it can be done, but it is rather complicated.

### Absolute jumps

To handle absolute jumps we store jump targets in a separate `CodeObject.labels` array. When emitting jump we use the label index as an argument.

This is how you emit a jump:

```Swift
// Create empty jump target.
let end = self.builder.createLabel()

// Emit code before jump - always executed.
try self.visit(codeBefore)

// Jump.
self.builder.appendJumpAbsolute(to: end)

// Emit code that we will jump over - never executed.
try self.visit(codeToJumpOver)

// Set target for 'end' label - we will jump here.
self.builder.setLabel(end)
```

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
