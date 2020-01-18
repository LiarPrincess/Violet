// swiftlint:disable vertical_whitespace
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// Add all of boring stuff to 'PyType'.
///
/// For example it will:
/// - set type flags
/// - add `__doc__`
/// - fill `__dict__`




internal enum FillTypes {


  // MARK: - Base object

  internal static func object(_ type: PyType) {
    type.setFlag(.default)
    type.setFlag(.baseType)

    let dict = type.getDict()

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyBaseObject.isEqual(zelf:other:))
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyBaseObject.isNotEqual(zelf:other:))
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyBaseObject.isLess(zelf:other:))
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyBaseObject.isLessEqual(zelf:other:))
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyBaseObject.isGreater(zelf:other:))
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyBaseObject.isGreaterEqual(zelf:other:))
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyBaseObject.hash(zelf:))
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBaseObject.repr(zelf:))
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBaseObject.str(zelf:))
    dict["__format__"] = PyBuiltinFunction.wrap(name: "__format__", doc: nil, fn: PyBaseObject.format(zelf:spec:))
    dict["__class__"] = PyBuiltinFunction.wrap(name: "__class__", doc: nil, fn: PyBaseObject.getClass(zelf:))
    dict["__dir__"] = PyBuiltinFunction.wrap(name: "__dir__", doc: nil, fn: PyBaseObject.dir(zelf:))
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBaseObject.getAttribute(zelf:name:))
    dict["__setattr__"] = PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyBaseObject.setAttribute(zelf:name:value:))
    dict["__delattr__"] = PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyBaseObject.delAttribute(zelf:name:))
    dict["__subclasshook__"] = PyBuiltinFunction.wrap(name: "__subclasshook__", doc: nil, fn: PyBaseObject.subclasshook(zelf:))
    dict["__init_subclass__"] = PyBuiltinFunction.wrap(name: "__init_subclass__", doc: nil, fn: PyBaseObject.initSubclass(zelf:))
    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBaseObject.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyBaseObject.pyInit(zelf:args:kwargs:))


  }


  // MARK: - Type type

  internal static func type(_ type: PyType) {
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)
    type.setFlag(.typeSubclass)

    let dict = type.getDict()
    dict["__name__"] = PyProperty.wrap(name: "__name__", doc: nil, get: PyType.getName, set: PyType.setName, castSelf: Cast.asPyType)
    dict["__qualname__"] = PyProperty.wrap(name: "__qualname__", doc: nil, get: PyType.getQualname, set: PyType.setQualname, castSelf: Cast.asPyType)
    dict["__doc__"] = PyProperty.wrap(name: "__doc__", doc: nil, get: PyType.getDoc, set: PyType.setDoc, castSelf: Cast.asPyType)
    dict["__module__"] = PyProperty.wrap(name: "__module__", doc: nil, get: PyType.getModule, set: PyType.setModule, castSelf: Cast.asPyType)
    dict["__bases__"] = PyProperty.wrap(name: "__bases__", doc: nil, get: PyType.getBases, set: PyType.setBases, castSelf: Cast.asPyType)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyType.getDict, castSelf: Cast.asPyType)
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyType.getClass, castSelf: Cast.asPyType)
    dict["__base__"] = PyProperty.wrap(name: "__base__", doc: nil, get: PyType.getBase, castSelf: Cast.asPyType)
    dict["__mro__"] = PyProperty.wrap(name: "__mro__", doc: nil, get: PyType.getMRO, castSelf: Cast.asPyType)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyType.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyType.pyInit(zelf:args:kwargs:))


    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyType.repr, castSelf: Cast.asPyType)
    dict["__subclasscheck__"] = PyBuiltinFunction.wrap(name: "__subclasscheck__", doc: nil, fn: PyType.isSubtype(of:), castSelf: Cast.asPyType)
    dict["__instancecheck__"] = PyBuiltinFunction.wrap(name: "__instancecheck__", doc: nil, fn: PyType.isType(of:), castSelf: Cast.asPyType)
    dict["__subclasses__"] = PyBuiltinFunction.wrap(name: "__subclasses__", doc: nil, fn: PyType.getSubclasses, castSelf: Cast.asPyType)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyType.getAttribute(name:), castSelf: Cast.asPyType)
    dict["__setattr__"] = PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyType.setAttribute(name:value:), castSelf: Cast.asPyType)
    dict["__delattr__"] = PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyType.delAttribute(name:), castSelf: Cast.asPyType)
    dict["__dir__"] = PyBuiltinFunction.wrap(name: "__dir__", doc: nil, fn: PyType.dir, castSelf: Cast.asPyType)
    dict["__call__"] = PyBuiltinFunction.wrap(name: "__call__", doc: nil, fn: PyType.call(args:kwargs:), castSelf: Cast.asPyType)
  }


  // MARK: - Bool

  internal static func bool(_ type: PyType) {
    type.setBuiltinTypeDoc(PyBool.doc)
    type.setFlag(.default)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBool.getClass, castSelf: Cast.asPyBool)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBool.pyNew(type:args:kwargs:))

    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBool.repr, castSelf: Cast.asPyBool)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBool.str, castSelf: Cast.asPyBool)
    dict["__and__"] = PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PyBool.and(_:), castSelf: Cast.asPyBool)
    dict["__rand__"] = PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PyBool.rand(_:), castSelf: Cast.asPyBool)
    dict["__or__"] = PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PyBool.or(_:), castSelf: Cast.asPyBool)
    dict["__ror__"] = PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PyBool.ror(_:), castSelf: Cast.asPyBool)
    dict["__xor__"] = PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PyBool.xor(_:), castSelf: Cast.asPyBool)
    dict["__rxor__"] = PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PyBool.rxor(_:), castSelf: Cast.asPyBool)
  }

  // MARK: - BuiltinFunction

  internal static func builtinFunction(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBuiltinFunction.getClass, castSelf: Cast.asPyBuiltinFunction)
    dict["__name__"] = PyProperty.wrap(name: "__name__", doc: nil, get: PyBuiltinFunction.getName, castSelf: Cast.asPyBuiltinFunction)
    dict["__qualname__"] = PyProperty.wrap(name: "__qualname__", doc: nil, get: PyBuiltinFunction.getQualname, castSelf: Cast.asPyBuiltinFunction)
    dict["__text_signature__"] = PyProperty.wrap(name: "__text_signature__", doc: nil, get: PyBuiltinFunction.getTextSignature, castSelf: Cast.asPyBuiltinFunction)
    dict["__module__"] = PyProperty.wrap(name: "__module__", doc: nil, get: PyBuiltinFunction.getModule, castSelf: Cast.asPyBuiltinFunction)
    dict["__self__"] = PyProperty.wrap(name: "__self__", doc: nil, get: PyBuiltinFunction.getSelf, castSelf: Cast.asPyBuiltinFunction)



    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyBuiltinFunction.isEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyBuiltinFunction.isNotEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyBuiltinFunction.isLess(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyBuiltinFunction.isLessEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyBuiltinFunction.isGreater(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyBuiltinFunction.isGreaterEqual(_:), castSelf: Cast.asPyBuiltinFunction)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyBuiltinFunction.hash, castSelf: Cast.asPyBuiltinFunction)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBuiltinFunction.repr, castSelf: Cast.asPyBuiltinFunction)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBuiltinFunction.getAttribute(name:), castSelf: Cast.asPyBuiltinFunction)
    dict["__call__"] = PyBuiltinFunction.wrap(name: "__call__", doc: nil, fn: PyBuiltinFunction.call(args:kwargs:), castSelf: Cast.asPyBuiltinFunction)
  }

  // MARK: - ByteArray

  internal static func bytearray(_ type: PyType) {
    type.setBuiltinTypeDoc(PyByteArray.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyByteArray.getClass, castSelf: Cast.asPyByteArray)

    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyByteArray.pyInit(zelf:args:kwargs:))

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyByteArray.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyByteArray.isEqual(_:), castSelf: Cast.asPyByteArray)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyByteArray.isNotEqual(_:), castSelf: Cast.asPyByteArray)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyByteArray.isLess(_:), castSelf: Cast.asPyByteArray)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyByteArray.isLessEqual(_:), castSelf: Cast.asPyByteArray)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyByteArray.isGreater(_:), castSelf: Cast.asPyByteArray)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyByteArray.isGreaterEqual(_:), castSelf: Cast.asPyByteArray)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyByteArray.hash, castSelf: Cast.asPyByteArray)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyByteArray.repr, castSelf: Cast.asPyByteArray)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyByteArray.str, castSelf: Cast.asPyByteArray)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyByteArray.getAttribute(name:), castSelf: Cast.asPyByteArray)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyByteArray.getLength, castSelf: Cast.asPyByteArray)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyByteArray.contains(_:), castSelf: Cast.asPyByteArray)
    dict["__getitem__"] = PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyByteArray.getItem(at:), castSelf: Cast.asPyByteArray)
    dict["isalnum"] = PyBuiltinFunction.wrap(name: "isalnum", doc: nil, fn: PyByteArray.isAlphaNumeric, castSelf: Cast.asPyByteArray)
    dict["isalpha"] = PyBuiltinFunction.wrap(name: "isalpha", doc: nil, fn: PyByteArray.isAlpha, castSelf: Cast.asPyByteArray)
    dict["isascii"] = PyBuiltinFunction.wrap(name: "isascii", doc: nil, fn: PyByteArray.isAscii, castSelf: Cast.asPyByteArray)
    dict["isdigit"] = PyBuiltinFunction.wrap(name: "isdigit", doc: nil, fn: PyByteArray.isDigit, castSelf: Cast.asPyByteArray)
    dict["islower"] = PyBuiltinFunction.wrap(name: "islower", doc: nil, fn: PyByteArray.isLower, castSelf: Cast.asPyByteArray)
    dict["isspace"] = PyBuiltinFunction.wrap(name: "isspace", doc: nil, fn: PyByteArray.isSpace, castSelf: Cast.asPyByteArray)
    dict["istitle"] = PyBuiltinFunction.wrap(name: "istitle", doc: nil, fn: PyByteArray.isTitle, castSelf: Cast.asPyByteArray)
    dict["isupper"] = PyBuiltinFunction.wrap(name: "isupper", doc: nil, fn: PyByteArray.isUpper, castSelf: Cast.asPyByteArray)
    dict["startswith"] = PyBuiltinFunction.wrap(name: "startswith", doc: nil, fn: PyByteArray.startsWith(_:start:end:), castSelf: Cast.asPyByteArray)
    dict["endswith"] = PyBuiltinFunction.wrap(name: "endswith", doc: nil, fn: PyByteArray.endsWith(_:start:end:), castSelf: Cast.asPyByteArray)
    dict["strip"] = PyBuiltinFunction.wrap(name: "strip", doc: nil, fn: PyByteArray.strip(_:), castSelf: Cast.asPyByteArray)
    dict["lstrip"] = PyBuiltinFunction.wrap(name: "lstrip", doc: nil, fn: PyByteArray.lstrip(_:), castSelf: Cast.asPyByteArray)
    dict["rstrip"] = PyBuiltinFunction.wrap(name: "rstrip", doc: nil, fn: PyByteArray.rstrip(_:), castSelf: Cast.asPyByteArray)
    dict["find"] = PyBuiltinFunction.wrap(name: "find", doc: nil, fn: PyByteArray.find(_:start:end:), castSelf: Cast.asPyByteArray)
    dict["rfind"] = PyBuiltinFunction.wrap(name: "rfind", doc: nil, fn: PyByteArray.rfind(_:start:end:), castSelf: Cast.asPyByteArray)
    dict["index"] = PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyByteArray.index(of:start:end:), castSelf: Cast.asPyByteArray)
    dict["rindex"] = PyBuiltinFunction.wrap(name: "rindex", doc: nil, fn: PyByteArray.rindex(_:start:end:), castSelf: Cast.asPyByteArray)
    dict["lower"] = PyBuiltinFunction.wrap(name: "lower", doc: nil, fn: PyByteArray.lower, castSelf: Cast.asPyByteArray)
    dict["upper"] = PyBuiltinFunction.wrap(name: "upper", doc: nil, fn: PyByteArray.upper, castSelf: Cast.asPyByteArray)
    dict["title"] = PyBuiltinFunction.wrap(name: "title", doc: nil, fn: PyByteArray.title, castSelf: Cast.asPyByteArray)
    dict["swapcase"] = PyBuiltinFunction.wrap(name: "swapcase", doc: nil, fn: PyByteArray.swapcase, castSelf: Cast.asPyByteArray)
    dict["capitalize"] = PyBuiltinFunction.wrap(name: "capitalize", doc: nil, fn: PyByteArray.capitalize, castSelf: Cast.asPyByteArray)
    dict["center"] = PyBuiltinFunction.wrap(name: "center", doc: nil, fn: PyByteArray.center(width:fillChar:), castSelf: Cast.asPyByteArray)
    dict["ljust"] = PyBuiltinFunction.wrap(name: "ljust", doc: nil, fn: PyByteArray.ljust(width:fillChar:), castSelf: Cast.asPyByteArray)
    dict["rjust"] = PyBuiltinFunction.wrap(name: "rjust", doc: nil, fn: PyByteArray.rjust(width:fillChar:), castSelf: Cast.asPyByteArray)
    dict["split"] = PyBuiltinFunction.wrap(name: "split", doc: nil, fn: PyByteArray.split(separator:maxCount:), castSelf: Cast.asPyByteArray)
    dict["rsplit"] = PyBuiltinFunction.wrap(name: "rsplit", doc: nil, fn: PyByteArray.rsplit(separator:maxCount:), castSelf: Cast.asPyByteArray)
    dict["splitlines"] = PyBuiltinFunction.wrap(name: "splitlines", doc: nil, fn: PyByteArray.splitLines(keepEnds:), castSelf: Cast.asPyByteArray)
    dict["partition"] = PyBuiltinFunction.wrap(name: "partition", doc: nil, fn: PyByteArray.partition(separator:), castSelf: Cast.asPyByteArray)
    dict["rpartition"] = PyBuiltinFunction.wrap(name: "rpartition", doc: nil, fn: PyByteArray.rpartition(separator:), castSelf: Cast.asPyByteArray)
    dict["expandtabs"] = PyBuiltinFunction.wrap(name: "expandtabs", doc: nil, fn: PyByteArray.expandTabs(tabSize:), castSelf: Cast.asPyByteArray)
    dict["count"] = PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyByteArray.count(_:start:end:), castSelf: Cast.asPyByteArray)
    dict["join"] = PyBuiltinFunction.wrap(name: "join", doc: nil, fn: PyByteArray.join(iterable:), castSelf: Cast.asPyByteArray)
    dict["replace"] = PyBuiltinFunction.wrap(name: "replace", doc: nil, fn: PyByteArray.replace(old:new:count:), castSelf: Cast.asPyByteArray)
    dict["zfill"] = PyBuiltinFunction.wrap(name: "zfill", doc: nil, fn: PyByteArray.zfill(width:), castSelf: Cast.asPyByteArray)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyByteArray.add(_:), castSelf: Cast.asPyByteArray)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyByteArray.mul(_:), castSelf: Cast.asPyByteArray)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyByteArray.rmul(_:), castSelf: Cast.asPyByteArray)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyByteArray.iter, castSelf: Cast.asPyByteArray)
    dict["append"] = PyBuiltinFunction.wrap(name: "append", doc: nil, fn: PyByteArray.append(_:), castSelf: Cast.asPyByteArray)
    dict["extend"] = PyBuiltinFunction.wrap(name: "extend", doc: nil, fn: PyByteArray.extend(iterable:), castSelf: Cast.asPyByteArray)
    dict["insert"] = PyBuiltinFunction.wrap(name: "insert", doc: nil, fn: PyByteArray.insert(at:item:), castSelf: Cast.asPyByteArray)
    dict["remove"] = PyBuiltinFunction.wrap(name: "remove", doc: nil, fn: PyByteArray.remove(_:), castSelf: Cast.asPyByteArray)
    dict["pop"] = PyBuiltinFunction.wrap(name: "pop", doc: nil, fn: PyByteArray.pop(index:), castSelf: Cast.asPyByteArray)
    dict["__setitem__"] = PyBuiltinFunction.wrap(name: "__setitem__", doc: nil, fn: PyByteArray.setItem(at:to:), castSelf: Cast.asPyByteArray)
    dict["__delitem__"] = PyBuiltinFunction.wrap(name: "__delitem__", doc: nil, fn: PyByteArray.delItem(at:), castSelf: Cast.asPyByteArray)
    dict["clear"] = PyBuiltinFunction.wrap(name: "clear", doc: nil, fn: PyByteArray.clear, castSelf: Cast.asPyByteArray)
    dict["reverse"] = PyBuiltinFunction.wrap(name: "reverse", doc: nil, fn: PyByteArray.reverse, castSelf: Cast.asPyByteArray)
    dict["copy"] = PyBuiltinFunction.wrap(name: "copy", doc: nil, fn: PyByteArray.copy, castSelf: Cast.asPyByteArray)
  }

  // MARK: - ByteArrayIterator

  internal static func bytearray_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyByteArrayIterator.getClass, castSelf: Cast.asPyByteArrayIterator)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyByteArrayIterator.pyNew(type:args:kwargs:))

    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyByteArrayIterator.getAttribute(name:), castSelf: Cast.asPyByteArrayIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyByteArrayIterator.iter, castSelf: Cast.asPyByteArrayIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyByteArrayIterator.next, castSelf: Cast.asPyByteArrayIterator)
  }

  // MARK: - Bytes

  internal static func bytes(_ type: PyType) {
    type.setBuiltinTypeDoc(PyBytes.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.bytesSubclass)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBytes.getClass, castSelf: Cast.asPyBytes)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBytes.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyBytes.isEqual(_:), castSelf: Cast.asPyBytes)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyBytes.isNotEqual(_:), castSelf: Cast.asPyBytes)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyBytes.isLess(_:), castSelf: Cast.asPyBytes)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyBytes.isLessEqual(_:), castSelf: Cast.asPyBytes)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyBytes.isGreater(_:), castSelf: Cast.asPyBytes)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyBytes.isGreaterEqual(_:), castSelf: Cast.asPyBytes)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyBytes.hash, castSelf: Cast.asPyBytes)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBytes.repr, castSelf: Cast.asPyBytes)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBytes.str, castSelf: Cast.asPyBytes)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBytes.getAttribute(name:), castSelf: Cast.asPyBytes)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyBytes.getLength, castSelf: Cast.asPyBytes)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyBytes.contains(_:), castSelf: Cast.asPyBytes)
    dict["__getitem__"] = PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyBytes.getItem(at:), castSelf: Cast.asPyBytes)
    dict["isalnum"] = PyBuiltinFunction.wrap(name: "isalnum", doc: nil, fn: PyBytes.isAlphaNumeric, castSelf: Cast.asPyBytes)
    dict["isalpha"] = PyBuiltinFunction.wrap(name: "isalpha", doc: nil, fn: PyBytes.isAlpha, castSelf: Cast.asPyBytes)
    dict["isascii"] = PyBuiltinFunction.wrap(name: "isascii", doc: nil, fn: PyBytes.isAscii, castSelf: Cast.asPyBytes)
    dict["isdigit"] = PyBuiltinFunction.wrap(name: "isdigit", doc: nil, fn: PyBytes.isDigit, castSelf: Cast.asPyBytes)
    dict["islower"] = PyBuiltinFunction.wrap(name: "islower", doc: nil, fn: PyBytes.isLower, castSelf: Cast.asPyBytes)
    dict["isspace"] = PyBuiltinFunction.wrap(name: "isspace", doc: nil, fn: PyBytes.isSpace, castSelf: Cast.asPyBytes)
    dict["istitle"] = PyBuiltinFunction.wrap(name: "istitle", doc: nil, fn: PyBytes.isTitle, castSelf: Cast.asPyBytes)
    dict["isupper"] = PyBuiltinFunction.wrap(name: "isupper", doc: nil, fn: PyBytes.isUpper, castSelf: Cast.asPyBytes)
    dict["startswith"] = PyBuiltinFunction.wrap(name: "startswith", doc: nil, fn: PyBytes.startsWith(_:start:end:), castSelf: Cast.asPyBytes)
    dict["endswith"] = PyBuiltinFunction.wrap(name: "endswith", doc: nil, fn: PyBytes.endsWith(_:start:end:), castSelf: Cast.asPyBytes)
    dict["strip"] = PyBuiltinFunction.wrap(name: "strip", doc: nil, fn: PyBytes.strip(_:), castSelf: Cast.asPyBytes)
    dict["lstrip"] = PyBuiltinFunction.wrap(name: "lstrip", doc: nil, fn: PyBytes.lstrip(_:), castSelf: Cast.asPyBytes)
    dict["rstrip"] = PyBuiltinFunction.wrap(name: "rstrip", doc: nil, fn: PyBytes.rstrip(_:), castSelf: Cast.asPyBytes)
    dict["find"] = PyBuiltinFunction.wrap(name: "find", doc: nil, fn: PyBytes.find(_:start:end:), castSelf: Cast.asPyBytes)
    dict["rfind"] = PyBuiltinFunction.wrap(name: "rfind", doc: nil, fn: PyBytes.rfind(_:start:end:), castSelf: Cast.asPyBytes)
    dict["index"] = PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyBytes.index(of:start:end:), castSelf: Cast.asPyBytes)
    dict["rindex"] = PyBuiltinFunction.wrap(name: "rindex", doc: nil, fn: PyBytes.rindex(_:start:end:), castSelf: Cast.asPyBytes)
    dict["lower"] = PyBuiltinFunction.wrap(name: "lower", doc: nil, fn: PyBytes.lower, castSelf: Cast.asPyBytes)
    dict["upper"] = PyBuiltinFunction.wrap(name: "upper", doc: nil, fn: PyBytes.upper, castSelf: Cast.asPyBytes)
    dict["title"] = PyBuiltinFunction.wrap(name: "title", doc: nil, fn: PyBytes.title, castSelf: Cast.asPyBytes)
    dict["swapcase"] = PyBuiltinFunction.wrap(name: "swapcase", doc: nil, fn: PyBytes.swapcase, castSelf: Cast.asPyBytes)
    dict["capitalize"] = PyBuiltinFunction.wrap(name: "capitalize", doc: nil, fn: PyBytes.capitalize, castSelf: Cast.asPyBytes)
    dict["center"] = PyBuiltinFunction.wrap(name: "center", doc: nil, fn: PyBytes.center(width:fillChar:), castSelf: Cast.asPyBytes)
    dict["ljust"] = PyBuiltinFunction.wrap(name: "ljust", doc: nil, fn: PyBytes.ljust(width:fillChar:), castSelf: Cast.asPyBytes)
    dict["rjust"] = PyBuiltinFunction.wrap(name: "rjust", doc: nil, fn: PyBytes.rjust(width:fillChar:), castSelf: Cast.asPyBytes)
    dict["split"] = PyBuiltinFunction.wrap(name: "split", doc: nil, fn: PyBytes.split(separator:maxCount:), castSelf: Cast.asPyBytes)
    dict["rsplit"] = PyBuiltinFunction.wrap(name: "rsplit", doc: nil, fn: PyBytes.rsplit(separator:maxCount:), castSelf: Cast.asPyBytes)
    dict["splitlines"] = PyBuiltinFunction.wrap(name: "splitlines", doc: nil, fn: PyBytes.splitLines(keepEnds:), castSelf: Cast.asPyBytes)
    dict["partition"] = PyBuiltinFunction.wrap(name: "partition", doc: nil, fn: PyBytes.partition(separator:), castSelf: Cast.asPyBytes)
    dict["rpartition"] = PyBuiltinFunction.wrap(name: "rpartition", doc: nil, fn: PyBytes.rpartition(separator:), castSelf: Cast.asPyBytes)
    dict["expandtabs"] = PyBuiltinFunction.wrap(name: "expandtabs", doc: nil, fn: PyBytes.expandTabs(tabSize:), castSelf: Cast.asPyBytes)
    dict["count"] = PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyBytes.count(_:start:end:), castSelf: Cast.asPyBytes)
    dict["join"] = PyBuiltinFunction.wrap(name: "join", doc: nil, fn: PyBytes.join(iterable:), castSelf: Cast.asPyBytes)
    dict["replace"] = PyBuiltinFunction.wrap(name: "replace", doc: nil, fn: PyBytes.replace(old:new:count:), castSelf: Cast.asPyBytes)
    dict["zfill"] = PyBuiltinFunction.wrap(name: "zfill", doc: nil, fn: PyBytes.zfill(width:), castSelf: Cast.asPyBytes)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyBytes.add(_:), castSelf: Cast.asPyBytes)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyBytes.mul(_:), castSelf: Cast.asPyBytes)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyBytes.rmul(_:), castSelf: Cast.asPyBytes)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyBytes.iter, castSelf: Cast.asPyBytes)
  }

  // MARK: - BytesIterator

  internal static func bytes_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBytesIterator.getClass, castSelf: Cast.asPyBytesIterator)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBytesIterator.pyNew(type:args:kwargs:))

    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBytesIterator.getAttribute(name:), castSelf: Cast.asPyBytesIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyBytesIterator.iter, castSelf: Cast.asPyBytesIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyBytesIterator.next, castSelf: Cast.asPyBytesIterator)
  }

  // MARK: - CallableIterator

  internal static func callable_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyCallableIterator.getClass, castSelf: Cast.asPyCallableIterator)



    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyCallableIterator.getAttribute(name:), castSelf: Cast.asPyCallableIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyCallableIterator.iter, castSelf: Cast.asPyCallableIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyCallableIterator.next, castSelf: Cast.asPyCallableIterator)
  }

  // MARK: - Code

  internal static func code(_ type: PyType) {
    type.setBuiltinTypeDoc(PyCode.doc)
    type.setFlag(.default)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyCode.getClass, castSelf: Cast.asPyCode)



    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyCode.isEqual(_:), castSelf: Cast.asPyCode)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyCode.isLess(_:), castSelf: Cast.asPyCode)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyCode.isLessEqual(_:), castSelf: Cast.asPyCode)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyCode.isGreater(_:), castSelf: Cast.asPyCode)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyCode.isGreaterEqual(_:), castSelf: Cast.asPyCode)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyCode.hash, castSelf: Cast.asPyCode)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyCode.repr, castSelf: Cast.asPyCode)
  }

  // MARK: - Complex

  internal static func complex(_ type: PyType) {
    type.setBuiltinTypeDoc(PyComplex.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyComplex.getClass, castSelf: Cast.asPyComplex)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyComplex.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyComplex.isEqual(_:), castSelf: Cast.asPyComplex)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyComplex.isNotEqual(_:), castSelf: Cast.asPyComplex)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyComplex.isLess(_:), castSelf: Cast.asPyComplex)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyComplex.isLessEqual(_:), castSelf: Cast.asPyComplex)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyComplex.isGreater(_:), castSelf: Cast.asPyComplex)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyComplex.isGreaterEqual(_:), castSelf: Cast.asPyComplex)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyComplex.hash, castSelf: Cast.asPyComplex)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyComplex.repr, castSelf: Cast.asPyComplex)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyComplex.str, castSelf: Cast.asPyComplex)
    dict["__bool__"] = PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyComplex.asBool, castSelf: Cast.asPyComplex)
    dict["__int__"] = PyBuiltinFunction.wrap(name: "__int__", doc: nil, fn: PyComplex.asInt, castSelf: Cast.asPyComplex)
    dict["__float__"] = PyBuiltinFunction.wrap(name: "__float__", doc: nil, fn: PyComplex.asFloat, castSelf: Cast.asPyComplex)
    dict["real"] = PyBuiltinFunction.wrap(name: "real", doc: nil, fn: PyComplex.asReal, castSelf: Cast.asPyComplex)
    dict["imag"] = PyBuiltinFunction.wrap(name: "imag", doc: nil, fn: PyComplex.asImag, castSelf: Cast.asPyComplex)
    dict["conjugate"] = PyBuiltinFunction.wrap(name: "conjugate", doc: nil, fn: PyComplex.conjugate, castSelf: Cast.asPyComplex)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyComplex.getAttribute(name:), castSelf: Cast.asPyComplex)
    dict["__pos__"] = PyBuiltinFunction.wrap(name: "__pos__", doc: nil, fn: PyComplex.positive, castSelf: Cast.asPyComplex)
    dict["__neg__"] = PyBuiltinFunction.wrap(name: "__neg__", doc: nil, fn: PyComplex.negative, castSelf: Cast.asPyComplex)
    dict["__abs__"] = PyBuiltinFunction.wrap(name: "__abs__", doc: nil, fn: PyComplex.abs, castSelf: Cast.asPyComplex)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyComplex.add(_:), castSelf: Cast.asPyComplex)
    dict["__radd__"] = PyBuiltinFunction.wrap(name: "__radd__", doc: nil, fn: PyComplex.radd(_:), castSelf: Cast.asPyComplex)
    dict["__sub__"] = PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyComplex.sub(_:), castSelf: Cast.asPyComplex)
    dict["__rsub__"] = PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyComplex.rsub(_:), castSelf: Cast.asPyComplex)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyComplex.mul(_:), castSelf: Cast.asPyComplex)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyComplex.rmul(_:), castSelf: Cast.asPyComplex)
    dict["__pow__"] = PyBuiltinFunction.wrap(name: "__pow__", doc: nil, fn: PyComplex.pow(exp:mod:), castSelf: Cast.asPyComplex)
    dict["__rpow__"] = PyBuiltinFunction.wrap(name: "__rpow__", doc: nil, fn: PyComplex.rpow(base:mod:), castSelf: Cast.asPyComplex)
    dict["__truediv__"] = PyBuiltinFunction.wrap(name: "__truediv__", doc: nil, fn: PyComplex.truediv(_:), castSelf: Cast.asPyComplex)
    dict["__rtruediv__"] = PyBuiltinFunction.wrap(name: "__rtruediv__", doc: nil, fn: PyComplex.rtruediv(_:), castSelf: Cast.asPyComplex)
    dict["__floordiv__"] = PyBuiltinFunction.wrap(name: "__floordiv__", doc: nil, fn: PyComplex.floordiv(_:), castSelf: Cast.asPyComplex)
    dict["__rfloordiv__"] = PyBuiltinFunction.wrap(name: "__rfloordiv__", doc: nil, fn: PyComplex.rfloordiv(_:), castSelf: Cast.asPyComplex)
    dict["__mod__"] = PyBuiltinFunction.wrap(name: "__mod__", doc: nil, fn: PyComplex.mod(_:), castSelf: Cast.asPyComplex)
    dict["__rmod__"] = PyBuiltinFunction.wrap(name: "__rmod__", doc: nil, fn: PyComplex.rmod(_:), castSelf: Cast.asPyComplex)
    dict["__divmod__"] = PyBuiltinFunction.wrap(name: "__divmod__", doc: nil, fn: PyComplex.divmod(_:), castSelf: Cast.asPyComplex)
    dict["__rdivmod__"] = PyBuiltinFunction.wrap(name: "__rdivmod__", doc: nil, fn: PyComplex.rdivmod(_:), castSelf: Cast.asPyComplex)
  }

  // MARK: - Dict

  internal static func dict(_ type: PyType) {
    type.setBuiltinTypeDoc(PyDict.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)
    type.setFlag(.dictSubclass)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyDict.getClass, castSelf: Cast.asPyDict)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyDict.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyDict.pyInit(zelf:args:kwargs:))


    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyDict.isEqual(_:), castSelf: Cast.asPyDict)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyDict.isNotEqual(_:), castSelf: Cast.asPyDict)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyDict.isLess(_:), castSelf: Cast.asPyDict)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyDict.isLessEqual(_:), castSelf: Cast.asPyDict)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyDict.isGreater(_:), castSelf: Cast.asPyDict)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyDict.isGreaterEqual(_:), castSelf: Cast.asPyDict)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyDict.hash, castSelf: Cast.asPyDict)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDict.repr, castSelf: Cast.asPyDict)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDict.getAttribute(name:), castSelf: Cast.asPyDict)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDict.getLength, castSelf: Cast.asPyDict)
    dict["__getitem__"] = PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyDict.getItem(at:), castSelf: Cast.asPyDict)
    dict["__setitem__"] = PyBuiltinFunction.wrap(name: "__setitem__", doc: nil, fn: PyDict.setItem(at:to:), castSelf: Cast.asPyDict)
    dict["__delitem__"] = PyBuiltinFunction.wrap(name: "__delitem__", doc: nil, fn: PyDict.delItem(at:), castSelf: Cast.asPyDict)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyDict.contains(_:), castSelf: Cast.asPyDict)
    dict["clear"] = PyBuiltinFunction.wrap(name: "clear", doc: nil, fn: PyDict.clear, castSelf: Cast.asPyDict)
    dict["get"] = PyBuiltinFunction.wrap(name: "get", doc: nil, fn: PyDict.get(_:default:), castSelf: Cast.asPyDict)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDict.iter, castSelf: Cast.asPyDict)
    dict["setdefault"] = PyBuiltinFunction.wrap(name: "setdefault", doc: nil, fn: PyDict.setDefault(_:default:), castSelf: Cast.asPyDict)
    dict["update"] = PyBuiltinFunction.wrap(name: "update", doc: nil, fn: PyDict.update(args:kwargs:), castSelf: Cast.asPyDict)
    dict["copy"] = PyBuiltinFunction.wrap(name: "copy", doc: nil, fn: PyDict.copy, castSelf: Cast.asPyDict)
    dict["pop"] = PyBuiltinFunction.wrap(name: "pop", doc: nil, fn: PyDict.pop(_:default:), castSelf: Cast.asPyDict)
    dict["popitem"] = PyBuiltinFunction.wrap(name: "popitem", doc: nil, fn: PyDict.popitem, castSelf: Cast.asPyDict)
    dict["keys"] = PyBuiltinFunction.wrap(name: "keys", doc: nil, fn: PyDict.keys, castSelf: Cast.asPyDict)
    dict["items"] = PyBuiltinFunction.wrap(name: "items", doc: nil, fn: PyDict.items, castSelf: Cast.asPyDict)
    dict["values"] = PyBuiltinFunction.wrap(name: "values", doc: nil, fn: PyDict.values, castSelf: Cast.asPyDict)
  }

  // MARK: - DictItemIterator

  internal static func dict_itemiterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyDictItemIterator.getClass, castSelf: Cast.asPyDictItemIterator)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyDictItemIterator.pyNew(type:args:kwargs:))

    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictItemIterator.getAttribute(name:), castSelf: Cast.asPyDictItemIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictItemIterator.iter, castSelf: Cast.asPyDictItemIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyDictItemIterator.next, castSelf: Cast.asPyDictItemIterator)
  }

  // MARK: - DictItems

  internal static func dict_items(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyDictItems.getClass, castSelf: Cast.asPyDictItems)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyDictItems.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyDictItems.isEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyDictItems.isNotEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyDictItems.isLess(_:), castSelf: Cast.asPyDictItems)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyDictItems.isLessEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyDictItems.isGreater(_:), castSelf: Cast.asPyDictItems)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyDictItems.isGreaterEqual(_:), castSelf: Cast.asPyDictItems)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyDictItems.hash, castSelf: Cast.asPyDictItems)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDictItems.repr, castSelf: Cast.asPyDictItems)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictItems.getAttribute(name:), castSelf: Cast.asPyDictItems)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDictItems.getLength, castSelf: Cast.asPyDictItems)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyDictItems.contains(_:), castSelf: Cast.asPyDictItems)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictItems.iter, castSelf: Cast.asPyDictItems)
  }

  // MARK: - DictKeyIterator

  internal static func dict_keyiterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyDictKeyIterator.getClass, castSelf: Cast.asPyDictKeyIterator)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyDictKeyIterator.pyNew(type:args:kwargs:))

    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictKeyIterator.getAttribute(name:), castSelf: Cast.asPyDictKeyIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictKeyIterator.iter, castSelf: Cast.asPyDictKeyIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyDictKeyIterator.next, castSelf: Cast.asPyDictKeyIterator)
  }

  // MARK: - DictKeys

  internal static func dict_keys(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyDictKeys.getClass, castSelf: Cast.asPyDictKeys)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyDictKeys.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyDictKeys.isEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyDictKeys.isNotEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyDictKeys.isLess(_:), castSelf: Cast.asPyDictKeys)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyDictKeys.isLessEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyDictKeys.isGreater(_:), castSelf: Cast.asPyDictKeys)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyDictKeys.isGreaterEqual(_:), castSelf: Cast.asPyDictKeys)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyDictKeys.hash, castSelf: Cast.asPyDictKeys)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDictKeys.repr, castSelf: Cast.asPyDictKeys)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictKeys.getAttribute(name:), castSelf: Cast.asPyDictKeys)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDictKeys.getLength, castSelf: Cast.asPyDictKeys)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyDictKeys.contains(_:), castSelf: Cast.asPyDictKeys)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictKeys.iter, castSelf: Cast.asPyDictKeys)
  }

  // MARK: - DictValueIterator

  internal static func dict_valueiterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyDictValueIterator.getClass, castSelf: Cast.asPyDictValueIterator)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyDictValueIterator.pyNew(type:args:kwargs:))

    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictValueIterator.getAttribute(name:), castSelf: Cast.asPyDictValueIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictValueIterator.iter, castSelf: Cast.asPyDictValueIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyDictValueIterator.next, castSelf: Cast.asPyDictValueIterator)
  }

  // MARK: - DictValues

  internal static func dict_values(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()



    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDictValues.repr, castSelf: Cast.asPyDictValues)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictValues.getAttribute(name:), castSelf: Cast.asPyDictValues)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDictValues.getLength, castSelf: Cast.asPyDictValues)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictValues.iter, castSelf: Cast.asPyDictValues)
  }

  // MARK: - Ellipsis

  internal static func ellipsis(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyEllipsis.getClass, castSelf: Cast.asPyEllipsis)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyEllipsis.pyNew(type:args:kwargs:))


    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyEllipsis.repr, castSelf: Cast.asPyEllipsis)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyEllipsis.getAttribute(name:), castSelf: Cast.asPyEllipsis)
  }

  // MARK: - Enumerate

  internal static func enumerate(_ type: PyType) {
    type.setBuiltinTypeDoc(PyEnumerate.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyEnumerate.getClass, castSelf: Cast.asPyEnumerate)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyEnumerate.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyEnumerate.getAttribute(name:), castSelf: Cast.asPyEnumerate)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyEnumerate.iter, castSelf: Cast.asPyEnumerate)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyEnumerate.next, castSelf: Cast.asPyEnumerate)
  }

  // MARK: - Filter

  internal static func filter(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFilter.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFilter.getClass, castSelf: Cast.asPyFilter)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyFilter.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyFilter.getAttribute(name:), castSelf: Cast.asPyFilter)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyFilter.iter, castSelf: Cast.asPyFilter)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyFilter.next, castSelf: Cast.asPyFilter)
  }

  // MARK: - Float

  internal static func float(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFloat.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFloat.getClass, castSelf: Cast.asPyFloat)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyFloat.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyFloat.isEqual(_:), castSelf: Cast.asPyFloat)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyFloat.isNotEqual(_:), castSelf: Cast.asPyFloat)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyFloat.isLess(_:), castSelf: Cast.asPyFloat)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyFloat.isLessEqual(_:), castSelf: Cast.asPyFloat)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyFloat.isGreater(_:), castSelf: Cast.asPyFloat)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyFloat.isGreaterEqual(_:), castSelf: Cast.asPyFloat)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyFloat.hash, castSelf: Cast.asPyFloat)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyFloat.repr, castSelf: Cast.asPyFloat)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyFloat.str, castSelf: Cast.asPyFloat)
    dict["__bool__"] = PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyFloat.asBool, castSelf: Cast.asPyFloat)
    dict["__int__"] = PyBuiltinFunction.wrap(name: "__int__", doc: nil, fn: PyFloat.asInt, castSelf: Cast.asPyFloat)
    dict["__float__"] = PyBuiltinFunction.wrap(name: "__float__", doc: nil, fn: PyFloat.asFloat, castSelf: Cast.asPyFloat)
    dict["real"] = PyBuiltinFunction.wrap(name: "real", doc: nil, fn: PyFloat.asReal, castSelf: Cast.asPyFloat)
    dict["imag"] = PyBuiltinFunction.wrap(name: "imag", doc: nil, fn: PyFloat.asImag, castSelf: Cast.asPyFloat)
    dict["conjugate"] = PyBuiltinFunction.wrap(name: "conjugate", doc: nil, fn: PyFloat.conjugate, castSelf: Cast.asPyFloat)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyFloat.getAttribute(name:), castSelf: Cast.asPyFloat)
    dict["__pos__"] = PyBuiltinFunction.wrap(name: "__pos__", doc: nil, fn: PyFloat.positive, castSelf: Cast.asPyFloat)
    dict["__neg__"] = PyBuiltinFunction.wrap(name: "__neg__", doc: nil, fn: PyFloat.negative, castSelf: Cast.asPyFloat)
    dict["__abs__"] = PyBuiltinFunction.wrap(name: "__abs__", doc: nil, fn: PyFloat.abs, castSelf: Cast.asPyFloat)
    dict["is_integer"] = PyBuiltinFunction.wrap(name: "is_integer", doc: nil, fn: PyFloat.isInteger, castSelf: Cast.asPyFloat)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyFloat.add(_:), castSelf: Cast.asPyFloat)
    dict["__radd__"] = PyBuiltinFunction.wrap(name: "__radd__", doc: nil, fn: PyFloat.radd(_:), castSelf: Cast.asPyFloat)
    dict["__sub__"] = PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyFloat.sub(_:), castSelf: Cast.asPyFloat)
    dict["__rsub__"] = PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyFloat.rsub(_:), castSelf: Cast.asPyFloat)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyFloat.mul(_:), castSelf: Cast.asPyFloat)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyFloat.rmul(_:), castSelf: Cast.asPyFloat)
    dict["__pow__"] = PyBuiltinFunction.wrap(name: "__pow__", doc: nil, fn: PyFloat.pow(exp:mod:), castSelf: Cast.asPyFloat)
    dict["__rpow__"] = PyBuiltinFunction.wrap(name: "__rpow__", doc: nil, fn: PyFloat.rpow(base:mod:), castSelf: Cast.asPyFloat)
    dict["__truediv__"] = PyBuiltinFunction.wrap(name: "__truediv__", doc: nil, fn: PyFloat.truediv(_:), castSelf: Cast.asPyFloat)
    dict["__rtruediv__"] = PyBuiltinFunction.wrap(name: "__rtruediv__", doc: nil, fn: PyFloat.rtruediv(_:), castSelf: Cast.asPyFloat)
    dict["__floordiv__"] = PyBuiltinFunction.wrap(name: "__floordiv__", doc: nil, fn: PyFloat.floordiv(_:), castSelf: Cast.asPyFloat)
    dict["__rfloordiv__"] = PyBuiltinFunction.wrap(name: "__rfloordiv__", doc: nil, fn: PyFloat.rfloordiv(_:), castSelf: Cast.asPyFloat)
    dict["__mod__"] = PyBuiltinFunction.wrap(name: "__mod__", doc: nil, fn: PyFloat.mod(_:), castSelf: Cast.asPyFloat)
    dict["__rmod__"] = PyBuiltinFunction.wrap(name: "__rmod__", doc: nil, fn: PyFloat.rmod(_:), castSelf: Cast.asPyFloat)
    dict["__divmod__"] = PyBuiltinFunction.wrap(name: "__divmod__", doc: nil, fn: PyFloat.divmod(_:), castSelf: Cast.asPyFloat)
    dict["__rdivmod__"] = PyBuiltinFunction.wrap(name: "__rdivmod__", doc: nil, fn: PyFloat.rdivmod(_:), castSelf: Cast.asPyFloat)
    dict["__round__"] = PyBuiltinFunction.wrap(name: "__round__", doc: nil, fn: PyFloat.round(nDigits:), castSelf: Cast.asPyFloat)
    dict["__trunc__"] = PyBuiltinFunction.wrap(name: "__trunc__", doc: nil, fn: PyFloat.trunc, castSelf: Cast.asPyFloat)
  }

  // MARK: - FrozenSet

  internal static func frozenset(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFrozenSet.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFrozenSet.getClass, castSelf: Cast.asPyFrozenSet)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyFrozenSet.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyFrozenSet.isEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyFrozenSet.isNotEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyFrozenSet.isLess(_:), castSelf: Cast.asPyFrozenSet)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyFrozenSet.isLessEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyFrozenSet.isGreater(_:), castSelf: Cast.asPyFrozenSet)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyFrozenSet.isGreaterEqual(_:), castSelf: Cast.asPyFrozenSet)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyFrozenSet.hash, castSelf: Cast.asPyFrozenSet)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyFrozenSet.repr, castSelf: Cast.asPyFrozenSet)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyFrozenSet.getAttribute(name:), castSelf: Cast.asPyFrozenSet)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyFrozenSet.getLength, castSelf: Cast.asPyFrozenSet)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyFrozenSet.contains(_:), castSelf: Cast.asPyFrozenSet)
    dict["__and__"] = PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PyFrozenSet.and(_:), castSelf: Cast.asPyFrozenSet)
    dict["__rand__"] = PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PyFrozenSet.rand(_:), castSelf: Cast.asPyFrozenSet)
    dict["__or__"] = PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PyFrozenSet.or(_:), castSelf: Cast.asPyFrozenSet)
    dict["__ror__"] = PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PyFrozenSet.ror(_:), castSelf: Cast.asPyFrozenSet)
    dict["__xor__"] = PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PyFrozenSet.xor(_:), castSelf: Cast.asPyFrozenSet)
    dict["__rxor__"] = PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PyFrozenSet.rxor(_:), castSelf: Cast.asPyFrozenSet)
    dict["__sub__"] = PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyFrozenSet.sub(_:), castSelf: Cast.asPyFrozenSet)
    dict["__rsub__"] = PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyFrozenSet.rsub(_:), castSelf: Cast.asPyFrozenSet)
    dict["issubset"] = PyBuiltinFunction.wrap(name: "issubset", doc: nil, fn: PyFrozenSet.isSubset(of:), castSelf: Cast.asPyFrozenSet)
    dict["issuperset"] = PyBuiltinFunction.wrap(name: "issuperset", doc: nil, fn: PyFrozenSet.isSuperset(of:), castSelf: Cast.asPyFrozenSet)
    dict["intersection"] = PyBuiltinFunction.wrap(name: "intersection", doc: nil, fn: PyFrozenSet.intersection(with:), castSelf: Cast.asPyFrozenSet)
    dict["union"] = PyBuiltinFunction.wrap(name: "union", doc: nil, fn: PyFrozenSet.union(with:), castSelf: Cast.asPyFrozenSet)
    dict["difference"] = PyBuiltinFunction.wrap(name: "difference", doc: nil, fn: PyFrozenSet.difference(with:), castSelf: Cast.asPyFrozenSet)
    dict["symmetric_difference"] = PyBuiltinFunction.wrap(name: "symmetric_difference", doc: nil, fn: PyFrozenSet.symmetricDifference(with:), castSelf: Cast.asPyFrozenSet)
    dict["isdisjoint"] = PyBuiltinFunction.wrap(name: "isdisjoint", doc: nil, fn: PyFrozenSet.isDisjoint(with:), castSelf: Cast.asPyFrozenSet)
    dict["copy"] = PyBuiltinFunction.wrap(name: "copy", doc: nil, fn: PyFrozenSet.copy, castSelf: Cast.asPyFrozenSet)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyFrozenSet.iter, castSelf: Cast.asPyFrozenSet)
  }

  // MARK: - Function

  internal static func function(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFunction.doc)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFunction.getClass, castSelf: Cast.asPyFunction)
    dict["__name__"] = PyProperty.wrap(name: "__name__", doc: nil, get: PyFunction.getName, set: PyFunction.setName, castSelf: Cast.asPyFunction)
    dict["__qualname__"] = PyProperty.wrap(name: "__qualname__", doc: nil, get: PyFunction.getQualname, set: PyFunction.setQualname, castSelf: Cast.asPyFunction)
    dict["__code__"] = PyProperty.wrap(name: "__code__", doc: nil, get: PyFunction.getCode, castSelf: Cast.asPyFunction)
    dict["__doc__"] = PyProperty.wrap(name: "__doc__", doc: nil, get: PyFunction.getDoc, castSelf: Cast.asPyFunction)
    dict["__module__"] = PyProperty.wrap(name: "__module__", doc: nil, get: PyFunction.getModule, castSelf: Cast.asPyFunction)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyFunction.getDict, castSelf: Cast.asPyFunction)



    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyFunction.repr, castSelf: Cast.asPyFunction)
    dict["__get__"] = PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyFunction.get(object:), castSelf: Cast.asPyFunction)
  }

  // MARK: - Int

  internal static func int(_ type: PyType) {
    type.setBuiltinTypeDoc(PyInt.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.longSubclass)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyInt.getClass, castSelf: Cast.asPyInt)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyInt.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyInt.isEqual(_:), castSelf: Cast.asPyInt)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyInt.isNotEqual(_:), castSelf: Cast.asPyInt)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyInt.isLess(_:), castSelf: Cast.asPyInt)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyInt.isLessEqual(_:), castSelf: Cast.asPyInt)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyInt.isGreater(_:), castSelf: Cast.asPyInt)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyInt.isGreaterEqual(_:), castSelf: Cast.asPyInt)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyInt.hash, castSelf: Cast.asPyInt)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyInt.repr, castSelf: Cast.asPyInt)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyInt.str, castSelf: Cast.asPyInt)
    dict["__bool__"] = PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyInt.asBool, castSelf: Cast.asPyInt)
    dict["__int__"] = PyBuiltinFunction.wrap(name: "__int__", doc: nil, fn: PyInt.asInt, castSelf: Cast.asPyInt)
    dict["__float__"] = PyBuiltinFunction.wrap(name: "__float__", doc: nil, fn: PyInt.asFloat, castSelf: Cast.asPyInt)
    dict["__index__"] = PyBuiltinFunction.wrap(name: "__index__", doc: nil, fn: PyInt.asIndex, castSelf: Cast.asPyInt)
    dict["real"] = PyBuiltinFunction.wrap(name: "real", doc: nil, fn: PyInt.asReal, castSelf: Cast.asPyInt)
    dict["imag"] = PyBuiltinFunction.wrap(name: "imag", doc: nil, fn: PyInt.asImag, castSelf: Cast.asPyInt)
    dict["conjugate"] = PyBuiltinFunction.wrap(name: "conjugate", doc: nil, fn: PyInt.conjugate, castSelf: Cast.asPyInt)
    dict["numerator"] = PyBuiltinFunction.wrap(name: "numerator", doc: nil, fn: PyInt.numerator, castSelf: Cast.asPyInt)
    dict["denominator"] = PyBuiltinFunction.wrap(name: "denominator", doc: nil, fn: PyInt.denominator, castSelf: Cast.asPyInt)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyInt.getAttribute(name:), castSelf: Cast.asPyInt)
    dict["__pos__"] = PyBuiltinFunction.wrap(name: "__pos__", doc: nil, fn: PyInt.positive, castSelf: Cast.asPyInt)
    dict["__neg__"] = PyBuiltinFunction.wrap(name: "__neg__", doc: nil, fn: PyInt.negative, castSelf: Cast.asPyInt)
    dict["__abs__"] = PyBuiltinFunction.wrap(name: "__abs__", doc: nil, fn: PyInt.abs, castSelf: Cast.asPyInt)
    dict["__trunc__"] = PyBuiltinFunction.wrap(name: "__trunc__", doc: nil, fn: PyInt.trunc, castSelf: Cast.asPyInt)
    dict["__floor__"] = PyBuiltinFunction.wrap(name: "__floor__", doc: nil, fn: PyInt.floor, castSelf: Cast.asPyInt)
    dict["__ceil__"] = PyBuiltinFunction.wrap(name: "__ceil__", doc: nil, fn: PyInt.ceil, castSelf: Cast.asPyInt)
    dict["bit_length"] = PyBuiltinFunction.wrap(name: "bit_length", doc: nil, fn: PyInt.bitLength, castSelf: Cast.asPyInt)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyInt.add(_:), castSelf: Cast.asPyInt)
    dict["__radd__"] = PyBuiltinFunction.wrap(name: "__radd__", doc: nil, fn: PyInt.radd(_:), castSelf: Cast.asPyInt)
    dict["__sub__"] = PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyInt.sub(_:), castSelf: Cast.asPyInt)
    dict["__rsub__"] = PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyInt.rsub(_:), castSelf: Cast.asPyInt)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyInt.mul(_:), castSelf: Cast.asPyInt)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyInt.rmul(_:), castSelf: Cast.asPyInt)
    dict["__pow__"] = PyBuiltinFunction.wrap(name: "__pow__", doc: nil, fn: PyInt.pow(exp:mod:), castSelf: Cast.asPyInt)
    dict["__rpow__"] = PyBuiltinFunction.wrap(name: "__rpow__", doc: nil, fn: PyInt.rpow(base:mod:), castSelf: Cast.asPyInt)
    dict["__truediv__"] = PyBuiltinFunction.wrap(name: "__truediv__", doc: nil, fn: PyInt.truediv(_:), castSelf: Cast.asPyInt)
    dict["__rtruediv__"] = PyBuiltinFunction.wrap(name: "__rtruediv__", doc: nil, fn: PyInt.rtruediv(_:), castSelf: Cast.asPyInt)
    dict["__floordiv__"] = PyBuiltinFunction.wrap(name: "__floordiv__", doc: nil, fn: PyInt.floordiv(_:), castSelf: Cast.asPyInt)
    dict["__rfloordiv__"] = PyBuiltinFunction.wrap(name: "__rfloordiv__", doc: nil, fn: PyInt.rfloordiv(_:), castSelf: Cast.asPyInt)
    dict["__mod__"] = PyBuiltinFunction.wrap(name: "__mod__", doc: nil, fn: PyInt.mod(_:), castSelf: Cast.asPyInt)
    dict["__rmod__"] = PyBuiltinFunction.wrap(name: "__rmod__", doc: nil, fn: PyInt.rmod(_:), castSelf: Cast.asPyInt)
    dict["__divmod__"] = PyBuiltinFunction.wrap(name: "__divmod__", doc: nil, fn: PyInt.divmod(_:), castSelf: Cast.asPyInt)
    dict["__rdivmod__"] = PyBuiltinFunction.wrap(name: "__rdivmod__", doc: nil, fn: PyInt.rdivmod(_:), castSelf: Cast.asPyInt)
    dict["__lshift__"] = PyBuiltinFunction.wrap(name: "__lshift__", doc: nil, fn: PyInt.lshift(_:), castSelf: Cast.asPyInt)
    dict["__rlshift__"] = PyBuiltinFunction.wrap(name: "__rlshift__", doc: nil, fn: PyInt.rlshift(_:), castSelf: Cast.asPyInt)
    dict["__rshift__"] = PyBuiltinFunction.wrap(name: "__rshift__", doc: nil, fn: PyInt.rshift(_:), castSelf: Cast.asPyInt)
    dict["__rrshift__"] = PyBuiltinFunction.wrap(name: "__rrshift__", doc: nil, fn: PyInt.rrshift(_:), castSelf: Cast.asPyInt)
    dict["__and__"] = PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PyInt.and(_:), castSelf: Cast.asPyInt)
    dict["__rand__"] = PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PyInt.rand(_:), castSelf: Cast.asPyInt)
    dict["__or__"] = PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PyInt.or(_:), castSelf: Cast.asPyInt)
    dict["__ror__"] = PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PyInt.ror(_:), castSelf: Cast.asPyInt)
    dict["__xor__"] = PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PyInt.xor(_:), castSelf: Cast.asPyInt)
    dict["__rxor__"] = PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PyInt.rxor(_:), castSelf: Cast.asPyInt)
    dict["__invert__"] = PyBuiltinFunction.wrap(name: "__invert__", doc: nil, fn: PyInt.invert, castSelf: Cast.asPyInt)
    dict["__round__"] = PyBuiltinFunction.wrap(name: "__round__", doc: nil, fn: PyInt.round(nDigits:), castSelf: Cast.asPyInt)
  }

  // MARK: - Iterator

  internal static func iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyIterator.getClass, castSelf: Cast.asPyIterator)



    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyIterator.getAttribute(name:), castSelf: Cast.asPyIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyIterator.iter, castSelf: Cast.asPyIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyIterator.next, castSelf: Cast.asPyIterator)
  }

  // MARK: - List

  internal static func list(_ type: PyType) {
    type.setBuiltinTypeDoc(PyList.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)
    type.setFlag(.listSubclass)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyList.getClass, castSelf: Cast.asPyList)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyList.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyList.pyInit(zelf:args:kwargs:))


    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyList.isEqual(_:), castSelf: Cast.asPyList)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyList.isNotEqual(_:), castSelf: Cast.asPyList)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyList.isLess(_:), castSelf: Cast.asPyList)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyList.isLessEqual(_:), castSelf: Cast.asPyList)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyList.isGreater(_:), castSelf: Cast.asPyList)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyList.isGreaterEqual(_:), castSelf: Cast.asPyList)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyList.hash, castSelf: Cast.asPyList)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyList.repr, castSelf: Cast.asPyList)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyList.getAttribute(name:), castSelf: Cast.asPyList)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyList.getLength, castSelf: Cast.asPyList)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyList.contains(_:), castSelf: Cast.asPyList)
    dict["__getitem__"] = PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyList.getItem(at:), castSelf: Cast.asPyList)
    dict["__setitem__"] = PyBuiltinFunction.wrap(name: "__setitem__", doc: nil, fn: PyList.setItem(at:to:), castSelf: Cast.asPyList)
    dict["__delitem__"] = PyBuiltinFunction.wrap(name: "__delitem__", doc: nil, fn: PyList.delItem(at:), castSelf: Cast.asPyList)
    dict["count"] = PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyList.count(_:), castSelf: Cast.asPyList)
    dict["index"] = PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyList.index(of:start:end:), castSelf: Cast.asPyList)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyList.iter, castSelf: Cast.asPyList)
    dict["__reversed__"] = PyBuiltinFunction.wrap(name: "__reversed__", doc: nil, fn: PyList.reversed, castSelf: Cast.asPyList)
    dict["append"] = PyBuiltinFunction.wrap(name: "append", doc: nil, fn: PyList.append(_:), castSelf: Cast.asPyList)
    dict["insert"] = PyBuiltinFunction.wrap(name: "insert", doc: nil, fn: PyList.insert(at:item:), castSelf: Cast.asPyList)
    dict["extend"] = PyBuiltinFunction.wrap(name: "extend", doc: nil, fn: PyList.extend(iterable:), castSelf: Cast.asPyList)
    dict["remove"] = PyBuiltinFunction.wrap(name: "remove", doc: nil, fn: PyList.remove(_:), castSelf: Cast.asPyList)
    dict["pop"] = PyBuiltinFunction.wrap(name: "pop", doc: nil, fn: PyList.pop(index:), castSelf: Cast.asPyList)
    dict["sort"] = PyBuiltinFunction.wrap(name: "sort", doc: nil, fn: PyList.sort(args:kwargs:), castSelf: Cast.asPyList)
    dict["reverse"] = PyBuiltinFunction.wrap(name: "reverse", doc: nil, fn: PyList.reverse, castSelf: Cast.asPyList)
    dict["clear"] = PyBuiltinFunction.wrap(name: "clear", doc: nil, fn: PyList.clear, castSelf: Cast.asPyList)
    dict["copy"] = PyBuiltinFunction.wrap(name: "copy", doc: nil, fn: PyList.copy, castSelf: Cast.asPyList)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyList.add(_:), castSelf: Cast.asPyList)
    dict["__iadd__"] = PyBuiltinFunction.wrap(name: "__iadd__", doc: nil, fn: PyList.iadd(_:), castSelf: Cast.asPyList)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyList.mul(_:), castSelf: Cast.asPyList)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyList.rmul(_:), castSelf: Cast.asPyList)
    dict["__imul__"] = PyBuiltinFunction.wrap(name: "__imul__", doc: nil, fn: PyList.imul(_:), castSelf: Cast.asPyList)
  }

  // MARK: - ListIterator

  internal static func list_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyListIterator.getClass, castSelf: Cast.asPyListIterator)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyListIterator.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyListIterator.getAttribute(name:), castSelf: Cast.asPyListIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyListIterator.iter, castSelf: Cast.asPyListIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyListIterator.next, castSelf: Cast.asPyListIterator)
  }

  // MARK: - ListReverseIterator

  internal static func list_reverseiterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyListReverseIterator.getClass, castSelf: Cast.asPyListReverseIterator)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyListReverseIterator.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyListReverseIterator.getAttribute(name:), castSelf: Cast.asPyListReverseIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyListReverseIterator.iter, castSelf: Cast.asPyListReverseIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyListReverseIterator.next, castSelf: Cast.asPyListReverseIterator)
  }

  // MARK: - Map

  internal static func map(_ type: PyType) {
    type.setBuiltinTypeDoc(PyMap.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyMap.getClass, castSelf: Cast.asPyMap)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyMap.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyMap.getAttribute(name:), castSelf: Cast.asPyMap)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyMap.iter, castSelf: Cast.asPyMap)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyMap.next, castSelf: Cast.asPyMap)
  }

  // MARK: - Method

  internal static func method(_ type: PyType) {
    type.setBuiltinTypeDoc(PyMethod.doc)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyMethod.getClass, castSelf: Cast.asPyMethod)



    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyMethod.isEqual(_:), castSelf: Cast.asPyMethod)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyMethod.isNotEqual(_:), castSelf: Cast.asPyMethod)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyMethod.isLess(_:), castSelf: Cast.asPyMethod)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyMethod.isLessEqual(_:), castSelf: Cast.asPyMethod)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyMethod.isGreater(_:), castSelf: Cast.asPyMethod)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyMethod.isGreaterEqual(_:), castSelf: Cast.asPyMethod)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyMethod.repr, castSelf: Cast.asPyMethod)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyMethod.hash, castSelf: Cast.asPyMethod)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyMethod.getAttribute(name:), castSelf: Cast.asPyMethod)
    dict["__setattr__"] = PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyMethod.setAttribute(name:value:), castSelf: Cast.asPyMethod)
    dict["__delattr__"] = PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyMethod.delAttribute(name:), castSelf: Cast.asPyMethod)
    dict["__func__"] = PyBuiltinFunction.wrap(name: "__func__", doc: nil, fn: PyMethod.getFunc, castSelf: Cast.asPyMethod)
    dict["__self__"] = PyBuiltinFunction.wrap(name: "__self__", doc: nil, fn: PyMethod.getSelf, castSelf: Cast.asPyMethod)
    dict["__get__"] = PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyMethod.get(object:), castSelf: Cast.asPyMethod)
  }

  // MARK: - Module

  internal static func module(_ type: PyType) {
    type.setBuiltinTypeDoc(PyModule.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyModule.getDict, castSelf: Cast.asPyModule)
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyModule.getClass, castSelf: Cast.asPyModule)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyModule.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyModule.pyInit(zelf:args:kwargs:))


    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyModule.repr, castSelf: Cast.asPyModule)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyModule.getAttribute(name:), castSelf: Cast.asPyModule)
    dict["__setattr__"] = PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyModule.setAttribute(name:value:), castSelf: Cast.asPyModule)
    dict["__delattr__"] = PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyModule.delAttribute(name:), castSelf: Cast.asPyModule)
    dict["__dir__"] = PyBuiltinFunction.wrap(name: "__dir__", doc: nil, fn: PyModule.dir, castSelf: Cast.asPyModule)
  }

  // MARK: - Namespace

  internal static func simpleNamespace(_ type: PyType) {
    type.setBuiltinTypeDoc(PyNamespace.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyNamespace.getDict, castSelf: Cast.asPyNamespace)

    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyNamespace.pyInit(zelf:args:kwargs:))


    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyNamespace.isEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyNamespace.isNotEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyNamespace.isLess(_:), castSelf: Cast.asPyNamespace)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyNamespace.isLessEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyNamespace.isGreater(_:), castSelf: Cast.asPyNamespace)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyNamespace.isGreaterEqual(_:), castSelf: Cast.asPyNamespace)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyNamespace.repr, castSelf: Cast.asPyNamespace)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyNamespace.getAttribute(name:), castSelf: Cast.asPyNamespace)
    dict["__setattr__"] = PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyNamespace.setAttribute(name:value:), castSelf: Cast.asPyNamespace)
    dict["__delattr__"] = PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyNamespace.delAttribute(name:), castSelf: Cast.asPyNamespace)
  }

  // MARK: - None

  internal static func none(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyNone.getClass, castSelf: Cast.asPyNone)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyNone.pyNew(type:args:kwargs:))


    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyNone.repr, castSelf: Cast.asPyNone)
    dict["__bool__"] = PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyNone.asBool, castSelf: Cast.asPyNone)
  }

  // MARK: - NotImplemented

  internal static func notImplemented(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyNotImplemented.getClass, castSelf: Cast.asPyNotImplemented)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyNotImplemented.pyNew(type:args:kwargs:))


    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyNotImplemented.repr, castSelf: Cast.asPyNotImplemented)
  }

  // MARK: - Property

  internal static func property(_ type: PyType) {
    type.setBuiltinTypeDoc(PyProperty.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyProperty.getClass, castSelf: Cast.asPyProperty)
    dict["fget"] = PyProperty.wrap(name: "fget", doc: nil, get: PyProperty.getFGet, castSelf: Cast.asPyProperty)
    dict["fset"] = PyProperty.wrap(name: "fset", doc: nil, get: PyProperty.getFSet, castSelf: Cast.asPyProperty)
    dict["fdel"] = PyProperty.wrap(name: "fdel", doc: nil, get: PyProperty.getFDel, castSelf: Cast.asPyProperty)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyProperty.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyProperty.pyInit(zelf:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyProperty.getAttribute(name:), castSelf: Cast.asPyProperty)
    dict["__get__"] = PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyProperty.get(object:), castSelf: Cast.asPyProperty)
    dict["__set__"] = PyBuiltinFunction.wrap(name: "__set__", doc: nil, fn: PyProperty.set(object:value:), castSelf: Cast.asPyProperty)
    dict["__delete__"] = PyBuiltinFunction.wrap(name: "__delete__", doc: nil, fn: PyProperty.del(object:), castSelf: Cast.asPyProperty)
  }

  // MARK: - Range

  internal static func range(_ type: PyType) {
    type.setBuiltinTypeDoc(PyRange.doc)
    type.setFlag(.default)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyRange.getClass, castSelf: Cast.asPyRange)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyRange.pyNew(type:args:kwargs:))


    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyRange.isEqual(_:), castSelf: Cast.asPyRange)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyRange.isNotEqual(_:), castSelf: Cast.asPyRange)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyRange.isLess(_:), castSelf: Cast.asPyRange)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyRange.isLessEqual(_:), castSelf: Cast.asPyRange)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyRange.isGreater(_:), castSelf: Cast.asPyRange)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyRange.isGreaterEqual(_:), castSelf: Cast.asPyRange)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyRange.hash, castSelf: Cast.asPyRange)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyRange.repr, castSelf: Cast.asPyRange)
    dict["__bool__"] = PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyRange.asBool, castSelf: Cast.asPyRange)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyRange.getLength, castSelf: Cast.asPyRange)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyRange.getAttribute(name:), castSelf: Cast.asPyRange)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyRange.contains(_:), castSelf: Cast.asPyRange)
    dict["__getitem__"] = PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyRange.getItem(at:), castSelf: Cast.asPyRange)
    dict["start"] = PyBuiltinFunction.wrap(name: "start", doc: nil, fn: PyRange.getStart, castSelf: Cast.asPyRange)
    dict["stop"] = PyBuiltinFunction.wrap(name: "stop", doc: nil, fn: PyRange.getStop, castSelf: Cast.asPyRange)
    dict["step"] = PyBuiltinFunction.wrap(name: "step", doc: nil, fn: PyRange.getStep, castSelf: Cast.asPyRange)
    dict["__reversed__"] = PyBuiltinFunction.wrap(name: "__reversed__", doc: nil, fn: PyRange.reversed, castSelf: Cast.asPyRange)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyRange.iter, castSelf: Cast.asPyRange)
    dict["count"] = PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyRange.count(_:), castSelf: Cast.asPyRange)
    dict["index"] = PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyRange.index(of:), castSelf: Cast.asPyRange)
  }

  // MARK: - RangeIterator

  internal static func range_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyRangeIterator.getClass, castSelf: Cast.asPyRangeIterator)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyRangeIterator.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyRangeIterator.getAttribute(name:), castSelf: Cast.asPyRangeIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyRangeIterator.iter, castSelf: Cast.asPyRangeIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyRangeIterator.next, castSelf: Cast.asPyRangeIterator)
  }

  // MARK: - Reversed

  internal static func reversed(_ type: PyType) {
    type.setBuiltinTypeDoc(PyReversed.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyReversed.getClass, castSelf: Cast.asPyReversed)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyReversed.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyReversed.getAttribute(name:), castSelf: Cast.asPyReversed)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyReversed.iter, castSelf: Cast.asPyReversed)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyReversed.next, castSelf: Cast.asPyReversed)
  }

  // MARK: - Set

  internal static func set(_ type: PyType) {
    type.setBuiltinTypeDoc(PySet.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PySet.getClass, castSelf: Cast.asPySet)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PySet.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PySet.pyInit(zelf:args:kwargs:))


    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PySet.isEqual(_:), castSelf: Cast.asPySet)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PySet.isNotEqual(_:), castSelf: Cast.asPySet)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PySet.isLess(_:), castSelf: Cast.asPySet)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PySet.isLessEqual(_:), castSelf: Cast.asPySet)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PySet.isGreater(_:), castSelf: Cast.asPySet)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PySet.isGreaterEqual(_:), castSelf: Cast.asPySet)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PySet.hash, castSelf: Cast.asPySet)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PySet.repr, castSelf: Cast.asPySet)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PySet.getAttribute(name:), castSelf: Cast.asPySet)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PySet.getLength, castSelf: Cast.asPySet)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PySet.contains(_:), castSelf: Cast.asPySet)
    dict["__and__"] = PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PySet.and(_:), castSelf: Cast.asPySet)
    dict["__rand__"] = PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PySet.rand(_:), castSelf: Cast.asPySet)
    dict["__or__"] = PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PySet.or(_:), castSelf: Cast.asPySet)
    dict["__ror__"] = PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PySet.ror(_:), castSelf: Cast.asPySet)
    dict["__xor__"] = PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PySet.xor(_:), castSelf: Cast.asPySet)
    dict["__rxor__"] = PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PySet.rxor(_:), castSelf: Cast.asPySet)
    dict["__sub__"] = PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PySet.sub(_:), castSelf: Cast.asPySet)
    dict["__rsub__"] = PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PySet.rsub(_:), castSelf: Cast.asPySet)
    dict["issubset"] = PyBuiltinFunction.wrap(name: "issubset", doc: nil, fn: PySet.isSubset(of:), castSelf: Cast.asPySet)
    dict["issuperset"] = PyBuiltinFunction.wrap(name: "issuperset", doc: nil, fn: PySet.isSuperset(of:), castSelf: Cast.asPySet)
    dict["intersection"] = PyBuiltinFunction.wrap(name: "intersection", doc: nil, fn: PySet.intersection(with:), castSelf: Cast.asPySet)
    dict["union"] = PyBuiltinFunction.wrap(name: "union", doc: nil, fn: PySet.union(with:), castSelf: Cast.asPySet)
    dict["difference"] = PyBuiltinFunction.wrap(name: "difference", doc: nil, fn: PySet.difference(with:), castSelf: Cast.asPySet)
    dict["symmetric_difference"] = PyBuiltinFunction.wrap(name: "symmetric_difference", doc: nil, fn: PySet.symmetricDifference(with:), castSelf: Cast.asPySet)
    dict["isdisjoint"] = PyBuiltinFunction.wrap(name: "isdisjoint", doc: nil, fn: PySet.isDisjoint(with:), castSelf: Cast.asPySet)
    dict["add"] = PyBuiltinFunction.wrap(name: "add", doc: nil, fn: PySet.add(_:), castSelf: Cast.asPySet)
    dict["update"] = PyBuiltinFunction.wrap(name: "update", doc: nil, fn: PySet.update(from:), castSelf: Cast.asPySet)
    dict["remove"] = PyBuiltinFunction.wrap(name: "remove", doc: nil, fn: PySet.remove(_:), castSelf: Cast.asPySet)
    dict["discard"] = PyBuiltinFunction.wrap(name: "discard", doc: nil, fn: PySet.discard(_:), castSelf: Cast.asPySet)
    dict["clear"] = PyBuiltinFunction.wrap(name: "clear", doc: nil, fn: PySet.clear, castSelf: Cast.asPySet)
    dict["copy"] = PyBuiltinFunction.wrap(name: "copy", doc: nil, fn: PySet.copy, castSelf: Cast.asPySet)
    dict["pop"] = PyBuiltinFunction.wrap(name: "pop", doc: nil, fn: PySet.pop, castSelf: Cast.asPySet)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PySet.iter, castSelf: Cast.asPySet)
  }

  // MARK: - SetIterator

  internal static func set_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PySetIterator.getClass, castSelf: Cast.asPySetIterator)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PySetIterator.pyNew(type:args:kwargs:))

    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PySetIterator.getAttribute(name:), castSelf: Cast.asPySetIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PySetIterator.iter, castSelf: Cast.asPySetIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PySetIterator.next, castSelf: Cast.asPySetIterator)
  }

  // MARK: - Slice

  internal static func slice(_ type: PyType) {
    type.setBuiltinTypeDoc(PySlice.doc)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PySlice.getClass, castSelf: Cast.asPySlice)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PySlice.pyNew(type:args:kwargs:))


    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PySlice.isEqual(_:), castSelf: Cast.asPySlice)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PySlice.isNotEqual(_:), castSelf: Cast.asPySlice)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PySlice.isLess(_:), castSelf: Cast.asPySlice)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PySlice.isLessEqual(_:), castSelf: Cast.asPySlice)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PySlice.isGreater(_:), castSelf: Cast.asPySlice)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PySlice.isGreaterEqual(_:), castSelf: Cast.asPySlice)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PySlice.hash, castSelf: Cast.asPySlice)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PySlice.repr, castSelf: Cast.asPySlice)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PySlice.getAttribute(name:), castSelf: Cast.asPySlice)
    dict["start"] = PyBuiltinFunction.wrap(name: "start", doc: nil, fn: PySlice.getStart, castSelf: Cast.asPySlice)
    dict["stop"] = PyBuiltinFunction.wrap(name: "stop", doc: nil, fn: PySlice.getStop, castSelf: Cast.asPySlice)
    dict["step"] = PyBuiltinFunction.wrap(name: "step", doc: nil, fn: PySlice.getStep, castSelf: Cast.asPySlice)
    dict["indices"] = PyBuiltinFunction.wrap(name: "indices", doc: nil, fn: PySlice.indicesInSequence(length:), castSelf: Cast.asPySlice)
  }

  // MARK: - String

  internal static func str(_ type: PyType) {
    type.setBuiltinTypeDoc(PyString.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.unicodeSubclass)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyString.getClass, castSelf: Cast.asPyString)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyString.pyNew(type:args:kwargs:))

    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyString.isEqual(_:), castSelf: Cast.asPyString)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyString.isNotEqual(_:), castSelf: Cast.asPyString)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyString.isLess(_:), castSelf: Cast.asPyString)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyString.isLessEqual(_:), castSelf: Cast.asPyString)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyString.isGreater(_:), castSelf: Cast.asPyString)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyString.isGreaterEqual(_:), castSelf: Cast.asPyString)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyString.hash, castSelf: Cast.asPyString)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyString.repr, castSelf: Cast.asPyString)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyString.str, castSelf: Cast.asPyString)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyString.getAttribute(name:), castSelf: Cast.asPyString)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyString.getLength, castSelf: Cast.asPyString)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyString.contains(_:), castSelf: Cast.asPyString)
    dict["__getitem__"] = PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyString.getItem(at:), castSelf: Cast.asPyString)
    dict["isalnum"] = PyBuiltinFunction.wrap(name: "isalnum", doc: nil, fn: PyString.isAlphaNumeric, castSelf: Cast.asPyString)
    dict["isalpha"] = PyBuiltinFunction.wrap(name: "isalpha", doc: nil, fn: PyString.isAlpha, castSelf: Cast.asPyString)
    dict["isascii"] = PyBuiltinFunction.wrap(name: "isascii", doc: nil, fn: PyString.isAscii, castSelf: Cast.asPyString)
    dict["isdecimal"] = PyBuiltinFunction.wrap(name: "isdecimal", doc: nil, fn: PyString.isDecimal, castSelf: Cast.asPyString)
    dict["isdigit"] = PyBuiltinFunction.wrap(name: "isdigit", doc: nil, fn: PyString.isDigit, castSelf: Cast.asPyString)
    dict["isidentifier"] = PyBuiltinFunction.wrap(name: "isidentifier", doc: nil, fn: PyString.isIdentifier, castSelf: Cast.asPyString)
    dict["islower"] = PyBuiltinFunction.wrap(name: "islower", doc: nil, fn: PyString.isLower, castSelf: Cast.asPyString)
    dict["isnumeric"] = PyBuiltinFunction.wrap(name: "isnumeric", doc: nil, fn: PyString.isNumeric, castSelf: Cast.asPyString)
    dict["isprintable"] = PyBuiltinFunction.wrap(name: "isprintable", doc: nil, fn: PyString.isPrintable, castSelf: Cast.asPyString)
    dict["isspace"] = PyBuiltinFunction.wrap(name: "isspace", doc: nil, fn: PyString.isSpace, castSelf: Cast.asPyString)
    dict["istitle"] = PyBuiltinFunction.wrap(name: "istitle", doc: nil, fn: PyString.isTitle, castSelf: Cast.asPyString)
    dict["isupper"] = PyBuiltinFunction.wrap(name: "isupper", doc: nil, fn: PyString.isUpper, castSelf: Cast.asPyString)
    dict["startswith"] = PyBuiltinFunction.wrap(name: "startswith", doc: nil, fn: PyString.startsWith(_:start:end:), castSelf: Cast.asPyString)
    dict["endswith"] = PyBuiltinFunction.wrap(name: "endswith", doc: nil, fn: PyString.endsWith(_:start:end:), castSelf: Cast.asPyString)
    dict["strip"] = PyBuiltinFunction.wrap(name: "strip", doc: nil, fn: PyString.strip(_:), castSelf: Cast.asPyString)
    dict["lstrip"] = PyBuiltinFunction.wrap(name: "lstrip", doc: nil, fn: PyString.lstrip(_:), castSelf: Cast.asPyString)
    dict["rstrip"] = PyBuiltinFunction.wrap(name: "rstrip", doc: nil, fn: PyString.rstrip(_:), castSelf: Cast.asPyString)
    dict["find"] = PyBuiltinFunction.wrap(name: "find", doc: nil, fn: PyString.find(_:start:end:), castSelf: Cast.asPyString)
    dict["rfind"] = PyBuiltinFunction.wrap(name: "rfind", doc: nil, fn: PyString.rfind(_:start:end:), castSelf: Cast.asPyString)
    dict["index"] = PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyString.index(of:start:end:), castSelf: Cast.asPyString)
    dict["rindex"] = PyBuiltinFunction.wrap(name: "rindex", doc: nil, fn: PyString.rindex(_:start:end:), castSelf: Cast.asPyString)
    dict["lower"] = PyBuiltinFunction.wrap(name: "lower", doc: nil, fn: PyString.lower, castSelf: Cast.asPyString)
    dict["upper"] = PyBuiltinFunction.wrap(name: "upper", doc: nil, fn: PyString.upper, castSelf: Cast.asPyString)
    dict["title"] = PyBuiltinFunction.wrap(name: "title", doc: nil, fn: PyString.title, castSelf: Cast.asPyString)
    dict["swapcase"] = PyBuiltinFunction.wrap(name: "swapcase", doc: nil, fn: PyString.swapcase, castSelf: Cast.asPyString)
    dict["casefold"] = PyBuiltinFunction.wrap(name: "casefold", doc: nil, fn: PyString.casefold, castSelf: Cast.asPyString)
    dict["capitalize"] = PyBuiltinFunction.wrap(name: "capitalize", doc: nil, fn: PyString.capitalize, castSelf: Cast.asPyString)
    dict["center"] = PyBuiltinFunction.wrap(name: "center", doc: nil, fn: PyString.center(width:fillChar:), castSelf: Cast.asPyString)
    dict["ljust"] = PyBuiltinFunction.wrap(name: "ljust", doc: nil, fn: PyString.ljust(width:fillChar:), castSelf: Cast.asPyString)
    dict["rjust"] = PyBuiltinFunction.wrap(name: "rjust", doc: nil, fn: PyString.rjust(width:fillChar:), castSelf: Cast.asPyString)
    dict["split"] = PyBuiltinFunction.wrap(name: "split", doc: nil, fn: PyString.split(separator:maxCount:), castSelf: Cast.asPyString)
    dict["rsplit"] = PyBuiltinFunction.wrap(name: "rsplit", doc: nil, fn: PyString.rsplit(separator:maxCount:), castSelf: Cast.asPyString)
    dict["splitlines"] = PyBuiltinFunction.wrap(name: "splitlines", doc: nil, fn: PyString.splitLines(keepEnds:), castSelf: Cast.asPyString)
    dict["partition"] = PyBuiltinFunction.wrap(name: "partition", doc: nil, fn: PyString.partition(separator:), castSelf: Cast.asPyString)
    dict["rpartition"] = PyBuiltinFunction.wrap(name: "rpartition", doc: nil, fn: PyString.rpartition(separator:), castSelf: Cast.asPyString)
    dict["expandtabs"] = PyBuiltinFunction.wrap(name: "expandtabs", doc: nil, fn: PyString.expandTabs(tabSize:), castSelf: Cast.asPyString)
    dict["count"] = PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyString.count(_:start:end:), castSelf: Cast.asPyString)
    dict["join"] = PyBuiltinFunction.wrap(name: "join", doc: nil, fn: PyString.join(iterable:), castSelf: Cast.asPyString)
    dict["replace"] = PyBuiltinFunction.wrap(name: "replace", doc: nil, fn: PyString.replace(old:new:count:), castSelf: Cast.asPyString)
    dict["zfill"] = PyBuiltinFunction.wrap(name: "zfill", doc: nil, fn: PyString.zfill(width:), castSelf: Cast.asPyString)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyString.add(_:), castSelf: Cast.asPyString)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyString.mul(_:), castSelf: Cast.asPyString)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyString.rmul(_:), castSelf: Cast.asPyString)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyString.iter, castSelf: Cast.asPyString)
  }

  // MARK: - StringIterator

  internal static func str_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyStringIterator.getClass, castSelf: Cast.asPyStringIterator)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyStringIterator.pyNew(type:args:kwargs:))

    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyStringIterator.getAttribute(name:), castSelf: Cast.asPyStringIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyStringIterator.iter, castSelf: Cast.asPyStringIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyStringIterator.next, castSelf: Cast.asPyStringIterator)
  }

  // MARK: - TextFile

  internal static func textFile(_ type: PyType) {
    type.setBuiltinTypeDoc(PyTextFile.doc)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setFlag(.hasFinalize)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyTextFile.getClass, castSelf: Cast.asPyTextFile)



    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyTextFile.repr, castSelf: Cast.asPyTextFile)
    dict["readable"] = PyBuiltinFunction.wrap(name: "readable", doc: nil, fn: PyTextFile.isReadable, castSelf: Cast.asPyTextFile)
    dict["read"] = PyBuiltinFunction.wrap(name: "read", doc: nil, fn: PyTextFile.read(size:), castSelf: Cast.asPyTextFile)
    dict["writable"] = PyBuiltinFunction.wrap(name: "writable", doc: nil, fn: PyTextFile.isWritable, castSelf: Cast.asPyTextFile)
    dict["write"] = PyBuiltinFunction.wrap(name: "write", doc: nil, fn: PyTextFile.write(object:), castSelf: Cast.asPyTextFile)
    dict["closed"] = PyBuiltinFunction.wrap(name: "closed", doc: nil, fn: PyTextFile.isClosed, castSelf: Cast.asPyTextFile)
    dict["close"] = PyBuiltinFunction.wrap(name: "close", doc: nil, fn: PyTextFile.close, castSelf: Cast.asPyTextFile)
    dict["__del__"] = PyBuiltinFunction.wrap(name: "__del__", doc: nil, fn: PyTextFile.del, castSelf: Cast.asPyTextFile)
  }

  // MARK: - Tuple

  internal static func tuple(_ type: PyType) {
    type.setBuiltinTypeDoc(PyTuple.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)
    type.setFlag(.tupleSubclass)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyTuple.getClass, castSelf: Cast.asPyTuple)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyTuple.pyNew(type:args:kwargs:))


    dict["__eq__"] = PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyTuple.isEqual(_:), castSelf: Cast.asPyTuple)
    dict["__ne__"] = PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyTuple.isNotEqual(_:), castSelf: Cast.asPyTuple)
    dict["__lt__"] = PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyTuple.isLess(_:), castSelf: Cast.asPyTuple)
    dict["__le__"] = PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyTuple.isLessEqual(_:), castSelf: Cast.asPyTuple)
    dict["__gt__"] = PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyTuple.isGreater(_:), castSelf: Cast.asPyTuple)
    dict["__ge__"] = PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyTuple.isGreaterEqual(_:), castSelf: Cast.asPyTuple)
    dict["__hash__"] = PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyTuple.hash, castSelf: Cast.asPyTuple)
    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyTuple.repr, castSelf: Cast.asPyTuple)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyTuple.getAttribute(name:), castSelf: Cast.asPyTuple)
    dict["__len__"] = PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyTuple.getLength, castSelf: Cast.asPyTuple)
    dict["__contains__"] = PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyTuple.contains(_:), castSelf: Cast.asPyTuple)
    dict["__getitem__"] = PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyTuple.getItem(at:), castSelf: Cast.asPyTuple)
    dict["count"] = PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyTuple.count(_:), castSelf: Cast.asPyTuple)
    dict["index"] = PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyTuple.index(of:start:end:), castSelf: Cast.asPyTuple)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyTuple.iter, castSelf: Cast.asPyTuple)
    dict["__add__"] = PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyTuple.add(_:), castSelf: Cast.asPyTuple)
    dict["__mul__"] = PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyTuple.mul(_:), castSelf: Cast.asPyTuple)
    dict["__rmul__"] = PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyTuple.rmul(_:), castSelf: Cast.asPyTuple)
  }

  // MARK: - TupleIterator

  internal static func tuple_iterator(_ type: PyType) {
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyTupleIterator.getClass, castSelf: Cast.asPyTupleIterator)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyTupleIterator.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyTupleIterator.getAttribute(name:), castSelf: Cast.asPyTupleIterator)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyTupleIterator.iter, castSelf: Cast.asPyTupleIterator)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyTupleIterator.next, castSelf: Cast.asPyTupleIterator)
  }

  // MARK: - Zip

  internal static func zip(_ type: PyType) {
    type.setBuiltinTypeDoc(PyZip.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyZip.getClass, castSelf: Cast.asPyZip)

    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyZip.pyNew(type:args:kwargs:))


    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyZip.getAttribute(name:), castSelf: Cast.asPyZip)
    dict["__iter__"] = PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyZip.iter, castSelf: Cast.asPyZip)
    dict["__next__"] = PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyZip.next, castSelf: Cast.asPyZip)
  }

  // MARK: - ArithmeticError

  internal static func arithmeticError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyArithmeticError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyArithmeticError.getClass, castSelf: Cast.asPyArithmeticError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyArithmeticError.getDict, castSelf: Cast.asPyArithmeticError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyArithmeticError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyArithmeticError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - AssertionError

  internal static func assertionError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyAssertionError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyAssertionError.getClass, castSelf: Cast.asPyAssertionError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyAssertionError.getDict, castSelf: Cast.asPyAssertionError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyAssertionError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyAssertionError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - AttributeError

  internal static func attributeError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyAttributeError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyAttributeError.getClass, castSelf: Cast.asPyAttributeError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyAttributeError.getDict, castSelf: Cast.asPyAttributeError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyAttributeError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyAttributeError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - BaseException

  internal static func baseException(_ type: PyType) {
    type.setBuiltinTypeDoc(PyBaseException.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)
    type.setFlag(.baseExceptionSubclass)

    let dict = type.getDict()
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyBaseException.getDict, castSelf: Cast.asPyBaseException)
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBaseException.getClass, castSelf: Cast.asPyBaseException)
    dict["args"] = PyProperty.wrap(name: "args", doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: Cast.asPyBaseException)
    dict["__traceback__"] = PyProperty.wrap(name: "__traceback__", doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: Cast.asPyBaseException)
    dict["__cause__"] = PyProperty.wrap(name: "__cause__", doc: nil, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: Cast.asPyBaseException)
    dict["__context__"] = PyProperty.wrap(name: "__context__", doc: nil, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: Cast.asPyBaseException)
    dict["__suppress_context__"] = PyProperty.wrap(name: "__suppress_context__", doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: Cast.asPyBaseException)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBaseException.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyBaseException.pyInit(zelf:args:kwargs:))

    dict["__repr__"] = PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBaseException.repr, castSelf: Cast.asPyBaseException)
    dict["__str__"] = PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBaseException.str, castSelf: Cast.asPyBaseException)
    dict["__getattribute__"] = PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBaseException.getAttribute(name:), castSelf: Cast.asPyBaseException)
    dict["__setattr__"] = PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyBaseException.setAttribute(name:value:), castSelf: Cast.asPyBaseException)
    dict["__delattr__"] = PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyBaseException.delAttribute(name:), castSelf: Cast.asPyBaseException)
  }

  // MARK: - BlockingIOError

  internal static func blockingIOError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyBlockingIOError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBlockingIOError.getClass, castSelf: Cast.asPyBlockingIOError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyBlockingIOError.getDict, castSelf: Cast.asPyBlockingIOError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBlockingIOError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyBlockingIOError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - BrokenPipeError

  internal static func brokenPipeError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyBrokenPipeError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBrokenPipeError.getClass, castSelf: Cast.asPyBrokenPipeError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyBrokenPipeError.getDict, castSelf: Cast.asPyBrokenPipeError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBrokenPipeError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyBrokenPipeError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - BufferError

  internal static func bufferError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyBufferError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBufferError.getClass, castSelf: Cast.asPyBufferError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyBufferError.getDict, castSelf: Cast.asPyBufferError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBufferError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyBufferError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - BytesWarning

  internal static func bytesWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyBytesWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyBytesWarning.getClass, castSelf: Cast.asPyBytesWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyBytesWarning.getDict, castSelf: Cast.asPyBytesWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyBytesWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyBytesWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ChildProcessError

  internal static func childProcessError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyChildProcessError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyChildProcessError.getClass, castSelf: Cast.asPyChildProcessError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyChildProcessError.getDict, castSelf: Cast.asPyChildProcessError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyChildProcessError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyChildProcessError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ConnectionAbortedError

  internal static func connectionAbortedError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyConnectionAbortedError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionAbortedError.getClass, castSelf: Cast.asPyConnectionAbortedError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionAbortedError.getDict, castSelf: Cast.asPyConnectionAbortedError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyConnectionAbortedError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyConnectionAbortedError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ConnectionError

  internal static func connectionError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyConnectionError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionError.getClass, castSelf: Cast.asPyConnectionError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionError.getDict, castSelf: Cast.asPyConnectionError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyConnectionError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyConnectionError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ConnectionRefusedError

  internal static func connectionRefusedError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyConnectionRefusedError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionRefusedError.getClass, castSelf: Cast.asPyConnectionRefusedError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionRefusedError.getDict, castSelf: Cast.asPyConnectionRefusedError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyConnectionRefusedError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyConnectionRefusedError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ConnectionResetError

  internal static func connectionResetError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyConnectionResetError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionResetError.getClass, castSelf: Cast.asPyConnectionResetError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionResetError.getDict, castSelf: Cast.asPyConnectionResetError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyConnectionResetError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyConnectionResetError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - DeprecationWarning

  internal static func deprecationWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyDeprecationWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyDeprecationWarning.getClass, castSelf: Cast.asPyDeprecationWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyDeprecationWarning.getDict, castSelf: Cast.asPyDeprecationWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyDeprecationWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyDeprecationWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - EOFError

  internal static func eofError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyEOFError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyEOFError.getClass, castSelf: Cast.asPyEOFError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyEOFError.getDict, castSelf: Cast.asPyEOFError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyEOFError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyEOFError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - Exception

  internal static func exception(_ type: PyType) {
    type.setBuiltinTypeDoc(PyException.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyException.getClass, castSelf: Cast.asPyException)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyException.getDict, castSelf: Cast.asPyException)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyException.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyException.pyInit(zelf:args:kwargs:))

  }

  // MARK: - FileExistsError

  internal static func fileExistsError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFileExistsError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFileExistsError.getClass, castSelf: Cast.asPyFileExistsError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyFileExistsError.getDict, castSelf: Cast.asPyFileExistsError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyFileExistsError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyFileExistsError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - FileNotFoundError

  internal static func fileNotFoundError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFileNotFoundError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFileNotFoundError.getClass, castSelf: Cast.asPyFileNotFoundError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyFileNotFoundError.getDict, castSelf: Cast.asPyFileNotFoundError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyFileNotFoundError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyFileNotFoundError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - FloatingPointError

  internal static func floatingPointError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFloatingPointError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFloatingPointError.getClass, castSelf: Cast.asPyFloatingPointError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyFloatingPointError.getDict, castSelf: Cast.asPyFloatingPointError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyFloatingPointError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyFloatingPointError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - FutureWarning

  internal static func futureWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyFutureWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyFutureWarning.getClass, castSelf: Cast.asPyFutureWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyFutureWarning.getDict, castSelf: Cast.asPyFutureWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyFutureWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyFutureWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - GeneratorExit

  internal static func generatorExit(_ type: PyType) {
    type.setBuiltinTypeDoc(PyGeneratorExit.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyGeneratorExit.getClass, castSelf: Cast.asPyGeneratorExit)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyGeneratorExit.getDict, castSelf: Cast.asPyGeneratorExit)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyGeneratorExit.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyGeneratorExit.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ImportError

  internal static func importError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyImportError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyImportError.getClass, castSelf: Cast.asPyImportError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyImportError.getDict, castSelf: Cast.asPyImportError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyImportError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyImportError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ImportWarning

  internal static func importWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyImportWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyImportWarning.getClass, castSelf: Cast.asPyImportWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyImportWarning.getDict, castSelf: Cast.asPyImportWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyImportWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyImportWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - IndentationError

  internal static func indentationError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyIndentationError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyIndentationError.getClass, castSelf: Cast.asPyIndentationError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyIndentationError.getDict, castSelf: Cast.asPyIndentationError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyIndentationError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyIndentationError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - IndexError

  internal static func indexError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyIndexError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyIndexError.getClass, castSelf: Cast.asPyIndexError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyIndexError.getDict, castSelf: Cast.asPyIndexError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyIndexError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyIndexError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - InterruptedError

  internal static func interruptedError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyInterruptedError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyInterruptedError.getClass, castSelf: Cast.asPyInterruptedError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyInterruptedError.getDict, castSelf: Cast.asPyInterruptedError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyInterruptedError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyInterruptedError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - IsADirectoryError

  internal static func isADirectoryError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyIsADirectoryError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyIsADirectoryError.getClass, castSelf: Cast.asPyIsADirectoryError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyIsADirectoryError.getDict, castSelf: Cast.asPyIsADirectoryError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyIsADirectoryError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyIsADirectoryError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - KeyError

  internal static func keyError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyKeyError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyKeyError.getClass, castSelf: Cast.asPyKeyError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyKeyError.getDict, castSelf: Cast.asPyKeyError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyKeyError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyKeyError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - KeyboardInterrupt

  internal static func keyboardInterrupt(_ type: PyType) {
    type.setBuiltinTypeDoc(PyKeyboardInterrupt.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyKeyboardInterrupt.getClass, castSelf: Cast.asPyKeyboardInterrupt)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyKeyboardInterrupt.getDict, castSelf: Cast.asPyKeyboardInterrupt)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyKeyboardInterrupt.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyKeyboardInterrupt.pyInit(zelf:args:kwargs:))

  }

  // MARK: - LookupError

  internal static func lookupError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyLookupError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyLookupError.getClass, castSelf: Cast.asPyLookupError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyLookupError.getDict, castSelf: Cast.asPyLookupError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyLookupError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyLookupError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - MemoryError

  internal static func memoryError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyMemoryError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyMemoryError.getClass, castSelf: Cast.asPyMemoryError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyMemoryError.getDict, castSelf: Cast.asPyMemoryError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyMemoryError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyMemoryError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ModuleNotFoundError

  internal static func moduleNotFoundError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyModuleNotFoundError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyModuleNotFoundError.getClass, castSelf: Cast.asPyModuleNotFoundError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyModuleNotFoundError.getDict, castSelf: Cast.asPyModuleNotFoundError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyModuleNotFoundError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyModuleNotFoundError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - NameError

  internal static func nameError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyNameError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyNameError.getClass, castSelf: Cast.asPyNameError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyNameError.getDict, castSelf: Cast.asPyNameError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyNameError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyNameError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - NotADirectoryError

  internal static func notADirectoryError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyNotADirectoryError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyNotADirectoryError.getClass, castSelf: Cast.asPyNotADirectoryError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyNotADirectoryError.getDict, castSelf: Cast.asPyNotADirectoryError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyNotADirectoryError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyNotADirectoryError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - NotImplementedError

  internal static func notImplementedError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyNotImplementedError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyNotImplementedError.getClass, castSelf: Cast.asPyNotImplementedError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyNotImplementedError.getDict, castSelf: Cast.asPyNotImplementedError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyNotImplementedError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyNotImplementedError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - OSError

  internal static func osError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyOSError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyOSError.getClass, castSelf: Cast.asPyOSError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyOSError.getDict, castSelf: Cast.asPyOSError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyOSError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyOSError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - OverflowError

  internal static func overflowError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyOverflowError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyOverflowError.getClass, castSelf: Cast.asPyOverflowError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyOverflowError.getDict, castSelf: Cast.asPyOverflowError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyOverflowError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyOverflowError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - PendingDeprecationWarning

  internal static func pendingDeprecationWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyPendingDeprecationWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyPendingDeprecationWarning.getClass, castSelf: Cast.asPyPendingDeprecationWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyPendingDeprecationWarning.getDict, castSelf: Cast.asPyPendingDeprecationWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyPendingDeprecationWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyPendingDeprecationWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - PermissionError

  internal static func permissionError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyPermissionError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyPermissionError.getClass, castSelf: Cast.asPyPermissionError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyPermissionError.getDict, castSelf: Cast.asPyPermissionError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyPermissionError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyPermissionError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ProcessLookupError

  internal static func processLookupError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyProcessLookupError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyProcessLookupError.getClass, castSelf: Cast.asPyProcessLookupError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyProcessLookupError.getDict, castSelf: Cast.asPyProcessLookupError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyProcessLookupError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyProcessLookupError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - RecursionError

  internal static func recursionError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyRecursionError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyRecursionError.getClass, castSelf: Cast.asPyRecursionError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyRecursionError.getDict, castSelf: Cast.asPyRecursionError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyRecursionError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyRecursionError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ReferenceError

  internal static func referenceError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyReferenceError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyReferenceError.getClass, castSelf: Cast.asPyReferenceError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyReferenceError.getDict, castSelf: Cast.asPyReferenceError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyReferenceError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyReferenceError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ResourceWarning

  internal static func resourceWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyResourceWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyResourceWarning.getClass, castSelf: Cast.asPyResourceWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyResourceWarning.getDict, castSelf: Cast.asPyResourceWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyResourceWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyResourceWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - RuntimeError

  internal static func runtimeError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyRuntimeError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyRuntimeError.getClass, castSelf: Cast.asPyRuntimeError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyRuntimeError.getDict, castSelf: Cast.asPyRuntimeError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyRuntimeError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyRuntimeError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - RuntimeWarning

  internal static func runtimeWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyRuntimeWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyRuntimeWarning.getClass, castSelf: Cast.asPyRuntimeWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyRuntimeWarning.getDict, castSelf: Cast.asPyRuntimeWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyRuntimeWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyRuntimeWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - StopAsyncIteration

  internal static func stopAsyncIteration(_ type: PyType) {
    type.setBuiltinTypeDoc(PyStopAsyncIteration.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyStopAsyncIteration.getClass, castSelf: Cast.asPyStopAsyncIteration)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyStopAsyncIteration.getDict, castSelf: Cast.asPyStopAsyncIteration)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyStopAsyncIteration.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyStopAsyncIteration.pyInit(zelf:args:kwargs:))

  }

  // MARK: - StopIteration

  internal static func stopIteration(_ type: PyType) {
    type.setBuiltinTypeDoc(PyStopIteration.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyStopIteration.getClass, castSelf: Cast.asPyStopIteration)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyStopIteration.getDict, castSelf: Cast.asPyStopIteration)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyStopIteration.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyStopIteration.pyInit(zelf:args:kwargs:))

  }

  // MARK: - SyntaxError

  internal static func syntaxError(_ type: PyType) {
    type.setBuiltinTypeDoc(PySyntaxError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PySyntaxError.getClass, castSelf: Cast.asPySyntaxError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PySyntaxError.getDict, castSelf: Cast.asPySyntaxError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PySyntaxError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PySyntaxError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - SyntaxWarning

  internal static func syntaxWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PySyntaxWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PySyntaxWarning.getClass, castSelf: Cast.asPySyntaxWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PySyntaxWarning.getDict, castSelf: Cast.asPySyntaxWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PySyntaxWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PySyntaxWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - SystemError

  internal static func systemError(_ type: PyType) {
    type.setBuiltinTypeDoc(PySystemError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PySystemError.getClass, castSelf: Cast.asPySystemError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PySystemError.getDict, castSelf: Cast.asPySystemError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PySystemError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PySystemError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - SystemExit

  internal static func systemExit(_ type: PyType) {
    type.setBuiltinTypeDoc(PySystemExit.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PySystemExit.getClass, castSelf: Cast.asPySystemExit)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PySystemExit.getDict, castSelf: Cast.asPySystemExit)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PySystemExit.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PySystemExit.pyInit(zelf:args:kwargs:))

  }

  // MARK: - TabError

  internal static func tabError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyTabError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyTabError.getClass, castSelf: Cast.asPyTabError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyTabError.getDict, castSelf: Cast.asPyTabError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyTabError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyTabError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - TimeoutError

  internal static func timeoutError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyTimeoutError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyTimeoutError.getClass, castSelf: Cast.asPyTimeoutError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyTimeoutError.getDict, castSelf: Cast.asPyTimeoutError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyTimeoutError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyTimeoutError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - TypeError

  internal static func typeError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyTypeError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyTypeError.getClass, castSelf: Cast.asPyTypeError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyTypeError.getDict, castSelf: Cast.asPyTypeError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyTypeError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyTypeError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - UnboundLocalError

  internal static func unboundLocalError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyUnboundLocalError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyUnboundLocalError.getClass, castSelf: Cast.asPyUnboundLocalError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnboundLocalError.getDict, castSelf: Cast.asPyUnboundLocalError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyUnboundLocalError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyUnboundLocalError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - UnicodeDecodeError

  internal static func unicodeDecodeError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyUnicodeDecodeError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeDecodeError.getClass, castSelf: Cast.asPyUnicodeDecodeError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeDecodeError.getDict, castSelf: Cast.asPyUnicodeDecodeError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyUnicodeDecodeError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyUnicodeDecodeError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - UnicodeEncodeError

  internal static func unicodeEncodeError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyUnicodeEncodeError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeEncodeError.getClass, castSelf: Cast.asPyUnicodeEncodeError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeEncodeError.getDict, castSelf: Cast.asPyUnicodeEncodeError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyUnicodeEncodeError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyUnicodeEncodeError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - UnicodeError

  internal static func unicodeError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyUnicodeError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeError.getClass, castSelf: Cast.asPyUnicodeError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeError.getDict, castSelf: Cast.asPyUnicodeError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyUnicodeError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyUnicodeError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - UnicodeTranslateError

  internal static func unicodeTranslateError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyUnicodeTranslateError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeTranslateError.getClass, castSelf: Cast.asPyUnicodeTranslateError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeTranslateError.getDict, castSelf: Cast.asPyUnicodeTranslateError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyUnicodeTranslateError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyUnicodeTranslateError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - UnicodeWarning

  internal static func unicodeWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyUnicodeWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeWarning.getClass, castSelf: Cast.asPyUnicodeWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeWarning.getDict, castSelf: Cast.asPyUnicodeWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyUnicodeWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyUnicodeWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - UserWarning

  internal static func userWarning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyUserWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyUserWarning.getClass, castSelf: Cast.asPyUserWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyUserWarning.getDict, castSelf: Cast.asPyUserWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyUserWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyUserWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ValueError

  internal static func valueError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyValueError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyValueError.getClass, castSelf: Cast.asPyValueError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyValueError.getDict, castSelf: Cast.asPyValueError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyValueError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyValueError.pyInit(zelf:args:kwargs:))

  }

  // MARK: - Warning

  internal static func warning(_ type: PyType) {
    type.setBuiltinTypeDoc(PyWarning.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyWarning.getClass, castSelf: Cast.asPyWarning)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyWarning.getDict, castSelf: Cast.asPyWarning)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyWarning.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyWarning.pyInit(zelf:args:kwargs:))

  }

  // MARK: - ZeroDivisionError

  internal static func zeroDivisionError(_ type: PyType) {
    type.setBuiltinTypeDoc(PyZeroDivisionError.doc)
    type.setFlag(.default)
    type.setFlag(.baseType)
    type.setFlag(.hasGC)

    let dict = type.getDict()
    dict["__class__"] = PyProperty.wrap(name: "__class__", doc: nil, get: PyZeroDivisionError.getClass, castSelf: Cast.asPyZeroDivisionError)
    dict["__dict__"] = PyProperty.wrap(name: "__dict__", doc: nil, get: PyZeroDivisionError.getDict, castSelf: Cast.asPyZeroDivisionError)


    dict["__new__"] = PyBuiltinFunction.wrapNew(typeName: "__new__", doc: nil, fn: PyZeroDivisionError.pyNew(type:args:kwargs:))
    dict["__init__"] = PyBuiltinFunction.wrapInit(typeName: "__init__", doc: nil, fn: PyZeroDivisionError.pyInit(zelf:args:kwargs:))

  }
}