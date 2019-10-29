// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable function_body_length



extension PyType {

  // MARK: - Base object

  /// Create `object` type without assigning `type` property.
  internal static func objectWithoutType(_ context: PyContext) -> PyType {
    let result = PyType.initWithoutType(context, name: "object", doc: PyBaseObject.doc, base: nil)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyBaseObject.isEqual(zelf:other:))
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyBaseObject.isNotEqual(zelf:other:))
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyBaseObject.isLess(zelf:other:))
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyBaseObject.isLessEqual(zelf:other:))
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyBaseObject.isGreater(zelf:other:))
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyBaseObject.isGreaterEqual(zelf:other:))
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyBaseObject.hash(zelf:))
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyBaseObject.repr(zelf:))
    result._attributes["__str__"] = PyType.wrapMethod(context, name: "__str__", doc: nil, func: PyBaseObject.str(zelf:))
    result._attributes["__format__"] = PyType.wrapMethod(context, name: "__format__", doc: nil, func: PyBaseObject.format(zelf:spec:))
    result._attributes["__class__"] = PyType.wrapMethod(context, name: "__class__", doc: nil, func: PyBaseObject.getClass(zelf:))
    result._attributes["__dir__"] = PyType.wrapMethod(context, name: "__dir__", doc: nil, func: PyBaseObject.dir(zelf:))
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyBaseObject.getAttribute(zelf:name:))
    result._attributes["__setattr__"] = PyType.wrapMethod(context, name: "__setattr__", doc: nil, func: PyBaseObject.setAttribute(zelf:name:value:))
    result._attributes["__delattr__"] = PyType.wrapMethod(context, name: "__delattr__", doc: nil, func: PyBaseObject.delAttribute(zelf:name:))
    result._attributes["__subclasshook__"] = PyType.wrapMethod(context, name: "__subclasshook__", doc: nil, func: PyBaseObject.subclasshook(zelf:))
    result._attributes["__init_subclass__"] = PyType.wrapMethod(context, name: "__init_subclass__", doc: nil, func: PyBaseObject.initSubclass(zelf:))

    return result
  }

  // MARK: - Type type

  /// Create `type` type without assigning `type` property.
  internal static func typeWithoutType(_ context: PyContext, base: PyType) -> PyType {
    let result = PyType.initWithoutType(context, name: "type", doc: PyType.doc, base: base)

    result._attributes["__name__"] = PyType.createProperty(context, name: "__name__", doc: nil, get: PyType.getName, set: PyType.setName, castSelf: PyType.selfAsPyType)
    result._attributes["__qualname__"] = PyType.createProperty(context, name: "__qualname__", doc: nil, get: PyType.getQualname, set: PyType.setQualname, castSelf: PyType.selfAsPyType)
    result._attributes["__module__"] = PyType.createProperty(context, name: "__module__", doc: nil, get: PyType.getModule, set: PyType.setModule, castSelf: PyType.selfAsPyType)
    result._attributes["__bases__"] = PyType.createProperty(context, name: "__bases__", doc: nil, get: PyType.getBases, set: PyType.setBases, castSelf: PyType.selfAsPyType)
    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyType.dict, castSelf: PyType.selfAsPyType)
    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyType.getClass, castSelf: PyType.selfAsPyType)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyType.repr, castSelf: PyType.selfAsPyType)
    result._attributes["__subclasses__"] = PyType.wrapMethod(context, name: "__subclasses__", doc: nil, func: PyType.getSubclasses, castSelf: PyType.selfAsPyType)
    result._attributes["__instancecheck__"] = PyType.wrapMethod(context, name: "__instancecheck__", doc: nil, func: PyType.isInstance(of:), castSelf: PyType.selfAsPyType)
    result._attributes["__subclasscheck__"] = PyType.wrapMethod(context, name: "__subclasscheck__", doc: nil, func: PyType.isSubclass(of:), castSelf: PyType.selfAsPyType)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyType.getAttribute(name:), castSelf: PyType.selfAsPyType)
    result._attributes["__setattr__"] = PyType.wrapMethod(context, name: "__setattr__", doc: nil, func: PyType.setAttribute(name:value:), castSelf: PyType.selfAsPyType)
    result._attributes["__delattr__"] = PyType.wrapMethod(context, name: "__delattr__", doc: nil, func: PyType.delAttribute(name:), castSelf: PyType.selfAsPyType)
    result._attributes["__dir__"] = PyType.wrapMethod(context, name: "__dir__", doc: nil, func: PyType.dir, castSelf: PyType.selfAsPyType)
    return result
  }

  // MARK: - Bool

  internal static func bool(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "bool", doc: PyBool.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyBool.getClass, castSelf: PyType.selfAsPyBool)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyBool.repr, castSelf: PyType.selfAsPyBool)
    result._attributes["__str__"] = PyType.wrapMethod(context, name: "__str__", doc: nil, func: PyBool.str, castSelf: PyType.selfAsPyBool)
    result._attributes["__and__"] = PyType.wrapMethod(context, name: "__and__", doc: nil, func: PyBool.and(_:), castSelf: PyType.selfAsPyBool)
    result._attributes["__rand__"] = PyType.wrapMethod(context, name: "__rand__", doc: nil, func: PyBool.rand(_:), castSelf: PyType.selfAsPyBool)
    result._attributes["__or__"] = PyType.wrapMethod(context, name: "__or__", doc: nil, func: PyBool.or(_:), castSelf: PyType.selfAsPyBool)
    result._attributes["__ror__"] = PyType.wrapMethod(context, name: "__ror__", doc: nil, func: PyBool.ror(_:), castSelf: PyType.selfAsPyBool)
    result._attributes["__xor__"] = PyType.wrapMethod(context, name: "__xor__", doc: nil, func: PyBool.xor(_:), castSelf: PyType.selfAsPyBool)
    result._attributes["__rxor__"] = PyType.wrapMethod(context, name: "__rxor__", doc: nil, func: PyBool.rxor(_:), castSelf: PyType.selfAsPyBool)
    return result
  }

  // MARK: - BuiltinFunction

  internal static func builtinFunction(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "builtinFunction", doc: nil, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyBuiltinFunction.getClass, castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__name__"] = PyType.createProperty(context, name: "__name__", doc: nil, get: PyBuiltinFunction.getName, castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__qualname__"] = PyType.createProperty(context, name: "__qualname__", doc: nil, get: PyBuiltinFunction.getQualname, castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__text_signature__"] = PyType.createProperty(context, name: "__text_signature__", doc: nil, get: PyBuiltinFunction.getTextSignature, castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__module__"] = PyType.createProperty(context, name: "__module__", doc: nil, get: PyBuiltinFunction.getModule, castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__self__"] = PyType.createProperty(context, name: "__self__", doc: nil, get: PyBuiltinFunction.getSelf, castSelf: PyType.selfAsPyBuiltinFunction)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyBuiltinFunction.isEqual(_:), castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyBuiltinFunction.isNotEqual(_:), castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyBuiltinFunction.isLess(_:), castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyBuiltinFunction.isLessEqual(_:), castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyBuiltinFunction.isGreater(_:), castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyBuiltinFunction.isGreaterEqual(_:), castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyBuiltinFunction.hash, castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyBuiltinFunction.repr, castSelf: PyType.selfAsPyBuiltinFunction)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyBuiltinFunction.getAttribute(name:), castSelf: PyType.selfAsPyBuiltinFunction)
    return result
  }

  // MARK: - Code

  internal static func code(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "code", doc: PyCode.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyCode.getClass, castSelf: PyType.selfAsPyCode)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyCode.isEqual(_:), castSelf: PyType.selfAsPyCode)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyCode.isLess(_:), castSelf: PyType.selfAsPyCode)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyCode.isLessEqual(_:), castSelf: PyType.selfAsPyCode)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyCode.isGreater(_:), castSelf: PyType.selfAsPyCode)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyCode.isGreaterEqual(_:), castSelf: PyType.selfAsPyCode)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyCode.hash, castSelf: PyType.selfAsPyCode)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyCode.repr, castSelf: PyType.selfAsPyCode)
    return result
  }

  // MARK: - Complex

  internal static func complex(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "complex", doc: PyComplex.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyComplex.getClass, castSelf: PyType.selfAsPyComplex)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyComplex.isEqual(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyComplex.isNotEqual(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyComplex.isLess(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyComplex.isLessEqual(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyComplex.isGreater(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyComplex.isGreaterEqual(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyComplex.hash, castSelf: PyType.selfAsPyComplex)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyComplex.repr, castSelf: PyType.selfAsPyComplex)
    result._attributes["__str__"] = PyType.wrapMethod(context, name: "__str__", doc: nil, func: PyComplex.str, castSelf: PyType.selfAsPyComplex)
    result._attributes["__bool__"] = PyType.wrapMethod(context, name: "__bool__", doc: nil, func: PyComplex.asBool, castSelf: PyType.selfAsPyComplex)
    result._attributes["__int__"] = PyType.wrapMethod(context, name: "__int__", doc: nil, func: PyComplex.asInt, castSelf: PyType.selfAsPyComplex)
    result._attributes["__float__"] = PyType.wrapMethod(context, name: "__float__", doc: nil, func: PyComplex.asFloat, castSelf: PyType.selfAsPyComplex)
    result._attributes["real"] = PyType.wrapMethod(context, name: "real", doc: nil, func: PyComplex.asReal, castSelf: PyType.selfAsPyComplex)
    result._attributes["imag"] = PyType.wrapMethod(context, name: "imag", doc: nil, func: PyComplex.asImag, castSelf: PyType.selfAsPyComplex)
    result._attributes["conjugate"] = PyType.wrapMethod(context, name: "conjugate", doc: nil, func: PyComplex.conjugate, castSelf: PyType.selfAsPyComplex)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyComplex.getAttribute(name:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__pos__"] = PyType.wrapMethod(context, name: "__pos__", doc: nil, func: PyComplex.positive, castSelf: PyType.selfAsPyComplex)
    result._attributes["__neg__"] = PyType.wrapMethod(context, name: "__neg__", doc: nil, func: PyComplex.negative, castSelf: PyType.selfAsPyComplex)
    result._attributes["__abs__"] = PyType.wrapMethod(context, name: "__abs__", doc: nil, func: PyComplex.abs, castSelf: PyType.selfAsPyComplex)
    result._attributes["__add__"] = PyType.wrapMethod(context, name: "__add__", doc: nil, func: PyComplex.add(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__radd__"] = PyType.wrapMethod(context, name: "__radd__", doc: nil, func: PyComplex.radd(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__sub__"] = PyType.wrapMethod(context, name: "__sub__", doc: nil, func: PyComplex.sub(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__rsub__"] = PyType.wrapMethod(context, name: "__rsub__", doc: nil, func: PyComplex.rsub(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__mul__"] = PyType.wrapMethod(context, name: "__mul__", doc: nil, func: PyComplex.mul(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__rmul__"] = PyType.wrapMethod(context, name: "__rmul__", doc: nil, func: PyComplex.rmul(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__pow__"] = PyType.wrapMethod(context, name: "__pow__", doc: nil, func: PyComplex.pow(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__rpow__"] = PyType.wrapMethod(context, name: "__rpow__", doc: nil, func: PyComplex.rpow(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__truediv__"] = PyType.wrapMethod(context, name: "__truediv__", doc: nil, func: PyComplex.trueDiv(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__rtruediv__"] = PyType.wrapMethod(context, name: "__rtruediv__", doc: nil, func: PyComplex.rtrueDiv(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__floordiv__"] = PyType.wrapMethod(context, name: "__floordiv__", doc: nil, func: PyComplex.floorDiv(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__rfloordiv__"] = PyType.wrapMethod(context, name: "__rfloordiv__", doc: nil, func: PyComplex.rfloorDiv(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__mod__"] = PyType.wrapMethod(context, name: "__mod__", doc: nil, func: PyComplex.mod(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__rmod__"] = PyType.wrapMethod(context, name: "__rmod__", doc: nil, func: PyComplex.rmod(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__divmod__"] = PyType.wrapMethod(context, name: "__divmod__", doc: nil, func: PyComplex.divMod(_:), castSelf: PyType.selfAsPyComplex)
    result._attributes["__rdivmod__"] = PyType.wrapMethod(context, name: "__rdivmod__", doc: nil, func: PyComplex.rdivMod(_:), castSelf: PyType.selfAsPyComplex)
    return result
  }

  // MARK: - Ellipsis

  internal static func ellipsis(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ellipsis", doc: nil, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyEllipsis.getClass, castSelf: PyType.selfAsPyEllipsis)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyEllipsis.repr, castSelf: PyType.selfAsPyEllipsis)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyEllipsis.getAttribute(name:), castSelf: PyType.selfAsPyEllipsis)
    return result
  }

  // MARK: - Float

  internal static func float(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "float", doc: PyFloat.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyFloat.getClass, castSelf: PyType.selfAsPyFloat)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyFloat.isEqual(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyFloat.isNotEqual(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyFloat.isLess(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyFloat.isLessEqual(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyFloat.isGreater(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyFloat.isGreaterEqual(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyFloat.hash, castSelf: PyType.selfAsPyFloat)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyFloat.repr, castSelf: PyType.selfAsPyFloat)
    result._attributes["__str__"] = PyType.wrapMethod(context, name: "__str__", doc: nil, func: PyFloat.str, castSelf: PyType.selfAsPyFloat)
    result._attributes["__bool__"] = PyType.wrapMethod(context, name: "__bool__", doc: nil, func: PyFloat.asBool, castSelf: PyType.selfAsPyFloat)
    result._attributes["__int__"] = PyType.wrapMethod(context, name: "__int__", doc: nil, func: PyFloat.asInt, castSelf: PyType.selfAsPyFloat)
    result._attributes["__float__"] = PyType.wrapMethod(context, name: "__float__", doc: nil, func: PyFloat.asFloat, castSelf: PyType.selfAsPyFloat)
    result._attributes["real"] = PyType.wrapMethod(context, name: "real", doc: nil, func: PyFloat.asReal, castSelf: PyType.selfAsPyFloat)
    result._attributes["imag"] = PyType.wrapMethod(context, name: "imag", doc: nil, func: PyFloat.asImag, castSelf: PyType.selfAsPyFloat)
    result._attributes["conjugate"] = PyType.wrapMethod(context, name: "conjugate", doc: nil, func: PyFloat.conjugate, castSelf: PyType.selfAsPyFloat)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyFloat.getAttribute(name:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__pos__"] = PyType.wrapMethod(context, name: "__pos__", doc: nil, func: PyFloat.positive, castSelf: PyType.selfAsPyFloat)
    result._attributes["__neg__"] = PyType.wrapMethod(context, name: "__neg__", doc: nil, func: PyFloat.negative, castSelf: PyType.selfAsPyFloat)
    result._attributes["__abs__"] = PyType.wrapMethod(context, name: "__abs__", doc: nil, func: PyFloat.abs, castSelf: PyType.selfAsPyFloat)
    result._attributes["__add__"] = PyType.wrapMethod(context, name: "__add__", doc: nil, func: PyFloat.add(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__radd__"] = PyType.wrapMethod(context, name: "__radd__", doc: nil, func: PyFloat.radd(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__sub__"] = PyType.wrapMethod(context, name: "__sub__", doc: nil, func: PyFloat.sub(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__rsub__"] = PyType.wrapMethod(context, name: "__rsub__", doc: nil, func: PyFloat.rsub(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__mul__"] = PyType.wrapMethod(context, name: "__mul__", doc: nil, func: PyFloat.mul(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__rmul__"] = PyType.wrapMethod(context, name: "__rmul__", doc: nil, func: PyFloat.rmul(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__pow__"] = PyType.wrapMethod(context, name: "__pow__", doc: nil, func: PyFloat.pow(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__rpow__"] = PyType.wrapMethod(context, name: "__rpow__", doc: nil, func: PyFloat.rpow(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__truediv__"] = PyType.wrapMethod(context, name: "__truediv__", doc: nil, func: PyFloat.trueDiv(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__rtruediv__"] = PyType.wrapMethod(context, name: "__rtruediv__", doc: nil, func: PyFloat.rtrueDiv(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__floordiv__"] = PyType.wrapMethod(context, name: "__floordiv__", doc: nil, func: PyFloat.floorDiv(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__rfloordiv__"] = PyType.wrapMethod(context, name: "__rfloordiv__", doc: nil, func: PyFloat.rfloorDiv(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__mod__"] = PyType.wrapMethod(context, name: "__mod__", doc: nil, func: PyFloat.mod(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__rmod__"] = PyType.wrapMethod(context, name: "__rmod__", doc: nil, func: PyFloat.rmod(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__divmod__"] = PyType.wrapMethod(context, name: "__divmod__", doc: nil, func: PyFloat.divMod(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__rdivmod__"] = PyType.wrapMethod(context, name: "__rdivmod__", doc: nil, func: PyFloat.rdivMod(_:), castSelf: PyType.selfAsPyFloat)
    result._attributes["__round__"] = PyType.wrapMethod(context, name: "__round__", doc: nil, func: PyFloat.round(nDigits:), castSelf: PyType.selfAsPyFloat)
    return result
  }

  // MARK: - Function

  internal static func function(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "function", doc: PyFunction.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyFunction.getClass, castSelf: PyType.selfAsPyFunction)
    result._attributes["__name__"] = PyType.createProperty(context, name: "__name__", doc: nil, get: PyFunction.getName, set: PyFunction.setName, castSelf: PyType.selfAsPyFunction)
    result._attributes["__qualname__"] = PyType.createProperty(context, name: "__qualname__", doc: nil, get: PyFunction.getQualname, set: PyFunction.setQualname, castSelf: PyType.selfAsPyFunction)
    result._attributes["__code__"] = PyType.createProperty(context, name: "__code__", doc: nil, get: PyFunction.getCode, castSelf: PyType.selfAsPyFunction)
    result._attributes["__doc__"] = PyType.createProperty(context, name: "__doc__", doc: nil, get: PyFunction.getDoc, castSelf: PyType.selfAsPyFunction)
    result._attributes["__module__"] = PyType.createProperty(context, name: "__module__", doc: nil, get: PyFunction.getModule, castSelf: PyType.selfAsPyFunction)
    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyFunction.dict, castSelf: PyType.selfAsPyFunction)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyFunction.repr, castSelf: PyType.selfAsPyFunction)
    result._attributes["__get__"] = PyType.wrapMethod(context, name: "__get__", doc: nil, func: PyFunction.get(object:), castSelf: PyType.selfAsPyFunction)
    return result
  }

  // MARK: - Int

  internal static func int(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "int", doc: PyInt.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyInt.getClass, castSelf: PyType.selfAsPyInt)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyInt.isEqual(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyInt.isNotEqual(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyInt.isLess(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyInt.isLessEqual(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyInt.isGreater(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyInt.isGreaterEqual(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyInt.hash, castSelf: PyType.selfAsPyInt)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyInt.repr, castSelf: PyType.selfAsPyInt)
    result._attributes["__str__"] = PyType.wrapMethod(context, name: "__str__", doc: nil, func: PyInt.str, castSelf: PyType.selfAsPyInt)
    result._attributes["__bool__"] = PyType.wrapMethod(context, name: "__bool__", doc: nil, func: PyInt.asBool, castSelf: PyType.selfAsPyInt)
    result._attributes["__int__"] = PyType.wrapMethod(context, name: "__int__", doc: nil, func: PyInt.asInt, castSelf: PyType.selfAsPyInt)
    result._attributes["__float__"] = PyType.wrapMethod(context, name: "__float__", doc: nil, func: PyInt.asFloat, castSelf: PyType.selfAsPyInt)
    result._attributes["__index__"] = PyType.wrapMethod(context, name: "__index__", doc: nil, func: PyInt.asIndex, castSelf: PyType.selfAsPyInt)
    result._attributes["real"] = PyType.wrapMethod(context, name: "real", doc: nil, func: PyInt.asReal, castSelf: PyType.selfAsPyInt)
    result._attributes["imag"] = PyType.wrapMethod(context, name: "imag", doc: nil, func: PyInt.asImag, castSelf: PyType.selfAsPyInt)
    result._attributes["conjugate"] = PyType.wrapMethod(context, name: "conjugate", doc: nil, func: PyInt.conjugate, castSelf: PyType.selfAsPyInt)
    result._attributes["numerator"] = PyType.wrapMethod(context, name: "numerator", doc: nil, func: PyInt.numerator, castSelf: PyType.selfAsPyInt)
    result._attributes["denominator"] = PyType.wrapMethod(context, name: "denominator", doc: nil, func: PyInt.denominator, castSelf: PyType.selfAsPyInt)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyInt.getAttribute(name:), castSelf: PyType.selfAsPyInt)
    result._attributes["__pos__"] = PyType.wrapMethod(context, name: "__pos__", doc: nil, func: PyInt.positive, castSelf: PyType.selfAsPyInt)
    result._attributes["__neg__"] = PyType.wrapMethod(context, name: "__neg__", doc: nil, func: PyInt.negative, castSelf: PyType.selfAsPyInt)
    result._attributes["__abs__"] = PyType.wrapMethod(context, name: "__abs__", doc: nil, func: PyInt.abs, castSelf: PyType.selfAsPyInt)
    result._attributes["__add__"] = PyType.wrapMethod(context, name: "__add__", doc: nil, func: PyInt.add(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__radd__"] = PyType.wrapMethod(context, name: "__radd__", doc: nil, func: PyInt.radd(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__sub__"] = PyType.wrapMethod(context, name: "__sub__", doc: nil, func: PyInt.sub(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rsub__"] = PyType.wrapMethod(context, name: "__rsub__", doc: nil, func: PyInt.rsub(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__mul__"] = PyType.wrapMethod(context, name: "__mul__", doc: nil, func: PyInt.mul(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rmul__"] = PyType.wrapMethod(context, name: "__rmul__", doc: nil, func: PyInt.rmul(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__pow__"] = PyType.wrapMethod(context, name: "__pow__", doc: nil, func: PyInt.pow(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rpow__"] = PyType.wrapMethod(context, name: "__rpow__", doc: nil, func: PyInt.rpow(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__truediv__"] = PyType.wrapMethod(context, name: "__truediv__", doc: nil, func: PyInt.trueDiv(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rtruediv__"] = PyType.wrapMethod(context, name: "__rtruediv__", doc: nil, func: PyInt.rtrueDiv(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__floordiv__"] = PyType.wrapMethod(context, name: "__floordiv__", doc: nil, func: PyInt.floorDiv(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rfloordiv__"] = PyType.wrapMethod(context, name: "__rfloordiv__", doc: nil, func: PyInt.rfloorDiv(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__mod__"] = PyType.wrapMethod(context, name: "__mod__", doc: nil, func: PyInt.mod(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rmod__"] = PyType.wrapMethod(context, name: "__rmod__", doc: nil, func: PyInt.rmod(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__divmod__"] = PyType.wrapMethod(context, name: "__divmod__", doc: nil, func: PyInt.divMod(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rdivmod__"] = PyType.wrapMethod(context, name: "__rdivmod__", doc: nil, func: PyInt.rdivMod(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__lshift__"] = PyType.wrapMethod(context, name: "__lshift__", doc: nil, func: PyInt.lShift(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rlshift__"] = PyType.wrapMethod(context, name: "__rlshift__", doc: nil, func: PyInt.rlShift(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rshift__"] = PyType.wrapMethod(context, name: "__rshift__", doc: nil, func: PyInt.rShift(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rrshift__"] = PyType.wrapMethod(context, name: "__rrshift__", doc: nil, func: PyInt.rrShift(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__and__"] = PyType.wrapMethod(context, name: "__and__", doc: nil, func: PyInt.and(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rand__"] = PyType.wrapMethod(context, name: "__rand__", doc: nil, func: PyInt.rand(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__or__"] = PyType.wrapMethod(context, name: "__or__", doc: nil, func: PyInt.or(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__ror__"] = PyType.wrapMethod(context, name: "__ror__", doc: nil, func: PyInt.ror(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__xor__"] = PyType.wrapMethod(context, name: "__xor__", doc: nil, func: PyInt.xor(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__rxor__"] = PyType.wrapMethod(context, name: "__rxor__", doc: nil, func: PyInt.rxor(_:), castSelf: PyType.selfAsPyInt)
    result._attributes["__invert__"] = PyType.wrapMethod(context, name: "__invert__", doc: nil, func: PyInt.invert, castSelf: PyType.selfAsPyInt)
    result._attributes["__round__"] = PyType.wrapMethod(context, name: "__round__", doc: nil, func: PyInt.round(nDigits:), castSelf: PyType.selfAsPyInt)
    return result
  }

  // MARK: - List

  internal static func list(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "list", doc: PyList.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyList.getClass, castSelf: PyType.selfAsPyList)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyList.isEqual(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyList.isNotEqual(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyList.isLess(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyList.isLessEqual(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyList.isGreater(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyList.isGreaterEqual(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyList.repr, castSelf: PyType.selfAsPyList)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyList.getAttribute(name:), castSelf: PyType.selfAsPyList)
    result._attributes["__len__"] = PyType.wrapMethod(context, name: "__len__", doc: nil, func: PyList.getLength, castSelf: PyType.selfAsPyList)
    result._attributes["__contains__"] = PyType.wrapMethod(context, name: "__contains__", doc: nil, func: PyList.contains(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__getitem__"] = PyType.wrapMethod(context, name: "__getitem__", doc: nil, func: PyList.getItem(at:), castSelf: PyType.selfAsPyList)
    result._attributes["count"] = PyType.wrapMethod(context, name: "count", doc: nil, func: PyList.count(_:), castSelf: PyType.selfAsPyList)
    result._attributes["index"] = PyType.wrapMethod(context, name: "index", doc: nil, func: PyList.getIndex(of:), castSelf: PyType.selfAsPyList)
    result._attributes["append"] = PyType.wrapMethod(context, name: "append", doc: nil, func: PyList.append(_:), castSelf: PyType.selfAsPyList)
    result._attributes["extend"] = PyType.wrapMethod(context, name: "extend", doc: nil, func: PyList.extend(_:), castSelf: PyType.selfAsPyList)
    result._attributes["clear"] = PyType.wrapMethod(context, name: "clear", doc: nil, func: PyList.clear, castSelf: PyType.selfAsPyList)
    result._attributes["copy"] = PyType.wrapMethod(context, name: "copy", doc: nil, func: PyList.copy, castSelf: PyType.selfAsPyList)
    result._attributes["__add__"] = PyType.wrapMethod(context, name: "__add__", doc: nil, func: PyList.add(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__iadd__"] = PyType.wrapMethod(context, name: "__iadd__", doc: nil, func: PyList.addInPlace(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__mul__"] = PyType.wrapMethod(context, name: "__mul__", doc: nil, func: PyList.mul(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__rmul__"] = PyType.wrapMethod(context, name: "__rmul__", doc: nil, func: PyList.rmul(_:), castSelf: PyType.selfAsPyList)
    result._attributes["__imul__"] = PyType.wrapMethod(context, name: "__imul__", doc: nil, func: PyList.mulInPlace(_:), castSelf: PyType.selfAsPyList)
    return result
  }

  // MARK: - Method

  internal static func method(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "method", doc: PyMethod.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyMethod.getClass, castSelf: PyType.selfAsPyMethod)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyMethod.isEqual(_:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyMethod.isNotEqual(_:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyMethod.isLess(_:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyMethod.isLessEqual(_:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyMethod.isGreater(_:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyMethod.isGreaterEqual(_:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyMethod.repr, castSelf: PyType.selfAsPyMethod)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyMethod.hash, castSelf: PyType.selfAsPyMethod)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyMethod.getAttribute(name:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__setattr__"] = PyType.wrapMethod(context, name: "__setattr__", doc: nil, func: PyMethod.setAttribute(name:value:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__delattr__"] = PyType.wrapMethod(context, name: "__delattr__", doc: nil, func: PyMethod.delAttribute(name:), castSelf: PyType.selfAsPyMethod)
    result._attributes["__func__"] = PyType.wrapMethod(context, name: "__func__", doc: nil, func: PyMethod.getFunc, castSelf: PyType.selfAsPyMethod)
    result._attributes["__self__"] = PyType.wrapMethod(context, name: "__self__", doc: nil, func: PyMethod.getSelf, castSelf: PyType.selfAsPyMethod)
    result._attributes["__get__"] = PyType.wrapMethod(context, name: "__get__", doc: nil, func: PyMethod.get(object:), castSelf: PyType.selfAsPyMethod)
    return result
  }

  // MARK: - Module

  internal static func module(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "module", doc: PyModule.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyModule.dict, castSelf: PyType.selfAsPyModule)
    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyModule.getClass, castSelf: PyType.selfAsPyModule)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyModule.repr, castSelf: PyType.selfAsPyModule)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyModule.getAttribute(name:), castSelf: PyType.selfAsPyModule)
    result._attributes["__setattr__"] = PyType.wrapMethod(context, name: "__setattr__", doc: nil, func: PyModule.setAttribute(name:value:), castSelf: PyType.selfAsPyModule)
    result._attributes["__delattr__"] = PyType.wrapMethod(context, name: "__delattr__", doc: nil, func: PyModule.delAttribute(name:), castSelf: PyType.selfAsPyModule)
    result._attributes["__dir__"] = PyType.wrapMethod(context, name: "__dir__", doc: nil, func: PyModule.dir, castSelf: PyType.selfAsPyModule)
    return result
  }

  // MARK: - Namespace

  internal static func simpleNamespace(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "types.SimpleNamespace", doc: PyNamespace.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyNamespace.dict, castSelf: PyType.selfAsPyNamespace)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyNamespace.isEqual(_:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyNamespace.isNotEqual(_:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyNamespace.isLess(_:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyNamespace.isLessEqual(_:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyNamespace.isGreater(_:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyNamespace.isGreaterEqual(_:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyNamespace.repr, castSelf: PyType.selfAsPyNamespace)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyNamespace.getAttribute(name:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__setattr__"] = PyType.wrapMethod(context, name: "__setattr__", doc: nil, func: PyNamespace.setAttribute(name:value:), castSelf: PyType.selfAsPyNamespace)
    result._attributes["__delattr__"] = PyType.wrapMethod(context, name: "__delattr__", doc: nil, func: PyNamespace.delAttribute(name:), castSelf: PyType.selfAsPyNamespace)
    return result
  }

  // MARK: - None

  internal static func none(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NoneType", doc: nil, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyNone.getClass, castSelf: PyType.selfAsPyNone)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyNone.repr, castSelf: PyType.selfAsPyNone)
    result._attributes["__bool__"] = PyType.wrapMethod(context, name: "__bool__", doc: nil, func: PyNone.asBool, castSelf: PyType.selfAsPyNone)
    return result
  }

  // MARK: - NotImplemented

  internal static func notImplemented(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedType", doc: nil, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyNotImplemented.getClass, castSelf: PyType.selfAsPyNotImplemented)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyNotImplemented.repr, castSelf: PyType.selfAsPyNotImplemented)
    return result
  }

  // MARK: - Property

  internal static func property(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "property", doc: PyProperty.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyProperty.getClass, castSelf: PyType.selfAsPyProperty)
    result._attributes["fget"] = PyType.createProperty(context, name: "fget", doc: nil, get: PyProperty.getFGet, castSelf: PyType.selfAsPyProperty)
    result._attributes["fset"] = PyType.createProperty(context, name: "fset", doc: nil, get: PyProperty.getFSet, castSelf: PyType.selfAsPyProperty)
    result._attributes["fdel"] = PyType.createProperty(context, name: "fdel", doc: nil, get: PyProperty.getFDel, castSelf: PyType.selfAsPyProperty)


    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyProperty.getAttribute(name:), castSelf: PyType.selfAsPyProperty)
    result._attributes["__get__"] = PyType.wrapMethod(context, name: "__get__", doc: nil, func: PyProperty.get(object:), castSelf: PyType.selfAsPyProperty)
    result._attributes["__set__"] = PyType.wrapMethod(context, name: "__set__", doc: nil, func: PyProperty.set(object:value:), castSelf: PyType.selfAsPyProperty)
    result._attributes["__delete__"] = PyType.wrapMethod(context, name: "__delete__", doc: nil, func: PyProperty.del(object:), castSelf: PyType.selfAsPyProperty)
    return result
  }

  // MARK: - Range

  internal static func range(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "range", doc: PyRange.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyRange.getClass, castSelf: PyType.selfAsPyRange)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyRange.isEqual(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyRange.isNotEqual(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyRange.isLess(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyRange.isLessEqual(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyRange.isGreater(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyRange.isGreaterEqual(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyRange.hash, castSelf: PyType.selfAsPyRange)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyRange.repr, castSelf: PyType.selfAsPyRange)
    result._attributes["__bool__"] = PyType.wrapMethod(context, name: "__bool__", doc: nil, func: PyRange.asBool, castSelf: PyType.selfAsPyRange)
    result._attributes["__len__"] = PyType.wrapMethod(context, name: "__len__", doc: nil, func: PyRange.getLength, castSelf: PyType.selfAsPyRange)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyRange.getAttribute(name:), castSelf: PyType.selfAsPyRange)
    result._attributes["__contains__"] = PyType.wrapMethod(context, name: "__contains__", doc: nil, func: PyRange.contains(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["__getitem__"] = PyType.wrapMethod(context, name: "__getitem__", doc: nil, func: PyRange.getItem(at:), castSelf: PyType.selfAsPyRange)
    result._attributes["count"] = PyType.wrapMethod(context, name: "count", doc: nil, func: PyRange.count(_:), castSelf: PyType.selfAsPyRange)
    result._attributes["index"] = PyType.wrapMethod(context, name: "index", doc: nil, func: PyRange.getIndex(of:), castSelf: PyType.selfAsPyRange)
    return result
  }

  // MARK: - Slice

  internal static func slice(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "slice", doc: PySlice.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PySlice.getClass, castSelf: PyType.selfAsPySlice)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PySlice.isEqual(_:), castSelf: PyType.selfAsPySlice)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PySlice.isNotEqual(_:), castSelf: PyType.selfAsPySlice)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PySlice.isLess(_:), castSelf: PyType.selfAsPySlice)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PySlice.isLessEqual(_:), castSelf: PyType.selfAsPySlice)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PySlice.isGreater(_:), castSelf: PyType.selfAsPySlice)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PySlice.isGreaterEqual(_:), castSelf: PyType.selfAsPySlice)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PySlice.repr, castSelf: PyType.selfAsPySlice)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PySlice.getAttribute(name:), castSelf: PyType.selfAsPySlice)
    return result
  }

  // MARK: - Tuple

  internal static func tuple(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "tuple", doc: PyTuple.doc, type: type, base: base)

    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyTuple.getClass, castSelf: PyType.selfAsPyTuple)


    result._attributes["__eq__"] = PyType.wrapMethod(context, name: "__eq__", doc: nil, func: PyTuple.isEqual(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__ne__"] = PyType.wrapMethod(context, name: "__ne__", doc: nil, func: PyTuple.isNotEqual(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__lt__"] = PyType.wrapMethod(context, name: "__lt__", doc: nil, func: PyTuple.isLess(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__le__"] = PyType.wrapMethod(context, name: "__le__", doc: nil, func: PyTuple.isLessEqual(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__gt__"] = PyType.wrapMethod(context, name: "__gt__", doc: nil, func: PyTuple.isGreater(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__ge__"] = PyType.wrapMethod(context, name: "__ge__", doc: nil, func: PyTuple.isGreaterEqual(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__hash__"] = PyType.wrapMethod(context, name: "__hash__", doc: nil, func: PyTuple.hash, castSelf: PyType.selfAsPyTuple)
    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyTuple.repr, castSelf: PyType.selfAsPyTuple)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyTuple.getAttribute(name:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__len__"] = PyType.wrapMethod(context, name: "__len__", doc: nil, func: PyTuple.getLength, castSelf: PyType.selfAsPyTuple)
    result._attributes["__contains__"] = PyType.wrapMethod(context, name: "__contains__", doc: nil, func: PyTuple.contains(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__getitem__"] = PyType.wrapMethod(context, name: "__getitem__", doc: nil, func: PyTuple.getItem(at:), castSelf: PyType.selfAsPyTuple)
    result._attributes["count"] = PyType.wrapMethod(context, name: "count", doc: nil, func: PyTuple.count(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["index"] = PyType.wrapMethod(context, name: "index", doc: nil, func: PyTuple.getIndex(of:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__add__"] = PyType.wrapMethod(context, name: "__add__", doc: nil, func: PyTuple.add(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__mul__"] = PyType.wrapMethod(context, name: "__mul__", doc: nil, func: PyTuple.mul(_:), castSelf: PyType.selfAsPyTuple)
    result._attributes["__rmul__"] = PyType.wrapMethod(context, name: "__rmul__", doc: nil, func: PyTuple.rmul(_:), castSelf: PyType.selfAsPyTuple)
    return result
  }

  // MARK: - BaseException

  internal static func baseException(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    #warning("Type PyBaseException should be marked final.")
    let result = PyType(context, name: "BaseException", doc: PyBaseException.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyBaseException.dict, castSelf: PyType.selfAsPyBaseException)
    result._attributes["__class__"] = PyType.createProperty(context, name: "__class__", doc: nil, get: PyBaseException.getClass, castSelf: PyType.selfAsPyBaseException)
    result._attributes["args"] = PyType.createProperty(context, name: "args", doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: PyType.selfAsPyBaseException)
    result._attributes["__traceback__"] = PyType.createProperty(context, name: "__traceback__", doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: PyType.selfAsPyBaseException)
    result._attributes["__cause__"] = PyType.createProperty(context, name: "__cause__", doc: nil, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: PyType.selfAsPyBaseException)
    result._attributes["__context__"] = PyType.createProperty(context, name: "__context__", doc: nil, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: PyType.selfAsPyBaseException)
    result._attributes["__suppress_context__"] = PyType.createProperty(context, name: "__suppress_context__", doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: PyType.selfAsPyBaseException)


    result._attributes["__repr__"] = PyType.wrapMethod(context, name: "__repr__", doc: nil, func: PyBaseException.repr, castSelf: PyType.selfAsPyBaseException)
    result._attributes["__str__"] = PyType.wrapMethod(context, name: "__str__", doc: nil, func: PyBaseException.str, castSelf: PyType.selfAsPyBaseException)
    result._attributes["__getattribute__"] = PyType.wrapMethod(context, name: "__getattribute__", doc: nil, func: PyBaseException.getAttribute(name:), castSelf: PyType.selfAsPyBaseException)
    result._attributes["__setattr__"] = PyType.wrapMethod(context, name: "__setattr__", doc: nil, func: PyBaseException.setAttribute(name:value:), castSelf: PyType.selfAsPyBaseException)
    result._attributes["__delattr__"] = PyType.wrapMethod(context, name: "__delattr__", doc: nil, func: PyBaseException.delAttribute(name:), castSelf: PyType.selfAsPyBaseException)
    return result
  }

  // MARK: - Exception

  internal static func exception(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    #warning("Type PyException should be marked final.")
    let result = PyType(context, name: "Exception", doc: PyException.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyException.dict, castSelf: PyType.selfAsPyException)


    return result
  }

  // MARK: - GeneratorExit

  internal static func generatorExit(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "GeneratorExit", doc: PyGeneratorExit.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyGeneratorExit.dict, castSelf: PyType.selfAsPyGeneratorExit)


    return result
  }

  // MARK: - KeyboardInterrupt

  internal static func keyboardInterrupt(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "KeyboardInterrupt", doc: PyKeyboardInterrupt.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyKeyboardInterrupt.dict, castSelf: PyType.selfAsPyKeyboardInterrupt)


    return result
  }
}

  // MARK: - BytesWarning

  internal static func bytesWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "BytesWarning", doc: PyBytesWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyBytesWarning.dict, castSelf: PyType.selfAsPyBytesWarning)


    return result
  }

  // MARK: - DeprecationWarning

  internal static func deprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "DeprecationWarning", doc: PyDeprecationWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyDeprecationWarning.dict, castSelf: PyType.selfAsPyDeprecationWarning)


    return result
  }

  // MARK: - FutureWarning

  internal static func futureWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "FutureWarning", doc: PyFutureWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyFutureWarning.dict, castSelf: PyType.selfAsPyFutureWarning)


    return result
  }

  // MARK: - ImportWarning

  internal static func importWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ImportWarning", doc: PyImportWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyImportWarning.dict, castSelf: PyType.selfAsPyImportWarning)


    return result
  }

  // MARK: - PendingDeprecationWarning

  internal static func pendingDeprecationWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "PendingDeprecationWarning", doc: PyPendingDeprecationWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyPendingDeprecationWarning.dict, castSelf: PyType.selfAsPyPendingDeprecationWarning)


    return result
  }

  // MARK: - ResourceWarning

  internal static func resourceWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ResourceWarning", doc: PyResourceWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyResourceWarning.dict, castSelf: PyType.selfAsPyResourceWarning)


    return result
  }

  // MARK: - RuntimeWarning

  internal static func runtimeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "RuntimeWarning", doc: PyRuntimeWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyRuntimeWarning.dict, castSelf: PyType.selfAsPyRuntimeWarning)


    return result
  }

  // MARK: - SyntaxWarning

  internal static func syntaxWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "SyntaxWarning", doc: PySyntaxWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PySyntaxWarning.dict, castSelf: PyType.selfAsPySyntaxWarning)


    return result
  }

  // MARK: - UnicodeWarning

  internal static func unicodeWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UnicodeWarning", doc: PyUnicodeWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyUnicodeWarning.dict, castSelf: PyType.selfAsPyUnicodeWarning)


    return result
  }

  // MARK: - UserWarning

  internal static func userWarning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "UserWarning", doc: PyUserWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyUserWarning.dict, castSelf: PyType.selfAsPyUserWarning)


    return result
  }

  // MARK: - Warning

  internal static func warning(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    #warning("Type PyWarning should be marked final.")
    let result = PyType(context, name: "Warning", doc: PyWarning.doc, type: type, base: base)

    result._attributes["__dict__"] = PyType.createProperty(context, name: "__dict__", doc: nil, get: PyWarning.dict, castSelf: PyType.selfAsPyWarning)


    return result
  }
}
