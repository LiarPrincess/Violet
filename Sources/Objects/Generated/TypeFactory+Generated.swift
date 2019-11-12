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


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyBaseObject.isEqual(zelf:other:))
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyBaseObject.isNotEqual(zelf:other:))
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyBaseObject.isLess(zelf:other:))
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyBaseObject.isLessEqual(zelf:other:))
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyBaseObject.isGreater(zelf:other:))
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyBaseObject.isGreaterEqual(zelf:other:))
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyBaseObject.hash(zelf:))
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyBaseObject.repr(zelf:))
    result._attributes["__str__"] = wrapMethod(context, name: "__str__", doc: nil, func: PyBaseObject.str(zelf:))
    result._attributes["__format__"] = wrapMethod(context, name: "__format__", doc: nil, func: PyBaseObject.format(zelf:spec:))
    result._attributes["__class__"] = wrapMethod(context, name: "__class__", doc: nil, func: PyBaseObject.getClass(zelf:))
    result._attributes["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, func: PyBaseObject.dir(zelf:))
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyBaseObject.getAttribute(zelf:name:))
    result._attributes["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, func: PyBaseObject.setAttribute(zelf:name:value:))
    result._attributes["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, func: PyBaseObject.delAttribute(zelf:name:))
    result._attributes["__subclasshook__"] = wrapMethod(context, name: "__subclasshook__", doc: nil, func: PyBaseObject.subclasshook(zelf:))
    result._attributes["__init_subclass__"] = wrapMethod(context, name: "__init_subclass__", doc: nil, func: PyBaseObject.initSubclass(zelf:))

    return result
  }

  // MARK: - Type type

  /// Create `type` type without assigning `type` property.
  internal static func typeWithoutType(_ context: PyContext, base: PyType) -> PyType {
    let result = PyType.initWithoutType(context, name: "type", doc: PyType.doc, base: base)

    result._attributes["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyType.getName, set: PyType.setName, castSelf: selfAsPyType)
    result._attributes["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyType.getQualname, set: PyType.setQualname, castSelf: selfAsPyType)
    result._attributes["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyType.getModule, set: PyType.setModule, castSelf: selfAsPyType)
    result._attributes["__bases__"] = createProperty(context, name: "__bases__", doc: nil, get: PyType.getBases, set: PyType.setBases, castSelf: selfAsPyType)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyType.dict, castSelf: selfAsPyType)
    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyType.getClass, castSelf: selfAsPyType)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyType.repr, castSelf: selfAsPyType)
    result._attributes["__subclasses__"] = wrapMethod(context, name: "__subclasses__", doc: nil, func: PyType.getSubclasses, castSelf: selfAsPyType)
    result._attributes["__instancecheck__"] = wrapMethod(context, name: "__instancecheck__", doc: nil, func: PyType.isInstance(of:), castSelf: selfAsPyType)
    result._attributes["__subclasscheck__"] = wrapMethod(context, name: "__subclasscheck__", doc: nil, func: PyType.isSubclass(of:), castSelf: selfAsPyType)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyType.getAttribute(name:), castSelf: selfAsPyType)
    result._attributes["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, func: PyType.setAttribute(name:value:), castSelf: selfAsPyType)
    result._attributes["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, func: PyType.delAttribute(name:), castSelf: selfAsPyType)
    result._attributes["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, func: PyType.dir, castSelf: selfAsPyType)
    return result
  }

  // MARK: - Bool

  internal static func bool(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "bool", doc: PyBool.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBool.getClass, castSelf: selfAsPyBool)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyBool.repr, castSelf: selfAsPyBool)
    result._attributes["__str__"] = wrapMethod(context, name: "__str__", doc: nil, func: PyBool.str, castSelf: selfAsPyBool)
    result._attributes["__and__"] = wrapMethod(context, name: "__and__", doc: nil, func: PyBool.and(_:), castSelf: selfAsPyBool)
    result._attributes["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, func: PyBool.rand(_:), castSelf: selfAsPyBool)
    result._attributes["__or__"] = wrapMethod(context, name: "__or__", doc: nil, func: PyBool.or(_:), castSelf: selfAsPyBool)
    result._attributes["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, func: PyBool.ror(_:), castSelf: selfAsPyBool)
    result._attributes["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, func: PyBool.xor(_:), castSelf: selfAsPyBool)
    result._attributes["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, func: PyBool.rxor(_:), castSelf: selfAsPyBool)
    return result
  }

  // MARK: - BuiltinFunction

  internal static func builtinFunction(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "builtinFunction", doc: nil, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBuiltinFunction.getClass, castSelf: selfAsPyBuiltinFunction)
    result._attributes["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyBuiltinFunction.getName, castSelf: selfAsPyBuiltinFunction)
    result._attributes["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyBuiltinFunction.getQualname, castSelf: selfAsPyBuiltinFunction)
    result._attributes["__text_signature__"] = createProperty(context, name: "__text_signature__", doc: nil, get: PyBuiltinFunction.getTextSignature, castSelf: selfAsPyBuiltinFunction)
    result._attributes["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyBuiltinFunction.getModule, castSelf: selfAsPyBuiltinFunction)
    result._attributes["__self__"] = createProperty(context, name: "__self__", doc: nil, get: PyBuiltinFunction.getSelf, castSelf: selfAsPyBuiltinFunction)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyBuiltinFunction.isEqual(_:), castSelf: selfAsPyBuiltinFunction)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyBuiltinFunction.isNotEqual(_:), castSelf: selfAsPyBuiltinFunction)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyBuiltinFunction.isLess(_:), castSelf: selfAsPyBuiltinFunction)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyBuiltinFunction.isLessEqual(_:), castSelf: selfAsPyBuiltinFunction)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyBuiltinFunction.isGreater(_:), castSelf: selfAsPyBuiltinFunction)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyBuiltinFunction.isGreaterEqual(_:), castSelf: selfAsPyBuiltinFunction)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyBuiltinFunction.hash, castSelf: selfAsPyBuiltinFunction)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyBuiltinFunction.repr, castSelf: selfAsPyBuiltinFunction)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyBuiltinFunction.getAttribute(name:), castSelf: selfAsPyBuiltinFunction)
    return result
  }

  // MARK: - Code

  internal static func code(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "code", doc: PyCode.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyCode.getClass, castSelf: selfAsPyCode)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyCode.isEqual(_:), castSelf: selfAsPyCode)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyCode.isLess(_:), castSelf: selfAsPyCode)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyCode.isLessEqual(_:), castSelf: selfAsPyCode)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyCode.isGreater(_:), castSelf: selfAsPyCode)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyCode.isGreaterEqual(_:), castSelf: selfAsPyCode)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyCode.hash, castSelf: selfAsPyCode)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyCode.repr, castSelf: selfAsPyCode)
    return result
  }

  // MARK: - Complex

  internal static func complex(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "complex", doc: PyComplex.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyComplex.getClass, castSelf: selfAsPyComplex)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyComplex.isEqual(_:), castSelf: selfAsPyComplex)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyComplex.isNotEqual(_:), castSelf: selfAsPyComplex)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyComplex.isLess(_:), castSelf: selfAsPyComplex)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyComplex.isLessEqual(_:), castSelf: selfAsPyComplex)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyComplex.isGreater(_:), castSelf: selfAsPyComplex)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyComplex.isGreaterEqual(_:), castSelf: selfAsPyComplex)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyComplex.hash, castSelf: selfAsPyComplex)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyComplex.repr, castSelf: selfAsPyComplex)
    result._attributes["__str__"] = wrapMethod(context, name: "__str__", doc: nil, func: PyComplex.str, castSelf: selfAsPyComplex)
    result._attributes["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, func: PyComplex.asBool, castSelf: selfAsPyComplex)
    result._attributes["__int__"] = wrapMethod(context, name: "__int__", doc: nil, func: PyComplex.asInt, castSelf: selfAsPyComplex)
    result._attributes["__float__"] = wrapMethod(context, name: "__float__", doc: nil, func: PyComplex.asFloat, castSelf: selfAsPyComplex)
    result._attributes["real"] = wrapMethod(context, name: "real", doc: nil, func: PyComplex.asReal, castSelf: selfAsPyComplex)
    result._attributes["imag"] = wrapMethod(context, name: "imag", doc: nil, func: PyComplex.asImag, castSelf: selfAsPyComplex)
    result._attributes["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, func: PyComplex.conjugate, castSelf: selfAsPyComplex)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyComplex.getAttribute(name:), castSelf: selfAsPyComplex)
    result._attributes["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, func: PyComplex.positive, castSelf: selfAsPyComplex)
    result._attributes["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, func: PyComplex.negative, castSelf: selfAsPyComplex)
    result._attributes["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, func: PyComplex.abs, castSelf: selfAsPyComplex)
    result._attributes["__add__"] = wrapMethod(context, name: "__add__", doc: nil, func: PyComplex.add(_:), castSelf: selfAsPyComplex)
    result._attributes["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, func: PyComplex.radd(_:), castSelf: selfAsPyComplex)
    result._attributes["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, func: PyComplex.sub(_:), castSelf: selfAsPyComplex)
    result._attributes["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, func: PyComplex.rsub(_:), castSelf: selfAsPyComplex)
    result._attributes["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, func: PyComplex.mul(_:), castSelf: selfAsPyComplex)
    result._attributes["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, func: PyComplex.rmul(_:), castSelf: selfAsPyComplex)
    result._attributes["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, func: PyComplex.pow(_:), castSelf: selfAsPyComplex)
    result._attributes["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, func: PyComplex.rpow(_:), castSelf: selfAsPyComplex)
    result._attributes["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, func: PyComplex.trueDiv(_:), castSelf: selfAsPyComplex)
    result._attributes["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, func: PyComplex.rtrueDiv(_:), castSelf: selfAsPyComplex)
    result._attributes["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, func: PyComplex.floorDiv(_:), castSelf: selfAsPyComplex)
    result._attributes["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, func: PyComplex.rfloorDiv(_:), castSelf: selfAsPyComplex)
    result._attributes["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, func: PyComplex.mod(_:), castSelf: selfAsPyComplex)
    result._attributes["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, func: PyComplex.rmod(_:), castSelf: selfAsPyComplex)
    result._attributes["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, func: PyComplex.divMod(_:), castSelf: selfAsPyComplex)
    result._attributes["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, func: PyComplex.rdivMod(_:), castSelf: selfAsPyComplex)
    return result
  }

  // MARK: - Dict

  internal static func dict(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "dict", doc: PyDict.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDict.getClass, castSelf: selfAsPyDict)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyDict.isEqual(_:), castSelf: selfAsPyDict)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyDict.isNotEqual(_:), castSelf: selfAsPyDict)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyDict.isLess(_:), castSelf: selfAsPyDict)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyDict.isLessEqual(_:), castSelf: selfAsPyDict)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyDict.isGreater(_:), castSelf: selfAsPyDict)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyDict.isGreaterEqual(_:), castSelf: selfAsPyDict)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyDict.hash, castSelf: selfAsPyDict)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyDict.repr, castSelf: selfAsPyDict)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyDict.getAttribute(name:), castSelf: selfAsPyDict)
    result._attributes["__len__"] = wrapMethod(context, name: "__len__", doc: nil, func: PyDict.getLength, castSelf: selfAsPyDict)
    result._attributes["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, func: PyDict.getItem(at:), castSelf: selfAsPyDict)
    result._attributes["__setitem__"] = wrapMethod(context, name: "__setitem__", doc: nil, func: PyDict.setItem(at:to:), castSelf: selfAsPyDict)
    result._attributes["__delitem__"] = wrapMethod(context, name: "__delitem__", doc: nil, func: PyDict.delItem(at:), castSelf: selfAsPyDict)
    result._attributes["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, func: PyDict.contains(_:), castSelf: selfAsPyDict)
    result._attributes["clear"] = wrapMethod(context, name: "clear", doc: nil, func: PyDict.clear, castSelf: selfAsPyDict)
    result._attributes["get"] = wrapMethod(context, name: "get", doc: nil, func: PyDict.get(_:default:), castSelf: selfAsPyDict)
    result._attributes["setdefault"] = wrapMethod(context, name: "setdefault", doc: nil, func: PyDict.setDefault(_:default:), castSelf: selfAsPyDict)
    result._attributes["copy"] = wrapMethod(context, name: "copy", doc: nil, func: PyDict.copy, castSelf: selfAsPyDict)
    result._attributes["pop"] = wrapMethod(context, name: "pop", doc: nil, func: PyDict.pop(_:default:), castSelf: selfAsPyDict)
    result._attributes["popitem"] = wrapMethod(context, name: "popitem", doc: nil, func: PyDict.popitem, castSelf: selfAsPyDict)
    return result
  }

  // MARK: - Ellipsis

  internal static func ellipsis(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ellipsis", doc: nil, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyEllipsis.getClass, castSelf: selfAsPyEllipsis)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyEllipsis.repr, castSelf: selfAsPyEllipsis)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyEllipsis.getAttribute(name:), castSelf: selfAsPyEllipsis)
    return result
  }

  // MARK: - Float

  internal static func float(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "float", doc: PyFloat.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFloat.getClass, castSelf: selfAsPyFloat)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyFloat.isEqual(_:), castSelf: selfAsPyFloat)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyFloat.isNotEqual(_:), castSelf: selfAsPyFloat)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyFloat.isLess(_:), castSelf: selfAsPyFloat)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyFloat.isLessEqual(_:), castSelf: selfAsPyFloat)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyFloat.isGreater(_:), castSelf: selfAsPyFloat)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyFloat.isGreaterEqual(_:), castSelf: selfAsPyFloat)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyFloat.hash, castSelf: selfAsPyFloat)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyFloat.repr, castSelf: selfAsPyFloat)
    result._attributes["__str__"] = wrapMethod(context, name: "__str__", doc: nil, func: PyFloat.str, castSelf: selfAsPyFloat)
    result._attributes["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, func: PyFloat.asBool, castSelf: selfAsPyFloat)
    result._attributes["__int__"] = wrapMethod(context, name: "__int__", doc: nil, func: PyFloat.asInt, castSelf: selfAsPyFloat)
    result._attributes["__float__"] = wrapMethod(context, name: "__float__", doc: nil, func: PyFloat.asFloat, castSelf: selfAsPyFloat)
    result._attributes["real"] = wrapMethod(context, name: "real", doc: nil, func: PyFloat.asReal, castSelf: selfAsPyFloat)
    result._attributes["imag"] = wrapMethod(context, name: "imag", doc: nil, func: PyFloat.asImag, castSelf: selfAsPyFloat)
    result._attributes["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, func: PyFloat.conjugate, castSelf: selfAsPyFloat)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyFloat.getAttribute(name:), castSelf: selfAsPyFloat)
    result._attributes["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, func: PyFloat.positive, castSelf: selfAsPyFloat)
    result._attributes["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, func: PyFloat.negative, castSelf: selfAsPyFloat)
    result._attributes["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, func: PyFloat.abs, castSelf: selfAsPyFloat)
    result._attributes["__add__"] = wrapMethod(context, name: "__add__", doc: nil, func: PyFloat.add(_:), castSelf: selfAsPyFloat)
    result._attributes["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, func: PyFloat.radd(_:), castSelf: selfAsPyFloat)
    result._attributes["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, func: PyFloat.sub(_:), castSelf: selfAsPyFloat)
    result._attributes["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, func: PyFloat.rsub(_:), castSelf: selfAsPyFloat)
    result._attributes["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, func: PyFloat.mul(_:), castSelf: selfAsPyFloat)
    result._attributes["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, func: PyFloat.rmul(_:), castSelf: selfAsPyFloat)
    result._attributes["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, func: PyFloat.pow(_:), castSelf: selfAsPyFloat)
    result._attributes["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, func: PyFloat.rpow(_:), castSelf: selfAsPyFloat)
    result._attributes["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, func: PyFloat.trueDiv(_:), castSelf: selfAsPyFloat)
    result._attributes["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, func: PyFloat.rtrueDiv(_:), castSelf: selfAsPyFloat)
    result._attributes["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, func: PyFloat.floorDiv(_:), castSelf: selfAsPyFloat)
    result._attributes["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, func: PyFloat.rfloorDiv(_:), castSelf: selfAsPyFloat)
    result._attributes["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, func: PyFloat.mod(_:), castSelf: selfAsPyFloat)
    result._attributes["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, func: PyFloat.rmod(_:), castSelf: selfAsPyFloat)
    result._attributes["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, func: PyFloat.divMod(_:), castSelf: selfAsPyFloat)
    result._attributes["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, func: PyFloat.rdivMod(_:), castSelf: selfAsPyFloat)
    result._attributes["__round__"] = wrapMethod(context, name: "__round__", doc: nil, func: PyFloat.round(nDigits:), castSelf: selfAsPyFloat)
    return result
  }

  // MARK: - FrozenSet

  internal static func frozenset(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "frozenset", doc: PyFrozenSet.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFrozenSet.getClass, castSelf: selfAsPyFrozenSet)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyFrozenSet.isEqual(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyFrozenSet.isNotEqual(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyFrozenSet.isLess(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyFrozenSet.isLessEqual(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyFrozenSet.isGreater(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyFrozenSet.isGreaterEqual(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyFrozenSet.hash, castSelf: selfAsPyFrozenSet)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyFrozenSet.repr, castSelf: selfAsPyFrozenSet)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyFrozenSet.getAttribute(name:), castSelf: selfAsPyFrozenSet)
    result._attributes["__len__"] = wrapMethod(context, name: "__len__", doc: nil, func: PyFrozenSet.getLength, castSelf: selfAsPyFrozenSet)
    result._attributes["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, func: PyFrozenSet.contains(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__and__"] = wrapMethod(context, name: "__and__", doc: nil, func: PyFrozenSet.and(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, func: PyFrozenSet.rand(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__or__"] = wrapMethod(context, name: "__or__", doc: nil, func: PyFrozenSet.or(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, func: PyFrozenSet.ror(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, func: PyFrozenSet.xor(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, func: PyFrozenSet.rxor(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, func: PyFrozenSet.sub(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, func: PyFrozenSet.rsub(_:), castSelf: selfAsPyFrozenSet)
    result._attributes["issubset"] = wrapMethod(context, name: "issubset", doc: nil, func: PyFrozenSet.isSubset(of:), castSelf: selfAsPyFrozenSet)
    result._attributes["issuperset"] = wrapMethod(context, name: "issuperset", doc: nil, func: PyFrozenSet.isSuperset(of:), castSelf: selfAsPyFrozenSet)
    result._attributes["intersection"] = wrapMethod(context, name: "intersection", doc: nil, func: PyFrozenSet.intersection(with:), castSelf: selfAsPyFrozenSet)
    result._attributes["union"] = wrapMethod(context, name: "union", doc: nil, func: PyFrozenSet.union(with:), castSelf: selfAsPyFrozenSet)
    result._attributes["difference"] = wrapMethod(context, name: "difference", doc: nil, func: PyFrozenSet.difference(with:), castSelf: selfAsPyFrozenSet)
    result._attributes["symmetric_difference"] = wrapMethod(context, name: "symmetric_difference", doc: nil, func: PyFrozenSet.symmetricDifference(with:), castSelf: selfAsPyFrozenSet)
    result._attributes["isdisjoint"] = wrapMethod(context, name: "isdisjoint", doc: nil, func: PyFrozenSet.isDisjoint(with:), castSelf: selfAsPyFrozenSet)
    result._attributes["copy"] = wrapMethod(context, name: "copy", doc: nil, func: PyFrozenSet.copy, castSelf: selfAsPyFrozenSet)
    return result
  }

  // MARK: - Function

  internal static func function(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "function", doc: PyFunction.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFunction.getClass, castSelf: selfAsPyFunction)
    result._attributes["__name__"] = createProperty(context, name: "__name__", doc: nil, get: PyFunction.getName, set: PyFunction.setName, castSelf: selfAsPyFunction)
    result._attributes["__qualname__"] = createProperty(context, name: "__qualname__", doc: nil, get: PyFunction.getQualname, set: PyFunction.setQualname, castSelf: selfAsPyFunction)
    result._attributes["__code__"] = createProperty(context, name: "__code__", doc: nil, get: PyFunction.getCode, castSelf: selfAsPyFunction)
    result._attributes["__doc__"] = createProperty(context, name: "__doc__", doc: nil, get: PyFunction.getDoc, castSelf: selfAsPyFunction)
    result._attributes["__module__"] = createProperty(context, name: "__module__", doc: nil, get: PyFunction.getModule, castSelf: selfAsPyFunction)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFunction.dict, castSelf: selfAsPyFunction)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyFunction.repr, castSelf: selfAsPyFunction)
    result._attributes["__get__"] = wrapMethod(context, name: "__get__", doc: nil, func: PyFunction.get(object:), castSelf: selfAsPyFunction)
    return result
  }

  // MARK: - Int

  internal static func int(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "int", doc: PyInt.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyInt.getClass, castSelf: selfAsPyInt)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyInt.isEqual(_:), castSelf: selfAsPyInt)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyInt.isNotEqual(_:), castSelf: selfAsPyInt)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyInt.isLess(_:), castSelf: selfAsPyInt)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyInt.isLessEqual(_:), castSelf: selfAsPyInt)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyInt.isGreater(_:), castSelf: selfAsPyInt)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyInt.isGreaterEqual(_:), castSelf: selfAsPyInt)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyInt.hash, castSelf: selfAsPyInt)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyInt.repr, castSelf: selfAsPyInt)
    result._attributes["__str__"] = wrapMethod(context, name: "__str__", doc: nil, func: PyInt.str, castSelf: selfAsPyInt)
    result._attributes["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, func: PyInt.asBool, castSelf: selfAsPyInt)
    result._attributes["__int__"] = wrapMethod(context, name: "__int__", doc: nil, func: PyInt.asInt, castSelf: selfAsPyInt)
    result._attributes["__float__"] = wrapMethod(context, name: "__float__", doc: nil, func: PyInt.asFloat, castSelf: selfAsPyInt)
    result._attributes["__index__"] = wrapMethod(context, name: "__index__", doc: nil, func: PyInt.asIndex, castSelf: selfAsPyInt)
    result._attributes["real"] = wrapMethod(context, name: "real", doc: nil, func: PyInt.asReal, castSelf: selfAsPyInt)
    result._attributes["imag"] = wrapMethod(context, name: "imag", doc: nil, func: PyInt.asImag, castSelf: selfAsPyInt)
    result._attributes["conjugate"] = wrapMethod(context, name: "conjugate", doc: nil, func: PyInt.conjugate, castSelf: selfAsPyInt)
    result._attributes["numerator"] = wrapMethod(context, name: "numerator", doc: nil, func: PyInt.numerator, castSelf: selfAsPyInt)
    result._attributes["denominator"] = wrapMethod(context, name: "denominator", doc: nil, func: PyInt.denominator, castSelf: selfAsPyInt)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyInt.getAttribute(name:), castSelf: selfAsPyInt)
    result._attributes["__pos__"] = wrapMethod(context, name: "__pos__", doc: nil, func: PyInt.positive, castSelf: selfAsPyInt)
    result._attributes["__neg__"] = wrapMethod(context, name: "__neg__", doc: nil, func: PyInt.negative, castSelf: selfAsPyInt)
    result._attributes["__abs__"] = wrapMethod(context, name: "__abs__", doc: nil, func: PyInt.abs, castSelf: selfAsPyInt)
    result._attributes["__add__"] = wrapMethod(context, name: "__add__", doc: nil, func: PyInt.add(_:), castSelf: selfAsPyInt)
    result._attributes["__radd__"] = wrapMethod(context, name: "__radd__", doc: nil, func: PyInt.radd(_:), castSelf: selfAsPyInt)
    result._attributes["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, func: PyInt.sub(_:), castSelf: selfAsPyInt)
    result._attributes["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, func: PyInt.rsub(_:), castSelf: selfAsPyInt)
    result._attributes["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, func: PyInt.mul(_:), castSelf: selfAsPyInt)
    result._attributes["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, func: PyInt.rmul(_:), castSelf: selfAsPyInt)
    result._attributes["__pow__"] = wrapMethod(context, name: "__pow__", doc: nil, func: PyInt.pow(_:), castSelf: selfAsPyInt)
    result._attributes["__rpow__"] = wrapMethod(context, name: "__rpow__", doc: nil, func: PyInt.rpow(_:), castSelf: selfAsPyInt)
    result._attributes["__truediv__"] = wrapMethod(context, name: "__truediv__", doc: nil, func: PyInt.trueDiv(_:), castSelf: selfAsPyInt)
    result._attributes["__rtruediv__"] = wrapMethod(context, name: "__rtruediv__", doc: nil, func: PyInt.rtrueDiv(_:), castSelf: selfAsPyInt)
    result._attributes["__floordiv__"] = wrapMethod(context, name: "__floordiv__", doc: nil, func: PyInt.floorDiv(_:), castSelf: selfAsPyInt)
    result._attributes["__rfloordiv__"] = wrapMethod(context, name: "__rfloordiv__", doc: nil, func: PyInt.rfloorDiv(_:), castSelf: selfAsPyInt)
    result._attributes["__mod__"] = wrapMethod(context, name: "__mod__", doc: nil, func: PyInt.mod(_:), castSelf: selfAsPyInt)
    result._attributes["__rmod__"] = wrapMethod(context, name: "__rmod__", doc: nil, func: PyInt.rmod(_:), castSelf: selfAsPyInt)
    result._attributes["__divmod__"] = wrapMethod(context, name: "__divmod__", doc: nil, func: PyInt.divMod(_:), castSelf: selfAsPyInt)
    result._attributes["__rdivmod__"] = wrapMethod(context, name: "__rdivmod__", doc: nil, func: PyInt.rdivMod(_:), castSelf: selfAsPyInt)
    result._attributes["__lshift__"] = wrapMethod(context, name: "__lshift__", doc: nil, func: PyInt.lShift(_:), castSelf: selfAsPyInt)
    result._attributes["__rlshift__"] = wrapMethod(context, name: "__rlshift__", doc: nil, func: PyInt.rlShift(_:), castSelf: selfAsPyInt)
    result._attributes["__rshift__"] = wrapMethod(context, name: "__rshift__", doc: nil, func: PyInt.rShift(_:), castSelf: selfAsPyInt)
    result._attributes["__rrshift__"] = wrapMethod(context, name: "__rrshift__", doc: nil, func: PyInt.rrShift(_:), castSelf: selfAsPyInt)
    result._attributes["__and__"] = wrapMethod(context, name: "__and__", doc: nil, func: PyInt.and(_:), castSelf: selfAsPyInt)
    result._attributes["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, func: PyInt.rand(_:), castSelf: selfAsPyInt)
    result._attributes["__or__"] = wrapMethod(context, name: "__or__", doc: nil, func: PyInt.or(_:), castSelf: selfAsPyInt)
    result._attributes["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, func: PyInt.ror(_:), castSelf: selfAsPyInt)
    result._attributes["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, func: PyInt.xor(_:), castSelf: selfAsPyInt)
    result._attributes["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, func: PyInt.rxor(_:), castSelf: selfAsPyInt)
    result._attributes["__invert__"] = wrapMethod(context, name: "__invert__", doc: nil, func: PyInt.invert, castSelf: selfAsPyInt)
    result._attributes["__round__"] = wrapMethod(context, name: "__round__", doc: nil, func: PyInt.round(nDigits:), castSelf: selfAsPyInt)
    return result
  }

  // MARK: - List

  internal static func list(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "list", doc: PyList.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyList.getClass, castSelf: selfAsPyList)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyList.isEqual(_:), castSelf: selfAsPyList)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyList.isNotEqual(_:), castSelf: selfAsPyList)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyList.isLess(_:), castSelf: selfAsPyList)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyList.isLessEqual(_:), castSelf: selfAsPyList)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyList.isGreater(_:), castSelf: selfAsPyList)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyList.isGreaterEqual(_:), castSelf: selfAsPyList)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyList.repr, castSelf: selfAsPyList)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyList.getAttribute(name:), castSelf: selfAsPyList)
    result._attributes["__len__"] = wrapMethod(context, name: "__len__", doc: nil, func: PyList.getLength, castSelf: selfAsPyList)
    result._attributes["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, func: PyList.contains(_:), castSelf: selfAsPyList)
    result._attributes["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, func: PyList.getItem(at:), castSelf: selfAsPyList)
    result._attributes["count"] = wrapMethod(context, name: "count", doc: nil, func: PyList.count(_:), castSelf: selfAsPyList)
    result._attributes["index"] = wrapMethod(context, name: "index", doc: nil, func: PyList.index(of:), castSelf: selfAsPyList)
    result._attributes["append"] = wrapMethod(context, name: "append", doc: nil, func: PyList.append(_:), castSelf: selfAsPyList)
    result._attributes["clear"] = wrapMethod(context, name: "clear", doc: nil, func: PyList.clear, castSelf: selfAsPyList)
    result._attributes["copy"] = wrapMethod(context, name: "copy", doc: nil, func: PyList.copy, castSelf: selfAsPyList)
    result._attributes["__add__"] = wrapMethod(context, name: "__add__", doc: nil, func: PyList.add(_:), castSelf: selfAsPyList)
    result._attributes["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, func: PyList.mul(_:), castSelf: selfAsPyList)
    result._attributes["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, func: PyList.rmul(_:), castSelf: selfAsPyList)
    result._attributes["__imul__"] = wrapMethod(context, name: "__imul__", doc: nil, func: PyList.mulInPlace(_:), castSelf: selfAsPyList)
    return result
  }

  // MARK: - Method

  internal static func method(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "method", doc: PyMethod.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyMethod.getClass, castSelf: selfAsPyMethod)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyMethod.isEqual(_:), castSelf: selfAsPyMethod)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyMethod.isNotEqual(_:), castSelf: selfAsPyMethod)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyMethod.isLess(_:), castSelf: selfAsPyMethod)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyMethod.isLessEqual(_:), castSelf: selfAsPyMethod)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyMethod.isGreater(_:), castSelf: selfAsPyMethod)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyMethod.isGreaterEqual(_:), castSelf: selfAsPyMethod)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyMethod.repr, castSelf: selfAsPyMethod)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyMethod.hash, castSelf: selfAsPyMethod)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyMethod.getAttribute(name:), castSelf: selfAsPyMethod)
    result._attributes["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, func: PyMethod.setAttribute(name:value:), castSelf: selfAsPyMethod)
    result._attributes["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, func: PyMethod.delAttribute(name:), castSelf: selfAsPyMethod)
    result._attributes["__func__"] = wrapMethod(context, name: "__func__", doc: nil, func: PyMethod.getFunc, castSelf: selfAsPyMethod)
    result._attributes["__self__"] = wrapMethod(context, name: "__self__", doc: nil, func: PyMethod.getSelf, castSelf: selfAsPyMethod)
    result._attributes["__get__"] = wrapMethod(context, name: "__get__", doc: nil, func: PyMethod.get(object:), castSelf: selfAsPyMethod)
    return result
  }

  // MARK: - Module

  internal static func module(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "module", doc: PyModule.doc, type: type, base: base)

    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyModule.dict, castSelf: selfAsPyModule)
    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyModule.getClass, castSelf: selfAsPyModule)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyModule.repr, castSelf: selfAsPyModule)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyModule.getAttribute(name:), castSelf: selfAsPyModule)
    result._attributes["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, func: PyModule.setAttribute(name:value:), castSelf: selfAsPyModule)
    result._attributes["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, func: PyModule.delAttribute(name:), castSelf: selfAsPyModule)
    result._attributes["__dir__"] = wrapMethod(context, name: "__dir__", doc: nil, func: PyModule.dir, castSelf: selfAsPyModule)
    return result
  }

  // MARK: - Namespace

  internal static func simpleNamespace(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "types.SimpleNamespace", doc: PyNamespace.doc, type: type, base: base)

    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNamespace.dict, castSelf: selfAsPyNamespace)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyNamespace.isEqual(_:), castSelf: selfAsPyNamespace)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyNamespace.isNotEqual(_:), castSelf: selfAsPyNamespace)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyNamespace.isLess(_:), castSelf: selfAsPyNamespace)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyNamespace.isLessEqual(_:), castSelf: selfAsPyNamespace)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyNamespace.isGreater(_:), castSelf: selfAsPyNamespace)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyNamespace.isGreaterEqual(_:), castSelf: selfAsPyNamespace)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyNamespace.repr, castSelf: selfAsPyNamespace)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyNamespace.getAttribute(name:), castSelf: selfAsPyNamespace)
    result._attributes["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, func: PyNamespace.setAttribute(name:value:), castSelf: selfAsPyNamespace)
    result._attributes["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, func: PyNamespace.delAttribute(name:), castSelf: selfAsPyNamespace)
    return result
  }

  // MARK: - None

  internal static func none(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NoneType", doc: nil, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNone.getClass, castSelf: selfAsPyNone)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyNone.repr, castSelf: selfAsPyNone)
    result._attributes["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, func: PyNone.asBool, castSelf: selfAsPyNone)
    return result
  }

  // MARK: - NotImplemented

  internal static func notImplemented(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedType", doc: nil, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotImplemented.getClass, castSelf: selfAsPyNotImplemented)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyNotImplemented.repr, castSelf: selfAsPyNotImplemented)
    return result
  }

  // MARK: - Property

  internal static func property(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "property", doc: PyProperty.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyProperty.getClass, castSelf: selfAsPyProperty)
    result._attributes["fget"] = createProperty(context, name: "fget", doc: nil, get: PyProperty.getFGet, castSelf: selfAsPyProperty)
    result._attributes["fset"] = createProperty(context, name: "fset", doc: nil, get: PyProperty.getFSet, castSelf: selfAsPyProperty)
    result._attributes["fdel"] = createProperty(context, name: "fdel", doc: nil, get: PyProperty.getFDel, castSelf: selfAsPyProperty)


    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyProperty.getAttribute(name:), castSelf: selfAsPyProperty)
    result._attributes["__get__"] = wrapMethod(context, name: "__get__", doc: nil, func: PyProperty.get(object:), castSelf: selfAsPyProperty)
    result._attributes["__set__"] = wrapMethod(context, name: "__set__", doc: nil, func: PyProperty.set(object:value:), castSelf: selfAsPyProperty)
    result._attributes["__delete__"] = wrapMethod(context, name: "__delete__", doc: nil, func: PyProperty.del(object:), castSelf: selfAsPyProperty)
    return result
  }

  // MARK: - Range

  internal static func range(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "range", doc: PyRange.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRange.getClass, castSelf: selfAsPyRange)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyRange.isEqual(_:), castSelf: selfAsPyRange)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyRange.isNotEqual(_:), castSelf: selfAsPyRange)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyRange.isLess(_:), castSelf: selfAsPyRange)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyRange.isLessEqual(_:), castSelf: selfAsPyRange)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyRange.isGreater(_:), castSelf: selfAsPyRange)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyRange.isGreaterEqual(_:), castSelf: selfAsPyRange)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyRange.hash, castSelf: selfAsPyRange)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyRange.repr, castSelf: selfAsPyRange)
    result._attributes["__bool__"] = wrapMethod(context, name: "__bool__", doc: nil, func: PyRange.asBool, castSelf: selfAsPyRange)
    result._attributes["__len__"] = wrapMethod(context, name: "__len__", doc: nil, func: PyRange.getLength, castSelf: selfAsPyRange)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyRange.getAttribute(name:), castSelf: selfAsPyRange)
    result._attributes["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, func: PyRange.contains(_:), castSelf: selfAsPyRange)
    result._attributes["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, func: PyRange.getItem(at:), castSelf: selfAsPyRange)
    result._attributes["count"] = wrapMethod(context, name: "count", doc: nil, func: PyRange.count(_:), castSelf: selfAsPyRange)
    result._attributes["index"] = wrapMethod(context, name: "index", doc: nil, func: PyRange.index(of:), castSelf: selfAsPyRange)
    return result
  }

  // MARK: - Set

  internal static func set(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "set", doc: PySet.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySet.getClass, castSelf: selfAsPySet)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PySet.isEqual(_:), castSelf: selfAsPySet)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PySet.isNotEqual(_:), castSelf: selfAsPySet)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PySet.isLess(_:), castSelf: selfAsPySet)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PySet.isLessEqual(_:), castSelf: selfAsPySet)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PySet.isGreater(_:), castSelf: selfAsPySet)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PySet.isGreaterEqual(_:), castSelf: selfAsPySet)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PySet.hash, castSelf: selfAsPySet)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PySet.repr, castSelf: selfAsPySet)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PySet.getAttribute(name:), castSelf: selfAsPySet)
    result._attributes["__len__"] = wrapMethod(context, name: "__len__", doc: nil, func: PySet.getLength, castSelf: selfAsPySet)
    result._attributes["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, func: PySet.contains(_:), castSelf: selfAsPySet)
    result._attributes["__and__"] = wrapMethod(context, name: "__and__", doc: nil, func: PySet.and(_:), castSelf: selfAsPySet)
    result._attributes["__rand__"] = wrapMethod(context, name: "__rand__", doc: nil, func: PySet.rand(_:), castSelf: selfAsPySet)
    result._attributes["__or__"] = wrapMethod(context, name: "__or__", doc: nil, func: PySet.or(_:), castSelf: selfAsPySet)
    result._attributes["__ror__"] = wrapMethod(context, name: "__ror__", doc: nil, func: PySet.ror(_:), castSelf: selfAsPySet)
    result._attributes["__xor__"] = wrapMethod(context, name: "__xor__", doc: nil, func: PySet.xor(_:), castSelf: selfAsPySet)
    result._attributes["__rxor__"] = wrapMethod(context, name: "__rxor__", doc: nil, func: PySet.rxor(_:), castSelf: selfAsPySet)
    result._attributes["__sub__"] = wrapMethod(context, name: "__sub__", doc: nil, func: PySet.sub(_:), castSelf: selfAsPySet)
    result._attributes["__rsub__"] = wrapMethod(context, name: "__rsub__", doc: nil, func: PySet.rsub(_:), castSelf: selfAsPySet)
    result._attributes["issubset"] = wrapMethod(context, name: "issubset", doc: nil, func: PySet.isSubset(of:), castSelf: selfAsPySet)
    result._attributes["issuperset"] = wrapMethod(context, name: "issuperset", doc: nil, func: PySet.isSuperset(of:), castSelf: selfAsPySet)
    result._attributes["intersection"] = wrapMethod(context, name: "intersection", doc: nil, func: PySet.intersection(with:), castSelf: selfAsPySet)
    result._attributes["union"] = wrapMethod(context, name: "union", doc: nil, func: PySet.union(with:), castSelf: selfAsPySet)
    result._attributes["difference"] = wrapMethod(context, name: "difference", doc: nil, func: PySet.difference(with:), castSelf: selfAsPySet)
    result._attributes["symmetric_difference"] = wrapMethod(context, name: "symmetric_difference", doc: nil, func: PySet.symmetricDifference(with:), castSelf: selfAsPySet)
    result._attributes["isdisjoint"] = wrapMethod(context, name: "isdisjoint", doc: nil, func: PySet.isDisjoint(with:), castSelf: selfAsPySet)
    result._attributes["add"] = wrapMethod(context, name: "add", doc: nil, func: PySet.add(_:), castSelf: selfAsPySet)
    result._attributes["remove"] = wrapMethod(context, name: "remove", doc: nil, func: PySet.remove(_:), castSelf: selfAsPySet)
    result._attributes["discard"] = wrapMethod(context, name: "discard", doc: nil, func: PySet.discard(_:), castSelf: selfAsPySet)
    result._attributes["clear"] = wrapMethod(context, name: "clear", doc: nil, func: PySet.clear, castSelf: selfAsPySet)
    result._attributes["copy"] = wrapMethod(context, name: "copy", doc: nil, func: PySet.copy, castSelf: selfAsPySet)
    result._attributes["pop"] = wrapMethod(context, name: "pop", doc: nil, func: PySet.pop, castSelf: selfAsPySet)
    return result
  }

  // MARK: - Slice

  internal static func slice(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "slice", doc: PySlice.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySlice.getClass, castSelf: selfAsPySlice)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PySlice.isEqual(_:), castSelf: selfAsPySlice)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PySlice.isNotEqual(_:), castSelf: selfAsPySlice)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PySlice.isLess(_:), castSelf: selfAsPySlice)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PySlice.isLessEqual(_:), castSelf: selfAsPySlice)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PySlice.isGreater(_:), castSelf: selfAsPySlice)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PySlice.isGreaterEqual(_:), castSelf: selfAsPySlice)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PySlice.repr, castSelf: selfAsPySlice)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PySlice.getAttribute(name:), castSelf: selfAsPySlice)
    return result
  }

  // MARK: - String

  internal static func str(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "str", doc: PyString.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyString.getClass, castSelf: selfAsPyString)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyString.isEqual(_:), castSelf: selfAsPyString)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyString.isNotEqual(_:), castSelf: selfAsPyString)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyString.isLess(_:), castSelf: selfAsPyString)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyString.isLessEqual(_:), castSelf: selfAsPyString)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyString.isGreater(_:), castSelf: selfAsPyString)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyString.isGreaterEqual(_:), castSelf: selfAsPyString)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyString.hash, castSelf: selfAsPyString)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyString.repr, castSelf: selfAsPyString)
    result._attributes["__str__"] = wrapMethod(context, name: "__str__", doc: nil, func: PyString.str, castSelf: selfAsPyString)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyString.getAttribute(name:), castSelf: selfAsPyString)
    result._attributes["__len__"] = wrapMethod(context, name: "__len__", doc: nil, func: PyString.getLength, castSelf: selfAsPyString)
    result._attributes["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, func: PyString.contains(_:), castSelf: selfAsPyString)
    result._attributes["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, func: PyString.getItem(at:), castSelf: selfAsPyString)
    result._attributes["isalnum"] = wrapMethod(context, name: "isalnum", doc: nil, func: PyString.isAlphaNumeric, castSelf: selfAsPyString)
    result._attributes["isalpha"] = wrapMethod(context, name: "isalpha", doc: nil, func: PyString.isAlpha, castSelf: selfAsPyString)
    result._attributes["isascii"] = wrapMethod(context, name: "isascii", doc: nil, func: PyString.isAscii, castSelf: selfAsPyString)
    result._attributes["isdecimal"] = wrapMethod(context, name: "isdecimal", doc: nil, func: PyString.isDecimal, castSelf: selfAsPyString)
    result._attributes["isdigit"] = wrapMethod(context, name: "isdigit", doc: nil, func: PyString.isDigit, castSelf: selfAsPyString)
    result._attributes["isidentifier"] = wrapMethod(context, name: "isidentifier", doc: nil, func: PyString.isIdentifier, castSelf: selfAsPyString)
    result._attributes["islower"] = wrapMethod(context, name: "islower", doc: nil, func: PyString.isLower, castSelf: selfAsPyString)
    result._attributes["isnumeric"] = wrapMethod(context, name: "isnumeric", doc: nil, func: PyString.isNumeric, castSelf: selfAsPyString)
    result._attributes["isprintable"] = wrapMethod(context, name: "isprintable", doc: nil, func: PyString.isPrintable, castSelf: selfAsPyString)
    result._attributes["isspace"] = wrapMethod(context, name: "isspace", doc: nil, func: PyString.isSpace, castSelf: selfAsPyString)
    result._attributes["istitle"] = wrapMethod(context, name: "istitle", doc: nil, func: PyString.isTitle, castSelf: selfAsPyString)
    result._attributes["isupper"] = wrapMethod(context, name: "isupper", doc: nil, func: PyString.isUpper, castSelf: selfAsPyString)
    result._attributes["startswith"] = wrapMethod(context, name: "startswith", doc: nil, func: PyString.startsWith(_:start:end:), castSelf: selfAsPyString)
    result._attributes["endswith"] = wrapMethod(context, name: "endswith", doc: nil, func: PyString.endsWith(_:start:end:), castSelf: selfAsPyString)
    result._attributes["strip"] = wrapMethod(context, name: "strip", doc: nil, func: PyString.strip(_:), castSelf: selfAsPyString)
    result._attributes["lstrip"] = wrapMethod(context, name: "lstrip", doc: nil, func: PyString.lstrip(_:), castSelf: selfAsPyString)
    result._attributes["rstrip"] = wrapMethod(context, name: "rstrip", doc: nil, func: PyString.rstrip(_:), castSelf: selfAsPyString)
    result._attributes["find"] = wrapMethod(context, name: "find", doc: nil, func: PyString.find(_:start:end:), castSelf: selfAsPyString)
    result._attributes["rfind"] = wrapMethod(context, name: "rfind", doc: nil, func: PyString.rfind(_:start:end:), castSelf: selfAsPyString)
    result._attributes["index"] = wrapMethod(context, name: "index", doc: nil, func: PyString.index(of:start:end:), castSelf: selfAsPyString)
    result._attributes["rindex"] = wrapMethod(context, name: "rindex", doc: nil, func: PyString.rindex(_:start:end:), castSelf: selfAsPyString)
    result._attributes["lower"] = wrapMethod(context, name: "lower", doc: nil, func: PyString.lower, castSelf: selfAsPyString)
    result._attributes["upper"] = wrapMethod(context, name: "upper", doc: nil, func: PyString.upper, castSelf: selfAsPyString)
    result._attributes["title"] = wrapMethod(context, name: "title", doc: nil, func: PyString.title, castSelf: selfAsPyString)
    result._attributes["swapcase"] = wrapMethod(context, name: "swapcase", doc: nil, func: PyString.swapcase, castSelf: selfAsPyString)
    result._attributes["casefold"] = wrapMethod(context, name: "casefold", doc: nil, func: PyString.casefold, castSelf: selfAsPyString)
    result._attributes["capitalize"] = wrapMethod(context, name: "capitalize", doc: nil, func: PyString.capitalize, castSelf: selfAsPyString)
    result._attributes["center"] = wrapMethod(context, name: "center", doc: nil, func: PyString.center(width:fillChar:), castSelf: selfAsPyString)
    result._attributes["ljust"] = wrapMethod(context, name: "ljust", doc: nil, func: PyString.ljust(width:fillChar:), castSelf: selfAsPyString)
    result._attributes["rjust"] = wrapMethod(context, name: "rjust", doc: nil, func: PyString.rjust(width:fillChar:), castSelf: selfAsPyString)
    result._attributes["split"] = wrapMethod(context, name: "split", doc: nil, func: PyString.split(separator:maxCount:), castSelf: selfAsPyString)
    result._attributes["rsplit"] = wrapMethod(context, name: "rsplit", doc: nil, func: PyString.rsplit(separator:maxCount:), castSelf: selfAsPyString)
    result._attributes["splitlines"] = wrapMethod(context, name: "splitlines", doc: nil, func: PyString.splitLines(keepEnds:), castSelf: selfAsPyString)
    result._attributes["partition"] = wrapMethod(context, name: "partition", doc: nil, func: PyString.partition(separator:), castSelf: selfAsPyString)
    result._attributes["rpartition"] = wrapMethod(context, name: "rpartition", doc: nil, func: PyString.rpartition(separator:), castSelf: selfAsPyString)
    result._attributes["expandtabs"] = wrapMethod(context, name: "expandtabs", doc: nil, func: PyString.expandTabs(tabSize:), castSelf: selfAsPyString)
    result._attributes["count"] = wrapMethod(context, name: "count", doc: nil, func: PyString.count(_:start:end:), castSelf: selfAsPyString)
    result._attributes["replace"] = wrapMethod(context, name: "replace", doc: nil, func: PyString.replace(old:new:count:), castSelf: selfAsPyString)
    result._attributes["zfill"] = wrapMethod(context, name: "zfill", doc: nil, func: PyString.zfill(width:), castSelf: selfAsPyString)
    result._attributes["__add__"] = wrapMethod(context, name: "__add__", doc: nil, func: PyString.add(_:), castSelf: selfAsPyString)
    result._attributes["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, func: PyString.mul(_:), castSelf: selfAsPyString)
    result._attributes["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, func: PyString.rmul(_:), castSelf: selfAsPyString)
    return result
  }

  // MARK: - Tuple

  internal static func tuple(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "tuple", doc: PyTuple.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTuple.getClass, castSelf: selfAsPyTuple)


    result._attributes["__eq__"] = wrapMethod(context, name: "__eq__", doc: nil, func: PyTuple.isEqual(_:), castSelf: selfAsPyTuple)
    result._attributes["__ne__"] = wrapMethod(context, name: "__ne__", doc: nil, func: PyTuple.isNotEqual(_:), castSelf: selfAsPyTuple)
    result._attributes["__lt__"] = wrapMethod(context, name: "__lt__", doc: nil, func: PyTuple.isLess(_:), castSelf: selfAsPyTuple)
    result._attributes["__le__"] = wrapMethod(context, name: "__le__", doc: nil, func: PyTuple.isLessEqual(_:), castSelf: selfAsPyTuple)
    result._attributes["__gt__"] = wrapMethod(context, name: "__gt__", doc: nil, func: PyTuple.isGreater(_:), castSelf: selfAsPyTuple)
    result._attributes["__ge__"] = wrapMethod(context, name: "__ge__", doc: nil, func: PyTuple.isGreaterEqual(_:), castSelf: selfAsPyTuple)
    result._attributes["__hash__"] = wrapMethod(context, name: "__hash__", doc: nil, func: PyTuple.hash, castSelf: selfAsPyTuple)
    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyTuple.repr, castSelf: selfAsPyTuple)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyTuple.getAttribute(name:), castSelf: selfAsPyTuple)
    result._attributes["__len__"] = wrapMethod(context, name: "__len__", doc: nil, func: PyTuple.getLength, castSelf: selfAsPyTuple)
    result._attributes["__contains__"] = wrapMethod(context, name: "__contains__", doc: nil, func: PyTuple.contains(_:), castSelf: selfAsPyTuple)
    result._attributes["__getitem__"] = wrapMethod(context, name: "__getitem__", doc: nil, func: PyTuple.getItem(at:), castSelf: selfAsPyTuple)
    result._attributes["count"] = wrapMethod(context, name: "count", doc: nil, func: PyTuple.count(_:), castSelf: selfAsPyTuple)
    result._attributes["index"] = wrapMethod(context, name: "index", doc: nil, func: PyTuple.index(of:), castSelf: selfAsPyTuple)
    result._attributes["__add__"] = wrapMethod(context, name: "__add__", doc: nil, func: PyTuple.add(_:), castSelf: selfAsPyTuple)
    result._attributes["__mul__"] = wrapMethod(context, name: "__mul__", doc: nil, func: PyTuple.mul(_:), castSelf: selfAsPyTuple)
    result._attributes["__rmul__"] = wrapMethod(context, name: "__rmul__", doc: nil, func: PyTuple.rmul(_:), castSelf: selfAsPyTuple)
    return result
  }

  // MARK: - ArithmeticError

  internal static func arithmeticError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ArithmeticError", doc: PyArithmeticError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyArithmeticError.getClass, castSelf: selfAsPyArithmeticError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyArithmeticError.dict, castSelf: selfAsPyArithmeticError)


    return result
  }

  // MARK: - AssertionError

  internal static func assertionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "AssertionError", doc: PyAssertionError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyAssertionError.getClass, castSelf: selfAsPyAssertionError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyAssertionError.dict, castSelf: selfAsPyAssertionError)


    return result
  }

  // MARK: - AttributeError

  internal static func attributeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "AttributeError", doc: PyAttributeError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyAttributeError.getClass, castSelf: selfAsPyAttributeError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyAttributeError.dict, castSelf: selfAsPyAttributeError)


    return result
  }

  // MARK: - BaseException

  internal static func baseException(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BaseException", doc: PyBaseException.doc, type: type, base: base)

    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBaseException.dict, castSelf: selfAsPyBaseException)
    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBaseException.getClass, castSelf: selfAsPyBaseException)
    result._attributes["args"] = createProperty(context, name: "args", doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: selfAsPyBaseException)
    result._attributes["__traceback__"] = createProperty(context, name: "__traceback__", doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: selfAsPyBaseException)
    result._attributes["__cause__"] = createProperty(context, name: "__cause__", doc: nil, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: selfAsPyBaseException)
    result._attributes["__context__"] = createProperty(context, name: "__context__", doc: nil, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: selfAsPyBaseException)
    result._attributes["__suppress_context__"] = createProperty(context, name: "__suppress_context__", doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: selfAsPyBaseException)


    result._attributes["__repr__"] = wrapMethod(context, name: "__repr__", doc: nil, func: PyBaseException.repr, castSelf: selfAsPyBaseException)
    result._attributes["__str__"] = wrapMethod(context, name: "__str__", doc: nil, func: PyBaseException.str, castSelf: selfAsPyBaseException)
    result._attributes["__getattribute__"] = wrapMethod(context, name: "__getattribute__", doc: nil, func: PyBaseException.getAttribute(name:), castSelf: selfAsPyBaseException)
    result._attributes["__setattr__"] = wrapMethod(context, name: "__setattr__", doc: nil, func: PyBaseException.setAttribute(name:value:), castSelf: selfAsPyBaseException)
    result._attributes["__delattr__"] = wrapMethod(context, name: "__delattr__", doc: nil, func: PyBaseException.delAttribute(name:), castSelf: selfAsPyBaseException)
    return result
  }

  // MARK: - BlockingIOError

  internal static func blockingIOError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BlockingIOError", doc: PyBlockingIOError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBlockingIOError.getClass, castSelf: selfAsPyBlockingIOError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBlockingIOError.dict, castSelf: selfAsPyBlockingIOError)


    return result
  }

  // MARK: - BrokenPipeError

  internal static func brokenPipeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BrokenPipeError", doc: PyBrokenPipeError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBrokenPipeError.getClass, castSelf: selfAsPyBrokenPipeError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBrokenPipeError.dict, castSelf: selfAsPyBrokenPipeError)


    return result
  }

  // MARK: - BufferError

  internal static func bufferError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BufferError", doc: PyBufferError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBufferError.getClass, castSelf: selfAsPyBufferError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBufferError.dict, castSelf: selfAsPyBufferError)


    return result
  }

  // MARK: - BytesWarning

  internal static func bytesWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BytesWarning", doc: PyBytesWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyBytesWarning.getClass, castSelf: selfAsPyBytesWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyBytesWarning.dict, castSelf: selfAsPyBytesWarning)


    return result
  }

  // MARK: - ChildProcessError

  internal static func childProcessError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ChildProcessError", doc: PyChildProcessError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyChildProcessError.getClass, castSelf: selfAsPyChildProcessError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyChildProcessError.dict, castSelf: selfAsPyChildProcessError)


    return result
  }

  // MARK: - ConnectionAbortedError

  internal static func connectionAbortedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionAbortedError", doc: PyConnectionAbortedError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionAbortedError.getClass, castSelf: selfAsPyConnectionAbortedError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionAbortedError.dict, castSelf: selfAsPyConnectionAbortedError)


    return result
  }

  // MARK: - ConnectionError

  internal static func connectionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionError", doc: PyConnectionError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionError.getClass, castSelf: selfAsPyConnectionError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionError.dict, castSelf: selfAsPyConnectionError)


    return result
  }

  // MARK: - ConnectionRefusedError

  internal static func connectionRefusedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionRefusedError", doc: PyConnectionRefusedError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionRefusedError.getClass, castSelf: selfAsPyConnectionRefusedError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionRefusedError.dict, castSelf: selfAsPyConnectionRefusedError)


    return result
  }

  // MARK: - ConnectionResetError

  internal static func connectionResetError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ConnectionResetError", doc: PyConnectionResetError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyConnectionResetError.getClass, castSelf: selfAsPyConnectionResetError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyConnectionResetError.dict, castSelf: selfAsPyConnectionResetError)


    return result
  }

  // MARK: - DeprecationWarning

  internal static func deprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "DeprecationWarning", doc: PyDeprecationWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyDeprecationWarning.getClass, castSelf: selfAsPyDeprecationWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyDeprecationWarning.dict, castSelf: selfAsPyDeprecationWarning)


    return result
  }

  // MARK: - EOFError

  internal static func eofError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "EOFError", doc: PyEOFError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyEOFError.getClass, castSelf: selfAsPyEOFError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyEOFError.dict, castSelf: selfAsPyEOFError)


    return result
  }

  // MARK: - Exception

  internal static func exception(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "Exception", doc: PyException.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyException.getClass, castSelf: selfAsPyException)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyException.dict, castSelf: selfAsPyException)


    return result
  }

  // MARK: - FileExistsError

  internal static func fileExistsError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FileExistsError", doc: PyFileExistsError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFileExistsError.getClass, castSelf: selfAsPyFileExistsError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFileExistsError.dict, castSelf: selfAsPyFileExistsError)


    return result
  }

  // MARK: - FileNotFoundError

  internal static func fileNotFoundError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FileNotFoundError", doc: PyFileNotFoundError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFileNotFoundError.getClass, castSelf: selfAsPyFileNotFoundError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFileNotFoundError.dict, castSelf: selfAsPyFileNotFoundError)


    return result
  }

  // MARK: - FloatingPointError

  internal static func floatingPointError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FloatingPointError", doc: PyFloatingPointError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFloatingPointError.getClass, castSelf: selfAsPyFloatingPointError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFloatingPointError.dict, castSelf: selfAsPyFloatingPointError)


    return result
  }

  // MARK: - FutureWarning

  internal static func futureWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FutureWarning", doc: PyFutureWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyFutureWarning.getClass, castSelf: selfAsPyFutureWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyFutureWarning.dict, castSelf: selfAsPyFutureWarning)


    return result
  }

  // MARK: - GeneratorExit

  internal static func generatorExit(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "GeneratorExit", doc: PyGeneratorExit.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyGeneratorExit.getClass, castSelf: selfAsPyGeneratorExit)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyGeneratorExit.dict, castSelf: selfAsPyGeneratorExit)


    return result
  }

  // MARK: - ImportError

  internal static func importError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ImportError", doc: PyImportError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyImportError.getClass, castSelf: selfAsPyImportError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyImportError.dict, castSelf: selfAsPyImportError)


    return result
  }

  // MARK: - ImportWarning

  internal static func importWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ImportWarning", doc: PyImportWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyImportWarning.getClass, castSelf: selfAsPyImportWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyImportWarning.dict, castSelf: selfAsPyImportWarning)


    return result
  }

  // MARK: - IndentationError

  internal static func indentationError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IndentationError", doc: PyIndentationError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIndentationError.getClass, castSelf: selfAsPyIndentationError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIndentationError.dict, castSelf: selfAsPyIndentationError)


    return result
  }

  // MARK: - IndexError

  internal static func indexError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IndexError", doc: PyIndexError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIndexError.getClass, castSelf: selfAsPyIndexError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIndexError.dict, castSelf: selfAsPyIndexError)


    return result
  }

  // MARK: - InterruptedError

  internal static func interruptedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "InterruptedError", doc: PyInterruptedError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyInterruptedError.getClass, castSelf: selfAsPyInterruptedError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyInterruptedError.dict, castSelf: selfAsPyInterruptedError)


    return result
  }

  // MARK: - IsADirectoryError

  internal static func isADirectoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "IsADirectoryError", doc: PyIsADirectoryError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyIsADirectoryError.getClass, castSelf: selfAsPyIsADirectoryError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyIsADirectoryError.dict, castSelf: selfAsPyIsADirectoryError)


    return result
  }

  // MARK: - KeyError

  internal static func keyError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "KeyError", doc: PyKeyError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyKeyError.getClass, castSelf: selfAsPyKeyError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyKeyError.dict, castSelf: selfAsPyKeyError)


    return result
  }

  // MARK: - KeyboardInterrupt

  internal static func keyboardInterrupt(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "KeyboardInterrupt", doc: PyKeyboardInterrupt.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyKeyboardInterrupt.getClass, castSelf: selfAsPyKeyboardInterrupt)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyKeyboardInterrupt.dict, castSelf: selfAsPyKeyboardInterrupt)


    return result
  }

  // MARK: - LookupError

  internal static func lookupError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "LookupError", doc: PyLookupError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyLookupError.getClass, castSelf: selfAsPyLookupError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyLookupError.dict, castSelf: selfAsPyLookupError)


    return result
  }

  // MARK: - MemoryError

  internal static func memoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "MemoryError", doc: PyMemoryError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyMemoryError.getClass, castSelf: selfAsPyMemoryError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyMemoryError.dict, castSelf: selfAsPyMemoryError)


    return result
  }

  // MARK: - ModuleNotFoundError

  internal static func moduleNotFoundError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ModuleNotFoundError", doc: PyModuleNotFoundError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyModuleNotFoundError.getClass, castSelf: selfAsPyModuleNotFoundError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyModuleNotFoundError.dict, castSelf: selfAsPyModuleNotFoundError)


    return result
  }

  // MARK: - NameError

  internal static func nameError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NameError", doc: PyNameError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNameError.getClass, castSelf: selfAsPyNameError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNameError.dict, castSelf: selfAsPyNameError)


    return result
  }

  // MARK: - NotADirectoryError

  internal static func notADirectoryError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotADirectoryError", doc: PyNotADirectoryError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotADirectoryError.getClass, castSelf: selfAsPyNotADirectoryError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNotADirectoryError.dict, castSelf: selfAsPyNotADirectoryError)


    return result
  }

  // MARK: - NotImplementedError

  internal static func notImplementedError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedError", doc: PyNotImplementedError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyNotImplementedError.getClass, castSelf: selfAsPyNotImplementedError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyNotImplementedError.dict, castSelf: selfAsPyNotImplementedError)


    return result
  }

  // MARK: - OSError

  internal static func osError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "OSError", doc: PyOSError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyOSError.getClass, castSelf: selfAsPyOSError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyOSError.dict, castSelf: selfAsPyOSError)


    return result
  }

  // MARK: - OverflowError

  internal static func overflowError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "OverflowError", doc: PyOverflowError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyOverflowError.getClass, castSelf: selfAsPyOverflowError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyOverflowError.dict, castSelf: selfAsPyOverflowError)


    return result
  }

  // MARK: - PendingDeprecationWarning

  internal static func pendingDeprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "PendingDeprecationWarning", doc: PyPendingDeprecationWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyPendingDeprecationWarning.getClass, castSelf: selfAsPyPendingDeprecationWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyPendingDeprecationWarning.dict, castSelf: selfAsPyPendingDeprecationWarning)


    return result
  }

  // MARK: - PermissionError

  internal static func permissionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "PermissionError", doc: PyPermissionError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyPermissionError.getClass, castSelf: selfAsPyPermissionError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyPermissionError.dict, castSelf: selfAsPyPermissionError)


    return result
  }

  // MARK: - ProcessLookupError

  internal static func processLookupError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ProcessLookupError", doc: PyProcessLookupError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyProcessLookupError.getClass, castSelf: selfAsPyProcessLookupError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyProcessLookupError.dict, castSelf: selfAsPyProcessLookupError)


    return result
  }

  // MARK: - RecursionError

  internal static func recursionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RecursionError", doc: PyRecursionError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRecursionError.getClass, castSelf: selfAsPyRecursionError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRecursionError.dict, castSelf: selfAsPyRecursionError)


    return result
  }

  // MARK: - ReferenceError

  internal static func referenceError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ReferenceError", doc: PyReferenceError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyReferenceError.getClass, castSelf: selfAsPyReferenceError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyReferenceError.dict, castSelf: selfAsPyReferenceError)


    return result
  }

  // MARK: - ResourceWarning

  internal static func resourceWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ResourceWarning", doc: PyResourceWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyResourceWarning.getClass, castSelf: selfAsPyResourceWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyResourceWarning.dict, castSelf: selfAsPyResourceWarning)


    return result
  }

  // MARK: - RuntimeError

  internal static func runtimeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RuntimeError", doc: PyRuntimeError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRuntimeError.getClass, castSelf: selfAsPyRuntimeError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRuntimeError.dict, castSelf: selfAsPyRuntimeError)


    return result
  }

  // MARK: - RuntimeWarning

  internal static func runtimeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RuntimeWarning", doc: PyRuntimeWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyRuntimeWarning.getClass, castSelf: selfAsPyRuntimeWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyRuntimeWarning.dict, castSelf: selfAsPyRuntimeWarning)


    return result
  }

  // MARK: - StopAsyncIteration

  internal static func stopAsyncIteration(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "StopAsyncIteration", doc: PyStopAsyncIteration.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyStopAsyncIteration.getClass, castSelf: selfAsPyStopAsyncIteration)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyStopAsyncIteration.dict, castSelf: selfAsPyStopAsyncIteration)


    return result
  }

  // MARK: - StopIteration

  internal static func stopIteration(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "StopIteration", doc: PyStopIteration.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyStopIteration.getClass, castSelf: selfAsPyStopIteration)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyStopIteration.dict, castSelf: selfAsPyStopIteration)


    return result
  }

  // MARK: - SyntaxError

  internal static func syntaxError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SyntaxError", doc: PySyntaxError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySyntaxError.getClass, castSelf: selfAsPySyntaxError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySyntaxError.dict, castSelf: selfAsPySyntaxError)


    return result
  }

  // MARK: - SyntaxWarning

  internal static func syntaxWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SyntaxWarning", doc: PySyntaxWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySyntaxWarning.getClass, castSelf: selfAsPySyntaxWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySyntaxWarning.dict, castSelf: selfAsPySyntaxWarning)


    return result
  }

  // MARK: - SystemError

  internal static func systemError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SystemError", doc: PySystemError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySystemError.getClass, castSelf: selfAsPySystemError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySystemError.dict, castSelf: selfAsPySystemError)


    return result
  }

  // MARK: - SystemExit

  internal static func systemExit(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SystemExit", doc: PySystemExit.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PySystemExit.getClass, castSelf: selfAsPySystemExit)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PySystemExit.dict, castSelf: selfAsPySystemExit)


    return result
  }

  // MARK: - TabError

  internal static func tabError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TabError", doc: PyTabError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTabError.getClass, castSelf: selfAsPyTabError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTabError.dict, castSelf: selfAsPyTabError)


    return result
  }

  // MARK: - TimeoutError

  internal static func timeoutError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TimeoutError", doc: PyTimeoutError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTimeoutError.getClass, castSelf: selfAsPyTimeoutError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTimeoutError.dict, castSelf: selfAsPyTimeoutError)


    return result
  }

  // MARK: - TypeError

  internal static func typeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "TypeError", doc: PyTypeError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyTypeError.getClass, castSelf: selfAsPyTypeError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyTypeError.dict, castSelf: selfAsPyTypeError)


    return result
  }

  // MARK: - UnboundLocalError

  internal static func unboundLocalError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnboundLocalError", doc: PyUnboundLocalError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnboundLocalError.getClass, castSelf: selfAsPyUnboundLocalError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnboundLocalError.dict, castSelf: selfAsPyUnboundLocalError)


    return result
  }

  // MARK: - UnicodeDecodeError

  internal static func unicodeDecodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeDecodeError", doc: PyUnicodeDecodeError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeDecodeError.getClass, castSelf: selfAsPyUnicodeDecodeError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeDecodeError.dict, castSelf: selfAsPyUnicodeDecodeError)


    return result
  }

  // MARK: - UnicodeEncodeError

  internal static func unicodeEncodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeEncodeError", doc: PyUnicodeEncodeError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeEncodeError.getClass, castSelf: selfAsPyUnicodeEncodeError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeEncodeError.dict, castSelf: selfAsPyUnicodeEncodeError)


    return result
  }

  // MARK: - UnicodeError

  internal static func unicodeError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeError", doc: PyUnicodeError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeError.getClass, castSelf: selfAsPyUnicodeError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeError.dict, castSelf: selfAsPyUnicodeError)


    return result
  }

  // MARK: - UnicodeTranslateError

  internal static func unicodeTranslateError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeTranslateError", doc: PyUnicodeTranslateError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeTranslateError.getClass, castSelf: selfAsPyUnicodeTranslateError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeTranslateError.dict, castSelf: selfAsPyUnicodeTranslateError)


    return result
  }

  // MARK: - UnicodeWarning

  internal static func unicodeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeWarning", doc: PyUnicodeWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUnicodeWarning.getClass, castSelf: selfAsPyUnicodeWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeWarning.dict, castSelf: selfAsPyUnicodeWarning)


    return result
  }

  // MARK: - UserWarning

  internal static func userWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UserWarning", doc: PyUserWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyUserWarning.getClass, castSelf: selfAsPyUserWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyUserWarning.dict, castSelf: selfAsPyUserWarning)


    return result
  }

  // MARK: - ValueError

  internal static func valueError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ValueError", doc: PyValueError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyValueError.getClass, castSelf: selfAsPyValueError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyValueError.dict, castSelf: selfAsPyValueError)


    return result
  }

  // MARK: - Warning

  internal static func warning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "Warning", doc: PyWarning.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyWarning.getClass, castSelf: selfAsPyWarning)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyWarning.dict, castSelf: selfAsPyWarning)


    return result
  }

  // MARK: - ZeroDivisionError

  internal static func zeroDivisionError(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ZeroDivisionError", doc: PyZeroDivisionError.doc, type: type, base: base)

    result._attributes["__class__"] = createProperty(context, name: "__class__", doc: nil, get: PyZeroDivisionError.getClass, castSelf: selfAsPyZeroDivisionError)
    result._attributes["__dict__"] = createProperty(context, name: "__dict__", doc: nil, get: PyZeroDivisionError.dict, castSelf: selfAsPyZeroDivisionError)


    return result
  }
}
