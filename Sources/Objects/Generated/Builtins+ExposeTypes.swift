// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable file_length

// This file will add type properties to 'Builtins', so that they are exposed
// to Python runtime.
// Btw. Not all of those types should be exposed from builtins module.
// Some should require 'import types', but sice we don't have 'types' module,
// we will expose them from builtins.

extension Builtins {

  // MARK: - Types

  // sourcery: pyproperty = bool
  internal func type_bool() -> PyType {
    return Py.types.bool
  }

  // sourcery: pyproperty = builtinFunction
  internal func type_builtinFunction() -> PyType {
    return Py.types.builtinFunction
  }

  // sourcery: pyproperty = bytearray
  internal func type_bytearray() -> PyType {
    return Py.types.bytearray
  }

  // sourcery: pyproperty = bytearray_iterator
  internal func type_bytearray_iterator() -> PyType {
    return Py.types.bytearray_iterator
  }

  // sourcery: pyproperty = bytes
  internal func type_bytes() -> PyType {
    return Py.types.bytes
  }

  // sourcery: pyproperty = bytes_iterator
  internal func type_bytes_iterator() -> PyType {
    return Py.types.bytes_iterator
  }

  // sourcery: pyproperty = callable_iterator
  internal func type_callable_iterator() -> PyType {
    return Py.types.callable_iterator
  }

  // sourcery: pyproperty = code
  internal func type_code() -> PyType {
    return Py.types.code
  }

  // sourcery: pyproperty = complex
  internal func type_complex() -> PyType {
    return Py.types.complex
  }

  // sourcery: pyproperty = dict
  internal func type_dict() -> PyType {
    return Py.types.dict
  }

  // sourcery: pyproperty = dict_itemiterator
  internal func type_dict_itemiterator() -> PyType {
    return Py.types.dict_itemiterator
  }

  // sourcery: pyproperty = dict_items
  internal func type_dict_items() -> PyType {
    return Py.types.dict_items
  }

  // sourcery: pyproperty = dict_keyiterator
  internal func type_dict_keyiterator() -> PyType {
    return Py.types.dict_keyiterator
  }

  // sourcery: pyproperty = dict_keys
  internal func type_dict_keys() -> PyType {
    return Py.types.dict_keys
  }

  // sourcery: pyproperty = dict_valueiterator
  internal func type_dict_valueiterator() -> PyType {
    return Py.types.dict_valueiterator
  }

  // sourcery: pyproperty = dict_values
  internal func type_dict_values() -> PyType {
    return Py.types.dict_values
  }

  // sourcery: pyproperty = ellipsis
  internal func type_ellipsis() -> PyType {
    return Py.types.ellipsis
  }

  // sourcery: pyproperty = enumerate
  internal func type_enumerate() -> PyType {
    return Py.types.enumerate
  }

  // sourcery: pyproperty = filter
  internal func type_filter() -> PyType {
    return Py.types.filter
  }

  // sourcery: pyproperty = float
  internal func type_float() -> PyType {
    return Py.types.float
  }

  // sourcery: pyproperty = frozenset
  internal func type_frozenset() -> PyType {
    return Py.types.frozenset
  }

  // sourcery: pyproperty = function
  internal func type_function() -> PyType {
    return Py.types.function
  }

  // sourcery: pyproperty = int
  internal func type_int() -> PyType {
    return Py.types.int
  }

  // sourcery: pyproperty = iterator
  internal func type_iterator() -> PyType {
    return Py.types.iterator
  }

  // sourcery: pyproperty = list
  internal func type_list() -> PyType {
    return Py.types.list
  }

  // sourcery: pyproperty = list_iterator
  internal func type_list_iterator() -> PyType {
    return Py.types.list_iterator
  }

  // sourcery: pyproperty = list_reverseiterator
  internal func type_list_reverseiterator() -> PyType {
    return Py.types.list_reverseiterator
  }

  // sourcery: pyproperty = map
  internal func type_map() -> PyType {
    return Py.types.map
  }

