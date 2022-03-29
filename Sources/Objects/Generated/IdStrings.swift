// ======================================================================
// Automatically generated from: ./Sources/Objects/Generated/IdStrings.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ======================================================================

import VioletCore

// swiftlint:disable nesting
// swiftlint:disable function_body_length

/// Predefined commonly used `__dict__` keys.
/// Similar to `_Py_IDENTIFIER` in `CPython`.
///
/// Performance of this 'cache' (because that what it actually is)
/// is crucial for overall performance.
/// Even using a dictionary (with its `O(1) + massive constants` access)
/// may be too slow.
///
/// Use `py.resolve(id:)` to convert to `PyString`.
public struct IdString: CustomStringConvertible {

  private let index: Int

  private init(index: Int) {
    self.index = index
  }

  public static let __abs__ = IdString(index: 0)
  public static let __add__ = IdString(index: 1)
  public static let __all__ = IdString(index: 2)
  public static let __and__ = IdString(index: 3)
  public static let __annotations__ = IdString(index: 4)
  public static let __bool__ = IdString(index: 5)
  public static let __build_class__ = IdString(index: 6)
  public static let __builtins__ = IdString(index: 7)
  public static let __call__ = IdString(index: 8)
  public static let __class__ = IdString(index: 9)
  public static let __class_getitem__ = IdString(index: 10)
  public static let __classcell__ = IdString(index: 11)
  public static let __complex__ = IdString(index: 12)
  public static let __contains__ = IdString(index: 13)
  public static let __del__ = IdString(index: 14)
  public static let __delattr__ = IdString(index: 15)
  public static let __delitem__ = IdString(index: 16)
  public static let __dict__ = IdString(index: 17)
  public static let __dir__ = IdString(index: 18)
  public static let __divmod__ = IdString(index: 19)
  public static let __doc__ = IdString(index: 20)
  public static let __enter__ = IdString(index: 21)
  public static let __eq__ = IdString(index: 22)
  public static let __exit__ = IdString(index: 23)
  public static let __file__ = IdString(index: 24)
  public static let __float__ = IdString(index: 25)
  public static let __floordiv__ = IdString(index: 26)
  public static let __ge__ = IdString(index: 27)
  public static let __get__ = IdString(index: 28)
  public static let __getattr__ = IdString(index: 29)
  public static let __getattribute__ = IdString(index: 30)
  public static let __getitem__ = IdString(index: 31)
  public static let __gt__ = IdString(index: 32)
  public static let __hash__ = IdString(index: 33)
  public static let __iadd__ = IdString(index: 34)
  public static let __iand__ = IdString(index: 35)
  public static let __idivmod__ = IdString(index: 36)
  public static let __ifloordiv__ = IdString(index: 37)
  public static let __ilshift__ = IdString(index: 38)
  public static let __imatmul__ = IdString(index: 39)
  public static let __imod__ = IdString(index: 40)
  public static let __import__ = IdString(index: 41)
  public static let __imul__ = IdString(index: 42)
  public static let __index__ = IdString(index: 43)
  public static let __init__ = IdString(index: 44)
  public static let __init_subclass__ = IdString(index: 45)
  public static let __instancecheck__ = IdString(index: 46)
  public static let __int__ = IdString(index: 47)
  public static let __invert__ = IdString(index: 48)
  public static let __ior__ = IdString(index: 49)
  public static let __ipow__ = IdString(index: 50)
  public static let __irshift__ = IdString(index: 51)
  public static let __isabstractmethod__ = IdString(index: 52)
  public static let __isub__ = IdString(index: 53)
  public static let __iter__ = IdString(index: 54)
  public static let __itruediv__ = IdString(index: 55)
  public static let __ixor__ = IdString(index: 56)
  public static let __le__ = IdString(index: 57)
  public static let __len__ = IdString(index: 58)
  public static let __loader__ = IdString(index: 59)
  public static let __lshift__ = IdString(index: 60)
  public static let __lt__ = IdString(index: 61)
  public static let __matmul__ = IdString(index: 62)
  public static let __missing__ = IdString(index: 63)
  public static let __mod__ = IdString(index: 64)
  public static let __module__ = IdString(index: 65)
  public static let __mul__ = IdString(index: 66)
  public static let __name__ = IdString(index: 67)
  public static let __ne__ = IdString(index: 68)
  public static let __neg__ = IdString(index: 69)
  public static let __new__ = IdString(index: 70)
  public static let __next__ = IdString(index: 71)
  public static let __or__ = IdString(index: 72)
  public static let __package__ = IdString(index: 73)
  public static let __path__ = IdString(index: 74)
  public static let __pos__ = IdString(index: 75)
  public static let __pow__ = IdString(index: 76)
  public static let __prepare__ = IdString(index: 77)
  public static let __qualname__ = IdString(index: 78)
  public static let __radd__ = IdString(index: 79)
  public static let __rand__ = IdString(index: 80)
  public static let __rdivmod__ = IdString(index: 81)
  public static let __repr__ = IdString(index: 82)
  public static let __reversed__ = IdString(index: 83)
  public static let __rfloordiv__ = IdString(index: 84)
  public static let __rlshift__ = IdString(index: 85)
  public static let __rmatmul__ = IdString(index: 86)
  public static let __rmod__ = IdString(index: 87)
  public static let __rmul__ = IdString(index: 88)
  public static let __ror__ = IdString(index: 89)
  public static let __round__ = IdString(index: 90)
  public static let __rpow__ = IdString(index: 91)
  public static let __rrshift__ = IdString(index: 92)
  public static let __rshift__ = IdString(index: 93)
  public static let __rsub__ = IdString(index: 94)
  public static let __rtruediv__ = IdString(index: 95)
  public static let __rxor__ = IdString(index: 96)
  public static let __set__ = IdString(index: 97)
  public static let __set_name__ = IdString(index: 98)
  public static let __setattr__ = IdString(index: 99)
  public static let __setitem__ = IdString(index: 100)
  public static let __spec__ = IdString(index: 101)
  public static let __str__ = IdString(index: 102)
  public static let __sub__ = IdString(index: 103)
  public static let __subclasscheck__ = IdString(index: 104)
  public static let __truediv__ = IdString(index: 105)
  public static let __trunc__ = IdString(index: 106)
  public static let __warningregistry__ = IdString(index: 107)
  public static let __xor__ = IdString(index: 108)
  public static let _find_and_load = IdString(index: 109)
  public static let _handle_fromlist = IdString(index: 110)
  public static let builtins = IdString(index: 111)
  public static let encoding = IdString(index: 112)
  public static let keys = IdString(index: 113)
  public static let metaclass = IdString(index: 114)
  public static let mro = IdString(index: 115)
  public static let name = IdString(index: 116)
  public static let object = IdString(index: 117)
  public static let origin = IdString(index: 118)

