# Rapunzel

Tiny module that implements subset of “[A prettier printer](http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf)” by Philip Wadler.

## Example

We use it to pretty print our `AST`:

Input (this is Python code):
```py
def elsa():
  print('let it go')
```

Output:
```
ModuleAST(start: 1:0, end: 2:20)
  FunctionDefStmt(start: 1:0, end: 2:20)
    Name: elsa
    Args
      Arguments(start: 1:9, end: 1:9)
        Args: none
        Defaults: none
        Vararg: none
        KwOnlyArgs: none
        KwOnlyDefaults: none
        Kwarg: none
    Body
      ExprStmt(start: 2:2, end: 2:20)
        CallExpr(context: Load, start: 2:2, end: 2:20)
          Name
            IdentifierExpr(context: Load, start: 2:2, end: 2:7)
              Value: print
          Args
            StringExpr(context: Load, start: 2:8, end: 2:19)
              String: 'let it go'
          Keywords: none
    Decorators: none
    Returns: none
```

Isn't it pretty?
