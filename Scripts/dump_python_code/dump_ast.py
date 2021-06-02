'''
Dump AST.
This tool should be used with CPython!
'''

import ast


def dump_ast(code: str):
    root = ast.parse(code, '<string>')
    _dump(root, indent_level=0)


def _class_name(obj):
    return obj.__class__.__name__


def _create_indent(level: int) -> str:
    return ' ' * level * 2


def _dump(node: ast.AST, indent_level: int):
    node_name = _class_name(node)
    node_indent = _create_indent(indent_level)
    print(node_indent + node_name + " (node)")

    child_indent_level = indent_level + 1
    child_indent = _create_indent(child_indent_level)

    for name in node._fields:
        try:
            value = getattr(node, name)

            if isinstance(value, ast.AST):
                if value._fields:
                    print(f"{child_indent}{name} (node)")
                    _dump(value, child_indent_level + 1)
                else:
                    print(f"{child_indent}{name}: {_class_name(value)}")
            elif isinstance(value, list):
                if len(value) == 0:
                    print(f"{child_indent}{name} (list): empty")
                else:
                    print(f"{child_indent}{name} (list)")
                    for e in value:
                        if isinstance(e, ast.AST):
                            _dump(e, child_indent_level + 1)
                        else:
                            print(f"{child_indent}  {e}")
            else:
                print(f"{child_indent}{name}:", repr(value))

        except AttributeError:
            print(f"{child_indent} Unknown field: '{name}'")
            pass
