import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable function_body_length
// ^ God knows, we will need this one...

extension Builtins {

  internal func fill__dict__() {

    // MARK: - Values

    self.setOrTrap(.none, to: Py.none)
    self.setOrTrap(.ellipsis, to: Py.ellipsis)
    self.setOrTrap(.dotDotDot, to: Py.ellipsis)
    self.setOrTrap(.notImplemented, to: Py.notImplemented)
    self.setOrTrap(.true, to: Py.`true`)
    self.setOrTrap(.false, to: Py.`false`)

    // MARK: - Types

    // Not all of those types should be exposed from builtins module.
    // Some should require 'import types', but sice we don't have 'types' module,
    // we will expose them from builtins.

    self.setOrTrap(.bool, to: Py.types.bool)
    self.setOrTrap(.bytearray, to: Py.types.bytearray)
    self.setOrTrap(.bytes, to: Py.types.bytes)
    self.setOrTrap(.classmethod, to: Py.types.classmethod)
    self.setOrTrap(.complex, to: Py.types.complex)
    self.setOrTrap(.dict, to: Py.types.dict)
    self.setOrTrap(.enumerate, to: Py.types.enumerate)
    self.setOrTrap(.filter, to: Py.types.filter)
    self.setOrTrap(.float, to: Py.types.float)
    self.setOrTrap(.frozenset, to: Py.types.frozenset)
    self.setOrTrap(.int, to: Py.types.int)
    self.setOrTrap(.list, to: Py.types.list)
    self.setOrTrap(.map, to: Py.types.map)
    self.setOrTrap(.object, to: Py.types.object)
    self.setOrTrap(.property, to: Py.types.property)
    self.setOrTrap(.range, to: Py.types.range)
    self.setOrTrap(.reversed, to: Py.types.reversed)
    self.setOrTrap(.set, to: Py.types.set)
    self.setOrTrap(.slice, to: Py.types.slice)
    self.setOrTrap(.staticmethod, to: Py.types.staticmethod)
    self.setOrTrap(.str, to: Py.types.str)
    self.setOrTrap(.super, to: Py.types.super)
    self.setOrTrap(.tuple, to: Py.types.tuple)
    self.setOrTrap(.type, to: Py.types.type)
    self.setOrTrap(.zip, to: Py.types.zip)

    // MARK: - Error types

    self.setOrTrap(.arithmeticError, to: Py.errorTypes.arithmeticError)
    self.setOrTrap(.assertionError, to: Py.errorTypes.assertionError)
    self.setOrTrap(.attributeError, to: Py.errorTypes.attributeError)
    self.setOrTrap(.baseException, to: Py.errorTypes.baseException)
    self.setOrTrap(.blockingIOError, to: Py.errorTypes.blockingIOError)
    self.setOrTrap(.brokenPipeError, to: Py.errorTypes.brokenPipeError)
    self.setOrTrap(.bufferError, to: Py.errorTypes.bufferError)
    self.setOrTrap(.bytesWarning, to: Py.errorTypes.bytesWarning)
    self.setOrTrap(.childProcessError, to: Py.errorTypes.childProcessError)
    self.setOrTrap(.connectionAbortedError, to: Py.errorTypes.connectionAbortedError)
    self.setOrTrap(.connectionError, to: Py.errorTypes.connectionError)
    self.setOrTrap(.connectionRefusedError, to: Py.errorTypes.connectionRefusedError)
    self.setOrTrap(.connectionResetError, to: Py.errorTypes.connectionResetError)
    self.setOrTrap(.deprecationWarning, to: Py.errorTypes.deprecationWarning)
    self.setOrTrap(.eofError, to: Py.errorTypes.eofError)
    self.setOrTrap(.exception, to: Py.errorTypes.exception)
    self.setOrTrap(.fileExistsError, to: Py.errorTypes.fileExistsError)
    self.setOrTrap(.fileNotFoundError, to: Py.errorTypes.fileNotFoundError)
    self.setOrTrap(.floatingPointError, to: Py.errorTypes.floatingPointError)
    self.setOrTrap(.futureWarning, to: Py.errorTypes.futureWarning)
    self.setOrTrap(.generatorExit, to: Py.errorTypes.generatorExit)
    self.setOrTrap(.importError, to: Py.errorTypes.importError)
    self.setOrTrap(.importWarning, to: Py.errorTypes.importWarning)
    self.setOrTrap(.indentationError, to: Py.errorTypes.indentationError)
    self.setOrTrap(.indexError, to: Py.errorTypes.indexError)
    self.setOrTrap(.interruptedError, to: Py.errorTypes.interruptedError)
    self.setOrTrap(.isADirectoryError, to: Py.errorTypes.isADirectoryError)
    self.setOrTrap(.keyError, to: Py.errorTypes.keyError)
    self.setOrTrap(.keyboardInterrupt, to: Py.errorTypes.keyboardInterrupt)
    self.setOrTrap(.lookupError, to: Py.errorTypes.lookupError)
    self.setOrTrap(.memoryError, to: Py.errorTypes.memoryError)
    self.setOrTrap(.moduleNotFoundError, to: Py.errorTypes.moduleNotFoundError)
    self.setOrTrap(.nameError, to: Py.errorTypes.nameError)
    self.setOrTrap(.notADirectoryError, to: Py.errorTypes.notADirectoryError)
    self.setOrTrap(.notImplementedError, to: Py.errorTypes.notImplementedError)
    self.setOrTrap(.osError, to: Py.errorTypes.osError)
    self.setOrTrap(.overflowError, to: Py.errorTypes.overflowError)
    self.setOrTrap(.pendingDeprecationWarning, to: Py.errorTypes.pendingDeprecationWarning)
    self.setOrTrap(.permissionError, to: Py.errorTypes.permissionError)
    self.setOrTrap(.processLookupError, to: Py.errorTypes.processLookupError)
    self.setOrTrap(.recursionError, to: Py.errorTypes.recursionError)
    self.setOrTrap(.referenceError, to: Py.errorTypes.referenceError)
    self.setOrTrap(.resourceWarning, to: Py.errorTypes.resourceWarning)
    self.setOrTrap(.runtimeError, to: Py.errorTypes.runtimeError)
    self.setOrTrap(.runtimeWarning, to: Py.errorTypes.runtimeWarning)
    self.setOrTrap(.stopAsyncIteration, to: Py.errorTypes.stopAsyncIteration)
    self.setOrTrap(.stopIteration, to: Py.errorTypes.stopIteration)
    self.setOrTrap(.syntaxError, to: Py.errorTypes.syntaxError)
    self.setOrTrap(.syntaxWarning, to: Py.errorTypes.syntaxWarning)
    self.setOrTrap(.systemError, to: Py.errorTypes.systemError)
    self.setOrTrap(.systemExit, to: Py.errorTypes.systemExit)
    self.setOrTrap(.tabError, to: Py.errorTypes.tabError)
    self.setOrTrap(.timeoutError, to: Py.errorTypes.timeoutError)
    self.setOrTrap(.typeError, to: Py.errorTypes.typeError)
    self.setOrTrap(.unboundLocalError, to: Py.errorTypes.unboundLocalError)
    self.setOrTrap(.unicodeDecodeError, to: Py.errorTypes.unicodeDecodeError)
    self.setOrTrap(.unicodeEncodeError, to: Py.errorTypes.unicodeEncodeError)
    self.setOrTrap(.unicodeError, to: Py.errorTypes.unicodeError)
    self.setOrTrap(.unicodeTranslateError, to: Py.errorTypes.unicodeTranslateError)
    self.setOrTrap(.unicodeWarning, to: Py.errorTypes.unicodeWarning)
    self.setOrTrap(.userWarning, to: Py.errorTypes.userWarning)
    self.setOrTrap(.valueError, to: Py.errorTypes.valueError)
    self.setOrTrap(.warning, to: Py.errorTypes.warning)
    self.setOrTrap(.zeroDivisionError, to: Py.errorTypes.zeroDivisionError)

    // MARK: - Functions

    // Not that capturing 'self' is intended.
    // See comment at the top of 'PyModuleImplementation' for details.
//    self.setOrTrap(.__build_class__, doc: Builtins.buildClassDoc,
//      fn: self.buildClass(args:kwargs:))
//    self.setOrTrap(.__import__, doc: Builtins.importDoc,
//      fn: self.__import__(args:kwargs:))
//    self.setOrTrap(.abs, doc: nil, fn: self.abs(_:))
//    self.setOrTrap(.all, doc: nil, fn: self.all(iterable:))
//    self.setOrTrap(.any, doc: nil, fn: self.any(iterable:))
//    self.setOrTrap(.ascii, doc: nil, fn: self.ascii(_:))
//    self.setOrTrap(.bin, doc: nil, fn: self.bin(_:))
//    self.setOrTrap(.breakpoint, doc: nil, fn: self.breakpoint)
//    self.setOrTrap(.callable, doc: nil, fn: self.isCallable(_:))
//    self.setOrTrap(.chr, doc: nil, fn: self.chr(_:))
//    self.setOrTrap(.compile, doc: nil, fn: self.compile(args:kwargs:))
//    self.setOrTrap(.delattr, doc: nil, fn: self.deleteAttribute(_:name:))
//    self.setOrTrap(.dir, doc: nil, fn: self.dir(_:))
//    self.setOrTrap(.divmod, doc: nil, fn: self.divmod(left:right:))
//    self.setOrTrap(.eval, doc: nil, fn: self.eval(args:kwargs:))
//    self.setOrTrap(.exec, doc: nil, fn: self.exec(args:kwargs:))
//    self.setOrTrap(.format, doc: nil, fn: self.format(value:format:))
//    self.setOrTrap(.getattr, doc: Builtins.getAttributeDoc,
//      fn: self.getAttribute(_:name:default:))
//    self.setOrTrap(.globals, doc: nil, fn: self.getGlobals)
//    self.setOrTrap(.hasattr, doc: nil, fn: self.hasAttribute(_:name:))
//    self.setOrTrap(.hash, doc: nil, fn: self.hash(_:))
//    self.setOrTrap(.help, doc: nil, fn: self.help)
//    self.setOrTrap(.hex, doc: nil, fn: self.hex(_:))
//    self.setOrTrap(.id, doc: nil, fn: self.id(_:))
//    self.setOrTrap(.input, doc: nil, fn: self.input)
//    self.setOrTrap(.isinstance, doc: Builtins.isInstanceDoc,
//      fn: self.isInstance(object:of:))
//    self.setOrTrap(.issubclass, doc: Builtins.isSubclassDoc,
//      fn: self.isSubclass(object:of:))
//    self.setOrTrap(.iter, doc: Builtins.iterDoc, fn: self.iter(from:sentinel:))
//    self.setOrTrap(.len, doc: nil, fn: self.length(iterable:))
//    self.setOrTrap(.locals, doc: nil, fn: self.getLocals)
//    self.setOrTrap(.max, doc: Builtins.maxDoc, fn: self.max(args:kwargs:))
//    self.setOrTrap(.memoryview, doc: nil, fn: self.memoryview)
//    self.setOrTrap(.min, doc: Builtins.minDoc, fn: self.min(args:kwargs:))
//    self.setOrTrap(.next, doc: Builtins.nextDoc, fn: self.next(iterator:default:))
//    self.setOrTrap(.oct, doc: nil, fn: self.oct(_:))
//    self.setOrTrap(.open, doc: nil, fn: self.open(args:kwargs:))
//    self.setOrTrap(.ord, doc: nil, fn: self.ord(_:))
//    self.setOrTrap(.pow, doc: nil, fn: self.pow(base:exp:mod:))
//    self.setOrTrap(.print, doc: nil, fn: self.print(args:kwargs:))
//    self.setOrTrap(.repr, doc: nil, fn: self.repr(_:))
//    self.setOrTrap(.round, doc: nil, fn: self.round(number:nDigits:))
//    self.setOrTrap(.setattr, doc: nil, fn: self.setAttribute(_:name:value:))
//    self.setOrTrap(.sorted, doc: nil, fn: self.sorted(args:kwargs:))
//    self.setOrTrap(.sum, doc: nil, fn: self.sum(args:kwargs:))
//    self.setOrTrap(.vars, doc: nil, fn: self.vars)
  }
}
