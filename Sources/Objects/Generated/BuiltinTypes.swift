}
// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable trailing_comma
// swiftlint:disable vertical_whitespace

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

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

public final class BuiltinTypes {

  // MARK: - Properties

  public let object: PyType
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
  internal init() {
    // Requirements (for 'self.object' and 'self.type'):
    // 1. 'type' inherits from 'object'
    // 2. both 'type' and 'object' are instances of 'type'
    self.object = PyType.initObjectType()
    self.type = PyType.initTypeType(objectType: self.object)
    self.object.setType(to: self.type)
    self.type.setType(to: self.type)

    // 'self.bool' has to be last because it uses 'self.int' as base!
    self.builtinFunction = PyType.initBuiltinType(name: "builtinFunction", type: self.type, base: self.object)
    self.builtinMethod = PyType.initBuiltinType(name: "builtinMethod", type: self.type, base: self.object)
    self.bytearray = PyType.initBuiltinType(name: "bytearray", type: self.type, base: self.object)
    self.bytearray_iterator = PyType.initBuiltinType(name: "bytearray_iterator", type: self.type, base: self.object)
    self.bytes = PyType.initBuiltinType(name: "bytes", type: self.type, base: self.object)
    self.bytes_iterator = PyType.initBuiltinType(name: "bytes_iterator", type: self.type, base: self.object)
    self.callable_iterator = PyType.initBuiltinType(name: "callable_iterator", type: self.type, base: self.object)
    self.cell = PyType.initBuiltinType(name: "cell", type: self.type, base: self.object)
    self.classmethod = PyType.initBuiltinType(name: "classmethod", type: self.type, base: self.object)
    self.code = PyType.initBuiltinType(name: "code", type: self.type, base: self.object)
    self.complex = PyType.initBuiltinType(name: "complex", type: self.type, base: self.object)
    self.dict = PyType.initBuiltinType(name: "dict", type: self.type, base: self.object)
    self.dict_itemiterator = PyType.initBuiltinType(name: "dict_itemiterator", type: self.type, base: self.object)
    self.dict_items = PyType.initBuiltinType(name: "dict_items", type: self.type, base: self.object)
    self.dict_keyiterator = PyType.initBuiltinType(name: "dict_keyiterator", type: self.type, base: self.object)
    self.dict_keys = PyType.initBuiltinType(name: "dict_keys", type: self.type, base: self.object)
    self.dict_valueiterator = PyType.initBuiltinType(name: "dict_valueiterator", type: self.type, base: self.object)
    self.dict_values = PyType.initBuiltinType(name: "dict_values", type: self.type, base: self.object)
    self.ellipsis = PyType.initBuiltinType(name: "ellipsis", type: self.type, base: self.object)
    self.enumerate = PyType.initBuiltinType(name: "enumerate", type: self.type, base: self.object)
    self.filter = PyType.initBuiltinType(name: "filter", type: self.type, base: self.object)
    self.float = PyType.initBuiltinType(name: "float", type: self.type, base: self.object)
    self.frame = PyType.initBuiltinType(name: "frame", type: self.type, base: self.object)
    self.frozenset = PyType.initBuiltinType(name: "frozenset", type: self.type, base: self.object)
    self.function = PyType.initBuiltinType(name: "function", type: self.type, base: self.object)
    self.int = PyType.initBuiltinType(name: "int", type: self.type, base: self.object)
    self.iterator = PyType.initBuiltinType(name: "iterator", type: self.type, base: self.object)
    self.list = PyType.initBuiltinType(name: "list", type: self.type, base: self.object)
    self.list_iterator = PyType.initBuiltinType(name: "list_iterator", type: self.type, base: self.object)
    self.list_reverseiterator = PyType.initBuiltinType(name: "list_reverseiterator", type: self.type, base: self.object)
    self.map = PyType.initBuiltinType(name: "map", type: self.type, base: self.object)
    self.method = PyType.initBuiltinType(name: "method", type: self.type, base: self.object)
    self.module = PyType.initBuiltinType(name: "module", type: self.type, base: self.object)
    self.simpleNamespace = PyType.initBuiltinType(name: "types.SimpleNamespace", type: self.type, base: self.object)
    self.none = PyType.initBuiltinType(name: "NoneType", type: self.type, base: self.object)
    self.notImplemented = PyType.initBuiltinType(name: "NotImplementedType", type: self.type, base: self.object)
    self.property = PyType.initBuiltinType(name: "property", type: self.type, base: self.object)
    self.range = PyType.initBuiltinType(name: "range", type: self.type, base: self.object)
    self.range_iterator = PyType.initBuiltinType(name: "range_iterator", type: self.type, base: self.object)
    self.reversed = PyType.initBuiltinType(name: "reversed", type: self.type, base: self.object)
    self.set = PyType.initBuiltinType(name: "set", type: self.type, base: self.object)
    self.set_iterator = PyType.initBuiltinType(name: "set_iterator", type: self.type, base: self.object)
    self.slice = PyType.initBuiltinType(name: "slice", type: self.type, base: self.object)
    self.staticmethod = PyType.initBuiltinType(name: "staticmethod", type: self.type, base: self.object)
    self.str = PyType.initBuiltinType(name: "str", type: self.type, base: self.object)
    self.str_iterator = PyType.initBuiltinType(name: "str_iterator", type: self.type, base: self.object)
    self.`super` = PyType.initBuiltinType(name: "super", type: self.type, base: self.object)
    self.textFile = PyType.initBuiltinType(name: "TextFile", type: self.type, base: self.object)
    self.tuple = PyType.initBuiltinType(name: "tuple", type: self.type, base: self.object)
    self.tuple_iterator = PyType.initBuiltinType(name: "tuple_iterator", type: self.type, base: self.object)
    self.zip = PyType.initBuiltinType(name: "zip", type: self.type, base: self.object)
    self.bool = PyType.initBuiltinType(name: "bool", type: self.type, base: self.int)
  }

  // MARK: - Stage 2 - fill __dict__

  /// This function finalizes init of all of the stored types.
  /// (see comment at the top of this file)
  ///
  /// For example it will:
  /// - set type flags
  /// - add `__doc__`
  /// - fill `__dict__`
  internal func fill__dict__() {
    self.fillObject()
    self.fillBool()
    self.fillBuiltinFunction()
    self.fillBuiltinMethod()
    self.fillByteArray()
    self.fillByteArrayIterator()
    self.fillBytes()
    self.fillBytesIterator()
    self.fillCallableIterator()
    self.fillCell()
    self.fillClassMethod()
    self.fillCode()
    self.fillComplex()
    self.fillDict()
    self.fillDictItemIterator()
    self.fillDictItems()
    self.fillDictKeyIterator()
    self.fillDictKeys()
    self.fillDictValueIterator()
    self.fillDictValues()
    self.fillEllipsis()
    self.fillEnumerate()
    self.fillFilter()
    self.fillFloat()
    self.fillFrame()
    self.fillFrozenSet()
    self.fillFunction()
    self.fillInt()
    self.fillIterator()
    self.fillList()
    self.fillListIterator()
    self.fillListReverseIterator()
    self.fillMap()
    self.fillMethod()
    self.fillModule()
    self.fillNamespace()
    self.fillNone()
    self.fillNotImplemented()
    self.fillProperty()
    self.fillRange()
    self.fillRangeIterator()
    self.fillReversed()
    self.fillSet()
    self.fillSetIterator()
    self.fillSlice()
    self.fillStaticMethod()
    self.fillString()
    self.fillStringIterator()
    self.fillSuper()
    self.fillTextFile()
    self.fillTuple()
    self.fillTupleIterator()
    self.fillType()
    self.fillZip()
  }

  // MARK: - All

  internal var all: [PyType] {
    return [
      self.object,
      self.bool,
      self.builtinFunction,
      self.builtinMethod,
      self.bytearray,
      self.bytearray_iterator,
      self.bytes,
      self.bytes_iterator,
      self.callable_iterator,
      self.cell,
      self.classmethod,
      self.code,
      self.complex,
      self.dict,
      self.dict_itemiterator,
      self.dict_items,
      self.dict_keyiterator,
      self.dict_keys,
      self.dict_valueiterator,
      self.dict_values,
      self.ellipsis,
      self.enumerate,
      self.filter,
      self.float,
      self.frame,
      self.frozenset,
      self.function,
      self.int,
      self.iterator,
      self.list,
      self.list_iterator,
      self.list_reverseiterator,
      self.map,
      self.method,
      self.module,
      self.simpleNamespace,
      self.none,
      self.notImplemented,
      self.property,
      self.range,
      self.range_iterator,
      self.reversed,
      self.set,
      self.set_iterator,
      self.slice,
      self.staticmethod,
      self.str,
      self.str_iterator,
      self.`super`,
      self.textFile,
      self.tuple,
      self.tuple_iterator,
      self.type,
      self.zip,
    ]
  }

  // MARK: - Cast helper

  /// Basically:
  /// We hold 'PyObjects' on stack.
  /// We need to call Swift method that needs specific 'self' type.
  /// This method is responsible for downcasting 'PyObject' -> specific Swift type.
  private static func cast<T>(_ object: PyObject,
                              as type: T.Type,
                              typeName: String,
                              methodName: String) -> PyResult<T> {
    if let v = object as? T {
      return .value(v)
    }

    return .typeError(
      "descriptor '\(methodName)' requires a '\(typeName)' object " +
      "but received a '\(object.typeName)'"
    )
  }

  // MARK: - Object

