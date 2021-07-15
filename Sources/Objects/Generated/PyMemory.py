from typing import Dict, Optional

from Common.strings import generated_warning
from Sourcery import get_types, TypeInfo, SwiftInitInfo

# Types for which we want to generate 'new' function
implemented_types = (
    'PyNone',  # Basic
    'PyEllipsis',
    'PyNamespace',
    'PyNotImplemented',
    'PyBool',
    'PyInt',
    'PyFloat',
    'PyComplex',
    'PyType',  # Type and object
    'PyObject',
    'PyList',  # List
    'PyListIterator',
    'PyListReverseIterator',
    'PyTuple',  # Tuple
    'PyTupleIterator',
    'PyDict',  # Dict
    'PyDictItemIterator',
    'PyDictItems',
    'PyDictKeyIterator',
    'PyDictKeys',
    'PyDictValueIterator',
    'PyDictValues',
    'PyFrozenSet',  # Set
    'PySet',
    'PySetIterator',
    'PyIterator',  # Iterators
    'PyCallableIterator',
    'PyReversed',
    'PyRange',  # Range
    'PyRangeIterator',
    'PySlice',  # Slice
    'PyEnumerate',  # Enumerate, map, filter, zip
    'PyMap',
    'PyFilter',
    'PyZip',
    'PyString',  # String
    'PyStringIterator',
    'PyBytes',  # Bytes
    'PyBytesIterator',
    'PyByteArray',
    'PyByteArrayIterator',
    'PyTextFile',
    'PyBuiltinFunction',  # Function/method
    'PyBuiltinMethod',
    'PyFunction',
    'PyMethod',
    'PyClassMethod',
    'PyStaticMethod',
    'PyProperty',  # Property
    'PyCode',  # Code/frame
    'PyFrame',
    'PyCell',
    'PyModule',
    'PySuper',  # Super
    'PyBaseException',  # Exceptions
    'PySystemExit',
    'PyKeyboardInterrupt',
    'PyGeneratorExit',
    'PyException',
    'PyStopIteration',
    'PyStopAsyncIteration',
    'PyArithmeticError',
    'PyFloatingPointError',
    'PyOverflowError',
    'PyZeroDivisionError',
    'PyAssertionError',
    'PyAttributeError',
    'PyBufferError',
    'PyEOFError',
    'PyImportError',
    'PyModuleNotFoundError',
    'PyLookupError',
    'PyIndexError',
    'PyKeyError',
    'PyMemoryError',
    'PyNameError',
    'PyUnboundLocalError',
    'PyOSError',
    'PyBlockingIOError',
    'PyChildProcessError',
    'PyConnectionError',
    'PyBrokenPipeError',
    'PyConnectionAbortedError',
    'PyConnectionRefusedError',
    'PyConnectionResetError',
    'PyFileExistsError',
    'PyFileNotFoundError',
    'PyInterruptedError',
    'PyIsADirectoryError',
    'PyNotADirectoryError',
    'PyPermissionError',
    'PyProcessLookupError',
    'PyTimeoutError',
    'PyReferenceError',
    'PyRuntimeError',
    'PyNotImplementedError',
    'PyRecursionError',
    'PySyntaxError',
    'PyIndentationError',
    'PyTabError',
    'PySystemError',
    'PyTypeError',
    'PyValueError',
    'PyUnicodeError',
    'PyUnicodeDecodeError',
    'PyUnicodeEncodeError',
    'PyUnicodeTranslateError',
    'PyWarning',  # Warnings
    'PyDeprecationWarning',
    'PyPendingDeprecationWarning',
    'PyRuntimeWarning',
    'PySyntaxWarning',
    'PyUserWarning',
    'PyFutureWarning',
    'PyImportWarning',
    'PyUnicodeWarning',
    'PyBytesWarning',
    'PyResourceWarning',
)


def get_initializers(types_by_swift_name: Dict[str, TypeInfo], t: TypeInfo) -> SwiftInitInfo:
    "If we do not have any 'initializers' then try parent"

    current_type: Optional[TypeInfo] = t
    while current_type:
        if current_type.swift_initializers:
            return current_type.swift_initializers

        base_type_name = current_type.swift_base_type_name
        if base_type_name:
            current_type = types_by_swift_name[base_type_name]
        else:
            current_type = None

    assert False, 'Unable to find init for:' + t.swift_type_name


def print_new_function(t: TypeInfo, i: SwiftInitInfo):
    if not i.is_open_public_internal:
        return

    swift_type = t.swift_type_name
    swift_type_without_py = swift_type[2:]
    python_type = t.python_type_name
    init_arguments = i.arguments

    additional_docs = ''

    is_object_init_without_arguments = python_type == 'object' and not init_arguments
    has_metatype_arg = any(map(lambda a: a.name == 'metatype', init_arguments))
    is_type_init_without_type_argument = python_type == 'type' and not has_metatype_arg

    if is_object_init_without_arguments or is_type_init_without_type_argument:
        additional_docs = '''\
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.\
'''

    print(f'  /// Allocate new instance of `{python_type}` type.')
    if additional_docs:
        print(additional_docs)

    print(f'  {i.access_modifier} static func new{swift_type_without_py}(')

    for index, arg in enumerate(init_arguments):
        is_last = index == len(init_arguments) - 1
        comma = '' if is_last else ','

        label = ''
        if arg.label:
            label = arg.label + ' '

        print(f'    {label}{arg.name}: {arg.typ}{comma}')

    print(f'  ) -> {swift_type} {{')
    print(f'    return {swift_type}(')

    for index, arg in enumerate(init_arguments):
        is_last = index == len(init_arguments) - 1
        comma = '' if is_last else ','
        label = arg.label or arg.name
        print(f'      {label}: {arg.name}{comma}')

    print(f'    )')  # Init end
    print('  }')  # Function end
    print()


if __name__ == '__main__':
    all_types = get_types()

    types_by_swift_name = {}
    for t in all_types:
        name = t.swift_type_name
        types_by_swift_name[name] = t

    print(f'''\
{generated_warning(__file__)}

import Foundation
import BigInt
import VioletCore
import VioletBytecode
import VioletCompiler

// swiftlint:disable function_parameter_count
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

/// Helper type for allocating new object instances.
///
/// Please note that with every call of `new` method a new Python object will be
/// allocated! It will not reuse existing instances or do any fancy checks.
/// This is basically the same thing as calling `init` on Swift type.
internal enum PyMemory {{
''')

    for t in all_types:
        if t.swift_type_name not in implemented_types:
            continue

        swift_type = t.swift_type_name
        swift_type_without_py = swift_type[2:]

        print(f'  // MARK: - {swift_type_without_py}')
        print()

        initializers = get_initializers(types_by_swift_name, t)
        for i in initializers:
            print_new_function(t, i)

    print('}')  # Type end
