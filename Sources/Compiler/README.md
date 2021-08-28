# Compiler

Compiler is responsible for transforming `AST` (from the “Parser” module) to `CodeObjects` (from the “Bytecode” module).

See “Documentation” directory in `<repository-root>` for more details.

## Important types

- `Compiler` and `CompilerImpl` — main types (duh…). 

- `CompilerUnit` — single `AST` may produce multiple `CodeObjects`. For example: *module* may contain *class* which contains *methods* and each of them will produce separate `CodeObject`. To remember to which `CodeObjects` we are currently emitting instructions to, we will store them on the stack of units (`CompilerUnit` = `CodeObject` + `SymbolScope` + some other things). For example:

    ```py
    class Frozen:
    def elsa(self):
      pass <- we are emitting here
    ```

      Generates the following unit stack: *module -> Frozen class -> elsa method*. We are currently emitting to the *elsa method* because it is at the top of the stack.

- `BlockType` - blocks are for example: `loops`, `try`, `except`. We will create the stack of `BlockTypes` to remember the context of the code we are currently emitting. This is useful to handle situations like: `continue` used outside of a loop.

- `SymbolTableBuilder` — before we compile `AST` we will do another pass that gathers information about used symbols (by *symbol* we mean variable/class/method name etc.). This will allow us to generate code more efficiently. For example: we will emit different instructions depending on whether the variable is function argument, local declaration or global.
