
import types as t



types = {
  object: [
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__str__',
    '__format__',
    '__class__',
    '__dir__',
    '__getattribute__',
    '__setattr__',
    '__delattr__',
    '__subclasshook__',
    '__init_subclass__',
    '__new__',
  ],
  type: [
    '__name__',
    '__qualname__',
    '__doc__',
    '__module__',
    '__bases__',
    '__dict__',
    '__class__',
    '__mro__',
    '__repr__',
    '__subclasses__',
    '__getattribute__',
    '__setattr__',
    '__delattr__',
    '__dir__',
    '__call__',
  ],
  bool: [
    '__class__',
    '__repr__',
    '__str__',
    '__and__',
    '__rand__',
    '__or__',
    '__ror__',
    '__xor__',
    '__rxor__',
    '__new__',
  ],
  t.BuiltinFunctionType: [
    '__class__',
    '__name__',
    '__qualname__',
    '__text_signature__',
    '__module__',
    '__self__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__getattribute__',
    '__call__',
  ],
  t.CodeType: [
    '__class__',
    '__eq__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
  ],
  complex: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__str__',
    '__bool__',
    '__int__',
    '__float__',
    'real',
    'imag',
    'conjugate',
    '__getattribute__',
    '__pos__',
    '__neg__',
    '__abs__',
    '__add__',
    '__radd__',
    '__sub__',
    '__rsub__',
    '__mul__',
    '__rmul__',
    '__pow__',
    '__rpow__',
    '__truediv__',
    '__rtruediv__',
    '__floordiv__',
    '__rfloordiv__',
    '__mod__',
    '__rmod__',
    '__divmod__',
    '__rdivmod__',
    '__new__',
  ],
  dict: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__getattribute__',
    '__len__',
    '__getitem__',
    '__setitem__',
    '__delitem__',
    '__contains__',
    'clear',
    'get',
    'setdefault',
    'copy',
    'pop',
    'popitem',
    '__new__',
  ],
  type(...): [
    '__class__',
    '__repr__',
    '__getattribute__',
    '__new__',
  ],
  float: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__str__',
    '__bool__',
    '__int__',
    '__float__',
    'real',
    'imag',
    'conjugate',
    '__getattribute__',
    '__pos__',
    '__neg__',
    '__abs__',
    '__add__',
    '__radd__',
    '__sub__',
    '__rsub__',
    '__mul__',
    '__rmul__',
    '__pow__',
    '__rpow__',
    '__truediv__',
    '__rtruediv__',
    '__floordiv__',
    '__rfloordiv__',
    '__mod__',
    '__rmod__',
    '__divmod__',
    '__rdivmod__',
    '__round__',
    '__trunc__',
    '__new__',
  ],
  frozenset: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__getattribute__',
    '__len__',
    '__contains__',
    '__and__',
    '__rand__',
    '__or__',
    '__ror__',
    '__xor__',
    '__rxor__',
    '__sub__',
    '__rsub__',
    'issubset',
    'issuperset',
    'intersection',
    'union',
    'difference',
    'symmetric_difference',
    'isdisjoint',
    'copy',
  ],
  t.FunctionType: [
    '__class__',
    '__name__',
    '__qualname__',
    '__code__',
    '__doc__',
    '__module__',
    '__dict__',
    '__repr__',
    '__get__',
  ],
  int: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__str__',
    '__bool__',
    '__int__',
    '__float__',
    '__index__',
    'real',
    'imag',
    'conjugate',
    'numerator',
    'denominator',
    '__getattribute__',
    '__pos__',
    '__neg__',
    '__abs__',
    '__add__',
    '__radd__',
    '__sub__',
    '__rsub__',
    '__mul__',
    '__rmul__',
    '__pow__',
    '__rpow__',
    '__truediv__',
    '__rtruediv__',
    '__floordiv__',
    '__rfloordiv__',
    '__mod__',
    '__rmod__',
    '__divmod__',
    '__rdivmod__',
    '__lshift__',
    '__rlshift__',
    '__rshift__',
    '__rrshift__',
    '__and__',
    '__rand__',
    '__or__',
    '__ror__',
    '__xor__',
    '__rxor__',
    '__invert__',
    '__round__',
    '__new__',
  ],
  list: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__repr__',
    '__getattribute__',
    '__len__',
    '__contains__',
    '__getitem__',
    'count',
    'index',
    'append',
    'pop',
    'clear',
    'copy',
    '__add__',
    '__mul__',
    '__rmul__',
    '__imul__',
    '__new__',
  ],
  t.MethodType: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__repr__',
    '__hash__',
    '__getattribute__',
    '__setattr__',
    '__delattr__',
    '__func__',
    '__self__',
    '__get__',
  ],
  t.ModuleType: [
    '__dict__',
    '__class__',
    '__repr__',
    '__getattribute__',
    '__setattr__',
    '__delattr__',
    '__dir__',
    '__new__',
  ],
  t.SimpleNamespace: [
    '__dict__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__repr__',
    '__getattribute__',
    '__setattr__',
    '__delattr__',
  ],
  type(None): [
    '__class__',
    '__repr__',
    '__bool__',
    '__new__',
  ],
  type(NotImplemented): [
    '__class__',
    '__repr__',
    '__new__',
  ],
  property: [
    '__class__',
    'fget',
    'fset',
    'fdel',
    '__getattribute__',
    '__get__',
    '__set__',
    '__delete__',
    '__new__',
  ],
  range: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__bool__',
    '__len__',
    '__getattribute__',
    '__contains__',
    '__getitem__',
    'count',
    'index',
  ],
  set: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__getattribute__',
    '__len__',
    '__contains__',
    '__and__',
    '__rand__',
    '__or__',
    '__ror__',
    '__xor__',
    '__rxor__',
    '__sub__',
    '__rsub__',
    'issubset',
    'issuperset',
    'intersection',
    'union',
    'difference',
    'symmetric_difference',
    'isdisjoint',
    'add',
    'remove',
    'discard',
    'clear',
    'copy',
    'pop',
    '__new__',
  ],
  slice: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__repr__',
    '__getattribute__',
    'indices',
  ],
  str: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__str__',
    '__getattribute__',
    '__len__',
    '__contains__',
    '__getitem__',
    'isalnum',
    'isalpha',
    'isascii',
    'isdecimal',
    'isdigit',
    'isidentifier',
    'islower',
    'isnumeric',
    'isprintable',
    'isspace',
    'istitle',
    'isupper',
    'startswith',
    'endswith',
    'strip',
    'lstrip',
    'rstrip',
    'find',
    'rfind',
    'index',
    'rindex',
    'lower',
    'upper',
    'title',
    'swapcase',
    'casefold',
    'capitalize',
    'center',
    'ljust',
    'rjust',
    'split',
    'rsplit',
    'splitlines',
    'partition',
    'rpartition',
    'expandtabs',
    'count',
    'replace',
    'zfill',
    '__add__',
    '__mul__',
    '__rmul__',
    '__new__',
  ],
  tuple: [
    '__class__',
    '__eq__',
    '__ne__',
    '__lt__',
    '__le__',
    '__gt__',
    '__ge__',
    '__hash__',
    '__repr__',
    '__getattribute__',
    '__len__',
    '__contains__',
    '__getitem__',
    'count',
    'index',
    '__add__',
    '__mul__',
    '__rmul__',
  ],
  ArithmeticError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  AssertionError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  AttributeError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  BaseException: [
    '__dict__',
    '__class__',
    'args',
    '__traceback__',
    '__cause__',
    '__context__',
    '__suppress_context__',
    '__repr__',
    '__str__',
    '__getattribute__',
    '__setattr__',
    '__delattr__',
    '__new__',
  ],
  BlockingIOError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  BrokenPipeError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  BufferError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  BytesWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ChildProcessError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ConnectionAbortedError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ConnectionError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ConnectionRefusedError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ConnectionResetError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  DeprecationWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  EOFError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  Exception: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  FileExistsError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  FileNotFoundError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  FloatingPointError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  FutureWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  GeneratorExit: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ImportError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ImportWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  IndentationError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  IndexError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  InterruptedError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  IsADirectoryError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  KeyError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  KeyboardInterrupt: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  LookupError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  MemoryError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ModuleNotFoundError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  NameError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  NotADirectoryError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  NotImplementedError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  OSError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  OverflowError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  PendingDeprecationWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  PermissionError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ProcessLookupError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  RecursionError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ReferenceError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ResourceWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  RuntimeError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  RuntimeWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  StopAsyncIteration: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  StopIteration: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  SyntaxError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  SyntaxWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  SystemError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  SystemExit: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  TabError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  TimeoutError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  TypeError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  UnboundLocalError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  UnicodeDecodeError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  UnicodeEncodeError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  UnicodeError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  UnicodeTranslateError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  UnicodeWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  UserWarning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ValueError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  Warning: [
    '__class__',
    '__dict__',
    '__new__',
  ],
  ZeroDivisionError: [
    '__class__',
    '__dict__',
    '__new__',
  ],
}