  // sourcery: pyproperty = method
  internal func type_method() -> PyType {
    return Py.types.method
  }

  // sourcery: pyproperty = module
  internal func type_module() -> PyType {
    return Py.types.module
  }

  // sourcery: pyproperty = SimpleNamespace
  internal func type_simpleNamespace() -> PyType {
    return Py.types.simpleNamespace
  }

  // sourcery: pyproperty = None
  internal func type_none() -> PyType {
    return Py.types.none
  }

  // sourcery: pyproperty = NotImplemented
  internal func type_notImplemented() -> PyType {
    return Py.types.notImplemented
  }

  // sourcery: pyproperty = property
  internal func type_property() -> PyType {
    return Py.types.property
  }

  // sourcery: pyproperty = range
  internal func type_range() -> PyType {
    return Py.types.range
  }

  // sourcery: pyproperty = range_iterator
  internal func type_range_iterator() -> PyType {
    return Py.types.range_iterator
  }

  // sourcery: pyproperty = reversed
  internal func type_reversed() -> PyType {
    return Py.types.reversed
  }

  // sourcery: pyproperty = set
  internal func type_set() -> PyType {
    return Py.types.set
  }

  // sourcery: pyproperty = set_iterator
  internal func type_set_iterator() -> PyType {
    return Py.types.set_iterator
  }

  // sourcery: pyproperty = slice
  internal func type_slice() -> PyType {
    return Py.types.slice
  }

  // sourcery: pyproperty = str
  internal func type_str() -> PyType {
    return Py.types.str
  }

  // sourcery: pyproperty = str_iterator
  internal func type_str_iterator() -> PyType {
    return Py.types.str_iterator
  }

  // sourcery: pyproperty = TextFile
  internal func type_textFile() -> PyType {
    return Py.types.textFile
  }

  // sourcery: pyproperty = tuple
  internal func type_tuple() -> PyType {
    return Py.types.tuple
  }

  // sourcery: pyproperty = tuple_iterator
  internal func type_tuple_iterator() -> PyType {
    return Py.types.tuple_iterator
  }

  // sourcery: pyproperty = zip
  internal func type_zip() -> PyType {
    return Py.types.zip
  }


  // MARK: - Error types

  // sourcery: pyproperty = ArithmeticError
  internal func type_arithmeticError() -> PyType {
    return Py.errorTypes.arithmeticError
  }

  // sourcery: pyproperty = AssertionError
  internal func type_assertionError() -> PyType {
    return Py.errorTypes.assertionError
  }

  // sourcery: pyproperty = AttributeError
  internal func type_attributeError() -> PyType {
    return Py.errorTypes.attributeError
  }

  // sourcery: pyproperty = BaseException
  internal func type_baseException() -> PyType {
    return Py.errorTypes.baseException
  }

  // sourcery: pyproperty = BlockingIOError
  internal func type_blockingIOError() -> PyType {
    return Py.errorTypes.blockingIOError
  }

  // sourcery: pyproperty = BrokenPipeError
  internal func type_brokenPipeError() -> PyType {
    return Py.errorTypes.brokenPipeError
  }

  // sourcery: pyproperty = BufferError
  internal func type_bufferError() -> PyType {
    return Py.errorTypes.bufferError
  }

  // sourcery: pyproperty = BytesWarning
  internal func type_bytesWarning() -> PyType {
    return Py.errorTypes.bytesWarning
  }

  // sourcery: pyproperty = ChildProcessError
  internal func type_childProcessError() -> PyType {
    return Py.errorTypes.childProcessError
  }

  // sourcery: pyproperty = ConnectionAbortedError
  internal func type_connectionAbortedError() -> PyType {
    return Py.errorTypes.connectionAbortedError
  }

  // sourcery: pyproperty = ConnectionError
  internal func type_connectionError() -> PyType {
    return Py.errorTypes.connectionError
  }

  // sourcery: pyproperty = ConnectionRefusedError
  internal func type_connectionRefusedError() -> PyType {
    return Py.errorTypes.connectionRefusedError
  }

