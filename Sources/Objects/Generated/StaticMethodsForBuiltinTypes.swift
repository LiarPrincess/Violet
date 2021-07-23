// =========================================================================================
// Automatically generated from: ./Sources/Objects/Generated/StaticMethodsForBuiltinTypes.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// =========================================================================================

// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable closure_body_length
// swiftlint:disable file_length

/// Static methods defined on builtin types.
///
/// See `PyStaticCall` documentation for more information.
internal enum StaticMethodsForBuiltinTypes {

  // MARK: - Object

  internal static var object: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = PyType.StaticallyKnownNotOverriddenMethods()
    result.__repr__ = .init(PyObjectType.repr(zelf:))
    result.__str__ = .init(PyObjectType.str(zelf:))
    result.__hash__ = .init(PyObjectType.hash(zelf:))
    result.__eq__ = .init(PyObjectType.isEqual(zelf:other:))
    result.__ne__ = .init(PyObjectType.isNotEqual(zelf:other:))
    result.__lt__ = .init(PyObjectType.isLess(zelf:other:))
    result.__le__ = .init(PyObjectType.isLessEqual(zelf:other:))
    result.__gt__ = .init(PyObjectType.isGreater(zelf:other:))
    result.__ge__ = .init(PyObjectType.isGreaterEqual(zelf:other:))
    result.__getattribute__ = .init(PyObjectType.getAttribute(zelf:name:))
    result.__setattr__ = .init(PyObjectType.setAttribute(zelf:name:value:))
    result.__delattr__ = .init(PyObjectType.delAttribute(zelf:name:))
    result.__dir__ = .init(PyObjectType.dir(zelf:))
    return result
  }()

  // MARK: - Bool

  internal static var bool: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.int.copy()
    result.__repr__ = .init(PyBool.reprBool)
    result.__str__ = .init(PyBool.strBool)
    result.__and__ = .init(PyBool.andBool(_:))
    result.__or__ = .init(PyBool.orBool(_:))
    result.__xor__ = .init(PyBool.xorBool(_:))
    result.__rand__ = .init(PyBool.randBool(_:))
    result.__ror__ = .init(PyBool.rorBool(_:))
    result.__rxor__ = .init(PyBool.rxorBool(_:))
    return result
  }()

  // MARK: - BuiltinFunction

  internal static var builtinFunction: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyBuiltinFunction.repr)
    result.__hash__ = .init(PyBuiltinFunction.hash)
    result.__eq__ = .init(PyBuiltinFunction.isEqual(_:))
    result.__ne__ = .init(PyBuiltinFunction.isNotEqual(_:))
    result.__lt__ = .init(PyBuiltinFunction.isLess(_:))
    result.__le__ = .init(PyBuiltinFunction.isLessEqual(_:))
    result.__gt__ = .init(PyBuiltinFunction.isGreater(_:))
    result.__ge__ = .init(PyBuiltinFunction.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyBuiltinFunction.getAttribute(name:))
    result.__call__ = .init(PyBuiltinFunction.call(args:kwargs:))
    return result
  }()

  // MARK: - BuiltinMethod

  internal static var builtinMethod: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyBuiltinMethod.repr)
    result.__hash__ = .init(PyBuiltinMethod.hash)
    result.__eq__ = .init(PyBuiltinMethod.isEqual(_:))
    result.__ne__ = .init(PyBuiltinMethod.isNotEqual(_:))
    result.__lt__ = .init(PyBuiltinMethod.isLess(_:))
    result.__le__ = .init(PyBuiltinMethod.isLessEqual(_:))
    result.__gt__ = .init(PyBuiltinMethod.isGreater(_:))
    result.__ge__ = .init(PyBuiltinMethod.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyBuiltinMethod.getAttribute(name:))
    result.__call__ = .init(PyBuiltinMethod.call(args:kwargs:))
    return result
  }()

  // MARK: - ByteArray

  internal static var byteArray: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyByteArray.repr)
    result.__str__ = .init(PyByteArray.str)
    result.__hash__ = .init(PyByteArray.hash)
    result.__eq__ = .init(PyByteArray.isEqual(_:))
    result.__ne__ = .init(PyByteArray.isNotEqual(_:))
    result.__lt__ = .init(PyByteArray.isLess(_:))
    result.__le__ = .init(PyByteArray.isLessEqual(_:))
    result.__gt__ = .init(PyByteArray.isGreater(_:))
    result.__ge__ = .init(PyByteArray.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyByteArray.getAttribute(name:))
    result.__getitem__ = .init(PyByteArray.getItem(index:))
    result.__setitem__ = .init(PyByteArray.setItem(index:value:))
    result.__delitem__ = .init(PyByteArray.delItem(index:))
    result.__iter__ = .init(PyByteArray.iter)
    result.__len__ = .init(PyByteArray.getLength)
    result.__contains__ = .init(PyByteArray.contains(element:))
    result.__add__ = .init(PyByteArray.add(_:))
    result.__mul__ = .init(PyByteArray.mul(_:))
    result.__rmul__ = .init(PyByteArray.rmul(_:))
    result.__iadd__ = .init(PyByteArray.iadd(_:))
    result.__imul__ = .init(PyByteArray.imul(_:))
    return result
  }()

  // MARK: - ByteArrayIterator

  internal static var byteArrayIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyByteArrayIterator.getAttribute(name:))
    result.__iter__ = .init(PyByteArrayIterator.iter)
    result.__next__ = .init(PyByteArrayIterator.next)
    return result
  }()

  // MARK: - Bytes

  internal static var bytes: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyBytes.repr)
    result.__str__ = .init(PyBytes.str)
    result.__hash__ = .init(PyBytes.hash)
    result.__eq__ = .init(PyBytes.isEqual(_:))
    result.__ne__ = .init(PyBytes.isNotEqual(_:))
    result.__lt__ = .init(PyBytes.isLess(_:))
    result.__le__ = .init(PyBytes.isLessEqual(_:))
    result.__gt__ = .init(PyBytes.isGreater(_:))
    result.__ge__ = .init(PyBytes.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyBytes.getAttribute(name:))
    result.__getitem__ = .init(PyBytes.getItem(index:))
    result.__iter__ = .init(PyBytes.iter)
    result.__len__ = .init(PyBytes.getLength)
    result.__contains__ = .init(PyBytes.contains(element:))
    result.__add__ = .init(PyBytes.add(_:))
    result.__mul__ = .init(PyBytes.mul(_:))
    result.__rmul__ = .init(PyBytes.rmul(_:))
    return result
  }()

  // MARK: - BytesIterator

  internal static var bytesIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyBytesIterator.getAttribute(name:))
    result.__iter__ = .init(PyBytesIterator.iter)
    result.__next__ = .init(PyBytesIterator.next)
    return result
  }()

  // MARK: - CallableIterator

  internal static var callableIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyCallableIterator.getAttribute(name:))
    result.__iter__ = .init(PyCallableIterator.iter)
    result.__next__ = .init(PyCallableIterator.next)
    return result
  }()

  // MARK: - Cell

  internal static var cell: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyCell.repr)
    result.__eq__ = .init(PyCell.isEqual(_:))
    result.__ne__ = .init(PyCell.isNotEqual(_:))
    result.__lt__ = .init(PyCell.isLess(_:))
    result.__le__ = .init(PyCell.isLessEqual(_:))
    result.__gt__ = .init(PyCell.isGreater(_:))
    result.__ge__ = .init(PyCell.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyCell.getAttribute(name:))
    return result
  }()

  // MARK: - ClassMethod

  internal static var classMethod: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__isabstractmethod__ = .init(PyClassMethod.isAbstractMethod)
    return result
  }()

  // MARK: - Code

  internal static var code: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyCode.repr)
    result.__hash__ = .init(PyCode.hash)
    result.__eq__ = .init(PyCode.isEqual(_:))
    result.__ne__ = .init(PyCode.isNotEqual(_:))
    result.__lt__ = .init(PyCode.isLess(_:))
    result.__le__ = .init(PyCode.isLessEqual(_:))
    result.__gt__ = .init(PyCode.isGreater(_:))
    result.__ge__ = .init(PyCode.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyCode.getAttribute(name:))
    return result
  }()

  // MARK: - Complex

  internal static var complex: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyComplex.repr)
    result.__str__ = .init(PyComplex.str)
    result.__hash__ = .init(PyComplex.hash)
    result.__eq__ = .init(PyComplex.isEqual(_:))
    result.__ne__ = .init(PyComplex.isNotEqual(_:))
    result.__lt__ = .init(PyComplex.isLess(_:))
    result.__le__ = .init(PyComplex.isLessEqual(_:))
    result.__gt__ = .init(PyComplex.isGreater(_:))
    result.__ge__ = .init(PyComplex.isGreaterEqual(_:))
    result.__bool__ = .init(PyComplex.asBool)
    result.__int__ = .init(PyComplex.asInt)
    result.__float__ = .init(PyComplex.asFloat)
    result.__getattribute__ = .init(PyComplex.getAttribute(name:))
    result.__pos__ = .init(PyComplex.positive)
    result.__neg__ = .init(PyComplex.negative)
    result.__abs__ = .init(PyComplex.abs)
    result.__add__ = .init(PyComplex.add(_:))
    result.__divmod__ = .init(PyComplex.divmod(_:))
    result.__floordiv__ = .init(PyComplex.floordiv(_:))
    result.__mod__ = .init(PyComplex.mod(_:))
    result.__mul__ = .init(PyComplex.mul(_:))
    result.__sub__ = .init(PyComplex.sub(_:))
    result.__truediv__ = .init(PyComplex.truediv(_:))
    result.__radd__ = .init(PyComplex.radd(_:))
    result.__rdivmod__ = .init(PyComplex.rdivmod(_:))
    result.__rfloordiv__ = .init(PyComplex.rfloordiv(_:))
    result.__rmod__ = .init(PyComplex.rmod(_:))
    result.__rmul__ = .init(PyComplex.rmul(_:))
    result.__rsub__ = .init(PyComplex.rsub(_:))
    result.__rtruediv__ = .init(PyComplex.rtruediv(_:))
    result.__pow__ = .init(PyComplex.pow(exp:mod:))
    result.__rpow__ = .init(PyComplex.rpow(base:mod:))
    return result
  }()

  // MARK: - Dict

  internal static var dict: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyDict.repr)
    result.__hash__ = .init(PyDict.hash)
    result.__eq__ = .init(PyDict.isEqual(_:))
    result.__ne__ = .init(PyDict.isNotEqual(_:))
    result.__lt__ = .init(PyDict.isLess(_:))
    result.__le__ = .init(PyDict.isLessEqual(_:))
    result.__gt__ = .init(PyDict.isGreater(_:))
    result.__ge__ = .init(PyDict.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyDict.getAttribute(name:))
    result.__getitem__ = .init(PyDict.getItem(index:))
    result.__setitem__ = .init(PyDict.setItem(index:value:))
    result.__delitem__ = .init(PyDict.delItem(index:))
    result.__iter__ = .init(PyDict.iter)
    result.__len__ = .init(PyDict.getLength)
    result.__contains__ = .init(PyDict.contains(element:))
    result.keys = .init(PyDict.keys)
    return result
  }()

  // MARK: - DictItemIterator

  internal static var dictItemIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyDictItemIterator.getAttribute(name:))
    result.__iter__ = .init(PyDictItemIterator.iter)
    result.__next__ = .init(PyDictItemIterator.next)
    return result
  }()

  // MARK: - DictItems

  internal static var dictItems: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyDictItems.repr)
    result.__hash__ = .init(PyDictItems.hash)
    result.__eq__ = .init(PyDictItems.isEqual(_:))
    result.__ne__ = .init(PyDictItems.isNotEqual(_:))
    result.__lt__ = .init(PyDictItems.isLess(_:))
    result.__le__ = .init(PyDictItems.isLessEqual(_:))
    result.__gt__ = .init(PyDictItems.isGreater(_:))
    result.__ge__ = .init(PyDictItems.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyDictItems.getAttribute(name:))
    result.__iter__ = .init(PyDictItems.iter)
    result.__len__ = .init(PyDictItems.getLength)
    result.__contains__ = .init(PyDictItems.contains(element:))
    return result
  }()

  // MARK: - DictKeyIterator

  internal static var dictKeyIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyDictKeyIterator.getAttribute(name:))
    result.__iter__ = .init(PyDictKeyIterator.iter)
    result.__next__ = .init(PyDictKeyIterator.next)
    return result
  }()

  // MARK: - DictKeys

  internal static var dictKeys: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyDictKeys.repr)
    result.__hash__ = .init(PyDictKeys.hash)
    result.__eq__ = .init(PyDictKeys.isEqual(_:))
    result.__ne__ = .init(PyDictKeys.isNotEqual(_:))
    result.__lt__ = .init(PyDictKeys.isLess(_:))
    result.__le__ = .init(PyDictKeys.isLessEqual(_:))
    result.__gt__ = .init(PyDictKeys.isGreater(_:))
    result.__ge__ = .init(PyDictKeys.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyDictKeys.getAttribute(name:))
    result.__iter__ = .init(PyDictKeys.iter)
    result.__len__ = .init(PyDictKeys.getLength)
    result.__contains__ = .init(PyDictKeys.contains(element:))
    return result
  }()

  // MARK: - DictValueIterator

  internal static var dictValueIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyDictValueIterator.getAttribute(name:))
    result.__iter__ = .init(PyDictValueIterator.iter)
    result.__next__ = .init(PyDictValueIterator.next)
    return result
  }()

  // MARK: - DictValues

  internal static var dictValues: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyDictValues.repr)
    result.__getattribute__ = .init(PyDictValues.getAttribute(name:))
    result.__iter__ = .init(PyDictValues.iter)
    result.__len__ = .init(PyDictValues.getLength)
    return result
  }()

  // MARK: - Ellipsis

  internal static var ellipsis: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyEllipsis.repr)
    result.__getattribute__ = .init(PyEllipsis.getAttribute(name:))
    return result
  }()

  // MARK: - Enumerate

  internal static var enumerate: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyEnumerate.getAttribute(name:))
    result.__iter__ = .init(PyEnumerate.iter)
    result.__next__ = .init(PyEnumerate.next)
    return result
  }()

  // MARK: - Filter

  internal static var filter: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyFilter.getAttribute(name:))
    result.__iter__ = .init(PyFilter.iter)
    result.__next__ = .init(PyFilter.next)
    return result
  }()

  // MARK: - Float

  internal static var float: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyFloat.repr)
    result.__str__ = .init(PyFloat.str)
    result.__hash__ = .init(PyFloat.hash)
    result.__eq__ = .init(PyFloat.isEqual(_:))
    result.__ne__ = .init(PyFloat.isNotEqual(_:))
    result.__lt__ = .init(PyFloat.isLess(_:))
    result.__le__ = .init(PyFloat.isLessEqual(_:))
    result.__gt__ = .init(PyFloat.isGreater(_:))
    result.__ge__ = .init(PyFloat.isGreaterEqual(_:))
    result.__bool__ = .init(PyFloat.asBool)
    result.__int__ = .init(PyFloat.asInt)
    result.__float__ = .init(PyFloat.asFloat)
    result.__getattribute__ = .init(PyFloat.getAttribute(name:))
    result.__pos__ = .init(PyFloat.positive)
    result.__neg__ = .init(PyFloat.negative)
    result.__abs__ = .init(PyFloat.abs)
    result.__trunc__ = .init(PyFloat.trunc)
    result.__round__ = .init(PyFloat.round(nDigits:))
    result.__add__ = .init(PyFloat.add(_:))
    result.__divmod__ = .init(PyFloat.divmod(_:))
    result.__floordiv__ = .init(PyFloat.floordiv(_:))
    result.__mod__ = .init(PyFloat.mod(_:))
    result.__mul__ = .init(PyFloat.mul(_:))
    result.__sub__ = .init(PyFloat.sub(_:))
    result.__truediv__ = .init(PyFloat.truediv(_:))
    result.__radd__ = .init(PyFloat.radd(_:))
    result.__rdivmod__ = .init(PyFloat.rdivmod(_:))
    result.__rfloordiv__ = .init(PyFloat.rfloordiv(_:))
    result.__rmod__ = .init(PyFloat.rmod(_:))
    result.__rmul__ = .init(PyFloat.rmul(_:))
    result.__rsub__ = .init(PyFloat.rsub(_:))
    result.__rtruediv__ = .init(PyFloat.rtruediv(_:))
    result.__pow__ = .init(PyFloat.pow(exp:mod:))
    result.__rpow__ = .init(PyFloat.rpow(base:mod:))
    return result
  }()

  // MARK: - Frame

  internal static var frame: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyFrame.repr)
    result.__getattribute__ = .init(PyFrame.getAttribute(name:))
    result.__setattr__ = .init(PyFrame.setAttribute(name:value:))
    result.__delattr__ = .init(PyFrame.delAttribute(name:))
    return result
  }()

  // MARK: - FrozenSet

  internal static var frozenSet: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyFrozenSet.repr)
    result.__hash__ = .init(PyFrozenSet.hash)
    result.__eq__ = .init(PyFrozenSet.isEqual(_:))
    result.__ne__ = .init(PyFrozenSet.isNotEqual(_:))
    result.__lt__ = .init(PyFrozenSet.isLess(_:))
    result.__le__ = .init(PyFrozenSet.isLessEqual(_:))
    result.__gt__ = .init(PyFrozenSet.isGreater(_:))
    result.__ge__ = .init(PyFrozenSet.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyFrozenSet.getAttribute(name:))
    result.__iter__ = .init(PyFrozenSet.iter)
    result.__len__ = .init(PyFrozenSet.getLength)
    result.__contains__ = .init(PyFrozenSet.contains(element:))
    result.__and__ = .init(PyFrozenSet.and(_:))
    result.__or__ = .init(PyFrozenSet.or(_:))
    result.__sub__ = .init(PyFrozenSet.sub(_:))
    result.__xor__ = .init(PyFrozenSet.xor(_:))
    result.__rand__ = .init(PyFrozenSet.rand(_:))
    result.__ror__ = .init(PyFrozenSet.ror(_:))
    result.__rsub__ = .init(PyFrozenSet.rsub(_:))
    result.__rxor__ = .init(PyFrozenSet.rxor(_:))
    return result
  }()

  // MARK: - Function

  internal static var function: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyFunction.repr)
    result.__call__ = .init(PyFunction.call(args:kwargs:))
    return result
  }()

  // MARK: - Int

  internal static var int: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyInt.repr)
    result.__str__ = .init(PyInt.str)
    result.__hash__ = .init(PyInt.hash)
    result.__eq__ = .init(PyInt.isEqual(_:))
    result.__ne__ = .init(PyInt.isNotEqual(_:))
    result.__lt__ = .init(PyInt.isLess(_:))
    result.__le__ = .init(PyInt.isLessEqual(_:))
    result.__gt__ = .init(PyInt.isGreater(_:))
    result.__ge__ = .init(PyInt.isGreaterEqual(_:))
    result.__bool__ = .init(PyInt.asBool)
    result.__int__ = .init(PyInt.asInt)
    result.__float__ = .init(PyInt.asFloat)
    result.__index__ = .init(PyInt.asIndex)
    result.__getattribute__ = .init(PyInt.getAttribute(name:))
    result.__pos__ = .init(PyInt.positive)
    result.__neg__ = .init(PyInt.negative)
    result.__abs__ = .init(PyInt.abs)
    result.__invert__ = .init(PyInt.invert)
    result.__trunc__ = .init(PyInt.trunc)
    result.__round__ = .init(PyInt.round(nDigits:))
    result.__add__ = .init(PyInt.add(_:))
    result.__and__ = .init(PyInt.and(_:))
    result.__divmod__ = .init(PyInt.divmod(_:))
    result.__floordiv__ = .init(PyInt.floordiv(_:))
    result.__lshift__ = .init(PyInt.lshift(_:))
    result.__mod__ = .init(PyInt.mod(_:))
    result.__mul__ = .init(PyInt.mul(_:))
    result.__or__ = .init(PyInt.or(_:))
    result.__rshift__ = .init(PyInt.rshift(_:))
    result.__sub__ = .init(PyInt.sub(_:))
    result.__truediv__ = .init(PyInt.truediv(_:))
    result.__xor__ = .init(PyInt.xor(_:))
    result.__radd__ = .init(PyInt.radd(_:))
    result.__rand__ = .init(PyInt.rand(_:))
    result.__rdivmod__ = .init(PyInt.rdivmod(_:))
    result.__rfloordiv__ = .init(PyInt.rfloordiv(_:))
    result.__rlshift__ = .init(PyInt.rlshift(_:))
    result.__rmod__ = .init(PyInt.rmod(_:))
    result.__rmul__ = .init(PyInt.rmul(_:))
    result.__ror__ = .init(PyInt.ror(_:))
    result.__rrshift__ = .init(PyInt.rrshift(_:))
    result.__rsub__ = .init(PyInt.rsub(_:))
    result.__rtruediv__ = .init(PyInt.rtruediv(_:))
    result.__rxor__ = .init(PyInt.rxor(_:))
    result.__pow__ = .init(PyInt.pow(exp:mod:))
    result.__rpow__ = .init(PyInt.rpow(base:mod:))
    return result
  }()

  // MARK: - Iterator

  internal static var iterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyIterator.getAttribute(name:))
    result.__iter__ = .init(PyIterator.iter)
    result.__next__ = .init(PyIterator.next)
    return result
  }()

  // MARK: - List

  internal static var list: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyList.repr)
    result.__hash__ = .init(PyList.hash)
    result.__eq__ = .init(PyList.isEqual(_:))
    result.__ne__ = .init(PyList.isNotEqual(_:))
    result.__lt__ = .init(PyList.isLess(_:))
    result.__le__ = .init(PyList.isLessEqual(_:))
    result.__gt__ = .init(PyList.isGreater(_:))
    result.__ge__ = .init(PyList.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyList.getAttribute(name:))
    result.__getitem__ = .init(PyList.getItem(index:))
    result.__setitem__ = .init(PyList.setItem(index:value:))
    result.__delitem__ = .init(PyList.delItem(index:))
    result.__iter__ = .init(PyList.iter)
    result.__len__ = .init(PyList.getLength)
    result.__contains__ = .init(PyList.contains(element:))
    result.__reversed__ = .init(PyList.reversed)
    result.__add__ = .init(PyList.add(_:))
    result.__mul__ = .init(PyList.mul(_:))
    result.__rmul__ = .init(PyList.rmul(_:))
    result.__iadd__ = .init(PyList.iadd(_:))
    result.__imul__ = .init(PyList.imul(_:))
    return result
  }()

  // MARK: - ListIterator

  internal static var listIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyListIterator.getAttribute(name:))
    result.__iter__ = .init(PyListIterator.iter)
    result.__next__ = .init(PyListIterator.next)
    return result
  }()

  // MARK: - ListReverseIterator

  internal static var listReverseIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyListReverseIterator.getAttribute(name:))
    result.__iter__ = .init(PyListReverseIterator.iter)
    result.__next__ = .init(PyListReverseIterator.next)
    return result
  }()

  // MARK: - Map

  internal static var map: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyMap.getAttribute(name:))
    result.__iter__ = .init(PyMap.iter)
    result.__next__ = .init(PyMap.next)
    return result
  }()

  // MARK: - Method

  internal static var method: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyMethod.repr)
    result.__hash__ = .init(PyMethod.hash)
    result.__eq__ = .init(PyMethod.isEqual(_:))
    result.__ne__ = .init(PyMethod.isNotEqual(_:))
    result.__lt__ = .init(PyMethod.isLess(_:))
    result.__le__ = .init(PyMethod.isLessEqual(_:))
    result.__gt__ = .init(PyMethod.isGreater(_:))
    result.__ge__ = .init(PyMethod.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyMethod.getAttribute(name:))
    result.__setattr__ = .init(PyMethod.setAttribute(name:value:))
    result.__delattr__ = .init(PyMethod.delAttribute(name:))
    result.__call__ = .init(PyMethod.call(args:kwargs:))
    return result
  }()

  // MARK: - Module

  internal static var module: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyModule.repr)
    result.__getattribute__ = .init(PyModule.getAttribute(name:))
    result.__setattr__ = .init(PyModule.setAttribute(name:value:))
    result.__delattr__ = .init(PyModule.delAttribute(name:))
    result.__dir__ = .init(PyModule.dir)
    return result
  }()

  // MARK: - Namespace

  internal static var namespace: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyNamespace.repr)
    result.__eq__ = .init(PyNamespace.isEqual(_:))
    result.__ne__ = .init(PyNamespace.isNotEqual(_:))
    result.__lt__ = .init(PyNamespace.isLess(_:))
    result.__le__ = .init(PyNamespace.isLessEqual(_:))
    result.__gt__ = .init(PyNamespace.isGreater(_:))
    result.__ge__ = .init(PyNamespace.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyNamespace.getAttribute(name:))
    result.__setattr__ = .init(PyNamespace.setAttribute(name:value:))
    result.__delattr__ = .init(PyNamespace.delAttribute(name:))
    return result
  }()

  // MARK: - None

  internal static var none: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyNone.repr)
    result.__bool__ = .init(PyNone.asBool)
    result.__getattribute__ = .init(PyNone.getAttribute(name:))
    return result
  }()

  // MARK: - NotImplemented

  internal static var notImplemented: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyNotImplemented.repr)
    return result
  }()

  // MARK: - Property

  internal static var property: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyProperty.getAttribute(name:))
    return result
  }()

  // MARK: - Range

  internal static var range: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyRange.repr)
    result.__hash__ = .init(PyRange.hash)
    result.__eq__ = .init(PyRange.isEqual(_:))
    result.__ne__ = .init(PyRange.isNotEqual(_:))
    result.__lt__ = .init(PyRange.isLess(_:))
    result.__le__ = .init(PyRange.isLessEqual(_:))
    result.__gt__ = .init(PyRange.isGreater(_:))
    result.__ge__ = .init(PyRange.isGreaterEqual(_:))
    result.__bool__ = .init(PyRange.asBool)
    result.__getattribute__ = .init(PyRange.getAttribute(name:))
    result.__getitem__ = .init(PyRange.getItem(index:))
    result.__iter__ = .init(PyRange.iter)
    result.__len__ = .init(PyRange.getLength)
    result.__contains__ = .init(PyRange.contains(element:))
    result.__reversed__ = .init(PyRange.reversed)
    return result
  }()

  // MARK: - RangeIterator

  internal static var rangeIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyRangeIterator.getAttribute(name:))
    result.__iter__ = .init(PyRangeIterator.iter)
    result.__next__ = .init(PyRangeIterator.next)
    return result
  }()

  // MARK: - Reversed

  internal static var reversed: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyReversed.getAttribute(name:))
    result.__iter__ = .init(PyReversed.iter)
    result.__next__ = .init(PyReversed.next)
    return result
  }()

  // MARK: - Set

  internal static var set: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PySet.repr)
    result.__hash__ = .init(PySet.hash)
    result.__eq__ = .init(PySet.isEqual(_:))
    result.__ne__ = .init(PySet.isNotEqual(_:))
    result.__lt__ = .init(PySet.isLess(_:))
    result.__le__ = .init(PySet.isLessEqual(_:))
    result.__gt__ = .init(PySet.isGreater(_:))
    result.__ge__ = .init(PySet.isGreaterEqual(_:))
    result.__getattribute__ = .init(PySet.getAttribute(name:))
    result.__iter__ = .init(PySet.iter)
    result.__len__ = .init(PySet.getLength)
    result.__contains__ = .init(PySet.contains(element:))
    result.__and__ = .init(PySet.and(_:))
    result.__or__ = .init(PySet.or(_:))
    result.__sub__ = .init(PySet.sub(_:))
    result.__xor__ = .init(PySet.xor(_:))
    result.__rand__ = .init(PySet.rand(_:))
    result.__ror__ = .init(PySet.ror(_:))
    result.__rsub__ = .init(PySet.rsub(_:))
    result.__rxor__ = .init(PySet.rxor(_:))
    return result
  }()

  // MARK: - SetIterator

  internal static var setIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PySetIterator.getAttribute(name:))
    result.__iter__ = .init(PySetIterator.iter)
    result.__next__ = .init(PySetIterator.next)
    return result
  }()

  // MARK: - Slice

  internal static var slice: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PySlice.repr)
    result.__hash__ = .init(PySlice.hash)
    result.__eq__ = .init(PySlice.isEqual(_:))
    result.__ne__ = .init(PySlice.isNotEqual(_:))
    result.__lt__ = .init(PySlice.isLess(_:))
    result.__le__ = .init(PySlice.isLessEqual(_:))
    result.__gt__ = .init(PySlice.isGreater(_:))
    result.__ge__ = .init(PySlice.isGreaterEqual(_:))
    result.__getattribute__ = .init(PySlice.getAttribute(name:))
    return result
  }()

  // MARK: - StaticMethod

  internal static var staticMethod: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__isabstractmethod__ = .init(PyStaticMethod.isAbstractMethod)
    return result
  }()

  // MARK: - String

  internal static var string: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyString.repr)
    result.__str__ = .init(PyString.str)
    result.__hash__ = .init(PyString.hash)
    result.__eq__ = .init(PyString.isEqual(_:))
    result.__ne__ = .init(PyString.isNotEqual(_:))
    result.__lt__ = .init(PyString.isLess(_:))
    result.__le__ = .init(PyString.isLessEqual(_:))
    result.__gt__ = .init(PyString.isGreater(_:))
    result.__ge__ = .init(PyString.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyString.getAttribute(name:))
    result.__getitem__ = .init(PyString.getItem(index:))
    result.__iter__ = .init(PyString.iter)
    result.__len__ = .init(PyString.getLength)
    result.__contains__ = .init(PyString.contains(element:))
    result.__add__ = .init(PyString.add(_:))
    result.__mul__ = .init(PyString.mul(_:))
    result.__rmul__ = .init(PyString.rmul(_:))
    return result
  }()

  // MARK: - StringIterator

  internal static var stringIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyStringIterator.getAttribute(name:))
    result.__iter__ = .init(PyStringIterator.iter)
    result.__next__ = .init(PyStringIterator.next)
    return result
  }()

  // MARK: - Super

  internal static var `super`: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PySuper.repr)
    result.__getattribute__ = .init(PySuper.getAttribute(name:))
    return result
  }()

  // MARK: - TextFile

  internal static var textFile: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyTextFile.repr)
    result.__del__ = .init(PyTextFile.del)
    return result
  }()

  // MARK: - Traceback

  internal static var traceback: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyTraceback.getAttribute(name:))
    result.__dir__ = .init(PyTraceback.dir)
    return result
  }()

  // MARK: - Tuple

  internal static var tuple: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyTuple.repr)
    result.__hash__ = .init(PyTuple.hash)
    result.__eq__ = .init(PyTuple.isEqual(_:))
    result.__ne__ = .init(PyTuple.isNotEqual(_:))
    result.__lt__ = .init(PyTuple.isLess(_:))
    result.__le__ = .init(PyTuple.isLessEqual(_:))
    result.__gt__ = .init(PyTuple.isGreater(_:))
    result.__ge__ = .init(PyTuple.isGreaterEqual(_:))
    result.__getattribute__ = .init(PyTuple.getAttribute(name:))
    result.__getitem__ = .init(PyTuple.getItem(index:))
    result.__iter__ = .init(PyTuple.iter)
    result.__len__ = .init(PyTuple.getLength)
    result.__contains__ = .init(PyTuple.contains(element:))
    result.__add__ = .init(PyTuple.add(_:))
    result.__mul__ = .init(PyTuple.mul(_:))
    result.__rmul__ = .init(PyTuple.rmul(_:))
    return result
  }()

  // MARK: - TupleIterator

  internal static var tupleIterator: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyTupleIterator.getAttribute(name:))
    result.__iter__ = .init(PyTupleIterator.iter)
    result.__next__ = .init(PyTupleIterator.next)
    return result
  }()

  // MARK: - Type

  internal static var type: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyType.repr)
    result.__getattribute__ = .init(PyType.getAttribute(name:))
    result.__setattr__ = .init(PyType.setAttribute(name:value:))
    result.__delattr__ = .init(PyType.delAttribute(name:))
    result.__dir__ = .init(PyType.dir)
    result.__call__ = .init(PyType.call(args:kwargs:))
    result.__instancecheck__ = .init(PyType.isType(of:))
    result.__subclasscheck__ = .init(PyType.isSubtype(of:))
    return result
  }()

  // MARK: - Zip

  internal static var zip: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__getattribute__ = .init(PyZip.getAttribute(name:))
    result.__iter__ = .init(PyZip.iter)
    result.__next__ = .init(PyZip.next)
    return result
  }()

  // MARK: - ArithmeticError

  // 'PyArithmeticError' does not any interesting methods to 'PyException'.
  internal static let arithmeticError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - AssertionError

  // 'PyAssertionError' does not any interesting methods to 'PyException'.
  internal static let assertionError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - AttributeError

  // 'PyAttributeError' does not any interesting methods to 'PyException'.
  internal static let attributeError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - BaseException

  internal static var baseException: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.object.copy()
    result.__repr__ = .init(PyBaseException.repr)
    result.__str__ = .init(PyBaseException.str(baseException:))
    result.__getattribute__ = .init(PyBaseException.getAttribute(name:))
    result.__setattr__ = .init(PyBaseException.setAttribute(name:value:))
    result.__delattr__ = .init(PyBaseException.delAttribute(name:))
    return result
  }()

  // MARK: - BlockingIOError

  // 'PyBlockingIOError' does not any interesting methods to 'PyOSError'.
  internal static let blockingIOError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - BrokenPipeError

  // 'PyBrokenPipeError' does not any interesting methods to 'PyConnectionError'.
  internal static let brokenPipeError = StaticMethodsForBuiltinTypes.connectionError.copy()

  // MARK: - BufferError

  // 'PyBufferError' does not any interesting methods to 'PyException'.
  internal static let bufferError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - BytesWarning

  // 'PyBytesWarning' does not any interesting methods to 'PyWarning'.
  internal static let bytesWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - ChildProcessError

  // 'PyChildProcessError' does not any interesting methods to 'PyOSError'.
  internal static let childProcessError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - ConnectionAbortedError

  // 'PyConnectionAbortedError' does not any interesting methods to 'PyConnectionError'.
  internal static let connectionAbortedError = StaticMethodsForBuiltinTypes.connectionError.copy()

  // MARK: - ConnectionError

  // 'PyConnectionError' does not any interesting methods to 'PyOSError'.
  internal static let connectionError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - ConnectionRefusedError

  // 'PyConnectionRefusedError' does not any interesting methods to 'PyConnectionError'.
  internal static let connectionRefusedError = StaticMethodsForBuiltinTypes.connectionError.copy()

  // MARK: - ConnectionResetError

  // 'PyConnectionResetError' does not any interesting methods to 'PyConnectionError'.
  internal static let connectionResetError = StaticMethodsForBuiltinTypes.connectionError.copy()

  // MARK: - DeprecationWarning

  // 'PyDeprecationWarning' does not any interesting methods to 'PyWarning'.
  internal static let deprecationWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - EOFError

  // 'PyEOFError' does not any interesting methods to 'PyException'.
  internal static let eOFError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - Exception

  // 'PyException' does not any interesting methods to 'PyBaseException'.
  internal static let exception = StaticMethodsForBuiltinTypes.baseException.copy()

  // MARK: - FileExistsError

  // 'PyFileExistsError' does not any interesting methods to 'PyOSError'.
  internal static let fileExistsError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - FileNotFoundError

  // 'PyFileNotFoundError' does not any interesting methods to 'PyOSError'.
  internal static let fileNotFoundError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - FloatingPointError

  // 'PyFloatingPointError' does not any interesting methods to 'PyArithmeticError'.
  internal static let floatingPointError = StaticMethodsForBuiltinTypes.arithmeticError.copy()

  // MARK: - FutureWarning

  // 'PyFutureWarning' does not any interesting methods to 'PyWarning'.
  internal static let futureWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - GeneratorExit

  // 'PyGeneratorExit' does not any interesting methods to 'PyBaseException'.
  internal static let generatorExit = StaticMethodsForBuiltinTypes.baseException.copy()

  // MARK: - ImportError

  internal static var importError: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.exception.copy()
    result.__str__ = .init(PyImportError.str(importError:))
    return result
  }()

  // MARK: - ImportWarning

  // 'PyImportWarning' does not any interesting methods to 'PyWarning'.
  internal static let importWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - IndentationError

  // 'PyIndentationError' does not any interesting methods to 'PySyntaxError'.
  internal static let indentationError = StaticMethodsForBuiltinTypes.syntaxError.copy()

  // MARK: - IndexError

  // 'PyIndexError' does not any interesting methods to 'PyLookupError'.
  internal static let indexError = StaticMethodsForBuiltinTypes.lookupError.copy()

  // MARK: - InterruptedError

  // 'PyInterruptedError' does not any interesting methods to 'PyOSError'.
  internal static let interruptedError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - IsADirectoryError

  // 'PyIsADirectoryError' does not any interesting methods to 'PyOSError'.
  internal static let isADirectoryError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - KeyError

  internal static var keyError: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.lookupError.copy()
    result.__str__ = .init(PyKeyError.str(keyError:))
    return result
  }()

  // MARK: - KeyboardInterrupt

  // 'PyKeyboardInterrupt' does not any interesting methods to 'PyBaseException'.
  internal static let keyboardInterrupt = StaticMethodsForBuiltinTypes.baseException.copy()

  // MARK: - LookupError

  // 'PyLookupError' does not any interesting methods to 'PyException'.
  internal static let lookupError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - MemoryError

  // 'PyMemoryError' does not any interesting methods to 'PyException'.
  internal static let memoryError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - ModuleNotFoundError

  // 'PyModuleNotFoundError' does not any interesting methods to 'PyImportError'.
  internal static let moduleNotFoundError = StaticMethodsForBuiltinTypes.importError.copy()

  // MARK: - NameError

  // 'PyNameError' does not any interesting methods to 'PyException'.
  internal static let nameError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - NotADirectoryError

  // 'PyNotADirectoryError' does not any interesting methods to 'PyOSError'.
  internal static let notADirectoryError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - NotImplementedError

  // 'PyNotImplementedError' does not any interesting methods to 'PyRuntimeError'.
  internal static let notImplementedError = StaticMethodsForBuiltinTypes.runtimeError.copy()

  // MARK: - OSError

  // 'PyOSError' does not any interesting methods to 'PyException'.
  internal static let oSError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - OverflowError

  // 'PyOverflowError' does not any interesting methods to 'PyArithmeticError'.
  internal static let overflowError = StaticMethodsForBuiltinTypes.arithmeticError.copy()

  // MARK: - PendingDeprecationWarning

  // 'PyPendingDeprecationWarning' does not any interesting methods to 'PyWarning'.
  internal static let pendingDeprecationWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - PermissionError

  // 'PyPermissionError' does not any interesting methods to 'PyOSError'.
  internal static let permissionError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - ProcessLookupError

  // 'PyProcessLookupError' does not any interesting methods to 'PyOSError'.
  internal static let processLookupError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - RecursionError

  // 'PyRecursionError' does not any interesting methods to 'PyRuntimeError'.
  internal static let recursionError = StaticMethodsForBuiltinTypes.runtimeError.copy()

  // MARK: - ReferenceError

  // 'PyReferenceError' does not any interesting methods to 'PyException'.
  internal static let referenceError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - ResourceWarning

  // 'PyResourceWarning' does not any interesting methods to 'PyWarning'.
  internal static let resourceWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - RuntimeError

  // 'PyRuntimeError' does not any interesting methods to 'PyException'.
  internal static let runtimeError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - RuntimeWarning

  // 'PyRuntimeWarning' does not any interesting methods to 'PyWarning'.
  internal static let runtimeWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - StopAsyncIteration

  // 'PyStopAsyncIteration' does not any interesting methods to 'PyException'.
  internal static let stopAsyncIteration = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - StopIteration

  // 'PyStopIteration' does not any interesting methods to 'PyException'.
  internal static let stopIteration = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - SyntaxError

  internal static var syntaxError: PyType.StaticallyKnownNotOverriddenMethods = {
    var result = StaticMethodsForBuiltinTypes.exception.copy()
    result.__str__ = .init(PySyntaxError.str(syntaxError:))
    return result
  }()

  // MARK: - SyntaxWarning

  // 'PySyntaxWarning' does not any interesting methods to 'PyWarning'.
  internal static let syntaxWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - SystemError

  // 'PySystemError' does not any interesting methods to 'PyException'.
  internal static let systemError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - SystemExit

  // 'PySystemExit' does not any interesting methods to 'PyBaseException'.
  internal static let systemExit = StaticMethodsForBuiltinTypes.baseException.copy()

  // MARK: - TabError

  // 'PyTabError' does not any interesting methods to 'PyIndentationError'.
  internal static let tabError = StaticMethodsForBuiltinTypes.indentationError.copy()

  // MARK: - TimeoutError

  // 'PyTimeoutError' does not any interesting methods to 'PyOSError'.
  internal static let timeoutError = StaticMethodsForBuiltinTypes.oSError.copy()

  // MARK: - TypeError

  // 'PyTypeError' does not any interesting methods to 'PyException'.
  internal static let typeError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - UnboundLocalError

  // 'PyUnboundLocalError' does not any interesting methods to 'PyNameError'.
  internal static let unboundLocalError = StaticMethodsForBuiltinTypes.nameError.copy()

  // MARK: - UnicodeDecodeError

  // 'PyUnicodeDecodeError' does not any interesting methods to 'PyUnicodeError'.
  internal static let unicodeDecodeError = StaticMethodsForBuiltinTypes.unicodeError.copy()

  // MARK: - UnicodeEncodeError

  // 'PyUnicodeEncodeError' does not any interesting methods to 'PyUnicodeError'.
  internal static let unicodeEncodeError = StaticMethodsForBuiltinTypes.unicodeError.copy()

  // MARK: - UnicodeError

  // 'PyUnicodeError' does not any interesting methods to 'PyValueError'.
  internal static let unicodeError = StaticMethodsForBuiltinTypes.valueError.copy()

  // MARK: - UnicodeTranslateError

  // 'PyUnicodeTranslateError' does not any interesting methods to 'PyUnicodeError'.
  internal static let unicodeTranslateError = StaticMethodsForBuiltinTypes.unicodeError.copy()

  // MARK: - UnicodeWarning

  // 'PyUnicodeWarning' does not any interesting methods to 'PyWarning'.
  internal static let unicodeWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - UserWarning

  // 'PyUserWarning' does not any interesting methods to 'PyWarning'.
  internal static let userWarning = StaticMethodsForBuiltinTypes.warning.copy()

  // MARK: - ValueError

  // 'PyValueError' does not any interesting methods to 'PyException'.
  internal static let valueError = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - Warning

  // 'PyWarning' does not any interesting methods to 'PyException'.
  internal static let warning = StaticMethodsForBuiltinTypes.exception.copy()

  // MARK: - ZeroDivisionError

  // 'PyZeroDivisionError' does not any interesting methods to 'PyArithmeticError'.
  internal static let zeroDivisionError = StaticMethodsForBuiltinTypes.arithmeticError.copy()

}
