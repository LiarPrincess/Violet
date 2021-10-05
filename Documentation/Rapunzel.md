# Rapunzel

Tiny module that implements a subset of “[A prettier printer](http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf)” by Philip Wadler.

## Example

We use it to pretty print our `AST`:

Input (in Python):

```py
def elsa():
  print('let it go')
```

Implementation (just some relevant bits):

```Swift
class ASTPrinter: ASTVisitor, StatementVisitor {

  public func visit(_ node: FunctionDefStmt) -> Doc {
    let decorators = node.decorators.isEmpty ?
      self.text("Decorators: none") :
      self.block(title: "Decorators", lines: node.decorators.map(self.visit))

    let returns = node.returns.map { block(title: "Returns", lines: self.visit($0)) } ??
      self.text("Returns: none")

    return self.base(
      stmt: node,
      lines:
        self.text("Name: \(node.name)"),
        self.block(title: "Args", lines: self.visit(node.args)),
        self.block(title: "Body", lines: node.body.map(self.visit)),
        decorators,
        returns
    )
  }

  // Helper functions - used in other 'visit' functions

   private func block(title: String, lines: [Doc]) -> Doc {
    return .block(title: title,
                  indent: ASTPrinter.indent,
                  lines: lines)
  }

  private func text<S: CustomStringConvertible>(_ value: S) -> Doc {
    return .text(String(describing: value))
  }

  private func base(stmt: Statement, lines: [Doc] = []) -> Doc {
    let type = self.typeName(of: stmt)
    let title = "\(type)(start: \(stmt.start), end: \(stmt.end))"

    return lines.isEmpty ?
      self.text(title) :
      self.block(title: title, lines: lines)
  }
}
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
