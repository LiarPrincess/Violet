// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable function_body_length

// ModuleFactory is based on pre-specialization (partial application)
// of function to module object and then wrapping remaining function.
//
// So, for example:
//   Builtins.add :: (self: Builtins) -> (left: PyObject, right: PyObject) -> Result
// would be specialized to 'Builtins' instance giving us:
//   add :: (left: PyObject, right: PyObject) -> Result
// which would be wrapped and exposed to Python runtime.
//
// So when you are working on Python 'builtins' you are actually working on
// (Scooby-Doo reveal incomming...)
// 'Py.builtins' object (which gives us stateful modules).
// (and we would have gotten away with it without you meddling kids!)
// https://www.youtube.com/watch?v=b4JLLv1lE7A

private func addBoring(dict: PyDict, name: String, value: PyObject) {
  let interned = Py.getInterned(name)
  dict.setItem(at: interned, to: value)
}

internal enum ModuleFactory {

  // MARK: - Builtins

  internal static func createBuiltins(from object: Builtins) -> PyModule {
    let result = PyModule(name: "builtins", doc: nil)
    let dict = result.getDict()

    addBoring(dict: dict, name: "None", value: object.none)
    addBoring(dict: dict, name: "Ellipsis", value: object.ellipsis)
    addBoring(dict: dict, name: "...", value: object.ellipsisDots)
    addBoring(dict: dict, name: "NotImplemented", value: object.notImplemented)
    addBoring(dict: dict, name: "True", value: object.`true`)
    addBoring(dict: dict, name: "False", value: object.`false`)
    addBoring(dict: dict, name: "object", value: object.type_object)
    addBoring(dict: dict, name: "type", value: object.type_type)
    addBoring(dict: dict, name: "bool", value: object.type_bool)
    addBoring(dict: dict, name: "bytearray", value: object.type_bytearray)
    addBoring(dict: dict, name: "bytes", value: object.type_bytes)
    addBoring(dict: dict, name: "complex", value: object.type_complex)
    addBoring(dict: dict, name: "dict", value: object.type_dict)
    addBoring(dict: dict, name: "enumerate", value: object.type_enumerate)
    addBoring(dict: dict, name: "filter", value: object.type_filter)
    addBoring(dict: dict, name: "float", value: object.type_float)
    addBoring(dict: dict, name: "frozenset", value: object.type_frozenset)
    addBoring(dict: dict, name: "int", value: object.type_int)
    addBoring(dict: dict, name: "list", value: object.type_list)
    addBoring(dict: dict, name: "map", value: object.type_map)
    addBoring(dict: dict, name: "property", value: object.type_property)
    addBoring(dict: dict, name: "range", value: object.type_range)
    addBoring(dict: dict, name: "reversed", value: object.type_reversed)
    addBoring(dict: dict, name: "set", value: object.type_set)
    addBoring(dict: dict, name: "slice", value: object.type_slice)
    addBoring(dict: dict, name: "str", value: object.type_str)
    addBoring(dict: dict, name: "tuple", value: object.type_tuple)
    addBoring(dict: dict, name: "zip", value: object.type_zip)
    addBoring(dict: dict, name: "ArithmeticError", value: object.type_arithmeticError)
    addBoring(dict: dict, name: "AssertionError", value: object.type_assertionError)
    addBoring(dict: dict, name: "AttributeError", value: object.type_attributeError)
    addBoring(dict: dict, name: "BaseException", value: object.type_baseException)
    addBoring(dict: dict, name: "BlockingIOError", value: object.type_blockingIOError)
    addBoring(dict: dict, name: "BrokenPipeError", value: object.type_brokenPipeError)
    addBoring(dict: dict, name: "BufferError", value: object.type_bufferError)
    addBoring(dict: dict, name: "BytesWarning", value: object.type_bytesWarning)
    addBoring(dict: dict, name: "ChildProcessError", value: object.type_childProcessError)
    addBoring(dict: dict, name: "ConnectionAbortedError", value: object.type_connectionAbortedError)
    addBoring(dict: dict, name: "ConnectionError", value: object.type_connectionError)
    addBoring(dict: dict, name: "ConnectionRefusedError", value: object.type_connectionRefusedError)
    addBoring(dict: dict, name: "ConnectionResetError", value: object.type_connectionResetError)
    addBoring(dict: dict, name: "DeprecationWarning", value: object.type_deprecationWarning)
    addBoring(dict: dict, name: "EOFError", value: object.type_eofError)
    addBoring(dict: dict, name: "Exception", value: object.type_exception)
    addBoring(dict: dict, name: "FileExistsError", value: object.type_fileExistsError)
    addBoring(dict: dict, name: "FileNotFoundError", value: object.type_fileNotFoundError)
    addBoring(dict: dict, name: "FloatingPointError", value: object.type_floatingPointError)
    addBoring(dict: dict, name: "FutureWarning", value: object.type_futureWarning)
    addBoring(dict: dict, name: "GeneratorExit", value: object.type_generatorExit)
    addBoring(dict: dict, name: "ImportError", value: object.type_importError)
    addBoring(dict: dict, name: "ImportWarning", value: object.type_importWarning)
    addBoring(dict: dict, name: "IndentationError", value: object.type_indentationError)
    addBoring(dict: dict, name: "IndexError", value: object.type_indexError)
    addBoring(dict: dict, name: "InterruptedError", value: object.type_interruptedError)
    addBoring(dict: dict, name: "IsADirectoryError", value: object.type_isADirectoryError)
    addBoring(dict: dict, name: "KeyError", value: object.type_keyError)
    addBoring(dict: dict, name: "KeyboardInterrupt", value: object.type_keyboardInterrupt)
    addBoring(dict: dict, name: "LookupError", value: object.type_lookupError)
    addBoring(dict: dict, name: "MemoryError", value: object.type_memoryError)
    addBoring(dict: dict, name: "ModuleNotFoundError", value: object.type_moduleNotFoundError)
    addBoring(dict: dict, name: "NameError", value: object.type_nameError)
    addBoring(dict: dict, name: "NotADirectoryError", value: object.type_notADirectoryError)
    addBoring(dict: dict, name: "NotImplementedError", value: object.type_notImplementedError)
    addBoring(dict: dict, name: "OSError", value: object.type_osError)
    addBoring(dict: dict, name: "OverflowError", value: object.type_overflowError)
    addBoring(dict: dict, name: "PendingDeprecationWarning", value: object.type_pendingDeprecationWarning)
    addBoring(dict: dict, name: "PermissionError", value: object.type_permissionError)
    addBoring(dict: dict, name: "ProcessLookupError", value: object.type_processLookupError)
    addBoring(dict: dict, name: "RecursionError", value: object.type_recursionError)
    addBoring(dict: dict, name: "ReferenceError", value: object.type_referenceError)
    addBoring(dict: dict, name: "ResourceWarning", value: object.type_resourceWarning)
    addBoring(dict: dict, name: "RuntimeError", value: object.type_runtimeError)
    addBoring(dict: dict, name: "RuntimeWarning", value: object.type_runtimeWarning)
    addBoring(dict: dict, name: "StopAsyncIteration", value: object.type_stopAsyncIteration)
    addBoring(dict: dict, name: "StopIteration", value: object.type_stopIteration)
    addBoring(dict: dict, name: "SyntaxError", value: object.type_syntaxError)
    addBoring(dict: dict, name: "SyntaxWarning", value: object.type_syntaxWarning)
    addBoring(dict: dict, name: "SystemError", value: object.type_systemError)
    addBoring(dict: dict, name: "SystemExit", value: object.type_systemExit)
    addBoring(dict: dict, name: "TabError", value: object.type_tabError)
    addBoring(dict: dict, name: "TimeoutError", value: object.type_timeoutError)
    addBoring(dict: dict, name: "TypeError", value: object.type_typeError)
    addBoring(dict: dict, name: "UnboundLocalError", value: object.type_unboundLocalError)
    addBoring(dict: dict, name: "UnicodeDecodeError", value: object.type_unicodeDecodeError)
    addBoring(dict: dict, name: "UnicodeEncodeError", value: object.type_unicodeEncodeError)
    addBoring(dict: dict, name: "UnicodeError", value: object.type_unicodeError)
    addBoring(dict: dict, name: "UnicodeTranslateError", value: object.type_unicodeTranslateError)
    addBoring(dict: dict, name: "UnicodeWarning", value: object.type_unicodeWarning)
    addBoring(dict: dict, name: "UserWarning", value: object.type_userWarning)
    addBoring(dict: dict, name: "ValueError", value: object.type_valueError)
    addBoring(dict: dict, name: "Warning", value: object.type_warning)
    addBoring(dict: dict, name: "ZeroDivisionError", value: object.type_zeroDivisionError)


    addBoring(dict: dict, name: "abs", value: PyBuiltinFunction.wrap(name: "abs", doc: nil, fn: object.abs(_:), module: result))
    addBoring(dict: dict, name: "any", value: PyBuiltinFunction.wrap(name: "any", doc: nil, fn: object.any(iterable:), module: result))
    addBoring(dict: dict, name: "all", value: PyBuiltinFunction.wrap(name: "all", doc: nil, fn: object.all(iterable:), module: result))
    addBoring(dict: dict, name: "sum", value: PyBuiltinFunction.wrap(name: "sum", doc: nil, fn: object.sum(args:kwargs:), module: result))
    addBoring(dict: dict, name: "isinstance", value: PyBuiltinFunction.wrap(name: "isinstance", doc: nil, fn: object.isInstance(object:of:), module: result))
    addBoring(dict: dict, name: "issubclass", value: PyBuiltinFunction.wrap(name: "issubclass", doc: nil, fn: object.isSubclass(object:of:), module: result))
    addBoring(dict: dict, name: "next", value: PyBuiltinFunction.wrap(name: "next", doc: nil, fn: object.next(iterator:default:), module: result))
    addBoring(dict: dict, name: "iter", value: PyBuiltinFunction.wrap(name: "iter", doc: nil, fn: object.iter(from:sentinel:), module: result))
    addBoring(dict: dict, name: "bin", value: PyBuiltinFunction.wrap(name: "bin", doc: nil, fn: object.bin(_:), module: result))
    addBoring(dict: dict, name: "oct", value: PyBuiltinFunction.wrap(name: "oct", doc: nil, fn: object.oct(_:), module: result))
    addBoring(dict: dict, name: "hex", value: PyBuiltinFunction.wrap(name: "hex", doc: nil, fn: object.hex(_:), module: result))
    addBoring(dict: dict, name: "chr", value: PyBuiltinFunction.wrap(name: "chr", doc: nil, fn: object.chr(_:), module: result))
    addBoring(dict: dict, name: "ord", value: PyBuiltinFunction.wrap(name: "ord", doc: nil, fn: object.ord(_:), module: result))
    addBoring(dict: dict, name: "__build_class__", value: PyBuiltinFunction.wrap(name: "__build_class__", doc: nil, fn: object.buildClass(args:kwargs:), module: result))
    addBoring(dict: dict, name: "hash", value: PyBuiltinFunction.wrap(name: "hash", doc: nil, fn: object.hash(_:), module: result))
    addBoring(dict: dict, name: "id", value: PyBuiltinFunction.wrap(name: "id", doc: nil, fn: object.id(_:), module: result))
    addBoring(dict: dict, name: "dir", value: PyBuiltinFunction.wrap(name: "dir", doc: nil, fn: object.dir(_:), module: result))
    addBoring(dict: dict, name: "repr", value: PyBuiltinFunction.wrap(name: "repr", doc: nil, fn: object.repr(_:), module: result))
    addBoring(dict: dict, name: "ascii", value: PyBuiltinFunction.wrap(name: "ascii", doc: nil, fn: object.ascii(_:), module: result))
    addBoring(dict: dict, name: "len", value: PyBuiltinFunction.wrap(name: "len", doc: nil, fn: object.length(iterable:), module: result))
    addBoring(dict: dict, name: "sorted", value: PyBuiltinFunction.wrap(name: "sorted", doc: nil, fn: object.sorted(args:kwargs:), module: result))
    addBoring(dict: dict, name: "callable", value: PyBuiltinFunction.wrap(name: "callable", doc: nil, fn: object.isCallable(_:), module: result))
    addBoring(dict: dict, name: "__import__", value: PyBuiltinFunction.wrap(name: "__import__", doc: nil, fn: object.__import__(args:kwargs:), module: result))
    addBoring(dict: dict, name: "round", value: PyBuiltinFunction.wrap(name: "round", doc: nil, fn: object.round(number:nDigits:), module: result))
    addBoring(dict: dict, name: "divmod", value: PyBuiltinFunction.wrap(name: "divmod", doc: nil, fn: object.divmod(left:right:), module: result))
    addBoring(dict: dict, name: "pow", value: PyBuiltinFunction.wrap(name: "pow", doc: nil, fn: object.pow(base:exp:mod:), module: result))
    addBoring(dict: dict, name: "print", value: PyBuiltinFunction.wrap(name: "print", doc: nil, fn: object.print(args:kwargs:), module: result))
    addBoring(dict: dict, name: "open", value: PyBuiltinFunction.wrap(name: "open", doc: nil, fn: object.open(args:kwargs:), module: result))
    addBoring(dict: dict, name: "getattr", value: PyBuiltinFunction.wrap(name: "getattr", doc: nil, fn: object.getAttribute(_:name:default:), module: result))
    addBoring(dict: dict, name: "hasattr", value: PyBuiltinFunction.wrap(name: "hasattr", doc: nil, fn: object.hasAttribute(_:name:), module: result))
    addBoring(dict: dict, name: "setattr", value: PyBuiltinFunction.wrap(name: "setattr", doc: nil, fn: object.setAttribute(_:name:value:), module: result))
    addBoring(dict: dict, name: "delattr", value: PyBuiltinFunction.wrap(name: "delattr", doc: nil, fn: object.deleteAttribute(_:name:), module: result))
    addBoring(dict: dict, name: "min", value: PyBuiltinFunction.wrap(name: "min", doc: nil, fn: object.min(args:kwargs:), module: result))
    addBoring(dict: dict, name: "max", value: PyBuiltinFunction.wrap(name: "max", doc: nil, fn: object.max(args:kwargs:), module: result))

    return result
  }

