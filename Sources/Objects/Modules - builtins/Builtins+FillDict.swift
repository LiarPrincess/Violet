import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable line_length
// ^^^ This code was generated and it really makes sense in this case
// swiftlint:disable function_body_length
// ^^^ God knows we will need this one…

extension Builtins {

  private func setOrTrap(_ name: Properties, type: PyType) {
    self.setOrTrap(name, value: type)
  }

  internal func fill__dict__() {

    // MARK: - Values

    self.setOrTrap(.none, value: self.py.none.asObject)
    self.setOrTrap(.ellipsis, value: self.py.ellipsis.asObject)
    self.setOrTrap(.dotDotDot, value: self.py.ellipsis.asObject)
    self.setOrTrap(.notImplemented, value: self.py.notImplemented.asObject)
    self.setOrTrap(.true, value: self.py.true.asObject)
    self.setOrTrap(.false, value: self.py.false.asObject)

    // MARK: - Types

    // Not all of those types should be exposed from builtins module.
    // Some should require 'import types', but since we don't have 'types' module,
    // we will expose them from builtins.
    self.setOrTrap(.bool, type: self.py.types.bool)
    self.setOrTrap(.bytearray, type: self.py.types.bytearray)
    self.setOrTrap(.bytes, type: self.py.types.bytes)
    self.setOrTrap(.classmethod, type: self.py.types.classmethod)
    self.setOrTrap(.complex, type: self.py.types.complex)
    self.setOrTrap(.dict, type: self.py.types.dict)
    self.setOrTrap(.enumerate, type: self.py.types.enumerate)
    self.setOrTrap(.filter, type: self.py.types.filter)
    self.setOrTrap(.float, type: self.py.types.float)
    self.setOrTrap(.frozenset, type: self.py.types.frozenset)
    self.setOrTrap(.int, type: self.py.types.int)
    self.setOrTrap(.list, type: self.py.types.list)
    self.setOrTrap(.map, type: self.py.types.map)
    self.setOrTrap(.object, type: self.py.types.object)
    self.setOrTrap(.property, type: self.py.types.property)
    self.setOrTrap(.range, type: self.py.types.range)
    self.setOrTrap(.reversed, type: self.py.types.reversed)
    self.setOrTrap(.set, type: self.py.types.set)
    self.setOrTrap(.slice, type: self.py.types.slice)
    self.setOrTrap(.staticmethod, type: self.py.types.staticmethod)
    self.setOrTrap(.str, type: self.py.types.str)
    self.setOrTrap(.super, type: self.py.types.super)
    self.setOrTrap(.tuple, type: self.py.types.tuple)
    self.setOrTrap(.type, type: self.py.types.type)
    self.setOrTrap(.zip, type: self.py.types.zip)
//    self.setOrTrap(.memoryview, type: self.py.types.memoryview)
//    self.setOrTrap(.mappingproxy, type: self.py.types.mappingproxy)
//    self.setOrTrap(.weakref, type: self.py.types.weakref)

    // MARK: - Error types

    self.setOrTrap(.arithmeticError, type: self.py.errorTypes.arithmeticError)
    self.setOrTrap(.assertionError, type: self.py.errorTypes.assertionError)
    self.setOrTrap(.attributeError, type: self.py.errorTypes.attributeError)
    self.setOrTrap(.baseException, type: self.py.errorTypes.baseException)
    self.setOrTrap(.blockingIOError, type: self.py.errorTypes.blockingIOError)
    self.setOrTrap(.brokenPipeError, type: self.py.errorTypes.brokenPipeError)
    self.setOrTrap(.bufferError, type: self.py.errorTypes.bufferError)
    self.setOrTrap(.bytesWarning, type: self.py.errorTypes.bytesWarning)
    self.setOrTrap(.childProcessError, type: self.py.errorTypes.childProcessError)
    self.setOrTrap(.connectionAbortedError, type: self.py.errorTypes.connectionAbortedError)
    self.setOrTrap(.connectionError, type: self.py.errorTypes.connectionError)
    self.setOrTrap(.connectionRefusedError, type: self.py.errorTypes.connectionRefusedError)
    self.setOrTrap(.connectionResetError, type: self.py.errorTypes.connectionResetError)
    self.setOrTrap(.deprecationWarning, type: self.py.errorTypes.deprecationWarning)
    self.setOrTrap(.eofError, type: self.py.errorTypes.eofError)
    self.setOrTrap(.exception, type: self.py.errorTypes.exception)
    self.setOrTrap(.fileExistsError, type: self.py.errorTypes.fileExistsError)
    self.setOrTrap(.fileNotFoundError, type: self.py.errorTypes.fileNotFoundError)
    self.setOrTrap(.floatingPointError, type: self.py.errorTypes.floatingPointError)
    self.setOrTrap(.futureWarning, type: self.py.errorTypes.futureWarning)
    self.setOrTrap(.generatorExit, type: self.py.errorTypes.generatorExit)
    self.setOrTrap(.importError, type: self.py.errorTypes.importError)
    self.setOrTrap(.importWarning, type: self.py.errorTypes.importWarning)
    self.setOrTrap(.indentationError, type: self.py.errorTypes.indentationError)
    self.setOrTrap(.indexError, type: self.py.errorTypes.indexError)
    self.setOrTrap(.interruptedError, type: self.py.errorTypes.interruptedError)
    self.setOrTrap(.isADirectoryError, type: self.py.errorTypes.isADirectoryError)
    self.setOrTrap(.keyError, type: self.py.errorTypes.keyError)
    self.setOrTrap(.keyboardInterrupt, type: self.py.errorTypes.keyboardInterrupt)
    self.setOrTrap(.lookupError, type: self.py.errorTypes.lookupError)
    self.setOrTrap(.memoryError, type: self.py.errorTypes.memoryError)
    self.setOrTrap(.moduleNotFoundError, type: self.py.errorTypes.moduleNotFoundError)
    self.setOrTrap(.nameError, type: self.py.errorTypes.nameError)
    self.setOrTrap(.notADirectoryError, type: self.py.errorTypes.notADirectoryError)
    self.setOrTrap(.notImplementedError, type: self.py.errorTypes.notImplementedError)
    self.setOrTrap(.osError, type: self.py.errorTypes.osError)
    self.setOrTrap(.overflowError, type: self.py.errorTypes.overflowError)
    self.setOrTrap(.pendingDeprecationWarning, type: self.py.errorTypes.pendingDeprecationWarning)
    self.setOrTrap(.permissionError, type: self.py.errorTypes.permissionError)
    self.setOrTrap(.processLookupError, type: self.py.errorTypes.processLookupError)
    self.setOrTrap(.recursionError, type: self.py.errorTypes.recursionError)
    self.setOrTrap(.referenceError, type: self.py.errorTypes.referenceError)
    self.setOrTrap(.resourceWarning, type: self.py.errorTypes.resourceWarning)
    self.setOrTrap(.runtimeError, type: self.py.errorTypes.runtimeError)
    self.setOrTrap(.runtimeWarning, type: self.py.errorTypes.runtimeWarning)
    self.setOrTrap(.stopAsyncIteration, type: self.py.errorTypes.stopAsyncIteration)
    self.setOrTrap(.stopIteration, type: self.py.errorTypes.stopIteration)
    self.setOrTrap(.syntaxError, type: self.py.errorTypes.syntaxError)
    self.setOrTrap(.syntaxWarning, type: self.py.errorTypes.syntaxWarning)
    self.setOrTrap(.systemError, type: self.py.errorTypes.systemError)
    self.setOrTrap(.systemExit, type: self.py.errorTypes.systemExit)
    self.setOrTrap(.tabError, type: self.py.errorTypes.tabError)
    self.setOrTrap(.timeoutError, type: self.py.errorTypes.timeoutError)
    self.setOrTrap(.typeError, type: self.py.errorTypes.typeError)
    self.setOrTrap(.unboundLocalError, type: self.py.errorTypes.unboundLocalError)
    self.setOrTrap(.unicodeDecodeError, type: self.py.errorTypes.unicodeDecodeError)
    self.setOrTrap(.unicodeEncodeError, type: self.py.errorTypes.unicodeEncodeError)
    self.setOrTrap(.unicodeError, type: self.py.errorTypes.unicodeError)
    self.setOrTrap(.unicodeTranslateError, type: self.py.errorTypes.unicodeTranslateError)
    self.setOrTrap(.unicodeWarning, type: self.py.errorTypes.unicodeWarning)
    self.setOrTrap(.userWarning, type: self.py.errorTypes.userWarning)
    self.setOrTrap(.valueError, type: self.py.errorTypes.valueError)
    self.setOrTrap(.warning, type: self.py.errorTypes.warning)
    self.setOrTrap(.zeroDivisionError, type: self.py.errorTypes.zeroDivisionError)

    // MARK: - Functions

    self.setOrTrap(.__build_class__, doc: Self.__build_class__Doc, fn: Self.__build_class__(_:args:kwargs:))
    self.setOrTrap(.__import__, doc: Self.__import__Doc, fn: Self.__import__(_:args:kwargs:))
    self.setOrTrap(.abs, doc: Self.absDoc, fn: Self.abs(_:object:))
    self.setOrTrap(.all, doc: Self.allDoc, fn: Self.all(_:iterable:))
    self.setOrTrap(.any, doc: Self.anyDoc, fn: Self.any(_:iterable:))
    self.setOrTrap(.ascii, doc: Self.asciiDoc, fn: Self.ascii(_:object:))
    self.setOrTrap(.bin, doc: Self.binDoc, fn: Self.bin(_:object:))
//    self.setOrTrap(.breakpoint, doc: Self.breakpointDoc, fn: Self.breakpoint)
    self.setOrTrap(.callable, doc: Self.callableDoc, fn: Self.callable(_:object:))
    self.setOrTrap(.chr, doc: Self.chrDoc, fn: Self.chr(_:object:))
    self.setOrTrap(.compile, doc: Self.compileDoc, fn: Self.compile(_:args:kwargs:))
    self.setOrTrap(.delattr, doc: Self.delattrDoc, fn: Self.delattr(_:object:name:))
    self.setOrTrap(.dir, doc: Self.dirDoc, fn: Self.dir(_:object:))
    self.setOrTrap(.divmod, doc: Self.divmodDoc, fn: Self.divmod(_:left:right:))
    self.setOrTrap(.eval, doc: Self.evalDoc, fn: Self.eval(_:args:kwargs:))
    self.setOrTrap(.exec, doc: Self.execDoc, fn: Self.exec(_:args:kwargs:))
//    self.setOrTrap(.format, doc: Self.formatDoc, fn: Self.format(value:format:))
    self.setOrTrap(.getattr, doc: Self.getattrDoc, fn: Self.getattr(_:object:name:default:))
    self.setOrTrap(.globals, doc: Self.globalsDoc, fn: Self.globals(_:))
    self.setOrTrap(.hasattr, doc: Self.hasattrDoc, fn: Self.hasattr(_:object:name:))
    self.setOrTrap(.hash, doc: Self.hashDoc, fn: Self.hash(_:object:))
//    self.setOrTrap(.help, doc: Self.helpDoc, fn: Self.help)
    self.setOrTrap(.hex, doc: Self.hexDoc, fn: Self.hex(_:object:))
    self.setOrTrap(.id, doc: Self.idDoc, fn: Self.id(_:object:))
//    self.setOrTrap(.input, doc: Self.inputDoc, fn: Self.input)
    self.setOrTrap(.isinstance, doc: Self.isinstanceDoc, fn: Self.isinstance(_:object:of:))
    self.setOrTrap(.issubclass, doc: Self.issubclassDoc, fn: Self.issubclass(_:object:of:))
    self.setOrTrap(.iter, doc: Self.iterDoc, fn: Self.iter(_:object:sentinel:))
    self.setOrTrap(.len, doc: Self.lenDoc, fn: Self.len(_:iterable:))
    self.setOrTrap(.locals, doc: Self.localsDoc, fn: Self.locals(_:))
    self.setOrTrap(.max, doc: Self.maxDoc, fn: Self.max(_:args:kwargs:))
    self.setOrTrap(.min, doc: Self.minDoc, fn: Self.min(_:args:kwargs:))
    self.setOrTrap(.next, doc: Self.nextDoc, fn: Self.next(_:iterator:default:))
    self.setOrTrap(.oct, doc: Self.octDoc, fn: Self.oct(_:object:))
    self.setOrTrap(.open, doc: Self.openDoc, fn: Self.open(_:args:kwargs:))
    self.setOrTrap(.ord, doc: Self.ordDoc, fn: Self.ord(_:object:))
    self.setOrTrap(.pow, doc: Self.powDoc, fn: Self.pow(_:base:exp:mod:))
    self.setOrTrap(.print, doc: Self.printDoc, fn: Self.print(_:args:kwargs:))
    self.setOrTrap(.repr, doc: Self.reprDoc, fn: Self.repr(_:object:))
    self.setOrTrap(.round, doc: Self.roundDoc, fn: Self.round(_:number:nDigits:))
    self.setOrTrap(.setattr, doc: Self.setattrDoc, fn: Self.setattr(_:object:name:value:))
    self.setOrTrap(.sorted, doc: Self.sortedDoc, fn: Self.sorted(_:args:kwargs:))
    self.setOrTrap(.sum, doc: Self.sumDoc, fn: Self.sum(_:args:kwargs:))
//    self.setOrTrap(.vars, doc: Self.varsDoc, fn: Self.vars)
  }
}
