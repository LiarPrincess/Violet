/// Predefined commonly used `__dict__` keys.
/// Similiar to `_Py_IDENTIFIER` in `CPython`.
///
/// Performance of this 'cache' (because that is what it actually is)
/// is crucial for performance.
/// Even using an dictionary (with its `O(1) + massive constants` access)
/// may be too slow.
/// We will do it in a bit different way.
///
/// We also need to support cleaning for when `Py` gets destroyed.
internal struct IdString {

  internal let value: PyString
  internal let hash: PyHash

  fileprivate init(value: String) {
    self.value = Py.newString(value)
    self.hash = self.value.hashRaw()
  }

  private static var _impl: IdStringImpl?
  private static var impl: IdStringImpl {
    if let i = Self._impl { return i }

    let i = IdStringImpl()
    Self._impl = i
    return i
  }

  /// Clean when `Py` gets destroyed.
  internal static func gcClean() {
    Self._impl = nil
  }

  internal static let __abstractmethods__ = Self.impl.__abstractmethods__
  internal static let __aiter__ = Self.impl.__aiter__
  internal static let __anext__ = Self.impl.__anext__
  internal static let __await__ = Self.impl.__await__
  internal static let __bases__ = Self.impl.__bases__
  internal static let __bool__ = Self.impl.__bool__
  internal static let __builtins__ = Self.impl.__builtins__
  internal static let __bytes__ = Self.impl.__bytes__
  internal static let __call__ = Self.impl.__call__
  internal static let __class__ = Self.impl.__class__
  internal static let __class_getitem__ = Self.impl.__class_getitem__
  internal static let __classcell__ = Self.impl.__classcell__
  internal static let __complex__ = Self.impl.__complex__
  internal static let __contains__ = Self.impl.__contains__
  internal static let __del__ = Self.impl.__del__
  internal static let __delattr__ = Self.impl.__delattr__
  internal static let __delete__ = Self.impl.__delete__
  internal static let __delitem__ = Self.impl.__delitem__
  internal static let __dict__ = Self.impl.__dict__
  internal static let __dir__ = Self.impl.__dir__
  internal static let __doc__ = Self.impl.__doc__
  internal static let __eq__ = Self.impl.__eq__
  internal static let __file__ = Self.impl.__file__
  internal static let __format__ = Self.impl.__format__
  internal static let __ge__ = Self.impl.__ge__
  internal static let __get__ = Self.impl.__get__
  internal static let __getattr__ = Self.impl.__getattr__
  internal static let __getattribute__ = Self.impl.__getattribute__
  internal static let __getitem__ = Self.impl.__getitem__
  internal static let __getnewargs__ = Self.impl.__getnewargs__
  internal static let __getnewargs_ex__ = Self.impl.__getnewargs_ex__
  internal static let __getstate__ = Self.impl.__getstate__
  internal static let __gt__ = Self.impl.__gt__
  internal static let __hash__ = Self.impl.__hash__
  internal static let __index__ = Self.impl.__index__
  internal static let __init__ = Self.impl.__init__
  internal static let __init_subclass__ = Self.impl.__init_subclass__
  internal static let __instancecheck__ = Self.impl.__instancecheck__
  internal static let __ipow__ = Self.impl.__ipow__
  internal static let __isabstractmethod__ = Self.impl.__isabstractmethod__
  internal static let __iter__ = Self.impl.__iter__
  internal static let __le__ = Self.impl.__le__
  internal static let __len__ = Self.impl.__len__
  internal static let __length_hint__ = Self.impl.__length_hint__
  internal static let __loader__ = Self.impl.__loader__
  internal static let __lt__ = Self.impl.__lt__
  internal static let __missing__ = Self.impl.__missing__
  internal static let __module__ = Self.impl.__module__
  internal static let __mro_entries__ = Self.impl.__mro_entries__
  internal static let __name__ = Self.impl.__name__
  internal static let __ne__ = Self.impl.__ne__
  internal static let __new__ = Self.impl.__new__
  internal static let __newobj__ = Self.impl.__newobj__
  internal static let __newobj_ex__ = Self.impl.__newobj_ex__
  internal static let __next__ = Self.impl.__next__
  internal static let __package__ = Self.impl.__package__
  internal static let __pow__ = Self.impl.__pow__
  internal static let __qualname__ = Self.impl.__qualname__
  internal static let __reduce__ = Self.impl.__reduce__
  internal static let __repr__ = Self.impl.__repr__
  internal static let __reversed__ = Self.impl.__reversed__
  internal static let __set__ = Self.impl.__set__
  internal static let __set_name__ = Self.impl.__set_name__
  internal static let __setattr__ = Self.impl.__setattr__
  internal static let __setitem__ = Self.impl.__setitem__
  internal static let __slotnames__ = Self.impl.__slotnames__
  internal static let __slots__ = Self.impl.__slots__
  internal static let __spec__ = Self.impl.__spec__
  internal static let __str__ = Self.impl.__str__
  internal static let __subclasscheck__ = Self.impl.__subclasscheck__
  internal static let __subclasshook__ = Self.impl.__subclasshook__
  internal static let __trunc__ = Self.impl.__trunc__
  internal static let _slotnames = Self.impl._slotnames
  internal static let `throw` = Self.impl.`throw`
  internal static let big = Self.impl.big
  internal static let builtins = Self.impl.builtins
  internal static let close = Self.impl.close
  internal static let copy = Self.impl.copy
  internal static let copyreg = Self.impl.copyreg
  internal static let difference_update = Self.impl.difference_update
  internal static let fileno = Self.impl.fileno
  internal static let foo = Self.impl.foo
  internal static let get = Self.impl.get
  internal static let getattr = Self.impl.getattr
  internal static let intersection_update = Self.impl.intersection_update
  internal static let items = Self.impl.items
  internal static let keys = Self.impl.keys
  internal static let little = Self.impl.little
  internal static let metaclass = Self.impl.metaclass
  internal static let mro = Self.impl.mro
  internal static let n_fields = Self.impl.n_fields
  internal static let n_sequence_fields = Self.impl.n_sequence_fields
  internal static let n_unnamed_fields = Self.impl.n_unnamed_fields
  internal static let name = Self.impl.name
  internal static let open = Self.impl.open
  internal static let path = Self.impl.path
  internal static let Py_Repr = Self.impl.Py_Repr
  internal static let readline = Self.impl.readline
  internal static let sorted = Self.impl.sorted
  internal static let special = Self.impl.special
  internal static let symmetric_difference_update = Self.impl.symmetric_difference_update
  internal static let update = Self.impl.update
  internal static let values = Self.impl.values
  internal static let varname = Self.impl.varname
  internal static let write = Self.impl.write
}
private struct IdStringImpl {
  fileprivate let __abstractmethods__ = IdString(value: "__abstractmethods__")
  fileprivate let __aiter__ = IdString(value: "__aiter__")
  fileprivate let __anext__ = IdString(value: "__anext__")
  fileprivate let __await__ = IdString(value: "__await__")
  fileprivate let __bases__ = IdString(value: "__bases__")
  fileprivate let __bool__ = IdString(value: "__bool__")
  fileprivate let __builtins__ = IdString(value: "__builtins__")
  fileprivate let __bytes__ = IdString(value: "__bytes__")
  fileprivate let __call__ = IdString(value: "__call__")
  fileprivate let __class__ = IdString(value: "__class__")
  fileprivate let __class_getitem__ = IdString(value: "__class_getitem__")
  fileprivate let __classcell__ = IdString(value: "__classcell__")
  fileprivate let __complex__ = IdString(value: "__complex__")
  fileprivate let __contains__ = IdString(value: "__contains__")
  fileprivate let __del__ = IdString(value: "__del__")
  fileprivate let __delattr__ = IdString(value: "__delattr__")
  fileprivate let __delete__ = IdString(value: "__delete__")
  fileprivate let __delitem__ = IdString(value: "__delitem__")
  fileprivate let __dict__ = IdString(value: "__dict__")
  fileprivate let __dir__ = IdString(value: "__dir__")
  fileprivate let __doc__ = IdString(value: "__doc__")
  fileprivate let __eq__ = IdString(value: "__eq__")
  fileprivate let __file__ = IdString(value: "__file__")
  fileprivate let __format__ = IdString(value: "__format__")
  fileprivate let __ge__ = IdString(value: "__ge__")
  fileprivate let __get__ = IdString(value: "__get__")
  fileprivate let __getattr__ = IdString(value: "__getattr__")
  fileprivate let __getattribute__ = IdString(value: "__getattribute__")
  fileprivate let __getitem__ = IdString(value: "__getitem__")
  fileprivate let __getnewargs__ = IdString(value: "__getnewargs__")
  fileprivate let __getnewargs_ex__ = IdString(value: "__getnewargs_ex__")
  fileprivate let __getstate__ = IdString(value: "__getstate__")
  fileprivate let __gt__ = IdString(value: "__gt__")
  fileprivate let __hash__ = IdString(value: "__hash__")
  fileprivate let __index__ = IdString(value: "__index__")
  fileprivate let __init__ = IdString(value: "__init__")
  fileprivate let __init_subclass__ = IdString(value: "__init_subclass__")
  fileprivate let __instancecheck__ = IdString(value: "__instancecheck__")
  fileprivate let __ipow__ = IdString(value: "__ipow__")
  fileprivate let __isabstractmethod__ = IdString(value: "__isabstractmethod__")
  fileprivate let __iter__ = IdString(value: "__iter__")
  fileprivate let __le__ = IdString(value: "__le__")
  fileprivate let __len__ = IdString(value: "__len__")
  fileprivate let __length_hint__ = IdString(value: "__length_hint__")
  fileprivate let __loader__ = IdString(value: "__loader__")
  fileprivate let __lt__ = IdString(value: "__lt__")
  fileprivate let __missing__ = IdString(value: "__missing__")
  fileprivate let __module__ = IdString(value: "__module__")
  fileprivate let __mro_entries__ = IdString(value: "__mro_entries__")
  fileprivate let __name__ = IdString(value: "__name__")
  fileprivate let __ne__ = IdString(value: "__ne__")
  fileprivate let __new__ = IdString(value: "__new__")
  fileprivate let __newobj__ = IdString(value: "__newobj__")
  fileprivate let __newobj_ex__ = IdString(value: "__newobj_ex__")
  fileprivate let __next__ = IdString(value: "__next__")
  fileprivate let __package__ = IdString(value: "__package__")
  fileprivate let __pow__ = IdString(value: "__pow__")
  fileprivate let __qualname__ = IdString(value: "__qualname__")
  fileprivate let __reduce__ = IdString(value: "__reduce__")
  fileprivate let __repr__ = IdString(value: "__repr__")
  fileprivate let __reversed__ = IdString(value: "__reversed__")
  fileprivate let __set__ = IdString(value: "__set__")
  fileprivate let __set_name__ = IdString(value: "__set_name__")
  fileprivate let __setattr__ = IdString(value: "__setattr__")
  fileprivate let __setitem__ = IdString(value: "__setitem__")
  fileprivate let __slotnames__ = IdString(value: "__slotnames__")
  fileprivate let __slots__ = IdString(value: "__slots__")
  fileprivate let __spec__ = IdString(value: "__spec__")
  fileprivate let __str__ = IdString(value: "__str__")
  fileprivate let __subclasscheck__ = IdString(value: "__subclasscheck__")
  fileprivate let __subclasshook__ = IdString(value: "__subclasshook__")
  fileprivate let __trunc__ = IdString(value: "__trunc__")
  fileprivate let _slotnames = IdString(value: "_slotnames")
  fileprivate let `throw` = IdString(value: "throw")
  fileprivate let big = IdString(value: "big")
  fileprivate let builtins = IdString(value: "builtins")
  fileprivate let close = IdString(value: "close")
  fileprivate let copy = IdString(value: "copy")
  fileprivate let copyreg = IdString(value: "copyreg")
  fileprivate let difference_update = IdString(value: "difference_update")
  fileprivate let fileno = IdString(value: "fileno")
  fileprivate let foo = IdString(value: "foo")
  fileprivate let get = IdString(value: "get")
  fileprivate let getattr = IdString(value: "getattr")
  fileprivate let intersection_update = IdString(value: "intersection_update")
  fileprivate let items = IdString(value: "items")
  fileprivate let keys = IdString(value: "keys")
  fileprivate let little = IdString(value: "little")
  fileprivate let metaclass = IdString(value: "metaclass")
  fileprivate let mro = IdString(value: "mro")
  fileprivate let n_fields = IdString(value: "n_fields")
  fileprivate let n_sequence_fields = IdString(value: "n_sequence_fields")
  fileprivate let n_unnamed_fields = IdString(value: "n_unnamed_fields")
  fileprivate let name = IdString(value: "name")
  fileprivate let open = IdString(value: "open")
  fileprivate let path = IdString(value: "path")
  fileprivate let Py_Repr = IdString(value: "Py_Repr")
  fileprivate let readline = IdString(value: "readline")
  fileprivate let sorted = IdString(value: "sorted")
  fileprivate let special = IdString(value: "special")
  fileprivate let symmetric_difference_update = IdString(value: "symmetric_difference_update")
  fileprivate let update = IdString(value: "update")
  fileprivate let values = IdString(value: "values")
  fileprivate let varname = IdString(value: "varname")
  fileprivate let write = IdString(value: "write")
}