  // MARK: - Sys

  internal static func createSys(from object: Sys) -> PyModule {
    let result = PyModule(name: "sys", doc: nil)
    let dict = result.getDict()


    addBoring(dict: dict, name: "stdin", value: PyProperty.wrap(name: "stdin", doc: nil, get: object.getStdin, set: object.setStdin))
    addBoring(dict: dict, name: "__stdin__", value: PyProperty.wrap(name: "__stdin__", doc: nil, get: object.get__stdin__))
    addBoring(dict: dict, name: "stdout", value: PyProperty.wrap(name: "stdout", doc: nil, get: object.getStdout, set: object.setStdout))
    addBoring(dict: dict, name: "__stdout__", value: PyProperty.wrap(name: "__stdout__", doc: nil, get: object.get__stdout__))
    addBoring(dict: dict, name: "stderr", value: PyProperty.wrap(name: "stderr", doc: nil, get: object.getStderr, set: object.setStderr))
    addBoring(dict: dict, name: "__stderr__", value: PyProperty.wrap(name: "__stderr__", doc: nil, get: object.get__stderr__))
    addBoring(dict: dict, name: "ps1", value: PyProperty.wrap(name: "ps1", doc: nil, get: object.getPS1, set: object.setPS1))
    addBoring(dict: dict, name: "ps2", value: PyProperty.wrap(name: "ps2", doc: nil, get: object.getPS2, set: object.setPS2))
    addBoring(dict: dict, name: "platform", value: PyProperty.wrap(name: "platform", doc: nil, get: object.getPlatform))
    addBoring(dict: dict, name: "copyright", value: PyProperty.wrap(name: "copyright", doc: nil, get: object.getCopyright))
    addBoring(dict: dict, name: "version", value: PyProperty.wrap(name: "version", doc: nil, get: object.getVersion))
    addBoring(dict: dict, name: "version_info", value: PyProperty.wrap(name: "version_info", doc: nil, get: object.getVersionInfo))
    addBoring(dict: dict, name: "implementation", value: PyProperty.wrap(name: "implementation", doc: nil, get: object.getImplementation))
    addBoring(dict: dict, name: "hash_info", value: PyProperty.wrap(name: "hash_info", doc: nil, get: object.getHashInfo))


    return result
  }
}