  public var description: String {
    switch self.index {
    case 0: return "__abs__"
    case 1: return "__add__"
    case 2: return "__all__"
    case 3: return "__and__"
    case 4: return "__annotations__"
    case 5: return "__bool__"
    case 6: return "__build_class__"
    case 7: return "__builtins__"
    case 8: return "__call__"
    case 9: return "__class__"
    case 10: return "__class_getitem__"
    case 11: return "__classcell__"
    case 12: return "__complex__"
    case 13: return "__contains__"
    case 14: return "__del__"
    case 15: return "__delattr__"
    case 16: return "__delitem__"
    case 17: return "__dict__"
    case 18: return "__dir__"
    case 19: return "__divmod__"
    case 20: return "__doc__"
    case 21: return "__enter__"
    case 22: return "__eq__"
    case 23: return "__exit__"
    case 24: return "__file__"
    case 25: return "__float__"
    case 26: return "__floordiv__"
    case 27: return "__ge__"
    case 28: return "__get__"
    case 29: return "__getattr__"
    case 30: return "__getattribute__"
    case 31: return "__getitem__"
    case 32: return "__gt__"
    case 33: return "__hash__"
    case 34: return "__iadd__"
    case 35: return "__iand__"
    case 36: return "__idivmod__"
    case 37: return "__ifloordiv__"
    case 38: return "__ilshift__"
    case 39: return "__imatmul__"
    case 40: return "__imod__"
    case 41: return "__import__"
    case 42: return "__imul__"
    case 43: return "__index__"
    case 44: return "__init__"
    case 45: return "__init_subclass__"
    case 46: return "__instancecheck__"
    case 47: return "__int__"
    case 48: return "__invert__"
    case 49: return "__ior__"
    case 50: return "__ipow__"
    case 51: return "__irshift__"
    case 52: return "__isabstractmethod__"
    case 53: return "__isub__"
    case 54: return "__iter__"
    case 55: return "__itruediv__"
    case 56: return "__ixor__"
    case 57: return "__le__"
    case 58: return "__len__"
    case 59: return "__loader__"
    case 60: return "__lshift__"
    case 61: return "__lt__"
    case 62: return "__matmul__"
    case 63: return "__missing__"
    case 64: return "__mod__"
    case 65: return "__module__"
    case 66: return "__mul__"
    case 67: return "__name__"
    case 68: return "__ne__"
    case 69: return "__neg__"
    case 70: return "__new__"
    case 71: return "__next__"
    case 72: return "__or__"
    case 73: return "__package__"
    case 74: return "__path__"
    case 75: return "__pos__"
    case 76: return "__pow__"
    case 77: return "__prepare__"
    case 78: return "__qualname__"
    case 79: return "__radd__"
    case 80: return "__rand__"
    case 81: return "__rdivmod__"
    case 82: return "__repr__"
    case 83: return "__reversed__"
    case 84: return "__rfloordiv__"
    case 85: return "__rlshift__"
    case 86: return "__rmatmul__"
    case 87: return "__rmod__"
    case 88: return "__rmul__"
    case 89: return "__ror__"
    case 90: return "__round__"
    case 91: return "__rpow__"
    case 92: return "__rrshift__"
    case 93: return "__rshift__"
    case 94: return "__rsub__"
    case 95: return "__rtruediv__"
    case 96: return "__rxor__"
    case 97: return "__set__"
    case 98: return "__set_name__"
    case 99: return "__setattr__"
    case 100: return "__setitem__"
    case 101: return "__spec__"
    case 102: return "__str__"
    case 103: return "__sub__"
    case 104: return "__subclasscheck__"
    case 105: return "__truediv__"
    case 106: return "__trunc__"
    case 107: return "__warningregistry__"
    case 108: return "__xor__"
    case 109: return "_find_and_load"
    case 110: return "_handle_fromlist"
    case 111: return "builtins"
    case 112: return "encoding"
    case 113: return "keys"
    case 114: return "metaclass"
    case 115: return "mro"
    case 116: return "name"
    case 117: return "object"
    case 118: return "origin"
    default: trap("Unexpected IdString index: \(self.index).")
    }
  }

