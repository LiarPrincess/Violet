# Use this command: grep -r "_Py_IDENTIFIER" .
# We also added unary, binary and ternary operators.
ids = [
  '__abs__',
  '__abstractmethods__',
  '__add__',
  '__aiter__',
  '__and__',
  '__anext__',
  '__await__',
  '__bases__',
  '__bool__',
  '__build_class__',
  '__builtins__',
  '__bytes__',
  '__call__',
  '__class__',
  '__class_getitem__',
  '__classcell__',
  '__complex__',
  '__contains__',
  '__del__',
  '__delattr__',
  '__delete__',
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
  '__format__',
  '__ge__',
  '__get__',
  '__getattr__',
  '__getattribute__',
  '__getitem__',
  '__getnewargs__',
  '__getnewargs_ex__',
  '__getstate__',
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
  '__length_hint__',
  '__loader__',
  '__lshift__',
  '__lt__',
  '__matmul__',
  '__missing__',
  '__mod__',
  '__module__',
  '__mro_entries__',
  '__mul__',
  '__name__',
  '__ne__',
  '__neg__',
  '__new__',
  '__newobj__',
  '__newobj_ex__',
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
  '__reduce__',
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
  '__slotnames__',
  '__slots__',
  '__spec__',
  '__str__',
  '__sub__',
  '__subclasscheck__',
  '__subclasshook__',
  '__truediv__',
  '__trunc__',
  '__xor__',
  '_imp',
  '_slotnames',
  'big',
  'builtins',
  'close',
  'copy',
  'copyreg',
  'difference_update',
  'fileno',
  'foo',
  'get',
  'getattr',
  'intersection_update',
  'items',
  'keys',
  'little',
  'metaclass',
  'mro',
  'n_fields',
  'n_sequence_fields',
  'n_unnamed_fields',
  'name',
  'open',
  'origin',
  'path',
  'Py_Repr',
  'readline',
  'sorted',
  'special',
  'symmetric_difference_update',
  'sys',
  'throw',
  'update',
  'values',
  'varname',
  'write'
]

# ----
# Main
# ----

def escaped(s):
  return '`throw`' if id == 'throw' else id

if __name__ == '__main__':
  print('''\
// swiftlint:disable file_length

/// Predefined commonly used `__dict__` keys.
/// Similiar to `_Py_IDENTIFIER` in `CPython`.
///
/// Performance of this 'cache' (because that what it actually is)
/// is crucial for overall performance.
/// Even using a dictionary (with its `O(1) + massive constants` access)
/// may be too slow.
/// We will do it in a bit different way with approximate complexity between
/// 'it will be inlined anyway' and 'hello cache, my old friend'.
///
/// We also need to support cleaning for when `Py` gets destroyed.
public struct IdString {

  internal let value: PyString
  internal let hash: PyHash

  fileprivate init(value: String) {
    self.value = Py.newString(value)
    self.hash = self.value.hashRaw()
  }

  private static var _impl: IdStringImpl?
  private static var impl: IdStringImpl {
    if let i = Self._impl { return i }

    let i = IdStringImpl()
    Self._impl = i
    return i
  }

  /// Clean when `Py` gets destroyed.
  internal static func gcClean() {
    Self._impl = nil
  }
''')

  for id in ids:
    print(f'  public static let {escaped(id)} = Self.impl.{escaped(id)}')

  print('}')

  # Impl
  print('private struct IdStringImpl {')

  for id in ids:
    print(f'  fileprivate let {escaped(id)} = IdString(value: "{id}")')

  print('}')