  func fillObject() {
    let type = self.object
    type.setBuiltinTypeDoc(PyObjectType.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setLayout(.PyObject)

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyObjectType.isEqual(zelf:other:)))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyObjectType.isNotEqual(zelf:other:)))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyObjectType.isLess(zelf:other:)))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyObjectType.isLessEqual(zelf:other:)))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyObjectType.isGreater(zelf:other:)))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyObjectType.isGreaterEqual(zelf:other:)))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyObjectType.hash(zelf:)))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyObjectType.repr(zelf:)))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyObjectType.str(zelf:)))
    insert(type: type, name: "__format__", value: PyBuiltinFunction.wrap(name: "__format__", doc: nil, fn: PyObjectType.format(zelf:spec:)))
    insert(type: type, name: "__class__", value: PyBuiltinFunction.wrap(name: "__class__", doc: nil, fn: PyObjectType.getClass(zelf:)))
    insert(type: type, name: "__dir__", value: PyBuiltinFunction.wrap(name: "__dir__", doc: nil, fn: PyObjectType.dir(zelf:)))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyObjectType.getAttribute(zelf:name:)))
    insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyObjectType.setAttribute(zelf:name:value:)))
    insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyObjectType.delAttribute(zelf:name:)))
    insert(type: type, name: "__subclasshook__", value: PyBuiltinFunction.wrap(name: "__subclasshook__", doc: nil, fn: PyObjectType.subclasshook(zelf:)))
    insert(type: type, name: "__init_subclass__", value: PyBuiltinFunction.wrap(name: "__init_subclass__", doc: nil, fn: PyObjectType.initSubclass(zelf:)))
    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyObjectType.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyObjectType.pyInit(zelf:args:kwargs:)))
  }

  private static func asObject(_ object: PyObject, methodName: String) -> PyResult<PyObject> {
    return Self.cast(
      object,
      as: PyObject.self,
      typeName: "object",
      methodName: methodName
    )
  }

  // MARK: - Bool

  func fillBool() {
    let type = self.bool
    type.setBuiltinTypeDoc(PyBool.doc)
    type.setFlag(.default)
    type.setLayout(.PyBool)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBool.getClass, castSelf: Self.asBool))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBool.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBool.repr, castSelf: Self.asBool))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBool.str, castSelf: Self.asBool))
    insert(type: type, name: "__and__", value: PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PyBool.and(_:), castSelf: Self.asBool))
    insert(type: type, name: "__rand__", value: PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PyBool.rand(_:), castSelf: Self.asBool))
    insert(type: type, name: "__or__", value: PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PyBool.or(_:), castSelf: Self.asBool))
    insert(type: type, name: "__ror__", value: PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PyBool.ror(_:), castSelf: Self.asBool))
    insert(type: type, name: "__xor__", value: PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PyBool.xor(_:), castSelf: Self.asBool))
    insert(type: type, name: "__rxor__", value: PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PyBool.rxor(_:), castSelf: Self.asBool))
  }

  private static func asBool(_ object: PyObject, methodName: String) -> PyResult<PyBool> {
    return Self.cast(
      object,
      as: PyBool.self,
      typeName: "bool",
      methodName: methodName
    )
  }

  // MARK: - BuiltinFunction

  func fillBuiltinFunction() {
    let type = self.builtinFunction
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBuiltinFunction)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBuiltinFunction.getClass, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__name__", value: PyProperty.wrap(name: "__name__", doc: nil, get: PyBuiltinFunction.getName, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__qualname__", value: PyProperty.wrap(name: "__qualname__", doc: nil, get: PyBuiltinFunction.getQualname, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__text_signature__", value: PyProperty.wrap(name: "__text_signature__", doc: nil, get: PyBuiltinFunction.getTextSignature, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__module__", value: PyProperty.wrap(name: "__module__", doc: nil, get: PyBuiltinFunction.getModule, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__self__", value: PyProperty.wrap(name: "__self__", doc: nil, get: PyBuiltinFunction.getSelf, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyBuiltinFunction.isEqual(_:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyBuiltinFunction.isNotEqual(_:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyBuiltinFunction.isLess(_:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyBuiltinFunction.isLessEqual(_:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyBuiltinFunction.isGreater(_:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyBuiltinFunction.isGreaterEqual(_:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyBuiltinFunction.hash, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBuiltinFunction.repr, castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBuiltinFunction.getAttribute(name:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyBuiltinFunction.get(object:type:), castSelf: Self.asBuiltinFunction))
    insert(type: type, name: "__call__", value: PyBuiltinFunction.wrap(name: "__call__", doc: nil, fn: PyBuiltinFunction.call(args:kwargs:), castSelf: Self.asBuiltinFunction))
  }

  private static func asBuiltinFunction(_ object: PyObject, methodName: String) -> PyResult<PyBuiltinFunction> {
    return Self.cast(
      object,
      as: PyBuiltinFunction.self,
      typeName: "builtinFunction",
      methodName: methodName
    )
  }

  // MARK: - BuiltinMethod

  func fillBuiltinMethod() {
    let type = self.builtinMethod
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBuiltinMethod)

    insert(type: type, name: "__name__", value: PyProperty.wrap(name: "__name__", doc: nil, get: PyBuiltinMethod.getName, castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__qualname__", value: PyProperty.wrap(name: "__qualname__", doc: nil, get: PyBuiltinMethod.getQualname, castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__text_signature__", value: PyProperty.wrap(name: "__text_signature__", doc: nil, get: PyBuiltinMethod.getTextSignature, castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__module__", value: PyProperty.wrap(name: "__module__", doc: nil, get: PyBuiltinMethod.getModule, castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__self__", value: PyProperty.wrap(name: "__self__", doc: nil, get: PyBuiltinMethod.getSelf, castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyBuiltinMethod.isEqual(_:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyBuiltinMethod.isNotEqual(_:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyBuiltinMethod.isLess(_:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyBuiltinMethod.isLessEqual(_:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyBuiltinMethod.isGreater(_:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyBuiltinMethod.isGreaterEqual(_:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyBuiltinMethod.hash, castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBuiltinMethod.repr, castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBuiltinMethod.getAttribute(name:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyBuiltinMethod.get(object:type:), castSelf: Self.asBuiltinMethod))
    insert(type: type, name: "__call__", value: PyBuiltinFunction.wrap(name: "__call__", doc: nil, fn: PyBuiltinMethod.call(args:kwargs:), castSelf: Self.asBuiltinMethod))
  }

  private static func asBuiltinMethod(_ object: PyObject, methodName: String) -> PyResult<PyBuiltinMethod> {
    return Self.cast(
      object,
      as: PyBuiltinMethod.self,
      typeName: "builtinMethod",
      methodName: methodName
    )
  }

  // MARK: - ByteArray

  func fillByteArray() {
    let type = self.bytearray
    type.setBuiltinTypeDoc(PyByteArray.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setLayout(.PyByteArray)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyByteArray.getClass, castSelf: Self.asByteArray))

    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyByteArray.pyInit(zelf:args:kwargs:)))
    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyByteArray.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyByteArray.isEqual(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyByteArray.isNotEqual(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyByteArray.isLess(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyByteArray.isLessEqual(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyByteArray.isGreater(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyByteArray.isGreaterEqual(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyByteArray.hash, castSelf: Self.asByteArray))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyByteArray.repr, castSelf: Self.asByteArray))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyByteArray.str, castSelf: Self.asByteArray))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyByteArray.getAttribute(name:), castSelf: Self.asByteArray))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyByteArray.getLength, castSelf: Self.asByteArray))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyByteArray.contains(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__getitem__", value: PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyByteArray.getItem(at:), castSelf: Self.asByteArray))
    insert(type: type, name: "isalnum", value: PyBuiltinFunction.wrap(name: "isalnum", doc: PyByteArray.isalnumDoc, fn: PyByteArray.isAlphaNumeric, castSelf: Self.asByteArray))
    insert(type: type, name: "isalpha", value: PyBuiltinFunction.wrap(name: "isalpha", doc: PyByteArray.isalphaDoc, fn: PyByteArray.isAlpha, castSelf: Self.asByteArray))
    insert(type: type, name: "isascii", value: PyBuiltinFunction.wrap(name: "isascii", doc: PyByteArray.isasciiDoc, fn: PyByteArray.isAscii, castSelf: Self.asByteArray))
    insert(type: type, name: "isdigit", value: PyBuiltinFunction.wrap(name: "isdigit", doc: PyByteArray.isdigitDoc, fn: PyByteArray.isDigit, castSelf: Self.asByteArray))
    insert(type: type, name: "islower", value: PyBuiltinFunction.wrap(name: "islower", doc: PyByteArray.islowerDoc, fn: PyByteArray.isLower, castSelf: Self.asByteArray))
    insert(type: type, name: "isspace", value: PyBuiltinFunction.wrap(name: "isspace", doc: PyByteArray.isspaceDoc, fn: PyByteArray.isSpace, castSelf: Self.asByteArray))
    insert(type: type, name: "istitle", value: PyBuiltinFunction.wrap(name: "istitle", doc: PyByteArray.istitleDoc, fn: PyByteArray.isTitle, castSelf: Self.asByteArray))
    insert(type: type, name: "isupper", value: PyBuiltinFunction.wrap(name: "isupper", doc: PyByteArray.isupperDoc, fn: PyByteArray.isUpper, castSelf: Self.asByteArray))
    insert(type: type, name: "startswith", value: PyBuiltinFunction.wrap(name: "startswith", doc: PyByteArray.startswithDoc, fn: PyByteArray.startsWith(_:start:end:), castSelf: Self.asByteArray))
    insert(type: type, name: "endswith", value: PyBuiltinFunction.wrap(name: "endswith", doc: PyByteArray.endswithDoc, fn: PyByteArray.endsWith(_:start:end:), castSelf: Self.asByteArray))
    insert(type: type, name: "strip", value: PyBuiltinFunction.wrap(name: "strip", doc: PyByteArray.stripDoc, fn: PyByteArray.strip(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "lstrip", value: PyBuiltinFunction.wrap(name: "lstrip", doc: PyByteArray.lstripDoc, fn: PyByteArray.lstrip(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "rstrip", value: PyBuiltinFunction.wrap(name: "rstrip", doc: PyByteArray.rstripDoc, fn: PyByteArray.rstrip(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "find", value: PyBuiltinFunction.wrap(name: "find", doc: PyByteArray.findDoc, fn: PyByteArray.find(_:start:end:), castSelf: Self.asByteArray))
    insert(type: type, name: "rfind", value: PyBuiltinFunction.wrap(name: "rfind", doc: PyByteArray.rfindDoc, fn: PyByteArray.rfind(_:start:end:), castSelf: Self.asByteArray))
    insert(type: type, name: "index", value: PyBuiltinFunction.wrap(name: "index", doc: PyByteArray.indexDoc, fn: PyByteArray.index(of:start:end:), castSelf: Self.asByteArray))
    insert(type: type, name: "rindex", value: PyBuiltinFunction.wrap(name: "rindex", doc: PyByteArray.rindexDoc, fn: PyByteArray.rindex(_:start:end:), castSelf: Self.asByteArray))
    insert(type: type, name: "lower", value: PyBuiltinFunction.wrap(name: "lower", doc: nil, fn: PyByteArray.lower, castSelf: Self.asByteArray))
    insert(type: type, name: "upper", value: PyBuiltinFunction.wrap(name: "upper", doc: nil, fn: PyByteArray.upper, castSelf: Self.asByteArray))
    insert(type: type, name: "title", value: PyBuiltinFunction.wrap(name: "title", doc: nil, fn: PyByteArray.title, castSelf: Self.asByteArray))
    insert(type: type, name: "swapcase", value: PyBuiltinFunction.wrap(name: "swapcase", doc: nil, fn: PyByteArray.swapcase, castSelf: Self.asByteArray))
    insert(type: type, name: "capitalize", value: PyBuiltinFunction.wrap(name: "capitalize", doc: nil, fn: PyByteArray.capitalize, castSelf: Self.asByteArray))
    insert(type: type, name: "center", value: PyBuiltinFunction.wrap(name: "center", doc: nil, fn: PyByteArray.center(width:fillChar:), castSelf: Self.asByteArray))
    insert(type: type, name: "ljust", value: PyBuiltinFunction.wrap(name: "ljust", doc: nil, fn: PyByteArray.ljust(width:fillChar:), castSelf: Self.asByteArray))
    insert(type: type, name: "rjust", value: PyBuiltinFunction.wrap(name: "rjust", doc: nil, fn: PyByteArray.rjust(width:fillChar:), castSelf: Self.asByteArray))
    insert(type: type, name: "split", value: PyBuiltinFunction.wrap(name: "split", doc: nil, fn: PyByteArray.split(args:kwargs:), castSelf: Self.asByteArray))
    insert(type: type, name: "rsplit", value: PyBuiltinFunction.wrap(name: "rsplit", doc: nil, fn: PyByteArray.rsplit(args:kwargs:), castSelf: Self.asByteArray))
    insert(type: type, name: "splitlines", value: PyBuiltinFunction.wrap(name: "splitlines", doc: nil, fn: PyByteArray.splitLines(args:kwargs:), castSelf: Self.asByteArray))
    insert(type: type, name: "partition", value: PyBuiltinFunction.wrap(name: "partition", doc: nil, fn: PyByteArray.partition(separator:), castSelf: Self.asByteArray))
    insert(type: type, name: "rpartition", value: PyBuiltinFunction.wrap(name: "rpartition", doc: nil, fn: PyByteArray.rpartition(separator:), castSelf: Self.asByteArray))
    insert(type: type, name: "expandtabs", value: PyBuiltinFunction.wrap(name: "expandtabs", doc: nil, fn: PyByteArray.expandTabs(tabSize:), castSelf: Self.asByteArray))
    insert(type: type, name: "count", value: PyBuiltinFunction.wrap(name: "count", doc: PyByteArray.countDoc, fn: PyByteArray.count(_:start:end:), castSelf: Self.asByteArray))
    insert(type: type, name: "join", value: PyBuiltinFunction.wrap(name: "join", doc: nil, fn: PyByteArray.join(iterable:), castSelf: Self.asByteArray))
    insert(type: type, name: "replace", value: PyBuiltinFunction.wrap(name: "replace", doc: nil, fn: PyByteArray.replace(old:new:count:), castSelf: Self.asByteArray))
    insert(type: type, name: "zfill", value: PyBuiltinFunction.wrap(name: "zfill", doc: nil, fn: PyByteArray.zfill(width:), castSelf: Self.asByteArray))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyByteArray.add(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyByteArray.mul(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyByteArray.rmul(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyByteArray.iter, castSelf: Self.asByteArray))
    insert(type: type, name: "append", value: PyBuiltinFunction.wrap(name: "append", doc: PyByteArray.appendDoc, fn: PyByteArray.append(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "extend", value: PyBuiltinFunction.wrap(name: "extend", doc: nil, fn: PyByteArray.extend(iterable:), castSelf: Self.asByteArray))
    insert(type: type, name: "insert", value: PyBuiltinFunction.wrap(name: "insert", doc: PyByteArray.insertDoc, fn: PyByteArray.insert(at:item:), castSelf: Self.asByteArray))
    insert(type: type, name: "remove", value: PyBuiltinFunction.wrap(name: "remove", doc: PyByteArray.removeDoc, fn: PyByteArray.remove(_:), castSelf: Self.asByteArray))
    insert(type: type, name: "pop", value: PyBuiltinFunction.wrap(name: "pop", doc: PyByteArray.popDoc, fn: PyByteArray.pop(index:), castSelf: Self.asByteArray))
    insert(type: type, name: "__setitem__", value: PyBuiltinFunction.wrap(name: "__setitem__", doc: nil, fn: PyByteArray.setItem(at:to:), castSelf: Self.asByteArray))
    insert(type: type, name: "__delitem__", value: PyBuiltinFunction.wrap(name: "__delitem__", doc: nil, fn: PyByteArray.delItem(at:), castSelf: Self.asByteArray))
    insert(type: type, name: "clear", value: PyBuiltinFunction.wrap(name: "clear", doc: PyByteArray.clearDoc, fn: PyByteArray.clear, castSelf: Self.asByteArray))
    insert(type: type, name: "reverse", value: PyBuiltinFunction.wrap(name: "reverse", doc: PyByteArray.reverseDoc, fn: PyByteArray.reverse, castSelf: Self.asByteArray))
    insert(type: type, name: "copy", value: PyBuiltinFunction.wrap(name: "copy", doc: PyByteArray.copyDoc, fn: PyByteArray.copy, castSelf: Self.asByteArray))
  }

  private static func asByteArray(_ object: PyObject, methodName: String) -> PyResult<PyByteArray> {
    return Self.cast(
      object,
      as: PyByteArray.self,
      typeName: "bytearray",
      methodName: methodName
    )
  }

  // MARK: - ByteArrayIterator

  func fillByteArrayIterator() {
    let type = self.bytearray_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyByteArrayIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyByteArrayIterator.getClass, castSelf: Self.asByteArrayIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyByteArrayIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyByteArrayIterator.getAttribute(name:), castSelf: Self.asByteArrayIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyByteArrayIterator.iter, castSelf: Self.asByteArrayIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyByteArrayIterator.next, castSelf: Self.asByteArrayIterator))
  }

  private static func asByteArrayIterator(_ object: PyObject, methodName: String) -> PyResult<PyByteArrayIterator> {
    return Self.cast(
      object,
      as: PyByteArrayIterator.self,
      typeName: "bytearray_iterator",
      methodName: methodName
    )
  }

  // MARK: - Bytes

  func fillBytes() {
    let type = self.bytes
    type.setBuiltinTypeDoc(PyBytes.doc)
    type.setFlag(.baseType)
    type.setFlag(.bytesSubclass)
    type.setFlag(.default)
    type.setLayout(.PyBytes)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBytes.getClass, castSelf: Self.asBytes))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBytes.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyBytes.isEqual(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyBytes.isNotEqual(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyBytes.isLess(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyBytes.isLessEqual(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyBytes.isGreater(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyBytes.isGreaterEqual(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyBytes.hash, castSelf: Self.asBytes))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBytes.repr, castSelf: Self.asBytes))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBytes.str, castSelf: Self.asBytes))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBytes.getAttribute(name:), castSelf: Self.asBytes))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyBytes.getLength, castSelf: Self.asBytes))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyBytes.contains(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__getitem__", value: PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyBytes.getItem(at:), castSelf: Self.asBytes))
    insert(type: type, name: "isalnum", value: PyBuiltinFunction.wrap(name: "isalnum", doc: PyBytes.isalnumDoc, fn: PyBytes.isAlphaNumeric, castSelf: Self.asBytes))
    insert(type: type, name: "isalpha", value: PyBuiltinFunction.wrap(name: "isalpha", doc: PyBytes.isalphaDoc, fn: PyBytes.isAlpha, castSelf: Self.asBytes))
    insert(type: type, name: "isascii", value: PyBuiltinFunction.wrap(name: "isascii", doc: PyBytes.isasciiDoc, fn: PyBytes.isAscii, castSelf: Self.asBytes))
    insert(type: type, name: "isdigit", value: PyBuiltinFunction.wrap(name: "isdigit", doc: PyBytes.isdigitDoc, fn: PyBytes.isDigit, castSelf: Self.asBytes))
    insert(type: type, name: "islower", value: PyBuiltinFunction.wrap(name: "islower", doc: PyBytes.islowerDoc, fn: PyBytes.isLower, castSelf: Self.asBytes))
    insert(type: type, name: "isspace", value: PyBuiltinFunction.wrap(name: "isspace", doc: PyBytes.isspaceDoc, fn: PyBytes.isSpace, castSelf: Self.asBytes))
    insert(type: type, name: "istitle", value: PyBuiltinFunction.wrap(name: "istitle", doc: PyBytes.istitleDoc, fn: PyBytes.isTitle, castSelf: Self.asBytes))
    insert(type: type, name: "isupper", value: PyBuiltinFunction.wrap(name: "isupper", doc: PyBytes.isupperDoc, fn: PyBytes.isUpper, castSelf: Self.asBytes))
    insert(type: type, name: "startswith", value: PyBuiltinFunction.wrap(name: "startswith", doc: PyBytes.startswithDoc, fn: PyBytes.startsWith(_:start:end:), castSelf: Self.asBytes))
    insert(type: type, name: "endswith", value: PyBuiltinFunction.wrap(name: "endswith", doc: PyBytes.endswithDoc, fn: PyBytes.endsWith(_:start:end:), castSelf: Self.asBytes))
    insert(type: type, name: "strip", value: PyBuiltinFunction.wrap(name: "strip", doc: PyBytes.stripDoc, fn: PyBytes.strip(_:), castSelf: Self.asBytes))
    insert(type: type, name: "lstrip", value: PyBuiltinFunction.wrap(name: "lstrip", doc: PyBytes.lstripDoc, fn: PyBytes.lstrip(_:), castSelf: Self.asBytes))
    insert(type: type, name: "rstrip", value: PyBuiltinFunction.wrap(name: "rstrip", doc: PyBytes.rstripDoc, fn: PyBytes.rstrip(_:), castSelf: Self.asBytes))
    insert(type: type, name: "find", value: PyBuiltinFunction.wrap(name: "find", doc: PyBytes.findDoc, fn: PyBytes.find(_:start:end:), castSelf: Self.asBytes))
    insert(type: type, name: "rfind", value: PyBuiltinFunction.wrap(name: "rfind", doc: PyBytes.rfindDoc, fn: PyBytes.rfind(_:start:end:), castSelf: Self.asBytes))
    insert(type: type, name: "index", value: PyBuiltinFunction.wrap(name: "index", doc: PyBytes.indexDoc, fn: PyBytes.index(of:start:end:), castSelf: Self.asBytes))
    insert(type: type, name: "rindex", value: PyBuiltinFunction.wrap(name: "rindex", doc: PyBytes.rindexDoc, fn: PyBytes.rindex(_:start:end:), castSelf: Self.asBytes))
    insert(type: type, name: "lower", value: PyBuiltinFunction.wrap(name: "lower", doc: nil, fn: PyBytes.lower, castSelf: Self.asBytes))
    insert(type: type, name: "upper", value: PyBuiltinFunction.wrap(name: "upper", doc: nil, fn: PyBytes.upper, castSelf: Self.asBytes))
    insert(type: type, name: "title", value: PyBuiltinFunction.wrap(name: "title", doc: nil, fn: PyBytes.title, castSelf: Self.asBytes))
    insert(type: type, name: "swapcase", value: PyBuiltinFunction.wrap(name: "swapcase", doc: nil, fn: PyBytes.swapcase, castSelf: Self.asBytes))
    insert(type: type, name: "capitalize", value: PyBuiltinFunction.wrap(name: "capitalize", doc: nil, fn: PyBytes.capitalize, castSelf: Self.asBytes))
    insert(type: type, name: "center", value: PyBuiltinFunction.wrap(name: "center", doc: nil, fn: PyBytes.center(width:fillChar:), castSelf: Self.asBytes))
    insert(type: type, name: "ljust", value: PyBuiltinFunction.wrap(name: "ljust", doc: nil, fn: PyBytes.ljust(width:fillChar:), castSelf: Self.asBytes))
    insert(type: type, name: "rjust", value: PyBuiltinFunction.wrap(name: "rjust", doc: nil, fn: PyBytes.rjust(width:fillChar:), castSelf: Self.asBytes))
    insert(type: type, name: "split", value: PyBuiltinFunction.wrap(name: "split", doc: nil, fn: PyBytes.split(args:kwargs:), castSelf: Self.asBytes))
    insert(type: type, name: "rsplit", value: PyBuiltinFunction.wrap(name: "rsplit", doc: nil, fn: PyBytes.rsplit(args:kwargs:), castSelf: Self.asBytes))
    insert(type: type, name: "splitlines", value: PyBuiltinFunction.wrap(name: "splitlines", doc: nil, fn: PyBytes.splitLines(args:kwargs:), castSelf: Self.asBytes))
    insert(type: type, name: "partition", value: PyBuiltinFunction.wrap(name: "partition", doc: nil, fn: PyBytes.partition(separator:), castSelf: Self.asBytes))
    insert(type: type, name: "rpartition", value: PyBuiltinFunction.wrap(name: "rpartition", doc: nil, fn: PyBytes.rpartition(separator:), castSelf: Self.asBytes))
    insert(type: type, name: "expandtabs", value: PyBuiltinFunction.wrap(name: "expandtabs", doc: nil, fn: PyBytes.expandTabs(tabSize:), castSelf: Self.asBytes))
    insert(type: type, name: "count", value: PyBuiltinFunction.wrap(name: "count", doc: PyBytes.countDoc, fn: PyBytes.count(_:start:end:), castSelf: Self.asBytes))
    insert(type: type, name: "join", value: PyBuiltinFunction.wrap(name: "join", doc: nil, fn: PyBytes.join(iterable:), castSelf: Self.asBytes))
    insert(type: type, name: "replace", value: PyBuiltinFunction.wrap(name: "replace", doc: nil, fn: PyBytes.replace(old:new:count:), castSelf: Self.asBytes))
    insert(type: type, name: "zfill", value: PyBuiltinFunction.wrap(name: "zfill", doc: nil, fn: PyBytes.zfill(width:), castSelf: Self.asBytes))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyBytes.add(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyBytes.mul(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyBytes.rmul(_:), castSelf: Self.asBytes))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyBytes.iter, castSelf: Self.asBytes))
  }

  private static func asBytes(_ object: PyObject, methodName: String) -> PyResult<PyBytes> {
    return Self.cast(
      object,
      as: PyBytes.self,
      typeName: "bytes",
      methodName: methodName
    )
  }

  // MARK: - BytesIterator

  func fillBytesIterator() {
    let type = self.bytes_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBytesIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBytesIterator.getClass, castSelf: Self.asBytesIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBytesIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBytesIterator.getAttribute(name:), castSelf: Self.asBytesIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyBytesIterator.iter, castSelf: Self.asBytesIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyBytesIterator.next, castSelf: Self.asBytesIterator))
  }

  private static func asBytesIterator(_ object: PyObject, methodName: String) -> PyResult<PyBytesIterator> {
    return Self.cast(
      object,
      as: PyBytesIterator.self,
      typeName: "bytes_iterator",
      methodName: methodName
    )
  }

  // MARK: - CallableIterator

  func fillCallableIterator() {
    let type = self.callable_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyCallableIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyCallableIterator.getClass, castSelf: Self.asCallableIterator))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyCallableIterator.getAttribute(name:), castSelf: Self.asCallableIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyCallableIterator.iter, castSelf: Self.asCallableIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyCallableIterator.next, castSelf: Self.asCallableIterator))
  }

  private static func asCallableIterator(_ object: PyObject, methodName: String) -> PyResult<PyCallableIterator> {
    return Self.cast(
      object,
      as: PyCallableIterator.self,
      typeName: "callable_iterator",
      methodName: methodName
    )
  }

  // MARK: - Cell

  func fillCell() {
    let type = self.cell
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyCell)

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyCell.isEqual(_:), castSelf: Self.asCell))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyCell.isNotEqual(_:), castSelf: Self.asCell))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyCell.isLess(_:), castSelf: Self.asCell))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyCell.isLessEqual(_:), castSelf: Self.asCell))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyCell.isGreater(_:), castSelf: Self.asCell))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyCell.isGreaterEqual(_:), castSelf: Self.asCell))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyCell.repr, castSelf: Self.asCell))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyCell.getAttribute(name:), castSelf: Self.asCell))
  }

  private static func asCell(_ object: PyObject, methodName: String) -> PyResult<PyCell> {
    return Self.cast(
      object,
      as: PyCell.self,
      typeName: "cell",
      methodName: methodName
    )
  }

  // MARK: - ClassMethod

  func fillClassMethod() {
    let type = self.classmethod
    type.setBuiltinTypeDoc(PyClassMethod.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyClassMethod)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyClassMethod.getClass, castSelf: Self.asClassMethod))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyClassMethod.getDict, castSelf: Self.asClassMethod))
    insert(type: type, name: "__func__", value: PyProperty.wrap(name: "__func__", doc: nil, get: PyClassMethod.getFunc, castSelf: Self.asClassMethod))

    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyClassMethod.pyInit(zelf:args:kwargs:)))
    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyClassMethod.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyClassMethod.get(object:type:), castSelf: Self.asClassMethod))
    insert(type: type, name: "__isabstractmethod__", value: PyBuiltinFunction.wrap(name: "__isabstractmethod__", doc: nil, fn: PyClassMethod.isAbstractMethod, castSelf: Self.asClassMethod))
  }

  private static func asClassMethod(_ object: PyObject, methodName: String) -> PyResult<PyClassMethod> {
    return Self.cast(
      object,
      as: PyClassMethod.self,
      typeName: "classmethod",
      methodName: methodName
    )
  }

  // MARK: - Code

  func fillCode() {
    let type = self.code
    type.setBuiltinTypeDoc(PyCode.doc)
    type.setFlag(.default)
    type.setLayout(.PyCode)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyCode.getClass, castSelf: Self.asCode))
    insert(type: type, name: "co_name", value: PyProperty.wrap(name: "co_name", doc: nil, get: PyCode.getName, castSelf: Self.asCode))
    insert(type: type, name: "co_filename", value: PyProperty.wrap(name: "co_filename", doc: nil, get: PyCode.getFilename, castSelf: Self.asCode))
    insert(type: type, name: "co_firstlineno", value: PyProperty.wrap(name: "co_firstlineno", doc: nil, get: PyCode.getFirstLineNo, castSelf: Self.asCode))
    insert(type: type, name: "co_argcount", value: PyProperty.wrap(name: "co_argcount", doc: nil, get: PyCode.getArgCount, castSelf: Self.asCode))
    insert(type: type, name: "co_kwonlyargcount", value: PyProperty.wrap(name: "co_kwonlyargcount", doc: nil, get: PyCode.getKwOnlyArgCount, castSelf: Self.asCode))
    insert(type: type, name: "co_nlocals", value: PyProperty.wrap(name: "co_nlocals", doc: nil, get: PyCode.getNLocals, castSelf: Self.asCode))
    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyCode.isEqual(_:), castSelf: Self.asCode))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyCode.isNotEqual(_:), castSelf: Self.asCode))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyCode.isLess(_:), castSelf: Self.asCode))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyCode.isLessEqual(_:), castSelf: Self.asCode))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyCode.isGreater(_:), castSelf: Self.asCode))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyCode.isGreaterEqual(_:), castSelf: Self.asCode))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyCode.hash, castSelf: Self.asCode))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyCode.repr, castSelf: Self.asCode))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyCode.getAttribute(name:), castSelf: Self.asCode))
  }

  private static func asCode(_ object: PyObject, methodName: String) -> PyResult<PyCode> {
    return Self.cast(
      object,
      as: PyCode.self,
      typeName: "code",
      methodName: methodName
    )
  }

  // MARK: - Complex

  func fillComplex() {
    let type = self.complex
    type.setBuiltinTypeDoc(PyComplex.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setLayout(.PyComplex)

    insert(type: type, name: "real", value: PyProperty.wrap(name: "real", doc: nil, get: PyComplex.asReal, castSelf: Self.asComplex))
    insert(type: type, name: "imag", value: PyProperty.wrap(name: "imag", doc: nil, get: PyComplex.asImag, castSelf: Self.asComplex))
    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyComplex.getClass, castSelf: Self.asComplex))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyComplex.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyComplex.isEqual(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyComplex.isNotEqual(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyComplex.isLess(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyComplex.isLessEqual(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyComplex.isGreater(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyComplex.isGreaterEqual(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyComplex.hash, castSelf: Self.asComplex))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyComplex.repr, castSelf: Self.asComplex))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyComplex.str, castSelf: Self.asComplex))
    insert(type: type, name: "__bool__", value: PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyComplex.asBool, castSelf: Self.asComplex))
    insert(type: type, name: "__int__", value: PyBuiltinFunction.wrap(name: "__int__", doc: nil, fn: PyComplex.asInt, castSelf: Self.asComplex))
    insert(type: type, name: "__float__", value: PyBuiltinFunction.wrap(name: "__float__", doc: nil, fn: PyComplex.asFloat, castSelf: Self.asComplex))
    insert(type: type, name: "conjugate", value: PyBuiltinFunction.wrap(name: "conjugate", doc: nil, fn: PyComplex.conjugate, castSelf: Self.asComplex))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyComplex.getAttribute(name:), castSelf: Self.asComplex))
    insert(type: type, name: "__pos__", value: PyBuiltinFunction.wrap(name: "__pos__", doc: nil, fn: PyComplex.positive, castSelf: Self.asComplex))
    insert(type: type, name: "__neg__", value: PyBuiltinFunction.wrap(name: "__neg__", doc: nil, fn: PyComplex.negative, castSelf: Self.asComplex))
    insert(type: type, name: "__abs__", value: PyBuiltinFunction.wrap(name: "__abs__", doc: nil, fn: PyComplex.abs, castSelf: Self.asComplex))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyComplex.add(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__radd__", value: PyBuiltinFunction.wrap(name: "__radd__", doc: nil, fn: PyComplex.radd(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__sub__", value: PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyComplex.sub(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__rsub__", value: PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyComplex.rsub(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyComplex.mul(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyComplex.rmul(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__pow__", value: PyBuiltinFunction.wrap(name: "__pow__", doc: nil, fn: PyComplex.pow(exp:mod:), castSelf: Self.asComplex))
    insert(type: type, name: "__rpow__", value: PyBuiltinFunction.wrap(name: "__rpow__", doc: nil, fn: PyComplex.rpow(base:mod:), castSelf: Self.asComplex))
    insert(type: type, name: "__truediv__", value: PyBuiltinFunction.wrap(name: "__truediv__", doc: nil, fn: PyComplex.truediv(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__rtruediv__", value: PyBuiltinFunction.wrap(name: "__rtruediv__", doc: nil, fn: PyComplex.rtruediv(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__floordiv__", value: PyBuiltinFunction.wrap(name: "__floordiv__", doc: nil, fn: PyComplex.floordiv(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__rfloordiv__", value: PyBuiltinFunction.wrap(name: "__rfloordiv__", doc: nil, fn: PyComplex.rfloordiv(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__mod__", value: PyBuiltinFunction.wrap(name: "__mod__", doc: nil, fn: PyComplex.mod(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__rmod__", value: PyBuiltinFunction.wrap(name: "__rmod__", doc: nil, fn: PyComplex.rmod(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__divmod__", value: PyBuiltinFunction.wrap(name: "__divmod__", doc: nil, fn: PyComplex.divmod(_:), castSelf: Self.asComplex))
    insert(type: type, name: "__rdivmod__", value: PyBuiltinFunction.wrap(name: "__rdivmod__", doc: nil, fn: PyComplex.rdivmod(_:), castSelf: Self.asComplex))
  }

  private static func asComplex(_ object: PyObject, methodName: String) -> PyResult<PyComplex> {
    return Self.cast(
      object,
      as: PyComplex.self,
      typeName: "complex",
      methodName: methodName
    )
  }

  // MARK: - Dict

  func fillDict() {
    let type = self.dict
    type.setBuiltinTypeDoc(PyDict.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.dictSubclass)
    type.setFlag(.hasGC)
    type.setLayout(.PyDict)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDict.getClass, castSelf: Self.asDict))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyDict.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyDict.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyDict.isEqual(_:), castSelf: Self.asDict))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyDict.isNotEqual(_:), castSelf: Self.asDict))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyDict.isLess(_:), castSelf: Self.asDict))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyDict.isLessEqual(_:), castSelf: Self.asDict))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyDict.isGreater(_:), castSelf: Self.asDict))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyDict.isGreaterEqual(_:), castSelf: Self.asDict))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyDict.hash, castSelf: Self.asDict))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDict.repr, castSelf: Self.asDict))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDict.getAttribute(name:), castSelf: Self.asDict))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDict.getLength, castSelf: Self.asDict))
    insert(type: type, name: "__getitem__", value: PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyDict.getItem(at:), castSelf: Self.asDict))
    insert(type: type, name: "__setitem__", value: PyBuiltinFunction.wrap(name: "__setitem__", doc: nil, fn: PyDict.setItem(at:to:), castSelf: Self.asDict))
    insert(type: type, name: "__delitem__", value: PyBuiltinFunction.wrap(name: "__delitem__", doc: nil, fn: PyDict.delItem(at:), castSelf: Self.asDict))
    insert(type: type, name: "get", value: PyBuiltinFunction.wrap(name: "get", doc: PyDict.getWithDefaultDoc, fn: PyDict.getWithDefault(args:kwargs:), castSelf: Self.asDict))
    insert(type: type, name: "setdefault", value: PyBuiltinFunction.wrap(name: "setdefault", doc: PyDict.setWithDefaultDoc, fn: PyDict.setWithDefault(args:kwargs:), castSelf: Self.asDict))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyDict.contains(_:), castSelf: Self.asDict))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDict.iter, castSelf: Self.asDict))
    insert(type: type, name: "clear", value: PyBuiltinFunction.wrap(name: "clear", doc: PyDict.clearDoc, fn: PyDict.clear, castSelf: Self.asDict))
    insert(type: type, name: "update", value: PyBuiltinFunction.wrap(name: "update", doc: nil, fn: PyDict.update(args:kwargs:), castSelf: Self.asDict))
    insert(type: type, name: "copy", value: PyBuiltinFunction.wrap(name: "copy", doc: PyDict.copyDoc, fn: PyDict.copy, castSelf: Self.asDict))
    insert(type: type, name: "pop", value: PyBuiltinFunction.wrap(name: "pop", doc: PyDict.popDoc, fn: PyDict.pop(_:default:), castSelf: Self.asDict))
    insert(type: type, name: "popitem", value: PyBuiltinFunction.wrap(name: "popitem", doc: PyDict.popitemDoc, fn: PyDict.popItem, castSelf: Self.asDict))
    insert(type: type, name: "keys", value: PyBuiltinFunction.wrap(name: "keys", doc: nil, fn: PyDict.keys, castSelf: Self.asDict))
    insert(type: type, name: "items", value: PyBuiltinFunction.wrap(name: "items", doc: nil, fn: PyDict.items, castSelf: Self.asDict))
    insert(type: type, name: "values", value: PyBuiltinFunction.wrap(name: "values", doc: nil, fn: PyDict.values, castSelf: Self.asDict))
  }

  private static func asDict(_ object: PyObject, methodName: String) -> PyResult<PyDict> {
    return Self.cast(
      object,
      as: PyDict.self,
      typeName: "dict",
      methodName: methodName
    )
  }

  // MARK: - DictItemIterator

  func fillDictItemIterator() {
    let type = self.dict_itemiterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyDictItemIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDictItemIterator.getClass, castSelf: Self.asDictItemIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyDictItemIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictItemIterator.getAttribute(name:), castSelf: Self.asDictItemIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictItemIterator.iter, castSelf: Self.asDictItemIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyDictItemIterator.next, castSelf: Self.asDictItemIterator))
  }

  private static func asDictItemIterator(_ object: PyObject, methodName: String) -> PyResult<PyDictItemIterator> {
    return Self.cast(
      object,
      as: PyDictItemIterator.self,
      typeName: "dict_itemiterator",
      methodName: methodName
    )
  }

  // MARK: - DictItems

  func fillDictItems() {
    let type = self.dict_items
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyDictItems)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDictItems.getClass, castSelf: Self.asDictItems))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyDictItems.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyDictItems.isEqual(_:), castSelf: Self.asDictItems))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyDictItems.isNotEqual(_:), castSelf: Self.asDictItems))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyDictItems.isLess(_:), castSelf: Self.asDictItems))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyDictItems.isLessEqual(_:), castSelf: Self.asDictItems))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyDictItems.isGreater(_:), castSelf: Self.asDictItems))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyDictItems.isGreaterEqual(_:), castSelf: Self.asDictItems))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyDictItems.hash, castSelf: Self.asDictItems))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDictItems.repr, castSelf: Self.asDictItems))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictItems.getAttribute(name:), castSelf: Self.asDictItems))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDictItems.getLength, castSelf: Self.asDictItems))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyDictItems.contains(_:), castSelf: Self.asDictItems))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictItems.iter, castSelf: Self.asDictItems))
  }

  private static func asDictItems(_ object: PyObject, methodName: String) -> PyResult<PyDictItems> {
    return Self.cast(
      object,
      as: PyDictItems.self,
      typeName: "dict_items",
      methodName: methodName
    )
  }

  // MARK: - DictKeyIterator

  func fillDictKeyIterator() {
    let type = self.dict_keyiterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyDictKeyIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDictKeyIterator.getClass, castSelf: Self.asDictKeyIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyDictKeyIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictKeyIterator.getAttribute(name:), castSelf: Self.asDictKeyIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictKeyIterator.iter, castSelf: Self.asDictKeyIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyDictKeyIterator.next, castSelf: Self.asDictKeyIterator))
  }

  private static func asDictKeyIterator(_ object: PyObject, methodName: String) -> PyResult<PyDictKeyIterator> {
    return Self.cast(
      object,
      as: PyDictKeyIterator.self,
      typeName: "dict_keyiterator",
      methodName: methodName
    )
  }

  // MARK: - DictKeys

  func fillDictKeys() {
    let type = self.dict_keys
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyDictKeys)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDictKeys.getClass, castSelf: Self.asDictKeys))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyDictKeys.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyDictKeys.isEqual(_:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyDictKeys.isNotEqual(_:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyDictKeys.isLess(_:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyDictKeys.isLessEqual(_:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyDictKeys.isGreater(_:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyDictKeys.isGreaterEqual(_:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyDictKeys.hash, castSelf: Self.asDictKeys))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDictKeys.repr, castSelf: Self.asDictKeys))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictKeys.getAttribute(name:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDictKeys.getLength, castSelf: Self.asDictKeys))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyDictKeys.contains(_:), castSelf: Self.asDictKeys))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictKeys.iter, castSelf: Self.asDictKeys))
  }

  private static func asDictKeys(_ object: PyObject, methodName: String) -> PyResult<PyDictKeys> {
    return Self.cast(
      object,
      as: PyDictKeys.self,
      typeName: "dict_keys",
      methodName: methodName
    )
  }

  // MARK: - DictValueIterator

  func fillDictValueIterator() {
    let type = self.dict_valueiterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyDictValueIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDictValueIterator.getClass, castSelf: Self.asDictValueIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyDictValueIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictValueIterator.getAttribute(name:), castSelf: Self.asDictValueIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictValueIterator.iter, castSelf: Self.asDictValueIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyDictValueIterator.next, castSelf: Self.asDictValueIterator))
  }

  private static func asDictValueIterator(_ object: PyObject, methodName: String) -> PyResult<PyDictValueIterator> {
    return Self.cast(
      object,
      as: PyDictValueIterator.self,
      typeName: "dict_valueiterator",
      methodName: methodName
    )
  }

  // MARK: - DictValues

  func fillDictValues() {
    let type = self.dict_values
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyDictValues)

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyDictValues.repr, castSelf: Self.asDictValues))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyDictValues.getAttribute(name:), castSelf: Self.asDictValues))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyDictValues.getLength, castSelf: Self.asDictValues))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyDictValues.iter, castSelf: Self.asDictValues))
  }

  private static func asDictValues(_ object: PyObject, methodName: String) -> PyResult<PyDictValues> {
    return Self.cast(
      object,
      as: PyDictValues.self,
      typeName: "dict_values",
      methodName: methodName
    )
  }

  // MARK: - Ellipsis

  func fillEllipsis() {
    let type = self.ellipsis
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setLayout(.PyEllipsis)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyEllipsis.getClass, castSelf: Self.asEllipsis))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyEllipsis.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyEllipsis.repr, castSelf: Self.asEllipsis))
    insert(type: type, name: "__reduce__", value: PyBuiltinFunction.wrap(name: "__reduce__", doc: nil, fn: PyEllipsis.reduce, castSelf: Self.asEllipsis))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyEllipsis.getAttribute(name:), castSelf: Self.asEllipsis))
  }

  private static func asEllipsis(_ object: PyObject, methodName: String) -> PyResult<PyEllipsis> {
    return Self.cast(
      object,
      as: PyEllipsis.self,
      typeName: "ellipsis",
      methodName: methodName
    )
  }

  // MARK: - Enumerate

  func fillEnumerate() {
    let type = self.enumerate
    type.setBuiltinTypeDoc(PyEnumerate.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyEnumerate)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyEnumerate.getClass, castSelf: Self.asEnumerate))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyEnumerate.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyEnumerate.getAttribute(name:), castSelf: Self.asEnumerate))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyEnumerate.iter, castSelf: Self.asEnumerate))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyEnumerate.next, castSelf: Self.asEnumerate))
  }

  private static func asEnumerate(_ object: PyObject, methodName: String) -> PyResult<PyEnumerate> {
    return Self.cast(
      object,
      as: PyEnumerate.self,
      typeName: "enumerate",
      methodName: methodName
    )
  }

  // MARK: - Filter

  func fillFilter() {
    let type = self.filter
    type.setBuiltinTypeDoc(PyFilter.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFilter)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFilter.getClass, castSelf: Self.asFilter))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyFilter.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyFilter.getAttribute(name:), castSelf: Self.asFilter))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyFilter.iter, castSelf: Self.asFilter))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyFilter.next, castSelf: Self.asFilter))
  }

  private static func asFilter(_ object: PyObject, methodName: String) -> PyResult<PyFilter> {
    return Self.cast(
      object,
      as: PyFilter.self,
      typeName: "filter",
      methodName: methodName
    )
  }

  // MARK: - Float

  func fillFloat() {
    let type = self.float
    type.setBuiltinTypeDoc(PyFloat.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setLayout(.PyFloat)

    insert(type: type, name: "real", value: PyProperty.wrap(name: "real", doc: nil, get: PyFloat.asReal, castSelf: Self.asFloat))
    insert(type: type, name: "imag", value: PyProperty.wrap(name: "imag", doc: nil, get: PyFloat.asImag, castSelf: Self.asFloat))
    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFloat.getClass, castSelf: Self.asFloat))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyFloat.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyFloat.isEqual(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyFloat.isNotEqual(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyFloat.isLess(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyFloat.isLessEqual(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyFloat.isGreater(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyFloat.isGreaterEqual(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyFloat.hash, castSelf: Self.asFloat))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyFloat.repr, castSelf: Self.asFloat))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyFloat.str, castSelf: Self.asFloat))
    insert(type: type, name: "__bool__", value: PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyFloat.asBool, castSelf: Self.asFloat))
    insert(type: type, name: "__int__", value: PyBuiltinFunction.wrap(name: "__int__", doc: nil, fn: PyFloat.asInt, castSelf: Self.asFloat))
    insert(type: type, name: "__float__", value: PyBuiltinFunction.wrap(name: "__float__", doc: nil, fn: PyFloat.asFloat, castSelf: Self.asFloat))
    insert(type: type, name: "conjugate", value: PyBuiltinFunction.wrap(name: "conjugate", doc: nil, fn: PyFloat.conjugate, castSelf: Self.asFloat))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyFloat.getAttribute(name:), castSelf: Self.asFloat))
    insert(type: type, name: "__pos__", value: PyBuiltinFunction.wrap(name: "__pos__", doc: nil, fn: PyFloat.positive, castSelf: Self.asFloat))
    insert(type: type, name: "__neg__", value: PyBuiltinFunction.wrap(name: "__neg__", doc: nil, fn: PyFloat.negative, castSelf: Self.asFloat))
    insert(type: type, name: "__abs__", value: PyBuiltinFunction.wrap(name: "__abs__", doc: nil, fn: PyFloat.abs, castSelf: Self.asFloat))
    insert(type: type, name: "is_integer", value: PyBuiltinFunction.wrap(name: "is_integer", doc: PyFloat.isIntegerDoc, fn: PyFloat.isInteger, castSelf: Self.asFloat))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyFloat.add(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__radd__", value: PyBuiltinFunction.wrap(name: "__radd__", doc: nil, fn: PyFloat.radd(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__sub__", value: PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyFloat.sub(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__rsub__", value: PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyFloat.rsub(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyFloat.mul(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyFloat.rmul(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__pow__", value: PyBuiltinFunction.wrap(name: "__pow__", doc: nil, fn: PyFloat.pow(exp:mod:), castSelf: Self.asFloat))
    insert(type: type, name: "__rpow__", value: PyBuiltinFunction.wrap(name: "__rpow__", doc: nil, fn: PyFloat.rpow(base:mod:), castSelf: Self.asFloat))
    insert(type: type, name: "__truediv__", value: PyBuiltinFunction.wrap(name: "__truediv__", doc: nil, fn: PyFloat.truediv(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__rtruediv__", value: PyBuiltinFunction.wrap(name: "__rtruediv__", doc: nil, fn: PyFloat.rtruediv(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__floordiv__", value: PyBuiltinFunction.wrap(name: "__floordiv__", doc: nil, fn: PyFloat.floordiv(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__rfloordiv__", value: PyBuiltinFunction.wrap(name: "__rfloordiv__", doc: nil, fn: PyFloat.rfloordiv(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__mod__", value: PyBuiltinFunction.wrap(name: "__mod__", doc: nil, fn: PyFloat.mod(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__rmod__", value: PyBuiltinFunction.wrap(name: "__rmod__", doc: nil, fn: PyFloat.rmod(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__divmod__", value: PyBuiltinFunction.wrap(name: "__divmod__", doc: nil, fn: PyFloat.divmod(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__rdivmod__", value: PyBuiltinFunction.wrap(name: "__rdivmod__", doc: nil, fn: PyFloat.rdivmod(_:), castSelf: Self.asFloat))
    insert(type: type, name: "__round__", value: PyBuiltinFunction.wrap(name: "__round__", doc: nil, fn: PyFloat.round(nDigits:), castSelf: Self.asFloat))
    insert(type: type, name: "__trunc__", value: PyBuiltinFunction.wrap(name: "__trunc__", doc: nil, fn: PyFloat.trunc, castSelf: Self.asFloat))
  }

  private static func asFloat(_ object: PyObject, methodName: String) -> PyResult<PyFloat> {
    return Self.cast(
      object,
      as: PyFloat.self,
      typeName: "float",
      methodName: methodName
    )
  }

  // MARK: - Frame

  func fillFrame() {
    let type = self.frame
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFrame)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFrame.getClass, castSelf: Self.asFrame))
    insert(type: type, name: "f_back", value: PyProperty.wrap(name: "f_back", doc: nil, get: PyFrame.getBack, castSelf: Self.asFrame))
    insert(type: type, name: "f_builtins", value: PyProperty.wrap(name: "f_builtins", doc: nil, get: PyFrame.getBuiltins, castSelf: Self.asFrame))
    insert(type: type, name: "f_globals", value: PyProperty.wrap(name: "f_globals", doc: nil, get: PyFrame.getGlobals, castSelf: Self.asFrame))
    insert(type: type, name: "f_locals", value: PyProperty.wrap(name: "f_locals", doc: nil, get: PyFrame.getLocals, castSelf: Self.asFrame))
    insert(type: type, name: "f_code", value: PyProperty.wrap(name: "f_code", doc: nil, get: PyFrame.getCode, castSelf: Self.asFrame))
    insert(type: type, name: "f_lasti", value: PyProperty.wrap(name: "f_lasti", doc: nil, get: PyFrame.getLasti, castSelf: Self.asFrame))
    insert(type: type, name: "f_lineno", value: PyProperty.wrap(name: "f_lineno", doc: nil, get: PyFrame.getLineno, castSelf: Self.asFrame))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyFrame.repr, castSelf: Self.asFrame))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyFrame.getAttribute(name:), castSelf: Self.asFrame))
    insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyFrame.setAttribute(name:value:), castSelf: Self.asFrame))
    insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyFrame.delAttribute(name:), castSelf: Self.asFrame))
  }

  private static func asFrame(_ object: PyObject, methodName: String) -> PyResult<PyFrame> {
    return Self.cast(
      object,
      as: PyFrame.self,
      typeName: "frame",
      methodName: methodName
    )
  }

  // MARK: - FrozenSet

  func fillFrozenSet() {
    let type = self.frozenset
    type.setBuiltinTypeDoc(PyFrozenSet.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFrozenSet)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFrozenSet.getClass, castSelf: Self.asFrozenSet))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyFrozenSet.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyFrozenSet.isEqual(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyFrozenSet.isNotEqual(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyFrozenSet.isLess(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyFrozenSet.isLessEqual(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyFrozenSet.isGreater(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyFrozenSet.isGreaterEqual(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyFrozenSet.hash, castSelf: Self.asFrozenSet))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyFrozenSet.repr, castSelf: Self.asFrozenSet))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyFrozenSet.getAttribute(name:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyFrozenSet.getLength, castSelf: Self.asFrozenSet))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyFrozenSet.contains(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__and__", value: PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PyFrozenSet.and(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__rand__", value: PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PyFrozenSet.rand(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__or__", value: PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PyFrozenSet.or(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__ror__", value: PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PyFrozenSet.ror(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__xor__", value: PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PyFrozenSet.xor(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__rxor__", value: PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PyFrozenSet.rxor(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__sub__", value: PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyFrozenSet.sub(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "__rsub__", value: PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyFrozenSet.rsub(_:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "issubset", value: PyBuiltinFunction.wrap(name: "issubset", doc: PyFrozenSet.isSubsetDoc, fn: PyFrozenSet.isSubset(of:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "issuperset", value: PyBuiltinFunction.wrap(name: "issuperset", doc: PyFrozenSet.isSupersetDoc, fn: PyFrozenSet.isSuperset(of:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "intersection", value: PyBuiltinFunction.wrap(name: "intersection", doc: PyFrozenSet.intersectionDoc, fn: PyFrozenSet.intersection(with:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "union", value: PyBuiltinFunction.wrap(name: "union", doc: PyFrozenSet.unionDoc, fn: PyFrozenSet.union(with:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "difference", value: PyBuiltinFunction.wrap(name: "difference", doc: PyFrozenSet.differenceDoc, fn: PyFrozenSet.difference(with:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "symmetric_difference", value: PyBuiltinFunction.wrap(name: "symmetric_difference", doc: PyFrozenSet.symmetricDifferenceDoc, fn: PyFrozenSet.symmetricDifference(with:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "isdisjoint", value: PyBuiltinFunction.wrap(name: "isdisjoint", doc: PyFrozenSet.isDisjointDoc, fn: PyFrozenSet.isDisjoint(with:), castSelf: Self.asFrozenSet))
    insert(type: type, name: "copy", value: PyBuiltinFunction.wrap(name: "copy", doc: PyFrozenSet.copyDoc, fn: PyFrozenSet.copy, castSelf: Self.asFrozenSet))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyFrozenSet.iter, castSelf: Self.asFrozenSet))
  }

  private static func asFrozenSet(_ object: PyObject, methodName: String) -> PyResult<PyFrozenSet> {
    return Self.cast(
      object,
      as: PyFrozenSet.self,
      typeName: "frozenset",
      methodName: methodName
    )
  }

  // MARK: - Function

  func fillFunction() {
    let type = self.function
    type.setBuiltinTypeDoc(PyFunction.doc)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFunction)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFunction.getClass, castSelf: Self.asFunction))
    insert(type: type, name: "__name__", value: PyProperty.wrap(name: "__name__", doc: nil, get: PyFunction.getName, set: PyFunction.setName, castSelf: Self.asFunction))
    insert(type: type, name: "__qualname__", value: PyProperty.wrap(name: "__qualname__", doc: nil, get: PyFunction.getQualname, set: PyFunction.setQualname, castSelf: Self.asFunction))
    insert(type: type, name: "__defaults__", value: PyProperty.wrap(name: "__defaults__", doc: nil, get: PyFunction.getDefaults, set: PyFunction.setDefaults, castSelf: Self.asFunction))
    insert(type: type, name: "__kwdefaults__", value: PyProperty.wrap(name: "__kwdefaults__", doc: nil, get: PyFunction.getKeywordDefaults, set: PyFunction.setKeywordDefaults, castSelf: Self.asFunction))
    insert(type: type, name: "__closure__", value: PyProperty.wrap(name: "__closure__", doc: nil, get: PyFunction.getClosure, set: PyFunction.setClosure, castSelf: Self.asFunction))
    insert(type: type, name: "__globals__", value: PyProperty.wrap(name: "__globals__", doc: nil, get: PyFunction.getGlobals, set: PyFunction.setGlobals, castSelf: Self.asFunction))
    insert(type: type, name: "__annotations__", value: PyProperty.wrap(name: "__annotations__", doc: nil, get: PyFunction.getAnnotations, set: PyFunction.setAnnotations, castSelf: Self.asFunction))
    insert(type: type, name: "__code__", value: PyProperty.wrap(name: "__code__", doc: nil, get: PyFunction.getCode, set: PyFunction.setCode, castSelf: Self.asFunction))
    insert(type: type, name: "__doc__", value: PyProperty.wrap(name: "__doc__", doc: nil, get: PyFunction.getDoc, set: PyFunction.setDoc, castSelf: Self.asFunction))
    insert(type: type, name: "__module__", value: PyProperty.wrap(name: "__module__", doc: nil, get: PyFunction.getModule, set: PyFunction.setModule, castSelf: Self.asFunction))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFunction.getDict, castSelf: Self.asFunction))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyFunction.repr, castSelf: Self.asFunction))
    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyFunction.get(object:type:), castSelf: Self.asFunction))
    insert(type: type, name: "__call__", value: PyBuiltinFunction.wrap(name: "__call__", doc: nil, fn: PyFunction.call(args:kwargs:), castSelf: Self.asFunction))
  }

  private static func asFunction(_ object: PyObject, methodName: String) -> PyResult<PyFunction> {
    return Self.cast(
      object,
      as: PyFunction.self,
      typeName: "function",
      methodName: methodName
    )
  }

  // MARK: - Int

  func fillInt() {
    let type = self.int
    type.setBuiltinTypeDoc(PyInt.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.longSubclass)
    type.setLayout(.PyInt)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyInt.getClass, castSelf: Self.asInt))
    insert(type: type, name: "real", value: PyProperty.wrap(name: "real", doc: nil, get: PyInt.asReal, castSelf: Self.asInt))
    insert(type: type, name: "imag", value: PyProperty.wrap(name: "imag", doc: nil, get: PyInt.asImag, castSelf: Self.asInt))
    insert(type: type, name: "numerator", value: PyProperty.wrap(name: "numerator", doc: nil, get: PyInt.numerator, castSelf: Self.asInt))
    insert(type: type, name: "denominator", value: PyProperty.wrap(name: "denominator", doc: nil, get: PyInt.denominator, castSelf: Self.asInt))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyInt.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyInt.isEqual(_:), castSelf: Self.asInt))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyInt.isNotEqual(_:), castSelf: Self.asInt))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyInt.isLess(_:), castSelf: Self.asInt))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyInt.isLessEqual(_:), castSelf: Self.asInt))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyInt.isGreater(_:), castSelf: Self.asInt))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyInt.isGreaterEqual(_:), castSelf: Self.asInt))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyInt.hash, castSelf: Self.asInt))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyInt.repr, castSelf: Self.asInt))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyInt.str, castSelf: Self.asInt))
    insert(type: type, name: "__bool__", value: PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyInt.asBool, castSelf: Self.asInt))
    insert(type: type, name: "__int__", value: PyBuiltinFunction.wrap(name: "__int__", doc: nil, fn: PyInt.asInt, castSelf: Self.asInt))
    insert(type: type, name: "__float__", value: PyBuiltinFunction.wrap(name: "__float__", doc: nil, fn: PyInt.asFloat, castSelf: Self.asInt))
    insert(type: type, name: "__index__", value: PyBuiltinFunction.wrap(name: "__index__", doc: nil, fn: PyInt.asIndex, castSelf: Self.asInt))
    insert(type: type, name: "conjugate", value: PyBuiltinFunction.wrap(name: "conjugate", doc: nil, fn: PyInt.conjugate, castSelf: Self.asInt))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyInt.getAttribute(name:), castSelf: Self.asInt))
    insert(type: type, name: "__pos__", value: PyBuiltinFunction.wrap(name: "__pos__", doc: nil, fn: PyInt.positive, castSelf: Self.asInt))
    insert(type: type, name: "__neg__", value: PyBuiltinFunction.wrap(name: "__neg__", doc: nil, fn: PyInt.negative, castSelf: Self.asInt))
    insert(type: type, name: "__abs__", value: PyBuiltinFunction.wrap(name: "__abs__", doc: nil, fn: PyInt.abs, castSelf: Self.asInt))
    insert(type: type, name: "__trunc__", value: PyBuiltinFunction.wrap(name: "__trunc__", doc: PyInt.truncDoc, fn: PyInt.trunc, castSelf: Self.asInt))
    insert(type: type, name: "__floor__", value: PyBuiltinFunction.wrap(name: "__floor__", doc: PyInt.floorDoc, fn: PyInt.floor, castSelf: Self.asInt))
    insert(type: type, name: "__ceil__", value: PyBuiltinFunction.wrap(name: "__ceil__", doc: PyInt.ceilDoc, fn: PyInt.ceil, castSelf: Self.asInt))
    insert(type: type, name: "bit_length", value: PyBuiltinFunction.wrap(name: "bit_length", doc: PyInt.bitLengthDoc, fn: PyInt.bitLength, castSelf: Self.asInt))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyInt.add(_:), castSelf: Self.asInt))
    insert(type: type, name: "__radd__", value: PyBuiltinFunction.wrap(name: "__radd__", doc: nil, fn: PyInt.radd(_:), castSelf: Self.asInt))
    insert(type: type, name: "__sub__", value: PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PyInt.sub(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rsub__", value: PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PyInt.rsub(_:), castSelf: Self.asInt))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyInt.mul(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyInt.rmul(_:), castSelf: Self.asInt))
    insert(type: type, name: "__pow__", value: PyBuiltinFunction.wrap(name: "__pow__", doc: nil, fn: PyInt.pow(exp:mod:), castSelf: Self.asInt))
    insert(type: type, name: "__rpow__", value: PyBuiltinFunction.wrap(name: "__rpow__", doc: nil, fn: PyInt.rpow(base:mod:), castSelf: Self.asInt))
    insert(type: type, name: "__truediv__", value: PyBuiltinFunction.wrap(name: "__truediv__", doc: nil, fn: PyInt.truediv(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rtruediv__", value: PyBuiltinFunction.wrap(name: "__rtruediv__", doc: nil, fn: PyInt.rtruediv(_:), castSelf: Self.asInt))
    insert(type: type, name: "__floordiv__", value: PyBuiltinFunction.wrap(name: "__floordiv__", doc: nil, fn: PyInt.floordiv(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rfloordiv__", value: PyBuiltinFunction.wrap(name: "__rfloordiv__", doc: nil, fn: PyInt.rfloordiv(_:), castSelf: Self.asInt))
    insert(type: type, name: "__mod__", value: PyBuiltinFunction.wrap(name: "__mod__", doc: nil, fn: PyInt.mod(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rmod__", value: PyBuiltinFunction.wrap(name: "__rmod__", doc: nil, fn: PyInt.rmod(_:), castSelf: Self.asInt))
    insert(type: type, name: "__divmod__", value: PyBuiltinFunction.wrap(name: "__divmod__", doc: nil, fn: PyInt.divmod(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rdivmod__", value: PyBuiltinFunction.wrap(name: "__rdivmod__", doc: nil, fn: PyInt.rdivmod(_:), castSelf: Self.asInt))
    insert(type: type, name: "__lshift__", value: PyBuiltinFunction.wrap(name: "__lshift__", doc: nil, fn: PyInt.lshift(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rlshift__", value: PyBuiltinFunction.wrap(name: "__rlshift__", doc: nil, fn: PyInt.rlshift(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rshift__", value: PyBuiltinFunction.wrap(name: "__rshift__", doc: nil, fn: PyInt.rshift(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rrshift__", value: PyBuiltinFunction.wrap(name: "__rrshift__", doc: nil, fn: PyInt.rrshift(_:), castSelf: Self.asInt))
    insert(type: type, name: "__and__", value: PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PyInt.and(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rand__", value: PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PyInt.rand(_:), castSelf: Self.asInt))
    insert(type: type, name: "__or__", value: PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PyInt.or(_:), castSelf: Self.asInt))
    insert(type: type, name: "__ror__", value: PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PyInt.ror(_:), castSelf: Self.asInt))
    insert(type: type, name: "__xor__", value: PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PyInt.xor(_:), castSelf: Self.asInt))
    insert(type: type, name: "__rxor__", value: PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PyInt.rxor(_:), castSelf: Self.asInt))
    insert(type: type, name: "__invert__", value: PyBuiltinFunction.wrap(name: "__invert__", doc: nil, fn: PyInt.invert, castSelf: Self.asInt))
    insert(type: type, name: "__round__", value: PyBuiltinFunction.wrap(name: "__round__", doc: nil, fn: PyInt.round(nDigits:), castSelf: Self.asInt))
  }

  private static func asInt(_ object: PyObject, methodName: String) -> PyResult<PyInt> {
    return Self.cast(
      object,
      as: PyInt.self,
      typeName: "int",
      methodName: methodName
    )
  }

  // MARK: - Iterator

  func fillIterator() {
    let type = self.iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyIterator.getClass, castSelf: Self.asIterator))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyIterator.getAttribute(name:), castSelf: Self.asIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyIterator.iter, castSelf: Self.asIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyIterator.next, castSelf: Self.asIterator))
  }

  private static func asIterator(_ object: PyObject, methodName: String) -> PyResult<PyIterator> {
    return Self.cast(
      object,
      as: PyIterator.self,
      typeName: "iterator",
      methodName: methodName
    )
  }

  // MARK: - List

  func fillList() {
    let type = self.list
    type.setBuiltinTypeDoc(PyList.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setFlag(.listSubclass)
    type.setLayout(.PyList)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyList.getClass, castSelf: Self.asList))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyList.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyList.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyList.isEqual(_:), castSelf: Self.asList))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyList.isNotEqual(_:), castSelf: Self.asList))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyList.isLess(_:), castSelf: Self.asList))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyList.isLessEqual(_:), castSelf: Self.asList))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyList.isGreater(_:), castSelf: Self.asList))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyList.isGreaterEqual(_:), castSelf: Self.asList))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyList.hash, castSelf: Self.asList))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyList.repr, castSelf: Self.asList))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyList.getAttribute(name:), castSelf: Self.asList))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyList.getLength, castSelf: Self.asList))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyList.contains(_:), castSelf: Self.asList))
    insert(type: type, name: "__getitem__", value: PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyList.getItem(at:), castSelf: Self.asList))
    insert(type: type, name: "__setitem__", value: PyBuiltinFunction.wrap(name: "__setitem__", doc: nil, fn: PyList.setItem(at:to:), castSelf: Self.asList))
    insert(type: type, name: "__delitem__", value: PyBuiltinFunction.wrap(name: "__delitem__", doc: nil, fn: PyList.delItem(at:), castSelf: Self.asList))
    insert(type: type, name: "count", value: PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyList.count(_:), castSelf: Self.asList))
    insert(type: type, name: "index", value: PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyList.index(of:start:end:), castSelf: Self.asList))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyList.iter, castSelf: Self.asList))
    insert(type: type, name: "__reversed__", value: PyBuiltinFunction.wrap(name: "__reversed__", doc: nil, fn: PyList.reversed, castSelf: Self.asList))
    insert(type: type, name: "append", value: PyBuiltinFunction.wrap(name: "append", doc: nil, fn: PyList.append(_:), castSelf: Self.asList))
    insert(type: type, name: "insert", value: PyBuiltinFunction.wrap(name: "insert", doc: PyList.insertDoc, fn: PyList.insert(at:item:), castSelf: Self.asList))
    insert(type: type, name: "extend", value: PyBuiltinFunction.wrap(name: "extend", doc: nil, fn: PyList.extend(iterable:), castSelf: Self.asList))
    insert(type: type, name: "remove", value: PyBuiltinFunction.wrap(name: "remove", doc: PyList.removeDoc, fn: PyList.remove(_:), castSelf: Self.asList))
    insert(type: type, name: "pop", value: PyBuiltinFunction.wrap(name: "pop", doc: nil, fn: PyList.pop(index:), castSelf: Self.asList))
    insert(type: type, name: "sort", value: PyBuiltinFunction.wrap(name: "sort", doc: PyList.sortDoc, fn: PyList.sort(args:kwargs:), castSelf: Self.asList))
    insert(type: type, name: "reverse", value: PyBuiltinFunction.wrap(name: "reverse", doc: PyList.reverseDoc, fn: PyList.reverse, castSelf: Self.asList))
    insert(type: type, name: "clear", value: PyBuiltinFunction.wrap(name: "clear", doc: nil, fn: PyList.clear, castSelf: Self.asList))
    insert(type: type, name: "copy", value: PyBuiltinFunction.wrap(name: "copy", doc: nil, fn: PyList.copy, castSelf: Self.asList))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyList.add(_:), castSelf: Self.asList))
    insert(type: type, name: "__iadd__", value: PyBuiltinFunction.wrap(name: "__iadd__", doc: nil, fn: PyList.iadd(_:), castSelf: Self.asList))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyList.mul(_:), castSelf: Self.asList))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyList.rmul(_:), castSelf: Self.asList))
    insert(type: type, name: "__imul__", value: PyBuiltinFunction.wrap(name: "__imul__", doc: nil, fn: PyList.imul(_:), castSelf: Self.asList))
  }

  private static func asList(_ object: PyObject, methodName: String) -> PyResult<PyList> {
    return Self.cast(
      object,
      as: PyList.self,
      typeName: "list",
      methodName: methodName
    )
  }

  // MARK: - ListIterator

  func fillListIterator() {
    let type = self.list_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyListIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyListIterator.getClass, castSelf: Self.asListIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyListIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyListIterator.getAttribute(name:), castSelf: Self.asListIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyListIterator.iter, castSelf: Self.asListIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyListIterator.next, castSelf: Self.asListIterator))
  }

  private static func asListIterator(_ object: PyObject, methodName: String) -> PyResult<PyListIterator> {
    return Self.cast(
      object,
      as: PyListIterator.self,
      typeName: "list_iterator",
      methodName: methodName
    )
  }

  // MARK: - ListReverseIterator

  func fillListReverseIterator() {
    let type = self.list_reverseiterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyListReverseIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyListReverseIterator.getClass, castSelf: Self.asListReverseIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyListReverseIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyListReverseIterator.getAttribute(name:), castSelf: Self.asListReverseIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyListReverseIterator.iter, castSelf: Self.asListReverseIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyListReverseIterator.next, castSelf: Self.asListReverseIterator))
  }

  private static func asListReverseIterator(_ object: PyObject, methodName: String) -> PyResult<PyListReverseIterator> {
    return Self.cast(
      object,
      as: PyListReverseIterator.self,
      typeName: "list_reverseiterator",
      methodName: methodName
    )
  }

  // MARK: - Map

  func fillMap() {
    let type = self.map
    type.setBuiltinTypeDoc(PyMap.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyMap)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyMap.getClass, castSelf: Self.asMap))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyMap.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyMap.getAttribute(name:), castSelf: Self.asMap))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyMap.iter, castSelf: Self.asMap))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyMap.next, castSelf: Self.asMap))
  }

  private static func asMap(_ object: PyObject, methodName: String) -> PyResult<PyMap> {
    return Self.cast(
      object,
      as: PyMap.self,
      typeName: "map",
      methodName: methodName
    )
  }

  // MARK: - Method

  func fillMethod() {
    let type = self.method
    type.setBuiltinTypeDoc(PyMethod.doc)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyMethod)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyMethod.getClass, castSelf: Self.asMethod))
    insert(type: type, name: "__doc__", value: PyProperty.wrap(name: "__doc__", doc: nil, get: PyMethod.getDoc, castSelf: Self.asMethod))
    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyMethod.isEqual(_:), castSelf: Self.asMethod))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyMethod.isNotEqual(_:), castSelf: Self.asMethod))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyMethod.isLess(_:), castSelf: Self.asMethod))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyMethod.isLessEqual(_:), castSelf: Self.asMethod))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyMethod.isGreater(_:), castSelf: Self.asMethod))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyMethod.isGreaterEqual(_:), castSelf: Self.asMethod))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyMethod.repr, castSelf: Self.asMethod))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyMethod.hash, castSelf: Self.asMethod))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyMethod.getAttribute(name:), castSelf: Self.asMethod))
    insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyMethod.setAttribute(name:value:), castSelf: Self.asMethod))
    insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyMethod.delAttribute(name:), castSelf: Self.asMethod))
    insert(type: type, name: "__func__", value: PyBuiltinFunction.wrap(name: "__func__", doc: nil, fn: PyMethod.getFunc, castSelf: Self.asMethod))
    insert(type: type, name: "__self__", value: PyBuiltinFunction.wrap(name: "__self__", doc: nil, fn: PyMethod.getSelf, castSelf: Self.asMethod))
    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyMethod.get(object:type:), castSelf: Self.asMethod))
    insert(type: type, name: "__call__", value: PyBuiltinFunction.wrap(name: "__call__", doc: nil, fn: PyMethod.call(args:kwargs:), castSelf: Self.asMethod))
  }

  private static func asMethod(_ object: PyObject, methodName: String) -> PyResult<PyMethod> {
    return Self.cast(
      object,
      as: PyMethod.self,
      typeName: "method",
      methodName: methodName
    )
  }

  // MARK: - Module

  func fillModule() {
    let type = self.module
    type.setBuiltinTypeDoc(PyModule.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyModule)

    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyModule.getDict, castSelf: Self.asModule))
    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyModule.getClass, castSelf: Self.asModule))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyModule.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyModule.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyModule.repr, castSelf: Self.asModule))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyModule.getAttribute(name:), castSelf: Self.asModule))
    insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyModule.setAttribute(name:value:), castSelf: Self.asModule))
    insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyModule.delAttribute(name:), castSelf: Self.asModule))
    insert(type: type, name: "__dir__", value: PyBuiltinFunction.wrap(name: "__dir__", doc: nil, fn: PyModule.dir, castSelf: Self.asModule))
  }

  private static func asModule(_ object: PyObject, methodName: String) -> PyResult<PyModule> {
    return Self.cast(
      object,
      as: PyModule.self,
      typeName: "module",
      methodName: methodName
    )
  }

  // MARK: - Namespace

  func fillNamespace() {
    let type = self.simpleNamespace
    type.setBuiltinTypeDoc(PyNamespace.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyNamespace)

    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyNamespace.getDict, castSelf: Self.asNamespace))

    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNamespace.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyNamespace.isEqual(_:), castSelf: Self.asNamespace))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyNamespace.isNotEqual(_:), castSelf: Self.asNamespace))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyNamespace.isLess(_:), castSelf: Self.asNamespace))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyNamespace.isLessEqual(_:), castSelf: Self.asNamespace))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyNamespace.isGreater(_:), castSelf: Self.asNamespace))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyNamespace.isGreaterEqual(_:), castSelf: Self.asNamespace))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyNamespace.repr, castSelf: Self.asNamespace))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyNamespace.getAttribute(name:), castSelf: Self.asNamespace))
    insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyNamespace.setAttribute(name:value:), castSelf: Self.asNamespace))
    insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyNamespace.delAttribute(name:), castSelf: Self.asNamespace))
  }

  private static func asNamespace(_ object: PyObject, methodName: String) -> PyResult<PyNamespace> {
    return Self.cast(
      object,
      as: PyNamespace.self,
      typeName: "types.SimpleNamespace",
      methodName: methodName
    )
  }

  // MARK: - None

  func fillNone() {
    let type = self.none
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setLayout(.PyNone)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNone.getClass, castSelf: Self.asNone))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyNone.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyNone.repr, castSelf: Self.asNone))
    insert(type: type, name: "__bool__", value: PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyNone.asBool, castSelf: Self.asNone))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyNone.getAttribute(name:), castSelf: Self.asNone))
  }

  private static func asNone(_ object: PyObject, methodName: String) -> PyResult<PyNone> {
    return Self.cast(
      object,
      as: PyNone.self,
      typeName: "NoneType",
      methodName: methodName
    )
  }

  // MARK: - NotImplemented

  func fillNotImplemented() {
    let type = self.notImplemented
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setLayout(.PyNotImplemented)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNotImplemented.getClass, castSelf: Self.asNotImplemented))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyNotImplemented.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyNotImplemented.repr, castSelf: Self.asNotImplemented))
  }

  private static func asNotImplemented(_ object: PyObject, methodName: String) -> PyResult<PyNotImplemented> {
    return Self.cast(
      object,
      as: PyNotImplemented.self,
      typeName: "NotImplementedType",
      methodName: methodName
    )
  }

  // MARK: - Property

  func fillProperty() {
    let type = self.property
    type.setBuiltinTypeDoc(PyProperty.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyProperty)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyProperty.getClass, castSelf: Self.asProperty))
    insert(type: type, name: "fget", value: PyProperty.wrap(name: "fget", doc: nil, get: PyProperty.getFGet, castSelf: Self.asProperty))
    insert(type: type, name: "fset", value: PyProperty.wrap(name: "fset", doc: nil, get: PyProperty.getFSet, castSelf: Self.asProperty))
    insert(type: type, name: "fdel", value: PyProperty.wrap(name: "fdel", doc: nil, get: PyProperty.getFDel, castSelf: Self.asProperty))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyProperty.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyProperty.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyProperty.getAttribute(name:), castSelf: Self.asProperty))
    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyProperty.get(object:type:), castSelf: Self.asProperty))
    insert(type: type, name: "__set__", value: PyBuiltinFunction.wrap(name: "__set__", doc: nil, fn: PyProperty.set(object:value:), castSelf: Self.asProperty))
    insert(type: type, name: "__delete__", value: PyBuiltinFunction.wrap(name: "__delete__", doc: nil, fn: PyProperty.del(object:), castSelf: Self.asProperty))
    insert(type: type, name: "getter", value: PyBuiltinFunction.wrap(name: "getter", doc: PyProperty.getterDoc, fn: PyProperty.getter(value:), castSelf: Self.asProperty))
    insert(type: type, name: "setter", value: PyBuiltinFunction.wrap(name: "setter", doc: nil, fn: PyProperty.setter(value:), castSelf: Self.asProperty))
    insert(type: type, name: "deleter", value: PyBuiltinFunction.wrap(name: "deleter", doc: nil, fn: PyProperty.deleter(value:), castSelf: Self.asProperty))
  }

  private static func asProperty(_ object: PyObject, methodName: String) -> PyResult<PyProperty> {
    return Self.cast(
      object,
      as: PyProperty.self,
      typeName: "property",
      methodName: methodName
    )
  }

  // MARK: - Range

  func fillRange() {
    let type = self.range
    type.setBuiltinTypeDoc(PyRange.doc)
    type.setFlag(.default)
    type.setLayout(.PyRange)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRange.getClass, castSelf: Self.asRange))
    insert(type: type, name: "start", value: PyProperty.wrap(name: "start", doc: nil, get: PyRange.getStart, castSelf: Self.asRange))
    insert(type: type, name: "stop", value: PyProperty.wrap(name: "stop", doc: nil, get: PyRange.getStop, castSelf: Self.asRange))
    insert(type: type, name: "step", value: PyProperty.wrap(name: "step", doc: nil, get: PyRange.getStep, castSelf: Self.asRange))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyRange.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyRange.isEqual(_:), castSelf: Self.asRange))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyRange.isNotEqual(_:), castSelf: Self.asRange))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyRange.isLess(_:), castSelf: Self.asRange))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyRange.isLessEqual(_:), castSelf: Self.asRange))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyRange.isGreater(_:), castSelf: Self.asRange))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyRange.isGreaterEqual(_:), castSelf: Self.asRange))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyRange.hash, castSelf: Self.asRange))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyRange.repr, castSelf: Self.asRange))
    insert(type: type, name: "__bool__", value: PyBuiltinFunction.wrap(name: "__bool__", doc: nil, fn: PyRange.asBool, castSelf: Self.asRange))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyRange.getLength, castSelf: Self.asRange))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyRange.getAttribute(name:), castSelf: Self.asRange))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyRange.contains(_:), castSelf: Self.asRange))
    insert(type: type, name: "__getitem__", value: PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyRange.getItem(at:), castSelf: Self.asRange))
    insert(type: type, name: "__reversed__", value: PyBuiltinFunction.wrap(name: "__reversed__", doc: nil, fn: PyRange.reversed, castSelf: Self.asRange))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyRange.iter, castSelf: Self.asRange))
    insert(type: type, name: "count", value: PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyRange.count(_:), castSelf: Self.asRange))
    insert(type: type, name: "index", value: PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyRange.index(of:), castSelf: Self.asRange))
  }

  private static func asRange(_ object: PyObject, methodName: String) -> PyResult<PyRange> {
    return Self.cast(
      object,
      as: PyRange.self,
      typeName: "range",
      methodName: methodName
    )
  }

  // MARK: - RangeIterator

  func fillRangeIterator() {
    let type = self.range_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setLayout(.PyRangeIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRangeIterator.getClass, castSelf: Self.asRangeIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyRangeIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyRangeIterator.getAttribute(name:), castSelf: Self.asRangeIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyRangeIterator.iter, castSelf: Self.asRangeIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyRangeIterator.next, castSelf: Self.asRangeIterator))
  }

  private static func asRangeIterator(_ object: PyObject, methodName: String) -> PyResult<PyRangeIterator> {
    return Self.cast(
      object,
      as: PyRangeIterator.self,
      typeName: "range_iterator",
      methodName: methodName
    )
  }

  // MARK: - Reversed

  func fillReversed() {
    let type = self.reversed
    type.setBuiltinTypeDoc(PyReversed.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyReversed)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyReversed.getClass, castSelf: Self.asReversed))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyReversed.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyReversed.getAttribute(name:), castSelf: Self.asReversed))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyReversed.iter, castSelf: Self.asReversed))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyReversed.next, castSelf: Self.asReversed))
  }

  private static func asReversed(_ object: PyObject, methodName: String) -> PyResult<PyReversed> {
    return Self.cast(
      object,
      as: PyReversed.self,
      typeName: "reversed",
      methodName: methodName
    )
  }

  // MARK: - Set

  func fillSet() {
    let type = self.set
    type.setBuiltinTypeDoc(PySet.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySet)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySet.getClass, castSelf: Self.asSet))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySet.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySet.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PySet.isEqual(_:), castSelf: Self.asSet))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PySet.isNotEqual(_:), castSelf: Self.asSet))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PySet.isLess(_:), castSelf: Self.asSet))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PySet.isLessEqual(_:), castSelf: Self.asSet))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PySet.isGreater(_:), castSelf: Self.asSet))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PySet.isGreaterEqual(_:), castSelf: Self.asSet))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PySet.hash, castSelf: Self.asSet))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PySet.repr, castSelf: Self.asSet))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PySet.getAttribute(name:), castSelf: Self.asSet))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PySet.getLength, castSelf: Self.asSet))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PySet.contains(_:), castSelf: Self.asSet))
    insert(type: type, name: "__and__", value: PyBuiltinFunction.wrap(name: "__and__", doc: nil, fn: PySet.and(_:), castSelf: Self.asSet))
    insert(type: type, name: "__rand__", value: PyBuiltinFunction.wrap(name: "__rand__", doc: nil, fn: PySet.rand(_:), castSelf: Self.asSet))
    insert(type: type, name: "__or__", value: PyBuiltinFunction.wrap(name: "__or__", doc: nil, fn: PySet.or(_:), castSelf: Self.asSet))
    insert(type: type, name: "__ror__", value: PyBuiltinFunction.wrap(name: "__ror__", doc: nil, fn: PySet.ror(_:), castSelf: Self.asSet))
    insert(type: type, name: "__xor__", value: PyBuiltinFunction.wrap(name: "__xor__", doc: nil, fn: PySet.xor(_:), castSelf: Self.asSet))
    insert(type: type, name: "__rxor__", value: PyBuiltinFunction.wrap(name: "__rxor__", doc: nil, fn: PySet.rxor(_:), castSelf: Self.asSet))
    insert(type: type, name: "__sub__", value: PyBuiltinFunction.wrap(name: "__sub__", doc: nil, fn: PySet.sub(_:), castSelf: Self.asSet))
    insert(type: type, name: "__rsub__", value: PyBuiltinFunction.wrap(name: "__rsub__", doc: nil, fn: PySet.rsub(_:), castSelf: Self.asSet))
    insert(type: type, name: "issubset", value: PyBuiltinFunction.wrap(name: "issubset", doc: PySet.isSubsetDoc, fn: PySet.isSubset(of:), castSelf: Self.asSet))
    insert(type: type, name: "issuperset", value: PyBuiltinFunction.wrap(name: "issuperset", doc: PySet.isSupersetDoc, fn: PySet.isSuperset(of:), castSelf: Self.asSet))
    insert(type: type, name: "intersection", value: PyBuiltinFunction.wrap(name: "intersection", doc: PySet.intersectionDoc, fn: PySet.intersection(with:), castSelf: Self.asSet))
    insert(type: type, name: "union", value: PyBuiltinFunction.wrap(name: "union", doc: PySet.unionDoc, fn: PySet.union(with:), castSelf: Self.asSet))
    insert(type: type, name: "difference", value: PyBuiltinFunction.wrap(name: "difference", doc: PySet.differenceDoc, fn: PySet.difference(with:), castSelf: Self.asSet))
    insert(type: type, name: "symmetric_difference", value: PyBuiltinFunction.wrap(name: "symmetric_difference", doc: PySet.symmetricDifferenceDoc, fn: PySet.symmetricDifference(with:), castSelf: Self.asSet))
    insert(type: type, name: "isdisjoint", value: PyBuiltinFunction.wrap(name: "isdisjoint", doc: PySet.isDisjointDoc, fn: PySet.isDisjoint(with:), castSelf: Self.asSet))
    insert(type: type, name: "add", value: PyBuiltinFunction.wrap(name: "add", doc: PySet.addDoc, fn: PySet.add(_:), castSelf: Self.asSet))
    insert(type: type, name: "update", value: PyBuiltinFunction.wrap(name: "update", doc: PySet.updateDoc, fn: PySet.update(from:), castSelf: Self.asSet))
    insert(type: type, name: "remove", value: PyBuiltinFunction.wrap(name: "remove", doc: PySet.removeDoc, fn: PySet.remove(_:), castSelf: Self.asSet))
    insert(type: type, name: "discard", value: PyBuiltinFunction.wrap(name: "discard", doc: PySet.discardDoc, fn: PySet.discard(_:), castSelf: Self.asSet))
    insert(type: type, name: "clear", value: PyBuiltinFunction.wrap(name: "clear", doc: PySet.clearDoc, fn: PySet.clear, castSelf: Self.asSet))
    insert(type: type, name: "copy", value: PyBuiltinFunction.wrap(name: "copy", doc: PySet.copyDoc, fn: PySet.copy, castSelf: Self.asSet))
    insert(type: type, name: "pop", value: PyBuiltinFunction.wrap(name: "pop", doc: PySet.popDoc, fn: PySet.pop, castSelf: Self.asSet))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PySet.iter, castSelf: Self.asSet))
  }

  private static func asSet(_ object: PyObject, methodName: String) -> PyResult<PySet> {
    return Self.cast(
      object,
      as: PySet.self,
      typeName: "set",
      methodName: methodName
    )
  }

  // MARK: - SetIterator

  func fillSetIterator() {
    let type = self.set_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySetIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySetIterator.getClass, castSelf: Self.asSetIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySetIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PySetIterator.getAttribute(name:), castSelf: Self.asSetIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PySetIterator.iter, castSelf: Self.asSetIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PySetIterator.next, castSelf: Self.asSetIterator))
  }

  private static func asSetIterator(_ object: PyObject, methodName: String) -> PyResult<PySetIterator> {
    return Self.cast(
      object,
      as: PySetIterator.self,
      typeName: "set_iterator",
      methodName: methodName
    )
  }

  // MARK: - Slice

  func fillSlice() {
    let type = self.slice
    type.setBuiltinTypeDoc(PySlice.doc)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySlice)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySlice.getClass, castSelf: Self.asSlice))
    insert(type: type, name: "start", value: PyProperty.wrap(name: "start", doc: nil, get: PySlice.getStart, castSelf: Self.asSlice))
    insert(type: type, name: "stop", value: PyProperty.wrap(name: "stop", doc: nil, get: PySlice.getStop, castSelf: Self.asSlice))
    insert(type: type, name: "step", value: PyProperty.wrap(name: "step", doc: nil, get: PySlice.getStep, castSelf: Self.asSlice))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySlice.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PySlice.isEqual(_:), castSelf: Self.asSlice))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PySlice.isNotEqual(_:), castSelf: Self.asSlice))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PySlice.isLess(_:), castSelf: Self.asSlice))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PySlice.isLessEqual(_:), castSelf: Self.asSlice))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PySlice.isGreater(_:), castSelf: Self.asSlice))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PySlice.isGreaterEqual(_:), castSelf: Self.asSlice))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PySlice.hash, castSelf: Self.asSlice))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PySlice.repr, castSelf: Self.asSlice))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PySlice.getAttribute(name:), castSelf: Self.asSlice))
    insert(type: type, name: "indices", value: PyBuiltinFunction.wrap(name: "indices", doc: nil, fn: PySlice.indicesInSequence(length:), castSelf: Self.asSlice))
  }

  private static func asSlice(_ object: PyObject, methodName: String) -> PyResult<PySlice> {
    return Self.cast(
      object,
      as: PySlice.self,
      typeName: "slice",
      methodName: methodName
    )
  }

  // MARK: - StaticMethod

  func fillStaticMethod() {
    let type = self.staticmethod
    type.setBuiltinTypeDoc(PyStaticMethod.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyStaticMethod)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyStaticMethod.getClass, castSelf: Self.asStaticMethod))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyStaticMethod.getDict, castSelf: Self.asStaticMethod))
    insert(type: type, name: "__func__", value: PyProperty.wrap(name: "__func__", doc: nil, get: PyStaticMethod.getFunc, castSelf: Self.asStaticMethod))

    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyStaticMethod.pyInit(zelf:args:kwargs:)))
    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyStaticMethod.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PyStaticMethod.get(object:type:), castSelf: Self.asStaticMethod))
    insert(type: type, name: "__isabstractmethod__", value: PyBuiltinFunction.wrap(name: "__isabstractmethod__", doc: nil, fn: PyStaticMethod.isAbstractMethod, castSelf: Self.asStaticMethod))
  }

  private static func asStaticMethod(_ object: PyObject, methodName: String) -> PyResult<PyStaticMethod> {
    return Self.cast(
      object,
      as: PyStaticMethod.self,
      typeName: "staticmethod",
      methodName: methodName
    )
  }

  // MARK: - String

  func fillString() {
    let type = self.str
    type.setBuiltinTypeDoc(PyString.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.unicodeSubclass)
    type.setLayout(.PyString)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyString.getClass, castSelf: Self.asString))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyString.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyString.isEqual(_:), castSelf: Self.asString))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyString.isNotEqual(_:), castSelf: Self.asString))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyString.isLess(_:), castSelf: Self.asString))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyString.isLessEqual(_:), castSelf: Self.asString))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyString.isGreater(_:), castSelf: Self.asString))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyString.isGreaterEqual(_:), castSelf: Self.asString))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyString.hash, castSelf: Self.asString))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyString.repr, castSelf: Self.asString))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyString.str, castSelf: Self.asString))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyString.getAttribute(name:), castSelf: Self.asString))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyString.getLength, castSelf: Self.asString))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyString.contains(_:), castSelf: Self.asString))
    insert(type: type, name: "__getitem__", value: PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyString.getItem(at:), castSelf: Self.asString))
    insert(type: type, name: "isalnum", value: PyBuiltinFunction.wrap(name: "isalnum", doc: PyString.isalnumDoc, fn: PyString.isAlphaNumeric, castSelf: Self.asString))
    insert(type: type, name: "isalpha", value: PyBuiltinFunction.wrap(name: "isalpha", doc: PyString.isalphaDoc, fn: PyString.isAlpha, castSelf: Self.asString))
    insert(type: type, name: "isascii", value: PyBuiltinFunction.wrap(name: "isascii", doc: PyString.isasciiDoc, fn: PyString.isAscii, castSelf: Self.asString))
    insert(type: type, name: "isdecimal", value: PyBuiltinFunction.wrap(name: "isdecimal", doc: PyString.isdecimalDoc, fn: PyString.isDecimal, castSelf: Self.asString))
    insert(type: type, name: "isdigit", value: PyBuiltinFunction.wrap(name: "isdigit", doc: PyString.isdigitDoc, fn: PyString.isDigit, castSelf: Self.asString))
    insert(type: type, name: "isidentifier", value: PyBuiltinFunction.wrap(name: "isidentifier", doc: PyString.isidentifierDoc, fn: PyString.isIdentifier, castSelf: Self.asString))
    insert(type: type, name: "islower", value: PyBuiltinFunction.wrap(name: "islower", doc: PyString.islowerDoc, fn: PyString.isLower, castSelf: Self.asString))
    insert(type: type, name: "isnumeric", value: PyBuiltinFunction.wrap(name: "isnumeric", doc: PyString.isnumericDoc, fn: PyString.isNumeric, castSelf: Self.asString))
    insert(type: type, name: "isprintable", value: PyBuiltinFunction.wrap(name: "isprintable", doc: PyString.isprintableDoc, fn: PyString.isPrintable, castSelf: Self.asString))
    insert(type: type, name: "isspace", value: PyBuiltinFunction.wrap(name: "isspace", doc: PyString.isspaceDoc, fn: PyString.isSpace, castSelf: Self.asString))
    insert(type: type, name: "istitle", value: PyBuiltinFunction.wrap(name: "istitle", doc: PyString.istitleDoc, fn: PyString.isTitle, castSelf: Self.asString))
    insert(type: type, name: "isupper", value: PyBuiltinFunction.wrap(name: "isupper", doc: PyString.isupperDoc, fn: PyString.isUpper, castSelf: Self.asString))
    insert(type: type, name: "startswith", value: PyBuiltinFunction.wrap(name: "startswith", doc: PyString.startswithDoc, fn: PyString.startsWith(_:start:end:), castSelf: Self.asString))
    insert(type: type, name: "endswith", value: PyBuiltinFunction.wrap(name: "endswith", doc: PyString.endswithDoc, fn: PyString.endsWith(_:start:end:), castSelf: Self.asString))
    insert(type: type, name: "strip", value: PyBuiltinFunction.wrap(name: "strip", doc: PyString.stripDoc, fn: PyString.strip(_:), castSelf: Self.asString))
    insert(type: type, name: "lstrip", value: PyBuiltinFunction.wrap(name: "lstrip", doc: PyString.lstripDoc, fn: PyString.lstrip(_:), castSelf: Self.asString))
    insert(type: type, name: "rstrip", value: PyBuiltinFunction.wrap(name: "rstrip", doc: PyString.rstripDoc, fn: PyString.rstrip(_:), castSelf: Self.asString))
    insert(type: type, name: "find", value: PyBuiltinFunction.wrap(name: "find", doc: PyString.findDoc, fn: PyString.find(_:start:end:), castSelf: Self.asString))
    insert(type: type, name: "rfind", value: PyBuiltinFunction.wrap(name: "rfind", doc: PyString.rfindDoc, fn: PyString.rfind(_:start:end:), castSelf: Self.asString))
    insert(type: type, name: "index", value: PyBuiltinFunction.wrap(name: "index", doc: PyString.indexDoc, fn: PyString.index(of:start:end:), castSelf: Self.asString))
    insert(type: type, name: "rindex", value: PyBuiltinFunction.wrap(name: "rindex", doc: PyString.rindexDoc, fn: PyString.rindex(_:start:end:), castSelf: Self.asString))
    insert(type: type, name: "lower", value: PyBuiltinFunction.wrap(name: "lower", doc: nil, fn: PyString.lower, castSelf: Self.asString))
    insert(type: type, name: "upper", value: PyBuiltinFunction.wrap(name: "upper", doc: nil, fn: PyString.upper, castSelf: Self.asString))
    insert(type: type, name: "title", value: PyBuiltinFunction.wrap(name: "title", doc: nil, fn: PyString.title, castSelf: Self.asString))
    insert(type: type, name: "swapcase", value: PyBuiltinFunction.wrap(name: "swapcase", doc: nil, fn: PyString.swapcase, castSelf: Self.asString))
    insert(type: type, name: "casefold", value: PyBuiltinFunction.wrap(name: "casefold", doc: nil, fn: PyString.casefold, castSelf: Self.asString))
    insert(type: type, name: "capitalize", value: PyBuiltinFunction.wrap(name: "capitalize", doc: nil, fn: PyString.capitalize, castSelf: Self.asString))
    insert(type: type, name: "center", value: PyBuiltinFunction.wrap(name: "center", doc: nil, fn: PyString.center(width:fillChar:), castSelf: Self.asString))
    insert(type: type, name: "ljust", value: PyBuiltinFunction.wrap(name: "ljust", doc: nil, fn: PyString.ljust(width:fillChar:), castSelf: Self.asString))
    insert(type: type, name: "rjust", value: PyBuiltinFunction.wrap(name: "rjust", doc: nil, fn: PyString.rjust(width:fillChar:), castSelf: Self.asString))
    insert(type: type, name: "split", value: PyBuiltinFunction.wrap(name: "split", doc: nil, fn: PyString.split(args:kwargs:), castSelf: Self.asString))
    insert(type: type, name: "rsplit", value: PyBuiltinFunction.wrap(name: "rsplit", doc: nil, fn: PyString.rsplit(args:kwargs:), castSelf: Self.asString))
    insert(type: type, name: "splitlines", value: PyBuiltinFunction.wrap(name: "splitlines", doc: nil, fn: PyString.splitLines(args:kwargs:), castSelf: Self.asString))
    insert(type: type, name: "partition", value: PyBuiltinFunction.wrap(name: "partition", doc: nil, fn: PyString.partition(separator:), castSelf: Self.asString))
    insert(type: type, name: "rpartition", value: PyBuiltinFunction.wrap(name: "rpartition", doc: nil, fn: PyString.rpartition(separator:), castSelf: Self.asString))
    insert(type: type, name: "expandtabs", value: PyBuiltinFunction.wrap(name: "expandtabs", doc: nil, fn: PyString.expandTabs(tabSize:), castSelf: Self.asString))
    insert(type: type, name: "count", value: PyBuiltinFunction.wrap(name: "count", doc: PyString.countDoc, fn: PyString.count(_:start:end:), castSelf: Self.asString))
    insert(type: type, name: "join", value: PyBuiltinFunction.wrap(name: "join", doc: nil, fn: PyString.join(iterable:), castSelf: Self.asString))
    insert(type: type, name: "replace", value: PyBuiltinFunction.wrap(name: "replace", doc: nil, fn: PyString.replace(old:new:count:), castSelf: Self.asString))
    insert(type: type, name: "zfill", value: PyBuiltinFunction.wrap(name: "zfill", doc: nil, fn: PyString.zfill(width:), castSelf: Self.asString))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyString.add(_:), castSelf: Self.asString))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyString.mul(_:), castSelf: Self.asString))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyString.rmul(_:), castSelf: Self.asString))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyString.iter, castSelf: Self.asString))
  }

  private static func asString(_ object: PyObject, methodName: String) -> PyResult<PyString> {
    return Self.cast(
      object,
      as: PyString.self,
      typeName: "str",
      methodName: methodName
    )
  }

  // MARK: - StringIterator

  func fillStringIterator() {
    let type = self.str_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyStringIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyStringIterator.getClass, castSelf: Self.asStringIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyStringIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyStringIterator.getAttribute(name:), castSelf: Self.asStringIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyStringIterator.iter, castSelf: Self.asStringIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyStringIterator.next, castSelf: Self.asStringIterator))
  }

  private static func asStringIterator(_ object: PyObject, methodName: String) -> PyResult<PyStringIterator> {
    return Self.cast(
      object,
      as: PyStringIterator.self,
      typeName: "str_iterator",
      methodName: methodName
    )
  }

  // MARK: - Super

  func fillSuper() {
    let type = self.super
    type.setBuiltinTypeDoc(PySuper.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySuper)

    insert(type: type, name: "__thisclass__", value: PyProperty.wrap(name: "__thisclass__", doc: PySuper.thisClassDoc, get: PySuper.getThisClass, castSelf: Self.asSuper))
    insert(type: type, name: "__self__", value: PyProperty.wrap(name: "__self__", doc: PySuper.selfDoc, get: PySuper.getSelf, castSelf: Self.asSuper))
    insert(type: type, name: "__self_class__", value: PyProperty.wrap(name: "__self_class__", doc: PySuper.selfClassDoc, get: PySuper.getSelfClass, castSelf: Self.asSuper))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySuper.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySuper.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PySuper.repr, castSelf: Self.asSuper))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PySuper.getAttribute(name:), castSelf: Self.asSuper))
    insert(type: type, name: "__get__", value: PyBuiltinFunction.wrap(name: "__get__", doc: nil, fn: PySuper.get(object:type:), castSelf: Self.asSuper))
  }

  private static func asSuper(_ object: PyObject, methodName: String) -> PyResult<PySuper> {
    return Self.cast(
      object,
      as: PySuper.self,
      typeName: "super",
      methodName: methodName
    )
  }

  // MARK: - TextFile

  func fillTextFile() {
    let type = self.textFile
    type.setBuiltinTypeDoc(PyTextFile.doc)
    type.setFlag(.default)
    type.setFlag(.hasFinalize)
    type.setFlag(.hasGC)
    type.setLayout(.PyTextFile)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTextFile.getClass, castSelf: Self.asTextFile))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyTextFile.repr, castSelf: Self.asTextFile))
    insert(type: type, name: "readable", value: PyBuiltinFunction.wrap(name: "readable", doc: nil, fn: PyTextFile.isReadable, castSelf: Self.asTextFile))
    insert(type: type, name: "read", value: PyBuiltinFunction.wrap(name: "read", doc: nil, fn: PyTextFile.read(size:), castSelf: Self.asTextFile))
    insert(type: type, name: "writable", value: PyBuiltinFunction.wrap(name: "writable", doc: nil, fn: PyTextFile.isWritable, castSelf: Self.asTextFile))
    insert(type: type, name: "write", value: PyBuiltinFunction.wrap(name: "write", doc: nil, fn: PyTextFile.write(object:), castSelf: Self.asTextFile))
    insert(type: type, name: "closed", value: PyBuiltinFunction.wrap(name: "closed", doc: nil, fn: PyTextFile.isClosed, castSelf: Self.asTextFile))
    insert(type: type, name: "close", value: PyBuiltinFunction.wrap(name: "close", doc: nil, fn: PyTextFile.close, castSelf: Self.asTextFile))
    insert(type: type, name: "__del__", value: PyBuiltinFunction.wrap(name: "__del__", doc: nil, fn: PyTextFile.del, castSelf: Self.asTextFile))
    insert(type: type, name: "__enter__", value: PyBuiltinFunction.wrap(name: "__enter__", doc: nil, fn: PyTextFile.enter, castSelf: Self.asTextFile))
    insert(type: type, name: "__exit__", value: PyBuiltinFunction.wrap(name: "__exit__", doc: nil, fn: PyTextFile.exit(exceptionType:exception:traceback:), castSelf: Self.asTextFile))
  }

  private static func asTextFile(_ object: PyObject, methodName: String) -> PyResult<PyTextFile> {
    return Self.cast(
      object,
      as: PyTextFile.self,
      typeName: "TextFile",
      methodName: methodName
    )
  }

  // MARK: - Tuple

  func fillTuple() {
    let type = self.tuple
    type.setBuiltinTypeDoc(PyTuple.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setFlag(.tupleSubclass)
    type.setLayout(.PyTuple)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTuple.getClass, castSelf: Self.asTuple))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyTuple.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__eq__", value: PyBuiltinFunction.wrap(name: "__eq__", doc: nil, fn: PyTuple.isEqual(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__ne__", value: PyBuiltinFunction.wrap(name: "__ne__", doc: nil, fn: PyTuple.isNotEqual(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__lt__", value: PyBuiltinFunction.wrap(name: "__lt__", doc: nil, fn: PyTuple.isLess(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__le__", value: PyBuiltinFunction.wrap(name: "__le__", doc: nil, fn: PyTuple.isLessEqual(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__gt__", value: PyBuiltinFunction.wrap(name: "__gt__", doc: nil, fn: PyTuple.isGreater(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__ge__", value: PyBuiltinFunction.wrap(name: "__ge__", doc: nil, fn: PyTuple.isGreaterEqual(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__hash__", value: PyBuiltinFunction.wrap(name: "__hash__", doc: nil, fn: PyTuple.hash, castSelf: Self.asTuple))
    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyTuple.repr, castSelf: Self.asTuple))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyTuple.getAttribute(name:), castSelf: Self.asTuple))
    insert(type: type, name: "__len__", value: PyBuiltinFunction.wrap(name: "__len__", doc: nil, fn: PyTuple.getLength, castSelf: Self.asTuple))
    insert(type: type, name: "__contains__", value: PyBuiltinFunction.wrap(name: "__contains__", doc: nil, fn: PyTuple.contains(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__getitem__", value: PyBuiltinFunction.wrap(name: "__getitem__", doc: nil, fn: PyTuple.getItem(at:), castSelf: Self.asTuple))
    insert(type: type, name: "count", value: PyBuiltinFunction.wrap(name: "count", doc: nil, fn: PyTuple.count(_:), castSelf: Self.asTuple))
    insert(type: type, name: "index", value: PyBuiltinFunction.wrap(name: "index", doc: nil, fn: PyTuple.index(of:start:end:), castSelf: Self.asTuple))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyTuple.iter, castSelf: Self.asTuple))
    insert(type: type, name: "__add__", value: PyBuiltinFunction.wrap(name: "__add__", doc: nil, fn: PyTuple.add(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__mul__", value: PyBuiltinFunction.wrap(name: "__mul__", doc: nil, fn: PyTuple.mul(_:), castSelf: Self.asTuple))
    insert(type: type, name: "__rmul__", value: PyBuiltinFunction.wrap(name: "__rmul__", doc: nil, fn: PyTuple.rmul(_:), castSelf: Self.asTuple))
  }

  private static func asTuple(_ object: PyObject, methodName: String) -> PyResult<PyTuple> {
    return Self.cast(
      object,
      as: PyTuple.self,
      typeName: "tuple",
      methodName: methodName
    )
  }

  // MARK: - TupleIterator

  func fillTupleIterator() {
    let type = self.tuple_iterator
    type.setBuiltinTypeDoc(nil)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyTupleIterator)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTupleIterator.getClass, castSelf: Self.asTupleIterator))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyTupleIterator.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyTupleIterator.getAttribute(name:), castSelf: Self.asTupleIterator))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyTupleIterator.iter, castSelf: Self.asTupleIterator))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyTupleIterator.next, castSelf: Self.asTupleIterator))
  }

  private static func asTupleIterator(_ object: PyObject, methodName: String) -> PyResult<PyTupleIterator> {
    return Self.cast(
      object,
      as: PyTupleIterator.self,
      typeName: "tuple_iterator",
      methodName: methodName
    )
  }

  // MARK: - Type

  func fillType() {
    let type = self.type
    type.setBuiltinTypeDoc(PyType.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setFlag(.typeSubclass)
    type.setLayout(.PyType)

    insert(type: type, name: "__name__", value: PyProperty.wrap(name: "__name__", doc: nil, get: PyType.getName, set: PyType.setName, castSelf: Self.asType))
    insert(type: type, name: "__qualname__", value: PyProperty.wrap(name: "__qualname__", doc: nil, get: PyType.getQualname, set: PyType.setQualname, castSelf: Self.asType))
    insert(type: type, name: "__doc__", value: PyProperty.wrap(name: "__doc__", doc: nil, get: PyType.getDoc, set: PyType.setDoc, castSelf: Self.asType))
    insert(type: type, name: "__module__", value: PyProperty.wrap(name: "__module__", doc: nil, get: PyType.getModule, set: PyType.setModule, castSelf: Self.asType))
    insert(type: type, name: "__bases__", value: PyProperty.wrap(name: "__bases__", doc: nil, get: PyType.getBases, set: PyType.setBases, castSelf: Self.asType))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyType.getDict, castSelf: Self.asType))
    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyType.getClass, castSelf: Self.asType))
    insert(type: type, name: "__base__", value: PyProperty.wrap(name: "__base__", doc: nil, get: PyType.getBase, castSelf: Self.asType))
    insert(type: type, name: "__mro__", value: PyProperty.wrap(name: "__mro__", doc: nil, get: PyType.getMRO, castSelf: Self.asType))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyType.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyType.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyType.repr, castSelf: Self.asType))
    insert(type: type, name: "__subclasscheck__", value: PyBuiltinFunction.wrap(name: "__subclasscheck__", doc: nil, fn: PyType.isSubtype(of:), castSelf: Self.asType))
    insert(type: type, name: "__instancecheck__", value: PyBuiltinFunction.wrap(name: "__instancecheck__", doc: nil, fn: PyType.isType(of:), castSelf: Self.asType))
    insert(type: type, name: "__subclasses__", value: PyBuiltinFunction.wrap(name: "__subclasses__", doc: nil, fn: PyType.getSubclasses, castSelf: Self.asType))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyType.getAttribute(name:), castSelf: Self.asType))
    insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyType.setAttribute(name:value:), castSelf: Self.asType))
    insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyType.delAttribute(name:), castSelf: Self.asType))
    insert(type: type, name: "__dir__", value: PyBuiltinFunction.wrap(name: "__dir__", doc: nil, fn: PyType.dir, castSelf: Self.asType))
    insert(type: type, name: "__call__", value: PyBuiltinFunction.wrap(name: "__call__", doc: nil, fn: PyType.call(args:kwargs:), castSelf: Self.asType))
  }

  private static func asType(_ object: PyObject, methodName: String) -> PyResult<PyType> {
    return Self.cast(
      object,
      as: PyType.self,
      typeName: "type",
      methodName: methodName
    )
  }

  // MARK: - Zip

  func fillZip() {
    let type = self.zip
    type.setBuiltinTypeDoc(PyZip.doc)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyZip)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyZip.getClass, castSelf: Self.asZip))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyZip.pyNew(type:args:kwargs:)))

    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyZip.getAttribute(name:), castSelf: Self.asZip))
    insert(type: type, name: "__iter__", value: PyBuiltinFunction.wrap(name: "__iter__", doc: nil, fn: PyZip.iter, castSelf: Self.asZip))
    insert(type: type, name: "__next__", value: PyBuiltinFunction.wrap(name: "__next__", doc: nil, fn: PyZip.next, castSelf: Self.asZip))
  }

  private static func asZip(_ object: PyObject, methodName: String) -> PyResult<PyZip> {
    return Self.cast(
      object,
      as: PyZip.self,
      typeName: "zip",
      methodName: methodName
    )
  }

}
