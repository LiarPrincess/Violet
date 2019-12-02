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
    let result = PyType.initWithoutType(context, name: "object", doc: PyBaseObject.doc, base: nil)
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


    return result
  }

  // MARK: - Type type

  /// Create `type` type without assigning `type` property.
  internal static func typeWithoutType(_ context: PyContext, base: PyType) -> PyType {
    let result = PyType.initWithoutType(context, name: "type", doc: PyType.doc, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)
    result.setFlag(.typeSubclass)

    let dict = result.getDict()
    dict["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyType.getName, set: PyType.setName, castSelf: selfAsPyType)
    dict["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyType.getQualname, set: PyType.setQualname, castSelf: selfAsPyType)
    dict["__doc__"] = createProperty(context, name: "__doc__", doc: nil, get: PyType.getDoc, set: PyType.setDoc, castSelf: selfAsPyType)
    dict["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyType.getModule, set: PyType.setModule, castSelf: selfAsPyType)
    dict["__bases__"] = createProperty(context, name: "__bases__", doc: nil, get: PyType.getBases, set: PyType.setBases, castSelf: selfAsPyType)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyType.getDict, castSelf: selfAsPyType)
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyType.getClass, castSelf: selfAsPyType)
    dict["__mro__"] = createProperty(context, name: "__mro__", doc: nil, get: PyType.getMRO, castSelf: selfAsPyType)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyType.repr, castSelf: selfAsPyType)
    dict["__subclasses__"] = wrapMethod(context, name: "__subclasses__", doc: nil, fn: PyType.getSubclasses, castSelf: selfAsPyType)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyType.getAttribute(name:), castSelf: selfAsPyType)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyType.setAttribute(name:value:), castSelf: selfAsPyType)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyType.delAttribute(name:), castSelf: selfAsPyType)
    dict["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, fn: PyType.dir, castSelf: selfAsPyType)
    dict["__call__"] = wrapMethod(context, name: "__call__", doc: nil, fn: PyType.call(args:kwargs:), castSelf: selfAsPyType)
    return result
  }

  // MARK: - Bool

  internal static func bool(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "bool", doc: PyBool.doc, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBool.getClass, castSelf: selfAsPyBool)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyBool.new(type:args:kwargs:))

    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyBool.repr, castSelf: selfAsPyBool)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyBool.str, castSelf: selfAsPyBool)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PyBool.and(_:), castSelf: selfAsPyBool)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PyBool.rand(_:), castSelf: selfAsPyBool)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PyBool.or(_:), castSelf: selfAsPyBool)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PyBool.ror(_:), castSelf: selfAsPyBool)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PyBool.xor(_:), castSelf: selfAsPyBool)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PyBool.rxor(_:), castSelf: selfAsPyBool)
    return result
  }

  // MARK: - BuiltinFunction

  internal static func builtinFunction(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "builtinFunction", doc: nil, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBuiltinFunction.getClass, castSelf: selfAsPyBuiltinFunction)
    dict["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyBuiltinFunction.getName, castSelf: selfAsPyBuiltinFunction)
    dict["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyBuiltinFunction.getQualname, castSelf: selfAsPyBuiltinFunction)
    dict["__text_signature__"] = createProperty(context, name: "__text_signature__", doc: nil, get: PyBuiltinFunction.getTextSignature, castSelf: selfAsPyBuiltinFunction)
    dict["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyBuiltinFunction.getModule, castSelf: selfAsPyBuiltinFunction)
    dict["__self__"] = createProperty(context, name: "__self__", doc: nil, get: PyBuiltinFunction.getSelf, castSelf: selfAsPyBuiltinFunction)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyBuiltinFunction.isEqual(_:), castSelf: selfAsPyBuiltinFunction)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyBuiltinFunction.isNotEqual(_:), castSelf: selfAsPyBuiltinFunction)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyBuiltinFunction.isLess(_:), castSelf: selfAsPyBuiltinFunction)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyBuiltinFunction.isLessEqual(_:), castSelf: selfAsPyBuiltinFunction)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyBuiltinFunction.isGreater(_:), castSelf: selfAsPyBuiltinFunction)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyBuiltinFunction.isGreaterEqual(_:), castSelf: selfAsPyBuiltinFunction)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyBuiltinFunction.hash, castSelf: selfAsPyBuiltinFunction)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyBuiltinFunction.repr, castSelf: selfAsPyBuiltinFunction)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyBuiltinFunction.getAttribute(name:), castSelf: selfAsPyBuiltinFunction)
    dict["__call__"] = wrapMethod(context, name: "__call__", doc: nil, fn: PyBuiltinFunction.call(args:kwargs:), castSelf: selfAsPyBuiltinFunction)
    return result
  }

  // MARK: - Code

  internal static func code(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "code", doc: PyCode.doc, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyCode.getClass, castSelf: selfAsPyCode)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyCode.isEqual(_:), castSelf: selfAsPyCode)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyCode.isLess(_:), castSelf: selfAsPyCode)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyCode.isLessEqual(_:), castSelf: selfAsPyCode)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyCode.isGreater(_:), castSelf: selfAsPyCode)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyCode.isGreaterEqual(_:), castSelf: selfAsPyCode)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyCode.hash, castSelf: selfAsPyCode)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyCode.repr, castSelf: selfAsPyCode)
    return result
  }

  // MARK: - Complex

  internal static func complex(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "complex", doc: PyComplex.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyComplex.getClass, castSelf: selfAsPyComplex)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyComplex.isEqual(_:), castSelf: selfAsPyComplex)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyComplex.isNotEqual(_:), castSelf: selfAsPyComplex)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyComplex.isLess(_:), castSelf: selfAsPyComplex)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyComplex.isLessEqual(_:), castSelf: selfAsPyComplex)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyComplex.isGreater(_:), castSelf: selfAsPyComplex)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyComplex.isGreaterEqual(_:), castSelf: selfAsPyComplex)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyComplex.hash, castSelf: selfAsPyComplex)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyComplex.repr, castSelf: selfAsPyComplex)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyComplex.str, castSelf: selfAsPyComplex)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyComplex.asBool, castSelf: selfAsPyComplex)
    dict["__int__"] = wrapMethod(context, name: "__int__", doc: nil, fn: PyComplex.asInt, castSelf: selfAsPyComplex)
    dict["__float__"] = wrapMethod(context, name: "__float__", doc: nil, fn: PyComplex.asFloat, castSelf: selfAsPyComplex)
    dict["real"] = wrapMethod(context, name: "real", doc: nil, fn: PyComplex.asReal, castSelf: selfAsPyComplex)
    dict["imag"] = wrapMethod(context, name: "imag", doc: nil, fn: PyComplex.asImag, castSelf: selfAsPyComplex)
    dict["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, fn: PyComplex.conjugate, castSelf: selfAsPyComplex)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyComplex.getAttribute(name:), castSelf: selfAsPyComplex)
    dict["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, fn: PyComplex.positive, castSelf: selfAsPyComplex)
    dict["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, fn: PyComplex.negative, castSelf: selfAsPyComplex)
    dict["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, fn: PyComplex.abs, castSelf: selfAsPyComplex)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyComplex.add(_:), castSelf: selfAsPyComplex)
    dict["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, fn: PyComplex.radd(_:), castSelf: selfAsPyComplex)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyComplex.sub(_:), castSelf: selfAsPyComplex)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyComplex.rsub(_:), castSelf: selfAsPyComplex)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyComplex.mul(_:), castSelf: selfAsPyComplex)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyComplex.rmul(_:), castSelf: selfAsPyComplex)
    dict["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, fn: PyComplex.pow(_:), castSelf: selfAsPyComplex)
    dict["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, fn: PyComplex.rpow(_:), castSelf: selfAsPyComplex)
    dict["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, fn: PyComplex.truediv(_:), castSelf: selfAsPyComplex)
    dict["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, fn: PyComplex.rtruediv(_:), castSelf: selfAsPyComplex)
    dict["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, fn: PyComplex.floordiv(_:), castSelf: selfAsPyComplex)
    dict["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, fn: PyComplex.rfloordiv(_:), castSelf: selfAsPyComplex)
    dict["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, fn: PyComplex.mod(_:), castSelf: selfAsPyComplex)
    dict["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, fn: PyComplex.rmod(_:), castSelf: selfAsPyComplex)
    dict["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, fn: PyComplex.divmod(_:), castSelf: selfAsPyComplex)
    dict["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, fn: PyComplex.rdivmod(_:), castSelf: selfAsPyComplex)
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
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDict.getClass, castSelf: selfAsPyDict)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyDict.isEqual(_:), castSelf: selfAsPyDict)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyDict.isNotEqual(_:), castSelf: selfAsPyDict)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyDict.isLess(_:), castSelf: selfAsPyDict)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyDict.isLessEqual(_:), castSelf: selfAsPyDict)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyDict.isGreater(_:), castSelf: selfAsPyDict)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyDict.isGreaterEqual(_:), castSelf: selfAsPyDict)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyDict.hash, castSelf: selfAsPyDict)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyDict.repr, castSelf: selfAsPyDict)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyDict.getAttribute(name:), castSelf: selfAsPyDict)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyDict.getLength, castSelf: selfAsPyDict)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyDict.getItem(at:), castSelf: selfAsPyDict)
    dict["__setitem__"] = wrapMethod(context, name: "__setitem__", doc: nil, fn: PyDict.setItem(at:to:), castSelf: selfAsPyDict)
    dict["__delitem__"] = wrapMethod(context, name: "__delitem__", doc: nil, fn: PyDict.delItem(at:), castSelf: selfAsPyDict)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyDict.contains(_:), castSelf: selfAsPyDict)
    dict["clear"] = wrapMethod(context, name: "clear", doc: nil, fn: PyDict.clear, castSelf: selfAsPyDict)
    dict["get"] = wrapMethod(context, name: "get", doc: nil, fn: PyDict.get(_:default:), castSelf: selfAsPyDict)
    dict["setdefault"] = wrapMethod(context, name: "setdefault", doc: nil, fn: PyDict.setDefault(_:default:), castSelf: selfAsPyDict)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PyDict.copy, castSelf: selfAsPyDict)
    dict["pop"] = wrapMethod(context, name: "pop", doc: nil, fn: PyDict.pop(_:default:), castSelf: selfAsPyDict)
    dict["popitem"] = wrapMethod(context, name: "popitem", doc: nil, fn: PyDict.popitem, castSelf: selfAsPyDict)
    return result
  }

  // MARK: - Ellipsis

  internal static func ellipsis(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ellipsis", doc: nil, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyEllipsis.getClass, castSelf: selfAsPyEllipsis)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyEllipsis.repr, castSelf: selfAsPyEllipsis)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyEllipsis.getAttribute(name:), castSelf: selfAsPyEllipsis)
    return result
  }

  // MARK: - Float

  internal static func float(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "float", doc: PyFloat.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFloat.getClass, castSelf: selfAsPyFloat)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyFloat.isEqual(_:), castSelf: selfAsPyFloat)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyFloat.isNotEqual(_:), castSelf: selfAsPyFloat)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyFloat.isLess(_:), castSelf: selfAsPyFloat)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyFloat.isLessEqual(_:), castSelf: selfAsPyFloat)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyFloat.isGreater(_:), castSelf: selfAsPyFloat)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyFloat.isGreaterEqual(_:), castSelf: selfAsPyFloat)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyFloat.hash, castSelf: selfAsPyFloat)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyFloat.repr, castSelf: selfAsPyFloat)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyFloat.str, castSelf: selfAsPyFloat)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyFloat.asBool, castSelf: selfAsPyFloat)
    dict["__int__"] = wrapMethod(context, name: "__int__", doc: nil, fn: PyFloat.asInt, castSelf: selfAsPyFloat)
    dict["__float__"] = wrapMethod(context, name: "__float__", doc: nil, fn: PyFloat.asFloat, castSelf: selfAsPyFloat)
    dict["real"] = wrapMethod(context, name: "real", doc: nil, fn: PyFloat.asReal, castSelf: selfAsPyFloat)
    dict["imag"] = wrapMethod(context, name: "imag", doc: nil, fn: PyFloat.asImag, castSelf: selfAsPyFloat)
    dict["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, fn: PyFloat.conjugate, castSelf: selfAsPyFloat)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyFloat.getAttribute(name:), castSelf: selfAsPyFloat)
    dict["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, fn: PyFloat.positive, castSelf: selfAsPyFloat)
    dict["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, fn: PyFloat.negative, castSelf: selfAsPyFloat)
    dict["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, fn: PyFloat.abs, castSelf: selfAsPyFloat)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyFloat.add(_:), castSelf: selfAsPyFloat)
    dict["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, fn: PyFloat.radd(_:), castSelf: selfAsPyFloat)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyFloat.sub(_:), castSelf: selfAsPyFloat)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyFloat.rsub(_:), castSelf: selfAsPyFloat)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyFloat.mul(_:), castSelf: selfAsPyFloat)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyFloat.rmul(_:), castSelf: selfAsPyFloat)
    dict["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, fn: PyFloat.pow(_:), castSelf: selfAsPyFloat)
    dict["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, fn: PyFloat.rpow(_:), castSelf: selfAsPyFloat)
    dict["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, fn: PyFloat.truediv(_:), castSelf: selfAsPyFloat)
    dict["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, fn: PyFloat.rtruediv(_:), castSelf: selfAsPyFloat)
    dict["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, fn: PyFloat.floordiv(_:), castSelf: selfAsPyFloat)
    dict["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, fn: PyFloat.rfloordiv(_:), castSelf: selfAsPyFloat)
    dict["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, fn: PyFloat.mod(_:), castSelf: selfAsPyFloat)
    dict["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, fn: PyFloat.rmod(_:), castSelf: selfAsPyFloat)
    dict["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, fn: PyFloat.divmod(_:), castSelf: selfAsPyFloat)
    dict["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, fn: PyFloat.rdivmod(_:), castSelf: selfAsPyFloat)
    dict["__round__"] = wrapMethod(context, name: "__round__", doc: nil, fn: PyFloat.round(nDigits:), castSelf: selfAsPyFloat)
    dict["__trunc__"] = wrapMethod(context, name: "__trunc__", doc: nil, fn: PyFloat.trunc, castSelf: selfAsPyFloat)
    return result
  }

  // MARK: - FrozenSet

  internal static func frozenset(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "frozenset", doc: PyFrozenSet.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFrozenSet.getClass, castSelf: selfAsPyFrozenSet)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyFrozenSet.isEqual(_:), castSelf: selfAsPyFrozenSet)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyFrozenSet.isNotEqual(_:), castSelf: selfAsPyFrozenSet)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyFrozenSet.isLess(_:), castSelf: selfAsPyFrozenSet)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyFrozenSet.isLessEqual(_:), castSelf: selfAsPyFrozenSet)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyFrozenSet.isGreater(_:), castSelf: selfAsPyFrozenSet)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyFrozenSet.isGreaterEqual(_:), castSelf: selfAsPyFrozenSet)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyFrozenSet.hash, castSelf: selfAsPyFrozenSet)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyFrozenSet.repr, castSelf: selfAsPyFrozenSet)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyFrozenSet.getAttribute(name:), castSelf: selfAsPyFrozenSet)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyFrozenSet.getLength, castSelf: selfAsPyFrozenSet)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyFrozenSet.contains(_:), castSelf: selfAsPyFrozenSet)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PyFrozenSet.and(_:), castSelf: selfAsPyFrozenSet)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PyFrozenSet.rand(_:), castSelf: selfAsPyFrozenSet)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PyFrozenSet.or(_:), castSelf: selfAsPyFrozenSet)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PyFrozenSet.ror(_:), castSelf: selfAsPyFrozenSet)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PyFrozenSet.xor(_:), castSelf: selfAsPyFrozenSet)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PyFrozenSet.rxor(_:), castSelf: selfAsPyFrozenSet)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyFrozenSet.sub(_:), castSelf: selfAsPyFrozenSet)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyFrozenSet.rsub(_:), castSelf: selfAsPyFrozenSet)
    dict["issubset"] = wrapMethod(context, name: "issubset", doc: nil, fn: PyFrozenSet.isSubset(of:), castSelf: selfAsPyFrozenSet)
    dict["issuperset"] = wrapMethod(context, name: "issuperset", doc: nil, fn: PyFrozenSet.isSuperset(of:), castSelf: selfAsPyFrozenSet)
    dict["intersection"] = wrapMethod(context, name: "intersection", doc: nil, fn: PyFrozenSet.intersection(with:), castSelf: selfAsPyFrozenSet)
    dict["union"] = wrapMethod(context, name: "union", doc: nil, fn: PyFrozenSet.union(with:), castSelf: selfAsPyFrozenSet)
    dict["difference"] = wrapMethod(context, name: "difference", doc: nil, fn: PyFrozenSet.difference(with:), castSelf: selfAsPyFrozenSet)
    dict["symmetric_difference"] = wrapMethod(context, name: "symmetric_difference", doc: nil, fn: PyFrozenSet.symmetricDifference(with:), castSelf: selfAsPyFrozenSet)
    dict["isdisjoint"] = wrapMethod(context, name: "isdisjoint", doc: nil, fn: PyFrozenSet.isDisjoint(with:), castSelf: selfAsPyFrozenSet)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PyFrozenSet.copy, castSelf: selfAsPyFrozenSet)
    return result
  }

  // MARK: - Function

  internal static func function(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "function", doc: PyFunction.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFunction.getClass, castSelf: selfAsPyFunction)
    dict["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyFunction.getName, set: PyFunction.setName, castSelf: selfAsPyFunction)
    dict["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyFunction.getQualname, set: PyFunction.setQualname, castSelf: selfAsPyFunction)
    dict["__code__"] = createProperty(context, name: "__code__", doc: nil, get: PyFunction.getCode, castSelf: selfAsPyFunction)
    dict["__doc__"] = createProperty(context, name: "__doc__", doc: nil, get: PyFunction.getDoc, castSelf: selfAsPyFunction)
    dict["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyFunction.getModule, castSelf: selfAsPyFunction)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFunction.getDict, castSelf: selfAsPyFunction)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyFunction.repr, castSelf: selfAsPyFunction)
    dict["__get__"] = wrapMethod(context, name: "__get__", doc: nil, fn: PyFunction.get(object:), castSelf: selfAsPyFunction)
    return result
  }

  // MARK: - Int

  internal static func int(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "int", doc: PyInt.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.longSubclass)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyInt.getClass, castSelf: selfAsPyInt)


    dict["__new__"] = wrapNew(context, typeName: "__new__", doc: nil, fn: PyInt.new(type:args:kwargs:))

    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyInt.isEqual(_:), castSelf: selfAsPyInt)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyInt.isNotEqual(_:), castSelf: selfAsPyInt)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyInt.isLess(_:), castSelf: selfAsPyInt)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyInt.isLessEqual(_:), castSelf: selfAsPyInt)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyInt.isGreater(_:), castSelf: selfAsPyInt)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyInt.isGreaterEqual(_:), castSelf: selfAsPyInt)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyInt.hash, castSelf: selfAsPyInt)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyInt.repr, castSelf: selfAsPyInt)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyInt.str, castSelf: selfAsPyInt)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyInt.asBool, castSelf: selfAsPyInt)
    dict["__int__"] = wrapMethod(context, name: "__int__", doc: nil, fn: PyInt.asInt, castSelf: selfAsPyInt)
    dict["__float__"] = wrapMethod(context, name: "__float__", doc: nil, fn: PyInt.asFloat, castSelf: selfAsPyInt)
    dict["__index__"] = wrapMethod(context, name: "__index__", doc: nil, fn: PyInt.asIndex, castSelf: selfAsPyInt)
    dict["real"] = wrapMethod(context, name: "real", doc: nil, fn: PyInt.asReal, castSelf: selfAsPyInt)
    dict["imag"] = wrapMethod(context, name: "imag", doc: nil, fn: PyInt.asImag, castSelf: selfAsPyInt)
    dict["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, fn: PyInt.conjugate, castSelf: selfAsPyInt)
    dict["numerator"] = wrapMethod(context, name: "numerator", doc: nil, fn: PyInt.numerator, castSelf: selfAsPyInt)
    dict["denominator"] = wrapMethod(context, name: "denominator", doc: nil, fn: PyInt.denominator, castSelf: selfAsPyInt)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyInt.getAttribute(name:), castSelf: selfAsPyInt)
    dict["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, fn: PyInt.positive, castSelf: selfAsPyInt)
    dict["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, fn: PyInt.negative, castSelf: selfAsPyInt)
    dict["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, fn: PyInt.abs, castSelf: selfAsPyInt)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyInt.add(_:), castSelf: selfAsPyInt)
    dict["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, fn: PyInt.radd(_:), castSelf: selfAsPyInt)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PyInt.sub(_:), castSelf: selfAsPyInt)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PyInt.rsub(_:), castSelf: selfAsPyInt)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyInt.mul(_:), castSelf: selfAsPyInt)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyInt.rmul(_:), castSelf: selfAsPyInt)
    dict["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, fn: PyInt.pow(_:), castSelf: selfAsPyInt)
    dict["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, fn: PyInt.rpow(_:), castSelf: selfAsPyInt)
    dict["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, fn: PyInt.truediv(_:), castSelf: selfAsPyInt)
    dict["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, fn: PyInt.rtruediv(_:), castSelf: selfAsPyInt)
    dict["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, fn: PyInt.floordiv(_:), castSelf: selfAsPyInt)
    dict["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, fn: PyInt.rfloordiv(_:), castSelf: selfAsPyInt)
    dict["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, fn: PyInt.mod(_:), castSelf: selfAsPyInt)
    dict["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, fn: PyInt.rmod(_:), castSelf: selfAsPyInt)
    dict["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, fn: PyInt.divmod(_:), castSelf: selfAsPyInt)
    dict["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, fn: PyInt.rdivmod(_:), castSelf: selfAsPyInt)
    dict["__lshift__"] = wrapMethod(context, name: "__lshift__", doc: nil, fn: PyInt.lshift(_:), castSelf: selfAsPyInt)
    dict["__rlshift__"] = wrapMethod(context, name: "__rlshift__", doc: nil, fn: PyInt.rlshift(_:), castSelf: selfAsPyInt)
    dict["__rshift__"] = wrapMethod(context, name: "__rshift__", doc: nil, fn: PyInt.rshift(_:), castSelf: selfAsPyInt)
    dict["__rrshift__"] = wrapMethod(context, name: "__rrshift__", doc: nil, fn: PyInt.rrshift(_:), castSelf: selfAsPyInt)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PyInt.and(_:), castSelf: selfAsPyInt)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PyInt.rand(_:), castSelf: selfAsPyInt)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PyInt.or(_:), castSelf: selfAsPyInt)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PyInt.ror(_:), castSelf: selfAsPyInt)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PyInt.xor(_:), castSelf: selfAsPyInt)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PyInt.rxor(_:), castSelf: selfAsPyInt)
    dict["__invert__"] = wrapMethod(context, name: "__invert__", doc: nil, fn: PyInt.invert, castSelf: selfAsPyInt)
    dict["__round__"] = wrapMethod(context, name: "__round__", doc: nil, fn: PyInt.round(nDigits:), castSelf: selfAsPyInt)
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
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyList.getClass, castSelf: selfAsPyList)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyList.isEqual(_:), castSelf: selfAsPyList)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyList.isNotEqual(_:), castSelf: selfAsPyList)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyList.isLess(_:), castSelf: selfAsPyList)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyList.isLessEqual(_:), castSelf: selfAsPyList)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyList.isGreater(_:), castSelf: selfAsPyList)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyList.isGreaterEqual(_:), castSelf: selfAsPyList)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyList.repr, castSelf: selfAsPyList)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyList.getAttribute(name:), castSelf: selfAsPyList)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyList.getLength, castSelf: selfAsPyList)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyList.contains(_:), castSelf: selfAsPyList)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyList.getItem(at:), castSelf: selfAsPyList)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyList.count(_:), castSelf: selfAsPyList)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyList.index(of:), castSelf: selfAsPyList)
    dict["append"] = wrapMethod(context, name: "append", doc: nil, fn: PyList.append(_:), castSelf: selfAsPyList)
    dict["pop"] = wrapMethod(context, name: "pop", doc: nil, fn: PyList.pop(index:), castSelf: selfAsPyList)
    dict["clear"] = wrapMethod(context, name: "clear", doc: nil, fn: PyList.clear, castSelf: selfAsPyList)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PyList.copy, castSelf: selfAsPyList)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyList.add(_:), castSelf: selfAsPyList)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyList.mul(_:), castSelf: selfAsPyList)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyList.rmul(_:), castSelf: selfAsPyList)
    dict["__imul__"] = wrapMethod(context, name: "__imul__", doc: nil, fn: PyList.imul(_:), castSelf: selfAsPyList)
    return result
  }

  // MARK: - Method

  internal static func method(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "method", doc: PyMethod.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyMethod.getClass, castSelf: selfAsPyMethod)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyMethod.isEqual(_:), castSelf: selfAsPyMethod)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyMethod.isNotEqual(_:), castSelf: selfAsPyMethod)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyMethod.isLess(_:), castSelf: selfAsPyMethod)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyMethod.isLessEqual(_:), castSelf: selfAsPyMethod)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyMethod.isGreater(_:), castSelf: selfAsPyMethod)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyMethod.isGreaterEqual(_:), castSelf: selfAsPyMethod)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyMethod.repr, castSelf: selfAsPyMethod)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyMethod.hash, castSelf: selfAsPyMethod)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyMethod.getAttribute(name:), castSelf: selfAsPyMethod)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyMethod.setAttribute(name:value:), castSelf: selfAsPyMethod)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyMethod.delAttribute(name:), castSelf: selfAsPyMethod)
    dict["__func__"] = wrapMethod(context, name: "__func__", doc: nil, fn: PyMethod.getFunc, castSelf: selfAsPyMethod)
    dict["__self__"] = wrapMethod(context, name: "__self__", doc: nil, fn: PyMethod.getSelf, castSelf: selfAsPyMethod)
    dict["__get__"] = wrapMethod(context, name: "__get__", doc: nil, fn: PyMethod.get(object:), castSelf: selfAsPyMethod)
    return result
  }

  // MARK: - Module

  internal static func module(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "module", doc: PyModule.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyModule.getDict, castSelf: selfAsPyModule)
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyModule.getClass, castSelf: selfAsPyModule)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyModule.repr, castSelf: selfAsPyModule)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyModule.getAttribute(name:), castSelf: selfAsPyModule)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyModule.setAttribute(name:value:), castSelf: selfAsPyModule)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyModule.delAttribute(name:), castSelf: selfAsPyModule)
    dict["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, fn: PyModule.dir, castSelf: selfAsPyModule)
    return result
  }

  // MARK: - Namespace

  internal static func simpleNamespace(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "types.SimpleNamespace", doc: PyNamespace.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNamespace.getDict, castSelf: selfAsPyNamespace)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyNamespace.isEqual(_:), castSelf: selfAsPyNamespace)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyNamespace.isNotEqual(_:), castSelf: selfAsPyNamespace)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyNamespace.isLess(_:), castSelf: selfAsPyNamespace)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyNamespace.isLessEqual(_:), castSelf: selfAsPyNamespace)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyNamespace.isGreater(_:), castSelf: selfAsPyNamespace)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyNamespace.isGreaterEqual(_:), castSelf: selfAsPyNamespace)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyNamespace.repr, castSelf: selfAsPyNamespace)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyNamespace.getAttribute(name:), castSelf: selfAsPyNamespace)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyNamespace.setAttribute(name:value:), castSelf: selfAsPyNamespace)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyNamespace.delAttribute(name:), castSelf: selfAsPyNamespace)
    return result
  }

  // MARK: - None

  internal static func none(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NoneType", doc: nil, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNone.getClass, castSelf: selfAsPyNone)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyNone.repr, castSelf: selfAsPyNone)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyNone.asBool, castSelf: selfAsPyNone)
    return result
  }

  // MARK: - NotImplemented

  internal static func notImplemented(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedType", doc: nil, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotImplemented.getClass, castSelf: selfAsPyNotImplemented)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyNotImplemented.repr, castSelf: selfAsPyNotImplemented)
    return result
  }

  // MARK: - Property

  internal static func property(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "property", doc: PyProperty.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyProperty.getClass, castSelf: selfAsPyProperty)
    dict["fget"] = createProperty(context, name: "fget", doc: nil, get: PyProperty.getFGet, castSelf: selfAsPyProperty)
    dict["fset"] = createProperty(context, name: "fset", doc: nil, get: PyProperty.getFSet, castSelf: selfAsPyProperty)
    dict["fdel"] = createProperty(context, name: "fdel", doc: nil, get: PyProperty.getFDel, castSelf: selfAsPyProperty)



    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyProperty.getAttribute(name:), castSelf: selfAsPyProperty)
    dict["__get__"] = wrapMethod(context, name: "__get__", doc: nil, fn: PyProperty.get(object:), castSelf: selfAsPyProperty)
    dict["__set__"] = wrapMethod(context, name: "__set__", doc: nil, fn: PyProperty.set(object:value:), castSelf: selfAsPyProperty)
    dict["__delete__"] = wrapMethod(context, name: "__delete__", doc: nil, fn: PyProperty.del(object:), castSelf: selfAsPyProperty)
    return result
  }

  // MARK: - Range

  internal static func range(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "range", doc: PyRange.doc, type: type, base: base)
    result.setFlag(.default)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRange.getClass, castSelf: selfAsPyRange)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyRange.isEqual(_:), castSelf: selfAsPyRange)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyRange.isNotEqual(_:), castSelf: selfAsPyRange)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyRange.isLess(_:), castSelf: selfAsPyRange)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyRange.isLessEqual(_:), castSelf: selfAsPyRange)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyRange.isGreater(_:), castSelf: selfAsPyRange)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyRange.isGreaterEqual(_:), castSelf: selfAsPyRange)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyRange.hash, castSelf: selfAsPyRange)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyRange.repr, castSelf: selfAsPyRange)
    dict["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, fn: PyRange.asBool, castSelf: selfAsPyRange)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyRange.getLength, castSelf: selfAsPyRange)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyRange.getAttribute(name:), castSelf: selfAsPyRange)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyRange.contains(_:), castSelf: selfAsPyRange)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyRange.getItem(at:), castSelf: selfAsPyRange)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyRange.count(_:), castSelf: selfAsPyRange)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyRange.index(of:), castSelf: selfAsPyRange)
    return result
  }

  // MARK: - Set

  internal static func set(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "set", doc: PySet.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySet.getClass, castSelf: selfAsPySet)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PySet.isEqual(_:), castSelf: selfAsPySet)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PySet.isNotEqual(_:), castSelf: selfAsPySet)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PySet.isLess(_:), castSelf: selfAsPySet)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PySet.isLessEqual(_:), castSelf: selfAsPySet)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PySet.isGreater(_:), castSelf: selfAsPySet)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PySet.isGreaterEqual(_:), castSelf: selfAsPySet)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PySet.hash, castSelf: selfAsPySet)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PySet.repr, castSelf: selfAsPySet)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PySet.getAttribute(name:), castSelf: selfAsPySet)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PySet.getLength, castSelf: selfAsPySet)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PySet.contains(_:), castSelf: selfAsPySet)
    dict["__and__"] = wrapMethod(context, name: "__and__", doc: nil, fn: PySet.and(_:), castSelf: selfAsPySet)
    dict["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, fn: PySet.rand(_:), castSelf: selfAsPySet)
    dict["__or__"] = wrapMethod(context, name: "__or__", doc: nil, fn: PySet.or(_:), castSelf: selfAsPySet)
    dict["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, fn: PySet.ror(_:), castSelf: selfAsPySet)
    dict["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, fn: PySet.xor(_:), castSelf: selfAsPySet)
    dict["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, fn: PySet.rxor(_:), castSelf: selfAsPySet)
    dict["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, fn: PySet.sub(_:), castSelf: selfAsPySet)
    dict["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, fn: PySet.rsub(_:), castSelf: selfAsPySet)
    dict["issubset"] = wrapMethod(context, name: "issubset", doc: nil, fn: PySet.isSubset(of:), castSelf: selfAsPySet)
    dict["issuperset"] = wrapMethod(context, name: "issuperset", doc: nil, fn: PySet.isSuperset(of:), castSelf: selfAsPySet)
    dict["intersection"] = wrapMethod(context, name: "intersection", doc: nil, fn: PySet.intersection(with:), castSelf: selfAsPySet)
    dict["union"] = wrapMethod(context, name: "union", doc: nil, fn: PySet.union(with:), castSelf: selfAsPySet)
    dict["difference"] = wrapMethod(context, name: "difference", doc: nil, fn: PySet.difference(with:), castSelf: selfAsPySet)
    dict["symmetric_difference"] = wrapMethod(context, name: "symmetric_difference", doc: nil, fn: PySet.symmetricDifference(with:), castSelf: selfAsPySet)
    dict["isdisjoint"] = wrapMethod(context, name: "isdisjoint", doc: nil, fn: PySet.isDisjoint(with:), castSelf: selfAsPySet)
    dict["add"] = wrapMethod(context, name: "add", doc: nil, fn: PySet.add(_:), castSelf: selfAsPySet)
    dict["remove"] = wrapMethod(context, name: "remove", doc: nil, fn: PySet.remove(_:), castSelf: selfAsPySet)
    dict["discard"] = wrapMethod(context, name: "discard", doc: nil, fn: PySet.discard(_:), castSelf: selfAsPySet)
    dict["clear"] = wrapMethod(context, name: "clear", doc: nil, fn: PySet.clear, castSelf: selfAsPySet)
    dict["copy"] = wrapMethod(context, name: "copy", doc: nil, fn: PySet.copy, castSelf: selfAsPySet)
    dict["pop"] = wrapMethod(context, name: "pop", doc: nil, fn: PySet.pop, castSelf: selfAsPySet)
    return result
  }

  // MARK: - Slice

  internal static func slice(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "slice", doc: PySlice.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySlice.getClass, castSelf: selfAsPySlice)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PySlice.isEqual(_:), castSelf: selfAsPySlice)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PySlice.isNotEqual(_:), castSelf: selfAsPySlice)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PySlice.isLess(_:), castSelf: selfAsPySlice)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PySlice.isLessEqual(_:), castSelf: selfAsPySlice)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PySlice.isGreater(_:), castSelf: selfAsPySlice)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PySlice.isGreaterEqual(_:), castSelf: selfAsPySlice)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PySlice.repr, castSelf: selfAsPySlice)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PySlice.getAttribute(name:), castSelf: selfAsPySlice)
    dict["indices"] = wrapMethod(context, name: "indices", doc: nil, fn: PySlice.indicesInSequence(length:), castSelf: selfAsPySlice)
    return result
  }

  // MARK: - String

  internal static func str(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "str", doc: PyString.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.unicodeSubclass)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyString.getClass, castSelf: selfAsPyString)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyString.isEqual(_:), castSelf: selfAsPyString)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyString.isNotEqual(_:), castSelf: selfAsPyString)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyString.isLess(_:), castSelf: selfAsPyString)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyString.isLessEqual(_:), castSelf: selfAsPyString)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyString.isGreater(_:), castSelf: selfAsPyString)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyString.isGreaterEqual(_:), castSelf: selfAsPyString)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyString.hash, castSelf: selfAsPyString)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyString.repr, castSelf: selfAsPyString)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyString.str, castSelf: selfAsPyString)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyString.getAttribute(name:), castSelf: selfAsPyString)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyString.getLength, castSelf: selfAsPyString)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyString.contains(_:), castSelf: selfAsPyString)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyString.getItem(at:), castSelf: selfAsPyString)
    dict["isalnum"] = wrapMethod(context, name: "isalnum", doc: nil, fn: PyString.isAlphaNumeric, castSelf: selfAsPyString)
    dict["isalpha"] = wrapMethod(context, name: "isalpha", doc: nil, fn: PyString.isAlpha, castSelf: selfAsPyString)
    dict["isascii"] = wrapMethod(context, name: "isascii", doc: nil, fn: PyString.isAscii, castSelf: selfAsPyString)
    dict["isdecimal"] = wrapMethod(context, name: "isdecimal", doc: nil, fn: PyString.isDecimal, castSelf: selfAsPyString)
    dict["isdigit"] = wrapMethod(context, name: "isdigit", doc: nil, fn: PyString.isDigit, castSelf: selfAsPyString)
    dict["isidentifier"] = wrapMethod(context, name: "isidentifier", doc: nil, fn: PyString.isIdentifier, castSelf: selfAsPyString)
    dict["islower"] = wrapMethod(context, name: "islower", doc: nil, fn: PyString.isLower, castSelf: selfAsPyString)
    dict["isnumeric"] = wrapMethod(context, name: "isnumeric", doc: nil, fn: PyString.isNumeric, castSelf: selfAsPyString)
    dict["isprintable"] = wrapMethod(context, name: "isprintable", doc: nil, fn: PyString.isPrintable, castSelf: selfAsPyString)
    dict["isspace"] = wrapMethod(context, name: "isspace", doc: nil, fn: PyString.isSpace, castSelf: selfAsPyString)
    dict["istitle"] = wrapMethod(context, name: "istitle", doc: nil, fn: PyString.isTitle, castSelf: selfAsPyString)
    dict["isupper"] = wrapMethod(context, name: "isupper", doc: nil, fn: PyString.isUpper, castSelf: selfAsPyString)
    dict["startswith"] = wrapMethod(context, name: "startswith", doc: nil, fn: PyString.startsWith(_:start:end:), castSelf: selfAsPyString)
    dict["endswith"] = wrapMethod(context, name: "endswith", doc: nil, fn: PyString.endsWith(_:start:end:), castSelf: selfAsPyString)
    dict["strip"] = wrapMethod(context, name: "strip", doc: nil, fn: PyString.strip(_:), castSelf: selfAsPyString)
    dict["lstrip"] = wrapMethod(context, name: "lstrip", doc: nil, fn: PyString.lstrip(_:), castSelf: selfAsPyString)
    dict["rstrip"] = wrapMethod(context, name: "rstrip", doc: nil, fn: PyString.rstrip(_:), castSelf: selfAsPyString)
    dict["find"] = wrapMethod(context, name: "find", doc: nil, fn: PyString.find(_:start:end:), castSelf: selfAsPyString)
    dict["rfind"] = wrapMethod(context, name: "rfind", doc: nil, fn: PyString.rfind(_:start:end:), castSelf: selfAsPyString)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyString.index(of:start:end:), castSelf: selfAsPyString)
    dict["rindex"] = wrapMethod(context, name: "rindex", doc: nil, fn: PyString.rindex(_:start:end:), castSelf: selfAsPyString)
    dict["lower"] = wrapMethod(context, name: "lower", doc: nil, fn: PyString.lower, castSelf: selfAsPyString)
    dict["upper"] = wrapMethod(context, name: "upper", doc: nil, fn: PyString.upper, castSelf: selfAsPyString)
    dict["title"] = wrapMethod(context, name: "title", doc: nil, fn: PyString.title, castSelf: selfAsPyString)
    dict["swapcase"] = wrapMethod(context, name: "swapcase", doc: nil, fn: PyString.swapcase, castSelf: selfAsPyString)
    dict["casefold"] = wrapMethod(context, name: "casefold", doc: nil, fn: PyString.casefold, castSelf: selfAsPyString)
    dict["capitalize"] = wrapMethod(context, name: "capitalize", doc: nil, fn: PyString.capitalize, castSelf: selfAsPyString)
    dict["center"] = wrapMethod(context, name: "center", doc: nil, fn: PyString.center(width:fillChar:), castSelf: selfAsPyString)
    dict["ljust"] = wrapMethod(context, name: "ljust", doc: nil, fn: PyString.ljust(width:fillChar:), castSelf: selfAsPyString)
    dict["rjust"] = wrapMethod(context, name: "rjust", doc: nil, fn: PyString.rjust(width:fillChar:), castSelf: selfAsPyString)
    dict["split"] = wrapMethod(context, name: "split", doc: nil, fn: PyString.split(separator:maxCount:), castSelf: selfAsPyString)
    dict["rsplit"] = wrapMethod(context, name: "rsplit", doc: nil, fn: PyString.rsplit(separator:maxCount:), castSelf: selfAsPyString)
    dict["splitlines"] = wrapMethod(context, name: "splitlines", doc: nil, fn: PyString.splitLines(keepEnds:), castSelf: selfAsPyString)
    dict["partition"] = wrapMethod(context, name: "partition", doc: nil, fn: PyString.partition(separator:), castSelf: selfAsPyString)
    dict["rpartition"] = wrapMethod(context, name: "rpartition", doc: nil, fn: PyString.rpartition(separator:), castSelf: selfAsPyString)
    dict["expandtabs"] = wrapMethod(context, name: "expandtabs", doc: nil, fn: PyString.expandTabs(tabSize:), castSelf: selfAsPyString)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyString.count(_:start:end:), castSelf: selfAsPyString)
    dict["replace"] = wrapMethod(context, name: "replace", doc: nil, fn: PyString.replace(old:new:count:), castSelf: selfAsPyString)
    dict["zfill"] = wrapMethod(context, name: "zfill", doc: nil, fn: PyString.zfill(width:), castSelf: selfAsPyString)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyString.add(_:), castSelf: selfAsPyString)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyString.mul(_:), castSelf: selfAsPyString)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyString.rmul(_:), castSelf: selfAsPyString)
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
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTuple.getClass, castSelf: selfAsPyTuple)



    dict["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, fn: PyTuple.isEqual(_:), castSelf: selfAsPyTuple)
    dict["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, fn: PyTuple.isNotEqual(_:), castSelf: selfAsPyTuple)
    dict["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, fn: PyTuple.isLess(_:), castSelf: selfAsPyTuple)
    dict["__le__"] = wrapMethod(context, name: "__le__", doc: nil, fn: PyTuple.isLessEqual(_:), castSelf: selfAsPyTuple)
    dict["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, fn: PyTuple.isGreater(_:), castSelf: selfAsPyTuple)
    dict["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, fn: PyTuple.isGreaterEqual(_:), castSelf: selfAsPyTuple)
    dict["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, fn: PyTuple.hash, castSelf: selfAsPyTuple)
    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyTuple.repr, castSelf: selfAsPyTuple)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyTuple.getAttribute(name:), castSelf: selfAsPyTuple)
    dict["__len__"] = wrapMethod(context, name: "__len__", doc: nil, fn: PyTuple.getLength, castSelf: selfAsPyTuple)
    dict["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, fn: PyTuple.contains(_:), castSelf: selfAsPyTuple)
    dict["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, fn: PyTuple.getItem(at:), castSelf: selfAsPyTuple)
    dict["count"] = wrapMethod(context, name: "count", doc: nil, fn: PyTuple.count(_:), castSelf: selfAsPyTuple)
    dict["index"] = wrapMethod(context, name: "index", doc: nil, fn: PyTuple.index(of:), castSelf: selfAsPyTuple)
    dict["__add__"] = wrapMethod(context, name: "__add__", doc: nil, fn: PyTuple.add(_:), castSelf: selfAsPyTuple)
    dict["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, fn: PyTuple.mul(_:), castSelf: selfAsPyTuple)
    dict["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, fn: PyTuple.rmul(_:), castSelf: selfAsPyTuple)
    return result
  }

  // MARK: - ArithmeticError

  internal static func arithmeticError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ArithmeticError", doc: PyArithmeticError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyArithmeticError.getClass, castSelf: selfAsPyArithmeticError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyArithmeticError.getDict, castSelf: selfAsPyArithmeticError)



    return result
  }

  // MARK: - AssertionError

  internal static func assertionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "AssertionError", doc: PyAssertionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyAssertionError.getClass, castSelf: selfAsPyAssertionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyAssertionError.getDict, castSelf: selfAsPyAssertionError)



    return result
  }

  // MARK: - AttributeError

  internal static func attributeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "AttributeError", doc: PyAttributeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyAttributeError.getClass, castSelf: selfAsPyAttributeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyAttributeError.getDict, castSelf: selfAsPyAttributeError)



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
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBaseException.getDict, castSelf: selfAsPyBaseException)
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBaseException.getClass, castSelf: selfAsPyBaseException)
    dict["args"] = createProperty(context, name: "args", doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: selfAsPyBaseException)
    dict["__traceback__"] = createProperty(context, name: "__traceback__", doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: selfAsPyBaseException)
    dict["__cause__"] = createProperty(context, name: "__cause__", doc: nil, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: selfAsPyBaseException)
    dict["__context__"] = createProperty(context, name: "__context__", doc: nil, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: selfAsPyBaseException)
    dict["__suppress_context__"] = createProperty(context, name: "__suppress_context__", doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: selfAsPyBaseException)



    dict["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, fn: PyBaseException.repr, castSelf: selfAsPyBaseException)
    dict["__str__"] = wrapMethod(context, name: "__str__", doc: nil, fn: PyBaseException.str, castSelf: selfAsPyBaseException)
    dict["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, fn: PyBaseException.getAttribute(name:), castSelf: selfAsPyBaseException)
    dict["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, fn: PyBaseException.setAttribute(name:value:), castSelf: selfAsPyBaseException)
    dict["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, fn: PyBaseException.delAttribute(name:), castSelf: selfAsPyBaseException)
    return result
  }

  // MARK: - BlockingIOError

  internal static func blockingIOError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BlockingIOError", doc: PyBlockingIOError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBlockingIOError.getClass, castSelf: selfAsPyBlockingIOError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBlockingIOError.getDict, castSelf: selfAsPyBlockingIOError)



    return result
  }

  // MARK: - BrokenPipeError

  internal static func brokenPipeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BrokenPipeError", doc: PyBrokenPipeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBrokenPipeError.getClass, castSelf: selfAsPyBrokenPipeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBrokenPipeError.getDict, castSelf: selfAsPyBrokenPipeError)



    return result
  }

  // MARK: - BufferError

  internal static func bufferError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BufferError", doc: PyBufferError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBufferError.getClass, castSelf: selfAsPyBufferError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBufferError.getDict, castSelf: selfAsPyBufferError)



    return result
  }

  // MARK: - BytesWarning

  internal static func bytesWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BytesWarning", doc: PyBytesWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBytesWarning.getClass, castSelf: selfAsPyBytesWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBytesWarning.getDict, castSelf: selfAsPyBytesWarning)



    return result
  }

  // MARK: - ChildProcessError

  internal static func childProcessError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ChildProcessError", doc: PyChildProcessError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyChildProcessError.getClass, castSelf: selfAsPyChildProcessError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyChildProcessError.getDict, castSelf: selfAsPyChildProcessError)



    return result
  }

  // MARK: - ConnectionAbortedError

  internal static func connectionAbortedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionAbortedError", doc: PyConnectionAbortedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionAbortedError.getClass, castSelf: selfAsPyConnectionAbortedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionAbortedError.getDict, castSelf: selfAsPyConnectionAbortedError)



    return result
  }

  // MARK: - ConnectionError

  internal static func connectionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionError", doc: PyConnectionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionError.getClass, castSelf: selfAsPyConnectionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionError.getDict, castSelf: selfAsPyConnectionError)



    return result
  }

  // MARK: - ConnectionRefusedError

  internal static func connectionRefusedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionRefusedError", doc: PyConnectionRefusedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionRefusedError.getClass, castSelf: selfAsPyConnectionRefusedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionRefusedError.getDict, castSelf: selfAsPyConnectionRefusedError)



    return result
  }

  // MARK: - ConnectionResetError

  internal static func connectionResetError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionResetError", doc: PyConnectionResetError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionResetError.getClass, castSelf: selfAsPyConnectionResetError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionResetError.getDict, castSelf: selfAsPyConnectionResetError)



    return result
  }

  // MARK: - DeprecationWarning

  internal static func deprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "DeprecationWarning", doc: PyDeprecationWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDeprecationWarning.getClass, castSelf: selfAsPyDeprecationWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyDeprecationWarning.getDict, castSelf: selfAsPyDeprecationWarning)



    return result
  }

  // MARK: - EOFError

  internal static func eofError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "EOFError", doc: PyEOFError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyEOFError.getClass, castSelf: selfAsPyEOFError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyEOFError.getDict, castSelf: selfAsPyEOFError)



    return result
  }

  // MARK: - Exception

  internal static func exception(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "Exception", doc: PyException.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyException.getClass, castSelf: selfAsPyException)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyException.getDict, castSelf: selfAsPyException)



    return result
  }

  // MARK: - FileExistsError

  internal static func fileExistsError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FileExistsError", doc: PyFileExistsError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFileExistsError.getClass, castSelf: selfAsPyFileExistsError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFileExistsError.getDict, castSelf: selfAsPyFileExistsError)



    return result
  }

  // MARK: - FileNotFoundError

  internal static func fileNotFoundError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FileNotFoundError", doc: PyFileNotFoundError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFileNotFoundError.getClass, castSelf: selfAsPyFileNotFoundError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFileNotFoundError.getDict, castSelf: selfAsPyFileNotFoundError)



    return result
  }

  // MARK: - FloatingPointError

  internal static func floatingPointError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FloatingPointError", doc: PyFloatingPointError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFloatingPointError.getClass, castSelf: selfAsPyFloatingPointError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFloatingPointError.getDict, castSelf: selfAsPyFloatingPointError)



    return result
  }

  // MARK: - FutureWarning

  internal static func futureWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FutureWarning", doc: PyFutureWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFutureWarning.getClass, castSelf: selfAsPyFutureWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFutureWarning.getDict, castSelf: selfAsPyFutureWarning)



    return result
  }

  // MARK: - GeneratorExit

  internal static func generatorExit(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "GeneratorExit", doc: PyGeneratorExit.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyGeneratorExit.getClass, castSelf: selfAsPyGeneratorExit)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyGeneratorExit.getDict, castSelf: selfAsPyGeneratorExit)



    return result
  }

  // MARK: - ImportError

  internal static func importError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ImportError", doc: PyImportError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyImportError.getClass, castSelf: selfAsPyImportError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyImportError.getDict, castSelf: selfAsPyImportError)



    return result
  }

  // MARK: - ImportWarning

  internal static func importWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ImportWarning", doc: PyImportWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyImportWarning.getClass, castSelf: selfAsPyImportWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyImportWarning.getDict, castSelf: selfAsPyImportWarning)



    return result
  }

  // MARK: - IndentationError

  internal static func indentationError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IndentationError", doc: PyIndentationError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIndentationError.getClass, castSelf: selfAsPyIndentationError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIndentationError.getDict, castSelf: selfAsPyIndentationError)



    return result
  }

  // MARK: - IndexError

  internal static func indexError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IndexError", doc: PyIndexError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIndexError.getClass, castSelf: selfAsPyIndexError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIndexError.getDict, castSelf: selfAsPyIndexError)



    return result
  }

  // MARK: - InterruptedError

  internal static func interruptedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "InterruptedError", doc: PyInterruptedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyInterruptedError.getClass, castSelf: selfAsPyInterruptedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyInterruptedError.getDict, castSelf: selfAsPyInterruptedError)



    return result
  }

  // MARK: - IsADirectoryError

  internal static func isADirectoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IsADirectoryError", doc: PyIsADirectoryError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIsADirectoryError.getClass, castSelf: selfAsPyIsADirectoryError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIsADirectoryError.getDict, castSelf: selfAsPyIsADirectoryError)



    return result
  }

  // MARK: - KeyError

  internal static func keyError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "KeyError", doc: PyKeyError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyKeyError.getClass, castSelf: selfAsPyKeyError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyKeyError.getDict, castSelf: selfAsPyKeyError)



    return result
  }

  // MARK: - KeyboardInterrupt

  internal static func keyboardInterrupt(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "KeyboardInterrupt", doc: PyKeyboardInterrupt.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyKeyboardInterrupt.getClass, castSelf: selfAsPyKeyboardInterrupt)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyKeyboardInterrupt.getDict, castSelf: selfAsPyKeyboardInterrupt)



    return result
  }

  // MARK: - LookupError

  internal static func lookupError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "LookupError", doc: PyLookupError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyLookupError.getClass, castSelf: selfAsPyLookupError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyLookupError.getDict, castSelf: selfAsPyLookupError)



    return result
  }

  // MARK: - MemoryError

  internal static func memoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "MemoryError", doc: PyMemoryError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyMemoryError.getClass, castSelf: selfAsPyMemoryError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyMemoryError.getDict, castSelf: selfAsPyMemoryError)



    return result
  }

  // MARK: - ModuleNotFoundError

  internal static func moduleNotFoundError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ModuleNotFoundError", doc: PyModuleNotFoundError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyModuleNotFoundError.getClass, castSelf: selfAsPyModuleNotFoundError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyModuleNotFoundError.getDict, castSelf: selfAsPyModuleNotFoundError)



    return result
  }

  // MARK: - NameError

  internal static func nameError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NameError", doc: PyNameError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNameError.getClass, castSelf: selfAsPyNameError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNameError.getDict, castSelf: selfAsPyNameError)



    return result
  }

  // MARK: - NotADirectoryError

  internal static func notADirectoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotADirectoryError", doc: PyNotADirectoryError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotADirectoryError.getClass, castSelf: selfAsPyNotADirectoryError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNotADirectoryError.getDict, castSelf: selfAsPyNotADirectoryError)



    return result
  }

  // MARK: - NotImplementedError

  internal static func notImplementedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedError", doc: PyNotImplementedError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotImplementedError.getClass, castSelf: selfAsPyNotImplementedError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNotImplementedError.getDict, castSelf: selfAsPyNotImplementedError)



    return result
  }

  // MARK: - OSError

  internal static func osError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "OSError", doc: PyOSError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyOSError.getClass, castSelf: selfAsPyOSError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyOSError.getDict, castSelf: selfAsPyOSError)



    return result
  }

  // MARK: - OverflowError

  internal static func overflowError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "OverflowError", doc: PyOverflowError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyOverflowError.getClass, castSelf: selfAsPyOverflowError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyOverflowError.getDict, castSelf: selfAsPyOverflowError)



    return result
  }

  // MARK: - PendingDeprecationWarning

  internal static func pendingDeprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "PendingDeprecationWarning", doc: PyPendingDeprecationWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyPendingDeprecationWarning.getClass, castSelf: selfAsPyPendingDeprecationWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyPendingDeprecationWarning.getDict, castSelf: selfAsPyPendingDeprecationWarning)



    return result
  }

  // MARK: - PermissionError

  internal static func permissionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "PermissionError", doc: PyPermissionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyPermissionError.getClass, castSelf: selfAsPyPermissionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyPermissionError.getDict, castSelf: selfAsPyPermissionError)



    return result
  }

  // MARK: - ProcessLookupError

  internal static func processLookupError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ProcessLookupError", doc: PyProcessLookupError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyProcessLookupError.getClass, castSelf: selfAsPyProcessLookupError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyProcessLookupError.getDict, castSelf: selfAsPyProcessLookupError)



    return result
  }

  // MARK: - RecursionError

  internal static func recursionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RecursionError", doc: PyRecursionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRecursionError.getClass, castSelf: selfAsPyRecursionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRecursionError.getDict, castSelf: selfAsPyRecursionError)



    return result
  }

  // MARK: - ReferenceError

  internal static func referenceError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ReferenceError", doc: PyReferenceError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyReferenceError.getClass, castSelf: selfAsPyReferenceError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyReferenceError.getDict, castSelf: selfAsPyReferenceError)



    return result
  }

  // MARK: - ResourceWarning

  internal static func resourceWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ResourceWarning", doc: PyResourceWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyResourceWarning.getClass, castSelf: selfAsPyResourceWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyResourceWarning.getDict, castSelf: selfAsPyResourceWarning)



    return result
  }

  // MARK: - RuntimeError

  internal static func runtimeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RuntimeError", doc: PyRuntimeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRuntimeError.getClass, castSelf: selfAsPyRuntimeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRuntimeError.getDict, castSelf: selfAsPyRuntimeError)



    return result
  }

  // MARK: - RuntimeWarning

  internal static func runtimeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RuntimeWarning", doc: PyRuntimeWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRuntimeWarning.getClass, castSelf: selfAsPyRuntimeWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRuntimeWarning.getDict, castSelf: selfAsPyRuntimeWarning)



    return result
  }

  // MARK: - StopAsyncIteration

  internal static func stopAsyncIteration(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "StopAsyncIteration", doc: PyStopAsyncIteration.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyStopAsyncIteration.getClass, castSelf: selfAsPyStopAsyncIteration)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyStopAsyncIteration.getDict, castSelf: selfAsPyStopAsyncIteration)



    return result
  }

  // MARK: - StopIteration

  internal static func stopIteration(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "StopIteration", doc: PyStopIteration.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyStopIteration.getClass, castSelf: selfAsPyStopIteration)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyStopIteration.getDict, castSelf: selfAsPyStopIteration)



    return result
  }

  // MARK: - SyntaxError

  internal static func syntaxError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SyntaxError", doc: PySyntaxError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySyntaxError.getClass, castSelf: selfAsPySyntaxError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySyntaxError.getDict, castSelf: selfAsPySyntaxError)



    return result
  }

  // MARK: - SyntaxWarning

  internal static func syntaxWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SyntaxWarning", doc: PySyntaxWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySyntaxWarning.getClass, castSelf: selfAsPySyntaxWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySyntaxWarning.getDict, castSelf: selfAsPySyntaxWarning)



    return result
  }

  // MARK: - SystemError

  internal static func systemError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SystemError", doc: PySystemError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySystemError.getClass, castSelf: selfAsPySystemError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySystemError.getDict, castSelf: selfAsPySystemError)



    return result
  }

  // MARK: - SystemExit

  internal static func systemExit(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SystemExit", doc: PySystemExit.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySystemExit.getClass, castSelf: selfAsPySystemExit)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySystemExit.getDict, castSelf: selfAsPySystemExit)



    return result
  }

  // MARK: - TabError

  internal static func tabError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TabError", doc: PyTabError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTabError.getClass, castSelf: selfAsPyTabError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTabError.getDict, castSelf: selfAsPyTabError)



    return result
  }

  // MARK: - TimeoutError

  internal static func timeoutError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TimeoutError", doc: PyTimeoutError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTimeoutError.getClass, castSelf: selfAsPyTimeoutError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTimeoutError.getDict, castSelf: selfAsPyTimeoutError)



    return result
  }

  // MARK: - TypeError

  internal static func typeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TypeError", doc: PyTypeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTypeError.getClass, castSelf: selfAsPyTypeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTypeError.getDict, castSelf: selfAsPyTypeError)



    return result
  }

  // MARK: - UnboundLocalError

  internal static func unboundLocalError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnboundLocalError", doc: PyUnboundLocalError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnboundLocalError.getClass, castSelf: selfAsPyUnboundLocalError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnboundLocalError.getDict, castSelf: selfAsPyUnboundLocalError)



    return result
  }

  // MARK: - UnicodeDecodeError

  internal static func unicodeDecodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeDecodeError", doc: PyUnicodeDecodeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeDecodeError.getClass, castSelf: selfAsPyUnicodeDecodeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeDecodeError.getDict, castSelf: selfAsPyUnicodeDecodeError)



    return result
  }

  // MARK: - UnicodeEncodeError

  internal static func unicodeEncodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeEncodeError", doc: PyUnicodeEncodeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeEncodeError.getClass, castSelf: selfAsPyUnicodeEncodeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeEncodeError.getDict, castSelf: selfAsPyUnicodeEncodeError)



    return result
  }

  // MARK: - UnicodeError

  internal static func unicodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeError", doc: PyUnicodeError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeError.getClass, castSelf: selfAsPyUnicodeError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeError.getDict, castSelf: selfAsPyUnicodeError)



    return result
  }

  // MARK: - UnicodeTranslateError

  internal static func unicodeTranslateError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeTranslateError", doc: PyUnicodeTranslateError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeTranslateError.getClass, castSelf: selfAsPyUnicodeTranslateError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeTranslateError.getDict, castSelf: selfAsPyUnicodeTranslateError)



    return result
  }

  // MARK: - UnicodeWarning

  internal static func unicodeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeWarning", doc: PyUnicodeWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeWarning.getClass, castSelf: selfAsPyUnicodeWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeWarning.getDict, castSelf: selfAsPyUnicodeWarning)



    return result
  }

  // MARK: - UserWarning

  internal static func userWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UserWarning", doc: PyUserWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUserWarning.getClass, castSelf: selfAsPyUserWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUserWarning.getDict, castSelf: selfAsPyUserWarning)



    return result
  }

  // MARK: - ValueError

  internal static func valueError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ValueError", doc: PyValueError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyValueError.getClass, castSelf: selfAsPyValueError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyValueError.getDict, castSelf: selfAsPyValueError)



    return result
  }

  // MARK: - Warning

  internal static func warning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "Warning", doc: PyWarning.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyWarning.getClass, castSelf: selfAsPyWarning)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyWarning.getDict, castSelf: selfAsPyWarning)



    return result
  }

  // MARK: - ZeroDivisionError

  internal static func zeroDivisionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ZeroDivisionError", doc: PyZeroDivisionError.doc, type: type, base: base)
    result.setFlag(.default)
    result.setFlag(.baseType)
    result.setFlag(.hasGC)

    let dict = result.getDict()
    dict["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyZeroDivisionError.getClass, castSelf: selfAsPyZeroDivisionError)
    dict["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyZeroDivisionError.getDict, castSelf: selfAsPyZeroDivisionError)



    return result
  }
}
