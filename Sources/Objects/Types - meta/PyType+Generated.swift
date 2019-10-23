// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable file_length




extension PyType {

  // MARK: - Object

  /// Create `object` type without assigning `type` property.
  internal static func objectWithoutType(_ context: PyContext) -> PyType {
    let result = PyType.initWithoutType(context, name: "object", doc: PyBaseObject.doc, base: nil)


    // result.__eq__ = PyBaseObject.isEqual(zelf: PyObject,                               other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PyBaseObject.isNotEqual(zelf: PyObject,                                  other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyBaseObject.isLess(zelf: PyObject,                              other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyBaseObject.isLessEqual(zelf: PyObject,                                   other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyBaseObject.isGreater(zelf: PyObject,                                 other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyBaseObject.isGreaterEqual(zelf: PyObject,                                      other: PyObject) -> PyResultOrNot<Bool>
    // result.__hash__ = PyBaseObject.hash(zelf: PyObject) -> PyResultOrNot<PyHash>
    // result.__repr__ = PyBaseObject.repr(zelf: PyObject) -> String
    // result.__str__ = PyBaseObject.str(zelf: PyObject) -> String
    // result.__format__ = PyBaseObject.format(zelf: PyObject, spec: PyObject) -> PyResult<String>
    // result.__class_ = PyBaseObject.getClass(zelf: PyObject) -> PyType
    // result.__dir__ = PyBaseObject.dir(zelf: PyObject) -> [String:PyObject]
    // result.__getattribute__ = PyBaseObject.getAttribute(zelf: PyObject,                                    name: PyObject) -> PyResult<PyObject>
    // result.__setattr__ = PyBaseObject.setAttribute(zelf: PyObject,                                    name: PyObject,                                    value: PyObject) -> PyResult<()>
    // result.__delattr__ = PyBaseObject.delAttribute(zelf: PyObject,                                    name: PyObject) -> PyResult<()>
    // result.__subclasshook__ = PyBaseObject.subclasshook(zelf: PyObject) -> PyResultOrNot<PyObject>
    // result.__init_subclass__ = PyBaseObject.initSubclass(zelf: PyObject) -> PyResultOrNot<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  // MARK: - Type type

  /// Create `type` type without assigning `type` property.
  internal static func typeWithoutType(_ context: PyContext, base: PyType) -> PyType {
    let result = PyType.initWithoutType(context, name: "type", doc: PyType.doc, base: base)

    // result.__name__ = PyType.getName(), setter: PyType.setName -> String
    // result.__qualname__ = PyType.getQualname(), setter: PyType.setQualname -> String
    // result.__module__ = PyType.getModule(), setter: PyType.setModule -> String
    // result.__bases__ = PyType.getBases(), setter: PyType.setBases -> [PyType]
    // result.__dict__ = PyType.dict() -> Attributes

    // result.__repr__ = PyType.repr() -> String
    // result.__subclasses__ = PyType.subclasses() -> [PyType]
    // result.__instancecheck__ = PyType.isInstance(of type: PyObject) -> PyResult<Bool>
    // result.__subclasscheck__ = PyType.isSubclass(of type: PyObject) -> PyResult<Bool>
    // result.__getattribute__ = PyType.getAttribute(name: PyObject) -> PyResult<PyObject>
    // result.__setattr__ = PyType.setAttribute(name: PyObject, value: PyObject) -> PyResult<()>
    // result.__delattr__ = PyType.delAttribute(name: PyObject) -> PyResult<()>
    // result.__dir__ = PyType.dir() -> [String: PyObject]
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  // MARK: - Ordinary types

  internal static func bool(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "bool", doc: PyBool.doc, type: type, base: base)


    // result.__repr__ = PyBool.repr() -> String
    // result.__str__ = PyBool.str() -> String
    // result.__and__ = PyBool.and(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rand__ = PyBool.rand(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__or__ = PyBool.or(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__ror__ = PyBool.ror(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__xor__ = PyBool.xor(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rxor__ = PyBool.rxor(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func builtinFunction(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "builtinFunction", doc: nil, type: type, base: base)


    // result.__repr__ = PyBuiltinFunctionOrMethod.repr() -> String
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func code(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "code", doc: PyCode.doc, type: type, base: base)


    // result.__eq__ = PyCode.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyCode.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyCode.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyCode.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyCode.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__hash__ = PyCode.hash() -> PyResultOrNot<PyHash>
    // result.__repr__ = PyCode.repr() -> String
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func complex(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "complex", doc: PyComplex.doc, type: type, base: base)


    // result.__eq__ = PyComplex.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PyComplex.isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyComplex.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyComplex.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyComplex.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyComplex.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__hash__ = PyComplex.hash() -> PyResultOrNot<PyHash>
    // result.__repr__ = PyComplex.repr() -> String
    // result.__str__ = PyComplex.str() -> String
    // result.__bool__ = PyComplex.asBool() -> PyResult<Bool>
    // result.__int__ = PyComplex.asInt() -> PyResult<PyInt>
    // result.__float__ = PyComplex.asFloat() -> PyResult<PyFloat>
    // result.real = PyComplex.asReal() -> PyObject
    // result.imag = PyComplex.asImag() -> PyObject
    // result.conjugate = PyComplex.conjugate() -> PyObject
    // result.__pos__ = PyComplex.positive() -> PyObject
    // result.__neg__ = PyComplex.negative() -> PyObject
    // result.__abs__ = PyComplex.abs() -> PyObject
    // result.__add__ = PyComplex.add(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__radd__ = PyComplex.radd(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__sub__ = PyComplex.sub(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rsub__ = PyComplex.rsub(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mul__ = PyComplex.mul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmul__ = PyComplex.rmul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__pow__ = PyComplex.pow(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rpow__ = PyComplex.rpow(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__truediv__ = PyComplex.trueDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rtruediv__ = PyComplex.rtrueDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__floordiv__ = PyComplex.floorDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rfloordiv__ = PyComplex.rfloorDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mod__ = PyComplex.mod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmod__ = PyComplex.rmod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__divmod__ = PyComplex.divMod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rdivmod__ = PyComplex.rdivMod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func ellipsis(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "ellipsis", doc: nil, type: type, base: base)


    // result.__repr__ = PyEllipsis.repr() -> String
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func float(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "float", doc: PyFloat.doc, type: type, base: base)


    // result.__eq__ = PyFloat.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PyFloat.isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyFloat.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyFloat.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyFloat.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyFloat.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__hash__ = PyFloat.hash() -> PyResultOrNot<PyHash>
    // result.__repr__ = PyFloat.repr() -> String
    // result.__str__ = PyFloat.str() -> String
    // result.__bool__ = PyFloat.asBool() -> PyResult<Bool>
    // result.__int__ = PyFloat.asInt() -> PyResult<PyInt>
    // result.__float__ = PyFloat.asFloat() -> PyResult<PyFloat>
    // result.real = PyFloat.asReal() -> PyObject
    // result.imag = PyFloat.asImag() -> PyObject
    // result.conjugate = PyFloat.conjugate() -> PyObject
    // result.__pos__ = PyFloat.positive() -> PyObject
    // result.__neg__ = PyFloat.negative() -> PyObject
    // result.__abs__ = PyFloat.abs() -> PyObject
    // result.__add__ = PyFloat.add(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__radd__ = PyFloat.radd(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__sub__ = PyFloat.sub(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rsub__ = PyFloat.rsub(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mul__ = PyFloat.mul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmul__ = PyFloat.rmul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__pow__ = PyFloat.pow(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rpow__ = PyFloat.rpow(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__truediv__ = PyFloat.trueDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rtruediv__ = PyFloat.rtrueDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__floordiv__ = PyFloat.floorDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rfloordiv__ = PyFloat.rfloorDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mod__ = PyFloat.mod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmod__ = PyFloat.rmod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__divmod__ = PyFloat.divMod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rdivmod__ = PyFloat.rdivMod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__round__ = PyFloat.round(nDigits: PyObject?) -> PyResultOrNot<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func function(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "function", doc: PyFunction.doc, type: type, base: base)


    // result.__repr__ = PyFunction.repr() -> String
    // result.__call__ = PyFunction.call() -> PyResult<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func int(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "int", doc: PyInt.doc, type: type, base: base)


    // result.__eq__ = PyInt.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PyInt.isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyInt.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyInt.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyInt.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyInt.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__hash__ = PyInt.hash() -> PyResultOrNot<PyHash>
    // result.__repr__ = PyInt.repr() -> String
    // result.__str__ = PyInt.str() -> String
    // result.__bool__ = PyInt.asBool() -> PyResult<Bool>
    // result.__int__ = PyInt.asInt() -> PyResult<PyInt>
    // result.__float__ = PyInt.asFloat() -> PyResult<PyFloat>
    // result.__index__ = PyInt.asIndex() -> BigInt
    // result.real = PyInt.asReal() -> PyObject
    // result.imag = PyInt.asImag() -> PyObject
    // result.conjugate = PyInt.conjugate() -> PyObject
    // result.numerator = PyInt.numerator() -> PyInt
    // result.denominator = PyInt.denominator() -> PyInt
    // result.__pos__ = PyInt.positive() -> PyObject
    // result.__neg__ = PyInt.negative() -> PyObject
    // result.__abs__ = PyInt.abs() -> PyObject
    // result.__add__ = PyInt.add(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__radd__ = PyInt.radd(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__sub__ = PyInt.sub(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rsub__ = PyInt.rsub(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mul__ = PyInt.mul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmul__ = PyInt.rmul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__pow__ = PyInt.pow(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rpow__ = PyInt.rpow(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__truediv__ = PyInt.trueDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rtruediv__ = PyInt.rtrueDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__floordiv__ = PyInt.floorDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rfloordiv__ = PyInt.rfloorDiv(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mod__ = PyInt.mod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmod__ = PyInt.rmod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__divmod__ = PyInt.divMod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rdivmod__ = PyInt.rdivMod(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__lshift__ = PyInt.lShift(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rlshift__ = PyInt.rlShift(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rshift__ = PyInt.rShift(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rrshift__ = PyInt.rrShift(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__and__ = PyInt.and(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rand__ = PyInt.rand(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__or__ = PyInt.or(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__ror__ = PyInt.ror(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__xor__ = PyInt.xor(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rxor__ = PyInt.rxor(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__invert__ = PyInt.invert() -> PyObject
    // result.__round__ = PyInt.round(nDigits: PyObject?) -> PyResultOrNot<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func list(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "list", doc: PyList.doc, type: type, base: base)


    // result.__eq__ = PyList.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PyList.isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyList.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyList.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyList.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyList.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__repr__ = PyList.repr() -> String
    // result.__len__ = PyList.getLength() -> BigInt
    // result.__contains__ = PyList.contains(_ element: PyObject) -> Bool
    // result.__getitem__ = PyList.getItem(at index: PyObject) -> PyResult<PyObject>
    // result.count = PyList.count(_ element: PyObject) -> PyResult<BigInt>
    // result.index = PyList.getIndex(of element: PyObject) -> PyResult<BigInt>
    // result.append = PyList.append(_ element: PyObject) -> Void
    // result.extend = PyList.extend(_ iterator: PyObject) -> Void
    // result.clear = PyList.clear() -> Void
    // result.copy = PyList.copy() -> PyList
    // result.__add__ = PyList.add(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__iadd__ = PyList.addInPlace(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mul__ = PyList.mul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmul__ = PyList.rmul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__imul__ = PyList.mulInPlace(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func method(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "method", doc: PyMethod.doc, type: type, base: base)


    // result.__repr__ = PyMethod.repr() -> String
    // result.__call__ = PyMethod.call() -> PyResult<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func module(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "module", doc: PyModule.doc, type: type, base: base)

    // result.__dict__ = PyModule.dict() -> Attributes

    // result.__repr__ = PyModule.repr() -> String
    // result.__getattribute__ = PyModule.getAttribute(name: String) -> PyResult<PyObject>
    // result.__setattr__ = PyModule.setAttribute(name: String, value: PyObject) -> Void
    // result.__delattr__ = PyModule.delAttribute(name: String) -> PyResult<PyObject>
    // result.__dir__ = PyModule.dir() -> [String]
    // result.__class__ = PyObject.getClass -> PyType

    return result
    #warning("Type PyModule should be marked final.")
  }

  internal static func NoneType(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NoneType", doc: nil, type: type, base: base)


    // result.__repr__ = PyNone.repr() -> String
    // result.__bool__ = PyNone.asBool() -> PyResult<Bool>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func NotImplementedType(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "NotImplementedType", doc: nil, type: type, base: base)


    // result.__repr__ = PyNotImplemented.repr() -> String
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func property(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "property", doc: PyProperty.doc, type: type, base: base)


    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func range(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "range", doc: PyRange.doc, type: type, base: base)


    // result.__eq__ = PyRange.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PyRange.isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyRange.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyRange.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyRange.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyRange.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__hash__ = PyRange.hash() -> PyResultOrNot<PyHash>
    // result.__repr__ = PyRange.repr() -> String
    // result.__bool__ = PyRange.asBool() -> PyResult<Bool>
    // result.__len__ = PyRange.getLength() -> BigInt
    // result.__contains__ = PyRange.contains(_ element: PyObject) -> Bool
    // result.__getitem__ = PyRange.getItem(at index: PyObject) -> PyResult<PyObject>
    // result.count = PyRange.count(_ element: PyObject) -> PyResult<BigInt>
    // result.index = PyRange.getIndex(of element: PyObject) -> PyResult<BigInt>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func slice(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "slice", doc: PySlice.doc, type: type, base: base)


    // result.__eq__ = PySlice.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PySlice.isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PySlice.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PySlice.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PySlice.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PySlice.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__repr__ = PySlice.repr() -> String
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }

  internal static func tuple(_ context: PyContext, type: PyType, base: PyType) -> PyType {
    let result = PyType(context, name: "tuple", doc: PyTuple.doc, type: type, base: base)


    // result.__eq__ = PyTuple.isEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ne__ = PyTuple.isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__lt__ = PyTuple.isLess(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__le__ = PyTuple.isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__gt__ = PyTuple.isGreater(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__ge__ = PyTuple.isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool>
    // result.__hash__ = PyTuple.hash() -> PyResultOrNot<PyHash>
    // result.__repr__ = PyTuple.repr() -> String
    // result.__len__ = PyTuple.getLength() -> BigInt
    // result.__contains__ = PyTuple.contains(_ element: PyObject) -> Bool
    // result.__getitem__ = PyTuple.getItem(at index: PyObject) -> PyResult<PyObject>
    // result.count = PyTuple.count(_ element: PyObject) -> PyResult<BigInt>
    // result.index = PyTuple.getIndex(of element: PyObject) -> PyResult<BigInt>
    // result.__add__ = PyTuple.add(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__mul__ = PyTuple.mul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__rmul__ = PyTuple.rmul(_ other: PyObject) -> PyResultOrNot<PyObject>
    // result.__class__ = PyObject.getClass -> PyType

    return result
  }
}
