// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable function_body_length

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

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

import Core

private func createModule(name: String,
                          doc: String?,
                          dict: PyDict) -> PyModule {
  let n = Py.intern(name)
  let d = doc.map(Py.intern(_:))
  return PyModule(name: n, doc: d, dict: dict)
}

private func insert(module: PyModule, name: String, value: PyObject) {
  let dict = module.getDict()
  let interned = Py.intern(name)

  switch dict.set(key: interned, to: value) {
  case .ok:
    break
  case .error(let e):
    trap("Error when inserting '\(name)' to '\(module)': \(e)")
  }
}

internal enum ModuleFactory {

  // MARK: - Builtins

  internal static func createBuiltins(from object: Builtins) -> PyModule {
    let module = createModule(name: "builtins", doc: Builtins.doc, dict: object.__dict__)

    insert(module: module, name: "None", value: object.none)
    insert(module: module, name: "Ellipsis", value: object.ellipsis)
    insert(module: module, name: "...", value: object.ellipsisDots)
    insert(module: module, name: "NotImplemented", value: object.notImplemented)
    insert(module: module, name: "True", value: object.`true`)
    insert(module: module, name: "False", value: object.`false`)
    insert(module: module, name: "object", value: object.type_object)
    insert(module: module, name: "type", value: object.type_type)
    insert(module: module, name: "bool", value: object.type_bool)
    insert(module: module, name: "bytearray", value: object.type_bytearray)
    insert(module: module, name: "bytes", value: object.type_bytes)
    insert(module: module, name: "classmethod", value: object.type_classmethod)
    insert(module: module, name: "complex", value: object.type_complex)
    insert(module: module, name: "dict", value: object.type_dict)
    insert(module: module, name: "enumerate", value: object.type_enumerate)
    insert(module: module, name: "filter", value: object.type_filter)
    insert(module: module, name: "float", value: object.type_float)
    insert(module: module, name: "frozenset", value: object.type_frozenset)
    insert(module: module, name: "int", value: object.type_int)
    insert(module: module, name: "list", value: object.type_list)
    insert(module: module, name: "map", value: object.type_map)
    insert(module: module, name: "property", value: object.type_property)
    insert(module: module, name: "range", value: object.type_range)
    insert(module: module, name: "reversed", value: object.type_reversed)
    insert(module: module, name: "set", value: object.type_set)
    insert(module: module, name: "slice", value: object.type_slice)
    insert(module: module, name: "staticmethod", value: object.type_staticmethod)
    insert(module: module, name: "str", value: object.type_str)
    insert(module: module, name: "super", value: object.type_super)
    insert(module: module, name: "tuple", value: object.type_tuple)
    insert(module: module, name: "zip", value: object.type_zip)
    insert(module: module, name: "ArithmeticError", value: object.type_arithmeticError)
    insert(module: module, name: "AssertionError", value: object.type_assertionError)
    insert(module: module, name: "AttributeError", value: object.type_attributeError)
    insert(module: module, name: "BaseException", value: object.type_baseException)
    insert(module: module, name: "BlockingIOError", value: object.type_blockingIOError)
    insert(module: module, name: "BrokenPipeError", value: object.type_brokenPipeError)
    insert(module: module, name: "BufferError", value: object.type_bufferError)
    insert(module: module, name: "BytesWarning", value: object.type_bytesWarning)
    insert(module: module, name: "ChildProcessError", value: object.type_childProcessError)
    insert(module: module, name: "ConnectionAbortedError", value: object.type_connectionAbortedError)
    insert(module: module, name: "ConnectionError", value: object.type_connectionError)
    insert(module: module, name: "ConnectionRefusedError", value: object.type_connectionRefusedError)
    insert(module: module, name: "ConnectionResetError", value: object.type_connectionResetError)
    insert(module: module, name: "DeprecationWarning", value: object.type_deprecationWarning)
    insert(module: module, name: "EOFError", value: object.type_eofError)
    insert(module: module, name: "Exception", value: object.type_exception)
    insert(module: module, name: "FileExistsError", value: object.type_fileExistsError)
    insert(module: module, name: "FileNotFoundError", value: object.type_fileNotFoundError)
    insert(module: module, name: "FloatingPointError", value: object.type_floatingPointError)
    insert(module: module, name: "FutureWarning", value: object.type_futureWarning)
    insert(module: module, name: "GeneratorExit", value: object.type_generatorExit)
    insert(module: module, name: "ImportError", value: object.type_importError)
    insert(module: module, name: "ImportWarning", value: object.type_importWarning)
    insert(module: module, name: "IndentationError", value: object.type_indentationError)
    insert(module: module, name: "IndexError", value: object.type_indexError)
    insert(module: module, name: "InterruptedError", value: object.type_interruptedError)
    insert(module: module, name: "IsADirectoryError", value: object.type_isADirectoryError)
    insert(module: module, name: "KeyError", value: object.type_keyError)
    insert(module: module, name: "KeyboardInterrupt", value: object.type_keyboardInterrupt)
    insert(module: module, name: "LookupError", value: object.type_lookupError)
    insert(module: module, name: "MemoryError", value: object.type_memoryError)
    insert(module: module, name: "ModuleNotFoundError", value: object.type_moduleNotFoundError)
    insert(module: module, name: "NameError", value: object.type_nameError)
    insert(module: module, name: "NotADirectoryError", value: object.type_notADirectoryError)
    insert(module: module, name: "NotImplementedError", value: object.type_notImplementedError)
    insert(module: module, name: "OSError", value: object.type_osError)
    insert(module: module, name: "OverflowError", value: object.type_overflowError)
    insert(module: module, name: "PendingDeprecationWarning", value: object.type_pendingDeprecationWarning)
    insert(module: module, name: "PermissionError", value: object.type_permissionError)
    insert(module: module, name: "ProcessLookupError", value: object.type_processLookupError)
    insert(module: module, name: "RecursionError", value: object.type_recursionError)
    insert(module: module, name: "ReferenceError", value: object.type_referenceError)
    insert(module: module, name: "ResourceWarning", value: object.type_resourceWarning)
    insert(module: module, name: "RuntimeError", value: object.type_runtimeError)
    insert(module: module, name: "RuntimeWarning", value: object.type_runtimeWarning)
    insert(module: module, name: "StopAsyncIteration", value: object.type_stopAsyncIteration)
    insert(module: module, name: "StopIteration", value: object.type_stopIteration)
    insert(module: module, name: "SyntaxError", value: object.type_syntaxError)
    insert(module: module, name: "SyntaxWarning", value: object.type_syntaxWarning)
    insert(module: module, name: "SystemError", value: object.type_systemError)
    insert(module: module, name: "SystemExit", value: object.type_systemExit)
    insert(module: module, name: "TabError", value: object.type_tabError)
    insert(module: module, name: "TimeoutError", value: object.type_timeoutError)
    insert(module: module, name: "TypeError", value: object.type_typeError)
    insert(module: module, name: "UnboundLocalError", value: object.type_unboundLocalError)
    insert(module: module, name: "UnicodeDecodeError", value: object.type_unicodeDecodeError)
    insert(module: module, name: "UnicodeEncodeError", value: object.type_unicodeEncodeError)
    insert(module: module, name: "UnicodeError", value: object.type_unicodeError)
    insert(module: module, name: "UnicodeTranslateError", value: object.type_unicodeTranslateError)
    insert(module: module, name: "UnicodeWarning", value: object.type_unicodeWarning)
    insert(module: module, name: "UserWarning", value: object.type_userWarning)
    insert(module: module, name: "ValueError", value: object.type_valueError)
    insert(module: module, name: "Warning", value: object.type_warning)
    insert(module: module, name: "ZeroDivisionError", value: object.type_zeroDivisionError)

    insert(module: module, name: "abs", value: PyBuiltinFunction.wrap(name: "abs", doc: nil, fn: object.abs(_:), module: module))
    insert(module: module, name: "any", value: PyBuiltinFunction.wrap(name: "any", doc: nil, fn: object.any(iterable:), module: module))
    insert(module: module, name: "all", value: PyBuiltinFunction.wrap(name: "all", doc: nil, fn: object.all(iterable:), module: module))
    insert(module: module, name: "sum", value: PyBuiltinFunction.wrap(name: "sum", doc: nil, fn: object.sum(args:kwargs:), module: module))
    insert(module: module, name: "globals", value: PyBuiltinFunction.wrap(name: "globals", doc: nil, fn: object.getGlobals, module: module))
    insert(module: module, name: "locals", value: PyBuiltinFunction.wrap(name: "locals", doc: nil, fn: object.getLocals, module: module))
    insert(module: module, name: "isinstance", value: PyBuiltinFunction.wrap(name: "isinstance", doc: nil, fn: object.isInstance(object:of:), module: module))
    insert(module: module, name: "issubclass", value: PyBuiltinFunction.wrap(name: "issubclass", doc: nil, fn: object.isSubclass(object:of:), module: module))
    insert(module: module, name: "next", value: PyBuiltinFunction.wrap(name: "next", doc: nil, fn: object.next(iterator:default:), module: module))
    insert(module: module, name: "iter", value: PyBuiltinFunction.wrap(name: "iter", doc: nil, fn: object.iter(from:sentinel:), module: module))
    insert(module: module, name: "bin", value: PyBuiltinFunction.wrap(name: "bin", doc: nil, fn: object.bin(_:), module: module))
    insert(module: module, name: "oct", value: PyBuiltinFunction.wrap(name: "oct", doc: nil, fn: object.oct(_:), module: module))
    insert(module: module, name: "hex", value: PyBuiltinFunction.wrap(name: "hex", doc: nil, fn: object.hex(_:), module: module))
    insert(module: module, name: "chr", value: PyBuiltinFunction.wrap(name: "chr", doc: nil, fn: object.chr(_:), module: module))
    insert(module: module, name: "ord", value: PyBuiltinFunction.wrap(name: "ord", doc: nil, fn: object.ord(_:), module: module))
    insert(module: module, name: "__build_class__", value: PyBuiltinFunction.wrap(name: "__build_class__", doc: nil, fn: object.buildClass(args:kwargs:), module: module))
    insert(module: module, name: "hash", value: PyBuiltinFunction.wrap(name: "hash", doc: nil, fn: object.hash(_:), module: module))
    insert(module: module, name: "id", value: PyBuiltinFunction.wrap(name: "id", doc: nil, fn: object.id(_:), module: module))
    insert(module: module, name: "dir", value: PyBuiltinFunction.wrap(name: "dir", doc: nil, fn: object.dir(_:), module: module))
    insert(module: module, name: "exec", value: PyBuiltinFunction.wrap(name: "exec", doc: nil, fn: object.exec(args:kwargs:), module: module))
    insert(module: module, name: "eval", value: PyBuiltinFunction.wrap(name: "eval", doc: nil, fn: object.eval(args:kwargs:), module: module))
    insert(module: module, name: "breakpoint", value: PyBuiltinFunction.wrap(name: "breakpoint", doc: nil, fn: object.breakpoint, module: module))
    insert(module: module, name: "vars", value: PyBuiltinFunction.wrap(name: "vars", doc: nil, fn: object.vars, module: module))
    insert(module: module, name: "input", value: PyBuiltinFunction.wrap(name: "input", doc: nil, fn: object.input, module: module))
    insert(module: module, name: "format", value: PyBuiltinFunction.wrap(name: "format", doc: nil, fn: object.format(value:format:), module: module))
    insert(module: module, name: "help", value: PyBuiltinFunction.wrap(name: "help", doc: nil, fn: object.help, module: module))
    insert(module: module, name: "memoryview", value: PyBuiltinFunction.wrap(name: "memoryview", doc: nil, fn: object.memoryview, module: module))
    insert(module: module, name: "repr", value: PyBuiltinFunction.wrap(name: "repr", doc: nil, fn: object.repr(_:), module: module))
    insert(module: module, name: "ascii", value: PyBuiltinFunction.wrap(name: "ascii", doc: nil, fn: object.ascii(_:), module: module))
    insert(module: module, name: "len", value: PyBuiltinFunction.wrap(name: "len", doc: nil, fn: object.length(iterable:), module: module))
    insert(module: module, name: "sorted", value: PyBuiltinFunction.wrap(name: "sorted", doc: nil, fn: object.sorted(args:kwargs:), module: module))
    insert(module: module, name: "callable", value: PyBuiltinFunction.wrap(name: "callable", doc: nil, fn: object.isCallable(_:), module: module))
    insert(module: module, name: "__import__", value: PyBuiltinFunction.wrap(name: "__import__", doc: nil, fn: object.__import__(args:kwargs:), module: module))
    insert(module: module, name: "compile", value: PyBuiltinFunction.wrap(name: "compile", doc: nil, fn: object.compile(args:kwargs:), module: module))
    insert(module: module, name: "round", value: PyBuiltinFunction.wrap(name: "round", doc: nil, fn: object.round(number:nDigits:), module: module))
    insert(module: module, name: "divmod", value: PyBuiltinFunction.wrap(name: "divmod", doc: nil, fn: object.divmod(left:right:), module: module))
    insert(module: module, name: "pow", value: PyBuiltinFunction.wrap(name: "pow", doc: nil, fn: object.pow(base:exp:mod:), module: module))
    insert(module: module, name: "print", value: PyBuiltinFunction.wrap(name: "print", doc: nil, fn: object.print(args:kwargs:), module: module))
    insert(module: module, name: "open", value: PyBuiltinFunction.wrap(name: "open", doc: nil, fn: object.open(args:kwargs:), module: module))
    insert(module: module, name: "getattr", value: PyBuiltinFunction.wrap(name: "getattr", doc: nil, fn: object.getAttribute(_:name:default:), module: module))
    insert(module: module, name: "hasattr", value: PyBuiltinFunction.wrap(name: "hasattr", doc: nil, fn: object.hasAttribute(_:name:), module: module))
    insert(module: module, name: "setattr", value: PyBuiltinFunction.wrap(name: "setattr", doc: nil, fn: object.setAttribute(_:name:value:), module: module))
    insert(module: module, name: "delattr", value: PyBuiltinFunction.wrap(name: "delattr", doc: nil, fn: object.deleteAttribute(_:name:), module: module))
    insert(module: module, name: "min", value: PyBuiltinFunction.wrap(name: "min", doc: nil, fn: object.min(args:kwargs:), module: module))
    insert(module: module, name: "max", value: PyBuiltinFunction.wrap(name: "max", doc: nil, fn: object.max(args:kwargs:), module: module))

    return module
  }

