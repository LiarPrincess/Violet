// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

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

  // MARK: - __abs__

  private static var ___abs__: IdString?
  public static var __abs__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___abs__ {
      return value
    }

    let value = IdString(value: "__abs__")
    Self.___abs__ = value
    return value
  }

  // MARK: - __add__

  private static var ___add__: IdString?
  public static var __add__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___add__ {
      return value
    }

    let value = IdString(value: "__add__")
    Self.___add__ = value
    return value
  }

  // MARK: - __all__

  private static var ___all__: IdString?
  public static var __all__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___all__ {
      return value
    }

    let value = IdString(value: "__all__")
    Self.___all__ = value
    return value
  }

  // MARK: - __and__

  private static var ___and__: IdString?
  public static var __and__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___and__ {
      return value
    }

    let value = IdString(value: "__and__")
    Self.___and__ = value
    return value
  }

  // MARK: - __annotations__

  private static var ___annotations__: IdString?
  public static var __annotations__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___annotations__ {
      return value
    }

    let value = IdString(value: "__annotations__")
    Self.___annotations__ = value
    return value
  }

  // MARK: - __bool__

  private static var ___bool__: IdString?
  public static var __bool__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___bool__ {
      return value
    }

    let value = IdString(value: "__bool__")
    Self.___bool__ = value
    return value
  }

  // MARK: - __build_class__

  private static var ___build_class__: IdString?
  public static var __build_class__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___build_class__ {
      return value
    }

    let value = IdString(value: "__build_class__")
    Self.___build_class__ = value
    return value
  }

  // MARK: - __builtins__

  private static var ___builtins__: IdString?
  public static var __builtins__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___builtins__ {
      return value
    }

    let value = IdString(value: "__builtins__")
    Self.___builtins__ = value
    return value
  }

  // MARK: - __call__

  private static var ___call__: IdString?
  public static var __call__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___call__ {
      return value
    }

    let value = IdString(value: "__call__")
    Self.___call__ = value
    return value
  }

  // MARK: - __class__

  private static var ___class__: IdString?
  public static var __class__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___class__ {
      return value
    }

    let value = IdString(value: "__class__")
    Self.___class__ = value
    return value
  }

  // MARK: - __class_getitem__

  private static var ___class_getitem__: IdString?
  public static var __class_getitem__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___class_getitem__ {
      return value
    }

    let value = IdString(value: "__class_getitem__")
    Self.___class_getitem__ = value
    return value
  }

  // MARK: - __classcell__

  private static var ___classcell__: IdString?
  public static var __classcell__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___classcell__ {
      return value
    }

    let value = IdString(value: "__classcell__")
    Self.___classcell__ = value
    return value
  }

  // MARK: - __complex__

  private static var ___complex__: IdString?
  public static var __complex__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___complex__ {
      return value
    }

    let value = IdString(value: "__complex__")
    Self.___complex__ = value
    return value
  }

  // MARK: - __contains__

  private static var ___contains__: IdString?
  public static var __contains__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___contains__ {
      return value
    }

    let value = IdString(value: "__contains__")
    Self.___contains__ = value
    return value
  }

  // MARK: - __del__

  private static var ___del__: IdString?
  public static var __del__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___del__ {
      return value
    }

    let value = IdString(value: "__del__")
    Self.___del__ = value
    return value
  }

  // MARK: - __delattr__

  private static var ___delattr__: IdString?
  public static var __delattr__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___delattr__ {
      return value
    }

    let value = IdString(value: "__delattr__")
    Self.___delattr__ = value
    return value
  }

  // MARK: - __delitem__

  private static var ___delitem__: IdString?
  public static var __delitem__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___delitem__ {
      return value
    }

    let value = IdString(value: "__delitem__")
    Self.___delitem__ = value
    return value
  }

  // MARK: - __dict__

  private static var ___dict__: IdString?
  public static var __dict__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___dict__ {
      return value
    }

    let value = IdString(value: "__dict__")
    Self.___dict__ = value
    return value
  }

  // MARK: - __dir__

  private static var ___dir__: IdString?
  public static var __dir__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___dir__ {
      return value
    }

    let value = IdString(value: "__dir__")
    Self.___dir__ = value
    return value
  }

  // MARK: - __divmod__

  private static var ___divmod__: IdString?
  public static var __divmod__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___divmod__ {
      return value
    }

    let value = IdString(value: "__divmod__")
    Self.___divmod__ = value
    return value
  }

  // MARK: - __doc__

  private static var ___doc__: IdString?
  public static var __doc__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___doc__ {
      return value
    }

    let value = IdString(value: "__doc__")
    Self.___doc__ = value
    return value
  }

  // MARK: - __enter__

  private static var ___enter__: IdString?
  public static var __enter__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___enter__ {
      return value
    }

    let value = IdString(value: "__enter__")
    Self.___enter__ = value
    return value
  }

  // MARK: - __eq__

  private static var ___eq__: IdString?
  public static var __eq__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___eq__ {
      return value
    }

    let value = IdString(value: "__eq__")
    Self.___eq__ = value
    return value
  }

  // MARK: - __exit__

  private static var ___exit__: IdString?
  public static var __exit__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___exit__ {
      return value
    }

    let value = IdString(value: "__exit__")
    Self.___exit__ = value
    return value
  }

  // MARK: - __file__

  private static var ___file__: IdString?
  public static var __file__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___file__ {
      return value
    }

    let value = IdString(value: "__file__")
    Self.___file__ = value
    return value
  }

  // MARK: - __float__

  private static var ___float__: IdString?
  public static var __float__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___float__ {
      return value
    }

    let value = IdString(value: "__float__")
    Self.___float__ = value
    return value
  }

  // MARK: - __floordiv__

  private static var ___floordiv__: IdString?
  public static var __floordiv__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___floordiv__ {
      return value
    }

    let value = IdString(value: "__floordiv__")
    Self.___floordiv__ = value
    return value
  }

  // MARK: - __ge__

  private static var ___ge__: IdString?
  public static var __ge__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ge__ {
      return value
    }

    let value = IdString(value: "__ge__")
    Self.___ge__ = value
    return value
  }

  // MARK: - __get__

  private static var ___get__: IdString?
  public static var __get__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___get__ {
      return value
    }

    let value = IdString(value: "__get__")
    Self.___get__ = value
    return value
  }

  // MARK: - __getattr__

  private static var ___getattr__: IdString?
  public static var __getattr__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___getattr__ {
      return value
    }

    let value = IdString(value: "__getattr__")
    Self.___getattr__ = value
    return value
  }

  // MARK: - __getattribute__

  private static var ___getattribute__: IdString?
  public static var __getattribute__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___getattribute__ {
      return value
    }

    let value = IdString(value: "__getattribute__")
    Self.___getattribute__ = value
    return value
  }

  // MARK: - __getitem__

  private static var ___getitem__: IdString?
  public static var __getitem__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___getitem__ {
      return value
    }

    let value = IdString(value: "__getitem__")
    Self.___getitem__ = value
    return value
  }

  // MARK: - __gt__

  private static var ___gt__: IdString?
  public static var __gt__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___gt__ {
      return value
    }

    let value = IdString(value: "__gt__")
    Self.___gt__ = value
    return value
  }

  // MARK: - __hash__

  private static var ___hash__: IdString?
  public static var __hash__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___hash__ {
      return value
    }

    let value = IdString(value: "__hash__")
    Self.___hash__ = value
    return value
  }

  // MARK: - __iadd__

  private static var ___iadd__: IdString?
  public static var __iadd__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___iadd__ {
      return value
    }

    let value = IdString(value: "__iadd__")
    Self.___iadd__ = value
    return value
  }

  // MARK: - __iand__

  private static var ___iand__: IdString?
  public static var __iand__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___iand__ {
      return value
    }

    let value = IdString(value: "__iand__")
    Self.___iand__ = value
    return value
  }

  // MARK: - __idivmod__

  private static var ___idivmod__: IdString?
  public static var __idivmod__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___idivmod__ {
      return value
    }

    let value = IdString(value: "__idivmod__")
    Self.___idivmod__ = value
    return value
  }

  // MARK: - __ifloordiv__

  private static var ___ifloordiv__: IdString?
  public static var __ifloordiv__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ifloordiv__ {
      return value
    }

    let value = IdString(value: "__ifloordiv__")
    Self.___ifloordiv__ = value
    return value
  }

  // MARK: - __ilshift__

  private static var ___ilshift__: IdString?
  public static var __ilshift__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ilshift__ {
      return value
    }

    let value = IdString(value: "__ilshift__")
    Self.___ilshift__ = value
    return value
  }

  // MARK: - __imatmul__

  private static var ___imatmul__: IdString?
  public static var __imatmul__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___imatmul__ {
      return value
    }

    let value = IdString(value: "__imatmul__")
    Self.___imatmul__ = value
    return value
  }

  // MARK: - __imod__

  private static var ___imod__: IdString?
  public static var __imod__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___imod__ {
      return value
    }

    let value = IdString(value: "__imod__")
    Self.___imod__ = value
    return value
  }

  // MARK: - __import__

  private static var ___import__: IdString?
  public static var __import__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___import__ {
      return value
    }

    let value = IdString(value: "__import__")
    Self.___import__ = value
    return value
  }

  // MARK: - __imul__

  private static var ___imul__: IdString?
  public static var __imul__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___imul__ {
      return value
    }

    let value = IdString(value: "__imul__")
    Self.___imul__ = value
    return value
  }

  // MARK: - __index__

  private static var ___index__: IdString?
  public static var __index__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___index__ {
      return value
    }

    let value = IdString(value: "__index__")
    Self.___index__ = value
    return value
  }

  // MARK: - __init__

  private static var ___init__: IdString?
  public static var __init__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___init__ {
      return value
    }

    let value = IdString(value: "__init__")
    Self.___init__ = value
    return value
  }

  // MARK: - __init_subclass__

  private static var ___init_subclass__: IdString?
  public static var __init_subclass__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___init_subclass__ {
      return value
    }

    let value = IdString(value: "__init_subclass__")
    Self.___init_subclass__ = value
    return value
  }

  // MARK: - __instancecheck__

  private static var ___instancecheck__: IdString?
  public static var __instancecheck__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___instancecheck__ {
      return value
    }

    let value = IdString(value: "__instancecheck__")
    Self.___instancecheck__ = value
    return value
  }

  // MARK: - __int__

  private static var ___int__: IdString?
  public static var __int__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___int__ {
      return value
    }

    let value = IdString(value: "__int__")
    Self.___int__ = value
    return value
  }

  // MARK: - __invert__

  private static var ___invert__: IdString?
  public static var __invert__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___invert__ {
      return value
    }

    let value = IdString(value: "__invert__")
    Self.___invert__ = value
    return value
  }

  // MARK: - __ior__

  private static var ___ior__: IdString?
  public static var __ior__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ior__ {
      return value
    }

    let value = IdString(value: "__ior__")
    Self.___ior__ = value
    return value
  }

  // MARK: - __ipow__

  private static var ___ipow__: IdString?
  public static var __ipow__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ipow__ {
      return value
    }

    let value = IdString(value: "__ipow__")
    Self.___ipow__ = value
    return value
  }

  // MARK: - __irshift__

  private static var ___irshift__: IdString?
  public static var __irshift__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___irshift__ {
      return value
    }

    let value = IdString(value: "__irshift__")
    Self.___irshift__ = value
    return value
  }

  // MARK: - __isabstractmethod__

  private static var ___isabstractmethod__: IdString?
  public static var __isabstractmethod__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___isabstractmethod__ {
      return value
    }

    let value = IdString(value: "__isabstractmethod__")
    Self.___isabstractmethod__ = value
    return value
  }

  // MARK: - __isub__

  private static var ___isub__: IdString?
  public static var __isub__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___isub__ {
      return value
    }

    let value = IdString(value: "__isub__")
    Self.___isub__ = value
    return value
  }

  // MARK: - __iter__

  private static var ___iter__: IdString?
  public static var __iter__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___iter__ {
      return value
    }

    let value = IdString(value: "__iter__")
    Self.___iter__ = value
    return value
  }

  // MARK: - __itruediv__

  private static var ___itruediv__: IdString?
  public static var __itruediv__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___itruediv__ {
      return value
    }

    let value = IdString(value: "__itruediv__")
    Self.___itruediv__ = value
    return value
  }

  // MARK: - __ixor__

  private static var ___ixor__: IdString?
  public static var __ixor__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ixor__ {
      return value
    }

    let value = IdString(value: "__ixor__")
    Self.___ixor__ = value
    return value
  }

  // MARK: - __le__

  private static var ___le__: IdString?
  public static var __le__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___le__ {
      return value
    }

    let value = IdString(value: "__le__")
    Self.___le__ = value
    return value
  }

  // MARK: - __len__

  private static var ___len__: IdString?
  public static var __len__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___len__ {
      return value
    }

    let value = IdString(value: "__len__")
    Self.___len__ = value
    return value
  }

  // MARK: - __loader__

  private static var ___loader__: IdString?
  public static var __loader__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___loader__ {
      return value
    }

    let value = IdString(value: "__loader__")
    Self.___loader__ = value
    return value
  }

  // MARK: - __lshift__

  private static var ___lshift__: IdString?
  public static var __lshift__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___lshift__ {
      return value
    }

    let value = IdString(value: "__lshift__")
    Self.___lshift__ = value
    return value
  }

  // MARK: - __lt__

  private static var ___lt__: IdString?
  public static var __lt__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___lt__ {
      return value
    }

    let value = IdString(value: "__lt__")
    Self.___lt__ = value
    return value
  }

  // MARK: - __matmul__

  private static var ___matmul__: IdString?
  public static var __matmul__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___matmul__ {
      return value
    }

    let value = IdString(value: "__matmul__")
    Self.___matmul__ = value
    return value
  }

  // MARK: - __missing__

  private static var ___missing__: IdString?
  public static var __missing__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___missing__ {
      return value
    }

    let value = IdString(value: "__missing__")
    Self.___missing__ = value
    return value
  }

  // MARK: - __mod__

  private static var ___mod__: IdString?
  public static var __mod__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___mod__ {
      return value
    }

    let value = IdString(value: "__mod__")
    Self.___mod__ = value
    return value
  }

  // MARK: - __module__

  private static var ___module__: IdString?
  public static var __module__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___module__ {
      return value
    }

    let value = IdString(value: "__module__")
    Self.___module__ = value
    return value
  }

  // MARK: - __mul__

  private static var ___mul__: IdString?
  public static var __mul__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___mul__ {
      return value
    }

    let value = IdString(value: "__mul__")
    Self.___mul__ = value
    return value
  }

  // MARK: - __name__

  private static var ___name__: IdString?
  public static var __name__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___name__ {
      return value
    }

    let value = IdString(value: "__name__")
    Self.___name__ = value
    return value
  }

  // MARK: - __ne__

  private static var ___ne__: IdString?
  public static var __ne__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ne__ {
      return value
    }

    let value = IdString(value: "__ne__")
    Self.___ne__ = value
    return value
  }

  // MARK: - __neg__

  private static var ___neg__: IdString?
  public static var __neg__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___neg__ {
      return value
    }

    let value = IdString(value: "__neg__")
    Self.___neg__ = value
    return value
  }

  // MARK: - __new__

  private static var ___new__: IdString?
  public static var __new__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___new__ {
      return value
    }

    let value = IdString(value: "__new__")
    Self.___new__ = value
    return value
  }

  // MARK: - __next__

  private static var ___next__: IdString?
  public static var __next__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___next__ {
      return value
    }

    let value = IdString(value: "__next__")
    Self.___next__ = value
    return value
  }

  // MARK: - __or__

  private static var ___or__: IdString?
  public static var __or__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___or__ {
      return value
    }

    let value = IdString(value: "__or__")
    Self.___or__ = value
    return value
  }

  // MARK: - __package__

  private static var ___package__: IdString?
  public static var __package__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___package__ {
      return value
    }

    let value = IdString(value: "__package__")
    Self.___package__ = value
    return value
  }

  // MARK: - __path__

  private static var ___path__: IdString?
  public static var __path__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___path__ {
      return value
    }

    let value = IdString(value: "__path__")
    Self.___path__ = value
    return value
  }

  // MARK: - __pos__

  private static var ___pos__: IdString?
  public static var __pos__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___pos__ {
      return value
    }

    let value = IdString(value: "__pos__")
    Self.___pos__ = value
    return value
  }

  // MARK: - __pow__

  private static var ___pow__: IdString?
  public static var __pow__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___pow__ {
      return value
    }

    let value = IdString(value: "__pow__")
    Self.___pow__ = value
    return value
  }

  // MARK: - __prepare__

  private static var ___prepare__: IdString?
  public static var __prepare__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___prepare__ {
      return value
    }

    let value = IdString(value: "__prepare__")
    Self.___prepare__ = value
    return value
  }

  // MARK: - __qualname__

  private static var ___qualname__: IdString?
  public static var __qualname__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___qualname__ {
      return value
    }

    let value = IdString(value: "__qualname__")
    Self.___qualname__ = value
    return value
  }

  // MARK: - __radd__

  private static var ___radd__: IdString?
  public static var __radd__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___radd__ {
      return value
    }

    let value = IdString(value: "__radd__")
    Self.___radd__ = value
    return value
  }

  // MARK: - __rand__

  private static var ___rand__: IdString?
  public static var __rand__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rand__ {
      return value
    }

    let value = IdString(value: "__rand__")
    Self.___rand__ = value
    return value
  }

  // MARK: - __rdivmod__

  private static var ___rdivmod__: IdString?
  public static var __rdivmod__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rdivmod__ {
      return value
    }

    let value = IdString(value: "__rdivmod__")
    Self.___rdivmod__ = value
    return value
  }

  // MARK: - __repr__

  private static var ___repr__: IdString?
  public static var __repr__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___repr__ {
      return value
    }

    let value = IdString(value: "__repr__")
    Self.___repr__ = value
    return value
  }

  // MARK: - __reversed__

  private static var ___reversed__: IdString?
  public static var __reversed__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___reversed__ {
      return value
    }

    let value = IdString(value: "__reversed__")
    Self.___reversed__ = value
    return value
  }

  // MARK: - __rfloordiv__

  private static var ___rfloordiv__: IdString?
  public static var __rfloordiv__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rfloordiv__ {
      return value
    }

    let value = IdString(value: "__rfloordiv__")
    Self.___rfloordiv__ = value
    return value
  }

  // MARK: - __rlshift__

  private static var ___rlshift__: IdString?
  public static var __rlshift__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rlshift__ {
      return value
    }

    let value = IdString(value: "__rlshift__")
    Self.___rlshift__ = value
    return value
  }

  // MARK: - __rmatmul__

  private static var ___rmatmul__: IdString?
  public static var __rmatmul__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rmatmul__ {
      return value
    }

    let value = IdString(value: "__rmatmul__")
    Self.___rmatmul__ = value
    return value
  }

  // MARK: - __rmod__

  private static var ___rmod__: IdString?
  public static var __rmod__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rmod__ {
      return value
    }

    let value = IdString(value: "__rmod__")
    Self.___rmod__ = value
    return value
  }

  // MARK: - __rmul__

  private static var ___rmul__: IdString?
  public static var __rmul__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rmul__ {
      return value
    }

    let value = IdString(value: "__rmul__")
    Self.___rmul__ = value
    return value
  }

  // MARK: - __ror__

  private static var ___ror__: IdString?
  public static var __ror__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___ror__ {
      return value
    }

    let value = IdString(value: "__ror__")
    Self.___ror__ = value
    return value
  }

  // MARK: - __round__

  private static var ___round__: IdString?
  public static var __round__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___round__ {
      return value
    }

    let value = IdString(value: "__round__")
    Self.___round__ = value
    return value
  }

  // MARK: - __rpow__

  private static var ___rpow__: IdString?
  public static var __rpow__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rpow__ {
      return value
    }

    let value = IdString(value: "__rpow__")
    Self.___rpow__ = value
    return value
  }

  // MARK: - __rrshift__

  private static var ___rrshift__: IdString?
  public static var __rrshift__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rrshift__ {
      return value
    }

    let value = IdString(value: "__rrshift__")
    Self.___rrshift__ = value
    return value
  }

  // MARK: - __rshift__

  private static var ___rshift__: IdString?
  public static var __rshift__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rshift__ {
      return value
    }

    let value = IdString(value: "__rshift__")
    Self.___rshift__ = value
    return value
  }

  // MARK: - __rsub__

  private static var ___rsub__: IdString?
  public static var __rsub__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rsub__ {
      return value
    }

    let value = IdString(value: "__rsub__")
    Self.___rsub__ = value
    return value
  }

  // MARK: - __rtruediv__

  private static var ___rtruediv__: IdString?
  public static var __rtruediv__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rtruediv__ {
      return value
    }

    let value = IdString(value: "__rtruediv__")
    Self.___rtruediv__ = value
    return value
  }

  // MARK: - __rxor__

  private static var ___rxor__: IdString?
  public static var __rxor__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___rxor__ {
      return value
    }

    let value = IdString(value: "__rxor__")
    Self.___rxor__ = value
    return value
  }

  // MARK: - __set__

  private static var ___set__: IdString?
  public static var __set__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___set__ {
      return value
    }

    let value = IdString(value: "__set__")
    Self.___set__ = value
    return value
  }

  // MARK: - __set_name__

  private static var ___set_name__: IdString?
  public static var __set_name__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___set_name__ {
      return value
    }

    let value = IdString(value: "__set_name__")
    Self.___set_name__ = value
    return value
  }

  // MARK: - __setattr__

  private static var ___setattr__: IdString?
  public static var __setattr__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___setattr__ {
      return value
    }

    let value = IdString(value: "__setattr__")
    Self.___setattr__ = value
    return value
  }

  // MARK: - __setitem__

  private static var ___setitem__: IdString?
  public static var __setitem__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___setitem__ {
      return value
    }

    let value = IdString(value: "__setitem__")
    Self.___setitem__ = value
    return value
  }

  // MARK: - __spec__

  private static var ___spec__: IdString?
  public static var __spec__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___spec__ {
      return value
    }

    let value = IdString(value: "__spec__")
    Self.___spec__ = value
    return value
  }

  // MARK: - __str__

  private static var ___str__: IdString?
  public static var __str__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___str__ {
      return value
    }

    let value = IdString(value: "__str__")
    Self.___str__ = value
    return value
  }

  // MARK: - __sub__

  private static var ___sub__: IdString?
  public static var __sub__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___sub__ {
      return value
    }

    let value = IdString(value: "__sub__")
    Self.___sub__ = value
    return value
  }

  // MARK: - __subclasscheck__

  private static var ___subclasscheck__: IdString?
  public static var __subclasscheck__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___subclasscheck__ {
      return value
    }

    let value = IdString(value: "__subclasscheck__")
    Self.___subclasscheck__ = value
    return value
  }

  // MARK: - __truediv__

  private static var ___truediv__: IdString?
  public static var __truediv__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___truediv__ {
      return value
    }

    let value = IdString(value: "__truediv__")
    Self.___truediv__ = value
    return value
  }

  // MARK: - __trunc__

  private static var ___trunc__: IdString?
  public static var __trunc__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___trunc__ {
      return value
    }

    let value = IdString(value: "__trunc__")
    Self.___trunc__ = value
    return value
  }

  // MARK: - __warningregistry__

  private static var ___warningregistry__: IdString?
  public static var __warningregistry__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___warningregistry__ {
      return value
    }

    let value = IdString(value: "__warningregistry__")
    Self.___warningregistry__ = value
    return value
  }

  // MARK: - __xor__

  private static var ___xor__: IdString?
  public static var __xor__: IdString {
    assert(Py.isInitialized)

    if let value = Self.___xor__ {
      return value
    }

    let value = IdString(value: "__xor__")
    Self.___xor__ = value
    return value
  }

  // MARK: - _find_and_load

  private static var __find_and_load: IdString?
  public static var _find_and_load: IdString {
    assert(Py.isInitialized)

    if let value = Self.__find_and_load {
      return value
    }

    let value = IdString(value: "_find_and_load")
    Self.__find_and_load = value
    return value
  }

  // MARK: - _handle_fromlist

  private static var __handle_fromlist: IdString?
  public static var _handle_fromlist: IdString {
    assert(Py.isInitialized)

    if let value = Self.__handle_fromlist {
      return value
    }

    let value = IdString(value: "_handle_fromlist")
    Self.__handle_fromlist = value
    return value
  }

  // MARK: - builtins

  private static var _builtins: IdString?
  public static var builtins: IdString {
    assert(Py.isInitialized)

    if let value = Self._builtins {
      return value
    }

    let value = IdString(value: "builtins")
    Self._builtins = value
    return value
  }

  // MARK: - encoding

  private static var _encoding: IdString?
  public static var encoding: IdString {
    assert(Py.isInitialized)

    if let value = Self._encoding {
      return value
    }

    let value = IdString(value: "encoding")
    Self._encoding = value
    return value
  }

  // MARK: - keys

  private static var _keys: IdString?
  public static var keys: IdString {
    assert(Py.isInitialized)

    if let value = Self._keys {
      return value
    }

    let value = IdString(value: "keys")
    Self._keys = value
    return value
  }

  // MARK: - metaclass

  private static var _metaclass: IdString?
  public static var metaclass: IdString {
    assert(Py.isInitialized)

    if let value = Self._metaclass {
      return value
    }

    let value = IdString(value: "metaclass")
    Self._metaclass = value
    return value
  }

  // MARK: - mro

  private static var _mro: IdString?
  public static var mro: IdString {
    assert(Py.isInitialized)

    if let value = Self._mro {
      return value
    }

    let value = IdString(value: "mro")
    Self._mro = value
    return value
  }

  // MARK: - name

  private static var _name: IdString?
  public static var name: IdString {
    assert(Py.isInitialized)

    if let value = Self._name {
      return value
    }

    let value = IdString(value: "name")
    Self._name = value
    return value
  }

  // MARK: - object

  private static var _object: IdString?
  public static var object: IdString {
    assert(Py.isInitialized)

    if let value = Self._object {
      return value
    }

    let value = IdString(value: "object")
    Self._object = value
    return value
  }

  // MARK: - origin

  private static var _origin: IdString?
  public static var origin: IdString {
    assert(Py.isInitialized)

    if let value = Self._origin {
      return value
    }

    let value = IdString(value: "origin")
    Self._origin = value
    return value
  }
}
