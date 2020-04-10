}
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
  internal var type_arithmeticError: PyType {
    return Py.types.arithmeticError
  }

  // sourcery: pyproperty = AssertionError
  internal var type_assertionError: PyType {
    return Py.types.assertionError
  }

  // sourcery: pyproperty = AttributeError
  internal var type_attributeError: PyType {
    return Py.types.attributeError
  }

  // sourcery: pyproperty = BaseException
  internal var type_baseException: PyType {
    return Py.types.baseException
  }

  // sourcery: pyproperty = BlockingIOError
  internal var type_blockingIOError: PyType {
    return Py.types.blockingIOError
  }

  // sourcery: pyproperty = BrokenPipeError
  internal var type_brokenPipeError: PyType {
    return Py.types.brokenPipeError
  }

  // sourcery: pyproperty = BufferError
  internal var type_bufferError: PyType {
    return Py.types.bufferError
  }

  // sourcery: pyproperty = BytesWarning
  internal var type_bytesWarning: PyType {
    return Py.types.bytesWarning
  }

  // sourcery: pyproperty = ChildProcessError
  internal var type_childProcessError: PyType {
    return Py.types.childProcessError
  }

  // sourcery: pyproperty = ConnectionAbortedError
  internal var type_connectionAbortedError: PyType {
    return Py.types.connectionAbortedError
  }

  // sourcery: pyproperty = ConnectionError
  internal var type_connectionError: PyType {
    return Py.types.connectionError
  }

  // sourcery: pyproperty = ConnectionRefusedError
  internal var type_connectionRefusedError: PyType {
    return Py.types.connectionRefusedError
  }

  // sourcery: pyproperty = ConnectionResetError
  internal var type_connectionResetError: PyType {
    return Py.types.connectionResetError
  }

  // sourcery: pyproperty = DeprecationWarning
  internal var type_deprecationWarning: PyType {
    return Py.types.deprecationWarning
  }

  // sourcery: pyproperty = EOFError
  internal var type_eofError: PyType {
    return Py.types.eofError
  }

  // sourcery: pyproperty = Exception
  internal var type_exception: PyType {
    return Py.types.exception
  }

  // sourcery: pyproperty = FileExistsError
  internal var type_fileExistsError: PyType {
    return Py.types.fileExistsError
  }

  // sourcery: pyproperty = FileNotFoundError
  internal var type_fileNotFoundError: PyType {
    return Py.types.fileNotFoundError
  }

  // sourcery: pyproperty = FloatingPointError
  internal var type_floatingPointError: PyType {
    return Py.types.floatingPointError
  }

  // sourcery: pyproperty = FutureWarning
  internal var type_futureWarning: PyType {
    return Py.types.futureWarning
  }

  // sourcery: pyproperty = GeneratorExit
  internal var type_generatorExit: PyType {
    return Py.types.generatorExit
  }

  // sourcery: pyproperty = ImportError
  internal var type_importError: PyType {
    return Py.types.importError
  }

  // sourcery: pyproperty = ImportWarning
  internal var type_importWarning: PyType {
    return Py.types.importWarning
  }

  // sourcery: pyproperty = IndentationError
  internal var type_indentationError: PyType {
    return Py.types.indentationError
  }

  // sourcery: pyproperty = IndexError
  internal var type_indexError: PyType {
    return Py.types.indexError
  }

  // sourcery: pyproperty = InterruptedError
  internal var type_interruptedError: PyType {
    return Py.types.interruptedError
  }

  // sourcery: pyproperty = IsADirectoryError
  internal var type_isADirectoryError: PyType {
    return Py.types.isADirectoryError
  }

  // sourcery: pyproperty = KeyError
  internal var type_keyError: PyType {
    return Py.types.keyError
  }

  // sourcery: pyproperty = KeyboardInterrupt
  internal var type_keyboardInterrupt: PyType {
    return Py.types.keyboardInterrupt
  }

  // sourcery: pyproperty = LookupError
  internal var type_lookupError: PyType {
    return Py.types.lookupError
  }

  // sourcery: pyproperty = MemoryError
  internal var type_memoryError: PyType {
    return Py.types.memoryError
  }

  // sourcery: pyproperty = ModuleNotFoundError
  internal var type_moduleNotFoundError: PyType {
    return Py.types.moduleNotFoundError
  }

  // sourcery: pyproperty = NameError
  internal var type_nameError: PyType {
    return Py.types.nameError
  }

  // sourcery: pyproperty = NotADirectoryError
  internal var type_notADirectoryError: PyType {
    return Py.types.notADirectoryError
  }

  // sourcery: pyproperty = NotImplementedError
  internal var type_notImplementedError: PyType {
    return Py.types.notImplementedError
  }

  // sourcery: pyproperty = OSError
  internal var type_osError: PyType {
    return Py.types.osError
  }

  // sourcery: pyproperty = OverflowError
  internal var type_overflowError: PyType {
    return Py.types.overflowError
  }

  // sourcery: pyproperty = PendingDeprecationWarning
  internal var type_pendingDeprecationWarning: PyType {
    return Py.types.pendingDeprecationWarning
  }

  // sourcery: pyproperty = PermissionError
  internal var type_permissionError: PyType {
    return Py.types.permissionError
  }

  // sourcery: pyproperty = ProcessLookupError
  internal var type_processLookupError: PyType {
    return Py.types.processLookupError
  }

  // sourcery: pyproperty = RecursionError
  internal var type_recursionError: PyType {
    return Py.types.recursionError
  }

  // sourcery: pyproperty = ReferenceError
  internal var type_referenceError: PyType {
    return Py.types.referenceError
  }

  // sourcery: pyproperty = ResourceWarning
  internal var type_resourceWarning: PyType {
    return Py.types.resourceWarning
  }

  // sourcery: pyproperty = RuntimeError
  internal var type_runtimeError: PyType {
    return Py.types.runtimeError
  }

  // sourcery: pyproperty = RuntimeWarning
  internal var type_runtimeWarning: PyType {
    return Py.types.runtimeWarning
  }

  // sourcery: pyproperty = StopAsyncIteration
  internal var type_stopAsyncIteration: PyType {
    return Py.types.stopAsyncIteration
  }

  // sourcery: pyproperty = StopIteration
  internal var type_stopIteration: PyType {
    return Py.types.stopIteration
  }

  // sourcery: pyproperty = SyntaxError
  internal var type_syntaxError: PyType {
    return Py.types.syntaxError
  }

  // sourcery: pyproperty = SyntaxWarning
  internal var type_syntaxWarning: PyType {
    return Py.types.syntaxWarning
  }

  // sourcery: pyproperty = SystemError
  internal var type_systemError: PyType {
    return Py.types.systemError
  }

  // sourcery: pyproperty = SystemExit
  internal var type_systemExit: PyType {
    return Py.types.systemExit
  }

  // sourcery: pyproperty = TabError
  internal var type_tabError: PyType {
    return Py.types.tabError
  }

  // sourcery: pyproperty = TimeoutError
  internal var type_timeoutError: PyType {
    return Py.types.timeoutError
  }

  // sourcery: pyproperty = TypeError
  internal var type_typeError: PyType {
    return Py.types.typeError
  }

  // sourcery: pyproperty = UnboundLocalError
  internal var type_unboundLocalError: PyType {
    return Py.types.unboundLocalError
  }

  // sourcery: pyproperty = UnicodeDecodeError
  internal var type_unicodeDecodeError: PyType {
    return Py.types.unicodeDecodeError
  }

  // sourcery: pyproperty = UnicodeEncodeError
  internal var type_unicodeEncodeError: PyType {
    return Py.types.unicodeEncodeError
  }

  // sourcery: pyproperty = UnicodeError
  internal var type_unicodeError: PyType {
    return Py.types.unicodeError
  }

  // sourcery: pyproperty = UnicodeTranslateError
  internal var type_unicodeTranslateError: PyType {
    return Py.types.unicodeTranslateError
  }

  // sourcery: pyproperty = UnicodeWarning
  internal var type_unicodeWarning: PyType {
    return Py.types.unicodeWarning
  }

  // sourcery: pyproperty = UserWarning
  internal var type_userWarning: PyType {
    return Py.types.userWarning
  }

  // sourcery: pyproperty = ValueError
  internal var type_valueError: PyType {
    return Py.types.valueError
  }

  // sourcery: pyproperty = Warning
  internal var type_warning: PyType {
    return Py.types.warning
  }

  // sourcery: pyproperty = ZeroDivisionError
  internal var type_zeroDivisionError: PyType {
    return Py.types.zeroDivisionError
  }

}