  // MARK: - Sys

  internal static func createSys(from object: Sys) -> PyModule {
    let module = createModule(name: "sys", doc: Sys.doc, dict: object.__dict__)

    insert(module: module, name: "meta_path", value: object.metaPath)
    insert(module: module, name: "path_hooks", value: object.pathHooks)
    insert(module: module, name: "path_importer_cache", value: object.pathImporterCache)
    insert(module: module, name: "path", value: object.path)
    insert(module: module, name: "prefix", value: object.prefix)
    insert(module: module, name: "builtin_module_names", value: object.builtinModuleNamesObject)
    insert(module: module, name: "modules", value: object.modules)
    insert(module: module, name: "__stdin__", value: object.__stdin__)
    insert(module: module, name: "stdin", value: object.stdin)
    insert(module: module, name: "__stdout__", value: object.__stdout__)
    insert(module: module, name: "stdout", value: object.stdout)
    insert(module: module, name: "__stderr__", value: object.__stderr__)
    insert(module: module, name: "stderr", value: object.stderr)
    insert(module: module, name: "warnoptions", value: object.warnOptions)
    insert(module: module, name: "ps1", value: object.ps1Object)
    insert(module: module, name: "ps2", value: object.ps2Object)
    insert(module: module, name: "argv", value: object.argv)
    insert(module: module, name: "flags", value: object.flagsObject)
    insert(module: module, name: "executable", value: object.executable)
    insert(module: module, name: "platform", value: object.platformObject)
    insert(module: module, name: "copyright", value: object.copyrightObject)
    insert(module: module, name: "hash_info", value: object.hashInfoObject)
    insert(module: module, name: "abiflags", value: object.abiFlags)
    insert(module: module, name: "base_exec_prefix", value: object.baseExecPrefix)
    insert(module: module, name: "base_prefix", value: object.basePrefix)
    insert(module: module, name: "byteorder", value: object.byteOrder)
    insert(module: module, name: "dllhandle", value: object.dllHandle)
    insert(module: module, name: "dont_write_bytecode", value: object.dontWriteBytecode)
    insert(module: module, name: "__breakpointhook__", value: object.__breakpointHook__)
    insert(module: module, name: "exec_prefix", value: object.execPrefix)
    insert(module: module, name: "float_info", value: object.floatInfo)
    insert(module: module, name: "float_repr_style", value: object.floatReprStyle)
    insert(module: module, name: "int_info", value: object.intInfo)
    insert(module: module, name: "__interactivehook__", value: object.__interactivehook__)
    insert(module: module, name: "last_type", value: object.lastType)
    insert(module: module, name: "maxsize", value: object.maxSize)
    insert(module: module, name: "maxunicode", value: object.maxUnicode)
    insert(module: module, name: "thread_info", value: object.threadInfo)
    insert(module: module, name: "tracebacklimit", value: object.tracebackLimit)
    insert(module: module, name: "api_version", value: object.apiVersion)
    insert(module: module, name: "winver", value: object.winver)
    insert(module: module, name: "_xoptions", value: object._xoptions)
    insert(module: module, name: "version", value: object.versionObject)
    insert(module: module, name: "version_info", value: object.versionInfoObject)
    insert(module: module, name: "implementation", value: object.implementationObject)
    insert(module: module, name: "hexversion", value: object.hexVersion)

    insert(module: module, name: "exit", value: PyBuiltinFunction.wrap(name: "exit", doc: nil, fn: object.exit(status:), module: module))
    insert(module: module, name: "intern", value: PyBuiltinFunction.wrap(name: "intern", doc: nil, fn: object.intern(value:), module: module))
    insert(module: module, name: "getdefaultencoding", value: PyBuiltinFunction.wrap(name: "getdefaultencoding", doc: nil, fn: object.getDefaultEncoding, module: module))
    insert(module: module, name: "call_tracing", value: PyBuiltinFunction.wrap(name: "call_tracing", doc: nil, fn: object.callTracing, module: module))
    insert(module: module, name: "_clear_type_cache", value: PyBuiltinFunction.wrap(name: "_clear_type_cache", doc: nil, fn: object._clearTypeCache, module: module))
    insert(module: module, name: "_current_frames", value: PyBuiltinFunction.wrap(name: "_current_frames", doc: nil, fn: object._currentFrames, module: module))
    insert(module: module, name: "breakpointhook", value: PyBuiltinFunction.wrap(name: "breakpointhook", doc: nil, fn: object.breakpointHook, module: module))
    insert(module: module, name: "_debugmallocstats", value: PyBuiltinFunction.wrap(name: "_debugmallocstats", doc: nil, fn: object._debugMallocStats, module: module))
    insert(module: module, name: "displayhook", value: PyBuiltinFunction.wrap(name: "displayhook", doc: nil, fn: object.displayHook, module: module))
    insert(module: module, name: "excepthook", value: PyBuiltinFunction.wrap(name: "excepthook", doc: nil, fn: object.exceptHook, module: module))
    insert(module: module, name: "exc_info", value: PyBuiltinFunction.wrap(name: "exc_info", doc: nil, fn: object.exceptionInfo, module: module))
    insert(module: module, name: "getallocatedblocks", value: PyBuiltinFunction.wrap(name: "getallocatedblocks", doc: nil, fn: object.getAllocatedBlocks, module: module))
    insert(module: module, name: "getandroidapilevel", value: PyBuiltinFunction.wrap(name: "getandroidapilevel", doc: nil, fn: object.getAndroidApiLevel, module: module))
    insert(module: module, name: "getcheckinterval", value: PyBuiltinFunction.wrap(name: "getcheckinterval", doc: nil, fn: object.getCheckInterval, module: module))
    insert(module: module, name: "getdlopenflags", value: PyBuiltinFunction.wrap(name: "getdlopenflags", doc: nil, fn: object.getDlopenFlags, module: module))
    insert(module: module, name: "getfilesystemencoding", value: PyBuiltinFunction.wrap(name: "getfilesystemencoding", doc: nil, fn: object.getFileSystemEncoding, module: module))
    insert(module: module, name: "getfilesystemencodeerrors", value: PyBuiltinFunction.wrap(name: "getfilesystemencodeerrors", doc: nil, fn: object.getFileSystemEncodeErrors, module: module))
    insert(module: module, name: "getrefcount", value: PyBuiltinFunction.wrap(name: "getrefcount", doc: nil, fn: object.getRefCount, module: module))
    insert(module: module, name: "getrecursionlimit", value: PyBuiltinFunction.wrap(name: "getrecursionlimit", doc: nil, fn: object.getRecursionLimit, module: module))
    insert(module: module, name: "getsizeof", value: PyBuiltinFunction.wrap(name: "getsizeof", doc: nil, fn: object.getSizeof, module: module))
    insert(module: module, name: "getswitchinterval", value: PyBuiltinFunction.wrap(name: "getswitchinterval", doc: nil, fn: object.getSwitchInterval, module: module))
    insert(module: module, name: "_getframe", value: PyBuiltinFunction.wrap(name: "_getframe", doc: nil, fn: object._getFrame, module: module))
    insert(module: module, name: "getprofile", value: PyBuiltinFunction.wrap(name: "getprofile", doc: nil, fn: object.getProfile, module: module))
    insert(module: module, name: "gettrace", value: PyBuiltinFunction.wrap(name: "gettrace", doc: nil, fn: object.getTrace, module: module))
    insert(module: module, name: "getwindowsversion", value: PyBuiltinFunction.wrap(name: "getwindowsversion", doc: nil, fn: object.getWindowsVersion, module: module))
    insert(module: module, name: "get_asyncgen_hooks", value: PyBuiltinFunction.wrap(name: "get_asyncgen_hooks", doc: nil, fn: object.getAsyncGenHooks, module: module))
    insert(module: module, name: "get_coroutine_origin_tracking_depth", value: PyBuiltinFunction.wrap(name: "get_coroutine_origin_tracking_depth", doc: nil, fn: object.getCoroutineOriginTrackingDepth, module: module))
    insert(module: module, name: "get_coroutine_wrapper", value: PyBuiltinFunction.wrap(name: "get_coroutine_wrapper", doc: nil, fn: object.getCoroutineWrapper, module: module))
    insert(module: module, name: "is_finalizing", value: PyBuiltinFunction.wrap(name: "is_finalizing", doc: nil, fn: object.isFinalizing, module: module))
    insert(module: module, name: "setcheckinterval", value: PyBuiltinFunction.wrap(name: "setcheckinterval", doc: nil, fn: object.setCheckInterval, module: module))
    insert(module: module, name: "setdlopenflags", value: PyBuiltinFunction.wrap(name: "setdlopenflags", doc: nil, fn: object.setDlopenFlags, module: module))
    insert(module: module, name: "setprofile", value: PyBuiltinFunction.wrap(name: "setprofile", doc: nil, fn: object.setProfile, module: module))
    insert(module: module, name: "setrecursionlimit", value: PyBuiltinFunction.wrap(name: "setrecursionlimit", doc: nil, fn: object.setRecursionLimit, module: module))
    insert(module: module, name: "setswitchinterval", value: PyBuiltinFunction.wrap(name: "setswitchinterval", doc: nil, fn: object.setSwitchInterval, module: module))
    insert(module: module, name: "settrace", value: PyBuiltinFunction.wrap(name: "settrace", doc: nil, fn: object.setTrace, module: module))
    insert(module: module, name: "set_asyncgen_hooks", value: PyBuiltinFunction.wrap(name: "set_asyncgen_hooks", doc: nil, fn: object.setAsyncGenHooks, module: module))
    insert(module: module, name: "set_coroutine_origin_tracking_depth", value: PyBuiltinFunction.wrap(name: "set_coroutine_origin_tracking_depth", doc: nil, fn: object.setCoroutineOriginTrackingDepth, module: module))
    insert(module: module, name: "set_coroutine_wrapper", value: PyBuiltinFunction.wrap(name: "set_coroutine_wrapper", doc: nil, fn: object.setCoroutineWrapper, module: module))
    insert(module: module, name: "_enablelegacywindowsfsencoding", value: PyBuiltinFunction.wrap(name: "_enablelegacywindowsfsencoding", doc: nil, fn: object._enableLegacyWindowsFSEncoding, module: module))

    return module
  }

