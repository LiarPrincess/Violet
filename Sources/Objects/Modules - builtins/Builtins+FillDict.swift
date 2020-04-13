import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable function_body_length
// ^ God knows we will need this one...

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
//    self.setOrTrap(.memoryview, to: Py.types.memoryview)
//    self.setOrTrap(.mappingproxy, to: Py.types.mappingproxy)
//    self.setOrTrap(.weakref, to: Py.types.weakref)

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

    self.setOrTrap(.__build_class__, doc: Self.buildClassDoc, fn: Self.buildClass(args:kwargs:))
    self.setOrTrap(.__import__, doc: Self.importDoc, fn: Self.__import__(args:kwargs:))
    self.setOrTrap(.abs, doc: nil, fn: Self.abs(object:))
    self.setOrTrap(.all, doc: nil, fn: Self.all(iterable:))
    self.setOrTrap(.any, doc: nil, fn: Self.any(iterable:))
    self.setOrTrap(.ascii, doc: nil, fn: Self.ascii(object:))
    self.setOrTrap(.bin, doc: nil, fn: Self.bin(object:))
//    self.setOrTrap(.breakpoint, doc: nil, fn: Self.breakpoint)
    self.setOrTrap(.callable, doc: nil, fn: Self.callable(object:))
    self.setOrTrap(.chr, doc: nil, fn: Self.chr(object:))
    self.setOrTrap(.compile, doc: nil, fn: Self.compile(args:kwargs:))
    self.setOrTrap(.delattr, doc: nil, fn: Self.delattr(object:name:))
    self.setOrTrap(.dir, doc: nil, fn: Self.dir(object:))
    self.setOrTrap(.divmod, doc: nil, fn: Self.divmod(left:right:))
    self.setOrTrap(.eval, doc: nil, fn: Self.eval(args:kwargs:))
    self.setOrTrap(.exec, doc: nil, fn: Self.exec(args:kwargs:))
//    self.setOrTrap(.format, doc: nil, fn: Self.format(value:format:))
    self.setOrTrap(.getattr, doc: Self.getAttributeDoc, fn: Self.getattr(object:name:default:))
    self.setOrTrap(.globals, doc: nil, fn: Self.globals)
    self.setOrTrap(.hasattr, doc: nil, fn: Self.hasattr(object:name:))
    self.setOrTrap(.hash, doc: nil, fn: Self.hash(object:))
//    self.setOrTrap(.help, doc: nil, fn: Self.help)
    self.setOrTrap(.hex, doc: nil, fn: Self.hex(object:))
    self.setOrTrap(.id, doc: nil, fn: Self.id(object:))
//    self.setOrTrap(.input, doc: nil, fn: Self.input)
    self.setOrTrap(.isinstance, doc: Self.isInstanceDoc, fn: Self.isinstance(object:of:))
    self.setOrTrap(.issubclass, doc: Self.isSubclassDoc, fn: Self.issubclass(object:of:))
    self.setOrTrap(.iter, doc: Self.iterDoc, fn: Self.iter(from:sentinel:))
    self.setOrTrap(.len, doc: nil, fn: Self.length(iterable:))
    self.setOrTrap(.locals, doc: nil, fn: Self.locals)
    self.setOrTrap(.max, doc: Self.maxDoc, fn: Self.max(args:kwargs:))
    self.setOrTrap(.min, doc: Self.minDoc, fn: Self.min(args:kwargs:))
    self.setOrTrap(.next, doc: Self.nextDoc, fn: Self.next(iterator:default:))
    self.setOrTrap(.oct, doc: nil, fn: Self.oct(object:))
    self.setOrTrap(.open, doc: nil, fn: Self.open(args:kwargs:))
    self.setOrTrap(.ord, doc: nil, fn: Self.ord(object:))
    self.setOrTrap(.pow, doc: nil, fn: Self.pow(base:exp:mod:))
    self.setOrTrap(.print, doc: nil, fn: Self.print(args:kwargs:))
    self.setOrTrap(.repr, doc: nil, fn: Self.repr(object:))
    self.setOrTrap(.round, doc: nil, fn: Self.round(number:nDigits:))
    self.setOrTrap(.setattr, doc: nil, fn: Self.setattr(object:name:value:))
    self.setOrTrap(.sorted, doc: nil, fn: Self.sorted(args:kwargs:))
    self.setOrTrap(.sum, doc: nil, fn: Self.sum(args:kwargs:))
//    self.setOrTrap(.vars, doc: nil, fn: Self.vars)
  }
}
