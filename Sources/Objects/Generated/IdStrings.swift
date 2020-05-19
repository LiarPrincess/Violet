// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable file_length
// swiftlint:disable function_body_length

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

  // MARK: - Initialize

  /// Create new set of `ids`.
  internal static func initialize() {
    Self.___abs__ = IdString(value: "__abs__")
    Self.___add__ = IdString(value: "__add__")
    Self.___all__ = IdString(value: "__all__")
    Self.___and__ = IdString(value: "__and__")
    Self.___annotations__ = IdString(value: "__annotations__")
    Self.___bool__ = IdString(value: "__bool__")
    Self.___build_class__ = IdString(value: "__build_class__")
    Self.___builtins__ = IdString(value: "__builtins__")
    Self.___call__ = IdString(value: "__call__")
    Self.___class__ = IdString(value: "__class__")
    Self.___class_getitem__ = IdString(value: "__class_getitem__")
    Self.___classcell__ = IdString(value: "__classcell__")
    Self.___complex__ = IdString(value: "__complex__")
    Self.___contains__ = IdString(value: "__contains__")
    Self.___del__ = IdString(value: "__del__")
    Self.___delattr__ = IdString(value: "__delattr__")
    Self.___delitem__ = IdString(value: "__delitem__")
    Self.___dict__ = IdString(value: "__dict__")
    Self.___dir__ = IdString(value: "__dir__")
    Self.___divmod__ = IdString(value: "__divmod__")
    Self.___doc__ = IdString(value: "__doc__")
    Self.___enter__ = IdString(value: "__enter__")
    Self.___eq__ = IdString(value: "__eq__")
    Self.___exit__ = IdString(value: "__exit__")
    Self.___file__ = IdString(value: "__file__")
    Self.___float__ = IdString(value: "__float__")
    Self.___floordiv__ = IdString(value: "__floordiv__")
    Self.___ge__ = IdString(value: "__ge__")
    Self.___get__ = IdString(value: "__get__")
    Self.___getattr__ = IdString(value: "__getattr__")
    Self.___getattribute__ = IdString(value: "__getattribute__")
    Self.___getitem__ = IdString(value: "__getitem__")
    Self.___gt__ = IdString(value: "__gt__")
    Self.___hash__ = IdString(value: "__hash__")
    Self.___iadd__ = IdString(value: "__iadd__")
    Self.___iand__ = IdString(value: "__iand__")
    Self.___idivmod__ = IdString(value: "__idivmod__")
    Self.___ifloordiv__ = IdString(value: "__ifloordiv__")
    Self.___ilshift__ = IdString(value: "__ilshift__")
    Self.___imatmul__ = IdString(value: "__imatmul__")
    Self.___imod__ = IdString(value: "__imod__")
    Self.___import__ = IdString(value: "__import__")
    Self.___imul__ = IdString(value: "__imul__")
    Self.___index__ = IdString(value: "__index__")
    Self.___init__ = IdString(value: "__init__")
    Self.___init_subclass__ = IdString(value: "__init_subclass__")
    Self.___instancecheck__ = IdString(value: "__instancecheck__")
    Self.___int__ = IdString(value: "__int__")
    Self.___invert__ = IdString(value: "__invert__")
    Self.___ior__ = IdString(value: "__ior__")
    Self.___ipow__ = IdString(value: "__ipow__")
    Self.___irshift__ = IdString(value: "__irshift__")
    Self.___isabstractmethod__ = IdString(value: "__isabstractmethod__")
    Self.___isub__ = IdString(value: "__isub__")
    Self.___iter__ = IdString(value: "__iter__")
    Self.___itruediv__ = IdString(value: "__itruediv__")
    Self.___ixor__ = IdString(value: "__ixor__")
    Self.___le__ = IdString(value: "__le__")
    Self.___len__ = IdString(value: "__len__")
    Self.___loader__ = IdString(value: "__loader__")
    Self.___lshift__ = IdString(value: "__lshift__")
    Self.___lt__ = IdString(value: "__lt__")
    Self.___matmul__ = IdString(value: "__matmul__")
    Self.___missing__ = IdString(value: "__missing__")
    Self.___mod__ = IdString(value: "__mod__")
    Self.___module__ = IdString(value: "__module__")
    Self.___mul__ = IdString(value: "__mul__")
    Self.___name__ = IdString(value: "__name__")
    Self.___ne__ = IdString(value: "__ne__")
    Self.___neg__ = IdString(value: "__neg__")
    Self.___new__ = IdString(value: "__new__")
    Self.___next__ = IdString(value: "__next__")
    Self.___or__ = IdString(value: "__or__")
    Self.___package__ = IdString(value: "__package__")
    Self.___path__ = IdString(value: "__path__")
    Self.___pos__ = IdString(value: "__pos__")
    Self.___pow__ = IdString(value: "__pow__")
    Self.___prepare__ = IdString(value: "__prepare__")
    Self.___qualname__ = IdString(value: "__qualname__")
    Self.___radd__ = IdString(value: "__radd__")
    Self.___rand__ = IdString(value: "__rand__")
    Self.___rdivmod__ = IdString(value: "__rdivmod__")
    Self.___repr__ = IdString(value: "__repr__")
    Self.___reversed__ = IdString(value: "__reversed__")
    Self.___rfloordiv__ = IdString(value: "__rfloordiv__")
    Self.___rlshift__ = IdString(value: "__rlshift__")
    Self.___rmatmul__ = IdString(value: "__rmatmul__")
    Self.___rmod__ = IdString(value: "__rmod__")
    Self.___rmul__ = IdString(value: "__rmul__")
    Self.___ror__ = IdString(value: "__ror__")
    Self.___round__ = IdString(value: "__round__")
    Self.___rpow__ = IdString(value: "__rpow__")
    Self.___rrshift__ = IdString(value: "__rrshift__")
    Self.___rshift__ = IdString(value: "__rshift__")
    Self.___rsub__ = IdString(value: "__rsub__")
    Self.___rtruediv__ = IdString(value: "__rtruediv__")
    Self.___rxor__ = IdString(value: "__rxor__")
    Self.___set__ = IdString(value: "__set__")
    Self.___set_name__ = IdString(value: "__set_name__")
    Self.___setattr__ = IdString(value: "__setattr__")
    Self.___setitem__ = IdString(value: "__setitem__")
    Self.___spec__ = IdString(value: "__spec__")
    Self.___str__ = IdString(value: "__str__")
    Self.___sub__ = IdString(value: "__sub__")
    Self.___subclasscheck__ = IdString(value: "__subclasscheck__")
    Self.___truediv__ = IdString(value: "__truediv__")
    Self.___trunc__ = IdString(value: "__trunc__")
    Self.___warningregistry__ = IdString(value: "__warningregistry__")
    Self.___xor__ = IdString(value: "__xor__")
    Self.__find_and_load = IdString(value: "_find_and_load")
    Self.__handle_fromlist = IdString(value: "_handle_fromlist")
    Self._builtins = IdString(value: "builtins")
    Self._encoding = IdString(value: "encoding")
    Self._keys = IdString(value: "keys")
    Self._metaclass = IdString(value: "metaclass")
    Self._mro = IdString(value: "mro")
    Self._name = IdString(value: "name")
    Self._object = IdString(value: "object")
    Self._origin = IdString(value: "origin")
  }

  // MARK: - GC

  /// Clean when `Py` gets destroyed.
  internal static func gcClean() {
    Self.___abs__ = nil
    Self.___add__ = nil
    Self.___all__ = nil
    Self.___and__ = nil
    Self.___annotations__ = nil
    Self.___bool__ = nil
    Self.___build_class__ = nil
    Self.___builtins__ = nil
    Self.___call__ = nil
    Self.___class__ = nil
    Self.___class_getitem__ = nil
    Self.___classcell__ = nil
    Self.___complex__ = nil
    Self.___contains__ = nil
    Self.___del__ = nil
    Self.___delattr__ = nil
    Self.___delitem__ = nil
    Self.___dict__ = nil
    Self.___dir__ = nil
    Self.___divmod__ = nil
    Self.___doc__ = nil
    Self.___enter__ = nil
    Self.___eq__ = nil
    Self.___exit__ = nil
    Self.___file__ = nil
    Self.___float__ = nil
    Self.___floordiv__ = nil
    Self.___ge__ = nil
    Self.___get__ = nil
    Self.___getattr__ = nil
    Self.___getattribute__ = nil
    Self.___getitem__ = nil
    Self.___gt__ = nil
    Self.___hash__ = nil
    Self.___iadd__ = nil
    Self.___iand__ = nil
    Self.___idivmod__ = nil
    Self.___ifloordiv__ = nil
    Self.___ilshift__ = nil
    Self.___imatmul__ = nil
    Self.___imod__ = nil
    Self.___import__ = nil
    Self.___imul__ = nil
    Self.___index__ = nil
    Self.___init__ = nil
    Self.___init_subclass__ = nil
    Self.___instancecheck__ = nil
    Self.___int__ = nil
    Self.___invert__ = nil
    Self.___ior__ = nil
    Self.___ipow__ = nil
    Self.___irshift__ = nil
    Self.___isabstractmethod__ = nil
    Self.___isub__ = nil
    Self.___iter__ = nil
    Self.___itruediv__ = nil
    Self.___ixor__ = nil
    Self.___le__ = nil
    Self.___len__ = nil
    Self.___loader__ = nil
    Self.___lshift__ = nil
    Self.___lt__ = nil
    Self.___matmul__ = nil
    Self.___missing__ = nil
    Self.___mod__ = nil
    Self.___module__ = nil
    Self.___mul__ = nil
    Self.___name__ = nil
    Self.___ne__ = nil
    Self.___neg__ = nil
    Self.___new__ = nil
    Self.___next__ = nil
    Self.___or__ = nil
    Self.___package__ = nil
    Self.___path__ = nil
    Self.___pos__ = nil
    Self.___pow__ = nil
    Self.___prepare__ = nil
    Self.___qualname__ = nil
    Self.___radd__ = nil
    Self.___rand__ = nil
    Self.___rdivmod__ = nil
    Self.___repr__ = nil
    Self.___reversed__ = nil
    Self.___rfloordiv__ = nil
    Self.___rlshift__ = nil
    Self.___rmatmul__ = nil
    Self.___rmod__ = nil
    Self.___rmul__ = nil
    Self.___ror__ = nil
    Self.___round__ = nil
    Self.___rpow__ = nil
    Self.___rrshift__ = nil
    Self.___rshift__ = nil
    Self.___rsub__ = nil
    Self.___rtruediv__ = nil
    Self.___rxor__ = nil
    Self.___set__ = nil
    Self.___set_name__ = nil
    Self.___setattr__ = nil
    Self.___setitem__ = nil
    Self.___spec__ = nil
    Self.___str__ = nil
    Self.___sub__ = nil
    Self.___subclasscheck__ = nil
    Self.___truediv__ = nil
    Self.___trunc__ = nil
    Self.___warningregistry__ = nil
    Self.___xor__ = nil
    Self.__find_and_load = nil
    Self.__handle_fromlist = nil
    Self._builtins = nil
    Self._encoding = nil
    Self._keys = nil
    Self._metaclass = nil
    Self._mro = nil
    Self._name = nil
    Self._object = nil
    Self._origin = nil
  }

  private static func nilPropertyMessage(id: String) -> String {
    return "Missing 'IdString.\(id)' " +
           "Are you trying to use IdStrings without initializing 'Py'?"
  }

  // MARK: - __abs__

  private static var ___abs__: IdString!
  public static var __abs__: IdString {
    precondition(Self.___abs__ != nil, nilPropertyMessage(id: "__abs__)"))
    return Self.___abs__!
  }

  // MARK: - __add__

  private static var ___add__: IdString!
  public static var __add__: IdString {
    precondition(Self.___add__ != nil, nilPropertyMessage(id: "__add__)"))
    return Self.___add__!
  }

  // MARK: - __all__

  private static var ___all__: IdString!
  public static var __all__: IdString {
    precondition(Self.___all__ != nil, nilPropertyMessage(id: "__all__)"))
    return Self.___all__!
  }

  // MARK: - __and__

  private static var ___and__: IdString!
  public static var __and__: IdString {
    precondition(Self.___and__ != nil, nilPropertyMessage(id: "__and__)"))
    return Self.___and__!
  }

  // MARK: - __annotations__

  private static var ___annotations__: IdString!
  public static var __annotations__: IdString {
    precondition(Self.___annotations__ != nil, nilPropertyMessage(id: "__annotations__)"))
    return Self.___annotations__!
  }

  // MARK: - __bool__

  private static var ___bool__: IdString!
  public static var __bool__: IdString {
    precondition(Self.___bool__ != nil, nilPropertyMessage(id: "__bool__)"))
    return Self.___bool__!
  }

  // MARK: - __build_class__

  private static var ___build_class__: IdString!
  public static var __build_class__: IdString {
    precondition(Self.___build_class__ != nil, nilPropertyMessage(id: "__build_class__)"))
    return Self.___build_class__!
  }

  // MARK: - __builtins__

  private static var ___builtins__: IdString!
  public static var __builtins__: IdString {
    precondition(Self.___builtins__ != nil, nilPropertyMessage(id: "__builtins__)"))
    return Self.___builtins__!
  }

  // MARK: - __call__

  private static var ___call__: IdString!
  public static var __call__: IdString {
    precondition(Self.___call__ != nil, nilPropertyMessage(id: "__call__)"))
    return Self.___call__!
  }

  // MARK: - __class__

  private static var ___class__: IdString!
  public static var __class__: IdString {
    precondition(Self.___class__ != nil, nilPropertyMessage(id: "__class__)"))
    return Self.___class__!
  }

  // MARK: - __class_getitem__

  private static var ___class_getitem__: IdString!
  public static var __class_getitem__: IdString {
    precondition(Self.___class_getitem__ != nil, nilPropertyMessage(id: "__class_getitem__)"))
    return Self.___class_getitem__!
  }

  // MARK: - __classcell__

  private static var ___classcell__: IdString!
  public static var __classcell__: IdString {
    precondition(Self.___classcell__ != nil, nilPropertyMessage(id: "__classcell__)"))
    return Self.___classcell__!
  }

  // MARK: - __complex__

  private static var ___complex__: IdString!
  public static var __complex__: IdString {
    precondition(Self.___complex__ != nil, nilPropertyMessage(id: "__complex__)"))
    return Self.___complex__!
  }

  // MARK: - __contains__

  private static var ___contains__: IdString!
  public static var __contains__: IdString {
    precondition(Self.___contains__ != nil, nilPropertyMessage(id: "__contains__)"))
    return Self.___contains__!
  }

  // MARK: - __del__

  private static var ___del__: IdString!
  public static var __del__: IdString {
    precondition(Self.___del__ != nil, nilPropertyMessage(id: "__del__)"))
    return Self.___del__!
  }

  // MARK: - __delattr__

  private static var ___delattr__: IdString!
  public static var __delattr__: IdString {
    precondition(Self.___delattr__ != nil, nilPropertyMessage(id: "__delattr__)"))
    return Self.___delattr__!
  }

  // MARK: - __delitem__

  private static var ___delitem__: IdString!
  public static var __delitem__: IdString {
    precondition(Self.___delitem__ != nil, nilPropertyMessage(id: "__delitem__)"))
    return Self.___delitem__!
  }

  // MARK: - __dict__

  private static var ___dict__: IdString!
  public static var __dict__: IdString {
    precondition(Self.___dict__ != nil, nilPropertyMessage(id: "__dict__)"))
    return Self.___dict__!
  }

  // MARK: - __dir__

  private static var ___dir__: IdString!
  public static var __dir__: IdString {
    precondition(Self.___dir__ != nil, nilPropertyMessage(id: "__dir__)"))
    return Self.___dir__!
  }

  // MARK: - __divmod__

  private static var ___divmod__: IdString!
  public static var __divmod__: IdString {
    precondition(Self.___divmod__ != nil, nilPropertyMessage(id: "__divmod__)"))
    return Self.___divmod__!
  }

  // MARK: - __doc__

  private static var ___doc__: IdString!
  public static var __doc__: IdString {
    precondition(Self.___doc__ != nil, nilPropertyMessage(id: "__doc__)"))
    return Self.___doc__!
  }

  // MARK: - __enter__

  private static var ___enter__: IdString!
  public static var __enter__: IdString {
    precondition(Self.___enter__ != nil, nilPropertyMessage(id: "__enter__)"))
    return Self.___enter__!
  }

  // MARK: - __eq__

  private static var ___eq__: IdString!
  public static var __eq__: IdString {
    precondition(Self.___eq__ != nil, nilPropertyMessage(id: "__eq__)"))
    return Self.___eq__!
  }

  // MARK: - __exit__

  private static var ___exit__: IdString!
  public static var __exit__: IdString {
    precondition(Self.___exit__ != nil, nilPropertyMessage(id: "__exit__)"))
    return Self.___exit__!
  }

  // MARK: - __file__

  private static var ___file__: IdString!
  public static var __file__: IdString {
    precondition(Self.___file__ != nil, nilPropertyMessage(id: "__file__)"))
    return Self.___file__!
  }

  // MARK: - __float__

  private static var ___float__: IdString!
  public static var __float__: IdString {
    precondition(Self.___float__ != nil, nilPropertyMessage(id: "__float__)"))
    return Self.___float__!
  }

  // MARK: - __floordiv__

  private static var ___floordiv__: IdString!
  public static var __floordiv__: IdString {
    precondition(Self.___floordiv__ != nil, nilPropertyMessage(id: "__floordiv__)"))
    return Self.___floordiv__!
  }

  // MARK: - __ge__

  private static var ___ge__: IdString!
  public static var __ge__: IdString {
    precondition(Self.___ge__ != nil, nilPropertyMessage(id: "__ge__)"))
    return Self.___ge__!
  }

  // MARK: - __get__

  private static var ___get__: IdString!
  public static var __get__: IdString {
    precondition(Self.___get__ != nil, nilPropertyMessage(id: "__get__)"))
    return Self.___get__!
  }

  // MARK: - __getattr__

  private static var ___getattr__: IdString!
  public static var __getattr__: IdString {
    precondition(Self.___getattr__ != nil, nilPropertyMessage(id: "__getattr__)"))
    return Self.___getattr__!
  }

  // MARK: - __getattribute__

  private static var ___getattribute__: IdString!
  public static var __getattribute__: IdString {
    precondition(Self.___getattribute__ != nil, nilPropertyMessage(id: "__getattribute__)"))
    return Self.___getattribute__!
  }

  // MARK: - __getitem__

  private static var ___getitem__: IdString!
  public static var __getitem__: IdString {
    precondition(Self.___getitem__ != nil, nilPropertyMessage(id: "__getitem__)"))
    return Self.___getitem__!
  }

  // MARK: - __gt__

  private static var ___gt__: IdString!
  public static var __gt__: IdString {
    precondition(Self.___gt__ != nil, nilPropertyMessage(id: "__gt__)"))
    return Self.___gt__!
  }

  // MARK: - __hash__

  private static var ___hash__: IdString!
  public static var __hash__: IdString {
    precondition(Self.___hash__ != nil, nilPropertyMessage(id: "__hash__)"))
    return Self.___hash__!
  }

  // MARK: - __iadd__

  private static var ___iadd__: IdString!
  public static var __iadd__: IdString {
    precondition(Self.___iadd__ != nil, nilPropertyMessage(id: "__iadd__)"))
    return Self.___iadd__!
  }

  // MARK: - __iand__

  private static var ___iand__: IdString!
  public static var __iand__: IdString {
    precondition(Self.___iand__ != nil, nilPropertyMessage(id: "__iand__)"))
    return Self.___iand__!
  }

  // MARK: - __idivmod__

  private static var ___idivmod__: IdString!
  public static var __idivmod__: IdString {
    precondition(Self.___idivmod__ != nil, nilPropertyMessage(id: "__idivmod__)"))
    return Self.___idivmod__!
  }

  // MARK: - __ifloordiv__

  private static var ___ifloordiv__: IdString!
  public static var __ifloordiv__: IdString {
    precondition(Self.___ifloordiv__ != nil, nilPropertyMessage(id: "__ifloordiv__)"))
    return Self.___ifloordiv__!
  }

  // MARK: - __ilshift__

  private static var ___ilshift__: IdString!
  public static var __ilshift__: IdString {
    precondition(Self.___ilshift__ != nil, nilPropertyMessage(id: "__ilshift__)"))
    return Self.___ilshift__!
  }

  // MARK: - __imatmul__

  private static var ___imatmul__: IdString!
  public static var __imatmul__: IdString {
    precondition(Self.___imatmul__ != nil, nilPropertyMessage(id: "__imatmul__)"))
    return Self.___imatmul__!
  }

  // MARK: - __imod__

  private static var ___imod__: IdString!
  public static var __imod__: IdString {
    precondition(Self.___imod__ != nil, nilPropertyMessage(id: "__imod__)"))
    return Self.___imod__!
  }

  // MARK: - __import__

  private static var ___import__: IdString!
  public static var __import__: IdString {
    precondition(Self.___import__ != nil, nilPropertyMessage(id: "__import__)"))
    return Self.___import__!
  }

  // MARK: - __imul__

  private static var ___imul__: IdString!
  public static var __imul__: IdString {
    precondition(Self.___imul__ != nil, nilPropertyMessage(id: "__imul__)"))
    return Self.___imul__!
  }

  // MARK: - __index__

  private static var ___index__: IdString!
  public static var __index__: IdString {
    precondition(Self.___index__ != nil, nilPropertyMessage(id: "__index__)"))
    return Self.___index__!
  }

  // MARK: - __init__

  private static var ___init__: IdString!
  public static var __init__: IdString {
    precondition(Self.___init__ != nil, nilPropertyMessage(id: "__init__)"))
    return Self.___init__!
  }

  // MARK: - __init_subclass__

  private static var ___init_subclass__: IdString!
  public static var __init_subclass__: IdString {
    precondition(Self.___init_subclass__ != nil, nilPropertyMessage(id: "__init_subclass__)"))
    return Self.___init_subclass__!
  }

  // MARK: - __instancecheck__

  private static var ___instancecheck__: IdString!
  public static var __instancecheck__: IdString {
    precondition(Self.___instancecheck__ != nil, nilPropertyMessage(id: "__instancecheck__)"))
    return Self.___instancecheck__!
  }

  // MARK: - __int__

  private static var ___int__: IdString!
  public static var __int__: IdString {
    precondition(Self.___int__ != nil, nilPropertyMessage(id: "__int__)"))
    return Self.___int__!
  }

  // MARK: - __invert__

  private static var ___invert__: IdString!
  public static var __invert__: IdString {
    precondition(Self.___invert__ != nil, nilPropertyMessage(id: "__invert__)"))
    return Self.___invert__!
  }

  // MARK: - __ior__

  private static var ___ior__: IdString!
  public static var __ior__: IdString {
    precondition(Self.___ior__ != nil, nilPropertyMessage(id: "__ior__)"))
    return Self.___ior__!
  }

  // MARK: - __ipow__

  private static var ___ipow__: IdString!
  public static var __ipow__: IdString {
    precondition(Self.___ipow__ != nil, nilPropertyMessage(id: "__ipow__)"))
    return Self.___ipow__!
  }

  // MARK: - __irshift__

  private static var ___irshift__: IdString!
  public static var __irshift__: IdString {
    precondition(Self.___irshift__ != nil, nilPropertyMessage(id: "__irshift__)"))
    return Self.___irshift__!
  }

  // MARK: - __isabstractmethod__

  private static var ___isabstractmethod__: IdString!
  public static var __isabstractmethod__: IdString {
    precondition(Self.___isabstractmethod__ != nil, nilPropertyMessage(id: "__isabstractmethod__)"))
    return Self.___isabstractmethod__!
  }

  // MARK: - __isub__

  private static var ___isub__: IdString!
  public static var __isub__: IdString {
    precondition(Self.___isub__ != nil, nilPropertyMessage(id: "__isub__)"))
    return Self.___isub__!
  }

  // MARK: - __iter__

  private static var ___iter__: IdString!
  public static var __iter__: IdString {
    precondition(Self.___iter__ != nil, nilPropertyMessage(id: "__iter__)"))
    return Self.___iter__!
  }

  // MARK: - __itruediv__

  private static var ___itruediv__: IdString!
  public static var __itruediv__: IdString {
    precondition(Self.___itruediv__ != nil, nilPropertyMessage(id: "__itruediv__)"))
    return Self.___itruediv__!
  }

  // MARK: - __ixor__

  private static var ___ixor__: IdString!
  public static var __ixor__: IdString {
    precondition(Self.___ixor__ != nil, nilPropertyMessage(id: "__ixor__)"))
    return Self.___ixor__!
  }

  // MARK: - __le__

  private static var ___le__: IdString!
  public static var __le__: IdString {
    precondition(Self.___le__ != nil, nilPropertyMessage(id: "__le__)"))
    return Self.___le__!
  }

  // MARK: - __len__

  private static var ___len__: IdString!
  public static var __len__: IdString {
    precondition(Self.___len__ != nil, nilPropertyMessage(id: "__len__)"))
    return Self.___len__!
  }

  // MARK: - __loader__

  private static var ___loader__: IdString!
  public static var __loader__: IdString {
    precondition(Self.___loader__ != nil, nilPropertyMessage(id: "__loader__)"))
    return Self.___loader__!
  }

  // MARK: - __lshift__

  private static var ___lshift__: IdString!
  public static var __lshift__: IdString {
    precondition(Self.___lshift__ != nil, nilPropertyMessage(id: "__lshift__)"))
    return Self.___lshift__!
  }

  // MARK: - __lt__

  private static var ___lt__: IdString!
  public static var __lt__: IdString {
    precondition(Self.___lt__ != nil, nilPropertyMessage(id: "__lt__)"))
    return Self.___lt__!
  }

  // MARK: - __matmul__

  private static var ___matmul__: IdString!
  public static var __matmul__: IdString {
    precondition(Self.___matmul__ != nil, nilPropertyMessage(id: "__matmul__)"))
    return Self.___matmul__!
  }

  // MARK: - __missing__

  private static var ___missing__: IdString!
  public static var __missing__: IdString {
    precondition(Self.___missing__ != nil, nilPropertyMessage(id: "__missing__)"))
    return Self.___missing__!
  }

  // MARK: - __mod__

  private static var ___mod__: IdString!
  public static var __mod__: IdString {
    precondition(Self.___mod__ != nil, nilPropertyMessage(id: "__mod__)"))
    return Self.___mod__!
  }

  // MARK: - __module__

  private static var ___module__: IdString!
  public static var __module__: IdString {
    precondition(Self.___module__ != nil, nilPropertyMessage(id: "__module__)"))
    return Self.___module__!
  }

  // MARK: - __mul__

  private static var ___mul__: IdString!
  public static var __mul__: IdString {
    precondition(Self.___mul__ != nil, nilPropertyMessage(id: "__mul__)"))
    return Self.___mul__!
  }

  // MARK: - __name__

  private static var ___name__: IdString!
  public static var __name__: IdString {
    precondition(Self.___name__ != nil, nilPropertyMessage(id: "__name__)"))
    return Self.___name__!
  }

  // MARK: - __ne__

  private static var ___ne__: IdString!
  public static var __ne__: IdString {
    precondition(Self.___ne__ != nil, nilPropertyMessage(id: "__ne__)"))
    return Self.___ne__!
  }

  // MARK: - __neg__

  private static var ___neg__: IdString!
  public static var __neg__: IdString {
    precondition(Self.___neg__ != nil, nilPropertyMessage(id: "__neg__)"))
    return Self.___neg__!
  }

  // MARK: - __new__

  private static var ___new__: IdString!
  public static var __new__: IdString {
    precondition(Self.___new__ != nil, nilPropertyMessage(id: "__new__)"))
    return Self.___new__!
  }

  // MARK: - __next__

  private static var ___next__: IdString!
  public static var __next__: IdString {
    precondition(Self.___next__ != nil, nilPropertyMessage(id: "__next__)"))
    return Self.___next__!
  }

  // MARK: - __or__

  private static var ___or__: IdString!
  public static var __or__: IdString {
    precondition(Self.___or__ != nil, nilPropertyMessage(id: "__or__)"))
    return Self.___or__!
  }

  // MARK: - __package__

  private static var ___package__: IdString!
  public static var __package__: IdString {
    precondition(Self.___package__ != nil, nilPropertyMessage(id: "__package__)"))
    return Self.___package__!
  }

  // MARK: - __path__

  private static var ___path__: IdString!
  public static var __path__: IdString {
    precondition(Self.___path__ != nil, nilPropertyMessage(id: "__path__)"))
    return Self.___path__!
  }

  // MARK: - __pos__

  private static var ___pos__: IdString!
  public static var __pos__: IdString {
    precondition(Self.___pos__ != nil, nilPropertyMessage(id: "__pos__)"))
    return Self.___pos__!
  }

  // MARK: - __pow__

  private static var ___pow__: IdString!
  public static var __pow__: IdString {
    precondition(Self.___pow__ != nil, nilPropertyMessage(id: "__pow__)"))
    return Self.___pow__!
  }

  // MARK: - __prepare__

  private static var ___prepare__: IdString!
  public static var __prepare__: IdString {
    precondition(Self.___prepare__ != nil, nilPropertyMessage(id: "__prepare__)"))
    return Self.___prepare__!
  }

  // MARK: - __qualname__

  private static var ___qualname__: IdString!
  public static var __qualname__: IdString {
    precondition(Self.___qualname__ != nil, nilPropertyMessage(id: "__qualname__)"))
    return Self.___qualname__!
  }

  // MARK: - __radd__

  private static var ___radd__: IdString!
  public static var __radd__: IdString {
    precondition(Self.___radd__ != nil, nilPropertyMessage(id: "__radd__)"))
    return Self.___radd__!
  }

  // MARK: - __rand__

  private static var ___rand__: IdString!
  public static var __rand__: IdString {
    precondition(Self.___rand__ != nil, nilPropertyMessage(id: "__rand__)"))
    return Self.___rand__!
  }

  // MARK: - __rdivmod__

  private static var ___rdivmod__: IdString!
  public static var __rdivmod__: IdString {
    precondition(Self.___rdivmod__ != nil, nilPropertyMessage(id: "__rdivmod__)"))
    return Self.___rdivmod__!
  }

  // MARK: - __repr__

  private static var ___repr__: IdString!
  public static var __repr__: IdString {
    precondition(Self.___repr__ != nil, nilPropertyMessage(id: "__repr__)"))
    return Self.___repr__!
  }

  // MARK: - __reversed__

  private static var ___reversed__: IdString!
  public static var __reversed__: IdString {
    precondition(Self.___reversed__ != nil, nilPropertyMessage(id: "__reversed__)"))
    return Self.___reversed__!
  }

  // MARK: - __rfloordiv__

  private static var ___rfloordiv__: IdString!
  public static var __rfloordiv__: IdString {
    precondition(Self.___rfloordiv__ != nil, nilPropertyMessage(id: "__rfloordiv__)"))
    return Self.___rfloordiv__!
  }

  // MARK: - __rlshift__

  private static var ___rlshift__: IdString!
  public static var __rlshift__: IdString {
    precondition(Self.___rlshift__ != nil, nilPropertyMessage(id: "__rlshift__)"))
    return Self.___rlshift__!
  }

  // MARK: - __rmatmul__

  private static var ___rmatmul__: IdString!
  public static var __rmatmul__: IdString {
    precondition(Self.___rmatmul__ != nil, nilPropertyMessage(id: "__rmatmul__)"))
    return Self.___rmatmul__!
  }

  // MARK: - __rmod__

  private static var ___rmod__: IdString!
  public static var __rmod__: IdString {
    precondition(Self.___rmod__ != nil, nilPropertyMessage(id: "__rmod__)"))
    return Self.___rmod__!
  }

  // MARK: - __rmul__

  private static var ___rmul__: IdString!
  public static var __rmul__: IdString {
    precondition(Self.___rmul__ != nil, nilPropertyMessage(id: "__rmul__)"))
    return Self.___rmul__!
  }

  // MARK: - __ror__

  private static var ___ror__: IdString!
  public static var __ror__: IdString {
    precondition(Self.___ror__ != nil, nilPropertyMessage(id: "__ror__)"))
    return Self.___ror__!
  }

  // MARK: - __round__

  private static var ___round__: IdString!
  public static var __round__: IdString {
    precondition(Self.___round__ != nil, nilPropertyMessage(id: "__round__)"))
    return Self.___round__!
  }

  // MARK: - __rpow__

  private static var ___rpow__: IdString!
  public static var __rpow__: IdString {
    precondition(Self.___rpow__ != nil, nilPropertyMessage(id: "__rpow__)"))
    return Self.___rpow__!
  }

  // MARK: - __rrshift__

  private static var ___rrshift__: IdString!
  public static var __rrshift__: IdString {
    precondition(Self.___rrshift__ != nil, nilPropertyMessage(id: "__rrshift__)"))
    return Self.___rrshift__!
  }

  // MARK: - __rshift__

  private static var ___rshift__: IdString!
  public static var __rshift__: IdString {
    precondition(Self.___rshift__ != nil, nilPropertyMessage(id: "__rshift__)"))
    return Self.___rshift__!
  }

  // MARK: - __rsub__

  private static var ___rsub__: IdString!
  public static var __rsub__: IdString {
    precondition(Self.___rsub__ != nil, nilPropertyMessage(id: "__rsub__)"))
    return Self.___rsub__!
  }

  // MARK: - __rtruediv__

  private static var ___rtruediv__: IdString!
  public static var __rtruediv__: IdString {
    precondition(Self.___rtruediv__ != nil, nilPropertyMessage(id: "__rtruediv__)"))
    return Self.___rtruediv__!
  }

  // MARK: - __rxor__

  private static var ___rxor__: IdString!
  public static var __rxor__: IdString {
    precondition(Self.___rxor__ != nil, nilPropertyMessage(id: "__rxor__)"))
    return Self.___rxor__!
  }

  // MARK: - __set__

  private static var ___set__: IdString!
  public static var __set__: IdString {
    precondition(Self.___set__ != nil, nilPropertyMessage(id: "__set__)"))
    return Self.___set__!
  }

  // MARK: - __set_name__

  private static var ___set_name__: IdString!
  public static var __set_name__: IdString {
    precondition(Self.___set_name__ != nil, nilPropertyMessage(id: "__set_name__)"))
    return Self.___set_name__!
  }

  // MARK: - __setattr__

  private static var ___setattr__: IdString!
  public static var __setattr__: IdString {
    precondition(Self.___setattr__ != nil, nilPropertyMessage(id: "__setattr__)"))
    return Self.___setattr__!
  }

  // MARK: - __setitem__

  private static var ___setitem__: IdString!
  public static var __setitem__: IdString {
    precondition(Self.___setitem__ != nil, nilPropertyMessage(id: "__setitem__)"))
    return Self.___setitem__!
  }

  // MARK: - __spec__

  private static var ___spec__: IdString!
  public static var __spec__: IdString {
    precondition(Self.___spec__ != nil, nilPropertyMessage(id: "__spec__)"))
    return Self.___spec__!
  }

  // MARK: - __str__

  private static var ___str__: IdString!
  public static var __str__: IdString {
    precondition(Self.___str__ != nil, nilPropertyMessage(id: "__str__)"))
    return Self.___str__!
  }

  // MARK: - __sub__

  private static var ___sub__: IdString!
  public static var __sub__: IdString {
    precondition(Self.___sub__ != nil, nilPropertyMessage(id: "__sub__)"))
    return Self.___sub__!
  }

  // MARK: - __subclasscheck__

  private static var ___subclasscheck__: IdString!
  public static var __subclasscheck__: IdString {
    precondition(Self.___subclasscheck__ != nil, nilPropertyMessage(id: "__subclasscheck__)"))
    return Self.___subclasscheck__!
  }

  // MARK: - __truediv__

  private static var ___truediv__: IdString!
  public static var __truediv__: IdString {
    precondition(Self.___truediv__ != nil, nilPropertyMessage(id: "__truediv__)"))
    return Self.___truediv__!
  }

  // MARK: - __trunc__

  private static var ___trunc__: IdString!
  public static var __trunc__: IdString {
    precondition(Self.___trunc__ != nil, nilPropertyMessage(id: "__trunc__)"))
    return Self.___trunc__!
  }

  // MARK: - __warningregistry__

  private static var ___warningregistry__: IdString!
  public static var __warningregistry__: IdString {
    precondition(Self.___warningregistry__ != nil, nilPropertyMessage(id: "__warningregistry__)"))
    return Self.___warningregistry__!
  }

  // MARK: - __xor__

  private static var ___xor__: IdString!
  public static var __xor__: IdString {
    precondition(Self.___xor__ != nil, nilPropertyMessage(id: "__xor__)"))
    return Self.___xor__!
  }

  // MARK: - _find_and_load

  private static var __find_and_load: IdString!
  public static var _find_and_load: IdString {
    precondition(Self.__find_and_load != nil, nilPropertyMessage(id: "_find_and_load)"))
    return Self.__find_and_load!
  }

  // MARK: - _handle_fromlist

  private static var __handle_fromlist: IdString!
  public static var _handle_fromlist: IdString {
    precondition(Self.__handle_fromlist != nil, nilPropertyMessage(id: "_handle_fromlist)"))
    return Self.__handle_fromlist!
  }

  // MARK: - builtins

  private static var _builtins: IdString!
  public static var builtins: IdString {
    precondition(Self._builtins != nil, nilPropertyMessage(id: "builtins)"))
    return Self._builtins!
  }

  // MARK: - encoding

  private static var _encoding: IdString!
  public static var encoding: IdString {
    precondition(Self._encoding != nil, nilPropertyMessage(id: "encoding)"))
    return Self._encoding!
  }

  // MARK: - keys

  private static var _keys: IdString!
  public static var keys: IdString {
    precondition(Self._keys != nil, nilPropertyMessage(id: "keys)"))
    return Self._keys!
  }

  // MARK: - metaclass

  private static var _metaclass: IdString!
  public static var metaclass: IdString {
    precondition(Self._metaclass != nil, nilPropertyMessage(id: "metaclass)"))
    return Self._metaclass!
  }

  // MARK: - mro

  private static var _mro: IdString!
  public static var mro: IdString {
    precondition(Self._mro != nil, nilPropertyMessage(id: "mro)"))
    return Self._mro!
  }

  // MARK: - name

  private static var _name: IdString!
  public static var name: IdString {
    precondition(Self._name != nil, nilPropertyMessage(id: "name)"))
    return Self._name!
  }

  // MARK: - object

  private static var _object: IdString!
  public static var object: IdString {
    precondition(Self._object != nil, nilPropertyMessage(id: "object)"))
    return Self._object!
  }

  // MARK: - origin

  private static var _origin: IdString!
  public static var origin: IdString {
    precondition(Self._origin != nil, nilPropertyMessage(id: "origin)"))
    return Self._origin!
  }
}