  // MARK: - UnderscoreImp

  internal static func createUnderscoreImp(from object: UnderscoreImp) -> PyModule {
    let module = createModule(name: "_imp", doc: UnderscoreImp.doc, dict: object.__dict__)

    insert(module: module, name: "lock_held", value: PyBuiltinFunction.wrap(name: "lock_held", doc: nil, fn: object.lockHeld, module: module))
    insert(module: module, name: "acquire_lock", value: PyBuiltinFunction.wrap(name: "acquire_lock", doc: nil, fn: object.acquireLock, module: module))
    insert(module: module, name: "release_lock", value: PyBuiltinFunction.wrap(name: "release_lock", doc: nil, fn: object.releaseLock, module: module))
    insert(module: module, name: "is_builtin", value: PyBuiltinFunction.wrap(name: "is_builtin", doc: nil, fn: object.isBuiltin(name:), module: module))
    insert(module: module, name: "create_builtin", value: PyBuiltinFunction.wrap(name: "create_builtin", doc: nil, fn: object.createBuiltin(spec:), module: module))
    insert(module: module, name: "exec_builtin", value: PyBuiltinFunction.wrap(name: "exec_builtin", doc: nil, fn: object.execBuiltin(module:), module: module))
    insert(module: module, name: "is_frozen", value: PyBuiltinFunction.wrap(name: "is_frozen", doc: nil, fn: object.isFrozen, module: module))
    insert(module: module, name: "is_frozen_package", value: PyBuiltinFunction.wrap(name: "is_frozen_package", doc: nil, fn: object.isFrozenPackage, module: module))
    insert(module: module, name: "get_frozen_object", value: PyBuiltinFunction.wrap(name: "get_frozen_object", doc: nil, fn: object.getFrozenObject, module: module))
    insert(module: module, name: "init_frozen", value: PyBuiltinFunction.wrap(name: "init_frozen", doc: nil, fn: object.initFrozen, module: module))
    insert(module: module, name: "create_dynamic", value: PyBuiltinFunction.wrap(name: "create_dynamic", doc: nil, fn: object.createDynamic(spec:file:), module: module))
    insert(module: module, name: "exec_dynamic", value: PyBuiltinFunction.wrap(name: "exec_dynamic", doc: nil, fn: object.execDynamic(module:), module: module))
    insert(module: module, name: "source_hash", value: PyBuiltinFunction.wrap(name: "source_hash", doc: nil, fn: object.sourceHash, module: module))
    insert(module: module, name: "check_hash_based_pycs", value: PyBuiltinFunction.wrap(name: "check_hash_based_pycs", doc: nil, fn: object.checkHashBasedPycs, module: module))
    insert(module: module, name: "_fix_co_filename", value: PyBuiltinFunction.wrap(name: "_fix_co_filename", doc: nil, fn: object.fixCoFilename, module: module))
    insert(module: module, name: "extension_suffixes", value: PyBuiltinFunction.wrap(name: "extension_suffixes", doc: nil, fn: object.extensionSuffixes, module: module))

    return module
  }

