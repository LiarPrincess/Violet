// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable function_body_length



extension TypeFactory {

  // MARK: - Base object

  /// Create `object` type without assigning `type` property.
  internal static func objectWithoutType(_ context: PyContext) -> PyType {
    let result = PyType.initObjectType(context, name: "object", doc: PyBaseObject.doc)
    result.setFlag(.default)
    result.setFlag(.baseType)

    let dict = result.getDict()

    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyBaseObject.isEqual(zelf:other:))
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyBaseObject.isNotEqual(zelf:other:))
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyBaseObject.isLess(zelf:other:))
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyBaseObject.isLessEqual(zelf:other:))
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyBaseObject.isGreater(zelf:other:))
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyBaseObject.isGreaterEqual(zelf:other:))
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyBaseObject.hash(zelf:))
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyBaseObject.repr(zelf:))
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyBaseObject.str(zelf:))
    dict["__format__"] = wrapMethod(context, name: "__format__", doc: nil, fn: PyBaseObject.format(zelf:spec:))
    dict["__class__"] = wrapMethod(context, name: "__class__", doc: nil, fn: PyBaseObject.getClass(zelf:))
    dict["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, fn: PyBaseObject.dir(zelf:))
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyBaseObject.getAttribute(zelf:name:))
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyBaseObject.setAttribute(zelf:name:value:))
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyBaseObject.delAttribute(zelf:name:))
    dict["__subclasshook__"] = wrapMethod(context, name: "__subclasshook__", doc: nil, fn: PyBaseObject.subclasshook(zelf:))
    dict["__init_subclass__"] = wrapMethod(context, name: "__init_subclass__", doc: nil, fn: PyBaseObject.initSubclass(zelf:))
    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBaseObject.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyBaseObject.pyInit(zelf:args:kwargs:))


    return result
  }

  // MARK: - Type type

  /// Create `type` type without assigning `type` property.
  internal static func typeWithoutType(_ context: PyContext, base: PyType) -> PyType {
    let result = PyType.initTypeType(context, name: "type", doc: PyType.doc, objectType: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)
    result.setFlag(.typeSubclass)

    let dict = result.getDict()
    dict["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyType.getName, set: PyType.setName, castSelf: Cast.asPyType)
    dict["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyType.getQualname, set: PyType.setQualname, castSelf: Cast.asPyType)
    dict["__doc__"] = createProperty(context, name: "__doc__", doc: nil, get: PyType.getDoc, set: PyType.setDoc, castSelf: Cast.asPyType)
    dict["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyType.getModule, set: PyType.setModule, castSelf: Cast.asPyType)
    dict["__bases__"] = createProperty(context, name: "__bases__", doc: nil, get: PyType.getBases, set: PyType.setBases, castSelf: Cast.asPyType)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyType.getDict, castSelf: Cast.asPyType)
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyType.getClass, castSelf: Cast.asPyType)
    dict["__base__"] = createProperty(context, name: "__base__", doc: nil, get: PyType.getBase, castSelf: Cast.asPyType)
    dict["__mro__"] = createProperty(context, name: "__mro__", doc: nil, get: PyType.getMRO, castSelf: Cast.asPyType)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyType.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyType.pyInit(zelf:args:kwargs:))


    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyType.repr, castSelf: Cast.asPyType)
    dict["__subclasses__"] = wrapMethod(context, name: "__subclasses__", doc: nil, fn: PyType.getSubclasses, castSelf: Cast.asPyType)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyType.getAttribute(name:), castSelf: Cast.asPyType)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyType.setAttribute(name:value:), castSelf: Cast.asPyType)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyType.delAttribute(name:), castSelf: Cast.asPyType)
    dict["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, fn: PyType.dir, castSelf: Cast.asPyType)
    dict["__call__"] = wrapMethod(context, name: "__call__", doc: nil, fn: PyType.call(args:kwargs:), castSelf: Cast.asPyType)
    return result
  }

  // MARK: - Bool

  internal static func bool(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "bool", doc: PyBool.doc, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBool.getClass, castSelf: Cast.asPyBool)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBool.pyNew(type:args:kwargs:))

    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyBool.repr, castSelf: Cast.asPyBool)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyBool.str, castSelf: Cast.asPyBool)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PyBool.and(_:), castSelf: Cast.asPyBool)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PyBool.rand(_:), castSelf: Cast.asPyBool)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PyBool.or(_:), castSelf: Cast.asPyBool)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PyBool.ror(_:), castSelf: Cast.asPyBool)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PyBool.xor(_:), castSelf: Cast.asPyBool)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PyBool.rxor(_:), castSelf: Cast.asPyBool)
    return result
  }

  // MARK: - BuiltinFunction

  internal static func builtinFunction(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "builtinFunction", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBuiltinFunction.getClass, castSelf: Cast.asPyBuiltinFunction)
    dict["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyBuiltinFunction.getName, castSelf: Cast.asPyBuiltinFunction)
    dict["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyBuiltinFunction.getQualname, castSelf: Cast.asPyBuiltinFunction)
    dict["__text_signature__"] = createProperty(context, name: "__text_signature__", doc: nil, get: PyBuiltinFunction.getTextSignature, castSelf: Cast.asPyBuiltinFunction)
    dict["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyBuiltinFunction.getModule, castSelf: Cast.asPyBuiltinFunction)
    dict["__self__"] = createProperty(context, name: "__self__", doc: nil, get: PyBuiltinFunction.getSelf, castSelf: Cast.asPyBuiltinFunction)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyBuiltinFunction.isEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyBuiltinFunction.isNotEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyBuiltinFunction.isLess(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyBuiltinFunction.isLessEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyBuiltinFunction.isGreater(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyBuiltinFunction.isGreaterEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyBuiltinFunction.hash, castSelf: Cast.asPyBuiltinFunction)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyBuiltinFunction.repr, castSelf: Cast.asPyBuiltinFunction)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyBuiltinFunction.getAttribute(name:), castSelf: Cast.asPyBuiltinFunction)
    dict["__call__"] = wrapMethod(context, name: "__call__", doc: nil, fn: PyBuiltinFunction.call(args:kwargs:), castSelf: Cast.asPyBuiltinFunction)
    return result
  }

  // MARK: - Code

  internal static func code(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "code", doc: PyCode.doc, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyCode.getClass, castSelf: Cast.asPyCode)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyCode.isEqual(_:), castSelf: Cast.asPyCode)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyCode.isLess(_:), castSelf: Cast.asPyCode)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyCode.isLessEqual(_:), castSelf: Cast.asPyCode)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyCode.isGreater(_:), castSelf: Cast.asPyCode)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyCode.isGreaterEqual(_:), castSelf: Cast.asPyCode)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyCode.hash, castSelf: Cast.asPyCode)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyCode.repr, castSelf: Cast.asPyCode)
    return result
  }

  // MARK: - Complex

  internal static func complex(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "complex", doc: PyComplex.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyComplex.getClass, castSelf: Cast.asPyComplex)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyComplex.pyNew(type:args:kwargs:))

    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyComplex.isEqual(_:), castSelf: Cast.asPyComplex)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyComplex.isNotEqual(_:), castSelf: Cast.asPyComplex)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyComplex.isLess(_:), castSelf: Cast.asPyComplex)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyComplex.isLessEqual(_:), castSelf: Cast.asPyComplex)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyComplex.isGreater(_:), castSelf: Cast.asPyComplex)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyComplex.isGreaterEqual(_:), castSelf: Cast.asPyComplex)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyComplex.hash, castSelf: Cast.asPyComplex)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyComplex.repr, castSelf: Cast.asPyComplex)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyComplex.str, castSelf: Cast.asPyComplex)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyComplex.asBool, castSelf: Cast.asPyComplex)
    dict["__int__"] = wrapMethod(context, name: "__int__", doc: nil, fn: PyComplex.asInt, castSelf: Cast.asPyComplex)
    dict["__float__"] = wrapMethod(context, name: "__float__", doc: nil, fn: PyComplex.asFloat, castSelf: Cast.asPyComplex)
    dict["real"] = wrapMethod(context, name: "real", doc: nil, fn: PyComplex.asReal, castSelf: Cast.asPyComplex)
    dict["imag"] = wrapMethod(context, name: "imag", doc: nil, fn: PyComplex.asImag, castSelf: Cast.asPyComplex)
    dict["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, fn: PyComplex.conjugate, castSelf: Cast.asPyComplex)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyComplex.getAttribute(name:), castSelf: Cast.asPyComplex)
    dict["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, fn: PyComplex.positive, castSelf: Cast.asPyComplex)
    dict["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, fn: PyComplex.negative, castSelf: Cast.asPyComplex)
    dict["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, fn: PyComplex.abs, castSelf: Cast.asPyComplex)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyComplex.add(_:), castSelf: Cast.asPyComplex)
    dict["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, fn: PyComplex.radd(_:), castSelf: Cast.asPyComplex)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyComplex.sub(_:), castSelf: Cast.asPyComplex)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyComplex.rsub(_:), castSelf: Cast.asPyComplex)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyComplex.mul(_:), castSelf: Cast.asPyComplex)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyComplex.rmul(_:), castSelf: Cast.asPyComplex)
    dict["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, fn: PyComplex.pow(_:), castSelf: Cast.asPyComplex)
    dict["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, fn: PyComplex.rpow(_:), castSelf: Cast.asPyComplex)
    dict["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, fn: PyComplex.truediv(_:), castSelf: Cast.asPyComplex)
    dict["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, fn: PyComplex.rtruediv(_:), castSelf: Cast.asPyComplex)
    dict["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, fn: PyComplex.floordiv(_:), castSelf: Cast.asPyComplex)
    dict["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, fn: PyComplex.rfloordiv(_:), castSelf: Cast.asPyComplex)
    dict["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, fn: PyComplex.mod(_:), castSelf: Cast.asPyComplex)
    dict["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, fn: PyComplex.rmod(_:), castSelf: Cast.asPyComplex)
    dict["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, fn: PyComplex.divmod(_:), castSelf: Cast.asPyComplex)
    dict["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, fn: PyComplex.rdivmod(_:), castSelf: Cast.asPyComplex)
    return result
  }

  // MARK: - Dict

  internal static func dict(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict", doc: PyDict.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)
    result.setFlag(.dictSubclass)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDict.getClass, castSelf: Cast.asPyDict)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyDict.pyNew(type:args:kwargs:))


    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyDict.isEqual(_:), castSelf: Cast.asPyDict)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyDict.isNotEqual(_:), castSelf: Cast.asPyDict)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyDict.isLess(_:), castSelf: Cast.asPyDict)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyDict.isLessEqual(_:), castSelf: Cast.asPyDict)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyDict.isGreater(_:), castSelf: Cast.asPyDict)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyDict.isGreaterEqual(_:), castSelf: Cast.asPyDict)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyDict.hash, castSelf: Cast.asPyDict)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyDict.repr, castSelf: Cast.asPyDict)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDict.getAttribute(name:), castSelf: Cast.asPyDict)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyDict.getLength, castSelf: Cast.asPyDict)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyDict.getItem(at:), castSelf: Cast.asPyDict)
    dict["__setitem__"] = wrapMethod(context, name: "__setitem__", doc: nil, fn: PyDict.setItem(at:to:), castSelf: Cast.asPyDict)
    dict["__delitem__"] = wrapMethod(context, name: "__delitem__", doc: nil, fn: PyDict.delItem(at:), castSelf: Cast.asPyDict)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyDict.contains(_:), castSelf: Cast.asPyDict)
    dict["clear"] = wrapMethod(context, name: "clear", doc: nil, fn: PyDict.clear, castSelf: Cast.asPyDict)
    dict["get"] = wrapMethod(context, name: "get", doc: nil, fn: PyDict.get(_:default:), castSelf: Cast.asPyDict)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyDict.iter, castSelf: Cast.asPyDict)
    dict["setdefault"] = wrapMethod(context, name: "setdefault", doc: nil, fn: PyDict.setDefault(_:default:), castSelf: Cast.asPyDict)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PyDict.copy, castSelf: Cast.asPyDict)
    dict["pop"] = wrapMethod(context, name: "pop", doc: nil, fn: PyDict.pop(_:default:), castSelf: Cast.asPyDict)
    dict["popitem"] = wrapMethod(context, name: "popitem", doc: nil, fn: PyDict.popitem, castSelf: Cast.asPyDict)
    dict["keys"] = wrapMethod(context, name: "keys", doc: nil, fn: PyDict.keys, castSelf: Cast.asPyDict)
    dict["items"] = wrapMethod(context, name: "items", doc: nil, fn: PyDict.items, castSelf: Cast.asPyDict)
    dict["values"] = wrapMethod(context, name: "values", doc: nil, fn: PyDict.values, castSelf: Cast.asPyDict)
    return result
  }

  // MARK: - DictItemIterator

  internal static func dict_itemiterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict_itemiterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDictItemIterator.getClass, castSelf: Cast.asPyDictItemIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDictItemIterator.getAttribute(name:), castSelf: Cast.asPyDictItemIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyDictItemIterator.iter, castSelf: Cast.asPyDictItemIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyDictItemIterator.next, castSelf: Cast.asPyDictItemIterator)
    return result
  }

  // MARK: - DictItems

  internal static func dict_items(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict_items", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDictItems.getClass, castSelf: Cast.asPyDictItems)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyDictItems.isEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyDictItems.isNotEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyDictItems.isLess(_:), castSelf: Cast.asPyDictItems)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyDictItems.isLessEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyDictItems.isGreater(_:), castSelf: Cast.asPyDictItems)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyDictItems.isGreaterEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyDictItems.repr, castSelf: Cast.asPyDictItems)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDictItems.getAttribute(name:), castSelf: Cast.asPyDictItems)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyDictItems.getLength, castSelf: Cast.asPyDictItems)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyDictItems.contains(_:), castSelf: Cast.asPyDictItems)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyDictItems.iter, castSelf: Cast.asPyDictItems)
    return result
  }

  // MARK: - DictKeyIterator

  internal static func dict_keyiterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict_keyiterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDictKeyIterator.getClass, castSelf: Cast.asPyDictKeyIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDictKeyIterator.getAttribute(name:), castSelf: Cast.asPyDictKeyIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyDictKeyIterator.iter, castSelf: Cast.asPyDictKeyIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyDictKeyIterator.next, castSelf: Cast.asPyDictKeyIterator)
    return result
  }

  // MARK: - DictKeys

  internal static func dict_keys(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict_keys", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDictKeys.getClass, castSelf: Cast.asPyDictKeys)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyDictKeys.isEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyDictKeys.isNotEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyDictKeys.isLess(_:), castSelf: Cast.asPyDictKeys)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyDictKeys.isLessEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyDictKeys.isGreater(_:), castSelf: Cast.asPyDictKeys)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyDictKeys.isGreaterEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyDictKeys.repr, castSelf: Cast.asPyDictKeys)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDictKeys.getAttribute(name:), castSelf: Cast.asPyDictKeys)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyDictKeys.getLength, castSelf: Cast.asPyDictKeys)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyDictKeys.contains(_:), castSelf: Cast.asPyDictKeys)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyDictKeys.iter, castSelf: Cast.asPyDictKeys)
    return result
  }

  // MARK: - DictValueIterator

  internal static func dict_valueiterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict_valueiterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDictValueIterator.getClass, castSelf: Cast.asPyDictValueIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDictValueIterator.getAttribute(name:), castSelf: Cast.asPyDictValueIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyDictValueIterator.iter, castSelf: Cast.asPyDictValueIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyDictValueIterator.next, castSelf: Cast.asPyDictValueIterator)
    return result
  }

  // MARK: - DictValues

  internal static func dict_values(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict_values", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyDictValues.repr, castSelf: Cast.asPyDictValues)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDictValues.getAttribute(name:), castSelf: Cast.asPyDictValues)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyDictValues.getLength, castSelf: Cast.asPyDictValues)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyDictValues.iter, castSelf: Cast.asPyDictValues)
    return result
  }

  // MARK: - Ellipsis

  internal static func ellipsis(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ellipsis", doc: nil, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyEllipsis.getClass, castSelf: Cast.asPyEllipsis)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyEllipsis.pyNew(type:args:kwargs:))


    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyEllipsis.repr, castSelf: Cast.asPyEllipsis)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyEllipsis.getAttribute(name:), castSelf: Cast.asPyEllipsis)
    return result
  }

  // MARK: - Enumerate

  internal static func enumerate(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "enumerate", doc: PyEnumerate.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyEnumerate.getClass, castSelf: Cast.asPyEnumerate)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyEnumerate.getAttribute(name:), castSelf: Cast.asPyEnumerate)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyEnumerate.iter, castSelf: Cast.asPyEnumerate)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyEnumerate.next, castSelf: Cast.asPyEnumerate)
    return result
  }

  // MARK: - Float

  internal static func float(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "float", doc: PyFloat.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFloat.getClass, castSelf: Cast.asPyFloat)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyFloat.pyNew(type:args:kwargs:))

    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyFloat.isEqual(_:), castSelf: Cast.asPyFloat)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyFloat.isNotEqual(_:), castSelf: Cast.asPyFloat)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyFloat.isLess(_:), castSelf: Cast.asPyFloat)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyFloat.isLessEqual(_:), castSelf: Cast.asPyFloat)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyFloat.isGreater(_:), castSelf: Cast.asPyFloat)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyFloat.isGreaterEqual(_:), castSelf: Cast.asPyFloat)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyFloat.hash, castSelf: Cast.asPyFloat)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyFloat.repr, castSelf: Cast.asPyFloat)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyFloat.str, castSelf: Cast.asPyFloat)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyFloat.asBool, castSelf: Cast.asPyFloat)
    dict["__int__"] = wrapMethod(context, name: "__int__", doc: nil, fn: PyFloat.asInt, castSelf: Cast.asPyFloat)
    dict["__float__"] = wrapMethod(context, name: "__float__", doc: nil, fn: PyFloat.asFloat, castSelf: Cast.asPyFloat)
    dict["real"] = wrapMethod(context, name: "real", doc: nil, fn: PyFloat.asReal, castSelf: Cast.asPyFloat)
    dict["imag"] = wrapMethod(context, name: "imag", doc: nil, fn: PyFloat.asImag, castSelf: Cast.asPyFloat)
    dict["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, fn: PyFloat.conjugate, castSelf: Cast.asPyFloat)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyFloat.getAttribute(name:), castSelf: Cast.asPyFloat)
    dict["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, fn: PyFloat.positive, castSelf: Cast.asPyFloat)
    dict["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, fn: PyFloat.negative, castSelf: Cast.asPyFloat)
    dict["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, fn: PyFloat.abs, castSelf: Cast.asPyFloat)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyFloat.add(_:), castSelf: Cast.asPyFloat)
    dict["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, fn: PyFloat.radd(_:), castSelf: Cast.asPyFloat)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyFloat.sub(_:), castSelf: Cast.asPyFloat)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyFloat.rsub(_:), castSelf: Cast.asPyFloat)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyFloat.mul(_:), castSelf: Cast.asPyFloat)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyFloat.rmul(_:), castSelf: Cast.asPyFloat)
    dict["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, fn: PyFloat.pow(_:), castSelf: Cast.asPyFloat)
    dict["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, fn: PyFloat.rpow(_:), castSelf: Cast.asPyFloat)
    dict["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, fn: PyFloat.truediv(_:), castSelf: Cast.asPyFloat)
    dict["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, fn: PyFloat.rtruediv(_:), castSelf: Cast.asPyFloat)
    dict["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, fn: PyFloat.floordiv(_:), castSelf: Cast.asPyFloat)
    dict["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, fn: PyFloat.rfloordiv(_:), castSelf: Cast.asPyFloat)
    dict["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, fn: PyFloat.mod(_:), castSelf: Cast.asPyFloat)
    dict["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, fn: PyFloat.rmod(_:), castSelf: Cast.asPyFloat)
    dict["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, fn: PyFloat.divmod(_:), castSelf: Cast.asPyFloat)
    dict["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, fn: PyFloat.rdivmod(_:), castSelf: Cast.asPyFloat)
    dict["__round__"] = wrapMethod(context, name: "__round__", doc: nil, fn: PyFloat.round(nDigits:), castSelf: Cast.asPyFloat)
    dict["__trunc__"] = wrapMethod(context, name: "__trunc__", doc: nil, fn: PyFloat.trunc, castSelf: Cast.asPyFloat)
    return result
  }

  // MARK: - FrozenSet

  internal static func frozenset(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "frozenset", doc: PyFrozenSet.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFrozenSet.getClass, castSelf: Cast.asPyFrozenSet)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyFrozenSet.isEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyFrozenSet.isNotEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyFrozenSet.isLess(_:), castSelf: Cast.asPyFrozenSet)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyFrozenSet.isLessEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyFrozenSet.isGreater(_:), castSelf: Cast.asPyFrozenSet)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyFrozenSet.isGreaterEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyFrozenSet.hash, castSelf: Cast.asPyFrozenSet)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyFrozenSet.repr, castSelf: Cast.asPyFrozenSet)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyFrozenSet.getAttribute(name:), castSelf: Cast.asPyFrozenSet)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyFrozenSet.getLength, castSelf: Cast.asPyFrozenSet)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyFrozenSet.contains(_:), castSelf: Cast.asPyFrozenSet)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PyFrozenSet.and(_:), castSelf: Cast.asPyFrozenSet)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PyFrozenSet.rand(_:), castSelf: Cast.asPyFrozenSet)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PyFrozenSet.or(_:), castSelf: Cast.asPyFrozenSet)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PyFrozenSet.ror(_:), castSelf: Cast.asPyFrozenSet)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PyFrozenSet.xor(_:), castSelf: Cast.asPyFrozenSet)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PyFrozenSet.rxor(_:), castSelf: Cast.asPyFrozenSet)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyFrozenSet.sub(_:), castSelf: Cast.asPyFrozenSet)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyFrozenSet.rsub(_:), castSelf: Cast.asPyFrozenSet)
    dict["issubset"] = wrapMethod(context, name: "issubset", doc: nil, fn: PyFrozenSet.isSubset(of:), castSelf: Cast.asPyFrozenSet)
    dict["issuperset"] = wrapMethod(context, name: "issuperset", doc: nil, fn: PyFrozenSet.isSuperset(of:), castSelf: Cast.asPyFrozenSet)
    dict["intersection"] = wrapMethod(context, name: "intersection", doc: nil, fn: PyFrozenSet.intersection(with:), castSelf: Cast.asPyFrozenSet)
    dict["union"] = wrapMethod(context, name: "union", doc: nil, fn: PyFrozenSet.union(with:), castSelf: Cast.asPyFrozenSet)
    dict["difference"] = wrapMethod(context, name: "difference", doc: nil, fn: PyFrozenSet.difference(with:), castSelf: Cast.asPyFrozenSet)
    dict["symmetric_difference"] = wrapMethod(context, name: "symmetric_difference", doc: nil, fn: PyFrozenSet.symmetricDifference(with:), castSelf: Cast.asPyFrozenSet)
    dict["isdisjoint"] = wrapMethod(context, name: "isdisjoint", doc: nil, fn: PyFrozenSet.isDisjoint(with:), castSelf: Cast.asPyFrozenSet)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PyFrozenSet.copy, castSelf: Cast.asPyFrozenSet)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyFrozenSet.iter, castSelf: Cast.asPyFrozenSet)
    return result
  }

  // MARK: - Function

  internal static func function(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "function", doc: PyFunction.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFunction.getClass, castSelf: Cast.asPyFunction)
    dict["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyFunction.getName, set: PyFunction.setName, castSelf: Cast.asPyFunction)
    dict["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyFunction.getQualname, set: PyFunction.setQualname, castSelf: Cast.asPyFunction)
    dict["__code__"] = createProperty(context, name: "__code__", doc: nil, get: PyFunction.getCode, castSelf: Cast.asPyFunction)
    dict["__doc__"] = createProperty(context, name: "__doc__", doc: nil, get: PyFunction.getDoc, castSelf: Cast.asPyFunction)
    dict["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyFunction.getModule, castSelf: Cast.asPyFunction)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFunction.getDict, castSelf: Cast.asPyFunction)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyFunction.repr, castSelf: Cast.asPyFunction)
    dict["__get__"] = wrapMethod(context, name: "__get__", doc: nil, fn: PyFunction.get(object:), castSelf: Cast.asPyFunction)
    return result
  }

  // MARK: - Int

  internal static func int(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "int", doc: PyInt.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.longSubclass)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyInt.getClass, castSelf: Cast.asPyInt)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyInt.pyNew(type:args:kwargs:))

    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyInt.isEqual(_:), castSelf: Cast.asPyInt)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyInt.isNotEqual(_:), castSelf: Cast.asPyInt)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyInt.isLess(_:), castSelf: Cast.asPyInt)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyInt.isLessEqual(_:), castSelf: Cast.asPyInt)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyInt.isGreater(_:), castSelf: Cast.asPyInt)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyInt.isGreaterEqual(_:), castSelf: Cast.asPyInt)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyInt.hash, castSelf: Cast.asPyInt)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyInt.repr, castSelf: Cast.asPyInt)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyInt.str, castSelf: Cast.asPyInt)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyInt.asBool, castSelf: Cast.asPyInt)
    dict["__int__"] = wrapMethod(context, name: "__int__", doc: nil, fn: PyInt.asInt, castSelf: Cast.asPyInt)
    dict["__float__"] = wrapMethod(context, name: "__float__", doc: nil, fn: PyInt.asFloat, castSelf: Cast.asPyInt)
    dict["__index__"] = wrapMethod(context, name: "__index__", doc: nil, fn: PyInt.asIndex, castSelf: Cast.asPyInt)
    dict["real"] = wrapMethod(context, name: "real", doc: nil, fn: PyInt.asReal, castSelf: Cast.asPyInt)
    dict["imag"] = wrapMethod(context, name: "imag", doc: nil, fn: PyInt.asImag, castSelf: Cast.asPyInt)
    dict["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, fn: PyInt.conjugate, castSelf: Cast.asPyInt)
    dict["numerator"] = wrapMethod(context, name: "numerator", doc: nil, fn: PyInt.numerator, castSelf: Cast.asPyInt)
    dict["denominator"] = wrapMethod(context, name: "denominator", doc: nil, fn: PyInt.denominator, castSelf: Cast.asPyInt)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyInt.getAttribute(name:), castSelf: Cast.asPyInt)
    dict["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, fn: PyInt.positive, castSelf: Cast.asPyInt)
    dict["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, fn: PyInt.negative, castSelf: Cast.asPyInt)
    dict["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, fn: PyInt.abs, castSelf: Cast.asPyInt)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyInt.add(_:), castSelf: Cast.asPyInt)
    dict["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, fn: PyInt.radd(_:), castSelf: Cast.asPyInt)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyInt.sub(_:), castSelf: Cast.asPyInt)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyInt.rsub(_:), castSelf: Cast.asPyInt)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyInt.mul(_:), castSelf: Cast.asPyInt)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyInt.rmul(_:), castSelf: Cast.asPyInt)
    dict["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, fn: PyInt.pow(_:), castSelf: Cast.asPyInt)
    dict["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, fn: PyInt.rpow(_:), castSelf: Cast.asPyInt)
    dict["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, fn: PyInt.truediv(_:), castSelf: Cast.asPyInt)
    dict["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, fn: PyInt.rtruediv(_:), castSelf: Cast.asPyInt)
    dict["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, fn: PyInt.floordiv(_:), castSelf: Cast.asPyInt)
    dict["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, fn: PyInt.rfloordiv(_:), castSelf: Cast.asPyInt)
    dict["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, fn: PyInt.mod(_:), castSelf: Cast.asPyInt)
    dict["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, fn: PyInt.rmod(_:), castSelf: Cast.asPyInt)
    dict["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, fn: PyInt.divmod(_:), castSelf: Cast.asPyInt)
    dict["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, fn: PyInt.rdivmod(_:), castSelf: Cast.asPyInt)
    dict["__lshift__"] = wrapMethod(context, name: "__lshift__", doc: nil, fn: PyInt.lshift(_:), castSelf: Cast.asPyInt)
    dict["__rlshift__"] = wrapMethod(context, name: "__rlshift__", doc: nil, fn: PyInt.rlshift(_:), castSelf: Cast.asPyInt)
    dict["__rshift__"] = wrapMethod(context, name: "__rshift__", doc: nil, fn: PyInt.rshift(_:), castSelf: Cast.asPyInt)
    dict["__rrshift__"] = wrapMethod(context, name: "__rrshift__", doc: nil, fn: PyInt.rrshift(_:), castSelf: Cast.asPyInt)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PyInt.and(_:), castSelf: Cast.asPyInt)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PyInt.rand(_:), castSelf: Cast.asPyInt)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PyInt.or(_:), castSelf: Cast.asPyInt)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PyInt.ror(_:), castSelf: Cast.asPyInt)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PyInt.xor(_:), castSelf: Cast.asPyInt)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PyInt.rxor(_:), castSelf: Cast.asPyInt)
    dict["__invert__"] = wrapMethod(context, name: "__invert__", doc: nil, fn: PyInt.invert, castSelf: Cast.asPyInt)
    dict["__round__"] = wrapMethod(context, name: "__round__", doc: nil, fn: PyInt.round(nDigits:), castSelf: Cast.asPyInt)
    return result
  }

  // MARK: - Iterator

  internal static func iterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "iterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIterator.getClass, castSelf: Cast.asPyIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyIterator.getAttribute(name:), castSelf: Cast.asPyIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyIterator.iter, castSelf: Cast.asPyIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyIterator.next, castSelf: Cast.asPyIterator)
    return result
  }

  // MARK: - List

  internal static func list(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "list", doc: PyList.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)
    result.setFlag(.listSubclass)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyList.getClass, castSelf: Cast.asPyList)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyList.pyNew(type:args:kwargs:))


    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyList.isEqual(_:), castSelf: Cast.asPyList)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyList.isNotEqual(_:), castSelf: Cast.asPyList)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyList.isLess(_:), castSelf: Cast.asPyList)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyList.isLessEqual(_:), castSelf: Cast.asPyList)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyList.isGreater(_:), castSelf: Cast.asPyList)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyList.isGreaterEqual(_:), castSelf: Cast.asPyList)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyList.repr, castSelf: Cast.asPyList)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyList.getAttribute(name:), castSelf: Cast.asPyList)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyList.getLength, castSelf: Cast.asPyList)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyList.contains(_:), castSelf: Cast.asPyList)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyList.getItem(at:), castSelf: Cast.asPyList)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyList.count(_:), castSelf: Cast.asPyList)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyList.index(of:start:end:), castSelf: Cast.asPyList)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyList.iter, castSelf: Cast.asPyList)
    dict["__reversed__"] = wrapMethod(context, name: "__reversed__", doc: nil, fn: PyList.reversedIter, castSelf: Cast.asPyList)
    dict["append"] = wrapMethod(context, name: "append", doc: nil, fn: PyList.append(_:), castSelf: Cast.asPyList)
    dict["pop"] = wrapMethod(context, name: "pop", doc: nil, fn: PyList.pop(index:), castSelf: Cast.asPyList)
    dict["clear"] = wrapMethod(context, name: "clear", doc: nil, fn: PyList.clear, castSelf: Cast.asPyList)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PyList.copy, castSelf: Cast.asPyList)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyList.add(_:), castSelf: Cast.asPyList)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyList.mul(_:), castSelf: Cast.asPyList)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyList.rmul(_:), castSelf: Cast.asPyList)
    dict["__imul__"] = wrapMethod(context, name: "__imul__", doc: nil, fn: PyList.imul(_:), castSelf: Cast.asPyList)
    return result
  }

  // MARK: - ListIterator

  internal static func list_iterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "list_iterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyListIterator.getClass, castSelf: Cast.asPyListIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyListIterator.getAttribute(name:), castSelf: Cast.asPyListIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyListIterator.iter, castSelf: Cast.asPyListIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyListIterator.next, castSelf: Cast.asPyListIterator)
    return result
  }

  // MARK: - ListReverseIterator

  internal static func list_reverseiterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "list_reverseiterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyListReverseIterator.getClass, castSelf: Cast.asPyListReverseIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyListReverseIterator.getAttribute(name:), castSelf: Cast.asPyListReverseIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyListReverseIterator.iter, castSelf: Cast.asPyListReverseIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyListReverseIterator.next, castSelf: Cast.asPyListReverseIterator)
    return result
  }

  // MARK: - Method

  internal static func method(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "method", doc: PyMethod.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyMethod.getClass, castSelf: Cast.asPyMethod)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyMethod.isEqual(_:), castSelf: Cast.asPyMethod)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyMethod.isNotEqual(_:), castSelf: Cast.asPyMethod)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyMethod.isLess(_:), castSelf: Cast.asPyMethod)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyMethod.isLessEqual(_:), castSelf: Cast.asPyMethod)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyMethod.isGreater(_:), castSelf: Cast.asPyMethod)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyMethod.isGreaterEqual(_:), castSelf: Cast.asPyMethod)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyMethod.repr, castSelf: Cast.asPyMethod)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyMethod.hash, castSelf: Cast.asPyMethod)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyMethod.getAttribute(name:), castSelf: Cast.asPyMethod)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyMethod.setAttribute(name:value:), castSelf: Cast.asPyMethod)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyMethod.delAttribute(name:), castSelf: Cast.asPyMethod)
    dict["__func__"] = wrapMethod(context, name: "__func__", doc: nil, fn: PyMethod.getFunc, castSelf: Cast.asPyMethod)
    dict["__self__"] = wrapMethod(context, name: "__self__", doc: nil, fn: PyMethod.getSelf, castSelf: Cast.asPyMethod)
    dict["__get__"] = wrapMethod(context, name: "__get__", doc: nil, fn: PyMethod.get(object:), castSelf: Cast.asPyMethod)
    return result
  }

  // MARK: - Module

  internal static func module(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "module", doc: PyModule.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyModule.getDict, castSelf: Cast.asPyModule)
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyModule.getClass, castSelf: Cast.asPyModule)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyModule.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyModule.pyInit(zelf:args:kwargs:))


    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyModule.repr, castSelf: Cast.asPyModule)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyModule.getAttribute(name:), castSelf: Cast.asPyModule)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyModule.setAttribute(name:value:), castSelf: Cast.asPyModule)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyModule.delAttribute(name:), castSelf: Cast.asPyModule)
    dict["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, fn: PyModule.dir, castSelf: Cast.asPyModule)
    return result
  }

  // MARK: - Namespace

  internal static func simpleNamespace(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "types.SimpleNamespace", doc: PyNamespace.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNamespace.getDict, castSelf: Cast.asPyNamespace)

    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyNamespace.pyInit(zelf:args:kwargs:))


    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyNamespace.isEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyNamespace.isNotEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyNamespace.isLess(_:), castSelf: Cast.asPyNamespace)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyNamespace.isLessEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyNamespace.isGreater(_:), castSelf: Cast.asPyNamespace)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyNamespace.isGreaterEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyNamespace.repr, castSelf: Cast.asPyNamespace)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyNamespace.getAttribute(name:), castSelf: Cast.asPyNamespace)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyNamespace.setAttribute(name:value:), castSelf: Cast.asPyNamespace)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyNamespace.delAttribute(name:), castSelf: Cast.asPyNamespace)
    return result
  }

  // MARK: - None

  internal static func none(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NoneType", doc: nil, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNone.getClass, castSelf: Cast.asPyNone)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyNone.pyNew(type:args:kwargs:))


    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyNone.repr, castSelf: Cast.asPyNone)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyNone.asBool, castSelf: Cast.asPyNone)
    return result
  }

  // MARK: - NotImplemented

  internal static func notImplemented(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedType", doc: nil, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotImplemented.getClass, castSelf: Cast.asPyNotImplemented)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyNotImplemented.pyNew(type:args:kwargs:))


    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyNotImplemented.repr, castSelf: Cast.asPyNotImplemented)
    return result
  }

  // MARK: - Property

  internal static func property(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "property", doc: PyProperty.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyProperty.getClass, castSelf: Cast.asPyProperty)
    dict["fget"] = createProperty(context, name: "fget", doc: nil, get: PyProperty.getFGet, castSelf: Cast.asPyProperty)
    dict["fset"] = createProperty(context, name: "fset", doc: nil, get: PyProperty.getFSet, castSelf: Cast.asPyProperty)
    dict["fdel"] = createProperty(context, name: "fdel", doc: nil, get: PyProperty.getFDel, castSelf: Cast.asPyProperty)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyProperty.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyProperty.pyInit(zelf:args:kwargs:))


    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyProperty.getAttribute(name:), castSelf: Cast.asPyProperty)
    dict["__get__"] = wrapMethod(context, name: "__get__", doc: nil, fn: PyProperty.get(object:), castSelf: Cast.asPyProperty)
    dict["__set__"] = wrapMethod(context, name: "__set__", doc: nil, fn: PyProperty.set(object:value:), castSelf: Cast.asPyProperty)
    dict["__delete__"] = wrapMethod(context, name: "__delete__", doc: nil, fn: PyProperty.del(object:), castSelf: Cast.asPyProperty)
    return result
  }

  // MARK: - Range

  internal static func range(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "range", doc: PyRange.doc, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRange.getClass, castSelf: Cast.asPyRange)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyRange.isEqual(_:), castSelf: Cast.asPyRange)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyRange.isNotEqual(_:), castSelf: Cast.asPyRange)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyRange.isLess(_:), castSelf: Cast.asPyRange)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyRange.isLessEqual(_:), castSelf: Cast.asPyRange)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyRange.isGreater(_:), castSelf: Cast.asPyRange)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyRange.isGreaterEqual(_:), castSelf: Cast.asPyRange)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyRange.hash, castSelf: Cast.asPyRange)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyRange.repr, castSelf: Cast.asPyRange)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyRange.asBool, castSelf: Cast.asPyRange)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyRange.getLength, castSelf: Cast.asPyRange)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyRange.getAttribute(name:), castSelf: Cast.asPyRange)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyRange.contains(_:), castSelf: Cast.asPyRange)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyRange.getItem(at:), castSelf: Cast.asPyRange)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyRange.count(_:), castSelf: Cast.asPyRange)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyRange.index(of:), castSelf: Cast.asPyRange)
    return result
  }

  // MARK: - Reversed

  internal static func reversed(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "reversed", doc: PyReversed.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyReversed.getClass, castSelf: Cast.asPyReversed)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyReversed.getAttribute(name:), castSelf: Cast.asPyReversed)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyReversed.iter, castSelf: Cast.asPyReversed)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyReversed.next, castSelf: Cast.asPyReversed)
    return result
  }

  // MARK: - Set

  internal static func set(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "set", doc: PySet.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySet.getClass, castSelf: Cast.asPySet)

    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PySet.pyNew(type:args:kwargs:))


    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PySet.isEqual(_:), castSelf: Cast.asPySet)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PySet.isNotEqual(_:), castSelf: Cast.asPySet)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PySet.isLess(_:), castSelf: Cast.asPySet)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PySet.isLessEqual(_:), castSelf: Cast.asPySet)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PySet.isGreater(_:), castSelf: Cast.asPySet)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PySet.isGreaterEqual(_:), castSelf: Cast.asPySet)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PySet.hash, castSelf: Cast.asPySet)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PySet.repr, castSelf: Cast.asPySet)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PySet.getAttribute(name:), castSelf: Cast.asPySet)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PySet.getLength, castSelf: Cast.asPySet)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PySet.contains(_:), castSelf: Cast.asPySet)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PySet.and(_:), castSelf: Cast.asPySet)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PySet.rand(_:), castSelf: Cast.asPySet)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PySet.or(_:), castSelf: Cast.asPySet)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PySet.ror(_:), castSelf: Cast.asPySet)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PySet.xor(_:), castSelf: Cast.asPySet)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PySet.rxor(_:), castSelf: Cast.asPySet)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PySet.sub(_:), castSelf: Cast.asPySet)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PySet.rsub(_:), castSelf: Cast.asPySet)
    dict["issubset"] = wrapMethod(context, name: "issubset", doc: nil, fn: PySet.isSubset(of:), castSelf: Cast.asPySet)
    dict["issuperset"] = wrapMethod(context, name: "issuperset", doc: nil, fn: PySet.isSuperset(of:), castSelf: Cast.asPySet)
    dict["intersection"] = wrapMethod(context, name: "intersection", doc: nil, fn: PySet.intersection(with:), castSelf: Cast.asPySet)
    dict["union"] = wrapMethod(context, name: "union", doc: nil, fn: PySet.union(with:), castSelf: Cast.asPySet)
    dict["difference"] = wrapMethod(context, name: "difference", doc: nil, fn: PySet.difference(with:), castSelf: Cast.asPySet)
    dict["symmetric_difference"] = wrapMethod(context, name: "symmetric_difference", doc: nil, fn: PySet.symmetricDifference(with:), castSelf: Cast.asPySet)
    dict["isdisjoint"] = wrapMethod(context, name: "isdisjoint", doc: nil, fn: PySet.isDisjoint(with:), castSelf: Cast.asPySet)
    dict["add"] = wrapMethod(context, name: "add", doc: nil, fn: PySet.add(_:), castSelf: Cast.asPySet)
    dict["remove"] = wrapMethod(context, name: "remove", doc: nil, fn: PySet.remove(_:), castSelf: Cast.asPySet)
    dict["discard"] = wrapMethod(context, name: "discard", doc: nil, fn: PySet.discard(_:), castSelf: Cast.asPySet)
    dict["clear"] = wrapMethod(context, name: "clear", doc: nil, fn: PySet.clear, castSelf: Cast.asPySet)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PySet.copy, castSelf: Cast.asPySet)
    dict["pop"] = wrapMethod(context, name: "pop", doc: nil, fn: PySet.pop, castSelf: Cast.asPySet)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PySet.iter, castSelf: Cast.asPySet)
    return result
  }

  // MARK: - SetIterator

  internal static func set_iterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "set_iterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySetIterator.getClass, castSelf: Cast.asPySetIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PySetIterator.getAttribute(name:), castSelf: Cast.asPySetIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PySetIterator.iter, castSelf: Cast.asPySetIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PySetIterator.next, castSelf: Cast.asPySetIterator)
    return result
  }

  // MARK: - Slice

  internal static func slice(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "slice", doc: PySlice.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySlice.getClass, castSelf: Cast.asPySlice)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PySlice.isEqual(_:), castSelf: Cast.asPySlice)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PySlice.isNotEqual(_:), castSelf: Cast.asPySlice)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PySlice.isLess(_:), castSelf: Cast.asPySlice)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PySlice.isLessEqual(_:), castSelf: Cast.asPySlice)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PySlice.isGreater(_:), castSelf: Cast.asPySlice)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PySlice.isGreaterEqual(_:), castSelf: Cast.asPySlice)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PySlice.repr, castSelf: Cast.asPySlice)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PySlice.getAttribute(name:), castSelf: Cast.asPySlice)
    dict["indices"] = wrapMethod(context, name: "indices", doc: nil, fn: PySlice.indicesInSequence(length:), castSelf: Cast.asPySlice)
    return result
  }

  // MARK: - String

  internal static func str(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "str", doc: PyString.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.unicodeSubclass)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyString.getClass, castSelf: Cast.asPyString)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyString.pyNew(type:args:kwargs:))

    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyString.isEqual(_:), castSelf: Cast.asPyString)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyString.isNotEqual(_:), castSelf: Cast.asPyString)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyString.isLess(_:), castSelf: Cast.asPyString)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyString.isLessEqual(_:), castSelf: Cast.asPyString)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyString.isGreater(_:), castSelf: Cast.asPyString)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyString.isGreaterEqual(_:), castSelf: Cast.asPyString)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyString.hash, castSelf: Cast.asPyString)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyString.repr, castSelf: Cast.asPyString)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyString.str, castSelf: Cast.asPyString)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyString.getAttribute(name:), castSelf: Cast.asPyString)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyString.getLength, castSelf: Cast.asPyString)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyString.contains(_:), castSelf: Cast.asPyString)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyString.getItem(at:), castSelf: Cast.asPyString)
    dict["isalnum"] = wrapMethod(context, name: "isalnum", doc: nil, fn: PyString.isAlphaNumeric, castSelf: Cast.asPyString)
    dict["isalpha"] = wrapMethod(context, name: "isalpha", doc: nil, fn: PyString.isAlpha, castSelf: Cast.asPyString)
    dict["isascii"] = wrapMethod(context, name: "isascii", doc: nil, fn: PyString.isAscii, castSelf: Cast.asPyString)
    dict["isdecimal"] = wrapMethod(context, name: "isdecimal", doc: nil, fn: PyString.isDecimal, castSelf: Cast.asPyString)
    dict["isdigit"] = wrapMethod(context, name: "isdigit", doc: nil, fn: PyString.isDigit, castSelf: Cast.asPyString)
    dict["isidentifier"] = wrapMethod(context, name: "isidentifier", doc: nil, fn: PyString.isIdentifier, castSelf: Cast.asPyString)
    dict["islower"] = wrapMethod(context, name: "islower", doc: nil, fn: PyString.isLower, castSelf: Cast.asPyString)
    dict["isnumeric"] = wrapMethod(context, name: "isnumeric", doc: nil, fn: PyString.isNumeric, castSelf: Cast.asPyString)
    dict["isprintable"] = wrapMethod(context, name: "isprintable", doc: nil, fn: PyString.isPrintable, castSelf: Cast.asPyString)
    dict["isspace"] = wrapMethod(context, name: "isspace", doc: nil, fn: PyString.isSpace, castSelf: Cast.asPyString)
    dict["istitle"] = wrapMethod(context, name: "istitle", doc: nil, fn: PyString.isTitle, castSelf: Cast.asPyString)
    dict["isupper"] = wrapMethod(context, name: "isupper", doc: nil, fn: PyString.isUpper, castSelf: Cast.asPyString)
    dict["startswith"] = wrapMethod(context, name: "startswith", doc: nil, fn: PyString.startsWith(_:start:end:), castSelf: Cast.asPyString)
    dict["endswith"] = wrapMethod(context, name: "endswith", doc: nil, fn: PyString.endsWith(_:start:end:), castSelf: Cast.asPyString)
    dict["strip"] = wrapMethod(context, name: "strip", doc: nil, fn: PyString.strip(_:), castSelf: Cast.asPyString)
    dict["lstrip"] = wrapMethod(context, name: "lstrip", doc: nil, fn: PyString.lstrip(_:), castSelf: Cast.asPyString)
    dict["rstrip"] = wrapMethod(context, name: "rstrip", doc: nil, fn: PyString.rstrip(_:), castSelf: Cast.asPyString)
    dict["find"] = wrapMethod(context, name: "find", doc: nil, fn: PyString.find(_:start:end:), castSelf: Cast.asPyString)
    dict["rfind"] = wrapMethod(context, name: "rfind", doc: nil, fn: PyString.rfind(_:start:end:), castSelf: Cast.asPyString)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyString.index(of:start:end:), castSelf: Cast.asPyString)
    dict["rindex"] = wrapMethod(context, name: "rindex", doc: nil, fn: PyString.rindex(_:start:end:), castSelf: Cast.asPyString)
    dict["lower"] = wrapMethod(context, name: "lower", doc: nil, fn: PyString.lower, castSelf: Cast.asPyString)
    dict["upper"] = wrapMethod(context, name: "upper", doc: nil, fn: PyString.upper, castSelf: Cast.asPyString)
    dict["title"] = wrapMethod(context, name: "title", doc: nil, fn: PyString.title, castSelf: Cast.asPyString)
    dict["swapcase"] = wrapMethod(context, name: "swapcase", doc: nil, fn: PyString.swapcase, castSelf: Cast.asPyString)
    dict["casefold"] = wrapMethod(context, name: "casefold", doc: nil, fn: PyString.casefold, castSelf: Cast.asPyString)
    dict["capitalize"] = wrapMethod(context, name: "capitalize", doc: nil, fn: PyString.capitalize, castSelf: Cast.asPyString)
    dict["center"] = wrapMethod(context, name: "center", doc: nil, fn: PyString.center(width:fillChar:), castSelf: Cast.asPyString)
    dict["ljust"] = wrapMethod(context, name: "ljust", doc: nil, fn: PyString.ljust(width:fillChar:), castSelf: Cast.asPyString)
    dict["rjust"] = wrapMethod(context, name: "rjust", doc: nil, fn: PyString.rjust(width:fillChar:), castSelf: Cast.asPyString)
    dict["split"] = wrapMethod(context, name: "split", doc: nil, fn: PyString.split(separator:maxCount:), castSelf: Cast.asPyString)
    dict["rsplit"] = wrapMethod(context, name: "rsplit", doc: nil, fn: PyString.rsplit(separator:maxCount:), castSelf: Cast.asPyString)
    dict["splitlines"] = wrapMethod(context, name: "splitlines", doc: nil, fn: PyString.splitLines(keepEnds:), castSelf: Cast.asPyString)
    dict["partition"] = wrapMethod(context, name: "partition", doc: nil, fn: PyString.partition(separator:), castSelf: Cast.asPyString)
    dict["rpartition"] = wrapMethod(context, name: "rpartition", doc: nil, fn: PyString.rpartition(separator:), castSelf: Cast.asPyString)
    dict["expandtabs"] = wrapMethod(context, name: "expandtabs", doc: nil, fn: PyString.expandTabs(tabSize:), castSelf: Cast.asPyString)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyString.count(_:start:end:), castSelf: Cast.asPyString)
    dict["replace"] = wrapMethod(context, name: "replace", doc: nil, fn: PyString.replace(old:new:count:), castSelf: Cast.asPyString)
    dict["zfill"] = wrapMethod(context, name: "zfill", doc: nil, fn: PyString.zfill(width:), castSelf: Cast.asPyString)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyString.add(_:), castSelf: Cast.asPyString)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyString.mul(_:), castSelf: Cast.asPyString)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyString.rmul(_:), castSelf: Cast.asPyString)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyString.iter, castSelf: Cast.asPyString)
    return result
  }

  // MARK: - StringIterator

  internal static func str_iterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "str_iterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyStringIterator.getClass, castSelf: Cast.asPyStringIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyStringIterator.getAttribute(name:), castSelf: Cast.asPyStringIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyStringIterator.iter, castSelf: Cast.asPyStringIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyStringIterator.next, castSelf: Cast.asPyStringIterator)
    return result
  }

  // MARK: - Tuple

  internal static func tuple(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "tuple", doc: PyTuple.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)
    result.setFlag(.tupleSubclass)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTuple.getClass, castSelf: Cast.asPyTuple)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyTuple.isEqual(_:), castSelf: Cast.asPyTuple)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyTuple.isNotEqual(_:), castSelf: Cast.asPyTuple)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyTuple.isLess(_:), castSelf: Cast.asPyTuple)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyTuple.isLessEqual(_:), castSelf: Cast.asPyTuple)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyTuple.isGreater(_:), castSelf: Cast.asPyTuple)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyTuple.isGreaterEqual(_:), castSelf: Cast.asPyTuple)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyTuple.hash, castSelf: Cast.asPyTuple)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyTuple.repr, castSelf: Cast.asPyTuple)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyTuple.getAttribute(name:), castSelf: Cast.asPyTuple)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyTuple.getLength, castSelf: Cast.asPyTuple)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyTuple.contains(_:), castSelf: Cast.asPyTuple)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyTuple.getItem(at:), castSelf: Cast.asPyTuple)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyTuple.count(_:), castSelf: Cast.asPyTuple)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyTuple.index(of:start:end:), castSelf: Cast.asPyTuple)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyTuple.iter, castSelf: Cast.asPyTuple)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyTuple.add(_:), castSelf: Cast.asPyTuple)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyTuple.mul(_:), castSelf: Cast.asPyTuple)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyTuple.rmul(_:), castSelf: Cast.asPyTuple)
    return result
  }

  // MARK: - TupleIterator

  internal static func tuple_iterator(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "tuple_iterator", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTupleIterator.getClass, castSelf: Cast.asPyTupleIterator)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyTupleIterator.getAttribute(name:), castSelf: Cast.asPyTupleIterator)
    dict["__iter__"] = wrapMethod(context, name: "__iter__", doc: nil, fn: PyTupleIterator.iter, castSelf: Cast.asPyTupleIterator)
    dict["__next__"] = wrapMethod(context, name: "__next__", doc: nil, fn: PyTupleIterator.next, castSelf: Cast.asPyTupleIterator)
    return result
  }

  // MARK: - ArithmeticError

  internal static func arithmeticError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ArithmeticError", doc: PyArithmeticError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyArithmeticError.getClass, castSelf: Cast.asPyArithmeticError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyArithmeticError.getDict, castSelf: Cast.asPyArithmeticError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyArithmeticError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyArithmeticError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - AssertionError

  internal static func assertionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "AssertionError", doc: PyAssertionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyAssertionError.getClass, castSelf: Cast.asPyAssertionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyAssertionError.getDict, castSelf: Cast.asPyAssertionError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyAssertionError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyAssertionError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - AttributeError

  internal static func attributeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "AttributeError", doc: PyAttributeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyAttributeError.getClass, castSelf: Cast.asPyAttributeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyAttributeError.getDict, castSelf: Cast.asPyAttributeError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyAttributeError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyAttributeError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - BaseException

  internal static func baseException(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BaseException", doc: PyBaseException.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)
    result.setFlag(.baseExceptionSubclass)

    let dict = result.getDict()
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBaseException.getDict, castSelf: Cast.asPyBaseException)
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBaseException.getClass, castSelf: Cast.asPyBaseException)
    dict["args"] = createProperty(context, name: "args", doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: Cast.asPyBaseException)
    dict["__traceback__"] = createProperty(context, name: "__traceback__", doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: Cast.asPyBaseException)
    dict["__cause__"] = createProperty(context, name: "__cause__", doc: nil, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: Cast.asPyBaseException)
    dict["__context__"] = createProperty(context, name: "__context__", doc: nil, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: Cast.asPyBaseException)
    dict["__suppress_context__"] = createProperty(context, name: "__suppress_context__", doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: Cast.asPyBaseException)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBaseException.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyBaseException.pyInit(zelf:args:kwargs:))

    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyBaseException.repr, castSelf: Cast.asPyBaseException)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyBaseException.str, castSelf: Cast.asPyBaseException)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyBaseException.getAttribute(name:), castSelf: Cast.asPyBaseException)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyBaseException.setAttribute(name:value:), castSelf: Cast.asPyBaseException)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyBaseException.delAttribute(name:), castSelf: Cast.asPyBaseException)
    return result
  }

  // MARK: - BlockingIOError

  internal static func blockingIOError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BlockingIOError", doc: PyBlockingIOError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBlockingIOError.getClass, castSelf: Cast.asPyBlockingIOError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBlockingIOError.getDict, castSelf: Cast.asPyBlockingIOError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBlockingIOError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyBlockingIOError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - BrokenPipeError

  internal static func brokenPipeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BrokenPipeError", doc: PyBrokenPipeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBrokenPipeError.getClass, castSelf: Cast.asPyBrokenPipeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBrokenPipeError.getDict, castSelf: Cast.asPyBrokenPipeError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBrokenPipeError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyBrokenPipeError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - BufferError

  internal static func bufferError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BufferError", doc: PyBufferError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBufferError.getClass, castSelf: Cast.asPyBufferError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBufferError.getDict, castSelf: Cast.asPyBufferError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBufferError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyBufferError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - BytesWarning

  internal static func bytesWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BytesWarning", doc: PyBytesWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBytesWarning.getClass, castSelf: Cast.asPyBytesWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBytesWarning.getDict, castSelf: Cast.asPyBytesWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBytesWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyBytesWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ChildProcessError

  internal static func childProcessError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ChildProcessError", doc: PyChildProcessError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyChildProcessError.getClass, castSelf: Cast.asPyChildProcessError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyChildProcessError.getDict, castSelf: Cast.asPyChildProcessError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyChildProcessError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyChildProcessError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ConnectionAbortedError

  internal static func connectionAbortedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionAbortedError", doc: PyConnectionAbortedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionAbortedError.getClass, castSelf: Cast.asPyConnectionAbortedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionAbortedError.getDict, castSelf: Cast.asPyConnectionAbortedError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyConnectionAbortedError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyConnectionAbortedError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ConnectionError

  internal static func connectionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionError", doc: PyConnectionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionError.getClass, castSelf: Cast.asPyConnectionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionError.getDict, castSelf: Cast.asPyConnectionError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyConnectionError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyConnectionError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ConnectionRefusedError

  internal static func connectionRefusedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionRefusedError", doc: PyConnectionRefusedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionRefusedError.getClass, castSelf: Cast.asPyConnectionRefusedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionRefusedError.getDict, castSelf: Cast.asPyConnectionRefusedError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyConnectionRefusedError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyConnectionRefusedError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ConnectionResetError

  internal static func connectionResetError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionResetError", doc: PyConnectionResetError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionResetError.getClass, castSelf: Cast.asPyConnectionResetError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionResetError.getDict, castSelf: Cast.asPyConnectionResetError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyConnectionResetError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyConnectionResetError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - DeprecationWarning

  internal static func deprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "DeprecationWarning", doc: PyDeprecationWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDeprecationWarning.getClass, castSelf: Cast.asPyDeprecationWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyDeprecationWarning.getDict, castSelf: Cast.asPyDeprecationWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyDeprecationWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyDeprecationWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - EOFError

  internal static func eofError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "EOFError", doc: PyEOFError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyEOFError.getClass, castSelf: Cast.asPyEOFError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyEOFError.getDict, castSelf: Cast.asPyEOFError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyEOFError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyEOFError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - Exception

  internal static func exception(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "Exception", doc: PyException.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyException.getClass, castSelf: Cast.asPyException)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyException.getDict, castSelf: Cast.asPyException)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyException.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyException.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - FileExistsError

  internal static func fileExistsError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FileExistsError", doc: PyFileExistsError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFileExistsError.getClass, castSelf: Cast.asPyFileExistsError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFileExistsError.getDict, castSelf: Cast.asPyFileExistsError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyFileExistsError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyFileExistsError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - FileNotFoundError

  internal static func fileNotFoundError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FileNotFoundError", doc: PyFileNotFoundError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFileNotFoundError.getClass, castSelf: Cast.asPyFileNotFoundError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFileNotFoundError.getDict, castSelf: Cast.asPyFileNotFoundError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyFileNotFoundError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyFileNotFoundError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - FloatingPointError

  internal static func floatingPointError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FloatingPointError", doc: PyFloatingPointError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFloatingPointError.getClass, castSelf: Cast.asPyFloatingPointError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFloatingPointError.getDict, castSelf: Cast.asPyFloatingPointError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyFloatingPointError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyFloatingPointError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - FutureWarning

  internal static func futureWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FutureWarning", doc: PyFutureWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFutureWarning.getClass, castSelf: Cast.asPyFutureWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFutureWarning.getDict, castSelf: Cast.asPyFutureWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyFutureWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyFutureWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - GeneratorExit

  internal static func generatorExit(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "GeneratorExit", doc: PyGeneratorExit.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyGeneratorExit.getClass, castSelf: Cast.asPyGeneratorExit)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyGeneratorExit.getDict, castSelf: Cast.asPyGeneratorExit)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyGeneratorExit.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyGeneratorExit.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ImportError

  internal static func importError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ImportError", doc: PyImportError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyImportError.getClass, castSelf: Cast.asPyImportError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyImportError.getDict, castSelf: Cast.asPyImportError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyImportError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyImportError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ImportWarning

  internal static func importWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ImportWarning", doc: PyImportWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyImportWarning.getClass, castSelf: Cast.asPyImportWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyImportWarning.getDict, castSelf: Cast.asPyImportWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyImportWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyImportWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - IndentationError

  internal static func indentationError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IndentationError", doc: PyIndentationError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIndentationError.getClass, castSelf: Cast.asPyIndentationError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIndentationError.getDict, castSelf: Cast.asPyIndentationError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyIndentationError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyIndentationError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - IndexError

  internal static func indexError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IndexError", doc: PyIndexError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIndexError.getClass, castSelf: Cast.asPyIndexError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIndexError.getDict, castSelf: Cast.asPyIndexError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyIndexError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyIndexError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - InterruptedError

  internal static func interruptedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "InterruptedError", doc: PyInterruptedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyInterruptedError.getClass, castSelf: Cast.asPyInterruptedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyInterruptedError.getDict, castSelf: Cast.asPyInterruptedError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyInterruptedError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyInterruptedError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - IsADirectoryError

  internal static func isADirectoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IsADirectoryError", doc: PyIsADirectoryError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIsADirectoryError.getClass, castSelf: Cast.asPyIsADirectoryError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIsADirectoryError.getDict, castSelf: Cast.asPyIsADirectoryError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyIsADirectoryError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyIsADirectoryError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - KeyError

  internal static func keyError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "KeyError", doc: PyKeyError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyKeyError.getClass, castSelf: Cast.asPyKeyError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyKeyError.getDict, castSelf: Cast.asPyKeyError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyKeyError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyKeyError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - KeyboardInterrupt

  internal static func keyboardInterrupt(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "KeyboardInterrupt", doc: PyKeyboardInterrupt.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyKeyboardInterrupt.getClass, castSelf: Cast.asPyKeyboardInterrupt)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyKeyboardInterrupt.getDict, castSelf: Cast.asPyKeyboardInterrupt)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyKeyboardInterrupt.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyKeyboardInterrupt.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - LookupError

  internal static func lookupError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "LookupError", doc: PyLookupError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyLookupError.getClass, castSelf: Cast.asPyLookupError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyLookupError.getDict, castSelf: Cast.asPyLookupError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyLookupError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyLookupError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - MemoryError

  internal static func memoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "MemoryError", doc: PyMemoryError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyMemoryError.getClass, castSelf: Cast.asPyMemoryError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyMemoryError.getDict, castSelf: Cast.asPyMemoryError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyMemoryError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyMemoryError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ModuleNotFoundError

  internal static func moduleNotFoundError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ModuleNotFoundError", doc: PyModuleNotFoundError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyModuleNotFoundError.getClass, castSelf: Cast.asPyModuleNotFoundError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyModuleNotFoundError.getDict, castSelf: Cast.asPyModuleNotFoundError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyModuleNotFoundError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyModuleNotFoundError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - NameError

  internal static func nameError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NameError", doc: PyNameError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNameError.getClass, castSelf: Cast.asPyNameError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNameError.getDict, castSelf: Cast.asPyNameError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyNameError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyNameError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - NotADirectoryError

  internal static func notADirectoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotADirectoryError", doc: PyNotADirectoryError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotADirectoryError.getClass, castSelf: Cast.asPyNotADirectoryError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNotADirectoryError.getDict, castSelf: Cast.asPyNotADirectoryError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyNotADirectoryError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyNotADirectoryError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - NotImplementedError

  internal static func notImplementedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedError", doc: PyNotImplementedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotImplementedError.getClass, castSelf: Cast.asPyNotImplementedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNotImplementedError.getDict, castSelf: Cast.asPyNotImplementedError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyNotImplementedError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyNotImplementedError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - OSError

  internal static func osError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "OSError", doc: PyOSError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyOSError.getClass, castSelf: Cast.asPyOSError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyOSError.getDict, castSelf: Cast.asPyOSError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyOSError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyOSError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - OverflowError

  internal static func overflowError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "OverflowError", doc: PyOverflowError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyOverflowError.getClass, castSelf: Cast.asPyOverflowError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyOverflowError.getDict, castSelf: Cast.asPyOverflowError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyOverflowError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyOverflowError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - PendingDeprecationWarning

  internal static func pendingDeprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "PendingDeprecationWarning", doc: PyPendingDeprecationWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyPendingDeprecationWarning.getClass, castSelf: Cast.asPyPendingDeprecationWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyPendingDeprecationWarning.getDict, castSelf: Cast.asPyPendingDeprecationWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyPendingDeprecationWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyPendingDeprecationWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - PermissionError

  internal static func permissionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "PermissionError", doc: PyPermissionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyPermissionError.getClass, castSelf: Cast.asPyPermissionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyPermissionError.getDict, castSelf: Cast.asPyPermissionError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyPermissionError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyPermissionError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ProcessLookupError

  internal static func processLookupError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ProcessLookupError", doc: PyProcessLookupError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyProcessLookupError.getClass, castSelf: Cast.asPyProcessLookupError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyProcessLookupError.getDict, castSelf: Cast.asPyProcessLookupError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyProcessLookupError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyProcessLookupError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - RecursionError

  internal static func recursionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RecursionError", doc: PyRecursionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRecursionError.getClass, castSelf: Cast.asPyRecursionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRecursionError.getDict, castSelf: Cast.asPyRecursionError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyRecursionError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyRecursionError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ReferenceError

  internal static func referenceError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ReferenceError", doc: PyReferenceError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyReferenceError.getClass, castSelf: Cast.asPyReferenceError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyReferenceError.getDict, castSelf: Cast.asPyReferenceError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyReferenceError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyReferenceError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ResourceWarning

  internal static func resourceWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ResourceWarning", doc: PyResourceWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyResourceWarning.getClass, castSelf: Cast.asPyResourceWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyResourceWarning.getDict, castSelf: Cast.asPyResourceWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyResourceWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyResourceWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - RuntimeError

  internal static func runtimeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RuntimeError", doc: PyRuntimeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRuntimeError.getClass, castSelf: Cast.asPyRuntimeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRuntimeError.getDict, castSelf: Cast.asPyRuntimeError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyRuntimeError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyRuntimeError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - RuntimeWarning

  internal static func runtimeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RuntimeWarning", doc: PyRuntimeWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRuntimeWarning.getClass, castSelf: Cast.asPyRuntimeWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRuntimeWarning.getDict, castSelf: Cast.asPyRuntimeWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyRuntimeWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyRuntimeWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - StopAsyncIteration

  internal static func stopAsyncIteration(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "StopAsyncIteration", doc: PyStopAsyncIteration.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyStopAsyncIteration.getClass, castSelf: Cast.asPyStopAsyncIteration)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyStopAsyncIteration.getDict, castSelf: Cast.asPyStopAsyncIteration)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyStopAsyncIteration.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyStopAsyncIteration.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - StopIteration

  internal static func stopIteration(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "StopIteration", doc: PyStopIteration.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyStopIteration.getClass, castSelf: Cast.asPyStopIteration)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyStopIteration.getDict, castSelf: Cast.asPyStopIteration)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyStopIteration.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyStopIteration.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - SyntaxError

  internal static func syntaxError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SyntaxError", doc: PySyntaxError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySyntaxError.getClass, castSelf: Cast.asPySyntaxError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySyntaxError.getDict, castSelf: Cast.asPySyntaxError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PySyntaxError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PySyntaxError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - SyntaxWarning

  internal static func syntaxWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SyntaxWarning", doc: PySyntaxWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySyntaxWarning.getClass, castSelf: Cast.asPySyntaxWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySyntaxWarning.getDict, castSelf: Cast.asPySyntaxWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PySyntaxWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PySyntaxWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - SystemError

  internal static func systemError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SystemError", doc: PySystemError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySystemError.getClass, castSelf: Cast.asPySystemError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySystemError.getDict, castSelf: Cast.asPySystemError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PySystemError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PySystemError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - SystemExit

  internal static func systemExit(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SystemExit", doc: PySystemExit.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySystemExit.getClass, castSelf: Cast.asPySystemExit)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySystemExit.getDict, castSelf: Cast.asPySystemExit)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PySystemExit.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PySystemExit.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - TabError

  internal static func tabError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TabError", doc: PyTabError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTabError.getClass, castSelf: Cast.asPyTabError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTabError.getDict, castSelf: Cast.asPyTabError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyTabError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyTabError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - TimeoutError

  internal static func timeoutError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TimeoutError", doc: PyTimeoutError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTimeoutError.getClass, castSelf: Cast.asPyTimeoutError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTimeoutError.getDict, castSelf: Cast.asPyTimeoutError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyTimeoutError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyTimeoutError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - TypeError

  internal static func typeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TypeError", doc: PyTypeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTypeError.getClass, castSelf: Cast.asPyTypeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTypeError.getDict, castSelf: Cast.asPyTypeError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyTypeError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyTypeError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - UnboundLocalError

  internal static func unboundLocalError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnboundLocalError", doc: PyUnboundLocalError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnboundLocalError.getClass, castSelf: Cast.asPyUnboundLocalError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnboundLocalError.getDict, castSelf: Cast.asPyUnboundLocalError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyUnboundLocalError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyUnboundLocalError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - UnicodeDecodeError

  internal static func unicodeDecodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeDecodeError", doc: PyUnicodeDecodeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeDecodeError.getClass, castSelf: Cast.asPyUnicodeDecodeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeDecodeError.getDict, castSelf: Cast.asPyUnicodeDecodeError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyUnicodeDecodeError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyUnicodeDecodeError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - UnicodeEncodeError

  internal static func unicodeEncodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeEncodeError", doc: PyUnicodeEncodeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeEncodeError.getClass, castSelf: Cast.asPyUnicodeEncodeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeEncodeError.getDict, castSelf: Cast.asPyUnicodeEncodeError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyUnicodeEncodeError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyUnicodeEncodeError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - UnicodeError

  internal static func unicodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeError", doc: PyUnicodeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeError.getClass, castSelf: Cast.asPyUnicodeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeError.getDict, castSelf: Cast.asPyUnicodeError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyUnicodeError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyUnicodeError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - UnicodeTranslateError

  internal static func unicodeTranslateError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeTranslateError", doc: PyUnicodeTranslateError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeTranslateError.getClass, castSelf: Cast.asPyUnicodeTranslateError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeTranslateError.getDict, castSelf: Cast.asPyUnicodeTranslateError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyUnicodeTranslateError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyUnicodeTranslateError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - UnicodeWarning

  internal static func unicodeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeWarning", doc: PyUnicodeWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeWarning.getClass, castSelf: Cast.asPyUnicodeWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeWarning.getDict, castSelf: Cast.asPyUnicodeWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyUnicodeWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyUnicodeWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - UserWarning

  internal static func userWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UserWarning", doc: PyUserWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUserWarning.getClass, castSelf: Cast.asPyUserWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUserWarning.getDict, castSelf: Cast.asPyUserWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyUserWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyUserWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ValueError

  internal static func valueError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ValueError", doc: PyValueError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyValueError.getClass, castSelf: Cast.asPyValueError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyValueError.getDict, castSelf: Cast.asPyValueError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyValueError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyValueError.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - Warning

  internal static func warning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "Warning", doc: PyWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyWarning.getClass, castSelf: Cast.asPyWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyWarning.getDict, castSelf: Cast.asPyWarning)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyWarning.pyInit(zelf:args:kwargs:))

    return result
  }

  // MARK: - ZeroDivisionError

  internal static func zeroDivisionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ZeroDivisionError", doc: PyZeroDivisionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyZeroDivisionError.getClass, castSelf: Cast.asPyZeroDivisionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyZeroDivisionError.getDict, castSelf: Cast.asPyZeroDivisionError)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyZeroDivisionError.pyNew(type:args:kwargs:))
    dict["__init__"] = wrapInit(context, typeName: "__init__", doc: nil, fn: PyZeroDivisionError.pyInit(zelf:args:kwargs:))

    return result
  }
}
