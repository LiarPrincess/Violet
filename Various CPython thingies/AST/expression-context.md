This file shows how `expr_context` is propagated through AST.

# Definition

```c
expr_context = Load | Store | Del | AugLoad | AugStore | Param`
set_context(struct compiling *c, expr_ty e, expr_context_ty ctx, const node *n)
```

Context is also propagated to tuple/list childs!

## Store

- **Comprehension**
  - comp->target
    - Single
    - Tuple
- **Assign**
  - stmt->v.Assign.targets
    - All childs
- **AugAssign**
  - stmt->v.AugAssign.target
    - Name
    - Attribute
    - Subscript
    - _ -> illegal expression for augmented assignment
- **AnnAssign**
  - stmt->v.AnnAssign.target
    - Name
    - Attribute
    - Subscript
    - List  -> only single target (not list) can be annotated
    - Tuple -> only single target (not tuple) can be annotated
    - _     -> illegal target for annotation
- **For**
- **AsyncFor**
  - stmt->v.(Async)For.target
    - Single
    - Tuple
- **With**
- **AsyncWith**
  - item->optional_vars

## Del

- **Delete**
  - stmt->v.Delete.targets, Del

## AugLoad, AugStore

The ast defines augmented store and load contexts, but the
implementation here doesn't actually use them.

The code may be a little more complex than necessary as a result.

It also means that expressions in an augmented assignment have a Store context.

Consider restructuring so that augmented assignment uses `set_context()`, too.

## Param

Not used.