  // sourcery: pyproperty = ConnectionResetError
  internal func type_connectionResetError() -> PyType {
    return Py.errorTypes.connectionResetError
  }

  // sourcery: pyproperty = DeprecationWarning
  internal func type_deprecationWarning() -> PyType {
    return Py.errorTypes.deprecationWarning
  }

  // sourcery: pyproperty = EOFError
  internal func type_eofError() -> PyType {
    return Py.errorTypes.eofError
  }

  // sourcery: pyproperty = Exception
  internal func type_exception() -> PyType {
    return Py.errorTypes.exception
  }

  // sourcery: pyproperty = FileExistsError
  internal func type_fileExistsError() -> PyType {
    return Py.errorTypes.fileExistsError
  }

  // sourcery: pyproperty = FileNotFoundError
  internal func type_fileNotFoundError() -> PyType {
    return Py.errorTypes.fileNotFoundError
  }

  // sourcery: pyproperty = FloatingPointError
  internal func type_floatingPointError() -> PyType {
    return Py.errorTypes.floatingPointError
  }

  // sourcery: pyproperty = FutureWarning
  internal func type_futureWarning() -> PyType {
    return Py.errorTypes.futureWarning
  }

  // sourcery: pyproperty = GeneratorExit
  internal func type_generatorExit() -> PyType {
    return Py.errorTypes.generatorExit
  }

  // sourcery: pyproperty = ImportError
  internal func type_importError() -> PyType {
    return Py.errorTypes.importError
  }

  // sourcery: pyproperty = ImportWarning
  internal func type_importWarning() -> PyType {
    return Py.errorTypes.importWarning
  }

  // sourcery: pyproperty = IndentationError
  internal func type_indentationError() -> PyType {
    return Py.errorTypes.indentationError
  }

  // sourcery: pyproperty = IndexError
  internal func type_indexError() -> PyType {
    return Py.errorTypes.indexError
  }

  // sourcery: pyproperty = InterruptedError
  internal func type_interruptedError() -> PyType {
    return Py.errorTypes.interruptedError
  }

  // sourcery: pyproperty = IsADirectoryError
  internal func type_isADirectoryError() -> PyType {
    return Py.errorTypes.isADirectoryError
  }

  // sourcery: pyproperty = KeyError
  internal func type_keyError() -> PyType {
    return Py.errorTypes.keyError
  }

  // sourcery: pyproperty = KeyboardInterrupt
  internal func type_keyboardInterrupt() -> PyType {
    return Py.errorTypes.keyboardInterrupt
  }

  // sourcery: pyproperty = LookupError
  internal func type_lookupError() -> PyType {
    return Py.errorTypes.lookupError
  }

  // sourcery: pyproperty = MemoryError
  internal func type_memoryError() -> PyType {
    return Py.errorTypes.memoryError
  }

  // sourcery: pyproperty = ModuleNotFoundError
  internal func type_moduleNotFoundError() -> PyType {
    return Py.errorTypes.moduleNotFoundError
  }

  // sourcery: pyproperty = NameError
  internal func type_nameError() -> PyType {
    return Py.errorTypes.nameError
  }

  // sourcery: pyproperty = NotADirectoryError
  internal func type_notADirectoryError() -> PyType {
    return Py.errorTypes.notADirectoryError
  }

  // sourcery: pyproperty = NotImplementedError
  internal func type_notImplementedError() -> PyType {
    return Py.errorTypes.notImplementedError
  }

  // sourcery: pyproperty = OSError
  internal func type_osError() -> PyType {
    return Py.errorTypes.osError
  }

  // sourcery: pyproperty = OverflowError
  internal func type_overflowError() -> PyType {
    return Py.errorTypes.overflowError
  }

  // sourcery: pyproperty = PendingDeprecationWarning
  internal func type_pendingDeprecationWarning() -> PyType {
    return Py.errorTypes.pendingDeprecationWarning
  }

