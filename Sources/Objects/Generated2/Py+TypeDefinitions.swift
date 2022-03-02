// ================================================================================
// Automatically generated from: ./Sources/Objects/Generated2/Py+TypeDefinitions.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ================================================================================

import BigInt
import VioletCore

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable trailing_comma
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

// Type initialization order:
//
// Stage 1: Create all type objects ('init()' function)
// Just instantiate all of the 'PyType' properties.
// At this point we can't fill '__dict__', because for this we would need other
// types to be already initialized (which would be circular).
// For example we can't insert '__doc__' because for this we would need 'str' type,
// which may not yet exist.
//
// Stage 2: Fill type objects ('fill__dict__()' method)
// When all of the types are initalized we can finally fill dictionaries.

extension Py {

  public final class Types {

    // MARK: - Properties

    public let bool: PyType
    public let builtinFunction: PyType
    public let builtinMethod: PyType
    public let bytearray: PyType
    public let bytearray_iterator: PyType
    public let bytes: PyType
    public let bytes_iterator: PyType
    public let callable_iterator: PyType
    public let cell: PyType
    public let classmethod: PyType
    public let code: PyType
    public let complex: PyType
    public let dict: PyType
    public let dict_itemiterator: PyType
    public let dict_items: PyType
    public let dict_keyiterator: PyType
    public let dict_keys: PyType
    public let dict_valueiterator: PyType
    public let dict_values: PyType
    public let ellipsis: PyType
    public let enumerate: PyType
    public let filter: PyType
    public let float: PyType
    public let frame: PyType
    public let frozenset: PyType
    public let function: PyType
    public let int: PyType
    public let iterator: PyType
    public let list: PyType
    public let list_iterator: PyType
    public let list_reverseiterator: PyType
    public let map: PyType
    public let method: PyType
    public let module: PyType
    public let simpleNamespace: PyType
    public let none: PyType
    public let notImplemented: PyType
    public let object: PyType
    public let property: PyType
    public let range: PyType
    public let range_iterator: PyType
    public let reversed: PyType
    public let set: PyType
    public let set_iterator: PyType
    public let slice: PyType
    public let staticmethod: PyType
    public let str: PyType
    public let str_iterator: PyType
    public let `super`: PyType
    public let textFile: PyType
    public let tuple: PyType
    public let tuple_iterator: PyType
    public let type: PyType
    public let zip: PyType

    // MARK: - Stage 1 - init