  internal struct Collection: Sequence {

    internal typealias Element = IdString

    private let objects: [PyString]

    internal subscript(id: IdString) -> PyString {
      return self.objects[id.index]
    }

    internal init(_ py: Py) {
      self.objects = [
        py.newString("__abs__"),
        py.newString("__add__"),
        py.newString("__all__"),
        py.newString("__and__"),
        py.newString("__annotations__"),
        py.newString("__bool__"),
        py.newString("__build_class__"),
        py.newString("__builtins__"),
        py.newString("__call__"),
        py.newString("__class__"),
        py.newString("__class_getitem__"),
        py.newString("__classcell__"),
        py.newString("__complex__"),
        py.newString("__contains__"),
        py.newString("__del__"),
        py.newString("__delattr__"),
        py.newString("__delitem__"),
        py.newString("__dict__"),
        py.newString("__dir__"),
        py.newString("__divmod__"),
        py.newString("__doc__"),
        py.newString("__enter__"),
        py.newString("__eq__"),
        py.newString("__exit__"),
        py.newString("__file__"),
        py.newString("__float__"),
        py.newString("__floordiv__"),
        py.newString("__ge__"),
        py.newString("__get__"),
        py.newString("__getattr__"),
        py.newString("__getattribute__"),
        py.newString("__getitem__"),
        py.newString("__gt__"),
        py.newString("__hash__"),
        py.newString("__iadd__"),
        py.newString("__iand__"),
        py.newString("__idivmod__"),
        py.newString("__ifloordiv__"),
        py.newString("__ilshift__"),
        py.newString("__imatmul__"),
        py.newString("__imod__"),
        py.newString("__import__"),
        py.newString("__imul__"),
        py.newString("__index__"),
        py.newString("__init__"),
        py.newString("__init_subclass__"),
        py.newString("__instancecheck__"),
        py.newString("__int__"),
        py.newString("__invert__"),
        py.newString("__ior__"),
        py.newString("__ipow__"),
        py.newString("__irshift__"),
        py.newString("__isabstractmethod__"),
        py.newString("__isub__"),
        py.newString("__iter__"),
        py.newString("__itruediv__"),
        py.newString("__ixor__"),
        py.newString("__le__"),
        py.newString("__len__"),
        py.newString("__loader__"),
        py.newString("__lshift__"),
        py.newString("__lt__"),
        py.newString("__matmul__"),
        py.newString("__missing__"),
        py.newString("__mod__"),
        py.newString("__module__"),
        py.newString("__mul__"),
        py.newString("__name__"),
        py.newString("__ne__"),
        py.newString("__neg__"),
        py.newString("__new__"),
        py.newString("__next__"),
        py.newString("__or__"),
        py.newString("__package__"),
        py.newString("__path__"),
        py.newString("__pos__"),
        py.newString("__pow__"),
        py.newString("__prepare__"),
        py.newString("__qualname__"),
        py.newString("__radd__"),
        py.newString("__rand__"),
        py.newString("__rdivmod__"),
        py.newString("__repr__"),
        py.newString("__reversed__"),
        py.newString("__rfloordiv__"),
        py.newString("__rlshift__"),
        py.newString("__rmatmul__"),
        py.newString("__rmod__"),
        py.newString("__rmul__"),
        py.newString("__ror__"),
        py.newString("__round__"),
        py.newString("__rpow__"),
        py.newString("__rrshift__"),
        py.newString("__rshift__"),
        py.newString("__rsub__"),
        py.newString("__rtruediv__"),
        py.newString("__rxor__"),
        py.newString("__set__"),
        py.newString("__set_name__"),
        py.newString("__setattr__"),
        py.newString("__setitem__"),
        py.newString("__spec__"),
        py.newString("__str__"),
        py.newString("__sub__"),
        py.newString("__subclasscheck__"),
        py.newString("__truediv__"),
        py.newString("__trunc__"),
        py.newString("__warningregistry__"),
        py.newString("__xor__"),
        py.newString("_find_and_load"),
        py.newString("_handle_fromlist"),
        py.newString("builtins"),
        py.newString("encoding"),
        py.newString("keys"),
        py.newString("metaclass"),
        py.newString("mro"),
        py.newString("name"),
        py.newString("object"),
        py.newString("origin")
      ]
    }

    internal struct Iterator: IteratorProtocol {

      private var index = -1

      mutating func next() -> IdString? {
        if self.index == 118 {
          return nil
        }

        self.index += 1
        return IdString(index: self.index)
      }
    }

    internal func makeIterator() -> Iterator {
      return Iterator()
    }
  }
}
