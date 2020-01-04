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
    let result = PyModule(object.context, name: "builtins", doc: nil)
    let dict = result.getDict()


    dict["abs"] = PyBuiltinFunction.wrap(object.context, name: "abs", doc: nil, fn: object.abs(_:))
    dict["callable"] = PyBuiltinFunction.wrap(object.context, name: "callable", doc: nil, fn: object.isCallable(_:))
    dict["len"] = PyBuiltinFunction.wrap(object.context, name: "len", doc: nil, fn: object.length(iterable:))
    dict["sorted"] = PyBuiltinFunction.wrap(object.context, name: "sorted", doc: nil, fn: object.sorted(iterable:key:reverse:))
    dict["min"] = PyBuiltinFunction.wrap(object.context, name: "min", doc: nil, fn: object.min(args:kwargs:))
    dict["max"] = PyBuiltinFunction.wrap(object.context, name: "max", doc: nil, fn: object.max(args:kwargs:))
    dict["getattr"] = PyBuiltinFunction.wrap(object.context, name: "getattr", doc: nil, fn: object.getAttribute(_:name:default:))
    dict["hasattr"] = PyBuiltinFunction.wrap(object.context, name: "hasattr", doc: nil, fn: object.hasAttribute(_:name:))
    dict["setattr"] = PyBuiltinFunction.wrap(object.context, name: "setattr", doc: nil, fn: object.setAttribute(_:name:value:))
    dict["delattr"] = PyBuiltinFunction.wrap(object.context, name: "delattr", doc: nil, fn: object.deleteAttribute(_:name:))
    dict["open"] = PyBuiltinFunction.wrap(object.context, name: "open", doc: nil, fn: object.open(args:kwargs:))
    dict["divmod"] = PyBuiltinFunction.wrap(object.context, name: "divmod", doc: nil, fn: object.divmod(left:right:))
    dict["bin"] = PyBuiltinFunction.wrap(object.context, name: "bin", doc: nil, fn: object.bin(_:))
    dict["oct"] = PyBuiltinFunction.wrap(object.context, name: "oct", doc: nil, fn: object.oct(_:))
    dict["hex"] = PyBuiltinFunction.wrap(object.context, name: "hex", doc: nil, fn: object.hex(_:))
    dict["chr"] = PyBuiltinFunction.wrap(object.context, name: "chr", doc: nil, fn: object.chr(_:))
    dict["ord"] = PyBuiltinFunction.wrap(object.context, name: "ord", doc: nil, fn: object.ord(_:))
    dict["any"] = PyBuiltinFunction.wrap(object.context, name: "any", doc: nil, fn: object.any(iterable:))
    dict["all"] = PyBuiltinFunction.wrap(object.context, name: "all", doc: nil, fn: object.all(iterable:))
    dict["sum"] = PyBuiltinFunction.wrap(object.context, name: "sum", doc: nil, fn: object.sum(iterable:start:))
    dict["repr"] = PyBuiltinFunction.wrap(object.context, name: "repr", doc: nil, fn: object.repr(_:))
    dict["ascii"] = PyBuiltinFunction.wrap(object.context, name: "ascii", doc: nil, fn: object.ascii(_:))
    dict["isinstance"] = PyBuiltinFunction.wrap(object.context, name: "isinstance", doc: nil, fn: object.isInstance(object:of:))
    dict["issubclass"] = PyBuiltinFunction.wrap(object.context, name: "issubclass", doc: nil, fn: object.isSubclass(object:of:))
    dict["pow"] = PyBuiltinFunction.wrap(object.context, name: "pow", doc: nil, fn: object.pow(base:exp:mod:))
    dict["next"] = PyBuiltinFunction.wrap(object.context, name: "next", doc: nil, fn: object.next(iterator:default:))
    dict["iter"] = PyBuiltinFunction.wrap(object.context, name: "iter", doc: nil, fn: object.iter(from:sentinel:))
    dict["id"] = PyBuiltinFunction.wrap(object.context, name: "id", doc: nil, fn: object.id(_:))
    dict["dir"] = PyBuiltinFunction.wrap(object.context, name: "dir", doc: nil, fn: object.dir(_:))
    dict["hash"] = PyBuiltinFunction.wrap(object.context, name: "hash", doc: nil, fn: object.hash(_:))

    return result
  }

  // MARK: - Sys

  internal static func createSys(from object: Sys) -> PyModule {
    let result = PyModule(object.context, name: "sys", doc: nil)
    let dict = result.getDict()

    dict["stdin"] = PyProperty.wrap(object.context, name: "stdin", doc: nil, get: object.getStdin, set: object.setStdin)
    dict["__stdin__"] = PyProperty.wrap(object.context, name: "__stdin__", doc: nil, get: object.get__stdin__)
    dict["stdout"] = PyProperty.wrap(object.context, name: "stdout", doc: nil, get: object.getStdout, set: object.setStdout)
    dict["__stdout__"] = PyProperty.wrap(object.context, name: "__stdout__", doc: nil, get: object.get__stdout__)
    dict["stderr"] = PyProperty.wrap(object.context, name: "stderr", doc: nil, get: object.getStderr, set: object.setStderr)
    dict["__stderr__"] = PyProperty.wrap(object.context, name: "__stderr__", doc: nil, get: object.get__stderr__)
    dict["ps1"] = PyProperty.wrap(object.context, name: "ps1", doc: nil, get: object.getPS1, set: object.setPS1)
    dict["ps2"] = PyProperty.wrap(object.context, name: "ps2", doc: nil, get: object.getPS2, set: object.setPS2)
    dict["platform"] = PyProperty.wrap(object.context, name: "platform", doc: nil, get: object.getPlatform)
    dict["copyright"] = PyProperty.wrap(object.context, name: "copyright", doc: nil, get: object.getCopyright)
    dict["version"] = PyProperty.wrap(object.context, name: "version", doc: nil, get: object.getVersion)
    dict["version_info"] = PyProperty.wrap(object.context, name: "version_info", doc: nil, get: object.getVersionInfo)
    dict["implementation"] = PyProperty.wrap(object.context, name: "implementation", doc: nil, get: object.getImplementation)
    dict["hash_info"] = PyProperty.wrap(object.context, name: "hash_info", doc: nil, get: object.getHashInfo)


    return result
  }
}
