import _io
import types
import inspect
import collections
from typing import Any, NamedTuple, Set


def get_type(name: str) -> type:
    if name == 'object':
        return object

    if name == 'bool':
        return bool

    if name == 'builtinFunction':
        return types.BuiltinFunctionType

    if name == 'builtinMethod':
        return types.BuiltinMethodType

    if name == 'bytearray':
        return bytearray

    if name == 'bytearray_iterator':
        return type(iter(bytearray()))

    if name == 'bytes':
        return bytes

    if name == 'bytes_iterator':
        return type(iter(b''))

    if name == 'callable_iterator':
        return type(iter(str, None))

    if name == 'classmethod':
        return classmethod

    if name == 'code':
        return types.CodeType

    if name == 'complex':
        return complex

    if name == 'dict':
        return dict

    if name == 'dict_itemiterator':
        return type(iter({}.items()))

    if name == 'dict_items':
        return type({}.items())

    if name == 'dict_keyiterator':
        return type(iter({}.keys()))

    if name == 'dict_keys':
        return type({}.keys())

    if name == 'dict_valueiterator':
        return type(iter({}.values()))

    if name == 'dict_values':
        return type({}.values())

    if name == 'ellipsis':
        return type(...)

    if name == 'enumerate':
        return enumerate

    if name == 'filter':
        return filter

    if name == 'float':
        return float

    if name == 'frame':
        return types.FrameType

    if name == 'frozenset':
        return frozenset

    if name == 'function':
        return types.FunctionType

    if name == 'int':
        return int

    if name == 'iterator':
        return collections.Iterator

    if name == 'list':
        return list

    if name == 'list_iterator':
        return type(iter([]))

    if name == 'list_reverseiterator':
        return type(reversed([]))

    if name == 'map':
        return map

    if name == 'method':
        return types.MethodType

    if name == 'module':
        return types.ModuleType

    if name == 'SimpleNamespace':
        return types.SimpleNamespace

    if name == 'NoneType':
        return type(None)

    if name == 'NotImplementedType':
        return type(NotImplemented)

    if name == 'property':
        return property

    if name == 'range':
        return range

    if name == 'range_iterator':
        return type(iter(range(1)))

    if name == 'reversed':
        return reversed

    if name == 'set':
        return set

    if name == 'set_iterator':
        return type(iter({1}))

    if name == 'slice':
        return slice

    if name == 'staticmethod':
        return staticmethod

    if name == 'str':
        return str

    if name == 'str_iterator':
        return type(iter(''))

    if name == 'super':
        return super

    if name == 'TextFile':
        # We don't have '_io' module.
        # Instead we use custom 'builtins.TextFile' based on '_io.TextIOWrapper'.
        return _io.TextIOWrapper

    if name == 'traceback':
        return types.TracebackType

    if name == 'tuple':
        return tuple

    if name == 'tuple_iterator':
        return type(iter(()))

    if name == 'type':
        return type

    if name == 'zip':
        return zip

    if name == 'ArithmeticError':
        return ArithmeticError

    if name == 'AssertionError':
        return AssertionError

    if name == 'AttributeError':
        return AttributeError

    if name == 'BaseException':
        return BaseException

    if name == 'BlockingIOError':
        return BlockingIOError

    if name == 'BrokenPipeError':
        return BrokenPipeError

    if name == 'BufferError':
        return BufferError

    if name == 'BytesWarning':
        return BytesWarning

    if name == 'ChildProcessError':
        return ChildProcessError

    if name == 'ConnectionAbortedError':
        return ConnectionAbortedError

    if name == 'ConnectionError':
        return ConnectionError

    if name == 'ConnectionRefusedError':
        return ConnectionRefusedError

    if name == 'ConnectionResetError':
        return ConnectionResetError

    if name == 'DeprecationWarning':
        return DeprecationWarning

    if name == 'EOFError':
        return EOFError

    if name == 'Exception':
        return Exception

    if name == 'FileExistsError':
        return FileExistsError

    if name == 'FileNotFoundError':
        return FileNotFoundError

    if name == 'FloatingPointError':
        return FloatingPointError

    if name == 'FutureWarning':
        return FutureWarning

    if name == 'GeneratorExit':
        return GeneratorExit

    if name == 'ImportError':
        return ImportError

    if name == 'ImportWarning':
        return ImportWarning

    if name == 'IndentationError':
        return IndentationError

    if name == 'IndexError':
        return IndexError

    if name == 'InterruptedError':
        return InterruptedError

    if name == 'IsADirectoryError':
        return IsADirectoryError

    if name == 'KeyError':
        return KeyError

    if name == 'KeyboardInterrupt':
        return KeyboardInterrupt

    if name == 'LookupError':
        return LookupError

    if name == 'MemoryError':
        return MemoryError

    if name == 'ModuleNotFoundError':
        return ModuleNotFoundError

    if name == 'NameError':
        return NameError

    if name == 'NotADirectoryError':
        return NotADirectoryError

    if name == 'NotImplementedError':
        return NotImplementedError

    if name == 'OSError':
        return OSError

    if name == 'OverflowError':
        return OverflowError

    if name == 'PendingDeprecationWarning':
        return PendingDeprecationWarning

    if name == 'PermissionError':
        return PermissionError

    if name == 'ProcessLookupError':
        return ProcessLookupError

    if name == 'RecursionError':
        return RecursionError

    if name == 'ReferenceError':
        return ReferenceError

    if name == 'ResourceWarning':
        return ResourceWarning

    if name == 'RuntimeError':
        return RuntimeError

    if name == 'RuntimeWarning':
        return RuntimeWarning

    if name == 'StopAsyncIteration':
        return StopAsyncIteration

    if name == 'StopIteration':
        return StopIteration

    if name == 'SyntaxError':
        return SyntaxError

    if name == 'SyntaxWarning':
        return SyntaxWarning

    if name == 'SystemError':
        return SystemError

    if name == 'SystemExit':
        return SystemExit

    if name == 'TabError':
        return TabError

    if name == 'TimeoutError':
        return TimeoutError

    if name == 'TypeError':
        return TypeError

    if name == 'UnboundLocalError':
        return UnboundLocalError

    if name == 'UnicodeDecodeError':
        return UnicodeDecodeError

    if name == 'UnicodeEncodeError':
        return UnicodeEncodeError

    if name == 'UnicodeError':
        return UnicodeError

    if name == 'UnicodeTranslateError':
        return UnicodeTranslateError

    if name == 'UnicodeWarning':
        return UnicodeWarning

    if name == 'UserWarning':
        return UserWarning

    if name == 'ValueError':
        return ValueError

    if name == 'Warning':
        return Warning

    if name == 'ZeroDivisionError':
        return ZeroDivisionError

    raise ValueError(f"Unknown type '{name}'")


class PythonEntry(NamedTuple):
    name: str
    value: Any

    def __hash__(self) -> int:
        return hash(self.name)

    def __eq__(self, o: object) -> bool:
        if isinstance(o, str):
            return self.name == o

        if isinstance(o, PythonEntry):
            return self.name == o.name

        return False


class PythonType(NamedTuple):
    names: Set[PythonEntry]
    derived_names: Set[PythonEntry]


def get_python_type(name: str) -> PythonType:
    t = get_type(name)

    names: Set[str] = set()
    derived_names: Set[str] = set()

    for name, member in inspect.getmembers(t):
        is_method = hasattr(member, '__objclass__')
        is_derived_name = is_method and not (member.__objclass__ == t)
        entry = PythonEntry(name, member)

        if is_derived_name:
            derived_names.add(entry)
        else:
            names.add(entry)

    result = PythonType(names, derived_names)
    return result
