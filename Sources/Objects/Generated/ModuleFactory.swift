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
    let name = Py.intern("builtins")
    let module = createModule(name: "builtins", doc: Builtins.doc, dict: object.__dict__)

    insert(module: module, name: "None", value: object.none)
    insert(module: module, name: "Ellipsis", value: object.ellipsis)
    insert(module: module, name: "...", value: object.ellipsisDots)
    insert(module: module, name: "NotImplemented", value: object.notImplemented)
    insert(module: module, name: "True", value: object.`true`)
    insert(module: module, name: "False", value: object.`false`)
    insert(module: module, name: "object", value: object.type_object)
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
    insert(module: module, name: "type", value: object.type_type)
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

    insert(module: module, name: "abs", value: PyBuiltinFunction.wrap(name: "abs", doc: nil, fn: object.abs(_:), module: name))
    insert(module: module, name: "any", value: PyBuiltinFunction.wrap(name: "any", doc: nil, fn: object.any(iterable:), module: name))
    insert(module: module, name: "all", value: PyBuiltinFunction.wrap(name: "all", doc: nil, fn: object.all(iterable:), module: name))
    insert(module: module, name: "sum", value: PyBuiltinFunction.wrap(name: "sum", doc: nil, fn: object.sum(args:kwargs:), module: name))
    insert(module: module, name: "globals", value: PyBuiltinFunction.wrap(name: "globals", doc: nil, fn: object.getGlobals, module: name))
    insert(module: module, name: "locals", value: PyBuiltinFunction.wrap(name: "locals", doc: nil, fn: object.getLocals, module: name))
    insert(module: module, name: "isinstance", value: PyBuiltinFunction.wrap(name: "isinstance", doc: Builtins.isInstanceDoc, fn: object.isInstance(object:of:), module: name))
    insert(module: module, name: "issubclass", value: PyBuiltinFunction.wrap(name: "issubclass", doc: Builtins.isSubclassDoc, fn: object.isSubclass(object:of:), module: name))
    insert(module: module, name: "next", value: PyBuiltinFunction.wrap(name: "next", doc: Builtins.nextDoc, fn: object.next(iterator:default:), module: name))
    insert(module: module, name: "iter", value: PyBuiltinFunction.wrap(name: "iter", doc: Builtins.iterDoc, fn: object.iter(from:sentinel:), module: name))
    insert(module: module, name: "bin", value: PyBuiltinFunction.wrap(name: "bin", doc: nil, fn: object.bin(_:), module: name))
    insert(module: module, name: "oct", value: PyBuiltinFunction.wrap(name: "oct", doc: nil, fn: object.oct(_:), module: name))
    insert(module: module, name: "hex", value: PyBuiltinFunction.wrap(name: "hex", doc: nil, fn: object.hex(_:), module: name))
    insert(module: module, name: "chr", value: PyBuiltinFunction.wrap(name: "chr", doc: nil, fn: object.chr(_:), module: name))
    insert(module: module, name: "ord", value: PyBuiltinFunction.wrap(name: "ord", doc: nil, fn: object.ord(_:), module: name))
    insert(module: module, name: "__build_class__", value: PyBuiltinFunction.wrap(name: "__build_class__", doc: Builtins.buildClassDoc, fn: object.buildClass(args:kwargs:), module: name))
    insert(module: module, name: "hash", value: PyBuiltinFunction.wrap(name: "hash", doc: nil, fn: object.hash(_:), module: name))
    insert(module: module, name: "id", value: PyBuiltinFunction.wrap(name: "id", doc: nil, fn: object.id(_:), module: name))
    insert(module: module, name: "dir", value: PyBuiltinFunction.wrap(name: "dir", doc: nil, fn: object.dir(_:), module: name))
    insert(module: module, name: "exec", value: PyBuiltinFunction.wrap(name: "exec", doc: nil, fn: object.exec(args:kwargs:), module: name))
    insert(module: module, name: "eval", value: PyBuiltinFunction.wrap(name: "eval", doc: nil, fn: object.eval(args:kwargs:), module: name))
    insert(module: module, name: "breakpoint", value: PyBuiltinFunction.wrap(name: "breakpoint", doc: nil, fn: object.breakpoint, module: name))
    insert(module: module, name: "vars", value: PyBuiltinFunction.wrap(name: "vars", doc: nil, fn: object.vars, module: name))
    insert(module: module, name: "input", value: PyBuiltinFunction.wrap(name: "input", doc: nil, fn: object.input, module: name))
    insert(module: module, name: "format", value: PyBuiltinFunction.wrap(name: "format", doc: nil, fn: object.format(value:format:), module: name))
    insert(module: module, name: "help", value: PyBuiltinFunction.wrap(name: "help", doc: nil, fn: object.help, module: name))
    insert(module: module, name: "memoryview", value: PyBuiltinFunction.wrap(name: "memoryview", doc: nil, fn: object.memoryview, module: name))
    insert(module: module, name: "repr", value: PyBuiltinFunction.wrap(name: "repr", doc: nil, fn: object.repr(_:), module: name))
    insert(module: module, name: "ascii", value: PyBuiltinFunction.wrap(name: "ascii", doc: nil, fn: object.ascii(_:), module: name))
    insert(module: module, name: "len", value: PyBuiltinFunction.wrap(name: "len", doc: nil, fn: object.length(iterable:), module: name))
    insert(module: module, name: "sorted", value: PyBuiltinFunction.wrap(name: "sorted", doc: nil, fn: object.sorted(args:kwargs:), module: name))
    insert(module: module, name: "callable", value: PyBuiltinFunction.wrap(name: "callable", doc: nil, fn: object.isCallable(_:), module: name))
    insert(module: module, name: "__import__", value: PyBuiltinFunction.wrap(name: "__import__", doc: Builtins.importDoc, fn: object.__import__(args:kwargs:), module: name))
    insert(module: module, name: "compile", value: PyBuiltinFunction.wrap(name: "compile", doc: nil, fn: object.compile(args:kwargs:), module: name))
    insert(module: module, name: "round", value: PyBuiltinFunction.wrap(name: "round", doc: nil, fn: object.round(number:nDigits:), module: name))
    insert(module: module, name: "divmod", value: PyBuiltinFunction.wrap(name: "divmod", doc: nil, fn: object.divmod(left:right:), module: name))
    insert(module: module, name: "pow", value: PyBuiltinFunction.wrap(name: "pow", doc: nil, fn: object.pow(base:exp:mod:), module: name))
    insert(module: module, name: "print", value: PyBuiltinFunction.wrap(name: "print", doc: nil, fn: object.print(args:kwargs:), module: name))
    insert(module: module, name: "open", value: PyBuiltinFunction.wrap(name: "open", doc: nil, fn: object.open(args:kwargs:), module: name))
    insert(module: module, name: "getattr", value: PyBuiltinFunction.wrap(name: "getattr", doc: Builtins.getAttributeDoc, fn: object.getAttribute(_:name:default:), module: name))
    insert(module: module, name: "hasattr", value: PyBuiltinFunction.wrap(name: "hasattr", doc: nil, fn: object.hasAttribute(_:name:), module: name))
    insert(module: module, name: "setattr", value: PyBuiltinFunction.wrap(name: "setattr", doc: nil, fn: object.setAttribute(_:name:value:), module: name))
    insert(module: module, name: "delattr", value: PyBuiltinFunction.wrap(name: "delattr", doc: nil, fn: object.deleteAttribute(_:name:), module: name))
    insert(module: module, name: "min", value: PyBuiltinFunction.wrap(name: "min", doc: Builtins.minDoc, fn: object.min(args:kwargs:), module: name))
    insert(module: module, name: "max", value: PyBuiltinFunction.wrap(name: "max", doc: Builtins.maxDoc, fn: object.max(args:kwargs:), module: name))

    return module
  }

  // MARK: - UnderscoreImp

  internal static func createUnderscoreImp(from object: UnderscoreImp) -> PyModule {
    let name = Py.intern("_imp")
    let module = createModule(name: "_imp", doc: UnderscoreImp.doc, dict: object.__dict__)

    insert(module: module, name: "lock_held", value: PyBuiltinFunction.wrap(name: "lock_held", doc: UnderscoreImp.lockHeldDoc, fn: object.lockHeld, module: name))
    insert(module: module, name: "acquire_lock", value: PyBuiltinFunction.wrap(name: "acquire_lock", doc: UnderscoreImp.acquireLockDoc, fn: object.acquireLock, module: name))
    insert(module: module, name: "release_lock", value: PyBuiltinFunction.wrap(name: "release_lock", doc: UnderscoreImp.releaseLockDoc, fn: object.releaseLock, module: name))
    insert(module: module, name: "is_builtin", value: PyBuiltinFunction.wrap(name: "is_builtin", doc: UnderscoreImp.isBuiltinDoc, fn: object.isBuiltin(name:), module: name))
    insert(module: module, name: "create_builtin", value: PyBuiltinFunction.wrap(name: "create_builtin", doc: UnderscoreImp.createBuiltinDoc, fn: object.createBuiltin(spec:), module: name))
    insert(module: module, name: "exec_builtin", value: PyBuiltinFunction.wrap(name: "exec_builtin", doc: UnderscoreImp.execBuiltinDoc, fn: object.execBuiltin(module:), module: name))
    insert(module: module, name: "is_frozen", value: PyBuiltinFunction.wrap(name: "is_frozen", doc: UnderscoreImp.isFrozenDoc, fn: object.isFrozen, module: name))
    insert(module: module, name: "is_frozen_package", value: PyBuiltinFunction.wrap(name: "is_frozen_package", doc: UnderscoreImp.isFrozenPackageDoc, fn: object.isFrozenPackage, module: name))
    insert(module: module, name: "get_frozen_object", value: PyBuiltinFunction.wrap(name: "get_frozen_object", doc: UnderscoreImp.getFrozenObjectDoc, fn: object.getFrozenObject, module: name))
    insert(module: module, name: "init_frozen", value: PyBuiltinFunction.wrap(name: "init_frozen", doc: UnderscoreImp.initFrozenDoc, fn: object.initFrozen, module: name))
    insert(module: module, name: "create_dynamic", value: PyBuiltinFunction.wrap(name: "create_dynamic", doc: UnderscoreImp.createDynamicDoc, fn: object.createDynamic(spec:file:), module: name))
    insert(module: module, name: "exec_dynamic", value: PyBuiltinFunction.wrap(name: "exec_dynamic", doc: UnderscoreImp.execDynamicDoc, fn: object.execDynamic(module:), module: name))
    insert(module: module, name: "source_hash", value: PyBuiltinFunction.wrap(name: "source_hash", doc: UnderscoreImp.sourceHashDoc, fn: object.sourceHash, module: name))
    insert(module: module, name: "check_hash_based_pycs", value: PyBuiltinFunction.wrap(name: "check_hash_based_pycs", doc: UnderscoreImp.checkHashBasedPycsDoc, fn: object.checkHashBasedPycs, module: name))
    insert(module: module, name: "_fix_co_filename", value: PyBuiltinFunction.wrap(name: "_fix_co_filename", doc: UnderscoreImp.fixCoFilenameDoc, fn: object.fixCoFilename, module: name))
    insert(module: module, name: "extension_suffixes", value: PyBuiltinFunction.wrap(name: "extension_suffixes", doc: UnderscoreImp.extensionSuffixesDoc, fn: object.extensionSuffixes, module: name))

    return module
  }
}
