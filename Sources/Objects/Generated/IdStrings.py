from Helpers import generated_warning, escape_swift_keyword

# Use: grep -r "_Py_IDENTIFIER".
# We also added unary, binary and ternary operators.
# If some line is commented then it means that
# this id is not (yet) used.
ids = [
    '__abs__',
    # '__abstractmethods__',
    '__add__',
    # '__aiter__',
    '__all__',
    '__and__',
    # '__anext__',
    '__annotations__',
    # '__await__',
    # '__bases__',
    '__bool__',
    '__build_class__',
    '__builtins__',
    # '__bytes__',
    '__call__',
    '__class__',
    '__class_getitem__',
    '__classcell__',
    '__complex__',
    '__contains__',
    '__del__',
    '__delattr__',
    # '__delete__',
    '__delitem__',
    '__dict__',
    '__dir__',
    '__divmod__',
    '__doc__',
    '__enter__',
    '__eq__',
    '__exit__',
    '__file__',
    '__float__',
    '__floordiv__',
    # '__format__',
    '__ge__',
    '__get__',
    '__getattr__',
    '__getattribute__',
    '__getitem__',
    # '__getnewargs__',
    # '__getnewargs_ex__',
    # '__getstate__',
    '__gt__',
    '__hash__',
    '__iadd__',
    '__iand__',
    '__idivmod__',
    '__ifloordiv__',
    '__ilshift__',
    '__imatmul__',
    '__imod__',
    '__import__',
    '__imul__',
    '__index__',
    '__init__',
    '__init_subclass__',
    '__instancecheck__',
    '__int__',
    '__invert__',
    '__ior__',
    '__ipow__',
    '__irshift__',
    '__isabstractmethod__',
    '__isub__',
    '__iter__',
    '__itruediv__',
    '__ixor__',
    '__le__',
    '__len__',
    # '__length_hint__',
    '__loader__',
    '__lshift__',
    '__lt__',
    '__matmul__',
    '__missing__',
    '__mod__',
    '__module__',
    # '__mro_entries__',
    '__mul__',
    '__name__',
    '__ne__',
    '__neg__',
    '__new__',
    # '__newobj__',
    # '__newobj_ex__',
    '__next__',
    '__or__',
    '__package__',
    '__path__',
    '__pos__',
    '__pow__',
    '__prepare__',
    '__qualname__',
    '__radd__',
    '__rand__',
    '__rdivmod__',
    # '__reduce__',
    '__repr__',
    '__reversed__',
    '__rfloordiv__',
    '__rlshift__',
    '__rmatmul__',
    '__rmod__',
    '__rmul__',
    '__ror__',
    '__round__',
    '__rpow__',
    '__rrshift__',
    '__rshift__',
    '__rsub__',
    '__rtruediv__',
    '__rxor__',
    '__set__',
    '__set_name__',
    '__setattr__',
    '__setitem__',
    # '__slotnames__',
    # '__slots__',
    '__spec__',
    '__str__',
    '__sub__',
    '__subclasscheck__',
    # '__subclasshook__',
    '__truediv__',
    '__trunc__',
    '__warningregistry__',
    '__xor__',
    '_find_and_load',
    '_handle_fromlist',
    # '_imp',
    # '_onceregistry',
    # '_slotnames',
    # 'argv',
    # 'big',
    # 'builtin_module_names',
    'builtins',
    # 'close',
    # 'copy',
    # 'copyreg',
    # 'defaultaction',
    # 'difference_update',
    'encoding',
    # 'exec_prefix',
    # 'executable',
    # 'filename',
    # 'fileno',
    # 'filters',
    # 'flags',
    # 'get',
    # 'getattr',
    # 'getdefaultencoding',
    # 'hexversion',
    # 'implementation',
    # 'intersection_update',
    # 'items',
    'keys',
    # 'lineno',
    # 'little',
    # 'meta_path',
    'metaclass',
    'mro',
    # 'n_fields',
    # 'n_sequence_fields',
    # 'n_unnamed_fields',
    'name',
    'object',
    # 'offset',
    # 'open',
    'origin',
    # 'Py_Repr',
    # 'readline',
    # 'sorted',
    # 'special',
    # 'symmetric_difference_update',
    # 'sys',
    # 'text',
    # 'throw',
    # 'update',
    # 'values',
    # 'varname',
    # 'warnoptions',
    # 'write'
]

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

import VioletCore

// swiftlint:disable nesting
// swiftlint:disable function_body_length

/// Predefined commonly used `__dict__` keys.
/// Similar to `_Py_IDENTIFIER` in `CPython`.
///
/// Performance of this 'cache' (because that what it actually is)
/// is crucial for overall performance.
/// Even using a dictionary (with its `O(1) + massive constants` access)
/// may be too slow.
///
/// Use `py.resolve(id:)` to convert to `PyString`.
public struct IdString: CustomStringConvertible {{

  private let index: Int

  private init(index: Int) {{
    self.index = index
  }}
''')

    # ==========================
    # === Static properties ====
    # ==========================

    for index, id in enumerate(ids):
        print(f'  public static let {id} = IdString(index: {index})')

    print()

    # ====================
    # === Description ====
    # ====================

    print('  public var description: String {')
    print('    switch self.index {')

    for index, id in enumerate(ids):
        print(f'    case {index}: return "{id}"')

    print('    default: trap("Unexpected IdString index: \(self.index).")')
    print('    }')
    print('  }')
    print()

    # ===================
    # === Collection ====
    # ===================

    print('  internal struct Collection: Sequence {')
    print()
    print('    internal typealias Element = IdString')
    print()
    print('    private let objects: [PyString]')
    print()
    print('    internal subscript(id: IdString) -> PyString {')
    print('      return self.objects[id.index]')
    print('    }')
    print()
    print('    internal init(_ py: Py) {')
    print('      self.objects = [')

    for index, id in enumerate(ids):
        is_last = index == len(ids) - 1
        comma = '' if is_last else ','
        print(f'        py.newString("{id}"){comma}')

    print(f'      ]')
    print(f'    }}')
    print()
    print(f'    internal struct Iterator: IteratorProtocol {{')
    print()
    print(f'      private var index = -1')
    print()
    print(f'      mutating func next() -> IdString? {{')
    print(f'        if self.index == {len(ids) - 1} {{')
    print(f'          return nil')
    print(f'        }}')
    print()
    print(f'        self.index += 1')
    print(f'        return IdString(index: self.index)')
    print(f'      }}')
    print(f'    }}') # ITerator
    print()
    print(f'    internal func makeIterator() -> Iterator {{')
    print(f'      return Iterator()')
    print(f'    }}')
    print(f'  }}')

    # ============
    # === End ====
    # ============

    print('}')
