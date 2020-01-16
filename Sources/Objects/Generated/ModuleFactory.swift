// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
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
// 'PyContext.builtins' object (which gives us stateful modules).
// (and we would have gotten away with it without you meddling kids!)
// https://www.youtube.com/watch?v=b4JLLv1lE7A

internal enum ModuleFactory {

  // MARK: - Builtins

  internal static func createBuiltins(from object: Builtins) -> PyModule {
    let result = PyModule(name: "builtins", doc: nil)
    let dict = result.getDict()


    dict["abs"] = PyBuiltinFunction.wrap(name: "abs", doc: nil, fn: object.abs(_:))
    dict["callable"] = PyBuiltinFunction.wrap(name: "callable", doc: nil, fn: object.isCallable(_:))
    dict["len"] = PyBuiltinFunction.wrap(name: "len", doc: nil, fn: object.length(iterable:))
    dict["sorted"] = PyBuiltinFunction.wrap(name: "sorted", doc: nil, fn: object.sorted(iterable:key:reverse:))
    dict["min"] = PyBuiltinFunction.wrap(name: "min", doc: nil, fn: object.min(args:kwargs:))
    dict["max"] = PyBuiltinFunction.wrap(name: "max", doc: nil, fn: object.max(args:kwargs:))
    dict["getattr"] = PyBuiltinFunction.wrap(name: "getattr", doc: nil, fn: object.getAttribute(_:name:default:))
    dict["hasattr"] = PyBuiltinFunction.wrap(name: "hasattr", doc: nil, fn: object.hasAttribute(_:name:))
    dict["setattr"] = PyBuiltinFunction.wrap(name: "setattr", doc: nil, fn: object.setAttribute(_:name:value:))
    dict["delattr"] = PyBuiltinFunction.wrap(name: "delattr", doc: nil, fn: object.deleteAttribute(_:name:))
    dict["open"] = PyBuiltinFunction.wrap(name: "open", doc: nil, fn: object.open(args:kwargs:))
    dict["divmod"] = PyBuiltinFunction.wrap(name: "divmod", doc: nil, fn: object.divmod(left:right:))
    dict["bin"] = PyBuiltinFunction.wrap(name: "bin", doc: nil, fn: object.bin(_:))
    dict["oct"] = PyBuiltinFunction.wrap(name: "oct", doc: nil, fn: object.oct(_:))
    dict["hex"] = PyBuiltinFunction.wrap(name: "hex", doc: nil, fn: object.hex(_:))
    dict["chr"] = PyBuiltinFunction.wrap(name: "chr", doc: nil, fn: object.chr(_:))
    dict["ord"] = PyBuiltinFunction.wrap(name: "ord", doc: nil, fn: object.ord(_:))
    dict["any"] = PyBuiltinFunction.wrap(name: "any", doc: nil, fn: object.any(iterable:))
    dict["all"] = PyBuiltinFunction.wrap(name: "all", doc: nil, fn: object.all(iterable:))
    dict["sum"] = PyBuiltinFunction.wrap(name: "sum", doc: nil, fn: object.sum(iterable:start:))
    dict["repr"] = PyBuiltinFunction.wrap(name: "repr", doc: nil, fn: object.repr(_:))
    dict["ascii"] = PyBuiltinFunction.wrap(name: "ascii", doc: nil, fn: object.ascii(_:))
    dict["isinstance"] = PyBuiltinFunction.wrap(name: "isinstance", doc: nil, fn: object.isInstance(object:of:))
    dict["issubclass"] = PyBuiltinFunction.wrap(name: "issubclass", doc: nil, fn: object.isSubclass(object:of:))
    dict["pow"] = PyBuiltinFunction.wrap(name: "pow", doc: nil, fn: object.pow(base:exp:mod:))
    dict["next"] = PyBuiltinFunction.wrap(name: "next", doc: nil, fn: object.next(iterator:default:))
    dict["iter"] = PyBuiltinFunction.wrap(name: "iter", doc: nil, fn: object.iter(from:sentinel:))
    dict["id"] = PyBuiltinFunction.wrap(name: "id", doc: nil, fn: object.id(_:))
    dict["dir"] = PyBuiltinFunction.wrap(name: "dir", doc: nil, fn: object.dir(_:))
    dict["hash"] = PyBuiltinFunction.wrap(name: "hash", doc: nil, fn: object.hash(_:))

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
