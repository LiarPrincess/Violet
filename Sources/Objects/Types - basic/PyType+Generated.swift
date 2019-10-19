// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable file_length

extension PyType {

  internal static func object(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "object", type: type, base: base)

    // result.__doc__ = PyBaseObject.doc


    // result.__eq__ = PyBaseObject.isEqual(_ other: PyObject)
    // result.__lt__ = PyBaseObject.isLess(_ other: PyObject)
    // result.__le__ = PyBaseObject.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyBaseObject.isGreater(_ other: PyObject)
    // result.__ge__ = PyBaseObject.isGreaterEqual(_ other: PyObject)
    // result.__hash__ = PyBaseObject.hash()
    // result.__repr__ = PyBaseObject.repr()
    // result.__str__ = PyBaseObject.str()
    // result.__format__ = PyBaseObject.format(spec: PyObject)
    // result.__dir__ = PyBaseObject.dir()
    // result.__subclasshook__ = PyBaseObject.subclasshook()
    // result.__init_subclass__ = PyBaseObject.initSubclass()

    return result
  }

  internal static func bool(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "bool", type: type, base: base)

    // result.__doc__ = PyBool.doc


    // result.__repr__ = PyBool.repr()
    // result.__str__ = PyBool.str()
    // result.__and__ = PyBool.and(_ other: PyObject)
    // result.__rand__ = PyBool.rand(_ other: PyObject)
    // result.__or__ = PyBool.or(_ other: PyObject)
    // result.__ror__ = PyBool.ror(_ other: PyObject)
    // result.__xor__ = PyBool.xor(_ other: PyObject)
    // result.__rxor__ = PyBool.rxor(_ other: PyObject)

    return result
  }

  internal static func builtinFunction(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "builtinFunction", type: type, base: base)



    // result.__repr__ = PyBuiltinFunctionOrMethod.repr()

    return result
  }

  internal static func code(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "code", type: type, base: base)

    // result.__doc__ = PyCode.doc


    // result.__eq__ = PyCode.isEqual(_ other: PyObject)
    // result.__lt__ = PyCode.isLess(_ other: PyObject)
    // result.__le__ = PyCode.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyCode.isGreater(_ other: PyObject)
    // result.__ge__ = PyCode.isGreaterEqual(_ other: PyObject)
    // result.__hash__ = PyCode.hash()
    // result.__repr__ = PyCode.repr()

    return result
  }

  internal static func complex(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "complex", type: type, base: base)

    // result.__doc__ = PyComplex.doc


    // result.__eq__ = PyComplex.isEqual(_ other: PyObject)
    // result.__lt__ = PyComplex.isLess(_ other: PyObject)
    // result.__le__ = PyComplex.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyComplex.isGreater(_ other: PyObject)
    // result.__ge__ = PyComplex.isGreaterEqual(_ other: PyObject)
    // result.__hash__ = PyComplex.hash()
    // result.__repr__ = PyComplex.repr()
    // result.__str__ = PyComplex.str()
    // result.__bool__ = PyComplex.asBool()
    // result.__int__ = PyComplex.asInt()
    // result.__float__ = PyComplex.asFloat()
    // result.real = PyComplex.asReal()
    // result.imag = PyComplex.asImag()
    // result.conjugate = PyComplex.conjugate()
    // result.__pos__ = PyComplex.positive()
    // result.__neg__ = PyComplex.negative()
    // result.__abs__ = PyComplex.abs()
    // result.__add__ = PyComplex.add(_ other: PyObject)
    // result.__radd__ = PyComplex.radd(_ other: PyObject)
    // result.__sub__ = PyComplex.sub(_ other: PyObject)
    // result.__rsub__ = PyComplex.rsub(_ other: PyObject)
    // result.__mul__ = PyComplex.mul(_ other: PyObject)
    // result.__rmul__ = PyComplex.rmul(_ other: PyObject)
    // result.__pow__ = PyComplex.pow(_ other: PyObject)
    // result.__rpow__ = PyComplex.rpow(_ other: PyObject)
    // result.__truediv__ = PyComplex.trueDiv(_ other: PyObject)
    // result.__rtruediv__ = PyComplex.rtrueDiv(_ other: PyObject)
    // result.__floordiv__ = PyComplex.floorDiv(_ other: PyObject)
    // result.__rfloordiv__ = PyComplex.rfloorDiv(_ other: PyObject)
    // result.__mod__ = PyComplex.mod(_ other: PyObject)
    // result.__rmod__ = PyComplex.rmod(_ other: PyObject)
    // result.__divmod__ = PyComplex.divMod(_ other: PyObject)
    // result.__rdivmod__ = PyComplex.rdivMod(_ other: PyObject)

    return result
  }

  internal static func ellipsis(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "ellipsis", type: type, base: base)



    // result.__repr__ = PyEllipsis.repr()

    return result
  }

  internal static func enumerate(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "enumerate", type: type, base: base)

    // result.__doc__ = PyEnumerate.doc



    return result
  }

  internal static func float(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "float", type: type, base: base)

    // result.__doc__ = PyFloat.doc


    // result.__eq__ = PyFloat.isEqual(_ other: PyObject)
    // result.__lt__ = PyFloat.isLess(_ other: PyObject)
    // result.__le__ = PyFloat.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyFloat.isGreater(_ other: PyObject)
    // result.__ge__ = PyFloat.isGreaterEqual(_ other: PyObject)
    // result.__hash__ = PyFloat.hash()
    // result.__repr__ = PyFloat.repr()
    // result.__str__ = PyFloat.str()
    // result.__bool__ = PyFloat.asBool()
    // result.__int__ = PyFloat.asInt()
    // result.__float__ = PyFloat.asFloat()
    // result.real = PyFloat.asReal()
    // result.imag = PyFloat.asImag()
    // result.conjugate = PyFloat.conjugate()
    // result.__pos__ = PyFloat.positive()
    // result.__neg__ = PyFloat.negative()
    // result.__abs__ = PyFloat.abs()
    // result.__add__ = PyFloat.add(_ other: PyObject)
    // result.__radd__ = PyFloat.radd(_ other: PyObject)
    // result.__sub__ = PyFloat.sub(_ other: PyObject)
    // result.__rsub__ = PyFloat.rsub(_ other: PyObject)
    // result.__mul__ = PyFloat.mul(_ other: PyObject)
    // result.__rmul__ = PyFloat.rmul(_ other: PyObject)
    // result.__pow__ = PyFloat.pow(_ other: PyObject)
    // result.__rpow__ = PyFloat.rpow(_ other: PyObject)
    // result.__truediv__ = PyFloat.trueDiv(_ other: PyObject)
    // result.__rtruediv__ = PyFloat.rtrueDiv(_ other: PyObject)
    // result.__floordiv__ = PyFloat.floorDiv(_ other: PyObject)
    // result.__rfloordiv__ = PyFloat.rfloorDiv(_ other: PyObject)
    // result.__mod__ = PyFloat.mod(_ other: PyObject)
    // result.__rmod__ = PyFloat.rmod(_ other: PyObject)
    // result.__divmod__ = PyFloat.divMod(_ other: PyObject)
    // result.__rdivmod__ = PyFloat.rdivMod(_ other: PyObject)
    // result.__round__ = PyFloat.round(nDigits: PyObject?)

    return result
  }

  internal static func function(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "function", type: type, base: base)

    // result.__doc__ = PyFunction.doc


    // result.__repr__ = PyFunction.repr()
    // result.__call__ = PyFunction.call()

    return result
  }

  internal static func int(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "int", type: type, base: base)

    // result.__doc__ = PyInt.doc


    // result.__eq__ = PyInt.isEqual(_ other: PyObject)
    // result.__lt__ = PyInt.isLess(_ other: PyObject)
    // result.__le__ = PyInt.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyInt.isGreater(_ other: PyObject)
    // result.__ge__ = PyInt.isGreaterEqual(_ other: PyObject)
    // result.__hash__ = PyInt.hash()
    // result.__repr__ = PyInt.repr()
    // result.__str__ = PyInt.str()
    // result.__bool__ = PyInt.asBool()
    // result.__int__ = PyInt.asInt()
    // result.__float__ = PyInt.asFloat()
    // result.__index__ = PyInt.asIndex()
    // result.real = PyInt.asReal()
    // result.imag = PyInt.asImag()
    // result.conjugate = PyInt.conjugate()
    // result.numerator = PyInt.numerator()
    // result.denominator = PyInt.denominator()
    // result.__pos__ = PyInt.positive()
    // result.__neg__ = PyInt.negative()
    // result.__abs__ = PyInt.abs()
    // result.__add__ = PyInt.add(_ other: PyObject)
    // result.__radd__ = PyInt.radd(_ other: PyObject)
    // result.__sub__ = PyInt.sub(_ other: PyObject)
    // result.__rsub__ = PyInt.rsub(_ other: PyObject)
    // result.__mul__ = PyInt.mul(_ other: PyObject)
    // result.__rmul__ = PyInt.rmul(_ other: PyObject)
    // result.__pow__ = PyInt.pow(_ other: PyObject)
    // result.__rpow__ = PyInt.rpow(_ other: PyObject)
    // result.__truediv__ = PyInt.trueDiv(_ other: PyObject)
    // result.__rtruediv__ = PyInt.rtrueDiv(_ other: PyObject)
    // result.__floordiv__ = PyInt.floorDiv(_ other: PyObject)
    // result.__rfloordiv__ = PyInt.rfloorDiv(_ other: PyObject)
    // result.__mod__ = PyInt.mod(_ other: PyObject)
    // result.__rmod__ = PyInt.rmod(_ other: PyObject)
    // result.__divmod__ = PyInt.divMod(_ other: PyObject)
    // result.__rdivmod__ = PyInt.rdivMod(_ other: PyObject)
    // result.__lshift__ = PyInt.lShift(_ other: PyObject)
    // result.__rlshift__ = PyInt.rlShift(_ other: PyObject)
    // result.__rshift__ = PyInt.rShift(_ other: PyObject)
    // result.__rrshift__ = PyInt.rrShift(_ other: PyObject)
    // result.__and__ = PyInt.and(_ other: PyObject)
    // result.__rand__ = PyInt.rand(_ other: PyObject)
    // result.__or__ = PyInt.or(_ other: PyObject)
    // result.__ror__ = PyInt.ror(_ other: PyObject)
    // result.__xor__ = PyInt.xor(_ other: PyObject)
    // result.__rxor__ = PyInt.rxor(_ other: PyObject)
    // result.__invert__ = PyInt.invert()
    // result.__round__ = PyInt.round(nDigits: PyObject?)

    return result
  }

  internal static func list(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "list", type: type, base: base)

    // result.__doc__ = PyList.doc


    // result.__eq__ = PyList.isEqual(_ other: PyObject)
    // result.__lt__ = PyList.isLess(_ other: PyObject)
    // result.__le__ = PyList.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyList.isGreater(_ other: PyObject)
    // result.__ge__ = PyList.isGreaterEqual(_ other: PyObject)
    // result.__repr__ = PyList.repr()
    // result.__len__ = PyList.getLength()
    // result.__contains__ = PyList.contains(_ element: PyObject)
    // result.__getitem__ = PyList.getItem(at index: PyObject)
    // result.count = PyList.count(_ element: PyObject)
    // result.index = PyList.getIndex(of element: PyObject)
    // result.append = PyList.append(_ element: PyObject)
    // result.extend = PyList.extend(_ iterator: PyObject)
    // result.clear = PyList.clear()
    // result.copy = PyList.copy()
    // result.__add__ = PyList.add(_ other: PyObject)
    // result.__iadd__ = PyList.addInPlace(_ other: PyObject)
    // result.__mul__ = PyList.mul(_ other: PyObject)
    // result.__rmul__ = PyList.rmul(_ other: PyObject)
    // result.__imul__ = PyList.mulInPlace(_ other: PyObject)

    return result
  }

  internal static func method(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "method", type: type, base: base)

    // result.__doc__ = PyMethod.doc


    // result.__repr__ = PyMethod.repr()
    // result.__call__ = PyMethod.call()

    return result
  }

  internal static func module(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "module", type: type, base: base)

    // result.__doc__ = PyModule.doc

    // result.__dict__ = PyModule.dict

    // result.__repr__ = PyModule.repr()
    // result.__getattribute__ = PyModule.getAttribute(key: String)
    // result.__setattr__ = PyModule.setAttribute(key: String, value: PyObject)
    // result.__delattr__ = PyModule.delAttribute(key: String)
    // result.__dir__ = PyModule.dir()

    return result
  }

  internal static func NoneType(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "NoneType", type: type, base: base)



    // result.__repr__ = PyNone.repr()
    // result.__bool__ = PyNone.asBool()

    return result
  }

  internal static func NotImplementedType(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "NotImplementedType", type: type, base: base)



    // result.__repr__ = PyNotImplemented.repr()

    return result
  }

  internal static func property(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "property", type: type, base: base)

    // result.__doc__ = PyProperty.doc



    return result
  }

  internal static func range(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "range", type: type, base: base)

    // result.__doc__ = PyRange.doc


    // result.__eq__ = PyRange.isEqual(_ other: PyObject)
    // result.__lt__ = PyRange.isLess(_ other: PyObject)
    // result.__le__ = PyRange.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyRange.isGreater(_ other: PyObject)
    // result.__ge__ = PyRange.isGreaterEqual(_ other: PyObject)
    // result.__hash__ = PyRange.hash()
    // result.__repr__ = PyRange.repr()
    // result.__bool__ = PyRange.asBool()
    // result.__len__ = PyRange.getLength()
    // result.__contains__ = PyRange.contains(_ element: PyObject)
    // result.__getitem__ = PyRange.getItem(at index: PyObject)
    // result.count = PyRange.count(_ element: PyObject)
    // result.index = PyRange.getIndex(of element: PyObject)

    return result
  }

  internal static func slice(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "slice", type: type, base: base)

    // result.__doc__ = PySlice.doc


    // result.__eq__ = PySlice.isEqual(_ other: PyObject)
    // result.__lt__ = PySlice.isLess(_ other: PyObject)
    // result.__le__ = PySlice.isLessEqual(_ other: PyObject)
    // result.__gt__ = PySlice.isGreater(_ other: PyObject)
    // result.__ge__ = PySlice.isGreaterEqual(_ other: PyObject)
    // result.__repr__ = PySlice.repr()

    return result
  }

  internal static func tuple(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    let result = PyType(context, name: "tuple", type: type, base: base)

    // result.__doc__ = PyTuple.doc


    // result.__eq__ = PyTuple.isEqual(_ other: PyObject)
    // result.__lt__ = PyTuple.isLess(_ other: PyObject)
    // result.__le__ = PyTuple.isLessEqual(_ other: PyObject)
    // result.__gt__ = PyTuple.isGreater(_ other: PyObject)
    // result.__ge__ = PyTuple.isGreaterEqual(_ other: PyObject)
    // result.__hash__ = PyTuple.hash()
    // result.__repr__ = PyTuple.repr()
    // result.__len__ = PyTuple.getLength()
    // result.__contains__ = PyTuple.contains(_ element: PyObject)
    // result.__getitem__ = PyTuple.getItem(at index: PyObject)
    // result.count = PyTuple.count(_ element: PyObject)
    // result.index = PyTuple.getIndex(of element: PyObject)
    // result.__add__ = PyTuple.add(_ other: PyObject)
    // result.__mul__ = PyTuple.mul(_ other: PyObject)
    // result.__rmul__ = PyTuple.rmul(_ other: PyObject)

    return result
  }

  internal static func type(_ context: PyContext, type: PyType, base: PyType?) -> PyType {
    #warning("Type PyType should be marked final.")
    let result = PyType(context, name: "type", type: type, base: base)

    // result.__doc__ = PyType.doc


    // result.__repr__ = PyType.repr()

    return result
  }
}
