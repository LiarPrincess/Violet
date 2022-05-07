// ===============================================================================
// Automatically generated from: ./Sources/Objects/Generated/Py+TypeDefinitions.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ===============================================================================

import BigInt
import VioletCore

// swiftlint:disable function_parameter_count
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable closure_body_length
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
// When all of the types are initialized we can finally fill dictionaries.

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
    public let traceback: PyType
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
        type: self.type,
        name: "builtinFunction",
        qualname: "builtinFunction",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyBuiltinFunction.layout.size,
        staticMethods: Py.Types.builtinFunctionStaticMethods,
        debugFn: PyBuiltinFunction.createDebugInfo(ptr:),
        deinitialize: PyBuiltinFunction.deinitialize(_:ptr:)
      )

      self.builtinMethod = memory.newType(
        type: self.type,
        name: "builtinMethod",
        qualname: "builtinMethod",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyBuiltinMethod.layout.size,
        staticMethods: Py.Types.builtinMethodStaticMethods,
        debugFn: PyBuiltinMethod.createDebugInfo(ptr:),
        deinitialize: PyBuiltinMethod.deinitialize(_:ptr:)
      )

      self.bytearray = memory.newType(
        type: self.type,
        name: "bytearray",
        qualname: "bytearray",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyByteArray.layout.size,
        staticMethods: Py.Types.byteArrayStaticMethods,
        debugFn: PyByteArray.createDebugInfo(ptr:),
        deinitialize: PyByteArray.deinitialize(_:ptr:)
      )

      self.bytearray_iterator = memory.newType(
        type: self.type,
        name: "bytearray_iterator",
        qualname: "bytearray_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyByteArrayIterator.layout.size,
        staticMethods: Py.Types.byteArrayIteratorStaticMethods,
        debugFn: PyByteArrayIterator.createDebugInfo(ptr:),
        deinitialize: PyByteArrayIterator.deinitialize(_:ptr:)
      )

      self.bytes = memory.newType(
        type: self.type,
        name: "bytes",
        qualname: "bytes",
        flags: [.isBaseTypeFlag, .isBytesSubclassFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyBytes.layout.size,
        staticMethods: Py.Types.bytesStaticMethods,
        debugFn: PyBytes.createDebugInfo(ptr:),
        deinitialize: PyBytes.deinitialize(_:ptr:)
      )

      self.bytes_iterator = memory.newType(
        type: self.type,
        name: "bytes_iterator",
        qualname: "bytes_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyBytesIterator.layout.size,
        staticMethods: Py.Types.bytesIteratorStaticMethods,
        debugFn: PyBytesIterator.createDebugInfo(ptr:),
        deinitialize: PyBytesIterator.deinitialize(_:ptr:)
      )

      self.callable_iterator = memory.newType(
        type: self.type,
        name: "callable_iterator",
        qualname: "callable_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyCallableIterator.layout.size,
        staticMethods: Py.Types.callableIteratorStaticMethods,
        debugFn: PyCallableIterator.createDebugInfo(ptr:),
        deinitialize: PyCallableIterator.deinitialize(_:ptr:)
      )

      self.cell = memory.newType(
        type: self.type,
        name: "cell",
        qualname: "cell",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyCell.layout.size,
        staticMethods: Py.Types.cellStaticMethods,
        debugFn: PyCell.createDebugInfo(ptr:),
        deinitialize: PyCell.deinitialize(_:ptr:)
      )

      self.classmethod = memory.newType(
        type: self.type,
        name: "classmethod",
        qualname: "classmethod",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyClassMethod.layout.size,
        staticMethods: Py.Types.classMethodStaticMethods,
        debugFn: PyClassMethod.createDebugInfo(ptr:),
        deinitialize: PyClassMethod.deinitialize(_:ptr:)
      )

      self.code = memory.newType(
        type: self.type,
        name: "code",
        qualname: "code",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyCode.layout.size,
        staticMethods: Py.Types.codeStaticMethods,
        debugFn: PyCode.createDebugInfo(ptr:),
        deinitialize: PyCode.deinitialize(_:ptr:)
      )

      self.complex = memory.newType(
        type: self.type,
        name: "complex",
        qualname: "complex",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyComplex.layout.size,
        staticMethods: Py.Types.complexStaticMethods,
        debugFn: PyComplex.createDebugInfo(ptr:),
        deinitialize: PyComplex.deinitialize(_:ptr:)
      )

      self.dict = memory.newType(
        type: self.type,
        name: "dict",
        qualname: "dict",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .isDictSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyDict.layout.size,
        staticMethods: Py.Types.dictStaticMethods,
        debugFn: PyDict.createDebugInfo(ptr:),
        deinitialize: PyDict.deinitialize(_:ptr:)
      )

      self.dict_itemiterator = memory.newType(
        type: self.type,
        name: "dict_itemiterator",
        qualname: "dict_itemiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyDictItemIterator.layout.size,
        staticMethods: Py.Types.dictItemIteratorStaticMethods,
        debugFn: PyDictItemIterator.createDebugInfo(ptr:),
        deinitialize: PyDictItemIterator.deinitialize(_:ptr:)
      )

      self.dict_items = memory.newType(
        type: self.type,
        name: "dict_items",
        qualname: "dict_items",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyDictItems.layout.size,
        staticMethods: Py.Types.dictItemsStaticMethods,
        debugFn: PyDictItems.createDebugInfo(ptr:),
        deinitialize: PyDictItems.deinitialize(_:ptr:)
      )

      self.dict_keyiterator = memory.newType(
        type: self.type,
        name: "dict_keyiterator",
        qualname: "dict_keyiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyDictKeyIterator.layout.size,
        staticMethods: Py.Types.dictKeyIteratorStaticMethods,
        debugFn: PyDictKeyIterator.createDebugInfo(ptr:),
        deinitialize: PyDictKeyIterator.deinitialize(_:ptr:)
      )

      self.dict_keys = memory.newType(
        type: self.type,
        name: "dict_keys",
        qualname: "dict_keys",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyDictKeys.layout.size,
        staticMethods: Py.Types.dictKeysStaticMethods,
        debugFn: PyDictKeys.createDebugInfo(ptr:),
        deinitialize: PyDictKeys.deinitialize(_:ptr:)
      )

      self.dict_valueiterator = memory.newType(
        type: self.type,
        name: "dict_valueiterator",
        qualname: "dict_valueiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyDictValueIterator.layout.size,
        staticMethods: Py.Types.dictValueIteratorStaticMethods,
        debugFn: PyDictValueIterator.createDebugInfo(ptr:),
        deinitialize: PyDictValueIterator.deinitialize(_:ptr:)
      )

      self.dict_values = memory.newType(
        type: self.type,
        name: "dict_values",
        qualname: "dict_values",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyDictValues.layout.size,
        staticMethods: Py.Types.dictValuesStaticMethods,
        debugFn: PyDictValues.createDebugInfo(ptr:),
        deinitialize: PyDictValues.deinitialize(_:ptr:)
      )

      self.ellipsis = memory.newType(
        type: self.type,
        name: "ellipsis",
        qualname: "ellipsis",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyEllipsis.layout.size,
        staticMethods: Py.Types.ellipsisStaticMethods,
        debugFn: PyEllipsis.createDebugInfo(ptr:),
        deinitialize: PyEllipsis.deinitialize(_:ptr:)
      )

      self.enumerate = memory.newType(
        type: self.type,
        name: "enumerate",
        qualname: "enumerate",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyEnumerate.layout.size,
        staticMethods: Py.Types.enumerateStaticMethods,
        debugFn: PyEnumerate.createDebugInfo(ptr:),
        deinitialize: PyEnumerate.deinitialize(_:ptr:)
      )

      self.filter = memory.newType(
        type: self.type,
        name: "filter",
        qualname: "filter",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyFilter.layout.size,
        staticMethods: Py.Types.filterStaticMethods,
        debugFn: PyFilter.createDebugInfo(ptr:),
        deinitialize: PyFilter.deinitialize(_:ptr:)
      )

      self.float = memory.newType(
        type: self.type,
        name: "float",
        qualname: "float",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyFloat.layout.size,
        staticMethods: Py.Types.floatStaticMethods,
        debugFn: PyFloat.createDebugInfo(ptr:),
        deinitialize: PyFloat.deinitialize(_:ptr:)
      )

      self.frame = memory.newType(
        type: self.type,
        name: "frame",
        qualname: "frame",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyFrame.layout.size,
        staticMethods: Py.Types.frameStaticMethods,
        debugFn: PyFrame.createDebugInfo(ptr:),
        deinitialize: PyFrame.deinitialize(_:ptr:)
      )

      self.frozenset = memory.newType(
        type: self.type,
        name: "frozenset",
        qualname: "frozenset",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyFrozenSet.layout.size,
        staticMethods: Py.Types.frozenSetStaticMethods,
        debugFn: PyFrozenSet.createDebugInfo(ptr:),
        deinitialize: PyFrozenSet.deinitialize(_:ptr:)
      )

      self.function = memory.newType(
        type: self.type,
        name: "function",
        qualname: "function",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyFunction.layout.size,
        staticMethods: Py.Types.functionStaticMethods,
        debugFn: PyFunction.createDebugInfo(ptr:),
        deinitialize: PyFunction.deinitialize(_:ptr:)
      )

      self.int = memory.newType(
        type: self.type,
        name: "int",
        qualname: "int",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .isLongSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyInt.layout.size,
        staticMethods: Py.Types.intStaticMethods,
        debugFn: PyInt.createDebugInfo(ptr:),
        deinitialize: PyInt.deinitialize(_:ptr:)
      )

      self.iterator = memory.newType(
        type: self.type,
        name: "iterator",
        qualname: "iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyIterator.layout.size,
        staticMethods: Py.Types.iteratorStaticMethods,
        debugFn: PyIterator.createDebugInfo(ptr:),
        deinitialize: PyIterator.deinitialize(_:ptr:)
      )

      self.list = memory.newType(
        type: self.type,
        name: "list",
        qualname: "list",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .isListSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyList.layout.size,
        staticMethods: Py.Types.listStaticMethods,
        debugFn: PyList.createDebugInfo(ptr:),
        deinitialize: PyList.deinitialize(_:ptr:)
      )

      self.list_iterator = memory.newType(
        type: self.type,
        name: "list_iterator",
        qualname: "list_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyListIterator.layout.size,
        staticMethods: Py.Types.listIteratorStaticMethods,
        debugFn: PyListIterator.createDebugInfo(ptr:),
        deinitialize: PyListIterator.deinitialize(_:ptr:)
      )

      self.list_reverseiterator = memory.newType(
        type: self.type,
        name: "list_reverseiterator",
        qualname: "list_reverseiterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyListReverseIterator.layout.size,
        staticMethods: Py.Types.listReverseIteratorStaticMethods,
        debugFn: PyListReverseIterator.createDebugInfo(ptr:),
        deinitialize: PyListReverseIterator.deinitialize(_:ptr:)
      )

      self.map = memory.newType(
        type: self.type,
        name: "map",
        qualname: "map",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyMap.layout.size,
        staticMethods: Py.Types.mapStaticMethods,
        debugFn: PyMap.createDebugInfo(ptr:),
        deinitialize: PyMap.deinitialize(_:ptr:)
      )

      self.method = memory.newType(
        type: self.type,
        name: "method",
        qualname: "method",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyMethod.layout.size,
        staticMethods: Py.Types.methodStaticMethods,
        debugFn: PyMethod.createDebugInfo(ptr:),
        deinitialize: PyMethod.deinitialize(_:ptr:)
      )

      self.module = memory.newType(
        type: self.type,
        name: "module",
        qualname: "module",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyModule.layout.size,
        staticMethods: Py.Types.moduleStaticMethods,
        debugFn: PyModule.createDebugInfo(ptr:),
        deinitialize: PyModule.deinitialize(_:ptr:)
      )

      self.simpleNamespace = memory.newType(
        type: self.type,
        name: "SimpleNamespace",
        qualname: "SimpleNamespace",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyNamespace.layout.size,
        staticMethods: Py.Types.namespaceStaticMethods,
        debugFn: PyNamespace.createDebugInfo(ptr:),
        deinitialize: PyNamespace.deinitialize(_:ptr:)
      )

      self.none = memory.newType(
        type: self.type,
        name: "NoneType",
        qualname: "NoneType",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyNone.layout.size,
        staticMethods: Py.Types.noneStaticMethods,
        debugFn: PyNone.createDebugInfo(ptr:),
        deinitialize: PyNone.deinitialize(_:ptr:)
      )

      self.notImplemented = memory.newType(
        type: self.type,
        name: "NotImplementedType",
        qualname: "NotImplementedType",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyNotImplemented.layout.size,
        staticMethods: Py.Types.notImplementedStaticMethods,
        debugFn: PyNotImplemented.createDebugInfo(ptr:),
        deinitialize: PyNotImplemented.deinitialize(_:ptr:)
      )

      self.property = memory.newType(
        type: self.type,
        name: "property",
        qualname: "property",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyProperty.layout.size,
        staticMethods: Py.Types.propertyStaticMethods,
        debugFn: PyProperty.createDebugInfo(ptr:),
        deinitialize: PyProperty.deinitialize(_:ptr:)
      )

      self.range = memory.newType(
        type: self.type,
        name: "range",
        qualname: "range",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyRange.layout.size,
        staticMethods: Py.Types.rangeStaticMethods,
        debugFn: PyRange.createDebugInfo(ptr:),
        deinitialize: PyRange.deinitialize(_:ptr:)
      )

      self.range_iterator = memory.newType(
        type: self.type,
        name: "range_iterator",
        qualname: "range_iterator",
        flags: [.isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyRangeIterator.layout.size,
        staticMethods: Py.Types.rangeIteratorStaticMethods,
        debugFn: PyRangeIterator.createDebugInfo(ptr:),
        deinitialize: PyRangeIterator.deinitialize(_:ptr:)
      )

      self.reversed = memory.newType(
        type: self.type,
        name: "reversed",
        qualname: "reversed",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyReversed.layout.size,
        staticMethods: Py.Types.reversedStaticMethods,
        debugFn: PyReversed.createDebugInfo(ptr:),
        deinitialize: PyReversed.deinitialize(_:ptr:)
      )

      self.set = memory.newType(
        type: self.type,
        name: "set",
        qualname: "set",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PySet.layout.size,
        staticMethods: Py.Types.setStaticMethods,
        debugFn: PySet.createDebugInfo(ptr:),
        deinitialize: PySet.deinitialize(_:ptr:)
      )

      self.set_iterator = memory.newType(
        type: self.type,
        name: "set_iterator",
        qualname: "set_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PySetIterator.layout.size,
        staticMethods: Py.Types.setIteratorStaticMethods,
        debugFn: PySetIterator.createDebugInfo(ptr:),
        deinitialize: PySetIterator.deinitialize(_:ptr:)
      )

      self.slice = memory.newType(
        type: self.type,
        name: "slice",
        qualname: "slice",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PySlice.layout.size,
        staticMethods: Py.Types.sliceStaticMethods,
        debugFn: PySlice.createDebugInfo(ptr:),
        deinitialize: PySlice.deinitialize(_:ptr:)
      )

      self.staticmethod = memory.newType(
        type: self.type,
        name: "staticmethod",
        qualname: "staticmethod",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyStaticMethod.layout.size,
        staticMethods: Py.Types.staticMethodStaticMethods,
        debugFn: PyStaticMethod.createDebugInfo(ptr:),
        deinitialize: PyStaticMethod.deinitialize(_:ptr:)
      )

      self.str = memory.newType(
        type: self.type,
        name: "str",
        qualname: "str",
        flags: [.isBaseTypeFlag, .isDefaultFlag, .isUnicodeSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyString.layout.size,
        staticMethods: Py.Types.stringStaticMethods,
        debugFn: PyString.createDebugInfo(ptr:),
        deinitialize: PyString.deinitialize(_:ptr:)
      )

      self.str_iterator = memory.newType(
        type: self.type,
        name: "str_iterator",
        qualname: "str_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyStringIterator.layout.size,
        staticMethods: Py.Types.stringIteratorStaticMethods,
        debugFn: PyStringIterator.createDebugInfo(ptr:),
        deinitialize: PyStringIterator.deinitialize(_:ptr:)
      )

      self.`super` = memory.newType(
        type: self.type,
        name: "super",
        qualname: "super",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PySuper.layout.size,
        staticMethods: Py.Types.superStaticMethods,
        debugFn: PySuper.createDebugInfo(ptr:),
        deinitialize: PySuper.deinitialize(_:ptr:)
      )

      self.textFile = memory.newType(
        type: self.type,
        name: "TextFile",
        qualname: "TextFile",
        flags: [.hasFinalizeFlag, .hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyTextFile.layout.size,
        staticMethods: Py.Types.textFileStaticMethods,
        debugFn: PyTextFile.createDebugInfo(ptr:),
        deinitialize: PyTextFile.deinitialize(_:ptr:)
      )

      self.traceback = memory.newType(
        type: self.type,
        name: "traceback",
        qualname: "traceback",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyTraceback.layout.size,
        staticMethods: Py.Types.tracebackStaticMethods,
        debugFn: PyTraceback.createDebugInfo(ptr:),
        deinitialize: PyTraceback.deinitialize(_:ptr:)
      )

      self.tuple = memory.newType(
        type: self.type,
        name: "tuple",
        qualname: "tuple",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .isTupleSubclassFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyTuple.layout.size,
        staticMethods: Py.Types.tupleStaticMethods,
        debugFn: PyTuple.createDebugInfo(ptr:),
        deinitialize: PyTuple.deinitialize(_:ptr:)
      )

      self.tuple_iterator = memory.newType(
        type: self.type,
        name: "tuple_iterator",
        qualname: "tuple_iterator",
        flags: [.hasGCFlag, .isDefaultFlag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyTupleIterator.layout.size,
        staticMethods: Py.Types.tupleIteratorStaticMethods,
        debugFn: PyTupleIterator.createDebugInfo(ptr:),
        deinitialize: PyTupleIterator.deinitialize(_:ptr:)
      )

      self.zip = memory.newType(
        type: self.type,
        name: "zip",
        qualname: "zip",
        flags: [.hasGCFlag, .isBaseTypeFlag, .isDefaultFlag, .subclassInstancesHave__dict__Flag],
        base: self.object,
        bases: [self.object],
        mroWithoutSelf: [self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyZip.layout.size,
        staticMethods: Py.Types.zipStaticMethods,
        debugFn: PyZip.createDebugInfo(ptr:),
        deinitialize: PyZip.deinitialize(_:ptr:)
      )

      // And now we can set 'bool' (because we have 'self.int').
      self.bool = memory.newType(
        type: self.type,
        name: "bool",
        qualname: "bool",
        flags: [.isDefaultFlag, .isLongSubclassFlag],
        base: self.int,
        bases: [self.int],
        mroWithoutSelf: [self.int, self.object],
        subclasses: [],
        instanceSizeWithoutTail: PyBool.layout.size,
        staticMethods: Py.Types.boolStaticMethods,
        debugFn: PyBool.createDebugInfo(ptr:),
        deinitialize: PyBool.deinitialize(_:ptr:)
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
      self.fillTraceback(py)
      self.fillTuple(py)
      self.fillTupleIterator(py)
      self.fillType(py)
      self.fillZip(py)
    }

    // MARK: - Helpers

    /// Adds `property` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, property get: FunctionWrapper, doc: String?) {
      let property = py.newProperty(get: get, set: nil, del: nil, doc: doc)
      let value = property.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `property` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, property get: FunctionWrapper, setter set: FunctionWrapper, doc: String?) {
      let property = py.newProperty(get: get, set: set, del: nil, doc: doc)
      let value = property.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `method` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, method: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: method, module: nil, doc: doc)
      let value = builtinFunction.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `classmethod` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, classMethod: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: classMethod, module: nil, doc: doc)
      let staticMethod = py.newClassMethod(callable: builtinFunction)
      let value = staticMethod.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `staticmethod` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, staticMethod: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: staticMethod, module: nil, doc: doc)
      let staticMethod = py.newStaticMethod(callable: builtinFunction)
      let value = staticMethod.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds value to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, value: PyObject) {
      let dict = type.getDict(py)
      let interned = py.intern(string: name)

      switch dict.set(py, key: interned, value: value) {
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
      type.setBuiltinTypeDoc(py, value: PyBool.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBool.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBool.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyBool.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyBool.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __and__ = FunctionWrapper(name: "__and__", fn: PyBool.__and__(_:zelf:other:))
      self.add(py, type: type, name: "__and__", method: __and__, doc: nil)
      let __rand__ = FunctionWrapper(name: "__rand__", fn: PyBool.__rand__(_:zelf:other:))
      self.add(py, type: type, name: "__rand__", method: __rand__, doc: nil)
      let __or__ = FunctionWrapper(name: "__or__", fn: PyBool.__or__(_:zelf:other:))
      self.add(py, type: type, name: "__or__", method: __or__, doc: nil)
      let __ror__ = FunctionWrapper(name: "__ror__", fn: PyBool.__ror__(_:zelf:other:))
      self.add(py, type: type, name: "__ror__", method: __ror__, doc: nil)
      let __xor__ = FunctionWrapper(name: "__xor__", fn: PyBool.__xor__(_:zelf:other:))
      self.add(py, type: type, name: "__xor__", method: __xor__, doc: nil)
      let __rxor__ = FunctionWrapper(name: "__rxor__", fn: PyBool.__rxor__(_:zelf:other:))
      self.add(py, type: type, name: "__rxor__", method: __rxor__, doc: nil)
    }

    internal static var boolStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.intStaticMethods.copy()
      result.__repr__ = .init(PyBool.__repr__(_:zelf:))
      result.__str__ = .init(PyBool.__str__(_:zelf:))
      result.__and__ = .init(PyBool.__and__(_:zelf:other:))
      result.__or__ = .init(PyBool.__or__(_:zelf:other:))
      result.__xor__ = .init(PyBool.__xor__(_:zelf:other:))
      result.__rand__ = .init(PyBool.__rand__(_:zelf:other:))
      result.__ror__ = .init(PyBool.__ror__(_:zelf:other:))
      result.__rxor__ = .init(PyBool.__rxor__(_:zelf:other:))
      return result
    }()

    // MARK: - BuiltinFunction

    private func fillBuiltinFunction(_ py: Py) {
      let type = self.builtinFunction
      type.setBuiltinTypeDoc(py, value: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __name__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__name__(_:zelf:))
      self.add(py, type: type, name: "__name__", property: __name__, doc: nil)
      let __qualname__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__qualname__(_:zelf:))
      self.add(py, type: type, name: "__qualname__", property: __qualname__, doc: nil)
      let __doc__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__doc__(_:zelf:))
      self.add(py, type: type, name: "__doc__", property: __doc__, doc: nil)
      let __text_signature__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__text_signature__(_:zelf:))
      self.add(py, type: type, name: "__text_signature__", property: __text_signature__, doc: nil)
      let __module__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__module__(_:zelf:))
      self.add(py, type: type, name: "__module__", property: __module__, doc: nil)
      let __self__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__self__(_:zelf:))
      self.add(py, type: type, name: "__self__", property: __self__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyBuiltinFunction.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyBuiltinFunction.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyBuiltinFunction.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyBuiltinFunction.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyBuiltinFunction.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyBuiltinFunction.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyBuiltinFunction.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyBuiltinFunction.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __get__ = FunctionWrapper(name: "__get__", fn: PyBuiltinFunction.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
      let __call__ = FunctionWrapper(name: "__call__", fn: PyBuiltinFunction.__call__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__call__", method: __call__, doc: nil)
    }

    internal static var builtinFunctionStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyBuiltinFunction.__repr__(_:zelf:))
      result.__eq__ = .init(PyBuiltinFunction.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyBuiltinFunction.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyBuiltinFunction.__lt__(_:zelf:other:))
      result.__le__ = .init(PyBuiltinFunction.__le__(_:zelf:other:))
      result.__gt__ = .init(PyBuiltinFunction.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyBuiltinFunction.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyBuiltinFunction.__getattribute__(_:zelf:name:))
      result.__call__ = .init(PyBuiltinFunction.__call__(_:zelf:args:kwargs:))
      return result
    }()

    // MARK: - BuiltinMethod

    private func fillBuiltinMethod(_ py: Py) {
      let type = self.builtinMethod
      type.setBuiltinTypeDoc(py, value: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __name__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__name__(_:zelf:))
      self.add(py, type: type, name: "__name__", property: __name__, doc: nil)
      let __qualname__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__qualname__(_:zelf:))
      self.add(py, type: type, name: "__qualname__", property: __qualname__, doc: nil)
      let __doc__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__doc__(_:zelf:))
      self.add(py, type: type, name: "__doc__", property: __doc__, doc: nil)
      let __text_signature__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__text_signature__(_:zelf:))
      self.add(py, type: type, name: "__text_signature__", property: __text_signature__, doc: nil)
      let __module__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__module__(_:zelf:))
      self.add(py, type: type, name: "__module__", property: __module__, doc: nil)
      let __self__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__self__(_:zelf:))
      self.add(py, type: type, name: "__self__", property: __self__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyBuiltinMethod.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyBuiltinMethod.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyBuiltinMethod.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyBuiltinMethod.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyBuiltinMethod.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyBuiltinMethod.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyBuiltinMethod.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyBuiltinMethod.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __get__ = FunctionWrapper(name: "__get__", fn: PyBuiltinMethod.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
      let __call__ = FunctionWrapper(name: "__call__", fn: PyBuiltinMethod.__call__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__call__", method: __call__, doc: nil)
    }

    internal static var builtinMethodStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyBuiltinMethod.__repr__(_:zelf:))
      result.__eq__ = .init(PyBuiltinMethod.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyBuiltinMethod.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyBuiltinMethod.__lt__(_:zelf:other:))
      result.__le__ = .init(PyBuiltinMethod.__le__(_:zelf:other:))
      result.__gt__ = .init(PyBuiltinMethod.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyBuiltinMethod.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyBuiltinMethod.__getattribute__(_:zelf:name:))
      result.__call__ = .init(PyBuiltinMethod.__call__(_:zelf:args:kwargs:))
      return result
    }()

    // MARK: - ByteArray

    private func fillByteArray(_ py: Py) {
      let type = self.bytearray
      type.setBuiltinTypeDoc(py, value: PyByteArray.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyByteArray.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyByteArray.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyByteArray.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyByteArray.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyByteArray.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyByteArray.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyByteArray.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyByteArray.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyByteArray.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyByteArray.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyByteArray.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyByteArray.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyByteArray.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyByteArray.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyByteArray.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __getitem__ = FunctionWrapper(name: "__getitem__", fn: PyByteArray.__getitem__(_:zelf:index:))
      self.add(py, type: type, name: "__getitem__", method: __getitem__, doc: nil)
      let __setitem__ = FunctionWrapper(name: "__setitem__", fn: PyByteArray.__setitem__(_:zelf:index:value:))
      self.add(py, type: type, name: "__setitem__", method: __setitem__, doc: nil)
      let __delitem__ = FunctionWrapper(name: "__delitem__", fn: PyByteArray.__delitem__(_:zelf:index:))
      self.add(py, type: type, name: "__delitem__", method: __delitem__, doc: nil)
      let isalnum = FunctionWrapper(name: "isalnum", fn: PyByteArray.isalnum(_:zelf:))
      self.add(py, type: type, name: "isalnum", method: isalnum, doc: PyByteArray.isalnumDoc)
      let isalpha = FunctionWrapper(name: "isalpha", fn: PyByteArray.isalpha(_:zelf:))
      self.add(py, type: type, name: "isalpha", method: isalpha, doc: PyByteArray.isalphaDoc)
      let isascii = FunctionWrapper(name: "isascii", fn: PyByteArray.isascii(_:zelf:))
      self.add(py, type: type, name: "isascii", method: isascii, doc: PyByteArray.isasciiDoc)
      let isdigit = FunctionWrapper(name: "isdigit", fn: PyByteArray.isdigit(_:zelf:))
      self.add(py, type: type, name: "isdigit", method: isdigit, doc: PyByteArray.isdigitDoc)
      let islower = FunctionWrapper(name: "islower", fn: PyByteArray.islower(_:zelf:))
      self.add(py, type: type, name: "islower", method: islower, doc: PyByteArray.islowerDoc)
      let isspace = FunctionWrapper(name: "isspace", fn: PyByteArray.isspace(_:zelf:))
      self.add(py, type: type, name: "isspace", method: isspace, doc: PyByteArray.isspaceDoc)
      let istitle = FunctionWrapper(name: "istitle", fn: PyByteArray.istitle(_:zelf:))
      self.add(py, type: type, name: "istitle", method: istitle, doc: PyByteArray.istitleDoc)
      let isupper = FunctionWrapper(name: "isupper", fn: PyByteArray.isupper(_:zelf:))
      self.add(py, type: type, name: "isupper", method: isupper, doc: PyByteArray.isupperDoc)
      let startswith = FunctionWrapper(name: "startswith", fn: PyByteArray.startswith(_:zelf:prefix:start:end:))
      self.add(py, type: type, name: "startswith", method: startswith, doc: PyByteArray.startswithDoc)
      let endswith = FunctionWrapper(name: "endswith", fn: PyByteArray.endswith(_:zelf:suffix:start:end:))
      self.add(py, type: type, name: "endswith", method: endswith, doc: PyByteArray.endswithDoc)
      let strip = FunctionWrapper(name: "strip", fn: PyByteArray.strip(_:zelf:chars:))
      self.add(py, type: type, name: "strip", method: strip, doc: PyByteArray.stripDoc)
      let lstrip = FunctionWrapper(name: "lstrip", fn: PyByteArray.lstrip(_:zelf:chars:))
      self.add(py, type: type, name: "lstrip", method: lstrip, doc: PyByteArray.lstripDoc)
      let rstrip = FunctionWrapper(name: "rstrip", fn: PyByteArray.rstrip(_:zelf:chars:))
      self.add(py, type: type, name: "rstrip", method: rstrip, doc: PyByteArray.rstripDoc)
      let find = FunctionWrapper(name: "find", fn: PyByteArray.find(_:zelf:object:start:end:))
      self.add(py, type: type, name: "find", method: find, doc: PyByteArray.findDoc)
      let rfind = FunctionWrapper(name: "rfind", fn: PyByteArray.rfind(_:zelf:object:start:end:))
      self.add(py, type: type, name: "rfind", method: rfind, doc: PyByteArray.rfindDoc)
      let index = FunctionWrapper(name: "index", fn: PyByteArray.index(_:zelf:object:start:end:))
      self.add(py, type: type, name: "index", method: index, doc: PyByteArray.indexDoc)
      let rindex = FunctionWrapper(name: "rindex", fn: PyByteArray.rindex(_:zelf:object:start:end:))
      self.add(py, type: type, name: "rindex", method: rindex, doc: PyByteArray.rindexDoc)
      let lower = FunctionWrapper(name: "lower", fn: PyByteArray.lower(_:zelf:))
      self.add(py, type: type, name: "lower", method: lower, doc: nil)
      let upper = FunctionWrapper(name: "upper", fn: PyByteArray.upper(_:zelf:))
      self.add(py, type: type, name: "upper", method: upper, doc: nil)
      let title = FunctionWrapper(name: "title", fn: PyByteArray.title(_:zelf:))
      self.add(py, type: type, name: "title", method: title, doc: nil)
      let swapcase = FunctionWrapper(name: "swapcase", fn: PyByteArray.swapcase(_:zelf:))
      self.add(py, type: type, name: "swapcase", method: swapcase, doc: nil)
      let capitalize = FunctionWrapper(name: "capitalize", fn: PyByteArray.capitalize(_:zelf:))
      self.add(py, type: type, name: "capitalize", method: capitalize, doc: nil)
      let center = FunctionWrapper(name: "center", fn: PyByteArray.center(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "center", method: center, doc: nil)
      let ljust = FunctionWrapper(name: "ljust", fn: PyByteArray.ljust(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "ljust", method: ljust, doc: nil)
      let rjust = FunctionWrapper(name: "rjust", fn: PyByteArray.rjust(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "rjust", method: rjust, doc: nil)
      let split = FunctionWrapper(name: "split", fn: PyByteArray.split(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "split", method: split, doc: nil)
      let rsplit = FunctionWrapper(name: "rsplit", fn: PyByteArray.rsplit(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "rsplit", method: rsplit, doc: nil)
      let splitlines = FunctionWrapper(name: "splitlines", fn: PyByteArray.splitlines(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "splitlines", method: splitlines, doc: nil)
      let partition = FunctionWrapper(name: "partition", fn: PyByteArray.partition(_:zelf:separator:))
      self.add(py, type: type, name: "partition", method: partition, doc: nil)
      let rpartition = FunctionWrapper(name: "rpartition", fn: PyByteArray.rpartition(_:zelf:separator:))
      self.add(py, type: type, name: "rpartition", method: rpartition, doc: nil)
      let expandtabs = FunctionWrapper(name: "expandtabs", fn: PyByteArray.expandtabs(_:zelf:tabSize:))
      self.add(py, type: type, name: "expandtabs", method: expandtabs, doc: nil)
      let count = FunctionWrapper(name: "count", fn: PyByteArray.count(_:zelf:object:start:end:))
      self.add(py, type: type, name: "count", method: count, doc: PyByteArray.countDoc)
      let join = FunctionWrapper(name: "join", fn: PyByteArray.join(_:zelf:iterable:))
      self.add(py, type: type, name: "join", method: join, doc: nil)
      let replace = FunctionWrapper(name: "replace", fn: PyByteArray.replace(_:zelf:old:new:count:))
      self.add(py, type: type, name: "replace", method: replace, doc: nil)
      let zfill = FunctionWrapper(name: "zfill", fn: PyByteArray.zfill(_:zelf:width:))
      self.add(py, type: type, name: "zfill", method: zfill, doc: nil)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyByteArray.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __iadd__ = FunctionWrapper(name: "__iadd__", fn: PyByteArray.__iadd__(_:zelf:other:))
      self.add(py, type: type, name: "__iadd__", method: __iadd__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyByteArray.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyByteArray.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
      let __imul__ = FunctionWrapper(name: "__imul__", fn: PyByteArray.__imul__(_:zelf:other:))
      self.add(py, type: type, name: "__imul__", method: __imul__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyByteArray.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let append = FunctionWrapper(name: "append", fn: PyByteArray.append(_:zelf:object:))
      self.add(py, type: type, name: "append", method: append, doc: PyByteArray.appendDoc)
      let extend = FunctionWrapper(name: "extend", fn: PyByteArray.extend(_:zelf:iterable:))
      self.add(py, type: type, name: "extend", method: extend, doc: nil)
      let insert = FunctionWrapper(name: "insert", fn: PyByteArray.insert(_:zelf:index:object:))
      self.add(py, type: type, name: "insert", method: insert, doc: PyByteArray.insertDoc)
      let remove = FunctionWrapper(name: "remove", fn: PyByteArray.remove(_:zelf:object:))
      self.add(py, type: type, name: "remove", method: remove, doc: PyByteArray.removeDoc)
      let pop = FunctionWrapper(name: "pop", fn: PyByteArray.pop(_:zelf:index:))
      self.add(py, type: type, name: "pop", method: pop, doc: PyByteArray.popDoc)
      let clear = FunctionWrapper(name: "clear", fn: PyByteArray.clear(_:zelf:))
      self.add(py, type: type, name: "clear", method: clear, doc: PyByteArray.clearDoc)
      let reverse = FunctionWrapper(name: "reverse", fn: PyByteArray.reverse(_:zelf:))
      self.add(py, type: type, name: "reverse", method: reverse, doc: PyByteArray.reverseDoc)
      let copy = FunctionWrapper(name: "copy", fn: PyByteArray.copy(_:zelf:))
      self.add(py, type: type, name: "copy", method: copy, doc: PyByteArray.copyDoc)
    }

    internal static var byteArrayStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyByteArray.__repr__(_:zelf:))
      result.__str__ = .init(PyByteArray.__str__(_:zelf:))
      result.__hash__ = .init(PyByteArray.__hash__(_:zelf:))
      result.__eq__ = .init(PyByteArray.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyByteArray.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyByteArray.__lt__(_:zelf:other:))
      result.__le__ = .init(PyByteArray.__le__(_:zelf:other:))
      result.__gt__ = .init(PyByteArray.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyByteArray.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyByteArray.__getattribute__(_:zelf:name:))
      result.__getitem__ = .init(PyByteArray.__getitem__(_:zelf:index:))
      result.__setitem__ = .init(PyByteArray.__setitem__(_:zelf:index:value:))
      result.__delitem__ = .init(PyByteArray.__delitem__(_:zelf:index:))
      result.__iter__ = .init(PyByteArray.__iter__(_:zelf:))
      result.__len__ = .init(PyByteArray.__len__(_:zelf:))
      result.__contains__ = .init(PyByteArray.__contains__(_:zelf:object:))
      result.__add__ = .init(PyByteArray.__add__(_:zelf:other:))
      result.__mul__ = .init(PyByteArray.__mul__(_:zelf:other:))
      result.__rmul__ = .init(PyByteArray.__rmul__(_:zelf:other:))
      result.__iadd__ = .init(PyByteArray.__iadd__(_:zelf:other:))
      result.__imul__ = .init(PyByteArray.__imul__(_:zelf:other:))
      return result
    }()

    // MARK: - ByteArrayIterator

    private func fillByteArrayIterator(_ py: Py) {
      let type = self.bytearray_iterator
      type.setBuiltinTypeDoc(py, value: PyByteArrayIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyByteArrayIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyByteArrayIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyByteArrayIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyByteArrayIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyByteArrayIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyByteArrayIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var byteArrayIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyByteArrayIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyByteArrayIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyByteArrayIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - Bytes

    private func fillBytes(_ py: Py) {
      let type = self.bytes
      type.setBuiltinTypeDoc(py, value: PyBytes.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBytes.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBytes.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyBytes.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyBytes.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyBytes.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyBytes.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyBytes.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyBytes.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyBytes.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyBytes.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyBytes.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyBytes.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyBytes.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyBytes.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __getitem__ = FunctionWrapper(name: "__getitem__", fn: PyBytes.__getitem__(_:zelf:index:))
      self.add(py, type: type, name: "__getitem__", method: __getitem__, doc: nil)
      let isalnum = FunctionWrapper(name: "isalnum", fn: PyBytes.isalnum(_:zelf:))
      self.add(py, type: type, name: "isalnum", method: isalnum, doc: PyBytes.isalnumDoc)
      let isalpha = FunctionWrapper(name: "isalpha", fn: PyBytes.isalpha(_:zelf:))
      self.add(py, type: type, name: "isalpha", method: isalpha, doc: PyBytes.isalphaDoc)
      let isascii = FunctionWrapper(name: "isascii", fn: PyBytes.isascii(_:zelf:))
      self.add(py, type: type, name: "isascii", method: isascii, doc: PyBytes.isasciiDoc)
      let isdigit = FunctionWrapper(name: "isdigit", fn: PyBytes.isdigit(_:zelf:))
      self.add(py, type: type, name: "isdigit", method: isdigit, doc: PyBytes.isdigitDoc)
      let islower = FunctionWrapper(name: "islower", fn: PyBytes.islower(_:zelf:))
      self.add(py, type: type, name: "islower", method: islower, doc: PyBytes.islowerDoc)
      let isspace = FunctionWrapper(name: "isspace", fn: PyBytes.isspace(_:zelf:))
      self.add(py, type: type, name: "isspace", method: isspace, doc: PyBytes.isspaceDoc)
      let istitle = FunctionWrapper(name: "istitle", fn: PyBytes.istitle(_:zelf:))
      self.add(py, type: type, name: "istitle", method: istitle, doc: PyBytes.istitleDoc)
      let isupper = FunctionWrapper(name: "isupper", fn: PyBytes.isupper(_:zelf:))
      self.add(py, type: type, name: "isupper", method: isupper, doc: PyBytes.isupperDoc)
      let startswith = FunctionWrapper(name: "startswith", fn: PyBytes.startswith(_:zelf:prefix:start:end:))
      self.add(py, type: type, name: "startswith", method: startswith, doc: PyBytes.startswithDoc)
      let endswith = FunctionWrapper(name: "endswith", fn: PyBytes.endswith(_:zelf:suffix:start:end:))
      self.add(py, type: type, name: "endswith", method: endswith, doc: PyBytes.endswithDoc)
      let strip = FunctionWrapper(name: "strip", fn: PyBytes.strip(_:zelf:chars:))
      self.add(py, type: type, name: "strip", method: strip, doc: PyBytes.stripDoc)
      let lstrip = FunctionWrapper(name: "lstrip", fn: PyBytes.lstrip(_:zelf:chars:))
      self.add(py, type: type, name: "lstrip", method: lstrip, doc: PyBytes.lstripDoc)
      let rstrip = FunctionWrapper(name: "rstrip", fn: PyBytes.rstrip(_:zelf:chars:))
      self.add(py, type: type, name: "rstrip", method: rstrip, doc: PyBytes.rstripDoc)
      let find = FunctionWrapper(name: "find", fn: PyBytes.find(_:zelf:object:start:end:))
      self.add(py, type: type, name: "find", method: find, doc: PyBytes.findDoc)
      let rfind = FunctionWrapper(name: "rfind", fn: PyBytes.rfind(_:zelf:object:start:end:))
      self.add(py, type: type, name: "rfind", method: rfind, doc: PyBytes.rfindDoc)
      let index = FunctionWrapper(name: "index", fn: PyBytes.index(_:zelf:object:start:end:))
      self.add(py, type: type, name: "index", method: index, doc: PyBytes.indexDoc)
      let rindex = FunctionWrapper(name: "rindex", fn: PyBytes.rindex(_:zelf:object:start:end:))
      self.add(py, type: type, name: "rindex", method: rindex, doc: PyBytes.rindexDoc)
      let lower = FunctionWrapper(name: "lower", fn: PyBytes.lower(_:zelf:))
      self.add(py, type: type, name: "lower", method: lower, doc: nil)
      let upper = FunctionWrapper(name: "upper", fn: PyBytes.upper(_:zelf:))
      self.add(py, type: type, name: "upper", method: upper, doc: nil)
      let title = FunctionWrapper(name: "title", fn: PyBytes.title(_:zelf:))
      self.add(py, type: type, name: "title", method: title, doc: nil)
      let swapcase = FunctionWrapper(name: "swapcase", fn: PyBytes.swapcase(_:zelf:))
      self.add(py, type: type, name: "swapcase", method: swapcase, doc: nil)
      let capitalize = FunctionWrapper(name: "capitalize", fn: PyBytes.capitalize(_:zelf:))
      self.add(py, type: type, name: "capitalize", method: capitalize, doc: nil)
      let center = FunctionWrapper(name: "center", fn: PyBytes.center(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "center", method: center, doc: nil)
      let ljust = FunctionWrapper(name: "ljust", fn: PyBytes.ljust(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "ljust", method: ljust, doc: nil)
      let rjust = FunctionWrapper(name: "rjust", fn: PyBytes.rjust(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "rjust", method: rjust, doc: nil)
      let split = FunctionWrapper(name: "split", fn: PyBytes.split(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "split", method: split, doc: nil)
      let rsplit = FunctionWrapper(name: "rsplit", fn: PyBytes.rsplit(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "rsplit", method: rsplit, doc: nil)
      let splitlines = FunctionWrapper(name: "splitlines", fn: PyBytes.splitlines(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "splitlines", method: splitlines, doc: nil)
      let partition = FunctionWrapper(name: "partition", fn: PyBytes.partition(_:zelf:separator:))
      self.add(py, type: type, name: "partition", method: partition, doc: nil)
      let rpartition = FunctionWrapper(name: "rpartition", fn: PyBytes.rpartition(_:zelf:separator:))
      self.add(py, type: type, name: "rpartition", method: rpartition, doc: nil)
      let expandtabs = FunctionWrapper(name: "expandtabs", fn: PyBytes.expandtabs(_:zelf:tabSize:))
      self.add(py, type: type, name: "expandtabs", method: expandtabs, doc: nil)
      let count = FunctionWrapper(name: "count", fn: PyBytes.count(_:zelf:object:start:end:))
      self.add(py, type: type, name: "count", method: count, doc: PyBytes.countDoc)
      let join = FunctionWrapper(name: "join", fn: PyBytes.join(_:zelf:iterable:))
      self.add(py, type: type, name: "join", method: join, doc: nil)
      let replace = FunctionWrapper(name: "replace", fn: PyBytes.replace(_:zelf:old:new:count:))
      self.add(py, type: type, name: "replace", method: replace, doc: nil)
      let zfill = FunctionWrapper(name: "zfill", fn: PyBytes.zfill(_:zelf:width:))
      self.add(py, type: type, name: "zfill", method: zfill, doc: nil)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyBytes.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyBytes.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyBytes.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyBytes.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
    }

    internal static var bytesStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyBytes.__repr__(_:zelf:))
      result.__str__ = .init(PyBytes.__str__(_:zelf:))
      result.__hash__ = .init(PyBytes.__hash__(_:zelf:))
      result.__eq__ = .init(PyBytes.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyBytes.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyBytes.__lt__(_:zelf:other:))
      result.__le__ = .init(PyBytes.__le__(_:zelf:other:))
      result.__gt__ = .init(PyBytes.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyBytes.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyBytes.__getattribute__(_:zelf:name:))
      result.__getitem__ = .init(PyBytes.__getitem__(_:zelf:index:))
      result.__iter__ = .init(PyBytes.__iter__(_:zelf:))
      result.__len__ = .init(PyBytes.__len__(_:zelf:))
      result.__contains__ = .init(PyBytes.__contains__(_:zelf:object:))
      result.__add__ = .init(PyBytes.__add__(_:zelf:other:))
      result.__mul__ = .init(PyBytes.__mul__(_:zelf:other:))
      result.__rmul__ = .init(PyBytes.__rmul__(_:zelf:other:))
      return result
    }()

    // MARK: - BytesIterator

    private func fillBytesIterator(_ py: Py) {
      let type = self.bytes_iterator
      type.setBuiltinTypeDoc(py, value: PyBytesIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBytesIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBytesIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyBytesIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyBytesIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyBytesIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyBytesIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var bytesIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyBytesIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyBytesIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyBytesIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - CallableIterator

    private func fillCallableIterator(_ py: Py) {
      let type = self.callable_iterator
      type.setBuiltinTypeDoc(py, value: PyCallableIterator.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyCallableIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyCallableIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyCallableIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyCallableIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
    }

    internal static var callableIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyCallableIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyCallableIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyCallableIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - Cell

    private func fillCell(_ py: Py) {
      let type = self.cell
      type.setBuiltinTypeDoc(py, value: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyCell.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyCell.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyCell.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyCell.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyCell.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyCell.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyCell.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyCell.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
    }

    internal static var cellStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyCell.__repr__(_:zelf:))
      result.__eq__ = .init(PyCell.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyCell.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyCell.__lt__(_:zelf:other:))
      result.__le__ = .init(PyCell.__le__(_:zelf:other:))
      result.__gt__ = .init(PyCell.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyCell.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyCell.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - ClassMethod

    private func fillClassMethod(_ py: Py) {
      let type = self.classmethod
      type.setBuiltinTypeDoc(py, value: PyClassMethod.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyClassMethod.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyClassMethod.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyClassMethod.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyClassMethod.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let __func__ = FunctionWrapper(name: "__get__", fn: PyClassMethod.__func__(_:zelf:))
      self.add(py, type: type, name: "__func__", property: __func__, doc: nil)

      let __get__ = FunctionWrapper(name: "__get__", fn: PyClassMethod.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
      let __isabstractmethod__ = FunctionWrapper(name: "__isabstractmethod__", fn: PyClassMethod.__isabstractmethod__(_:zelf:))
      self.add(py, type: type, name: "__isabstractmethod__", method: __isabstractmethod__, doc: nil)
    }

    internal static var classMethodStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__isabstractmethod__ = .init(PyClassMethod.__isabstractmethod__(_:zelf:))
      return result
    }()

    // MARK: - Code

    private func fillCode(_ py: Py) {
      let type = self.code
      type.setBuiltinTypeDoc(py, value: PyCode.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyCode.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let co_name = FunctionWrapper(name: "__get__", fn: PyCode.co_name(_:zelf:))
      self.add(py, type: type, name: "co_name", property: co_name, doc: nil)
      let co_filename = FunctionWrapper(name: "__get__", fn: PyCode.co_filename(_:zelf:))
      self.add(py, type: type, name: "co_filename", property: co_filename, doc: nil)
      let co_firstlineno = FunctionWrapper(name: "__get__", fn: PyCode.co_firstlineno(_:zelf:))
      self.add(py, type: type, name: "co_firstlineno", property: co_firstlineno, doc: nil)
      let co_argcount = FunctionWrapper(name: "__get__", fn: PyCode.co_argcount(_:zelf:))
      self.add(py, type: type, name: "co_argcount", property: co_argcount, doc: nil)
      let co_posonlyargcount = FunctionWrapper(name: "__get__", fn: PyCode.co_posonlyargcount(_:zelf:))
      self.add(py, type: type, name: "co_posonlyargcount", property: co_posonlyargcount, doc: nil)
      let co_kwonlyargcount = FunctionWrapper(name: "__get__", fn: PyCode.co_kwonlyargcount(_:zelf:))
      self.add(py, type: type, name: "co_kwonlyargcount", property: co_kwonlyargcount, doc: nil)
      let co_nlocals = FunctionWrapper(name: "__get__", fn: PyCode.co_nlocals(_:zelf:))
      self.add(py, type: type, name: "co_nlocals", property: co_nlocals, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyCode.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyCode.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyCode.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyCode.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyCode.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyCode.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyCode.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyCode.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyCode.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
    }

    internal static var codeStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyCode.__repr__(_:zelf:))
      result.__hash__ = .init(PyCode.__hash__(_:zelf:))
      result.__eq__ = .init(PyCode.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyCode.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyCode.__lt__(_:zelf:other:))
      result.__le__ = .init(PyCode.__le__(_:zelf:other:))
      result.__gt__ = .init(PyCode.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyCode.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyCode.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - Complex

    private func fillComplex(_ py: Py) {
      let type = self.complex
      type.setBuiltinTypeDoc(py, value: PyComplex.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyComplex.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let real = FunctionWrapper(name: "__get__", fn: PyComplex.real(_:zelf:))
      self.add(py, type: type, name: "real", property: real, doc: nil)
      let imag = FunctionWrapper(name: "__get__", fn: PyComplex.imag(_:zelf:))
      self.add(py, type: type, name: "imag", property: imag, doc: nil)
      let __class__ = FunctionWrapper(name: "__get__", fn: PyComplex.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyComplex.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyComplex.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyComplex.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyComplex.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyComplex.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyComplex.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyComplex.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyComplex.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyComplex.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __bool__ = FunctionWrapper(name: "__bool__", fn: PyComplex.__bool__(_:zelf:))
      self.add(py, type: type, name: "__bool__", method: __bool__, doc: nil)
      let __int__ = FunctionWrapper(name: "__int__", fn: PyComplex.__int__(_:zelf:))
      self.add(py, type: type, name: "__int__", method: __int__, doc: nil)
      let __float__ = FunctionWrapper(name: "__float__", fn: PyComplex.__float__(_:zelf:))
      self.add(py, type: type, name: "__float__", method: __float__, doc: nil)
      let conjugate = FunctionWrapper(name: "conjugate", fn: PyComplex.conjugate(_:zelf:))
      self.add(py, type: type, name: "conjugate", method: conjugate, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyComplex.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __pos__ = FunctionWrapper(name: "__pos__", fn: PyComplex.__pos__(_:zelf:))
      self.add(py, type: type, name: "__pos__", method: __pos__, doc: nil)
      let __neg__ = FunctionWrapper(name: "__neg__", fn: PyComplex.__neg__(_:zelf:))
      self.add(py, type: type, name: "__neg__", method: __neg__, doc: nil)
      let __abs__ = FunctionWrapper(name: "__abs__", fn: PyComplex.__abs__(_:zelf:))
      self.add(py, type: type, name: "__abs__", method: __abs__, doc: nil)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyComplex.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __radd__ = FunctionWrapper(name: "__radd__", fn: PyComplex.__radd__(_:zelf:other:))
      self.add(py, type: type, name: "__radd__", method: __radd__, doc: nil)
      let __sub__ = FunctionWrapper(name: "__sub__", fn: PyComplex.__sub__(_:zelf:other:))
      self.add(py, type: type, name: "__sub__", method: __sub__, doc: nil)
      let __rsub__ = FunctionWrapper(name: "__rsub__", fn: PyComplex.__rsub__(_:zelf:other:))
      self.add(py, type: type, name: "__rsub__", method: __rsub__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyComplex.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyComplex.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
      let __pow__ = FunctionWrapper(name: "__pow__", fn: PyComplex.__pow__(_:zelf:exp:mod:))
      self.add(py, type: type, name: "__pow__", method: __pow__, doc: nil)
      let __rpow__ = FunctionWrapper(name: "__rpow__", fn: PyComplex.__rpow__(_:zelf:base:mod:))
      self.add(py, type: type, name: "__rpow__", method: __rpow__, doc: nil)
      let __truediv__ = FunctionWrapper(name: "__truediv__", fn: PyComplex.__truediv__(_:zelf:other:))
      self.add(py, type: type, name: "__truediv__", method: __truediv__, doc: nil)
      let __rtruediv__ = FunctionWrapper(name: "__rtruediv__", fn: PyComplex.__rtruediv__(_:zelf:other:))
      self.add(py, type: type, name: "__rtruediv__", method: __rtruediv__, doc: nil)
      let __floordiv__ = FunctionWrapper(name: "__floordiv__", fn: PyComplex.__floordiv__(_:zelf:other:))
      self.add(py, type: type, name: "__floordiv__", method: __floordiv__, doc: nil)
      let __rfloordiv__ = FunctionWrapper(name: "__rfloordiv__", fn: PyComplex.__rfloordiv__(_:zelf:other:))
      self.add(py, type: type, name: "__rfloordiv__", method: __rfloordiv__, doc: nil)
      let __mod__ = FunctionWrapper(name: "__mod__", fn: PyComplex.__mod__(_:zelf:other:))
      self.add(py, type: type, name: "__mod__", method: __mod__, doc: nil)
      let __rmod__ = FunctionWrapper(name: "__rmod__", fn: PyComplex.__rmod__(_:zelf:other:))
      self.add(py, type: type, name: "__rmod__", method: __rmod__, doc: nil)
      let __divmod__ = FunctionWrapper(name: "__divmod__", fn: PyComplex.__divmod__(_:zelf:other:))
      self.add(py, type: type, name: "__divmod__", method: __divmod__, doc: nil)
      let __rdivmod__ = FunctionWrapper(name: "__rdivmod__", fn: PyComplex.__rdivmod__(_:zelf:other:))
      self.add(py, type: type, name: "__rdivmod__", method: __rdivmod__, doc: nil)
      let __getnewargs__ = FunctionWrapper(name: "__getnewargs__", fn: PyComplex.__getnewargs__(_:zelf:))
      self.add(py, type: type, name: "__getnewargs__", method: __getnewargs__, doc: nil)
    }

    internal static var complexStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyComplex.__repr__(_:zelf:))
      result.__str__ = .init(PyComplex.__str__(_:zelf:))
      result.__hash__ = .init(PyComplex.__hash__(_:zelf:))
      result.__eq__ = .init(PyComplex.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyComplex.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyComplex.__lt__(_:zelf:other:))
      result.__le__ = .init(PyComplex.__le__(_:zelf:other:))
      result.__gt__ = .init(PyComplex.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyComplex.__ge__(_:zelf:other:))
      result.__bool__ = .init(PyComplex.__bool__(_:zelf:))
      result.__int__ = .init(PyComplex.__int__(_:zelf:))
      result.__float__ = .init(PyComplex.__float__(_:zelf:))
      result.__getattribute__ = .init(PyComplex.__getattribute__(_:zelf:name:))
      result.__pos__ = .init(PyComplex.__pos__(_:zelf:))
      result.__neg__ = .init(PyComplex.__neg__(_:zelf:))
      result.__abs__ = .init(PyComplex.__abs__(_:zelf:))
      result.__add__ = .init(PyComplex.__add__(_:zelf:other:))
      result.__divmod__ = .init(PyComplex.__divmod__(_:zelf:other:))
      result.__floordiv__ = .init(PyComplex.__floordiv__(_:zelf:other:))
      result.__mod__ = .init(PyComplex.__mod__(_:zelf:other:))
      result.__mul__ = .init(PyComplex.__mul__(_:zelf:other:))
      result.__sub__ = .init(PyComplex.__sub__(_:zelf:other:))
      result.__truediv__ = .init(PyComplex.__truediv__(_:zelf:other:))
      result.__radd__ = .init(PyComplex.__radd__(_:zelf:other:))
      result.__rdivmod__ = .init(PyComplex.__rdivmod__(_:zelf:other:))
      result.__rfloordiv__ = .init(PyComplex.__rfloordiv__(_:zelf:other:))
      result.__rmod__ = .init(PyComplex.__rmod__(_:zelf:other:))
      result.__rmul__ = .init(PyComplex.__rmul__(_:zelf:other:))
      result.__rsub__ = .init(PyComplex.__rsub__(_:zelf:other:))
      result.__rtruediv__ = .init(PyComplex.__rtruediv__(_:zelf:other:))
      result.__pow__ = .init(PyComplex.__pow__(_:zelf:exp:mod:))
      result.__rpow__ = .init(PyComplex.__rpow__(_:zelf:base:mod:))
      return result
    }()

    // MARK: - Dict

    private func fillDict(_ py: Py) {
      let type = self.dict
      type.setBuiltinTypeDoc(py, value: PyDict.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDict.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyDict.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDict.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let fromkeys = FunctionWrapper(name: "fromkeys", fn: PyDict.fromkeys(_:type:iterable:value:))
      self.add(py, type: type, name: "fromkeys", classMethod: fromkeys, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyDict.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyDict.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyDict.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyDict.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyDict.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyDict.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyDict.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyDict.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyDict.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyDict.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __getitem__ = FunctionWrapper(name: "__getitem__", fn: PyDict.__getitem__(_:zelf:index:))
      self.add(py, type: type, name: "__getitem__", method: __getitem__, doc: nil)
      let __setitem__ = FunctionWrapper(name: "__setitem__", fn: PyDict.__setitem__(_:zelf:index:value:))
      self.add(py, type: type, name: "__setitem__", method: __setitem__, doc: nil)
      let __delitem__ = FunctionWrapper(name: "__delitem__", fn: PyDict.__delitem__(_:zelf:index:))
      self.add(py, type: type, name: "__delitem__", method: __delitem__, doc: nil)
      let get = FunctionWrapper(name: "get", fn: PyDict.get(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "get", method: get, doc: PyDict.getWithDefaultDoc)
      let setdefault = FunctionWrapper(name: "setdefault", fn: PyDict.setdefault(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "setdefault", method: setdefault, doc: PyDict.setDefaultDoc)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyDict.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyDict.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let clear = FunctionWrapper(name: "clear", fn: PyDict.clear(_:zelf:))
      self.add(py, type: type, name: "clear", method: clear, doc: PyDict.clearDoc)
      let update = FunctionWrapper(name: "update", fn: PyDict.update(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "update", method: update, doc: nil)
      let copy = FunctionWrapper(name: "copy", fn: PyDict.copy(_:zelf:))
      self.add(py, type: type, name: "copy", method: copy, doc: PyDict.copyDoc)
      let pop = FunctionWrapper(name: "pop", fn: PyDict.pop(_:zelf:index:default:))
      self.add(py, type: type, name: "pop", method: pop, doc: PyDict.popDoc)
      let popitem = FunctionWrapper(name: "popitem", fn: PyDict.popitem(_:zelf:))
      self.add(py, type: type, name: "popitem", method: popitem, doc: PyDict.popitemDoc)
      let keys = FunctionWrapper(name: "keys", fn: PyDict.keys(_:zelf:))
      self.add(py, type: type, name: "keys", method: keys, doc: nil)
      let items = FunctionWrapper(name: "items", fn: PyDict.items(_:zelf:))
      self.add(py, type: type, name: "items", method: items, doc: nil)
      let values = FunctionWrapper(name: "values", fn: PyDict.values(_:zelf:))
      self.add(py, type: type, name: "values", method: values, doc: nil)
    }

    internal static var dictStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyDict.__repr__(_:zelf:))
      result.__hash__ = .init(PyDict.__hash__(_:zelf:))
      result.__eq__ = .init(PyDict.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyDict.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyDict.__lt__(_:zelf:other:))
      result.__le__ = .init(PyDict.__le__(_:zelf:other:))
      result.__gt__ = .init(PyDict.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyDict.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyDict.__getattribute__(_:zelf:name:))
      result.__getitem__ = .init(PyDict.__getitem__(_:zelf:index:))
      result.__setitem__ = .init(PyDict.__setitem__(_:zelf:index:value:))
      result.__delitem__ = .init(PyDict.__delitem__(_:zelf:index:))
      result.__iter__ = .init(PyDict.__iter__(_:zelf:))
      result.__len__ = .init(PyDict.__len__(_:zelf:))
      result.__contains__ = .init(PyDict.__contains__(_:zelf:object:))
      result.keys = .init(PyDict.keys(_:zelf:))
      return result
    }()

    // MARK: - DictItemIterator

    private func fillDictItemIterator(_ py: Py) {
      let type = self.dict_itemiterator
      type.setBuiltinTypeDoc(py, value: PyDictItemIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDictItemIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDictItemIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyDictItemIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyDictItemIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyDictItemIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyDictItemIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var dictItemIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyDictItemIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyDictItemIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyDictItemIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - DictItems

    private func fillDictItems(_ py: Py) {
      let type = self.dict_items
      type.setBuiltinTypeDoc(py, value: PyDictItems.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDictItems.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDictItems.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyDictItems.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyDictItems.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyDictItems.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyDictItems.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyDictItems.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyDictItems.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyDictItems.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyDictItems.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyDictItems.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyDictItems.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyDictItems.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyDictItems.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
    }

    internal static var dictItemsStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyDictItems.__repr__(_:zelf:))
      result.__hash__ = .init(PyDictItems.__hash__(_:zelf:))
      result.__eq__ = .init(PyDictItems.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyDictItems.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyDictItems.__lt__(_:zelf:other:))
      result.__le__ = .init(PyDictItems.__le__(_:zelf:other:))
      result.__gt__ = .init(PyDictItems.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyDictItems.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyDictItems.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyDictItems.__iter__(_:zelf:))
      result.__len__ = .init(PyDictItems.__len__(_:zelf:))
      result.__contains__ = .init(PyDictItems.__contains__(_:zelf:object:))
      return result
    }()

    // MARK: - DictKeyIterator

    private func fillDictKeyIterator(_ py: Py) {
      let type = self.dict_keyiterator
      type.setBuiltinTypeDoc(py, value: PyDictKeyIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDictKeyIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDictKeyIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyDictKeyIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyDictKeyIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyDictKeyIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyDictKeyIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var dictKeyIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyDictKeyIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyDictKeyIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyDictKeyIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - DictKeys

    private func fillDictKeys(_ py: Py) {
      let type = self.dict_keys
      type.setBuiltinTypeDoc(py, value: PyDictKeys.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDictKeys.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDictKeys.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyDictKeys.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyDictKeys.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyDictKeys.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyDictKeys.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyDictKeys.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyDictKeys.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyDictKeys.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyDictKeys.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyDictKeys.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyDictKeys.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyDictKeys.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyDictKeys.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
    }

    internal static var dictKeysStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyDictKeys.__repr__(_:zelf:))
      result.__hash__ = .init(PyDictKeys.__hash__(_:zelf:))
      result.__eq__ = .init(PyDictKeys.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyDictKeys.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyDictKeys.__lt__(_:zelf:other:))
      result.__le__ = .init(PyDictKeys.__le__(_:zelf:other:))
      result.__gt__ = .init(PyDictKeys.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyDictKeys.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyDictKeys.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyDictKeys.__iter__(_:zelf:))
      result.__len__ = .init(PyDictKeys.__len__(_:zelf:))
      result.__contains__ = .init(PyDictKeys.__contains__(_:zelf:object:))
      return result
    }()

    // MARK: - DictValueIterator

    private func fillDictValueIterator(_ py: Py) {
      let type = self.dict_valueiterator
      type.setBuiltinTypeDoc(py, value: PyDictValueIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDictValueIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDictValueIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyDictValueIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyDictValueIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyDictValueIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyDictValueIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var dictValueIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyDictValueIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyDictValueIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyDictValueIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - DictValues

    private func fillDictValues(_ py: Py) {
      let type = self.dict_values
      type.setBuiltinTypeDoc(py, value: PyDictValues.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDictValues.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyDictValues.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyDictValues.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyDictValues.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyDictValues.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
    }

    internal static var dictValuesStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyDictValues.__repr__(_:zelf:))
      result.__getattribute__ = .init(PyDictValues.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyDictValues.__iter__(_:zelf:))
      result.__len__ = .init(PyDictValues.__len__(_:zelf:))
      return result
    }()

    // MARK: - Ellipsis

    private func fillEllipsis(_ py: Py) {
      let type = self.ellipsis
      type.setBuiltinTypeDoc(py, value: PyEllipsis.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyEllipsis.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyEllipsis.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyEllipsis.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __reduce__ = FunctionWrapper(name: "__reduce__", fn: PyEllipsis.__reduce__(_:zelf:))
      self.add(py, type: type, name: "__reduce__", method: __reduce__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyEllipsis.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
    }

    internal static var ellipsisStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyEllipsis.__repr__(_:zelf:))
      result.__getattribute__ = .init(PyEllipsis.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - Enumerate

    private func fillEnumerate(_ py: Py) {
      let type = self.enumerate
      type.setBuiltinTypeDoc(py, value: PyEnumerate.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyEnumerate.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyEnumerate.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyEnumerate.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyEnumerate.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyEnumerate.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
    }

    internal static var enumerateStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyEnumerate.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyEnumerate.__iter__(_:zelf:))
      result.__next__ = .init(PyEnumerate.__next__(_:zelf:))
      return result
    }()

    // MARK: - Filter

    private func fillFilter(_ py: Py) {
      let type = self.filter
      type.setBuiltinTypeDoc(py, value: PyFilter.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFilter.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFilter.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyFilter.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyFilter.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyFilter.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
    }

    internal static var filterStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyFilter.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyFilter.__iter__(_:zelf:))
      result.__next__ = .init(PyFilter.__next__(_:zelf:))
      return result
    }()

    // MARK: - Float

    private func fillFloat(_ py: Py) {
      let type = self.float
      type.setBuiltinTypeDoc(py, value: PyFloat.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFloat.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: PyFloat.newDoc)

      let real = FunctionWrapper(name: "__get__", fn: PyFloat.real(_:zelf:))
      self.add(py, type: type, name: "real", property: real, doc: PyFloat.hexDoc)
      let imag = FunctionWrapper(name: "__get__", fn: PyFloat.imag(_:zelf:))
      self.add(py, type: type, name: "imag", property: imag, doc: PyFloat.hexDoc)
      let __class__ = FunctionWrapper(name: "__get__", fn: PyFloat.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: PyFloat.hexDoc)

      let fromhex = FunctionWrapper(name: "fromhex", fn: PyFloat.fromhex(_:type:value:))
      self.add(py, type: type, name: "fromhex", classMethod: fromhex, doc: PyFloat.fromHexDoc)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyFloat.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyFloat.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyFloat.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyFloat.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyFloat.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyFloat.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyFloat.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyFloat.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyFloat.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __bool__ = FunctionWrapper(name: "__bool__", fn: PyFloat.__bool__(_:zelf:))
      self.add(py, type: type, name: "__bool__", method: __bool__, doc: nil)
      let __int__ = FunctionWrapper(name: "__int__", fn: PyFloat.__int__(_:zelf:))
      self.add(py, type: type, name: "__int__", method: __int__, doc: nil)
      let __float__ = FunctionWrapper(name: "__float__", fn: PyFloat.__float__(_:zelf:))
      self.add(py, type: type, name: "__float__", method: __float__, doc: nil)
      let conjugate = FunctionWrapper(name: "conjugate", fn: PyFloat.conjugate(_:zelf:))
      self.add(py, type: type, name: "conjugate", method: conjugate, doc: PyFloat.conjugateDoc)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyFloat.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __pos__ = FunctionWrapper(name: "__pos__", fn: PyFloat.__pos__(_:zelf:))
      self.add(py, type: type, name: "__pos__", method: __pos__, doc: nil)
      let __neg__ = FunctionWrapper(name: "__neg__", fn: PyFloat.__neg__(_:zelf:))
      self.add(py, type: type, name: "__neg__", method: __neg__, doc: nil)
      let __abs__ = FunctionWrapper(name: "__abs__", fn: PyFloat.__abs__(_:zelf:))
      self.add(py, type: type, name: "__abs__", method: __abs__, doc: nil)
      let is_integer = FunctionWrapper(name: "is_integer", fn: PyFloat.is_integer(_:zelf:))
      self.add(py, type: type, name: "is_integer", method: is_integer, doc: PyFloat.isIntegerDoc)
      let as_integer_ratio = FunctionWrapper(name: "as_integer_ratio", fn: PyFloat.as_integer_ratio(_:zelf:))
      self.add(py, type: type, name: "as_integer_ratio", method: as_integer_ratio, doc: PyFloat.asIntegerRatioDoc)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyFloat.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __radd__ = FunctionWrapper(name: "__radd__", fn: PyFloat.__radd__(_:zelf:other:))
      self.add(py, type: type, name: "__radd__", method: __radd__, doc: nil)
      let __sub__ = FunctionWrapper(name: "__sub__", fn: PyFloat.__sub__(_:zelf:other:))
      self.add(py, type: type, name: "__sub__", method: __sub__, doc: nil)
      let __rsub__ = FunctionWrapper(name: "__rsub__", fn: PyFloat.__rsub__(_:zelf:other:))
      self.add(py, type: type, name: "__rsub__", method: __rsub__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyFloat.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyFloat.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
      let __pow__ = FunctionWrapper(name: "__pow__", fn: PyFloat.__pow__(_:zelf:exp:mod:))
      self.add(py, type: type, name: "__pow__", method: __pow__, doc: nil)
      let __rpow__ = FunctionWrapper(name: "__rpow__", fn: PyFloat.__rpow__(_:zelf:base:mod:))
      self.add(py, type: type, name: "__rpow__", method: __rpow__, doc: nil)
      let __truediv__ = FunctionWrapper(name: "__truediv__", fn: PyFloat.__truediv__(_:zelf:other:))
      self.add(py, type: type, name: "__truediv__", method: __truediv__, doc: nil)
      let __rtruediv__ = FunctionWrapper(name: "__rtruediv__", fn: PyFloat.__rtruediv__(_:zelf:other:))
      self.add(py, type: type, name: "__rtruediv__", method: __rtruediv__, doc: nil)
      let __floordiv__ = FunctionWrapper(name: "__floordiv__", fn: PyFloat.__floordiv__(_:zelf:other:))
      self.add(py, type: type, name: "__floordiv__", method: __floordiv__, doc: nil)
      let __rfloordiv__ = FunctionWrapper(name: "__rfloordiv__", fn: PyFloat.__rfloordiv__(_:zelf:other:))
      self.add(py, type: type, name: "__rfloordiv__", method: __rfloordiv__, doc: nil)
      let __mod__ = FunctionWrapper(name: "__mod__", fn: PyFloat.__mod__(_:zelf:other:))
      self.add(py, type: type, name: "__mod__", method: __mod__, doc: nil)
      let __rmod__ = FunctionWrapper(name: "__rmod__", fn: PyFloat.__rmod__(_:zelf:other:))
      self.add(py, type: type, name: "__rmod__", method: __rmod__, doc: nil)
      let __divmod__ = FunctionWrapper(name: "__divmod__", fn: PyFloat.__divmod__(_:zelf:other:))
      self.add(py, type: type, name: "__divmod__", method: __divmod__, doc: nil)
      let __rdivmod__ = FunctionWrapper(name: "__rdivmod__", fn: PyFloat.__rdivmod__(_:zelf:other:))
      self.add(py, type: type, name: "__rdivmod__", method: __rdivmod__, doc: nil)
      let __round__ = FunctionWrapper(name: "__round__", fn: PyFloat.__round__(_:zelf:nDigits:))
      self.add(py, type: type, name: "__round__", method: __round__, doc: PyFloat.roundDoc)
      let __trunc__ = FunctionWrapper(name: "__trunc__", fn: PyFloat.__trunc__(_:zelf:))
      self.add(py, type: type, name: "__trunc__", method: __trunc__, doc: PyFloat.truncDoc)
      let hex = FunctionWrapper(name: "hex", fn: PyFloat.hex(_:zelf:))
      self.add(py, type: type, name: "hex", method: hex, doc: PyFloat.hexDoc)
    }

    internal static var floatStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyFloat.__repr__(_:zelf:))
      result.__str__ = .init(PyFloat.__str__(_:zelf:))
      result.__hash__ = .init(PyFloat.__hash__(_:zelf:))
      result.__eq__ = .init(PyFloat.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyFloat.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyFloat.__lt__(_:zelf:other:))
      result.__le__ = .init(PyFloat.__le__(_:zelf:other:))
      result.__gt__ = .init(PyFloat.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyFloat.__ge__(_:zelf:other:))
      result.__bool__ = .init(PyFloat.__bool__(_:zelf:))
      result.__int__ = .init(PyFloat.__int__(_:zelf:))
      result.__float__ = .init(PyFloat.__float__(_:zelf:))
      result.__getattribute__ = .init(PyFloat.__getattribute__(_:zelf:name:))
      result.__pos__ = .init(PyFloat.__pos__(_:zelf:))
      result.__neg__ = .init(PyFloat.__neg__(_:zelf:))
      result.__abs__ = .init(PyFloat.__abs__(_:zelf:))
      result.__trunc__ = .init(PyFloat.__trunc__(_:zelf:))
      result.__round__ = .init(PyFloat.__round__(_:zelf:nDigits:))
      result.__add__ = .init(PyFloat.__add__(_:zelf:other:))
      result.__divmod__ = .init(PyFloat.__divmod__(_:zelf:other:))
      result.__floordiv__ = .init(PyFloat.__floordiv__(_:zelf:other:))
      result.__mod__ = .init(PyFloat.__mod__(_:zelf:other:))
      result.__mul__ = .init(PyFloat.__mul__(_:zelf:other:))
      result.__sub__ = .init(PyFloat.__sub__(_:zelf:other:))
      result.__truediv__ = .init(PyFloat.__truediv__(_:zelf:other:))
      result.__radd__ = .init(PyFloat.__radd__(_:zelf:other:))
      result.__rdivmod__ = .init(PyFloat.__rdivmod__(_:zelf:other:))
      result.__rfloordiv__ = .init(PyFloat.__rfloordiv__(_:zelf:other:))
      result.__rmod__ = .init(PyFloat.__rmod__(_:zelf:other:))
      result.__rmul__ = .init(PyFloat.__rmul__(_:zelf:other:))
      result.__rsub__ = .init(PyFloat.__rsub__(_:zelf:other:))
      result.__rtruediv__ = .init(PyFloat.__rtruediv__(_:zelf:other:))
      result.__pow__ = .init(PyFloat.__pow__(_:zelf:exp:mod:))
      result.__rpow__ = .init(PyFloat.__rpow__(_:zelf:base:mod:))
      return result
    }()

    // MARK: - Frame

    private func fillFrame(_ py: Py) {
      let type = self.frame
      type.setBuiltinTypeDoc(py, value: PyFrame.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFrame.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let f_back = FunctionWrapper(name: "__get__", fn: PyFrame.f_back(_:zelf:))
      self.add(py, type: type, name: "f_back", property: f_back, doc: nil)
      let f_builtins = FunctionWrapper(name: "__get__", fn: PyFrame.f_builtins(_:zelf:))
      self.add(py, type: type, name: "f_builtins", property: f_builtins, doc: nil)
      let f_globals = FunctionWrapper(name: "__get__", fn: PyFrame.f_globals(_:zelf:))
      self.add(py, type: type, name: "f_globals", property: f_globals, doc: nil)
      let f_locals = FunctionWrapper(name: "__get__", fn: PyFrame.f_locals(_:zelf:))
      self.add(py, type: type, name: "f_locals", property: f_locals, doc: nil)
      let f_code = FunctionWrapper(name: "__get__", fn: PyFrame.f_code(_:zelf:))
      self.add(py, type: type, name: "f_code", property: f_code, doc: nil)
      let f_lasti = FunctionWrapper(name: "__get__", fn: PyFrame.f_lasti(_:zelf:))
      self.add(py, type: type, name: "f_lasti", property: f_lasti, doc: nil)
      let f_lineno = FunctionWrapper(name: "__get__", fn: PyFrame.f_lineno(_:zelf:))
      self.add(py, type: type, name: "f_lineno", property: f_lineno, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyFrame.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyFrame.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __setattr__ = FunctionWrapper(name: "__setattr__", fn: PyFrame.__setattr__(_:zelf:name:value:))
      self.add(py, type: type, name: "__setattr__", method: __setattr__, doc: nil)
      let __delattr__ = FunctionWrapper(name: "__delattr__", fn: PyFrame.__delattr__(_:zelf:name:))
      self.add(py, type: type, name: "__delattr__", method: __delattr__, doc: nil)
    }

    internal static var frameStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyFrame.__repr__(_:zelf:))
      result.__getattribute__ = .init(PyFrame.__getattribute__(_:zelf:name:))
      result.__setattr__ = .init(PyFrame.__setattr__(_:zelf:name:value:))
      result.__delattr__ = .init(PyFrame.__delattr__(_:zelf:name:))
      return result
    }()

    // MARK: - FrozenSet

    private func fillFrozenSet(_ py: Py) {
      let type = self.frozenset
      type.setBuiltinTypeDoc(py, value: PyFrozenSet.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFrozenSet.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFrozenSet.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyFrozenSet.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyFrozenSet.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyFrozenSet.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyFrozenSet.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyFrozenSet.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyFrozenSet.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyFrozenSet.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyFrozenSet.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyFrozenSet.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyFrozenSet.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyFrozenSet.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __and__ = FunctionWrapper(name: "__and__", fn: PyFrozenSet.__and__(_:zelf:other:))
      self.add(py, type: type, name: "__and__", method: __and__, doc: nil)
      let __rand__ = FunctionWrapper(name: "__rand__", fn: PyFrozenSet.__rand__(_:zelf:other:))
      self.add(py, type: type, name: "__rand__", method: __rand__, doc: nil)
      let __or__ = FunctionWrapper(name: "__or__", fn: PyFrozenSet.__or__(_:zelf:other:))
      self.add(py, type: type, name: "__or__", method: __or__, doc: nil)
      let __ror__ = FunctionWrapper(name: "__ror__", fn: PyFrozenSet.__ror__(_:zelf:other:))
      self.add(py, type: type, name: "__ror__", method: __ror__, doc: nil)
      let __xor__ = FunctionWrapper(name: "__xor__", fn: PyFrozenSet.__xor__(_:zelf:other:))
      self.add(py, type: type, name: "__xor__", method: __xor__, doc: nil)
      let __rxor__ = FunctionWrapper(name: "__rxor__", fn: PyFrozenSet.__rxor__(_:zelf:other:))
      self.add(py, type: type, name: "__rxor__", method: __rxor__, doc: nil)
      let __sub__ = FunctionWrapper(name: "__sub__", fn: PyFrozenSet.__sub__(_:zelf:other:))
      self.add(py, type: type, name: "__sub__", method: __sub__, doc: nil)
      let __rsub__ = FunctionWrapper(name: "__rsub__", fn: PyFrozenSet.__rsub__(_:zelf:other:))
      self.add(py, type: type, name: "__rsub__", method: __rsub__, doc: nil)
      let issubset = FunctionWrapper(name: "issubset", fn: PyFrozenSet.issubset(_:zelf:other:))
      self.add(py, type: type, name: "issubset", method: issubset, doc: PyFrozenSet.isSubsetDoc)
      let issuperset = FunctionWrapper(name: "issuperset", fn: PyFrozenSet.issuperset(_:zelf:other:))
      self.add(py, type: type, name: "issuperset", method: issuperset, doc: PyFrozenSet.isSupersetDoc)
      let isdisjoint = FunctionWrapper(name: "isdisjoint", fn: PyFrozenSet.isdisjoint(_:zelf:other:))
      self.add(py, type: type, name: "isdisjoint", method: isdisjoint, doc: PyFrozenSet.isDisjointDoc)
      let intersection = FunctionWrapper(name: "intersection", fn: PyFrozenSet.intersection(_:zelf:other:))
      self.add(py, type: type, name: "intersection", method: intersection, doc: PyFrozenSet.intersectionDoc)
      let union = FunctionWrapper(name: "union", fn: PyFrozenSet.union(_:zelf:other:))
      self.add(py, type: type, name: "union", method: union, doc: PyFrozenSet.unionDoc)
      let difference = FunctionWrapper(name: "difference", fn: PyFrozenSet.difference(_:zelf:other:))
      self.add(py, type: type, name: "difference", method: difference, doc: PyFrozenSet.differenceDoc)
      let symmetric_difference = FunctionWrapper(name: "symmetric_difference", fn: PyFrozenSet.symmetric_difference(_:zelf:other:))
      self.add(py, type: type, name: "symmetric_difference", method: symmetric_difference, doc: PyFrozenSet.symmetricDifferenceDoc)
      let copy = FunctionWrapper(name: "copy", fn: PyFrozenSet.copy(_:zelf:))
      self.add(py, type: type, name: "copy", method: copy, doc: PyFrozenSet.copyDoc)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyFrozenSet.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
    }

    internal static var frozenSetStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyFrozenSet.__repr__(_:zelf:))
      result.__hash__ = .init(PyFrozenSet.__hash__(_:zelf:))
      result.__eq__ = .init(PyFrozenSet.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyFrozenSet.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyFrozenSet.__lt__(_:zelf:other:))
      result.__le__ = .init(PyFrozenSet.__le__(_:zelf:other:))
      result.__gt__ = .init(PyFrozenSet.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyFrozenSet.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyFrozenSet.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyFrozenSet.__iter__(_:zelf:))
      result.__len__ = .init(PyFrozenSet.__len__(_:zelf:))
      result.__contains__ = .init(PyFrozenSet.__contains__(_:zelf:object:))
      result.__and__ = .init(PyFrozenSet.__and__(_:zelf:other:))
      result.__or__ = .init(PyFrozenSet.__or__(_:zelf:other:))
      result.__sub__ = .init(PyFrozenSet.__sub__(_:zelf:other:))
      result.__xor__ = .init(PyFrozenSet.__xor__(_:zelf:other:))
      result.__rand__ = .init(PyFrozenSet.__rand__(_:zelf:other:))
      result.__ror__ = .init(PyFrozenSet.__ror__(_:zelf:other:))
      result.__rsub__ = .init(PyFrozenSet.__rsub__(_:zelf:other:))
      result.__rxor__ = .init(PyFrozenSet.__rxor__(_:zelf:other:))
      return result
    }()

    // MARK: - Function

    private func fillFunction(_ py: Py) {
      let type = self.function
      type.setBuiltinTypeDoc(py, value: PyFunction.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFunction.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __name__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__name__(_:zelf:))
      let __name__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__name__(_:zelf:value:))
      self.add(py, type: type, name: "__name__", property: __name__Get, setter: __name__Set, doc: nil)
      let __qualname__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__qualname__(_:zelf:))
      let __qualname__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__qualname__(_:zelf:value:))
      self.add(py, type: type, name: "__qualname__", property: __qualname__Get, setter: __qualname__Set, doc: nil)
      let __defaults__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__defaults__(_:zelf:))
      let __defaults__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__defaults__(_:zelf:value:))
      self.add(py, type: type, name: "__defaults__", property: __defaults__Get, setter: __defaults__Set, doc: nil)
      let __kwdefaults__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__kwdefaults__(_:zelf:))
      let __kwdefaults__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__kwdefaults__(_:zelf:value:))
      self.add(py, type: type, name: "__kwdefaults__", property: __kwdefaults__Get, setter: __kwdefaults__Set, doc: nil)
      let __closure__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__closure__(_:zelf:))
      let __closure__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__closure__(_:zelf:value:))
      self.add(py, type: type, name: "__closure__", property: __closure__Get, setter: __closure__Set, doc: nil)
      let __globals__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__globals__(_:zelf:))
      let __globals__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__globals__(_:zelf:value:))
      self.add(py, type: type, name: "__globals__", property: __globals__Get, setter: __globals__Set, doc: nil)
      let __annotations__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__annotations__(_:zelf:))
      let __annotations__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__annotations__(_:zelf:value:))
      self.add(py, type: type, name: "__annotations__", property: __annotations__Get, setter: __annotations__Set, doc: nil)
      let __code__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__code__(_:zelf:))
      let __code__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__code__(_:zelf:value:))
      self.add(py, type: type, name: "__code__", property: __code__Get, setter: __code__Set, doc: nil)
      let __doc__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__doc__(_:zelf:))
      let __doc__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__doc__(_:zelf:value:))
      self.add(py, type: type, name: "__doc__", property: __doc__Get, setter: __doc__Set, doc: nil)
      let __module__Get = FunctionWrapper(name: "__get__", fn: PyFunction.__module__(_:zelf:))
      let __module__Set = FunctionWrapper(name: "__set__", fn: PyFunction.__module__(_:zelf:value:))
      self.add(py, type: type, name: "__module__", property: __module__Get, setter: __module__Set, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyFunction.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyFunction.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __get__ = FunctionWrapper(name: "__get__", fn: PyFunction.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
      let __call__ = FunctionWrapper(name: "__call__", fn: PyFunction.__call__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__call__", method: __call__, doc: nil)
    }

    internal static var functionStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyFunction.__repr__(_:zelf:))
      result.__call__ = .init(PyFunction.__call__(_:zelf:args:kwargs:))
      return result
    }()

    // MARK: - Int

    private func fillInt(_ py: Py) {
      let type = self.int
      type.setBuiltinTypeDoc(py, value: PyInt.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyInt.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyInt.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let real = FunctionWrapper(name: "__get__", fn: PyInt.real(_:zelf:))
      self.add(py, type: type, name: "real", property: real, doc: nil)
      let imag = FunctionWrapper(name: "__get__", fn: PyInt.imag(_:zelf:))
      self.add(py, type: type, name: "imag", property: imag, doc: nil)
      let numerator = FunctionWrapper(name: "__get__", fn: PyInt.numerator(_:zelf:))
      self.add(py, type: type, name: "numerator", property: numerator, doc: nil)
      let denominator = FunctionWrapper(name: "__get__", fn: PyInt.denominator(_:zelf:))
      self.add(py, type: type, name: "denominator", property: denominator, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyInt.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyInt.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyInt.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyInt.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyInt.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyInt.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyInt.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyInt.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyInt.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __bool__ = FunctionWrapper(name: "__bool__", fn: PyInt.__bool__(_:zelf:))
      self.add(py, type: type, name: "__bool__", method: __bool__, doc: nil)
      let __int__ = FunctionWrapper(name: "__int__", fn: PyInt.__int__(_:zelf:))
      self.add(py, type: type, name: "__int__", method: __int__, doc: nil)
      let __float__ = FunctionWrapper(name: "__float__", fn: PyInt.__float__(_:zelf:))
      self.add(py, type: type, name: "__float__", method: __float__, doc: nil)
      let __index__ = FunctionWrapper(name: "__index__", fn: PyInt.__index__(_:zelf:))
      self.add(py, type: type, name: "__index__", method: __index__, doc: nil)
      let conjugate = FunctionWrapper(name: "conjugate", fn: PyInt.conjugate(_:zelf:))
      self.add(py, type: type, name: "conjugate", method: conjugate, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyInt.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __pos__ = FunctionWrapper(name: "__pos__", fn: PyInt.__pos__(_:zelf:))
      self.add(py, type: type, name: "__pos__", method: __pos__, doc: nil)
      let __neg__ = FunctionWrapper(name: "__neg__", fn: PyInt.__neg__(_:zelf:))
      self.add(py, type: type, name: "__neg__", method: __neg__, doc: nil)
      let __invert__ = FunctionWrapper(name: "__invert__", fn: PyInt.__invert__(_:zelf:))
      self.add(py, type: type, name: "__invert__", method: __invert__, doc: nil)
      let __abs__ = FunctionWrapper(name: "__abs__", fn: PyInt.__abs__(_:zelf:))
      self.add(py, type: type, name: "__abs__", method: __abs__, doc: nil)
      let __trunc__ = FunctionWrapper(name: "__trunc__", fn: PyInt.__trunc__(_:zelf:))
      self.add(py, type: type, name: "__trunc__", method: __trunc__, doc: PyInt.truncDoc)
      let __floor__ = FunctionWrapper(name: "__floor__", fn: PyInt.__floor__(_:zelf:))
      self.add(py, type: type, name: "__floor__", method: __floor__, doc: PyInt.floorDoc)
      let __ceil__ = FunctionWrapper(name: "__ceil__", fn: PyInt.__ceil__(_:zelf:))
      self.add(py, type: type, name: "__ceil__", method: __ceil__, doc: PyInt.ceilDoc)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyInt.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __radd__ = FunctionWrapper(name: "__radd__", fn: PyInt.__radd__(_:zelf:other:))
      self.add(py, type: type, name: "__radd__", method: __radd__, doc: nil)
      let __sub__ = FunctionWrapper(name: "__sub__", fn: PyInt.__sub__(_:zelf:other:))
      self.add(py, type: type, name: "__sub__", method: __sub__, doc: nil)
      let __rsub__ = FunctionWrapper(name: "__rsub__", fn: PyInt.__rsub__(_:zelf:other:))
      self.add(py, type: type, name: "__rsub__", method: __rsub__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyInt.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyInt.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
      let bit_length = FunctionWrapper(name: "bit_length", fn: PyInt.bit_length(_:zelf:))
      self.add(py, type: type, name: "bit_length", method: bit_length, doc: PyInt.bitLengthDoc)
      let __pow__ = FunctionWrapper(name: "__pow__", fn: PyInt.__pow__(_:zelf:exp:mod:))
      self.add(py, type: type, name: "__pow__", method: __pow__, doc: nil)
      let __rpow__ = FunctionWrapper(name: "__rpow__", fn: PyInt.__rpow__(_:zelf:base:mod:))
      self.add(py, type: type, name: "__rpow__", method: __rpow__, doc: nil)
      let __truediv__ = FunctionWrapper(name: "__truediv__", fn: PyInt.__truediv__(_:zelf:other:))
      self.add(py, type: type, name: "__truediv__", method: __truediv__, doc: nil)
      let __rtruediv__ = FunctionWrapper(name: "__rtruediv__", fn: PyInt.__rtruediv__(_:zelf:other:))
      self.add(py, type: type, name: "__rtruediv__", method: __rtruediv__, doc: nil)
      let __floordiv__ = FunctionWrapper(name: "__floordiv__", fn: PyInt.__floordiv__(_:zelf:other:))
      self.add(py, type: type, name: "__floordiv__", method: __floordiv__, doc: nil)
      let __rfloordiv__ = FunctionWrapper(name: "__rfloordiv__", fn: PyInt.__rfloordiv__(_:zelf:other:))
      self.add(py, type: type, name: "__rfloordiv__", method: __rfloordiv__, doc: nil)
      let __mod__ = FunctionWrapper(name: "__mod__", fn: PyInt.__mod__(_:zelf:other:))
      self.add(py, type: type, name: "__mod__", method: __mod__, doc: nil)
      let __rmod__ = FunctionWrapper(name: "__rmod__", fn: PyInt.__rmod__(_:zelf:other:))
      self.add(py, type: type, name: "__rmod__", method: __rmod__, doc: nil)
      let __divmod__ = FunctionWrapper(name: "__divmod__", fn: PyInt.__divmod__(_:zelf:other:))
      self.add(py, type: type, name: "__divmod__", method: __divmod__, doc: nil)
      let __rdivmod__ = FunctionWrapper(name: "__rdivmod__", fn: PyInt.__rdivmod__(_:zelf:other:))
      self.add(py, type: type, name: "__rdivmod__", method: __rdivmod__, doc: nil)
      let __lshift__ = FunctionWrapper(name: "__lshift__", fn: PyInt.__lshift__(_:zelf:other:))
      self.add(py, type: type, name: "__lshift__", method: __lshift__, doc: nil)
      let __rlshift__ = FunctionWrapper(name: "__rlshift__", fn: PyInt.__rlshift__(_:zelf:other:))
      self.add(py, type: type, name: "__rlshift__", method: __rlshift__, doc: nil)
      let __rshift__ = FunctionWrapper(name: "__rshift__", fn: PyInt.__rshift__(_:zelf:other:))
      self.add(py, type: type, name: "__rshift__", method: __rshift__, doc: nil)
      let __rrshift__ = FunctionWrapper(name: "__rrshift__", fn: PyInt.__rrshift__(_:zelf:other:))
      self.add(py, type: type, name: "__rrshift__", method: __rrshift__, doc: nil)
      let __and__ = FunctionWrapper(name: "__and__", fn: PyInt.__and__(_:zelf:other:))
      self.add(py, type: type, name: "__and__", method: __and__, doc: nil)
      let __rand__ = FunctionWrapper(name: "__rand__", fn: PyInt.__rand__(_:zelf:other:))
      self.add(py, type: type, name: "__rand__", method: __rand__, doc: nil)
      let __or__ = FunctionWrapper(name: "__or__", fn: PyInt.__or__(_:zelf:other:))
      self.add(py, type: type, name: "__or__", method: __or__, doc: nil)
      let __ror__ = FunctionWrapper(name: "__ror__", fn: PyInt.__ror__(_:zelf:other:))
      self.add(py, type: type, name: "__ror__", method: __ror__, doc: nil)
      let __xor__ = FunctionWrapper(name: "__xor__", fn: PyInt.__xor__(_:zelf:other:))
      self.add(py, type: type, name: "__xor__", method: __xor__, doc: nil)
      let __rxor__ = FunctionWrapper(name: "__rxor__", fn: PyInt.__rxor__(_:zelf:other:))
      self.add(py, type: type, name: "__rxor__", method: __rxor__, doc: nil)
      let __round__ = FunctionWrapper(name: "__round__", fn: PyInt.__round__(_:zelf:nDigits:))
      self.add(py, type: type, name: "__round__", method: __round__, doc: nil)
    }

    internal static var intStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyInt.__repr__(_:zelf:))
      result.__str__ = .init(PyInt.__str__(_:zelf:))
      result.__hash__ = .init(PyInt.__hash__(_:zelf:))
      result.__eq__ = .init(PyInt.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyInt.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyInt.__lt__(_:zelf:other:))
      result.__le__ = .init(PyInt.__le__(_:zelf:other:))
      result.__gt__ = .init(PyInt.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyInt.__ge__(_:zelf:other:))
      result.__bool__ = .init(PyInt.__bool__(_:zelf:))
      result.__int__ = .init(PyInt.__int__(_:zelf:))
      result.__float__ = .init(PyInt.__float__(_:zelf:))
      result.__index__ = .init(PyInt.__index__(_:zelf:))
      result.__getattribute__ = .init(PyInt.__getattribute__(_:zelf:name:))
      result.__pos__ = .init(PyInt.__pos__(_:zelf:))
      result.__neg__ = .init(PyInt.__neg__(_:zelf:))
      result.__invert__ = .init(PyInt.__invert__(_:zelf:))
      result.__abs__ = .init(PyInt.__abs__(_:zelf:))
      result.__trunc__ = .init(PyInt.__trunc__(_:zelf:))
      result.__round__ = .init(PyInt.__round__(_:zelf:nDigits:))
      result.__add__ = .init(PyInt.__add__(_:zelf:other:))
      result.__and__ = .init(PyInt.__and__(_:zelf:other:))
      result.__divmod__ = .init(PyInt.__divmod__(_:zelf:other:))
      result.__floordiv__ = .init(PyInt.__floordiv__(_:zelf:other:))
      result.__lshift__ = .init(PyInt.__lshift__(_:zelf:other:))
      result.__mod__ = .init(PyInt.__mod__(_:zelf:other:))
      result.__mul__ = .init(PyInt.__mul__(_:zelf:other:))
      result.__or__ = .init(PyInt.__or__(_:zelf:other:))
      result.__rshift__ = .init(PyInt.__rshift__(_:zelf:other:))
      result.__sub__ = .init(PyInt.__sub__(_:zelf:other:))
      result.__truediv__ = .init(PyInt.__truediv__(_:zelf:other:))
      result.__xor__ = .init(PyInt.__xor__(_:zelf:other:))
      result.__radd__ = .init(PyInt.__radd__(_:zelf:other:))
      result.__rand__ = .init(PyInt.__rand__(_:zelf:other:))
      result.__rdivmod__ = .init(PyInt.__rdivmod__(_:zelf:other:))
      result.__rfloordiv__ = .init(PyInt.__rfloordiv__(_:zelf:other:))
      result.__rlshift__ = .init(PyInt.__rlshift__(_:zelf:other:))
      result.__rmod__ = .init(PyInt.__rmod__(_:zelf:other:))
      result.__rmul__ = .init(PyInt.__rmul__(_:zelf:other:))
      result.__ror__ = .init(PyInt.__ror__(_:zelf:other:))
      result.__rrshift__ = .init(PyInt.__rrshift__(_:zelf:other:))
      result.__rsub__ = .init(PyInt.__rsub__(_:zelf:other:))
      result.__rtruediv__ = .init(PyInt.__rtruediv__(_:zelf:other:))
      result.__rxor__ = .init(PyInt.__rxor__(_:zelf:other:))
      result.__pow__ = .init(PyInt.__pow__(_:zelf:exp:mod:))
      result.__rpow__ = .init(PyInt.__rpow__(_:zelf:base:mod:))
      return result
    }()

    // MARK: - Iterator

    private func fillIterator(_ py: Py) {
      let type = self.iterator
      type.setBuiltinTypeDoc(py, value: PyIterator.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var iteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - List

    private func fillList(_ py: Py) {
      let type = self.list
      type.setBuiltinTypeDoc(py, value: PyList.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyList.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyList.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyList.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyList.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyList.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyList.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyList.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyList.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyList.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyList.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyList.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyList.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyList.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyList.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let count = FunctionWrapper(name: "count", fn: PyList.count(_:zelf:object:))
      self.add(py, type: type, name: "count", method: count, doc: nil)
      let index = FunctionWrapper(name: "index", fn: PyList.index(_:zelf:object:start:end:))
      self.add(py, type: type, name: "index", method: index, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyList.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __reversed__ = FunctionWrapper(name: "__reversed__", fn: PyList.__reversed__(_:zelf:))
      self.add(py, type: type, name: "__reversed__", method: __reversed__, doc: nil)
      let __getitem__ = FunctionWrapper(name: "__getitem__", fn: PyList.__getitem__(_:zelf:index:))
      self.add(py, type: type, name: "__getitem__", method: __getitem__, doc: nil)
      let __setitem__ = FunctionWrapper(name: "__setitem__", fn: PyList.__setitem__(_:zelf:index:value:))
      self.add(py, type: type, name: "__setitem__", method: __setitem__, doc: nil)
      let __delitem__ = FunctionWrapper(name: "__delitem__", fn: PyList.__delitem__(_:zelf:index:))
      self.add(py, type: type, name: "__delitem__", method: __delitem__, doc: nil)
      let append = FunctionWrapper(name: "append", fn: PyList.append(_:zelf:object:))
      self.add(py, type: type, name: "append", method: append, doc: nil)
      let insert = FunctionWrapper(name: "insert", fn: PyList.insert(_:zelf:index:object:))
      self.add(py, type: type, name: "insert", method: insert, doc: PyList.insertDoc)
      let extend = FunctionWrapper(name: "extend", fn: PyList.extend(_:zelf:iterable:))
      self.add(py, type: type, name: "extend", method: extend, doc: nil)
      let remove = FunctionWrapper(name: "remove", fn: PyList.remove(_:zelf:object:))
      self.add(py, type: type, name: "remove", method: remove, doc: PyList.removeDoc)
      let pop = FunctionWrapper(name: "pop", fn: PyList.pop(_:zelf:index:))
      self.add(py, type: type, name: "pop", method: pop, doc: nil)
      let sort = FunctionWrapper(name: "sort", fn: PyList.sort(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "sort", method: sort, doc: PyList.sortDoc)
      let reverse = FunctionWrapper(name: "reverse", fn: PyList.reverse(_:zelf:))
      self.add(py, type: type, name: "reverse", method: reverse, doc: PyList.reverseDoc)
      let clear = FunctionWrapper(name: "clear", fn: PyList.clear(_:zelf:))
      self.add(py, type: type, name: "clear", method: clear, doc: nil)
      let copy = FunctionWrapper(name: "copy", fn: PyList.copy(_:zelf:))
      self.add(py, type: type, name: "copy", method: copy, doc: nil)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyList.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __iadd__ = FunctionWrapper(name: "__iadd__", fn: PyList.__iadd__(_:zelf:other:))
      self.add(py, type: type, name: "__iadd__", method: __iadd__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyList.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyList.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
      let __imul__ = FunctionWrapper(name: "__imul__", fn: PyList.__imul__(_:zelf:other:))
      self.add(py, type: type, name: "__imul__", method: __imul__, doc: nil)
    }

    internal static var listStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyList.__repr__(_:zelf:))
      result.__hash__ = .init(PyList.__hash__(_:zelf:))
      result.__eq__ = .init(PyList.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyList.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyList.__lt__(_:zelf:other:))
      result.__le__ = .init(PyList.__le__(_:zelf:other:))
      result.__gt__ = .init(PyList.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyList.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyList.__getattribute__(_:zelf:name:))
      result.__getitem__ = .init(PyList.__getitem__(_:zelf:index:))
      result.__setitem__ = .init(PyList.__setitem__(_:zelf:index:value:))
      result.__delitem__ = .init(PyList.__delitem__(_:zelf:index:))
      result.__iter__ = .init(PyList.__iter__(_:zelf:))
      result.__len__ = .init(PyList.__len__(_:zelf:))
      result.__contains__ = .init(PyList.__contains__(_:zelf:object:))
      result.__reversed__ = .init(PyList.__reversed__(_:zelf:))
      result.__add__ = .init(PyList.__add__(_:zelf:other:))
      result.__mul__ = .init(PyList.__mul__(_:zelf:other:))
      result.__rmul__ = .init(PyList.__rmul__(_:zelf:other:))
      result.__iadd__ = .init(PyList.__iadd__(_:zelf:other:))
      result.__imul__ = .init(PyList.__imul__(_:zelf:other:))
      return result
    }()

    // MARK: - ListIterator

    private func fillListIterator(_ py: Py) {
      let type = self.list_iterator
      type.setBuiltinTypeDoc(py, value: PyListIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyListIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyListIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyListIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyListIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyListIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyListIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var listIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyListIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyListIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyListIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - ListReverseIterator

    private func fillListReverseIterator(_ py: Py) {
      let type = self.list_reverseiterator
      type.setBuiltinTypeDoc(py, value: PyListReverseIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyListReverseIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyListReverseIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyListReverseIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyListReverseIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyListReverseIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyListReverseIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var listReverseIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyListReverseIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyListReverseIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyListReverseIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - Map

    private func fillMap(_ py: Py) {
      let type = self.map
      type.setBuiltinTypeDoc(py, value: PyMap.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyMap.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyMap.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyMap.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyMap.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyMap.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
    }

    internal static var mapStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyMap.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyMap.__iter__(_:zelf:))
      result.__next__ = .init(PyMap.__next__(_:zelf:))
      return result
    }()

    // MARK: - Method

    private func fillMethod(_ py: Py) {
      let type = self.method
      type.setBuiltinTypeDoc(py, value: PyMethod.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyMethod.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __doc__ = FunctionWrapper(name: "__get__", fn: PyMethod.__doc__(_:zelf:))
      self.add(py, type: type, name: "__doc__", property: __doc__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyMethod.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyMethod.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyMethod.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyMethod.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyMethod.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyMethod.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyMethod.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyMethod.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyMethod.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __setattr__ = FunctionWrapper(name: "__setattr__", fn: PyMethod.__setattr__(_:zelf:name:value:))
      self.add(py, type: type, name: "__setattr__", method: __setattr__, doc: nil)
      let __delattr__ = FunctionWrapper(name: "__delattr__", fn: PyMethod.__delattr__(_:zelf:name:))
      self.add(py, type: type, name: "__delattr__", method: __delattr__, doc: nil)
      let __func__ = FunctionWrapper(name: "__func__", fn: PyMethod.__func__(_:zelf:))
      self.add(py, type: type, name: "__func__", method: __func__, doc: nil)
      let __self__ = FunctionWrapper(name: "__self__", fn: PyMethod.__self__(_:zelf:))
      self.add(py, type: type, name: "__self__", method: __self__, doc: nil)
      let __get__ = FunctionWrapper(name: "__get__", fn: PyMethod.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
      let __call__ = FunctionWrapper(name: "__call__", fn: PyMethod.__call__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__call__", method: __call__, doc: nil)
    }

    internal static var methodStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyMethod.__repr__(_:zelf:))
      result.__hash__ = .init(PyMethod.__hash__(_:zelf:))
      result.__eq__ = .init(PyMethod.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyMethod.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyMethod.__lt__(_:zelf:other:))
      result.__le__ = .init(PyMethod.__le__(_:zelf:other:))
      result.__gt__ = .init(PyMethod.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyMethod.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyMethod.__getattribute__(_:zelf:name:))
      result.__setattr__ = .init(PyMethod.__setattr__(_:zelf:name:value:))
      result.__delattr__ = .init(PyMethod.__delattr__(_:zelf:name:))
      result.__call__ = .init(PyMethod.__call__(_:zelf:args:kwargs:))
      return result
    }()

    // MARK: - Module

    private func fillModule(_ py: Py) {
      let type = self.module
      type.setBuiltinTypeDoc(py, value: PyModule.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyModule.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyModule.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __dict__ = FunctionWrapper(name: "__get__", fn: PyModule.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let __class__ = FunctionWrapper(name: "__get__", fn: PyModule.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyModule.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyModule.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __setattr__ = FunctionWrapper(name: "__setattr__", fn: PyModule.__setattr__(_:zelf:name:value:))
      self.add(py, type: type, name: "__setattr__", method: __setattr__, doc: nil)
      let __delattr__ = FunctionWrapper(name: "__delattr__", fn: PyModule.__delattr__(_:zelf:name:))
      self.add(py, type: type, name: "__delattr__", method: __delattr__, doc: nil)
      let __dir__ = FunctionWrapper(name: "__dir__", fn: PyModule.__dir__(_:zelf:))
      self.add(py, type: type, name: "__dir__", method: __dir__, doc: nil)
    }

    internal static var moduleStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyModule.__repr__(_:zelf:))
      result.__dir__ = .init(PyModule.__dir__(_:zelf:))
      result.__getattribute__ = .init(PyModule.__getattribute__(_:zelf:name:))
      result.__setattr__ = .init(PyModule.__setattr__(_:zelf:name:value:))
      result.__delattr__ = .init(PyModule.__delattr__(_:zelf:name:))
      return result
    }()

    // MARK: - Namespace

    private func fillNamespace(_ py: Py) {
      let type = self.simpleNamespace
      type.setBuiltinTypeDoc(py, value: PyNamespace.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNamespace.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyNamespace.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyNamespace.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyNamespace.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyNamespace.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyNamespace.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyNamespace.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyNamespace.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyNamespace.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyNamespace.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyNamespace.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyNamespace.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __setattr__ = FunctionWrapper(name: "__setattr__", fn: PyNamespace.__setattr__(_:zelf:name:value:))
      self.add(py, type: type, name: "__setattr__", method: __setattr__, doc: nil)
      let __delattr__ = FunctionWrapper(name: "__delattr__", fn: PyNamespace.__delattr__(_:zelf:name:))
      self.add(py, type: type, name: "__delattr__", method: __delattr__, doc: nil)
    }

    internal static var namespaceStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyNamespace.__repr__(_:zelf:))
      result.__eq__ = .init(PyNamespace.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyNamespace.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyNamespace.__lt__(_:zelf:other:))
      result.__le__ = .init(PyNamespace.__le__(_:zelf:other:))
      result.__gt__ = .init(PyNamespace.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyNamespace.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyNamespace.__getattribute__(_:zelf:name:))
      result.__setattr__ = .init(PyNamespace.__setattr__(_:zelf:name:value:))
      result.__delattr__ = .init(PyNamespace.__delattr__(_:zelf:name:))
      return result
    }()

    // MARK: - None

    private func fillNone(_ py: Py) {
      let type = self.none
      type.setBuiltinTypeDoc(py, value: PyNone.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNone.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyNone.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyNone.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __bool__ = FunctionWrapper(name: "__bool__", fn: PyNone.__bool__(_:zelf:))
      self.add(py, type: type, name: "__bool__", method: __bool__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyNone.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
    }

    internal static var noneStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyNone.__repr__(_:zelf:))
      result.__bool__ = .init(PyNone.__bool__(_:zelf:))
      result.__getattribute__ = .init(PyNone.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - NotImplemented

    private func fillNotImplemented(_ py: Py) {
      let type = self.notImplemented
      type.setBuiltinTypeDoc(py, value: PyNotImplemented.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNotImplemented.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyNotImplemented.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyNotImplemented.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
    }

    internal static var notImplementedStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyNotImplemented.__repr__(_:zelf:))
      return result
    }()

    // MARK: - Object

    private func fillObject(_ py: Py) {
      let type = self.object
      type.setBuiltinTypeDoc(py, value: PyObject.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyObject.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyObject.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyObject.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __subclasshook__ = FunctionWrapper(name: "__subclasshook__", fn: PyObject.__subclasshook__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__subclasshook__", classMethod: __subclasshook__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyObject.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyObject.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyObject.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyObject.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyObject.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyObject.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyObject.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyObject.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyObject.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __format__ = FunctionWrapper(name: "__format__", fn: PyObject.__format__(_:zelf:spec:))
      self.add(py, type: type, name: "__format__", method: __format__, doc: nil)
      let __dir__ = FunctionWrapper(name: "__dir__", fn: PyObject.__dir__(_:zelf:))
      self.add(py, type: type, name: "__dir__", method: __dir__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyObject.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __setattr__ = FunctionWrapper(name: "__setattr__", fn: PyObject.__setattr__(_:zelf:name:value:))
      self.add(py, type: type, name: "__setattr__", method: __setattr__, doc: nil)
      let __delattr__ = FunctionWrapper(name: "__delattr__", fn: PyObject.__delattr__(_:zelf:name:))
      self.add(py, type: type, name: "__delattr__", method: __delattr__, doc: nil)
      let __init_subclass__ = FunctionWrapper(name: "__init_subclass__", fn: PyObject.__init_subclass__(_:zelf:))
      self.add(py, type: type, name: "__init_subclass__", method: __init_subclass__, doc: nil)
    }

    internal static var objectStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = PyStaticCall.KnownNotOverriddenMethods()
      result.__repr__ = .init(PyObject.__repr__(_:zelf:))
      result.__str__ = .init(PyObject.__str__(_:zelf:))
      result.__hash__ = .init(PyObject.__hash__(_:zelf:))
      result.__dir__ = .init(PyObject.__dir__(_:zelf:))
      result.__eq__ = .init(PyObject.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyObject.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyObject.__lt__(_:zelf:other:))
      result.__le__ = .init(PyObject.__le__(_:zelf:other:))
      result.__gt__ = .init(PyObject.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyObject.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyObject.__getattribute__(_:zelf:name:))
      result.__setattr__ = .init(PyObject.__setattr__(_:zelf:name:value:))
      result.__delattr__ = .init(PyObject.__delattr__(_:zelf:name:))
      return result
    }()

    // MARK: - Property

    private func fillProperty(_ py: Py) {
      let type = self.property
      type.setBuiltinTypeDoc(py, value: PyProperty.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyProperty.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyProperty.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyProperty.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let fget = FunctionWrapper(name: "__get__", fn: PyProperty.fget(_:zelf:))
      self.add(py, type: type, name: "fget", property: fget, doc: nil)
      let fset = FunctionWrapper(name: "__get__", fn: PyProperty.fset(_:zelf:))
      self.add(py, type: type, name: "fset", property: fset, doc: nil)
      let fdel = FunctionWrapper(name: "__get__", fn: PyProperty.fdel(_:zelf:))
      self.add(py, type: type, name: "fdel", property: fdel, doc: nil)
      let __doc__Get = FunctionWrapper(name: "__get__", fn: PyProperty.__doc__(_:zelf:))
      let __doc__Set = FunctionWrapper(name: "__set__", fn: PyProperty.__doc__(_:zelf:value:))
      self.add(py, type: type, name: "__doc__", property: __doc__Get, setter: __doc__Set, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyProperty.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __get__ = FunctionWrapper(name: "__get__", fn: PyProperty.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
      let __set__ = FunctionWrapper(name: "__set__", fn: PyProperty.__set__(_:zelf:object:value:))
      self.add(py, type: type, name: "__set__", method: __set__, doc: nil)
      let __delete__ = FunctionWrapper(name: "__delete__", fn: PyProperty.__delete__(_:zelf:object:))
      self.add(py, type: type, name: "__delete__", method: __delete__, doc: nil)
      let getter = FunctionWrapper(name: "getter", fn: PyProperty.getter(_:zelf:value:))
      self.add(py, type: type, name: "getter", method: getter, doc: PyProperty.getterDoc)
      let setter = FunctionWrapper(name: "setter", fn: PyProperty.setter(_:zelf:value:))
      self.add(py, type: type, name: "setter", method: setter, doc: nil)
      let deleter = FunctionWrapper(name: "deleter", fn: PyProperty.deleter(_:zelf:value:))
      self.add(py, type: type, name: "deleter", method: deleter, doc: nil)
    }

    internal static var propertyStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyProperty.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - Range

    private func fillRange(_ py: Py) {
      let type = self.range
      type.setBuiltinTypeDoc(py, value: PyRange.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRange.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyRange.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let start = FunctionWrapper(name: "__get__", fn: PyRange.start(_:zelf:))
      self.add(py, type: type, name: "start", property: start, doc: nil)
      let stop = FunctionWrapper(name: "__get__", fn: PyRange.stop(_:zelf:))
      self.add(py, type: type, name: "stop", property: stop, doc: nil)
      let step = FunctionWrapper(name: "__get__", fn: PyRange.step(_:zelf:))
      self.add(py, type: type, name: "step", property: step, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyRange.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyRange.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyRange.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyRange.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyRange.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyRange.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyRange.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyRange.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __bool__ = FunctionWrapper(name: "__bool__", fn: PyRange.__bool__(_:zelf:))
      self.add(py, type: type, name: "__bool__", method: __bool__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyRange.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyRange.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyRange.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __getitem__ = FunctionWrapper(name: "__getitem__", fn: PyRange.__getitem__(_:zelf:index:))
      self.add(py, type: type, name: "__getitem__", method: __getitem__, doc: nil)
      let __reversed__ = FunctionWrapper(name: "__reversed__", fn: PyRange.__reversed__(_:zelf:))
      self.add(py, type: type, name: "__reversed__", method: __reversed__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyRange.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let count = FunctionWrapper(name: "count", fn: PyRange.count(_:zelf:object:))
      self.add(py, type: type, name: "count", method: count, doc: nil)
      let index = FunctionWrapper(name: "index", fn: PyRange.index(_:zelf:object:))
      self.add(py, type: type, name: "index", method: index, doc: nil)
      let __reduce__ = FunctionWrapper(name: "__reduce__", fn: PyRange.__reduce__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__reduce__", method: __reduce__, doc: nil)
    }

    internal static var rangeStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyRange.__repr__(_:zelf:))
      result.__hash__ = .init(PyRange.__hash__(_:zelf:))
      result.__eq__ = .init(PyRange.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyRange.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyRange.__lt__(_:zelf:other:))
      result.__le__ = .init(PyRange.__le__(_:zelf:other:))
      result.__gt__ = .init(PyRange.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyRange.__ge__(_:zelf:other:))
      result.__bool__ = .init(PyRange.__bool__(_:zelf:))
      result.__getattribute__ = .init(PyRange.__getattribute__(_:zelf:name:))
      result.__getitem__ = .init(PyRange.__getitem__(_:zelf:index:))
      result.__iter__ = .init(PyRange.__iter__(_:zelf:))
      result.__len__ = .init(PyRange.__len__(_:zelf:))
      result.__contains__ = .init(PyRange.__contains__(_:zelf:object:))
      result.__reversed__ = .init(PyRange.__reversed__(_:zelf:))
      return result
    }()

    // MARK: - RangeIterator

    private func fillRangeIterator(_ py: Py) {
      let type = self.range_iterator
      type.setBuiltinTypeDoc(py, value: PyRangeIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRangeIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyRangeIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyRangeIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyRangeIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyRangeIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyRangeIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var rangeIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyRangeIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyRangeIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyRangeIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - Reversed

    private func fillReversed(_ py: Py) {
      let type = self.reversed
      type.setBuiltinTypeDoc(py, value: PyReversed.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyReversed.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyReversed.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyReversed.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyReversed.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyReversed.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyReversed.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var reversedStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyReversed.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyReversed.__iter__(_:zelf:))
      result.__next__ = .init(PyReversed.__next__(_:zelf:))
      return result
    }()

    // MARK: - Set

    private func fillSet(_ py: Py) {
      let type = self.set
      type.setBuiltinTypeDoc(py, value: PySet.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySet.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySet.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySet.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PySet.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PySet.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PySet.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PySet.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PySet.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PySet.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PySet.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PySet.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PySet.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PySet.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PySet.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __and__ = FunctionWrapper(name: "__and__", fn: PySet.__and__(_:zelf:other:))
      self.add(py, type: type, name: "__and__", method: __and__, doc: nil)
      let __rand__ = FunctionWrapper(name: "__rand__", fn: PySet.__rand__(_:zelf:other:))
      self.add(py, type: type, name: "__rand__", method: __rand__, doc: nil)
      let __or__ = FunctionWrapper(name: "__or__", fn: PySet.__or__(_:zelf:other:))
      self.add(py, type: type, name: "__or__", method: __or__, doc: nil)
      let __ror__ = FunctionWrapper(name: "__ror__", fn: PySet.__ror__(_:zelf:other:))
      self.add(py, type: type, name: "__ror__", method: __ror__, doc: nil)
      let __xor__ = FunctionWrapper(name: "__xor__", fn: PySet.__xor__(_:zelf:other:))
      self.add(py, type: type, name: "__xor__", method: __xor__, doc: nil)
      let __rxor__ = FunctionWrapper(name: "__rxor__", fn: PySet.__rxor__(_:zelf:other:))
      self.add(py, type: type, name: "__rxor__", method: __rxor__, doc: nil)
      let __sub__ = FunctionWrapper(name: "__sub__", fn: PySet.__sub__(_:zelf:other:))
      self.add(py, type: type, name: "__sub__", method: __sub__, doc: nil)
      let __rsub__ = FunctionWrapper(name: "__rsub__", fn: PySet.__rsub__(_:zelf:other:))
      self.add(py, type: type, name: "__rsub__", method: __rsub__, doc: nil)
      let issubset = FunctionWrapper(name: "issubset", fn: PySet.issubset(_:zelf:other:))
      self.add(py, type: type, name: "issubset", method: issubset, doc: PySet.isSubsetDoc)
      let issuperset = FunctionWrapper(name: "issuperset", fn: PySet.issuperset(_:zelf:other:))
      self.add(py, type: type, name: "issuperset", method: issuperset, doc: PySet.isSupersetDoc)
      let isdisjoint = FunctionWrapper(name: "isdisjoint", fn: PySet.isdisjoint(_:zelf:other:))
      self.add(py, type: type, name: "isdisjoint", method: isdisjoint, doc: PySet.isDisjointDoc)
      let intersection = FunctionWrapper(name: "intersection", fn: PySet.intersection(_:zelf:other:))
      self.add(py, type: type, name: "intersection", method: intersection, doc: PySet.intersectionDoc)
      let union = FunctionWrapper(name: "union", fn: PySet.union(_:zelf:other:))
      self.add(py, type: type, name: "union", method: union, doc: PySet.unionDoc)
      let difference = FunctionWrapper(name: "difference", fn: PySet.difference(_:zelf:other:))
      self.add(py, type: type, name: "difference", method: difference, doc: PySet.differenceDoc)
      let symmetric_difference = FunctionWrapper(name: "symmetric_difference", fn: PySet.symmetric_difference(_:zelf:other:))
      self.add(py, type: type, name: "symmetric_difference", method: symmetric_difference, doc: PySet.symmetricDifferenceDoc)
      let add = FunctionWrapper(name: "add", fn: PySet.add(_:zelf:other:))
      self.add(py, type: type, name: "add", method: add, doc: PySet.addDoc)
      let update = FunctionWrapper(name: "update", fn: PySet.update(_:zelf:other:))
      self.add(py, type: type, name: "update", method: update, doc: PySet.updateDoc)
      let remove = FunctionWrapper(name: "remove", fn: PySet.remove(_:zelf:object:))
      self.add(py, type: type, name: "remove", method: remove, doc: PySet.removeDoc)
      let discard = FunctionWrapper(name: "discard", fn: PySet.discard(_:zelf:object:))
      self.add(py, type: type, name: "discard", method: discard, doc: PySet.discardDoc)
      let clear = FunctionWrapper(name: "clear", fn: PySet.clear(_:zelf:))
      self.add(py, type: type, name: "clear", method: clear, doc: PySet.clearDoc)
      let copy = FunctionWrapper(name: "copy", fn: PySet.copy(_:zelf:))
      self.add(py, type: type, name: "copy", method: copy, doc: PySet.copyDoc)
      let pop = FunctionWrapper(name: "pop", fn: PySet.pop(_:zelf:))
      self.add(py, type: type, name: "pop", method: pop, doc: PySet.popDoc)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PySet.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
    }

    internal static var setStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PySet.__repr__(_:zelf:))
      result.__hash__ = .init(PySet.__hash__(_:zelf:))
      result.__eq__ = .init(PySet.__eq__(_:zelf:other:))
      result.__ne__ = .init(PySet.__ne__(_:zelf:other:))
      result.__lt__ = .init(PySet.__lt__(_:zelf:other:))
      result.__le__ = .init(PySet.__le__(_:zelf:other:))
      result.__gt__ = .init(PySet.__gt__(_:zelf:other:))
      result.__ge__ = .init(PySet.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PySet.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PySet.__iter__(_:zelf:))
      result.__len__ = .init(PySet.__len__(_:zelf:))
      result.__contains__ = .init(PySet.__contains__(_:zelf:object:))
      result.__and__ = .init(PySet.__and__(_:zelf:other:))
      result.__or__ = .init(PySet.__or__(_:zelf:other:))
      result.__sub__ = .init(PySet.__sub__(_:zelf:other:))
      result.__xor__ = .init(PySet.__xor__(_:zelf:other:))
      result.__rand__ = .init(PySet.__rand__(_:zelf:other:))
      result.__ror__ = .init(PySet.__ror__(_:zelf:other:))
      result.__rsub__ = .init(PySet.__rsub__(_:zelf:other:))
      result.__rxor__ = .init(PySet.__rxor__(_:zelf:other:))
      return result
    }()

    // MARK: - SetIterator

    private func fillSetIterator(_ py: Py) {
      let type = self.set_iterator
      type.setBuiltinTypeDoc(py, value: PySetIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySetIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySetIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PySetIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PySetIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PySetIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PySetIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var setIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PySetIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PySetIterator.__iter__(_:zelf:))
      result.__next__ = .init(PySetIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - Slice

    private func fillSlice(_ py: Py) {
      let type = self.slice
      type.setBuiltinTypeDoc(py, value: PySlice.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySlice.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySlice.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let start = FunctionWrapper(name: "__get__", fn: PySlice.start(_:zelf:))
      self.add(py, type: type, name: "start", property: start, doc: nil)
      let stop = FunctionWrapper(name: "__get__", fn: PySlice.stop(_:zelf:))
      self.add(py, type: type, name: "stop", property: stop, doc: nil)
      let step = FunctionWrapper(name: "__get__", fn: PySlice.step(_:zelf:))
      self.add(py, type: type, name: "step", property: step, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PySlice.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PySlice.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PySlice.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PySlice.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PySlice.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PySlice.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PySlice.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PySlice.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PySlice.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let indices = FunctionWrapper(name: "indices", fn: PySlice.indices(_:zelf:length:))
      self.add(py, type: type, name: "indices", method: indices, doc: nil)
    }

    internal static var sliceStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PySlice.__repr__(_:zelf:))
      result.__hash__ = .init(PySlice.__hash__(_:zelf:))
      result.__eq__ = .init(PySlice.__eq__(_:zelf:other:))
      result.__ne__ = .init(PySlice.__ne__(_:zelf:other:))
      result.__lt__ = .init(PySlice.__lt__(_:zelf:other:))
      result.__le__ = .init(PySlice.__le__(_:zelf:other:))
      result.__gt__ = .init(PySlice.__gt__(_:zelf:other:))
      result.__ge__ = .init(PySlice.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PySlice.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - StaticMethod

    private func fillStaticMethod(_ py: Py) {
      let type = self.staticmethod
      type.setBuiltinTypeDoc(py, value: PyStaticMethod.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyStaticMethod.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyStaticMethod.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyStaticMethod.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyStaticMethod.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let __func__ = FunctionWrapper(name: "__get__", fn: PyStaticMethod.__func__(_:zelf:))
      self.add(py, type: type, name: "__func__", property: __func__, doc: nil)

      let __get__ = FunctionWrapper(name: "__get__", fn: PyStaticMethod.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
      let __isabstractmethod__ = FunctionWrapper(name: "__isabstractmethod__", fn: PyStaticMethod.__isabstractmethod__(_:zelf:))
      self.add(py, type: type, name: "__isabstractmethod__", method: __isabstractmethod__, doc: nil)
    }

    internal static var staticMethodStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__isabstractmethod__ = .init(PyStaticMethod.__isabstractmethod__(_:zelf:))
      return result
    }()

    // MARK: - String

    private func fillString(_ py: Py) {
      let type = self.str
      type.setBuiltinTypeDoc(py, value: PyString.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyString.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyString.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyString.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyString.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyString.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyString.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyString.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyString.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyString.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyString.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyString.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyString.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyString.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyString.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let __getitem__ = FunctionWrapper(name: "__getitem__", fn: PyString.__getitem__(_:zelf:index:))
      self.add(py, type: type, name: "__getitem__", method: __getitem__, doc: nil)
      let isalnum = FunctionWrapper(name: "isalnum", fn: PyString.isalnum(_:zelf:))
      self.add(py, type: type, name: "isalnum", method: isalnum, doc: PyString.isalnumDoc)
      let isalpha = FunctionWrapper(name: "isalpha", fn: PyString.isalpha(_:zelf:))
      self.add(py, type: type, name: "isalpha", method: isalpha, doc: PyString.isalphaDoc)
      let isascii = FunctionWrapper(name: "isascii", fn: PyString.isascii(_:zelf:))
      self.add(py, type: type, name: "isascii", method: isascii, doc: PyString.isasciiDoc)
      let isdecimal = FunctionWrapper(name: "isdecimal", fn: PyString.isdecimal(_:zelf:))
      self.add(py, type: type, name: "isdecimal", method: isdecimal, doc: PyString.isdecimalDoc)
      let isdigit = FunctionWrapper(name: "isdigit", fn: PyString.isdigit(_:zelf:))
      self.add(py, type: type, name: "isdigit", method: isdigit, doc: PyString.isdigitDoc)
      let isidentifier = FunctionWrapper(name: "isidentifier", fn: PyString.isidentifier(_:zelf:))
      self.add(py, type: type, name: "isidentifier", method: isidentifier, doc: PyString.isidentifierDoc)
      let islower = FunctionWrapper(name: "islower", fn: PyString.islower(_:zelf:))
      self.add(py, type: type, name: "islower", method: islower, doc: PyString.islowerDoc)
      let isnumeric = FunctionWrapper(name: "isnumeric", fn: PyString.isnumeric(_:zelf:))
      self.add(py, type: type, name: "isnumeric", method: isnumeric, doc: PyString.isnumericDoc)
      let isprintable = FunctionWrapper(name: "isprintable", fn: PyString.isprintable(_:zelf:))
      self.add(py, type: type, name: "isprintable", method: isprintable, doc: PyString.isprintableDoc)
      let isspace = FunctionWrapper(name: "isspace", fn: PyString.isspace(_:zelf:))
      self.add(py, type: type, name: "isspace", method: isspace, doc: PyString.isspaceDoc)
      let istitle = FunctionWrapper(name: "istitle", fn: PyString.istitle(_:zelf:))
      self.add(py, type: type, name: "istitle", method: istitle, doc: PyString.istitleDoc)
      let isupper = FunctionWrapper(name: "isupper", fn: PyString.isupper(_:zelf:))
      self.add(py, type: type, name: "isupper", method: isupper, doc: PyString.isupperDoc)
      let startswith = FunctionWrapper(name: "startswith", fn: PyString.startswith(_:zelf:prefix:start:end:))
      self.add(py, type: type, name: "startswith", method: startswith, doc: PyString.startswithDoc)
      let endswith = FunctionWrapper(name: "endswith", fn: PyString.endswith(_:zelf:suffix:start:end:))
      self.add(py, type: type, name: "endswith", method: endswith, doc: PyString.endswithDoc)
      let strip = FunctionWrapper(name: "strip", fn: PyString.strip(_:zelf:chars:))
      self.add(py, type: type, name: "strip", method: strip, doc: PyString.stripDoc)
      let lstrip = FunctionWrapper(name: "lstrip", fn: PyString.lstrip(_:zelf:chars:))
      self.add(py, type: type, name: "lstrip", method: lstrip, doc: PyString.lstripDoc)
      let rstrip = FunctionWrapper(name: "rstrip", fn: PyString.rstrip(_:zelf:chars:))
      self.add(py, type: type, name: "rstrip", method: rstrip, doc: PyString.rstripDoc)
      let find = FunctionWrapper(name: "find", fn: PyString.find(_:zelf:object:start:end:))
      self.add(py, type: type, name: "find", method: find, doc: PyString.findDoc)
      let rfind = FunctionWrapper(name: "rfind", fn: PyString.rfind(_:zelf:object:start:end:))
      self.add(py, type: type, name: "rfind", method: rfind, doc: PyString.rfindDoc)
      let index = FunctionWrapper(name: "index", fn: PyString.index(_:zelf:object:start:end:))
      self.add(py, type: type, name: "index", method: index, doc: PyString.indexDoc)
      let rindex = FunctionWrapper(name: "rindex", fn: PyString.rindex(_:zelf:object:start:end:))
      self.add(py, type: type, name: "rindex", method: rindex, doc: PyString.rindexDoc)
      let lower = FunctionWrapper(name: "lower", fn: PyString.lower(_:zelf:))
      self.add(py, type: type, name: "lower", method: lower, doc: nil)
      let upper = FunctionWrapper(name: "upper", fn: PyString.upper(_:zelf:))
      self.add(py, type: type, name: "upper", method: upper, doc: nil)
      let title = FunctionWrapper(name: "title", fn: PyString.title(_:zelf:))
      self.add(py, type: type, name: "title", method: title, doc: nil)
      let swapcase = FunctionWrapper(name: "swapcase", fn: PyString.swapcase(_:zelf:))
      self.add(py, type: type, name: "swapcase", method: swapcase, doc: nil)
      let capitalize = FunctionWrapper(name: "capitalize", fn: PyString.capitalize(_:zelf:))
      self.add(py, type: type, name: "capitalize", method: capitalize, doc: nil)
      let casefold = FunctionWrapper(name: "casefold", fn: PyString.casefold(_:zelf:))
      self.add(py, type: type, name: "casefold", method: casefold, doc: nil)
      let center = FunctionWrapper(name: "center", fn: PyString.center(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "center", method: center, doc: nil)
      let ljust = FunctionWrapper(name: "ljust", fn: PyString.ljust(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "ljust", method: ljust, doc: nil)
      let rjust = FunctionWrapper(name: "rjust", fn: PyString.rjust(_:zelf:width:fillChar:))
      self.add(py, type: type, name: "rjust", method: rjust, doc: nil)
      let split = FunctionWrapper(name: "split", fn: PyString.split(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "split", method: split, doc: nil)
      let rsplit = FunctionWrapper(name: "rsplit", fn: PyString.rsplit(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "rsplit", method: rsplit, doc: nil)
      let splitlines = FunctionWrapper(name: "splitlines", fn: PyString.splitlines(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "splitlines", method: splitlines, doc: nil)
      let partition = FunctionWrapper(name: "partition", fn: PyString.partition(_:zelf:separator:))
      self.add(py, type: type, name: "partition", method: partition, doc: nil)
      let rpartition = FunctionWrapper(name: "rpartition", fn: PyString.rpartition(_:zelf:separator:))
      self.add(py, type: type, name: "rpartition", method: rpartition, doc: nil)
      let expandtabs = FunctionWrapper(name: "expandtabs", fn: PyString.expandtabs(_:zelf:tabSize:))
      self.add(py, type: type, name: "expandtabs", method: expandtabs, doc: nil)
      let count = FunctionWrapper(name: "count", fn: PyString.count(_:zelf:object:start:end:))
      self.add(py, type: type, name: "count", method: count, doc: PyString.countDoc)
      let join = FunctionWrapper(name: "join", fn: PyString.join(_:zelf:iterable:))
      self.add(py, type: type, name: "join", method: join, doc: nil)
      let replace = FunctionWrapper(name: "replace", fn: PyString.replace(_:zelf:old:new:count:))
      self.add(py, type: type, name: "replace", method: replace, doc: nil)
      let zfill = FunctionWrapper(name: "zfill", fn: PyString.zfill(_:zelf:width:))
      self.add(py, type: type, name: "zfill", method: zfill, doc: nil)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyString.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyString.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyString.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyString.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
    }

    internal static var stringStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyString.__repr__(_:zelf:))
      result.__str__ = .init(PyString.__str__(_:zelf:))
      result.__hash__ = .init(PyString.__hash__(_:zelf:))
      result.__eq__ = .init(PyString.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyString.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyString.__lt__(_:zelf:other:))
      result.__le__ = .init(PyString.__le__(_:zelf:other:))
      result.__gt__ = .init(PyString.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyString.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyString.__getattribute__(_:zelf:name:))
      result.__getitem__ = .init(PyString.__getitem__(_:zelf:index:))
      result.__iter__ = .init(PyString.__iter__(_:zelf:))
      result.__len__ = .init(PyString.__len__(_:zelf:))
      result.__contains__ = .init(PyString.__contains__(_:zelf:object:))
      result.__add__ = .init(PyString.__add__(_:zelf:other:))
      result.__mul__ = .init(PyString.__mul__(_:zelf:other:))
      result.__rmul__ = .init(PyString.__rmul__(_:zelf:other:))
      return result
    }()

    // MARK: - StringIterator

    private func fillStringIterator(_ py: Py) {
      let type = self.str_iterator
      type.setBuiltinTypeDoc(py, value: PyStringIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyStringIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyStringIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyStringIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyStringIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyStringIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyStringIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var stringIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyStringIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyStringIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyStringIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - Super

    private func fillSuper(_ py: Py) {
      let type = self.super
      type.setBuiltinTypeDoc(py, value: PySuper.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySuper.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySuper.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySuper.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __thisclass__ = FunctionWrapper(name: "__get__", fn: PySuper.__thisclass__(_:zelf:))
      self.add(py, type: type, name: "__thisclass__", property: __thisclass__, doc: nil)
      let __self__ = FunctionWrapper(name: "__get__", fn: PySuper.__self__(_:zelf:))
      self.add(py, type: type, name: "__self__", property: __self__, doc: nil)
      let __self_class__ = FunctionWrapper(name: "__get__", fn: PySuper.__self_class__(_:zelf:))
      self.add(py, type: type, name: "__self_class__", property: __self_class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PySuper.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PySuper.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __get__ = FunctionWrapper(name: "__get__", fn: PySuper.__get__(_:zelf:object:type:))
      self.add(py, type: type, name: "__get__", method: __get__, doc: nil)
    }

    internal static var superStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PySuper.__repr__(_:zelf:))
      result.__getattribute__ = .init(PySuper.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - TextFile

    private func fillTextFile(_ py: Py) {
      let type = self.textFile
      type.setBuiltinTypeDoc(py, value: PyTextFile.doc)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyTextFile.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyTextFile.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let readable = FunctionWrapper(name: "readable", fn: PyTextFile.readable(_:zelf:))
      self.add(py, type: type, name: "readable", method: readable, doc: nil)
      let readline = FunctionWrapper(name: "readline", fn: PyTextFile.readline(_:zelf:))
      self.add(py, type: type, name: "readline", method: readline, doc: nil)
      let read = FunctionWrapper(name: "read", fn: PyTextFile.read(_:zelf:size:))
      self.add(py, type: type, name: "read", method: read, doc: nil)
      let writable = FunctionWrapper(name: "writable", fn: PyTextFile.writable(_:zelf:))
      self.add(py, type: type, name: "writable", method: writable, doc: nil)
      let write = FunctionWrapper(name: "write", fn: PyTextFile.write(_:zelf:object:))
      self.add(py, type: type, name: "write", method: write, doc: nil)
      let flush = FunctionWrapper(name: "flush", fn: PyTextFile.flush(_:zelf:))
      self.add(py, type: type, name: "flush", method: flush, doc: nil)
      let closed = FunctionWrapper(name: "closed", fn: PyTextFile.closed(_:zelf:))
      self.add(py, type: type, name: "closed", method: closed, doc: nil)
      let close = FunctionWrapper(name: "close", fn: PyTextFile.close(_:zelf:))
      self.add(py, type: type, name: "close", method: close, doc: nil)
      let __del__ = FunctionWrapper(name: "__del__", fn: PyTextFile.__del__(_:zelf:))
      self.add(py, type: type, name: "__del__", method: __del__, doc: nil)
      let __enter__ = FunctionWrapper(name: "__enter__", fn: PyTextFile.__enter__(_:zelf:))
      self.add(py, type: type, name: "__enter__", method: __enter__, doc: nil)
      let __exit__ = FunctionWrapper(name: "__exit__", fn: PyTextFile.__exit__(_:zelf:exceptionType:exception:traceback:))
      self.add(py, type: type, name: "__exit__", method: __exit__, doc: nil)
    }

    internal static var textFileStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyTextFile.__repr__(_:zelf:))
      result.__del__ = .init(PyTextFile.__del__(_:zelf:))
      return result
    }()

    // MARK: - Traceback

    private func fillTraceback(_ py: Py) {
      let type = self.traceback
      type.setBuiltinTypeDoc(py, value: PyTraceback.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTraceback.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyTraceback.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let tb_frame = FunctionWrapper(name: "__get__", fn: PyTraceback.tb_frame(_:zelf:))
      self.add(py, type: type, name: "tb_frame", property: tb_frame, doc: nil)
      let tb_lasti = FunctionWrapper(name: "__get__", fn: PyTraceback.tb_lasti(_:zelf:))
      self.add(py, type: type, name: "tb_lasti", property: tb_lasti, doc: nil)
      let tb_lineno = FunctionWrapper(name: "__get__", fn: PyTraceback.tb_lineno(_:zelf:))
      self.add(py, type: type, name: "tb_lineno", property: tb_lineno, doc: nil)
      let tb_nextGet = FunctionWrapper(name: "__get__", fn: PyTraceback.tb_next(_:zelf:))
      let tb_nextSet = FunctionWrapper(name: "__set__", fn: PyTraceback.tb_next(_:zelf:value:))
      self.add(py, type: type, name: "tb_next", property: tb_nextGet, setter: tb_nextSet, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyTraceback.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __dir__ = FunctionWrapper(name: "__dir__", fn: PyTraceback.__dir__(_:zelf:))
      self.add(py, type: type, name: "__dir__", method: __dir__, doc: nil)
    }

    internal static var tracebackStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__dir__ = .init(PyTraceback.__dir__(_:zelf:))
      result.__getattribute__ = .init(PyTraceback.__getattribute__(_:zelf:name:))
      return result
    }()

    // MARK: - Tuple

    private func fillTuple(_ py: Py) {
      let type = self.tuple
      type.setBuiltinTypeDoc(py, value: PyTuple.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTuple.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyTuple.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __eq__ = FunctionWrapper(name: "__eq__", fn: PyTuple.__eq__(_:zelf:other:))
      self.add(py, type: type, name: "__eq__", method: __eq__, doc: nil)
      let __ne__ = FunctionWrapper(name: "__ne__", fn: PyTuple.__ne__(_:zelf:other:))
      self.add(py, type: type, name: "__ne__", method: __ne__, doc: nil)
      let __lt__ = FunctionWrapper(name: "__lt__", fn: PyTuple.__lt__(_:zelf:other:))
      self.add(py, type: type, name: "__lt__", method: __lt__, doc: nil)
      let __le__ = FunctionWrapper(name: "__le__", fn: PyTuple.__le__(_:zelf:other:))
      self.add(py, type: type, name: "__le__", method: __le__, doc: nil)
      let __gt__ = FunctionWrapper(name: "__gt__", fn: PyTuple.__gt__(_:zelf:other:))
      self.add(py, type: type, name: "__gt__", method: __gt__, doc: nil)
      let __ge__ = FunctionWrapper(name: "__ge__", fn: PyTuple.__ge__(_:zelf:other:))
      self.add(py, type: type, name: "__ge__", method: __ge__, doc: nil)
      let __hash__ = FunctionWrapper(name: "__hash__", fn: PyTuple.__hash__(_:zelf:))
      self.add(py, type: type, name: "__hash__", method: __hash__, doc: nil)
      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyTuple.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyTuple.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __len__ = FunctionWrapper(name: "__len__", fn: PyTuple.__len__(_:zelf:))
      self.add(py, type: type, name: "__len__", method: __len__, doc: nil)
      let __contains__ = FunctionWrapper(name: "__contains__", fn: PyTuple.__contains__(_:zelf:object:))
      self.add(py, type: type, name: "__contains__", method: __contains__, doc: nil)
      let count = FunctionWrapper(name: "count", fn: PyTuple.count(_:zelf:object:))
      self.add(py, type: type, name: "count", method: count, doc: nil)
      let index = FunctionWrapper(name: "index", fn: PyTuple.index(_:zelf:object:start:end:))
      self.add(py, type: type, name: "index", method: index, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyTuple.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __getitem__ = FunctionWrapper(name: "__getitem__", fn: PyTuple.__getitem__(_:zelf:index:))
      self.add(py, type: type, name: "__getitem__", method: __getitem__, doc: nil)
      let __add__ = FunctionWrapper(name: "__add__", fn: PyTuple.__add__(_:zelf:other:))
      self.add(py, type: type, name: "__add__", method: __add__, doc: nil)
      let __mul__ = FunctionWrapper(name: "__mul__", fn: PyTuple.__mul__(_:zelf:other:))
      self.add(py, type: type, name: "__mul__", method: __mul__, doc: nil)
      let __rmul__ = FunctionWrapper(name: "__rmul__", fn: PyTuple.__rmul__(_:zelf:other:))
      self.add(py, type: type, name: "__rmul__", method: __rmul__, doc: nil)
    }

    internal static var tupleStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyTuple.__repr__(_:zelf:))
      result.__hash__ = .init(PyTuple.__hash__(_:zelf:))
      result.__eq__ = .init(PyTuple.__eq__(_:zelf:other:))
      result.__ne__ = .init(PyTuple.__ne__(_:zelf:other:))
      result.__lt__ = .init(PyTuple.__lt__(_:zelf:other:))
      result.__le__ = .init(PyTuple.__le__(_:zelf:other:))
      result.__gt__ = .init(PyTuple.__gt__(_:zelf:other:))
      result.__ge__ = .init(PyTuple.__ge__(_:zelf:other:))
      result.__getattribute__ = .init(PyTuple.__getattribute__(_:zelf:name:))
      result.__getitem__ = .init(PyTuple.__getitem__(_:zelf:index:))
      result.__iter__ = .init(PyTuple.__iter__(_:zelf:))
      result.__len__ = .init(PyTuple.__len__(_:zelf:))
      result.__contains__ = .init(PyTuple.__contains__(_:zelf:object:))
      result.__add__ = .init(PyTuple.__add__(_:zelf:other:))
      result.__mul__ = .init(PyTuple.__mul__(_:zelf:other:))
      result.__rmul__ = .init(PyTuple.__rmul__(_:zelf:other:))
      return result
    }()

    // MARK: - TupleIterator

    private func fillTupleIterator(_ py: Py) {
      let type = self.tuple_iterator
      type.setBuiltinTypeDoc(py, value: PyTupleIterator.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTupleIterator.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyTupleIterator.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyTupleIterator.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyTupleIterator.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyTupleIterator.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
      let __length_hint__ = FunctionWrapper(name: "__length_hint__", fn: PyTupleIterator.__length_hint__(_:zelf:))
      self.add(py, type: type, name: "__length_hint__", method: __length_hint__, doc: nil)
    }

    internal static var tupleIteratorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyTupleIterator.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyTupleIterator.__iter__(_:zelf:))
      result.__next__ = .init(PyTupleIterator.__next__(_:zelf:))
      return result
    }()

    // MARK: - Type

    private func fillType(_ py: Py) {
      let type = self.type
      type.setBuiltinTypeDoc(py, value: PyType.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyType.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyType.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __name__Get = FunctionWrapper(name: "__get__", fn: PyType.__name__(_:zelf:))
      let __name__Set = FunctionWrapper(name: "__set__", fn: PyType.__name__(_:zelf:value:))
      self.add(py, type: type, name: "__name__", property: __name__Get, setter: __name__Set, doc: nil)
      let __qualname__Get = FunctionWrapper(name: "__get__", fn: PyType.__qualname__(_:zelf:))
      let __qualname__Set = FunctionWrapper(name: "__set__", fn: PyType.__qualname__(_:zelf:value:))
      self.add(py, type: type, name: "__qualname__", property: __qualname__Get, setter: __qualname__Set, doc: nil)
      let __doc__Get = FunctionWrapper(name: "__get__", fn: PyType.__doc__(_:zelf:))
      let __doc__Set = FunctionWrapper(name: "__set__", fn: PyType.__doc__(_:zelf:value:))
      self.add(py, type: type, name: "__doc__", property: __doc__Get, setter: __doc__Set, doc: nil)
      let __module__Get = FunctionWrapper(name: "__get__", fn: PyType.__module__(_:zelf:))
      let __module__Set = FunctionWrapper(name: "__set__", fn: PyType.__module__(_:zelf:value:))
      self.add(py, type: type, name: "__module__", property: __module__Get, setter: __module__Set, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyType.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let __class__ = FunctionWrapper(name: "__get__", fn: PyType.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __base__ = FunctionWrapper(name: "__get__", fn: PyType.__base__(_:zelf:))
      self.add(py, type: type, name: "__base__", property: __base__, doc: nil)
      let __bases__Get = FunctionWrapper(name: "__get__", fn: PyType.__bases__(_:zelf:))
      let __bases__Set = FunctionWrapper(name: "__set__", fn: PyType.__bases__(_:zelf:value:))
      self.add(py, type: type, name: "__bases__", property: __bases__Get, setter: __bases__Set, doc: nil)
      let __mro__ = FunctionWrapper(name: "__get__", fn: PyType.__mro__(_:zelf:))
      self.add(py, type: type, name: "__mro__", property: __mro__, doc: nil)

      let __prepare__ = FunctionWrapper(name: "__prepare__", fn: PyType.__prepare__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__prepare__", classMethod: __prepare__, doc: PyType.prepareDoc)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyType.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let mro = FunctionWrapper(name: "mro", fn: PyType.mro(_:zelf:))
      self.add(py, type: type, name: "mro", method: mro, doc: PyType.mroDoc)
      let __subclasscheck__ = FunctionWrapper(name: "__subclasscheck__", fn: PyType.__subclasscheck__(_:zelf:object:))
      self.add(py, type: type, name: "__subclasscheck__", method: __subclasscheck__, doc: nil)
      let __instancecheck__ = FunctionWrapper(name: "__instancecheck__", fn: PyType.__instancecheck__(_:zelf:object:))
      self.add(py, type: type, name: "__instancecheck__", method: __instancecheck__, doc: nil)
      let __subclasses__ = FunctionWrapper(name: "__subclasses__", fn: PyType.__subclasses__(_:zelf:))
      self.add(py, type: type, name: "__subclasses__", method: __subclasses__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyType.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __setattr__ = FunctionWrapper(name: "__setattr__", fn: PyType.__setattr__(_:zelf:name:value:))
      self.add(py, type: type, name: "__setattr__", method: __setattr__, doc: nil)
      let __delattr__ = FunctionWrapper(name: "__delattr__", fn: PyType.__delattr__(_:zelf:name:))
      self.add(py, type: type, name: "__delattr__", method: __delattr__, doc: nil)
      let __dir__ = FunctionWrapper(name: "__dir__", fn: PyType.__dir__(_:zelf:))
      self.add(py, type: type, name: "__dir__", method: __dir__, doc: nil)
      let __call__ = FunctionWrapper(name: "__call__", fn: PyType.__call__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__call__", method: __call__, doc: nil)
    }

    internal static var typeStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyType.__repr__(_:zelf:))
      result.__dir__ = .init(PyType.__dir__(_:zelf:))
      result.__getattribute__ = .init(PyType.__getattribute__(_:zelf:name:))
      result.__setattr__ = .init(PyType.__setattr__(_:zelf:name:value:))
      result.__delattr__ = .init(PyType.__delattr__(_:zelf:name:))
      result.__call__ = .init(PyType.__call__(_:zelf:args:kwargs:))
      result.__instancecheck__ = .init(PyType.__instancecheck__(_:zelf:object:))
      result.__subclasscheck__ = .init(PyType.__subclasscheck__(_:zelf:object:))
      return result
    }()

    // MARK: - Zip

    private func fillZip(_ py: Py) {
      let type = self.zip
      type.setBuiltinTypeDoc(py, value: PyZip.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyZip.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyZip.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)

      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyZip.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __iter__ = FunctionWrapper(name: "__iter__", fn: PyZip.__iter__(_:zelf:))
      self.add(py, type: type, name: "__iter__", method: __iter__, doc: nil)
      let __next__ = FunctionWrapper(name: "__next__", fn: PyZip.__next__(_:zelf:))
      self.add(py, type: type, name: "__next__", method: __next__, doc: nil)
    }

    internal static var zipStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__getattribute__ = .init(PyZip.__getattribute__(_:zelf:name:))
      result.__iter__ = .init(PyZip.__iter__(_:zelf:))
      result.__next__ = .init(PyZip.__next__(_:zelf:))
      return result
    }()

  }
}
