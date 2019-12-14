// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable trailing_comma

public final class BuiltinTypes {

  /// Root of the type hierarchy
  public let object: PyType
  /// Type which is set as `type` on all of the `PyType` objects
  public let type: PyType

  public let bool: PyType
  public let builtinFunction: PyType
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
  public let reversed: PyType
  public let set: PyType
  public let set_iterator: PyType
  public let slice: PyType
  public let str: PyType
  public let str_iterator: PyType
  public let tuple: PyType
  public let tuple_iterator: PyType

  /// Init that will only initialize properties.
  /// You need to call `postInit` to fill `__dict__` etc.!
  internal init(context: PyContext) {
    // Requirements (for 'self.object' and 'self.type'):
    // 1. 'type' inherits from 'object'
    // 2. both 'type' and 'object' are instances of 'type'
    self.object = PyType.initObjectType(context)
    self.type = PyType.initTypeType(objectType: self.object)
    self.object.setType(to: self.type)
    self.type.setType(to: self.type)

    // 'self.bool' has to be last because it uses 'self.int' as base!
    self.builtinFunction = PyType.initBuiltinType(name: "builtinFunction", type: self.type, base: self.object)
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
    self.reversed = PyType.initBuiltinType(name: "reversed", type: self.type, base: self.object)
    self.set = PyType.initBuiltinType(name: "set", type: self.type, base: self.object)
    self.set_iterator = PyType.initBuiltinType(name: "set_iterator", type: self.type, base: self.object)
    self.slice = PyType.initBuiltinType(name: "slice", type: self.type, base: self.object)
    self.str = PyType.initBuiltinType(name: "str", type: self.type, base: self.object)
    self.str_iterator = PyType.initBuiltinType(name: "str_iterator", type: self.type, base: self.object)
    self.tuple = PyType.initBuiltinType(name: "tuple", type: self.type, base: self.object)
    self.tuple_iterator = PyType.initBuiltinType(name: "tuple_iterator", type: self.type, base: self.object)
    self.bool = PyType.initBuiltinType(name: "bool", type: self.type, base: self.int)
  }

  /// This function finalizes init of all of the stored types
  /// (adds `__doc__`, fills `__dict__` etc.) .
  internal func postInit() {
    BuiltinTypesFill.object(self.object)
    BuiltinTypesFill.type(self.type)
    BuiltinTypesFill.bool(self.bool)
    BuiltinTypesFill.builtinFunction(self.builtinFunction)
    BuiltinTypesFill.code(self.code)
    BuiltinTypesFill.complex(self.complex)
    BuiltinTypesFill.dict(self.dict)
    BuiltinTypesFill.dict_itemiterator(self.dict_itemiterator)
    BuiltinTypesFill.dict_items(self.dict_items)
    BuiltinTypesFill.dict_keyiterator(self.dict_keyiterator)
    BuiltinTypesFill.dict_keys(self.dict_keys)
    BuiltinTypesFill.dict_valueiterator(self.dict_valueiterator)
    BuiltinTypesFill.dict_values(self.dict_values)
    BuiltinTypesFill.ellipsis(self.ellipsis)
    BuiltinTypesFill.enumerate(self.enumerate)
    BuiltinTypesFill.filter(self.filter)
    BuiltinTypesFill.float(self.float)
    BuiltinTypesFill.frozenset(self.frozenset)
    BuiltinTypesFill.function(self.function)
    BuiltinTypesFill.int(self.int)
    BuiltinTypesFill.iterator(self.iterator)
    BuiltinTypesFill.list(self.list)
    BuiltinTypesFill.list_iterator(self.list_iterator)
    BuiltinTypesFill.list_reverseiterator(self.list_reverseiterator)
    BuiltinTypesFill.map(self.map)
    BuiltinTypesFill.method(self.method)
    BuiltinTypesFill.module(self.module)
    BuiltinTypesFill.simpleNamespace(self.simpleNamespace)
    BuiltinTypesFill.none(self.none)
    BuiltinTypesFill.notImplemented(self.notImplemented)
    BuiltinTypesFill.property(self.property)
    BuiltinTypesFill.range(self.range)
    BuiltinTypesFill.reversed(self.reversed)
    BuiltinTypesFill.set(self.set)
    BuiltinTypesFill.set_iterator(self.set_iterator)
    BuiltinTypesFill.slice(self.slice)
    BuiltinTypesFill.str(self.str)
    BuiltinTypesFill.str_iterator(self.str_iterator)
    BuiltinTypesFill.tuple(self.tuple)
    BuiltinTypesFill.tuple_iterator(self.tuple_iterator)
  }

  internal var all: [PyType] {
    return [
      self.object,
      self.type,
      self.bool,
      self.builtinFunction,
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
      self.reversed,
      self.set,
      self.set_iterator,
      self.slice,
      self.str,
      self.str_iterator,
      self.tuple,
      self.tuple_iterator,
    ]
  }
}
