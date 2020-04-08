// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// This file will add type properties to 'Builtins', so that they are exposed
// to Python runtime.
// Later 'ModuleFactory' script will pick those properties and add them to module
// '__dict__' as 'PyProperty'.
//
// Btw. Not all of those types should be exposed from builtins module.
// Some should require 'import types', but sice we don't have 'types' module,
// we will expose them from builtins.

extension Builtins {

  // MARK: - Types

  // sourcery: pyproperty = object
  internal var type_object: PyType {
    return Py.types.object
  }


  // sourcery: pyproperty = bool
  internal var type_bool: PyType {
    return Py.types.bool
  }

  // sourcery: pyproperty = bytearray
  internal var type_bytearray: PyType {
    return Py.types.bytearray
  }

  // sourcery: pyproperty = bytes
  internal var type_bytes: PyType {
    return Py.types.bytes
  }

  // sourcery: pyproperty = classmethod
  internal var type_classmethod: PyType {
    return Py.types.classmethod
  }

  // sourcery: pyproperty = complex
  internal var type_complex: PyType {
    return Py.types.complex
  }

  // sourcery: pyproperty = dict
  internal var type_dict: PyType {
    return Py.types.dict
  }

  // sourcery: pyproperty = enumerate
  internal var type_enumerate: PyType {
    return Py.types.enumerate
  }

  // sourcery: pyproperty = filter
  internal var type_filter: PyType {
    return Py.types.filter
  }

  // sourcery: pyproperty = float
  internal var type_float: PyType {
    return Py.types.float
  }

  // sourcery: pyproperty = frozenset
  internal var type_frozenset: PyType {
    return Py.types.frozenset
  }

  // sourcery: pyproperty = int
  internal var type_int: PyType {
    return Py.types.int
  }

  // sourcery: pyproperty = list
  internal var type_list: PyType {
    return Py.types.list
  }

  // sourcery: pyproperty = map
  internal var type_map: PyType {
    return Py.types.map
  }

  // sourcery: pyproperty = property
  internal var type_property: PyType {
    return Py.types.property
  }

  // sourcery: pyproperty = range
  internal var type_range: PyType {
    return Py.types.range
  }

  // sourcery: pyproperty = reversed
  internal var type_reversed: PyType {
    return Py.types.reversed
  }

  // sourcery: pyproperty = set
  internal var type_set: PyType {
    return Py.types.set
  }

  // sourcery: pyproperty = slice
  internal var type_slice: PyType {
    return Py.types.slice
  }

  // sourcery: pyproperty = staticmethod
  internal var type_staticmethod: PyType {
    return Py.types.staticmethod
  }

  // sourcery: pyproperty = str
  internal var type_str: PyType {
    return Py.types.str
  }

  // sourcery: pyproperty = super
  internal var type_super: PyType {
    return Py.types.super
  }

  // sourcery: pyproperty = tuple
  internal var type_tuple: PyType {
    return Py.types.tuple
  }

  // sourcery: pyproperty = type
  internal var type_type: PyType {
    return Py.types.type
  }

  // sourcery: pyproperty = zip
  internal var type_zip: PyType {
    return Py.types.zip
  }

  // sourcery: pyproperty = ArithmeticError
  internal var type_ArithmeticError: PyType {
    return Py.types.ArithmeticError
  }

  // sourcery: pyproperty = AssertionError
  internal var type_AssertionError: PyType {
    return Py.types.AssertionError
  }

  // sourcery: pyproperty = AttributeError
  internal var type_AttributeError: PyType {
    return Py.types.AttributeError
  }

  // sourcery: pyproperty = BaseException
  internal var type_BaseException: PyType {
    return Py.types.BaseException
  }

  // sourcery: pyproperty = BlockingIOError
  internal var type_BlockingIOError: PyType {
    return Py.types.BlockingIOError
  }

  // sourcery: pyproperty = BrokenPipeError
  internal var type_BrokenPipeError: PyType {
    return Py.types.BrokenPipeError
  }

  // sourcery: pyproperty = BufferError
  internal var type_BufferError: PyType {
    return Py.types.BufferError
  }

