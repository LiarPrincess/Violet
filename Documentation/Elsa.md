# Elsa

Elsa is a tiny DSL for describing data. It uses  `.letitgo` files from `Definitions` directory.

- [Elsa](#elsa)
  - [Why?](#why)
  - [Language description](#language-description)
    - [Comments](#comments)
    - [Swift documentation](#swift-documentation)
    - [Product types](#product-types)
    - [Union types](#union-types)
    - [Alias](#alias)

## Why?

From a single Elsa definition we can generate both `AST` nodes and [visitor](https://en.wikipedia.org/wiki/Visitor_pattern) protocols. And if our AST ever changes, we just need to fix it in one place (`.letitgo` file).

Elsa allows us to avoid writing Swift boilerplate by just concentrating on data shape. For example: Swift automatically creates *memberwise initializer* for every `struct`. Unfortunately this `init` has an `internal` access level, so if we want to create instance from an another module, we have manually add `public init`. Elsa does this automatically.

You can easily modify generated code. For example: to add method responsible for accepting [visitor](https://en.wikipedia.org/wiki/Visitor_pattern) you just modify Elsa code, that saves you from having to manually update every node definition.

## Language description

Tip: Use Haskell syntax highlighting.

### Comments
Use `{-` and `-}` for comment. Comments will not emit any Swift code.

```haskell
{-
This is a
multiline comment
-}
```

### Swift documentation
Use `--` to generate Swift documentation.

For example:

```haskell
-- Top (root) node in AST.
@class AST: ASTNode = (
  -- A unique node identifier.
  ASTNodeId id
)
```

will generate:

```Swift
/// Top (root) node in AST.
public class AST: ASTNode {
  /// A unique node identifier.
  public var id: ASTNodeId
}
```

You can add Swift documentation to:
- `enums`
- `enum cases`
- `structs`
- `classes`
- `properties`

### Product types

`@class` will generate `class`, just like `@struct` will generate `struct`.

Types can be nested inside other types, by specifying `OuterType.InnerType` as name (see `@struct` in the example below).

Following modifiers can be used for properties:
- `*` - array
- `+` - array with at least 1 element (will emit `NonEmptyArray` from `Core` module)
- `?` - optional

```haskell
-- A function definition.
@class FunctionDefStmt: Stmt = (
  -- `name` is a raw string of the function name.
  Identifier name,
  -- `args` is a arguments node.
  Arguments args,
  -- `body` is the list of nodes inside the function.
  Stmt+ body,
  -- `decorators` is the list of decorators to be applied,
  --  stored outermost first (i.e. the first in the list will be applied last).
  Expr* decorators,
  -- `returns` is the return annotation (the thing after '->').
  Expr? returns
)

{-
This 'Element' type is nested inside 'CompareExpr' type!
See generated Swift code below.
-}
@struct CompareExpr.Element = (
  CompareExpr.Operator op,
  Expr right
)
```

Will generate:

```Swift

/// A function definition.
public final class FunctionDefStmt: Statement {
  /// `name` is a raw string of the function name.
  public var name: String
  /// `args` is a arguments node.
  public var args: Arguments
  /// `body` is the list of nodes inside the function.
  public var body: NonEmptyArray<Statement>
  /// `decorators` is the list of decorators to be applied,
  ///  stored outermost first (i.e. the first in the list will be applied last).
  public var decorators: [Expression]
  /// `returns` is the return annotation (the thing after '->').
  public var returns: Expression?
}

extension CompareExpr {
  public struct Element {
    public var op: CompareExpr.Operator
    public var right: Expression
  }
}
```

### Union types

Use `@enum` to generate Swift `enum`.

For example:

```haskell
@enum Vararg =
  none
  -- Separator for keyword arguments. Represented by just `*`.
  | unnamed
  | named(Argument)
```

Will generate:

```Swift
public enum Vararg {
  case none
  /// Separator for keyword arguments. Represented by just `*`.
  case unnamed
  case named(Argument)
}
```

Btw. *teknikly* Swift enums are not *proper* union types, but who cares.

### Alias

You can use `@alias` to rename a type.

For example:

```haskell
@alias Identifier = String

-- A class definition.
@class ClassDefStmt: Stmt = (
  -- `name` is a raw string for the class name
  Identifier name
)
```

Will generate `String` instead of `Identifier`:

```Swift
/// A class definition.
public final class ClassDefStmt: Statement {
  /// `name` is a raw string for the class name
  public var name: String
}
```
