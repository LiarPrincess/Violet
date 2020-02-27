// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable trailing_comma

// VERY IMPORTANT:
//
// Type initialization order:
//
// Stage 1: Create all type objects ('init()' function)
// Just instantiate all of the 'PyType' properties.
// At this point we can't fill '__dict__', because for this we would need other
// types to be already initialized (which would be circular).
// For example we can't fill '__doc__' because for this we would need 'str' type,
// which may not yet exist.
//
// Stage 2: Fill type objects ('fill__dict__()' method)
// When all of the types are initalized we can finally fill dictionaries.

public final class BuiltinTypes {

  /// Root of the type hierarchy
  public let object: PyType
  /// Type which is set as `type` on all of the `PyType` objects
  public let type: PyType

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
  public let textFile: PyType
  public let tuple: PyType
  public let tuple_iterator: PyType
  public let zip: PyType

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
    self.textFile = PyType.initBuiltinType(name: "TextFile", type: self.type, base: self.object)
    self.tuple = PyType.initBuiltinType(name: "tuple", type: self.type, base: self.object)
    self.tuple_iterator = PyType.initBuiltinType(name: "tuple_iterator", type: self.type, base: self.object)
    self.zip = PyType.initBuiltinType(name: "zip", type: self.type, base: self.object)
    self.bool = PyType.initBuiltinType(name: "bool", type: self.type, base: self.int)
  }

  /// This function finalizes init of all of the stored types.
  /// (see comment at the top of this file)
  ///
  /// For example it will:
  /// - set type flags
  /// - add `__doc__`
  /// - fill `__dict__`
  internal func fill__dict__() {
    FillTypes.object(self.object)
    FillTypes.type(self.type)
    FillTypes.bool(self.bool)
    FillTypes.builtinFunction(self.builtinFunction)
    FillTypes.builtinMethod(self.builtinMethod)
    FillTypes.bytearray(self.bytearray)
    FillTypes.bytearray_iterator(self.bytearray_iterator)
    FillTypes.bytes(self.bytes)
    FillTypes.bytes_iterator(self.bytes_iterator)
    FillTypes.callable_iterator(self.callable_iterator)
    FillTypes.cell(self.cell)
    FillTypes.classmethod(self.classmethod)
    FillTypes.code(self.code)
    FillTypes.complex(self.complex)
    FillTypes.dict(self.dict)
    FillTypes.dict_itemiterator(self.dict_itemiterator)
    FillTypes.dict_items(self.dict_items)
    FillTypes.dict_keyiterator(self.dict_keyiterator)
    FillTypes.dict_keys(self.dict_keys)
    FillTypes.dict_valueiterator(self.dict_valueiterator)
    FillTypes.dict_values(self.dict_values)
    FillTypes.ellipsis(self.ellipsis)
    FillTypes.enumerate(self.enumerate)
    FillTypes.filter(self.filter)
    FillTypes.float(self.float)
    FillTypes.frozenset(self.frozenset)
    FillTypes.function(self.function)
    FillTypes.int(self.int)
    FillTypes.iterator(self.iterator)
    FillTypes.list(self.list)
    FillTypes.list_iterator(self.list_iterator)
    FillTypes.list_reverseiterator(self.list_reverseiterator)
    FillTypes.map(self.map)
    FillTypes.method(self.method)
    FillTypes.module(self.module)
    FillTypes.simpleNamespace(self.simpleNamespace)
    FillTypes.none(self.none)
    FillTypes.notImplemented(self.notImplemented)
    FillTypes.property(self.property)
    FillTypes.range(self.range)
    FillTypes.range_iterator(self.range_iterator)
    FillTypes.reversed(self.reversed)
    FillTypes.set(self.set)
    FillTypes.set_iterator(self.set_iterator)
    FillTypes.slice(self.slice)
    FillTypes.staticmethod(self.staticmethod)
    FillTypes.str(self.str)
    FillTypes.str_iterator(self.str_iterator)
    FillTypes.textFile(self.textFile)
    FillTypes.tuple(self.tuple)
    FillTypes.tuple_iterator(self.tuple_iterator)
    FillTypes.zip(self.zip)
  }

  internal var all: [PyType] {
    return [
      self.object,
      self.type,
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
      self.textFile,
      self.tuple,
      self.tuple_iterator,
      self.zip,
    ]
  }
}