  // sourcery: pyproperty = BytesWarning
  internal var type_BytesWarning: PyType {
    return Py.types.BytesWarning
  }

  // sourcery: pyproperty = ChildProcessError
  internal var type_ChildProcessError: PyType {
    return Py.types.ChildProcessError
  }

  // sourcery: pyproperty = ConnectionAbortedError
  internal var type_ConnectionAbortedError: PyType {
    return Py.types.ConnectionAbortedError
  }

  // sourcery: pyproperty = ConnectionError
  internal var type_ConnectionError: PyType {
    return Py.types.ConnectionError
  }

  // sourcery: pyproperty = ConnectionRefusedError
  internal var type_ConnectionRefusedError: PyType {
    return Py.types.ConnectionRefusedError
  }

  // sourcery: pyproperty = ConnectionResetError
  internal var type_ConnectionResetError: PyType {
    return Py.types.ConnectionResetError
  }

  // sourcery: pyproperty = DeprecationWarning
  internal var type_DeprecationWarning: PyType {
    return Py.types.DeprecationWarning
  }

  // sourcery: pyproperty = EOFError
  internal var type_EOFError: PyType {
    return Py.types.EOFError
  }

  // sourcery: pyproperty = Exception
  internal var type_Exception: PyType {
    return Py.types.Exception
  }

  // sourcery: pyproperty = FileExistsError
  internal var type_FileExistsError: PyType {
    return Py.types.FileExistsError
  }

  // sourcery: pyproperty = FileNotFoundError
  internal var type_FileNotFoundError: PyType {
    return Py.types.FileNotFoundError
  }

  // sourcery: pyproperty = FloatingPointError
  internal var type_FloatingPointError: PyType {
    return Py.types.FloatingPointError
  }

  // sourcery: pyproperty = FutureWarning
  internal var type_FutureWarning: PyType {
    return Py.types.FutureWarning
  }

  // sourcery: pyproperty = GeneratorExit
  internal var type_GeneratorExit: PyType {
    return Py.types.GeneratorExit
  }

  // sourcery: pyproperty = ImportError
  internal var type_ImportError: PyType {
    return Py.types.ImportError
  }

  // sourcery: pyproperty = ImportWarning
  internal var type_ImportWarning: PyType {
    return Py.types.ImportWarning
  }

  // sourcery: pyproperty = IndentationError
  internal var type_IndentationError: PyType {
    return Py.types.IndentationError
  }

  // sourcery: pyproperty = IndexError
  internal var type_IndexError: PyType {
    return Py.types.IndexError
  }

  // sourcery: pyproperty = InterruptedError
  internal var type_InterruptedError: PyType {
    return Py.types.InterruptedError
  }

  // sourcery: pyproperty = IsADirectoryError
  internal var type_IsADirectoryError: PyType {
    return Py.types.IsADirectoryError
  }

  // sourcery: pyproperty = KeyError
  internal var type_KeyError: PyType {
    return Py.types.KeyError
  }

  // sourcery: pyproperty = KeyboardInterrupt
  internal var type_KeyboardInterrupt: PyType {
    return Py.types.KeyboardInterrupt
  }

  // sourcery: pyproperty = LookupError
  internal var type_LookupError: PyType {
    return Py.types.LookupError
  }

  // sourcery: pyproperty = MemoryError
  internal var type_MemoryError: PyType {
    return Py.types.MemoryError
  }

  // sourcery: pyproperty = ModuleNotFoundError
  internal var type_ModuleNotFoundError: PyType {
    return Py.types.ModuleNotFoundError
  }

  // sourcery: pyproperty = NameError
  internal var type_NameError: PyType {
    return Py.types.NameError
  }

  // sourcery: pyproperty = NotADirectoryError
  internal var type_NotADirectoryError: PyType {
    return Py.types.NotADirectoryError
  }

  // sourcery: pyproperty = NotImplementedError
  internal var type_NotImplementedError: PyType {
    return Py.types.NotImplementedError
  }

