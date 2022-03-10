from typing import List

# Based on:
# > CPython->Lib->test->exception_hierarchy.txt

class ErrorInfo:
    def __init__(self, type_name: str, base_type_name: str, doc: str):
        self.type_name = type_name
        self.base_type_name = base_type_name
        self.doc = doc


data: List[ErrorInfo] = [
    ErrorInfo('BaseException', 'Object', "Common base class for all exceptions"),
    ErrorInfo('SystemExit', 'BaseException', "Request to exit from the interpreter."),
    ErrorInfo('KeyboardInterrupt', 'BaseException', "Program interrupted by user."),
    ErrorInfo('GeneratorExit', 'BaseException', "Request that a generator exit."),
    # Exception
    ErrorInfo('Exception', 'BaseException', "Common base class for all non-exit exceptions."),
    ErrorInfo('StopIteration', 'Exception', "Signal the end from iterator.__next__()."),
    ErrorInfo('StopAsyncIteration', 'Exception', "Signal the end from iterator.__anext__()."),
    # ArithmeticError
    ErrorInfo('ArithmeticError', 'Exception', "Base class for arithmetic errors."),
    ErrorInfo('FloatingPointError', 'ArithmeticError', "Floating point operation failed."),
    ErrorInfo('OverflowError', 'ArithmeticError', "Result too large to be represented."),
    ErrorInfo('ZeroDivisionError', 'ArithmeticError', "Second argument to a division or modulo operation was zero."),
    # ...
    ErrorInfo('AssertionError', 'Exception', "Assertion failed."),
    ErrorInfo('AttributeError', 'Exception', "Attribute not found."),
    ErrorInfo('BufferError', 'Exception', "Buffer error."),
    ErrorInfo('EOFError', 'Exception', "Read beyond end of file."),
    # ImportError
    ErrorInfo('ImportError', 'Exception', "Import can't find module, or can't find name in module."),
    ErrorInfo('ModuleNotFoundError', 'ImportError', "Module not found."),
    # LookupError
    ErrorInfo('LookupError', 'Exception', "Base class for lookup errors."),
    ErrorInfo('IndexError', 'LookupError', "Sequence index out of range."),
    ErrorInfo('KeyError', 'LookupError', "Mapping key not found."),
    # ...
    ErrorInfo('MemoryError', 'Exception', "Out of memory."),
    # NameError
    ErrorInfo('NameError', 'Exception', "Name not found globally."),
    ErrorInfo('UnboundLocalError', 'NameError', "Local name referenced but not bound to a value."),
    # OSError
    ErrorInfo('OSError', 'Exception', "Base class for I/O related errors."),
    ErrorInfo('BlockingIOError', 'OSError', "I/O operation would block."),
    ErrorInfo('ChildProcessError', 'OSError', "Child process error."),
    ErrorInfo('ConnectionError', 'OSError', "Connection error."),
    ErrorInfo('BrokenPipeError', 'ConnectionError', "Broken pipe."),
    ErrorInfo('ConnectionAbortedError', 'ConnectionError', "Connection aborted."),
    ErrorInfo('ConnectionRefusedError', 'ConnectionError', "Connection refused."),
    ErrorInfo('ConnectionResetError', 'ConnectionError', "Connection reset."),
    ErrorInfo('FileExistsError', 'OSError', "File already exists."),
    ErrorInfo('FileNotFoundError', 'OSError', "File not found."),
    ErrorInfo('InterruptedError', 'OSError', "Interrupted by signal."),
    ErrorInfo('IsADirectoryError', 'OSError', "Operation doesn't work on directories."),
    ErrorInfo('NotADirectoryError', 'OSError', "Operation only works on directories."),
    ErrorInfo('PermissionError', 'OSError', "Not enough permissions."),
    ErrorInfo('ProcessLookupError', 'OSError', "Process not found."),
    ErrorInfo('TimeoutError', 'OSError', "Timeout expired."),
    # ...
    ErrorInfo('ReferenceError', 'Exception', "Weak ref proxy used after referent went away."),
    # RuntimeError
    ErrorInfo('RuntimeError', 'Exception', "Unspecified run-time error."),
    ErrorInfo('NotImplementedError', 'RuntimeError', "Method or function hasn't been implemented yet."),
    ErrorInfo('RecursionError', 'RuntimeError', "Recursion limit exceeded."),
    # SyntaxError
    ErrorInfo('SyntaxError', 'Exception', "Invalid syntax."),
    ErrorInfo('IndentationError', 'SyntaxError', "Improper indentation."),
    ErrorInfo('TabError', 'IndentationError', "Improper mixture of spaces and tabs."),
    # ...
    ErrorInfo('SystemError', 'Exception', "Internal error in the Python interpreter.\n\nPlease report this to the Python maintainer, along with the traceback,\nthe Python version, and the hardware/OS platform and version."),
    ErrorInfo('TypeError', 'Exception', "Inappropriate argument type."),
    ErrorInfo('ValueError', 'Exception', "Inappropriate argument value (of correct type)."),
    # UnicodeError
    ErrorInfo('UnicodeError', 'ValueError', "Unicode related error."),
    ErrorInfo('UnicodeDecodeError', 'UnicodeError', "Unicode decoding error."),
    ErrorInfo('UnicodeEncodeError', 'UnicodeError', "Unicode encoding error."),
    ErrorInfo('UnicodeTranslateError', 'UnicodeError', "Unicode translation error."),
    # Warning
    ErrorInfo('Warning', 'Exception', "Base class for warning categories."),
    ErrorInfo('DeprecationWarning', 'Warning', "Base class for warnings about deprecated features."),
    ErrorInfo('PendingDeprecationWarning', 'Warning', "Base class for warnings about features which will be deprecated\nin the future."),
    ErrorInfo('RuntimeWarning', 'Warning', "Base class for warnings about dubious runtime behavior."),
    ErrorInfo('SyntaxWarning', 'Warning', "Base class for warnings about dubious syntax."),
    ErrorInfo('UserWarning', 'Warning', "Base class for warnings generated by user code."),
    ErrorInfo('FutureWarning', 'Warning', "Base class for warnings about constructs that will change semantically\nin the future."),
    ErrorInfo('ImportWarning', 'Warning', "Base class for warnings about probable mistakes in module imports"),
    ErrorInfo('UnicodeWarning', 'Warning', "Base class for warnings about Unicode related problems, mostly\nrelated to conversion problems."),
    ErrorInfo('BytesWarning', 'Warning', "Base class for warnings about bytes and buffer related problems, mostly\nrelated to conversion from str or comparing to str."),
    ErrorInfo('ResourceWarning', 'Warning', "Base class for warnings about resource usage."),
]
