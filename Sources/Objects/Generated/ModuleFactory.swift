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

internal enum ModuleFactory {

  // MARK: - Builtins

  internal static func createBuiltins(from object: Builtins) -> PyModule {
    let result = PyModule(name: "builtins", doc: nil)
    let dict = result.getDict()

    dict["None"] = object.none
    dict["Ellipsis"] = object.ellipsis
    dict["..."] = object.ellipsisDots
    dict["NotImplemented"] = object.notImplemented
    dict["True"] = object.`true`
    dict["False"] = object.`false`
    dict["object"] = object.type_object
    dict["type"] = object.type_type
    dict["bool"] = object.type_bool
    dict["bytearray"] = object.type_bytearray
    dict["bytes"] = object.type_bytes
    dict["complex"] = object.type_complex
    dict["dict"] = object.type_dict
    dict["enumerate"] = object.type_enumerate
    dict["filter"] = object.type_filter
    dict["float"] = object.type_float
    dict["frozenset"] = object.type_frozenset
    dict["int"] = object.type_int
    dict["list"] = object.type_list
    dict["map"] = object.type_map
    dict["property"] = object.type_property
    dict["range"] = object.type_range
    dict["reversed"] = object.type_reversed
    dict["set"] = object.type_set
    dict["slice"] = object.type_slice
    dict["str"] = object.type_str
    dict["tuple"] = object.type_tuple
    dict["zip"] = object.type_zip
    dict["ArithmeticError"] = object.type_arithmeticError
    dict["AssertionError"] = object.type_assertionError
    dict["AttributeError"] = object.type_attributeError
    dict["BaseException"] = object.type_baseException
    dict["BlockingIOError"] = object.type_blockingIOError
    dict["BrokenPipeError"] = object.type_brokenPipeError
    dict["BufferError"] = object.type_bufferError
    dict["BytesWarning"] = object.type_bytesWarning
    dict["ChildProcessError"] = object.type_childProcessError
    dict["ConnectionAbortedError"] = object.type_connectionAbortedError
    dict["ConnectionError"] = object.type_connectionError
    dict["ConnectionRefusedError"] = object.type_connectionRefusedError
    dict["ConnectionResetError"] = object.type_connectionResetError
    dict["DeprecationWarning"] = object.type_deprecationWarning
    dict["EOFError"] = object.type_eofError
    dict["Exception"] = object.type_exception
    dict["FileExistsError"] = object.type_fileExistsError
    dict["FileNotFoundError"] = object.type_fileNotFoundError
    dict["FloatingPointError"] = object.type_floatingPointError
    dict["FutureWarning"] = object.type_futureWarning
    dict["GeneratorExit"] = object.type_generatorExit
    dict["ImportError"] = object.type_importError
    dict["ImportWarning"] = object.type_importWarning
    dict["IndentationError"] = object.type_indentationError
    dict["IndexError"] = object.type_indexError
    dict["InterruptedError"] = object.type_interruptedError
    dict["IsADirectoryError"] = object.type_isADirectoryError
    dict["KeyError"] = object.type_keyError
    dict["KeyboardInterrupt"] = object.type_keyboardInterrupt
    dict["LookupError"] = object.type_lookupError
    dict["MemoryError"] = object.type_memoryError
    dict["ModuleNotFoundError"] = object.type_moduleNotFoundError
    dict["NameError"] = object.type_nameError
    dict["NotADirectoryError"] = object.type_notADirectoryError
    dict["NotImplementedError"] = object.type_notImplementedError
    dict["OSError"] = object.type_osError
    dict["OverflowError"] = object.type_overflowError
    dict["PendingDeprecationWarning"] = object.type_pendingDeprecationWarning
    dict["PermissionError"] = object.type_permissionError
    dict["ProcessLookupError"] = object.type_processLookupError
    dict["RecursionError"] = object.type_recursionError
    dict["ReferenceError"] = object.type_referenceError
    dict["ResourceWarning"] = object.type_resourceWarning
    dict["RuntimeError"] = object.type_runtimeError
    dict["RuntimeWarning"] = object.type_runtimeWarning
    dict["StopAsyncIteration"] = object.type_stopAsyncIteration
    dict["StopIteration"] = object.type_stopIteration
    dict["SyntaxError"] = object.type_syntaxError
    dict["SyntaxWarning"] = object.type_syntaxWarning
    dict["SystemError"] = object.type_systemError
    dict["SystemExit"] = object.type_systemExit
    dict["TabError"] = object.type_tabError
    dict["TimeoutError"] = object.type_timeoutError
    dict["TypeError"] = object.type_typeError
    dict["UnboundLocalError"] = object.type_unboundLocalError
    dict["UnicodeDecodeError"] = object.type_unicodeDecodeError
    dict["UnicodeEncodeError"] = object.type_unicodeEncodeError
    dict["UnicodeError"] = object.type_unicodeError
    dict["UnicodeTranslateError"] = object.type_unicodeTranslateError
    dict["UnicodeWarning"] = object.type_unicodeWarning
    dict["UserWarning"] = object.type_userWarning
    dict["ValueError"] = object.type_valueError
    dict["Warning"] = object.type_warning
    dict["ZeroDivisionError"] = object.type_zeroDivisionError


    dict["abs"] = PyBuiltinFunction.wrap(name: "abs", doc: nil, fn: object.abs(_:), module: result)
    dict["any"] = PyBuiltinFunction.wrap(name: "any", doc: nil, fn: object.any(iterable:), module: result)
    dict["all"] = PyBuiltinFunction.wrap(name: "all", doc: nil, fn: object.all(iterable:), module: result)
    dict["sum"] = PyBuiltinFunction.wrap(name: "sum", doc: nil, fn: object.sum(args:kwargs:), module: result)
    dict["isinstance"] = PyBuiltinFunction.wrap(name: "isinstance", doc: nil, fn: object.isInstance(object:of:), module: result)
    dict["issubclass"] = PyBuiltinFunction.wrap(name: "issubclass", doc: nil, fn: object.isSubclass(object:of:), module: result)
    dict["next"] = PyBuiltinFunction.wrap(name: "next", doc: nil, fn: object.next(iterator:default:), module: result)
    dict["iter"] = PyBuiltinFunction.wrap(name: "iter", doc: nil, fn: object.iter(from:sentinel:), module: result)
    dict["bin"] = PyBuiltinFunction.wrap(name: "bin", doc: nil, fn: object.bin(_:), module: result)
    dict["oct"] = PyBuiltinFunction.wrap(name: "oct", doc: nil, fn: object.oct(_:), module: result)
    dict["hex"] = PyBuiltinFunction.wrap(name: "hex", doc: nil, fn: object.hex(_:), module: result)
    dict["chr"] = PyBuiltinFunction.wrap(name: "chr", doc: nil, fn: object.chr(_:), module: result)
    dict["ord"] = PyBuiltinFunction.wrap(name: "ord", doc: nil, fn: object.ord(_:), module: result)
    dict["hash"] = PyBuiltinFunction.wrap(name: "hash", doc: nil, fn: object.hash(_:), module: result)
    dict["id"] = PyBuiltinFunction.wrap(name: "id", doc: nil, fn: object.id(_:), module: result)
    dict["dir"] = PyBuiltinFunction.wrap(name: "dir", doc: nil, fn: object.dir(_:), module: result)
    dict["repr"] = PyBuiltinFunction.wrap(name: "repr", doc: nil, fn: object.repr(_:), module: result)
    dict["ascii"] = PyBuiltinFunction.wrap(name: "ascii", doc: nil, fn: object.ascii(_:), module: result)
    dict["len"] = PyBuiltinFunction.wrap(name: "len", doc: nil, fn: object.length(iterable:), module: result)
    dict["sorted"] = PyBuiltinFunction.wrap(name: "sorted", doc: nil, fn: object.sorted(iterable:key:reverse:), module: result)
    dict["callable"] = PyBuiltinFunction.wrap(name: "callable", doc: nil, fn: object.isCallable(_:), module: result)
    dict["divmod"] = PyBuiltinFunction.wrap(name: "divmod", doc: nil, fn: object.divmod(left:right:), module: result)
    dict["pow"] = PyBuiltinFunction.wrap(name: "pow", doc: nil, fn: object.pow(base:exp:mod:), module: result)
    dict["open"] = PyBuiltinFunction.wrap(name: "open", doc: nil, fn: object.open(args:kwargs:), module: result)
    dict["getattr"] = PyBuiltinFunction.wrap(name: "getattr", doc: nil, fn: object.getAttribute(_:name:default:), module: result)
    dict["hasattr"] = PyBuiltinFunction.wrap(name: "hasattr", doc: nil, fn: object.hasAttribute(_:name:), module: result)
    dict["setattr"] = PyBuiltinFunction.wrap(name: "setattr", doc: nil, fn: object.setAttribute(_:name:value:), module: result)
    dict["delattr"] = PyBuiltinFunction.wrap(name: "delattr", doc: nil, fn: object.deleteAttribute(_:name:), module: result)
    dict["min"] = PyBuiltinFunction.wrap(name: "min", doc: nil, fn: object.min(args:kwargs:), module: result)
    dict["max"] = PyBuiltinFunction.wrap(name: "max", doc: nil, fn: object.max(args:kwargs:), module: result)

    return result
  }