  // sourcery: pyproperty = OSError
  internal var type_OSError: PyType {
    return Py.types.OSError
  }

  // sourcery: pyproperty = OverflowError
  internal var type_OverflowError: PyType {
    return Py.types.OverflowError
  }

  // sourcery: pyproperty = PendingDeprecationWarning
  internal var type_PendingDeprecationWarning: PyType {
    return Py.types.PendingDeprecationWarning
  }

  // sourcery: pyproperty = PermissionError
  internal var type_PermissionError: PyType {
    return Py.types.PermissionError
  }

  // sourcery: pyproperty = ProcessLookupError
  internal var type_ProcessLookupError: PyType {
    return Py.types.ProcessLookupError
  }

  // sourcery: pyproperty = RecursionError
  internal var type_RecursionError: PyType {
    return Py.types.RecursionError
  }

  // sourcery: pyproperty = ReferenceError
  internal var type_ReferenceError: PyType {
    return Py.types.ReferenceError
  }

  // sourcery: pyproperty = ResourceWarning
  internal var type_ResourceWarning: PyType {
    return Py.types.ResourceWarning
  }

  // sourcery: pyproperty = RuntimeError
  internal var type_RuntimeError: PyType {
    return Py.types.RuntimeError
  }

  // sourcery: pyproperty = RuntimeWarning
  internal var type_RuntimeWarning: PyType {
    return Py.types.RuntimeWarning
  }

  // sourcery: pyproperty = StopAsyncIteration
  internal var type_StopAsyncIteration: PyType {
    return Py.types.StopAsyncIteration
  }

  // sourcery: pyproperty = StopIteration
  internal var type_StopIteration: PyType {
    return Py.types.StopIteration
  }

  // sourcery: pyproperty = SyntaxError
  internal var type_SyntaxError: PyType {
    return Py.types.SyntaxError
  }

  // sourcery: pyproperty = SyntaxWarning
  internal var type_SyntaxWarning: PyType {
    return Py.types.SyntaxWarning
  }

  // sourcery: pyproperty = SystemError
  internal var type_SystemError: PyType {
    return Py.types.SystemError
  }

  // sourcery: pyproperty = SystemExit
  internal var type_SystemExit: PyType {
    return Py.types.SystemExit
  }

  // sourcery: pyproperty = TabError
  internal var type_TabError: PyType {
    return Py.types.TabError
  }

  // sourcery: pyproperty = TimeoutError
  internal var type_TimeoutError: PyType {
    return Py.types.TimeoutError
  }

  // sourcery: pyproperty = TypeError
  internal var type_TypeError: PyType {
    return Py.types.TypeError
  }

  // sourcery: pyproperty = UnboundLocalError
  internal var type_UnboundLocalError: PyType {
    return Py.types.UnboundLocalError
  }

  // sourcery: pyproperty = UnicodeDecodeError
  internal var type_UnicodeDecodeError: PyType {
    return Py.types.UnicodeDecodeError
  }

  // sourcery: pyproperty = UnicodeEncodeError
  internal var type_UnicodeEncodeError: PyType {
    return Py.types.UnicodeEncodeError
  }

  // sourcery: pyproperty = UnicodeError
  internal var type_UnicodeError: PyType {
    return Py.types.UnicodeError
  }

  // sourcery: pyproperty = UnicodeTranslateError
  internal var type_UnicodeTranslateError: PyType {
    return Py.types.UnicodeTranslateError
  }

  // sourcery: pyproperty = UnicodeWarning
  internal var type_UnicodeWarning: PyType {
    return Py.types.UnicodeWarning
  }

  // sourcery: pyproperty = UserWarning
  internal var type_UserWarning: PyType {
    return Py.types.UserWarning
  }

  // sourcery: pyproperty = ValueError
  internal var type_ValueError: PyType {
    return Py.types.ValueError
  }

  // sourcery: pyproperty = Warning
  internal var type_Warning: PyType {
    return Py.types.Warning
  }

  // sourcery: pyproperty = ZeroDivisionError
  internal var type_ZeroDivisionError: PyType {
    return Py.types.ZeroDivisionError
  }

}