    /// Init that will only initialize properties.
    /// (see comment at the top of this file)
    internal init(_ py: Py) {
      let memory = py.memory

      // Requirements for 'self.object' and 'self.type':
      // 1. 'type' inherits from 'object'
      // 2. both 'type' and 'object' are instances of 'type'
      let pair = memory.newTypeAndObjectTypes(py)
      self.object = pair.objectType
      self.type = pair.typeType

      // Btw. 'self.bool' has to be last because it uses 'self.int' as base!

      self.builtinFunction = memory.newType(
        py,
        type: self.type,
        name: "builtinFunction",
        qualname: "builtinFunction",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.builtinFunctionMemoryLayout,
        staticMethods: Py.Types.builtinFunctionStaticMethods,
        debugFn: PyBuiltinFunction.createDebugString(ptr:),
        deinitialize: PyBuiltinFunction.deinitialize(ptr:)
      )

      self.builtinMethod = memory.newType(
        py,
        type: self.type,
        name: "builtinMethod",
        qualname: "builtinMethod",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.builtinMethodMemoryLayout,
        staticMethods: Py.Types.builtinMethodStaticMethods,
        debugFn: PyBuiltinMethod.createDebugString(ptr:),
        deinitialize: PyBuiltinMethod.deinitialize(ptr:)
      )

      self.bytearray = memory.newType(
        py,
        type: self.type,
        name: "bytearray",
        qualname: "bytearray",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.byteArrayMemoryLayout,
        staticMethods: Py.Types.byteArrayStaticMethods,
        debugFn: PyByteArray.createDebugString(ptr:),
        deinitialize: PyByteArray.deinitialize(ptr:)
      )

      self.bytearray_iterator = memory.newType(
        py,
        type: self.type,
        name: "bytearray_iterator",
        qualname: "bytearray_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.byteArrayIteratorMemoryLayout,
        staticMethods: Py.Types.byteArrayIteratorStaticMethods,
        debugFn: PyByteArrayIterator.createDebugString(ptr:),
        deinitialize: PyByteArrayIterator.deinitialize(ptr:)
      )

      self.bytes = memory.newType(
        py,
        type: self.type,
        name: "bytes",
        qualname: "bytes",
        flags: [.isBaseTypeFlag, .isBytesSubclassFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.bytesMemoryLayout,
        staticMethods: Py.Types.bytesStaticMethods,
        debugFn: PyBytes.createDebugString(ptr:),
        deinitialize: PyBytes.deinitialize(ptr:)
      )

      self.bytes_iterator = memory.newType(
        py,
        type: self.type,
        name: "bytes_iterator",
        qualname: "bytes_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.bytesIteratorMemoryLayout,
        staticMethods: Py.Types.bytesIteratorStaticMethods,
        debugFn: PyBytesIterator.createDebugString(ptr:),
        deinitialize: PyBytesIterator.deinitialize(ptr:)
      )

      self.callable_iterator = memory.newType(
        py,
        type: self.type,
        name: "callable_iterator",
        qualname: "callable_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.callableIteratorMemoryLayout,
        staticMethods: Py.Types.callableIteratorStaticMethods,
        debugFn: PyCallableIterator.createDebugString(ptr:),
        deinitialize: PyCallableIterator.deinitialize(ptr:)
      )

      self.cell = memory.newType(
        py,
        type: self.type,
        name: "cell",
        qualname: "cell",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.cellMemoryLayout,
        staticMethods: Py.Types.cellStaticMethods,
        debugFn: PyCell.createDebugString(ptr:),
        deinitialize: PyCell.deinitialize(ptr:)
      )

      self.classmethod = memory.newType(
        py,
        type: self.type,
        name: "classmethod",
        qualname: "classmethod",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.classMethodMemoryLayout,
        staticMethods: Py.Types.classMethodStaticMethods,
        debugFn: PyClassMethod.createDebugString(ptr:),
        deinitialize: PyClassMethod.deinitialize(ptr:)
      )

      self.code = memory.newType(
        py,
        type: self.type,
        name: "code",
        qualname: "code",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.codeMemoryLayout,
        staticMethods: Py.Types.codeStaticMethods,
        debugFn: PyCode.createDebugString(ptr:),
        deinitialize: PyCode.deinitialize(ptr:)
      )

      self.complex = memory.newType(
        py,
        type: self.type,
        name: "complex",
        qualname: "complex",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.complexMemoryLayout,
        staticMethods: Py.Types.complexStaticMethods,
        debugFn: PyComplex.createDebugString(ptr:),
        deinitialize: PyComplex.deinitialize(ptr:)
      )

      self.dict = memory.newType(
        py,
        type: self.type,
        name: "dict",
        qualname: "dict",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .isDictSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.dictMemoryLayout,
        staticMethods: Py.Types.dictStaticMethods,
        debugFn: PyDict.createDebugString(ptr:),
        deinitialize: PyDict.deinitialize(ptr:)
      )

      self.dict_itemiterator = memory.newType(
        py,
        type: self.type,
        name: "dict_itemiterator",
        qualname: "dict_itemiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.dictItemIteratorMemoryLayout,
        staticMethods: Py.Types.dictItemIteratorStaticMethods,
        debugFn: PyDictItemIterator.createDebugString(ptr:),
        deinitialize: PyDictItemIterator.deinitialize(ptr:)
      )

      self.dict_items = memory.newType(
        py,
        type: self.type,
        name: "dict_items",
        qualname: "dict_items",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.dictItemsMemoryLayout,
        staticMethods: Py.Types.dictItemsStaticMethods,
        debugFn: PyDictItems.createDebugString(ptr:),
        deinitialize: PyDictItems.deinitialize(ptr:)
      )

      self.dict_keyiterator = memory.newType(
        py,
        type: self.type,
        name: "dict_keyiterator",
        qualname: "dict_keyiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.dictKeyIteratorMemoryLayout,
        staticMethods: Py.Types.dictKeyIteratorStaticMethods,
        debugFn: PyDictKeyIterator.createDebugString(ptr:),
        deinitialize: PyDictKeyIterator.deinitialize(ptr:)
      )

      self.dict_keys = memory.newType(
        py,
        type: self.type,
        name: "dict_keys",
        qualname: "dict_keys",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.dictKeysMemoryLayout,
        staticMethods: Py.Types.dictKeysStaticMethods,
        debugFn: PyDictKeys.createDebugString(ptr:),
        deinitialize: PyDictKeys.deinitialize(ptr:)
      )

      self.dict_valueiterator = memory.newType(
        py,
        type: self.type,
        name: "dict_valueiterator",
        qualname: "dict_valueiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.dictValueIteratorMemoryLayout,
        staticMethods: Py.Types.dictValueIteratorStaticMethods,
        debugFn: PyDictValueIterator.createDebugString(ptr:),
        deinitialize: PyDictValueIterator.deinitialize(ptr:)
      )

      self.dict_values = memory.newType(
        py,
        type: self.type,
        name: "dict_values",
        qualname: "dict_values",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.dictValuesMemoryLayout,
        staticMethods: Py.Types.dictValuesStaticMethods,
        debugFn: PyDictValues.createDebugString(ptr:),
        deinitialize: PyDictValues.deinitialize(ptr:)
      )

      self.ellipsis = memory.newType(
        py,
        type: self.type,
        name: "ellipsis",
        qualname: "ellipsis",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.ellipsisMemoryLayout,
        staticMethods: Py.Types.ellipsisStaticMethods,
        debugFn: PyEllipsis.createDebugString(ptr:),
        deinitialize: PyEllipsis.deinitialize(ptr:)
      )

      self.enumerate = memory.newType(
        py,
        type: self.type,
        name: "enumerate",
        qualname: "enumerate",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.enumerateMemoryLayout,
        staticMethods: Py.Types.enumerateStaticMethods,
        debugFn: PyEnumerate.createDebugString(ptr:),
        deinitialize: PyEnumerate.deinitialize(ptr:)
      )

      self.filter = memory.newType(
        py,
        type: self.type,
        name: "filter",
        qualname: "filter",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.filterMemoryLayout,
        staticMethods: Py.Types.filterStaticMethods,
        debugFn: PyFilter.createDebugString(ptr:),
        deinitialize: PyFilter.deinitialize(ptr:)
      )

      self.float = memory.newType(
        py,
        type: self.type,
        name: "float",
        qualname: "float",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.floatMemoryLayout,
        staticMethods: Py.Types.floatStaticMethods,
        debugFn: PyFloat.createDebugString(ptr:),
        deinitialize: PyFloat.deinitialize(ptr:)
      )

      self.frame = memory.newType(
        py,
        type: self.type,
        name: "frame",
        qualname: "frame",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.frameMemoryLayout,
        staticMethods: Py.Types.frameStaticMethods,
        debugFn: PyFrame.createDebugString(ptr:),
        deinitialize: PyFrame.deinitialize(ptr:)
      )

      self.frozenset = memory.newType(
        py,
        type: self.type,
        name: "frozenset",
        qualname: "frozenset",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.frozenSetMemoryLayout,
        staticMethods: Py.Types.frozenSetStaticMethods,
        debugFn: PyFrozenSet.createDebugString(ptr:),
        deinitialize: PyFrozenSet.deinitialize(ptr:)
      )

      self.function = memory.newType(
        py,
        type: self.type,
        name: "function",
        qualname: "function",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.functionMemoryLayout,
        staticMethods: Py.Types.functionStaticMethods,
        debugFn: PyFunction.createDebugString(ptr:),
        deinitialize: PyFunction.deinitialize(ptr:)
      )

      self.int = memory.newType(
        py,
        type: self.type,
        name: "int",
        qualname: "int",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .isLongSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.intMemoryLayout,
        staticMethods: Py.Types.intStaticMethods,
        debugFn: PyInt.createDebugString(ptr:),
        deinitialize: PyInt.deinitialize(ptr:)
      )

      self.iterator = memory.newType(
        py,
        type: self.type,
        name: "iterator",
        qualname: "iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.iteratorMemoryLayout,
        staticMethods: Py.Types.iteratorStaticMethods,
        debugFn: PyIterator.createDebugString(ptr:),
        deinitialize: PyIterator.deinitialize(ptr:)
      )

      self.list = memory.newType(
        py,
        type: self.type,
        name: "list",
        qualname: "list",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .isListSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.listMemoryLayout,
        staticMethods: Py.Types.listStaticMethods,
        debugFn: PyList.createDebugString(ptr:),
        deinitialize: PyList.deinitialize(ptr:)
      )

      self.list_iterator = memory.newType(
        py,
        type: self.type,
        name: "list_iterator",
        qualname: "list_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.listIteratorMemoryLayout,
        staticMethods: Py.Types.listIteratorStaticMethods,
        debugFn: PyListIterator.createDebugString(ptr:),
        deinitialize: PyListIterator.deinitialize(ptr:)
      )

      self.list_reverseiterator = memory.newType(
        py,
        type: self.type,
        name: "list_reverseiterator",
        qualname: "list_reverseiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.listReverseIteratorMemoryLayout,
        staticMethods: Py.Types.listReverseIteratorStaticMethods,
        debugFn: PyListReverseIterator.createDebugString(ptr:),
        deinitialize: PyListReverseIterator.deinitialize(ptr:)
      )

      self.map = memory.newType(
        py,
        type: self.type,
        name: "map",
        qualname: "map",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.mapMemoryLayout,
        staticMethods: Py.Types.mapStaticMethods,
        debugFn: PyMap.createDebugString(ptr:),
        deinitialize: PyMap.deinitialize(ptr:)
      )

      self.method = memory.newType(
        py,
        type: self.type,
        name: "method",
        qualname: "method",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.methodMemoryLayout,
        staticMethods: Py.Types.methodStaticMethods,
        debugFn: PyMethod.createDebugString(ptr:),
        deinitialize: PyMethod.deinitialize(ptr:)
      )

      self.module = memory.newType(
        py,
        type: self.type,
        name: "module",
        qualname: "module",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.moduleMemoryLayout,
        staticMethods: Py.Types.moduleStaticMethods,
        debugFn: PyModule.createDebugString(ptr:),
        deinitialize: PyModule.deinitialize(ptr:)
      )

      self.simpleNamespace = memory.newType(
        py,
        type: self.type,
        name: "SimpleNamespace",
        qualname: "SimpleNamespace",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.namespaceMemoryLayout,
        staticMethods: Py.Types.namespaceStaticMethods,
        debugFn: PyNamespace.createDebugString(ptr:),
        deinitialize: PyNamespace.deinitialize(ptr:)
      )

      self.none = memory.newType(
        py,
        type: self.type,
        name: "NoneType",
        qualname: "NoneType",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.noneMemoryLayout,
        staticMethods: Py.Types.noneStaticMethods,
        debugFn: PyNone.createDebugString(ptr:),
        deinitialize: PyNone.deinitialize(ptr:)
      )

      self.notImplemented = memory.newType(
        py,
        type: self.type,
        name: "NotImplementedType",
        qualname: "NotImplementedType",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.notImplementedMemoryLayout,
        staticMethods: Py.Types.notImplementedStaticMethods,
        debugFn: PyNotImplemented.createDebugString(ptr:),
        deinitialize: PyNotImplemented.deinitialize(ptr:)
      )

      self.property = memory.newType(
        py,
        type: self.type,
        name: "property",
        qualname: "property",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.propertyMemoryLayout,
        staticMethods: Py.Types.propertyStaticMethods,
        debugFn: PyProperty.createDebugString(ptr:),
        deinitialize: PyProperty.deinitialize(ptr:)
      )

      self.range = memory.newType(
        py,
        type: self.type,
        name: "range",
        qualname: "range",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.rangeMemoryLayout,
        staticMethods: Py.Types.rangeStaticMethods,
        debugFn: PyRange.createDebugString(ptr:),
        deinitialize: PyRange.deinitialize(ptr:)
      )

      self.range_iterator = memory.newType(
        py,
        type: self.type,
        name: "range_iterator",
        qualname: "range_iterator",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.rangeIteratorMemoryLayout,
        staticMethods: Py.Types.rangeIteratorStaticMethods,
        debugFn: PyRangeIterator.createDebugString(ptr:),
        deinitialize: PyRangeIterator.deinitialize(ptr:)
      )

      self.reversed = memory.newType(
        py,
        type: self.type,
        name: "reversed",
        qualname: "reversed",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.reversedMemoryLayout,
        staticMethods: Py.Types.reversedStaticMethods,
        debugFn: PyReversed.createDebugString(ptr:),
        deinitialize: PyReversed.deinitialize(ptr:)
      )

      self.set = memory.newType(
        py,
        type: self.type,
        name: "set",
        qualname: "set",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.setMemoryLayout,
        staticMethods: Py.Types.setStaticMethods,
        debugFn: PySet.createDebugString(ptr:),
        deinitialize: PySet.deinitialize(ptr:)
      )

      self.set_iterator = memory.newType(
        py,
        type: self.type,
        name: "set_iterator",
        qualname: "set_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.setIteratorMemoryLayout,
        staticMethods: Py.Types.setIteratorStaticMethods,
        debugFn: PySetIterator.createDebugString(ptr:),
        deinitialize: PySetIterator.deinitialize(ptr:)
      )

      self.slice = memory.newType(
        py,
        type: self.type,
        name: "slice",
        qualname: "slice",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.sliceMemoryLayout,
        staticMethods: Py.Types.sliceStaticMethods,
        debugFn: PySlice.createDebugString(ptr:),
        deinitialize: PySlice.deinitialize(ptr:)
      )

      self.staticmethod = memory.newType(
        py,
        type: self.type,
        name: "staticmethod",
        qualname: "staticmethod",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.staticMethodMemoryLayout,
        staticMethods: Py.Types.staticMethodStaticMethods,
        debugFn: PyStaticMethod.createDebugString(ptr:),
        deinitialize: PyStaticMethod.deinitialize(ptr:)
      )

      self.str = memory.newType(
        py,
        type: self.type,
        name: "str",
        qualname: "str",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .isUnicodeSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.stringMemoryLayout,
        staticMethods: Py.Types.stringStaticMethods,
        debugFn: PyString.createDebugString(ptr:),
        deinitialize: PyString.deinitialize(ptr:)
      )

      self.str_iterator = memory.newType(
        py,
        type: self.type,
        name: "str_iterator",
        qualname: "str_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.stringIteratorMemoryLayout,
        staticMethods: Py.Types.stringIteratorStaticMethods,
        debugFn: PyStringIterator.createDebugString(ptr:),
        deinitialize: PyStringIterator.deinitialize(ptr:)
      )

      self.`super` = memory.newType(
        py,
        type: self.type,
        name: "super",
        qualname: "super",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.superMemoryLayout,
        staticMethods: Py.Types.superStaticMethods,
        debugFn: PySuper.createDebugString(ptr:),
        deinitialize: PySuper.deinitialize(ptr:)
      )

      self.textFile = memory.newType(
        py,
        type: self.type,
        name: "TextFile",
        qualname: "TextFile",
        flags: [.hasFinalizeFlag, .hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.textFileMemoryLayout,
        staticMethods: Py.Types.textFileStaticMethods,
        debugFn: PyTextFile.createDebugString(ptr:),
        deinitialize: PyTextFile.deinitialize(ptr:)
      )

      self.tuple = memory.newType(
        py,
        type: self.type,
        name: "tuple",
        qualname: "tuple",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .isTupleSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.tupleMemoryLayout,
        staticMethods: Py.Types.tupleStaticMethods,
        debugFn: PyTuple.createDebugString(ptr:),
        deinitialize: PyTuple.deinitialize(ptr:)
      )

      self.tuple_iterator = memory.newType(
        py,
        type: self.type,
        name: "tuple_iterator",
        qualname: "tuple_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.tupleIteratorMemoryLayout,
        staticMethods: Py.Types.tupleIteratorStaticMethods,
        debugFn: PyTupleIterator.createDebugString(ptr:),
        deinitialize: PyTupleIterator.deinitialize(ptr:)
      )

      self.zip = memory.newType(
        py,
        type: self.type,
        name: "zip",
        qualname: "zip",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        layout: Py.Types.zipMemoryLayout,
        staticMethods: Py.Types.zipStaticMethods,
        debugFn: PyZip.createDebugString(ptr:),
        deinitialize: PyZip.deinitialize(ptr:)
      )

      // And now we can set 'bool' (because we have 'self.int').
      self.bool = memory.newType(
        py,
        type: self.type,
        name: "bool",
        qualname: "bool",
        flags: [.isDefaultFlag, .isLongSubclassFlag],
        base: self.int,
        bases: [self.int, self.object],
        mroWithoutSelf: [self.int, self.object],
        subclasses: [],
        layout: Py.Types.boolMemoryLayout,
        staticMethods: Py.Types.boolStaticMethods,
        debugFn: PyBool.createDebugString(ptr:),
        deinitialize: PyBool.deinitialize(ptr:)
      )
    }

    // MARK: - Stage 2 - fill __dict__

    /// This function finalizes init of all of the stored types.
    /// (see comment at the top of this file)
    ///
    /// For example it will:
    /// - add `__doc__`
    /// - fill `__dict__`
    internal func fill__dict__(_ py: Py) {
      self.fillBool(py)
      self.fillBuiltinFunction(py)
      self.fillBuiltinMethod(py)
      self.fillByteArray(py)
      self.fillByteArrayIterator(py)
      self.fillBytes(py)
      self.fillBytesIterator(py)
      self.fillCallableIterator(py)
      self.fillCell(py)
      self.fillClassMethod(py)
      self.fillCode(py)
      self.fillComplex(py)
      self.fillDict(py)
      self.fillDictItemIterator(py)
      self.fillDictItems(py)
      self.fillDictKeyIterator(py)
      self.fillDictKeys(py)
      self.fillDictValueIterator(py)
      self.fillDictValues(py)
      self.fillEllipsis(py)
      self.fillEnumerate(py)
      self.fillFilter(py)
      self.fillFloat(py)
      self.fillFrame(py)
      self.fillFrozenSet(py)
      self.fillFunction(py)
      self.fillInt(py)
      self.fillIterator(py)
      self.fillList(py)
      self.fillListIterator(py)
      self.fillListReverseIterator(py)
      self.fillMap(py)
      self.fillMethod(py)
      self.fillModule(py)
      self.fillNamespace(py)
      self.fillNone(py)
      self.fillNotImplemented(py)
      self.fillObject(py)
      self.fillProperty(py)
      self.fillRange(py)
      self.fillRangeIterator(py)
      self.fillReversed(py)
      self.fillSet(py)
      self.fillSetIterator(py)
      self.fillSlice(py)
      self.fillStaticMethod(py)
      self.fillString(py)
      self.fillStringIterator(py)
      self.fillSuper(py)
      self.fillTextFile(py)
      self.fillTuple(py)
      self.fillTupleIterator(py)
      self.fillType(py)
      self.fillZip(py)
    }

    // MARK: - Helpers

    /// Adds value to `type.__dict__`.
    private func add<T: PyObjectMixin>(_ py: Py, type: PyType, name: String, value: T) {
      let __dict__ = type.header.__dict__
      let interned = py.intern(string: name)

      switch __dict__.set(key: interned, to: value.asObject) {
      case .ok:
        break
      case .error(let e):
        let typeName = type.getNameString()
        trap("Error when adding '\(name)' to '\(typeName)' type: \(e)")
      }
    }

    // MARK: - Bool

    private func fillBool(_ py: Py) {
      let type = self.bool
      type.setBuiltinTypeDoc(PyBool.doc)
    }

    internal static let boolStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let boolMemoryLayout = PyType.MemoryLayout()

    // MARK: - BuiltinFunction

    private func fillBuiltinFunction(_ py: Py) {
      let type = self.builtinFunction
      type.setBuiltinTypeDoc(nil)
    }

    internal static let builtinFunctionStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let builtinFunctionMemoryLayout = PyType.MemoryLayout()

    // MARK: - BuiltinMethod

    private func fillBuiltinMethod(_ py: Py) {
      let type = self.builtinMethod
      type.setBuiltinTypeDoc(nil)
    }

    internal static let builtinMethodStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let builtinMethodMemoryLayout = PyType.MemoryLayout()

    // MARK: - ByteArray

    private func fillByteArray(_ py: Py) {
      let type = self.bytearray
      type.setBuiltinTypeDoc(PyByteArray.doc)
    }

    internal static let byteArrayStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let byteArrayMemoryLayout = PyType.MemoryLayout()

    // MARK: - ByteArrayIterator

    private func fillByteArrayIterator(_ py: Py) {
      let type = self.bytearray_iterator
      type.setBuiltinTypeDoc(PyByteArrayIterator.doc)
    }

    internal static let byteArrayIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let byteArrayIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Bytes

    private func fillBytes(_ py: Py) {
      let type = self.bytes
      type.setBuiltinTypeDoc(PyBytes.doc)
    }

    internal static let bytesStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let bytesMemoryLayout = PyType.MemoryLayout()

    // MARK: - BytesIterator

    private func fillBytesIterator(_ py: Py) {
      let type = self.bytes_iterator
      type.setBuiltinTypeDoc(PyBytesIterator.doc)
    }

    internal static let bytesIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let bytesIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - CallableIterator

    private func fillCallableIterator(_ py: Py) {
      let type = self.callable_iterator
      type.setBuiltinTypeDoc(PyCallableIterator.doc)
    }

    internal static let callableIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let callableIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Cell

    private func fillCell(_ py: Py) {
      let type = self.cell
      type.setBuiltinTypeDoc(nil)
    }

    internal static let cellStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let cellMemoryLayout = PyType.MemoryLayout()

    // MARK: - ClassMethod

    private func fillClassMethod(_ py: Py) {
      let type = self.classmethod
      type.setBuiltinTypeDoc(PyClassMethod.doc)
    }

    internal static let classMethodStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let classMethodMemoryLayout = PyType.MemoryLayout()

    // MARK: - Code

    private func fillCode(_ py: Py) {
      let type = self.code
      type.setBuiltinTypeDoc(PyCode.doc)
    }

    internal static let codeStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let codeMemoryLayout = PyType.MemoryLayout()

    // MARK: - Complex

    private func fillComplex(_ py: Py) {
      let type = self.complex
      type.setBuiltinTypeDoc(PyComplex.doc)
    }

    internal static let complexStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let complexMemoryLayout = PyType.MemoryLayout()

    // MARK: - Dict

    private func fillDict(_ py: Py) {
      let type = self.dict
      type.setBuiltinTypeDoc(PyDict.doc)
    }

    internal static let dictStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let dictMemoryLayout = PyType.MemoryLayout()

    // MARK: - DictItemIterator

    private func fillDictItemIterator(_ py: Py) {
      let type = self.dict_itemiterator
      type.setBuiltinTypeDoc(PyDictItemIterator.doc)
    }

    internal static let dictItemIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let dictItemIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - DictItems

    private func fillDictItems(_ py: Py) {
      let type = self.dict_items
      type.setBuiltinTypeDoc(PyDictItems.doc)
    }

    internal static let dictItemsStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let dictItemsMemoryLayout = PyType.MemoryLayout()

    // MARK: - DictKeyIterator

    private func fillDictKeyIterator(_ py: Py) {
      let type = self.dict_keyiterator
      type.setBuiltinTypeDoc(PyDictKeyIterator.doc)
    }

    internal static let dictKeyIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let dictKeyIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - DictKeys

    private func fillDictKeys(_ py: Py) {
      let type = self.dict_keys
      type.setBuiltinTypeDoc(PyDictKeys.doc)
    }

    internal static let dictKeysStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let dictKeysMemoryLayout = PyType.MemoryLayout()

    // MARK: - DictValueIterator

    private func fillDictValueIterator(_ py: Py) {
      let type = self.dict_valueiterator
      type.setBuiltinTypeDoc(PyDictValueIterator.doc)
    }

    internal static let dictValueIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let dictValueIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - DictValues

    private func fillDictValues(_ py: Py) {
      let type = self.dict_values
      type.setBuiltinTypeDoc(PyDictValues.doc)
    }

    internal static let dictValuesStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let dictValuesMemoryLayout = PyType.MemoryLayout()

    // MARK: - Ellipsis

    private func fillEllipsis(_ py: Py) {
      let type = self.ellipsis
      type.setBuiltinTypeDoc(PyEllipsis.doc)
    }

    internal static let ellipsisStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let ellipsisMemoryLayout = PyType.MemoryLayout()

    // MARK: - Enumerate

    private func fillEnumerate(_ py: Py) {
      let type = self.enumerate
      type.setBuiltinTypeDoc(PyEnumerate.doc)
    }

    internal static let enumerateStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let enumerateMemoryLayout = PyType.MemoryLayout()

    // MARK: - Filter

    private func fillFilter(_ py: Py) {
      let type = self.filter
      type.setBuiltinTypeDoc(PyFilter.doc)
    }

    internal static let filterStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let filterMemoryLayout = PyType.MemoryLayout()

    // MARK: - Float

    private func fillFloat(_ py: Py) {
      let type = self.float
      type.setBuiltinTypeDoc(PyFloat.doc)
    }

    internal static let floatStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let floatMemoryLayout = PyType.MemoryLayout()

    // MARK: - Frame

    private func fillFrame(_ py: Py) {
      let type = self.frame
      type.setBuiltinTypeDoc(PyFrame.doc)
    }

    internal static let frameStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let frameMemoryLayout = PyType.MemoryLayout()

    // MARK: - FrozenSet

    private func fillFrozenSet(_ py: Py) {
      let type = self.frozenset
      type.setBuiltinTypeDoc(PyFrozenSet.doc)
    }

    internal static let frozenSetStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let frozenSetMemoryLayout = PyType.MemoryLayout()

    // MARK: - Function

    private func fillFunction(_ py: Py) {
      let type = self.function
      type.setBuiltinTypeDoc(PyFunction.doc)
    }

    internal static let functionStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let functionMemoryLayout = PyType.MemoryLayout()

    // MARK: - Int

    private func fillInt(_ py: Py) {
      let type = self.int
      type.setBuiltinTypeDoc(PyInt.doc)
    }

    internal static let intStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let intMemoryLayout = PyType.MemoryLayout()

    // MARK: - Iterator

    private func fillIterator(_ py: Py) {
      let type = self.iterator
      type.setBuiltinTypeDoc(PyIterator.doc)
    }

    internal static let iteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let iteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - List

    private func fillList(_ py: Py) {
      let type = self.list
      type.setBuiltinTypeDoc(PyList.doc)
    }

    internal static let listStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let listMemoryLayout = PyType.MemoryLayout()

    // MARK: - ListIterator

    private func fillListIterator(_ py: Py) {
      let type = self.list_iterator
      type.setBuiltinTypeDoc(PyListIterator.doc)
    }

    internal static let listIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let listIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ListReverseIterator

    private func fillListReverseIterator(_ py: Py) {
      let type = self.list_reverseiterator
      type.setBuiltinTypeDoc(PyListReverseIterator.doc)
    }

    internal static let listReverseIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let listReverseIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Map

    private func fillMap(_ py: Py) {
      let type = self.map
      type.setBuiltinTypeDoc(PyMap.doc)
    }

    internal static let mapStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let mapMemoryLayout = PyType.MemoryLayout()

    // MARK: - Method

    private func fillMethod(_ py: Py) {
      let type = self.method
      type.setBuiltinTypeDoc(PyMethod.doc)
    }

    internal static let methodStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let methodMemoryLayout = PyType.MemoryLayout()

    // MARK: - Module

    private func fillModule(_ py: Py) {
      let type = self.module
      type.setBuiltinTypeDoc(PyModule.doc)
    }

    internal static let moduleStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let moduleMemoryLayout = PyType.MemoryLayout()

    // MARK: - Namespace

    private func fillNamespace(_ py: Py) {
      let type = self.simpleNamespace
      type.setBuiltinTypeDoc(PyNamespace.doc)
    }

    internal static let namespaceStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let namespaceMemoryLayout = PyType.MemoryLayout()

    // MARK: - None

    private func fillNone(_ py: Py) {
      let type = self.none
      type.setBuiltinTypeDoc(PyNone.doc)
    }

    internal static let noneStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let noneMemoryLayout = PyType.MemoryLayout()

    // MARK: - NotImplemented

    private func fillNotImplemented(_ py: Py) {
      let type = self.notImplemented
      type.setBuiltinTypeDoc(PyNotImplemented.doc)
    }

    internal static let notImplementedStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let notImplementedMemoryLayout = PyType.MemoryLayout()

    // MARK: - Object

    private func fillObject(_ py: Py) {
      let type = self.object
      type.setBuiltinTypeDoc(PyObject.doc)
    }

    internal static let objectStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let objectMemoryLayout = PyType.MemoryLayout()

    // MARK: - Property

    private func fillProperty(_ py: Py) {
      let type = self.property
      type.setBuiltinTypeDoc(PyProperty.doc)
    }

    internal static let propertyStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let propertyMemoryLayout = PyType.MemoryLayout()

    // MARK: - Range

    private func fillRange(_ py: Py) {
      let type = self.range
      type.setBuiltinTypeDoc(PyRange.doc)
    }

    internal static let rangeStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let rangeMemoryLayout = PyType.MemoryLayout()

    // MARK: - RangeIterator

    private func fillRangeIterator(_ py: Py) {
      let type = self.range_iterator
      type.setBuiltinTypeDoc(PyRangeIterator.doc)
    }

    internal static let rangeIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let rangeIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Reversed

    private func fillReversed(_ py: Py) {
      let type = self.reversed
      type.setBuiltinTypeDoc(PyReversed.doc)
    }

    internal static let reversedStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let reversedMemoryLayout = PyType.MemoryLayout()

    // MARK: - Set

    private func fillSet(_ py: Py) {
      let type = self.set
      type.setBuiltinTypeDoc(PySet.doc)
    }

    internal static let setStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let setMemoryLayout = PyType.MemoryLayout()

    // MARK: - SetIterator

    private func fillSetIterator(_ py: Py) {
      let type = self.set_iterator
      type.setBuiltinTypeDoc(PySetIterator.doc)
    }

    internal static let setIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let setIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Slice

    private func fillSlice(_ py: Py) {
      let type = self.slice
      type.setBuiltinTypeDoc(PySlice.doc)
    }

    internal static let sliceStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let sliceMemoryLayout = PyType.MemoryLayout()

    // MARK: - StaticMethod

    private func fillStaticMethod(_ py: Py) {
      let type = self.staticmethod
      type.setBuiltinTypeDoc(PyStaticMethod.doc)
    }

    internal static let staticMethodStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let staticMethodMemoryLayout = PyType.MemoryLayout()

    // MARK: - String

    private func fillString(_ py: Py) {
      let type = self.str
      type.setBuiltinTypeDoc(PyString.doc)
    }

    internal static let stringStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let stringMemoryLayout = PyType.MemoryLayout()

    // MARK: - StringIterator

    private func fillStringIterator(_ py: Py) {
      let type = self.str_iterator
      type.setBuiltinTypeDoc(PyStringIterator.doc)
    }

    internal static let stringIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let stringIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Super

    private func fillSuper(_ py: Py) {
      let type = self.super
      type.setBuiltinTypeDoc(PySuper.doc)
    }

    internal static let superStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let superMemoryLayout = PyType.MemoryLayout()

    // MARK: - TextFile

    private func fillTextFile(_ py: Py) {
      let type = self.textFile
      type.setBuiltinTypeDoc(PyTextFile.doc)
    }

    internal static let textFileStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let textFileMemoryLayout = PyType.MemoryLayout()

    // MARK: - Tuple

    private func fillTuple(_ py: Py) {
      let type = self.tuple
      type.setBuiltinTypeDoc(PyTuple.doc)
    }

    internal static let tupleStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let tupleMemoryLayout = PyType.MemoryLayout()

    // MARK: - TupleIterator

    private func fillTupleIterator(_ py: Py) {
      let type = self.tuple_iterator
      type.setBuiltinTypeDoc(PyTupleIterator.doc)
    }

    internal static let tupleIteratorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let tupleIteratorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Type

    private func fillType(_ py: Py) {
      let type = self.type
      type.setBuiltinTypeDoc(PyType.doc)
    }

    internal static let typeStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let typeMemoryLayout = PyType.MemoryLayout()

    // MARK: - Zip

    private func fillZip(_ py: Py) {
      let type = self.zip
      type.setBuiltinTypeDoc(PyZip.doc)
    }

    internal static let zipStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let zipMemoryLayout = PyType.MemoryLayout()

  }
}