  // MARK: - Sys

  internal static func createSys(from object: Sys) -> PyModule {
    let result = PyModule(name: "sys", doc: nil)
    let dict = result.getDict()


    dict["stdin"] = PyProperty.wrap(name: "stdin", doc: nil, get: object.getStdin, set: object.setStdin)
    dict["__stdin__"] = PyProperty.wrap(name: "__stdin__", doc: nil, get: object.get__stdin__)
    dict["stdout"] = PyProperty.wrap(name: "stdout", doc: nil, get: object.getStdout, set: object.setStdout)
    dict["__stdout__"] = PyProperty.wrap(name: "__stdout__", doc: nil, get: object.get__stdout__)
    dict["stderr"] = PyProperty.wrap(name: "stderr", doc: nil, get: object.getStderr, set: object.setStderr)
    dict["__stderr__"] = PyProperty.wrap(name: "__stderr__", doc: nil, get: object.get__stderr__)
    dict["ps1"] = PyProperty.wrap(name: "ps1", doc: nil, get: object.getPS1, set: object.setPS1)
    dict["ps2"] = PyProperty.wrap(name: "ps2", doc: nil, get: object.getPS2, set: object.setPS2)
    dict["platform"] = PyProperty.wrap(name: "platform", doc: nil, get: object.getPlatform)
    dict["copyright"] = PyProperty.wrap(name: "copyright", doc: nil, get: object.getCopyright)
    dict["version"] = PyProperty.wrap(name: "version", doc: nil, get: object.getVersion)
    dict["version_info"] = PyProperty.wrap(name: "version_info", doc: nil, get: object.getVersionInfo)
    dict["implementation"] = PyProperty.wrap(name: "implementation", doc: nil, get: object.getImplementation)
    dict["hash_info"] = PyProperty.wrap(name: "hash_info", doc: nil, get: object.getHashInfo)


    return result
  }
}