  // sourcery: pyproperty = PermissionError
  internal func type_permissionError() -> PyType {
    return Py.errorTypes.permissionError
  }

  // sourcery: pyproperty = ProcessLookupError
  internal func type_processLookupError() -> PyType {
    return Py.errorTypes.processLookupError
  }

  // sourcery: pyproperty = RecursionError
  internal func type_recursionError() -> PyType {
    return Py.errorTypes.recursionError
  }

  // sourcery: pyproperty = ReferenceError
  internal func type_referenceError() -> PyType {
    return Py.errorTypes.referenceError
  }

  // sourcery: pyproperty = ResourceWarning
  internal func type_resourceWarning() -> PyType {
    return Py.errorTypes.resourceWarning
  }

  // sourcery: pyproperty = RuntimeError
  internal func type_runtimeError() -> PyType {
    return Py.errorTypes.runtimeError
  }

  // sourcery: pyproperty = RuntimeWarning
  internal func type_runtimeWarning() -> PyType {
    return Py.errorTypes.runtimeWarning
  }

  // sourcery: pyproperty = StopAsyncIteration
  internal func type_stopAsyncIteration() -> PyType {
    return Py.errorTypes.stopAsyncIteration
  }

  // sourcery: pyproperty = StopIteration
  internal func type_stopIteration() -> PyType {
    return Py.errorTypes.stopIteration
  }

  // sourcery: pyproperty = SyntaxError
  internal func type_syntaxError() -> PyType {
    return Py.errorTypes.syntaxError
  }

  // sourcery: pyproperty = SyntaxWarning
  internal func type_syntaxWarning() -> PyType {
    return Py.errorTypes.syntaxWarning
  }

  // sourcery: pyproperty = SystemError
  internal func type_systemError() -> PyType {
    return Py.errorTypes.systemError
  }

  // sourcery: pyproperty = SystemExit
  internal func type_systemExit() -> PyType {
    return Py.errorTypes.systemExit
  }

  // sourcery: pyproperty = TabError
  internal func type_tabError() -> PyType {
    return Py.errorTypes.tabError
  }

  // sourcery: pyproperty = TimeoutError
  internal func type_timeoutError() -> PyType {
    return Py.errorTypes.timeoutError
  }

  // sourcery: pyproperty = TypeError
  internal func type_typeError() -> PyType {
    return Py.errorTypes.typeError
  }

  // sourcery: pyproperty = UnboundLocalError
  internal func type_unboundLocalError() -> PyType {
    return Py.errorTypes.unboundLocalError
  }

  // sourcery: pyproperty = UnicodeDecodeError
  internal func type_unicodeDecodeError() -> PyType {
    return Py.errorTypes.unicodeDecodeError
  }

  // sourcery: pyproperty = UnicodeEncodeError
  internal func type_unicodeEncodeError() -> PyType {
    return Py.errorTypes.unicodeEncodeError
  }

  // sourcery: pyproperty = UnicodeError
  internal func type_unicodeError() -> PyType {
    return Py.errorTypes.unicodeError
  }

  // sourcery: pyproperty = UnicodeTranslateError
  internal func type_unicodeTranslateError() -> PyType {
    return Py.errorTypes.unicodeTranslateError
  }

  // sourcery: pyproperty = UnicodeWarning
  internal func type_unicodeWarning() -> PyType {
    return Py.errorTypes.unicodeWarning
  }

  // sourcery: pyproperty = UserWarning
  internal func type_userWarning() -> PyType {
    return Py.errorTypes.userWarning
  }

  // sourcery: pyproperty = ValueError
  internal func type_valueError() -> PyType {
    return Py.errorTypes.valueError
  }

  // sourcery: pyproperty = Warning
  internal func type_warning() -> PyType {
    return Py.errorTypes.warning
  }

  // sourcery: pyproperty = ZeroDivisionError
  internal func type_zeroDivisionError() -> PyType {
    return Py.errorTypes.zeroDivisionError
  }
}
