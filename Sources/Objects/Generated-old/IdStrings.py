from Common.strings import generated_warning

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

# ----
# Main
# ----


def field_name(s):
    return '_' + s


def escaped(s):
    return '`throw`' if id == 'throw' else id


if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// Predefined commonly used `__dict__` keys.
/// Similar to `_Py_IDENTIFIER` in `CPython`.
///
/// Performance of this 'cache' (because that what it actually is)
/// is crucial for overall performance.
/// Even using a dictionary (with its `O(1) + massive constants` access)
/// may be too slow.
/// We will do it in a bit different way with approximate complexity between
/// 'it will be inlined anyway' and 'hello cache, my old friend'.
///
/// We also need to support cleaning for when `Py` gets destroyed.
public struct IdString {{

  internal let value: PyString
  // 'hash' is cached on 'str', but by storing it on 'IdString' we can avoid
  // memory fetch.
  internal let hash: PyHash

  fileprivate init(value: String) {{
    self.value = Py.newString(value)
    self.hash = self.value.hash()
  }}\
''')

    # ==================
    # === Initialize ===
    # ==================

    print('''
  // MARK: - Initialize

  /// Create new set of `ids`.
  internal static func initialize() {\
''')

    for id in ids:
        print(f'    Self.{field_name(id)} = IdString(value: "{id}")')

    print('  }')

    # ==========
    # === GC ===
    # ==========

    print('''
  // MARK: - GC

  /// Clean when `Py` gets destroyed.
  internal static func gcClean() {\
''')

    for id in ids:
        print(f'    Self.{field_name(id)} = nil')

    print('  }')

    # ===========
    # === Ids ===
    # ===========

    print('''
  private static func nilPropertyMessage(id: String) -> String {
    return "Missing 'IdString.\(id)' " +
           "Are you trying to use IdStrings without initializing 'Py'?"
  }\
''')

    for id in ids:
        print(f'''
  // MARK: - {id}

  private static var {field_name(id)}: IdString!
  public static var {escaped(id)}: IdString {{
    precondition(Self.{field_name(id)} != nil, nilPropertyMessage(id: "{id})"))
    return Self.{field_name(id)}!
  }}\
''')

    print('}')