  // MARK: - UnderscoreOS

  internal static func createUnderscoreOS(from object: UnderscoreOS) -> PyModule {
    let module = createModule(name: "_os", doc: nil, dict: object.__dict__)

    insert(module: module, name: "getcwd", value: PyBuiltinFunction.wrap(name: "getcwd", doc: nil, fn: object.getCwd, module: module))
    insert(module: module, name: "fspath", value: PyBuiltinFunction.wrap(name: "fspath", doc: nil, fn: object.getFSPath(path:), module: module))
    insert(module: module, name: "stat", value: PyBuiltinFunction.wrap(name: "stat", doc: nil, fn: object.getStat(path:), module: module))
    insert(module: module, name: "listdir", value: PyBuiltinFunction.wrap(name: "listdir", doc: nil, fn: object.listDir(path:), module: module))

    return module
  }

  // MARK: - UnderscoreWarnings

  internal static func createUnderscoreWarnings(from object: UnderscoreWarnings) -> PyModule {
    let module = createModule(name: "_warnings", doc: UnderscoreWarnings.doc, dict: object.__dict__)

    insert(module: module, name: "filters", value: object.filters)
    insert(module: module, name: "_defaultaction", value: object.defaultAction)
    insert(module: module, name: "_onceregistry", value: object.onceRegistry)

    insert(module: module, name: "warn", value: PyBuiltinFunction.wrap(name: "warn", doc: nil, fn: object.warn(args:kwargs:), module: module))

    return module
  }
}
