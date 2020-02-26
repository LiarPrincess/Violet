// swiftlint:disable file_length

/// Predefined commonly used `__dict__` keys.
/// Similiar to `_Py_IDENTIFIER` in `CPython`.
///
/// Performance of this 'cache' (because that what it actually is)
/// is crucial for overall performance.
/// Even using a dictionary (with its `O(1) + massive constants` access)
/// may be too slow.
/// We will do it in a bit different way with approximate complexity between
/// 'it will be inlined anyway' and 'hello cache, my old friend'.
///
/// We also need to support cleaning for when `Py` gets destroyed.
public struct IdString {

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

  public static let __abs__ = Self.impl.__abs__
  public static let __abstractmethods__ = Self.impl.__abstractmethods__
  public static let __add__ = Self.impl.__add__
  public static let __aiter__ = Self.impl.__aiter__
  public static let __and__ = Self.impl.__and__
  public static let __anext__ = Self.impl.__anext__
  public static let __await__ = Self.impl.__await__
  public static let __bases__ = Self.impl.__bases__
  public static let __bool__ = Self.impl.__bool__
  public static let __build_class__ = Self.impl.__build_class__
  public static let __builtins__ = Self.impl.__builtins__
  public static let __bytes__ = Self.impl.__bytes__
  public static let __call__ = Self.impl.__call__
  public static let __class__ = Self.impl.__class__
  public static let __class_getitem__ = Self.impl.__class_getitem__
  public static let __classcell__ = Self.impl.__classcell__
  public static let __complex__ = Self.impl.__complex__
  public static let __contains__ = Self.impl.__contains__
  public static let __del__ = Self.impl.__del__
  public static let __delattr__ = Self.impl.__delattr__
  public static let __delete__ = Self.impl.__delete__
  public static let __delitem__ = Self.impl.__delitem__
  public static let __dict__ = Self.impl.__dict__
  public static let __dir__ = Self.impl.__dir__
  public static let __divmod__ = Self.impl.__divmod__
  public static let __doc__ = Self.impl.__doc__
  public static let __eq__ = Self.impl.__eq__
  public static let __file__ = Self.impl.__file__
  public static let __float__ = Self.impl.__float__
  public static let __floordiv__ = Self.impl.__floordiv__
  public static let __format__ = Self.impl.__format__
  public static let __ge__ = Self.impl.__ge__
  public static let __get__ = Self.impl.__get__
  public static let __getattr__ = Self.impl.__getattr__
  public static let __getattribute__ = Self.impl.__getattribute__
  public static let __getitem__ = Self.impl.__getitem__
  public static let __getnewargs__ = Self.impl.__getnewargs__
  public static let __getnewargs_ex__ = Self.impl.__getnewargs_ex__
  public static let __getstate__ = Self.impl.__getstate__
  public static let __gt__ = Self.impl.__gt__
  public static let __hash__ = Self.impl.__hash__
  public static let __iadd__ = Self.impl.__iadd__
  public static let __iand__ = Self.impl.__iand__
  public static let __idivmod__ = Self.impl.__idivmod__
  public static let __ifloordiv__ = Self.impl.__ifloordiv__
  public static let __ilshift__ = Self.impl.__ilshift__
  public static let __imatmul__ = Self.impl.__imatmul__
  public static let __imod__ = Self.impl.__imod__
  public static let __import__ = Self.impl.__import__
  public static let __imul__ = Self.impl.__imul__
  public static let __index__ = Self.impl.__index__
  public static let __init__ = Self.impl.__init__
  public static let __init_subclass__ = Self.impl.__init_subclass__
  public static let __instancecheck__ = Self.impl.__instancecheck__
  public static let __invert__ = Self.impl.__invert__
  public static let __ior__ = Self.impl.__ior__
  public static let __ipow__ = Self.impl.__ipow__
  public static let __irshift__ = Self.impl.__irshift__
  public static let __isabstractmethod__ = Self.impl.__isabstractmethod__
  public static let __isub__ = Self.impl.__isub__
  public static let __iter__ = Self.impl.__iter__
  public static let __itruediv__ = Self.impl.__itruediv__
  public static let __ixor__ = Self.impl.__ixor__
  public static let __le__ = Self.impl.__le__
  public static let __len__ = Self.impl.__len__
  public static let __length_hint__ = Self.impl.__length_hint__
  public static let __loader__ = Self.impl.__loader__
  public static let __lshift__ = Self.impl.__lshift__
  public static let __lt__ = Self.impl.__lt__
  public static let __matmul__ = Self.impl.__matmul__
  public static let __missing__ = Self.impl.__missing__
  public static let __mod__ = Self.impl.__mod__
  public static let __module__ = Self.impl.__module__
  public static let __mro_entries__ = Self.impl.__mro_entries__
  public static let __mul__ = Self.impl.__mul__
  public static let __name__ = Self.impl.__name__
  public static let __ne__ = Self.impl.__ne__
  public static let __neg__ = Self.impl.__neg__
  public static let __new__ = Self.impl.__new__
  public static let __newobj__ = Self.impl.__newobj__
  public static let __newobj_ex__ = Self.impl.__newobj_ex__
  public static let __next__ = Self.impl.__next__
  public static let __or__ = Self.impl.__or__
  public static let __package__ = Self.impl.__package__
  public static let __pos__ = Self.impl.__pos__
  public static let __pow__ = Self.impl.__pow__
  public static let __prepare__ = Self.impl.__prepare__
  public static let __qualname__ = Self.impl.__qualname__
  public static let __radd__ = Self.impl.__radd__
  public static let __rand__ = Self.impl.__rand__
  public static let __rdivmod__ = Self.impl.__rdivmod__
  public static let __reduce__ = Self.impl.__reduce__
  public static let __repr__ = Self.impl.__repr__
  public static let __reversed__ = Self.impl.__reversed__
  public static let __rfloordiv__ = Self.impl.__rfloordiv__
  public static let __rlshift__ = Self.impl.__rlshift__
  public static let __rmatmul__ = Self.impl.__rmatmul__
  public static let __rmod__ = Self.impl.__rmod__
  public static let __rmul__ = Self.impl.__rmul__
  public static let __ror__ = Self.impl.__ror__
  public static let __round__ = Self.impl.__round__
  public static let __rpow__ = Self.impl.__rpow__
  public static let __rrshift__ = Self.impl.__rrshift__
  public static let __rshift__ = Self.impl.__rshift__
  public static let __rsub__ = Self.impl.__rsub__
  public static let __rtruediv__ = Self.impl.__rtruediv__
  public static let __rxor__ = Self.impl.__rxor__
  public static let __set__ = Self.impl.__set__
  public static let __set_name__ = Self.impl.__set_name__
  public static let __setattr__ = Self.impl.__setattr__
  public static let __setitem__ = Self.impl.__setitem__
  public static let __slotnames__ = Self.impl.__slotnames__
  public static let __slots__ = Self.impl.__slots__
  public static let __spec__ = Self.impl.__spec__
  public static let __str__ = Self.impl.__str__
  public static let __sub__ = Self.impl.__sub__
  public static let __subclasscheck__ = Self.impl.__subclasscheck__
  public static let __subclasshook__ = Self.impl.__subclasshook__
  public static let __truediv__ = Self.impl.__truediv__
  public static let __trunc__ = Self.impl.__trunc__
  public static let __xor__ = Self.impl.__xor__
  public static let _slotnames = Self.impl._slotnames
  public static let big = Self.impl.big
  public static let builtins = Self.impl.builtins
  public static let close = Self.impl.close
  public static let copy = Self.impl.copy
  public static let copyreg = Self.impl.copyreg
  public static let difference_update = Self.impl.difference_update
  public static let fileno = Self.impl.fileno
  public static let foo = Self.impl.foo
  public static let get = Self.impl.get
  public static let getattr = Self.impl.getattr
  public static let intersection_update = Self.impl.intersection_update
  public static let items = Self.impl.items
  public static let keys = Self.impl.keys
  public static let little = Self.impl.little
  public static let metaclass = Self.impl.metaclass
  public static let mro = Self.impl.mro
  public static let n_fields = Self.impl.n_fields
  public static let n_sequence_fields = Self.impl.n_sequence_fields
  public static let n_unnamed_fields = Self.impl.n_unnamed_fields
  public static let name = Self.impl.name
  public static let open = Self.impl.open
  public static let path = Self.impl.path
  public static let Py_Repr = Self.impl.Py_Repr
  public static let readline = Self.impl.readline
  public static let sorted = Self.impl.sorted
  public static let special = Self.impl.special
  public static let symmetric_difference_update = Self.impl.symmetric_difference_update
  public static let `throw` = Self.impl.`throw`
  public static let update = Self.impl.update
  public static let values = Self.impl.values
  public static let varname = Self.impl.varname
  public static let write = Self.impl.write
}
private struct IdStringImpl {
  fileprivate let __abs__ = IdString(value: "__abs__")
  fileprivate let __abstractmethods__ = IdString(value: "__abstractmethods__")
  fileprivate let __add__ = IdString(value: "__add__")
  fileprivate let __aiter__ = IdString(value: "__aiter__")
  fileprivate let __and__ = IdString(value: "__and__")
  fileprivate let __anext__ = IdString(value: "__anext__")
  fileprivate let __await__ = IdString(value: "__await__")
  fileprivate let __bases__ = IdString(value: "__bases__")
  fileprivate let __bool__ = IdString(value: "__bool__")
  fileprivate let __build_class__ = IdString(value: "__build_class__")
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
  fileprivate let __divmod__ = IdString(value: "__divmod__")
  fileprivate let __doc__ = IdString(value: "__doc__")
  fileprivate let __eq__ = IdString(value: "__eq__")
  fileprivate let __file__ = IdString(value: "__file__")
  fileprivate let __float__ = IdString(value: "__float__")
  fileprivate let __floordiv__ = IdString(value: "__floordiv__")
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
  fileprivate let __iadd__ = IdString(value: "__iadd__")
  fileprivate let __iand__ = IdString(value: "__iand__")
  fileprivate let __idivmod__ = IdString(value: "__idivmod__")
  fileprivate let __ifloordiv__ = IdString(value: "__ifloordiv__")
  fileprivate let __ilshift__ = IdString(value: "__ilshift__")
  fileprivate let __imatmul__ = IdString(value: "__imatmul__")
  fileprivate let __imod__ = IdString(value: "__imod__")
  fileprivate let __import__ = IdString(value: "__import__")
  fileprivate let __imul__ = IdString(value: "__imul__")
  fileprivate let __index__ = IdString(value: "__index__")
  fileprivate let __init__ = IdString(value: "__init__")
  fileprivate let __init_subclass__ = IdString(value: "__init_subclass__")
  fileprivate let __instancecheck__ = IdString(value: "__instancecheck__")
  fileprivate let __invert__ = IdString(value: "__invert__")
  fileprivate let __ior__ = IdString(value: "__ior__")
  fileprivate let __ipow__ = IdString(value: "__ipow__")
  fileprivate let __irshift__ = IdString(value: "__irshift__")
  fileprivate let __isabstractmethod__ = IdString(value: "__isabstractmethod__")
  fileprivate let __isub__ = IdString(value: "__isub__")
  fileprivate let __iter__ = IdString(value: "__iter__")
  fileprivate let __itruediv__ = IdString(value: "__itruediv__")
  fileprivate let __ixor__ = IdString(value: "__ixor__")
  fileprivate let __le__ = IdString(value: "__le__")
  fileprivate let __len__ = IdString(value: "__len__")
  fileprivate let __length_hint__ = IdString(value: "__length_hint__")
  fileprivate let __loader__ = IdString(value: "__loader__")
  fileprivate let __lshift__ = IdString(value: "__lshift__")
  fileprivate let __lt__ = IdString(value: "__lt__")
  fileprivate let __matmul__ = IdString(value: "__matmul__")
  fileprivate let __missing__ = IdString(value: "__missing__")
  fileprivate let __mod__ = IdString(value: "__mod__")
  fileprivate let __module__ = IdString(value: "__module__")
  fileprivate let __mro_entries__ = IdString(value: "__mro_entries__")
  fileprivate let __mul__ = IdString(value: "__mul__")
  fileprivate let __name__ = IdString(value: "__name__")
  fileprivate let __ne__ = IdString(value: "__ne__")
  fileprivate let __neg__ = IdString(value: "__neg__")
  fileprivate let __new__ = IdString(value: "__new__")
  fileprivate let __newobj__ = IdString(value: "__newobj__")
  fileprivate let __newobj_ex__ = IdString(value: "__newobj_ex__")
  fileprivate let __next__ = IdString(value: "__next__")
  fileprivate let __or__ = IdString(value: "__or__")
  fileprivate let __package__ = IdString(value: "__package__")
  fileprivate let __pos__ = IdString(value: "__pos__")
  fileprivate let __pow__ = IdString(value: "__pow__")
  fileprivate let __prepare__ = IdString(value: "__prepare__")
  fileprivate let __qualname__ = IdString(value: "__qualname__")
  fileprivate let __radd__ = IdString(value: "__radd__")
  fileprivate let __rand__ = IdString(value: "__rand__")
  fileprivate let __rdivmod__ = IdString(value: "__rdivmod__")
  fileprivate let __reduce__ = IdString(value: "__reduce__")
  fileprivate let __repr__ = IdString(value: "__repr__")
  fileprivate let __reversed__ = IdString(value: "__reversed__")
  fileprivate let __rfloordiv__ = IdString(value: "__rfloordiv__")
  fileprivate let __rlshift__ = IdString(value: "__rlshift__")
  fileprivate let __rmatmul__ = IdString(value: "__rmatmul__")
  fileprivate let __rmod__ = IdString(value: "__rmod__")
  fileprivate let __rmul__ = IdString(value: "__rmul__")
  fileprivate let __ror__ = IdString(value: "__ror__")
  fileprivate let __round__ = IdString(value: "__round__")
  fileprivate let __rpow__ = IdString(value: "__rpow__")
  fileprivate let __rrshift__ = IdString(value: "__rrshift__")
  fileprivate let __rshift__ = IdString(value: "__rshift__")
  fileprivate let __rsub__ = IdString(value: "__rsub__")
  fileprivate let __rtruediv__ = IdString(value: "__rtruediv__")
  fileprivate let __rxor__ = IdString(value: "__rxor__")
  fileprivate let __set__ = IdString(value: "__set__")
  fileprivate let __set_name__ = IdString(value: "__set_name__")
  fileprivate let __setattr__ = IdString(value: "__setattr__")
  fileprivate let __setitem__ = IdString(value: "__setitem__")
  fileprivate let __slotnames__ = IdString(value: "__slotnames__")
  fileprivate let __slots__ = IdString(value: "__slots__")
  fileprivate let __spec__ = IdString(value: "__spec__")
  fileprivate let __str__ = IdString(value: "__str__")
  fileprivate let __sub__ = IdString(value: "__sub__")
  fileprivate let __subclasscheck__ = IdString(value: "__subclasscheck__")
  fileprivate let __subclasshook__ = IdString(value: "__subclasshook__")
  fileprivate let __truediv__ = IdString(value: "__truediv__")
  fileprivate let __trunc__ = IdString(value: "__trunc__")
  fileprivate let __xor__ = IdString(value: "__xor__")
  fileprivate let _slotnames = IdString(value: "_slotnames")
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
  fileprivate let `throw` = IdString(value: "throw")
  fileprivate let update = IdString(value: "update")
  fileprivate let values = IdString(value: "values")
  fileprivate let varname = IdString(value: "varname")
  fileprivate let write = IdString(value: "write")
}
