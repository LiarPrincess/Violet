// =========================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyStaticCall.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// =========================================================================

import BigInt
import VioletCore

// swiftlint:disable nesting
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable file_length

/// Call Swift method directly without going through a full Python dispatch
/// (if possible).
///
/// # What is this?
///
/// Certain Python methods are used very often.
/// While we could do the full Python dispatch on every call, we can also store the
/// pointer to resolved Swift function directly on type (`PyType` instance).
/// Then when this method is called we would use the stored function instead
/// of doing the costly `MRO` lookup.
///
/// Example: we want to call `list.__len__`
///
/// Python dispatch:
/// 1. Lookup `__len__` in `list` `MRO` - this operation is complicated,
///    especially when the method is defined on one of the base types.
/// 2. Create method object bound to specific `list` instance - this means heap
///    allocation.
/// 3. Dispatch bound method - it will (eventually) call `PyList.__len__` in Swift.
///
/// Static dispatch (the one defined in this file):
/// 1. Check if `object.type` contains pointer to `__len__` function - if this fails
///    (for example when method is overridden) then do full 'Python dispatch'.
/// 2. Call Swift function stored in this pointer - this is (almost) a direct call
///    to `PyList.__len__`.
///
/// Ofc. It does not make sense to do this for every method, in our case we will
/// just use the most common magic methods.
///
/// # Why?
///
/// REASON 1: Debugging
///
/// Trust me, you don't want to debug a raw Python dispatch.
/// There is a lot of code involved, with multiple method calls (which can fail).
///
/// On the other hand static calls in lldb look like this:
/// 1. Check if `list` has stored `__len__` function pointer (lldb: `n`)
/// 2. Go into the final method (lldb: `s`)
///
/// REASON 2: Static calls during `Py.initialize`
///
/// This also allows us to call Python methods during `Py.initialize`,
/// when not all of the types are yet fully initialized.
///
/// For example when we have not yet added `__hash__` to `str.__dict__`
/// we can still call this method because we know (statically) that `str` does
/// implement this operation. This has a side-effect of using `str.__hash__`
/// (via static call) to insert `__hash__` inside `str.__dict__`.
///
/// # Is this bullet-proof?
///
/// Not really.
/// If you remove one of the builtin methods from a type, then function pointer
/// on type still remains.
///
/// But most of the time you can't do this:
/// ```py
/// >>> del list.__len__
/// Traceback (most recent call last):
///   File "<stdin>", line 1, in <module>
/// TypeError: can't set attributes of built-in/extension type 'list'
/// ```
///
/// Also you have to take care of overridden methods in classes written by user:
/// - Option 1: do not fill any of the function pointers on subclass -> all of the
///             methods will use Python dispatch.
/// - Option 2: use pointers from base class, but remove entries for overridden methods.
public enum PyStaticCall {

  /// Methods stored on `PyType` needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  public final class KnownNotOverriddenMethods {

    // MARK: - Aliases

    public typealias StringConversion = (Py, PyObject) -> PyResult
    public typealias Hash = (Py, PyObject) -> HashResult
    public typealias Dir = (Py, PyObject) -> PyResultGen<DirResult>
    public typealias Comparison = (Py, PyObject, PyObject) -> CompareResult
    public typealias AsBool = (Py, PyObject) -> PyResult
    public typealias AsInt = (Py, PyObject) -> PyResult
    public typealias AsFloat = (Py, PyObject) -> PyResult
    public typealias AsComplex = (Py, PyObject) -> PyResult
    public typealias AsIndex = (Py, PyObject) -> PyResult
    public typealias GetAttribute = (Py, PyObject, PyObject) -> PyResult
    public typealias SetAttribute = (Py, PyObject, PyObject, PyObject?) -> PyResult
    public typealias DelAttribute = (Py, PyObject, PyObject) -> PyResult
    public typealias GetItem = (Py, PyObject, PyObject) -> PyResult
    public typealias SetItem = (Py, PyObject, PyObject, PyObject) -> PyResult
    public typealias DelItem = (Py, PyObject, PyObject) -> PyResult
    public typealias Iter = (Py, PyObject) -> PyResult
    public typealias Next = (Py, PyObject) -> PyResult
    public typealias GetLength = (Py, PyObject) -> PyResult
    public typealias Contains = (Py, PyObject, PyObject) -> PyResult
    public typealias Reversed = (Py, PyObject) -> PyResult
    public typealias Keys = (Py, PyObject) -> PyResult
    public typealias Del = (Py, PyObject) -> PyResult
    public typealias Call = (Py, PyObject, [PyObject], PyDict?) -> PyResult
    public typealias InstanceCheck = (Py, PyObject, PyObject) -> PyResult
    public typealias SubclassCheck = (Py, PyObject, PyObject) -> PyResult
    public typealias IsAbstractMethod = (Py, PyObject) -> PyResult
    public typealias NumericUnary = (Py, PyObject) -> PyResult
    public typealias NumericRound = (Py, PyObject, PyObject?) -> PyResult
    public typealias NumericBinary = (Py, PyObject, PyObject) -> PyResult
    public typealias NumericPow = (Py, PyObject, PyObject, PyObject) -> PyResult

    // MARK: - Properties

    // All of the function pointers have 16 bytes.
    // They also have an invalid representation that can be used as optional tag.
    // So each of those functions is exactly 16 bytes.

    public var __repr__: StringConversion?
    public var __str__: StringConversion?

    public var __hash__: Hash?
    public var __dir__: Dir?

    public var __eq__: Comparison?
    public var __ne__: Comparison?
    public var __lt__: Comparison?
    public var __le__: Comparison?
    public var __gt__: Comparison?
    public var __ge__: Comparison?

    public var __bool__: AsBool?
    public var __int__: AsInt?
    public var __float__: AsFloat?
    public var __complex__: AsComplex?
    public var __index__: AsIndex?

    public var __getattr__: GetAttribute?
    public var __getattribute__: GetAttribute?
    public var __setattr__: SetAttribute?
    public var __delattr__: DelAttribute?

    public var __getitem__: GetItem?
    public var __setitem__: SetItem?
    public var __delitem__: DelItem?

    public var __iter__: Iter?
    public var __next__: Next?
    public var __len__: GetLength?
    public var __contains__: Contains?
    public var __reversed__: Reversed?
    public var keys: Keys?

    public var __del__: Del?
    public var __call__: Call?

    public var __instancecheck__: InstanceCheck?
    public var __subclasscheck__: SubclassCheck?
    public var __isabstractmethod__: IsAbstractMethod?

    public var __pos__: NumericUnary?
    public var __neg__: NumericUnary?
    public var __invert__: NumericUnary?
    public var __abs__: NumericUnary?
    public var __trunc__: NumericUnary?
    public var __round__: NumericRound?

    public var __add__: NumericBinary?
    public var __and__: NumericBinary?
    public var __divmod__: NumericBinary?
    public var __floordiv__: NumericBinary?
    public var __lshift__: NumericBinary?
    public var __matmul__: NumericBinary?
    public var __mod__: NumericBinary?
    public var __mul__: NumericBinary?
    public var __or__: NumericBinary?
    public var __rshift__: NumericBinary?
    public var __sub__: NumericBinary?
    public var __truediv__: NumericBinary?
    public var __xor__: NumericBinary?

    public var __radd__: NumericBinary?
    public var __rand__: NumericBinary?
    public var __rdivmod__: NumericBinary?
    public var __rfloordiv__: NumericBinary?
    public var __rlshift__: NumericBinary?
    public var __rmatmul__: NumericBinary?
    public var __rmod__: NumericBinary?
    public var __rmul__: NumericBinary?
    public var __ror__: NumericBinary?
    public var __rrshift__: NumericBinary?
    public var __rsub__: NumericBinary?
    public var __rtruediv__: NumericBinary?
    public var __rxor__: NumericBinary?

    public var __iadd__: NumericBinary?
    public var __iand__: NumericBinary?
    public var __idivmod__: NumericBinary?
    public var __ifloordiv__: NumericBinary?
    public var __ilshift__: NumericBinary?
    public var __imatmul__: NumericBinary?
    public var __imod__: NumericBinary?
    public var __imul__: NumericBinary?
    public var __ior__: NumericBinary?
    public var __irshift__: NumericBinary?
    public var __isub__: NumericBinary?
    public var __itruediv__: NumericBinary?
    public var __ixor__: NumericBinary?

    public var __pow__: NumericPow?
    public var __rpow__: NumericPow?
    public var __ipow__: NumericPow?

    // MARK: - Init

    public init() {
      self.__repr__ = nil
      self.__str__ = nil

      self.__hash__ = nil
      self.__dir__ = nil

      self.__eq__ = nil
      self.__ne__ = nil
      self.__lt__ = nil
      self.__le__ = nil
      self.__gt__ = nil
      self.__ge__ = nil

      self.__bool__ = nil
      self.__int__ = nil
      self.__float__ = nil
      self.__complex__ = nil
      self.__index__ = nil

      self.__getattr__ = nil
      self.__getattribute__ = nil
      self.__setattr__ = nil
      self.__delattr__ = nil

      self.__getitem__ = nil
      self.__setitem__ = nil
      self.__delitem__ = nil

      self.__iter__ = nil
      self.__next__ = nil
      self.__len__ = nil
      self.__contains__ = nil
      self.__reversed__ = nil
      self.keys = nil

      self.__del__ = nil
      self.__call__ = nil

      self.__instancecheck__ = nil
      self.__subclasscheck__ = nil
      self.__isabstractmethod__ = nil

      self.__pos__ = nil
      self.__neg__ = nil
      self.__invert__ = nil
      self.__abs__ = nil
      self.__trunc__ = nil
      self.__round__ = nil

      self.__add__ = nil
      self.__and__ = nil
      self.__divmod__ = nil
      self.__floordiv__ = nil
      self.__lshift__ = nil
      self.__matmul__ = nil
      self.__mod__ = nil
      self.__mul__ = nil
      self.__or__ = nil
      self.__rshift__ = nil
      self.__sub__ = nil
      self.__truediv__ = nil
      self.__xor__ = nil

      self.__radd__ = nil
      self.__rand__ = nil
      self.__rdivmod__ = nil
      self.__rfloordiv__ = nil
      self.__rlshift__ = nil
      self.__rmatmul__ = nil
      self.__rmod__ = nil
      self.__rmul__ = nil
      self.__ror__ = nil
      self.__rrshift__ = nil
      self.__rsub__ = nil
      self.__rtruediv__ = nil
      self.__rxor__ = nil

      self.__iadd__ = nil
      self.__iand__ = nil
      self.__idivmod__ = nil
      self.__ifloordiv__ = nil
      self.__ilshift__ = nil
      self.__imatmul__ = nil
      self.__imod__ = nil
      self.__imul__ = nil
      self.__ior__ = nil
      self.__irshift__ = nil
      self.__isub__ = nil
      self.__itruediv__ = nil
      self.__ixor__ = nil

      self.__pow__ = nil
      self.__rpow__ = nil
      self.__ipow__ = nil
    }

    // MARK: - Init MRO

    /// Special init for heap types (types created on-the-fly,
    /// for example by 'class' statement).
    ///
    /// We can't just use 'base' type, because each type has a different method
    /// resolution order (MRO) and we have to respect this.
    public convenience init(
      _ py: Py,
      mroWithoutCurrentlyCreatedType mro: [PyType],
      dictForCurrentlyCreatedType dict: PyDict
    ) {
      self.init()

      // We need to start from the back (the most base type, probably 'object').
      for type in mro.reversed() {
        let dict = type.getDict(py)
        self.removeOverriddenMethods(py, dict: dict)
        self.copyMethods(from: type.staticMethods)
      }

      self.removeOverriddenMethods(py, dict: dict)
    }

    private func copyMethods(from other: KnownNotOverriddenMethods) {
      self.__repr__ = other.__repr__ ?? self.__repr__
      self.__str__ = other.__str__ ?? self.__str__

      self.__hash__ = other.__hash__ ?? self.__hash__
      self.__dir__ = other.__dir__ ?? self.__dir__

      self.__eq__ = other.__eq__ ?? self.__eq__
      self.__ne__ = other.__ne__ ?? self.__ne__
      self.__lt__ = other.__lt__ ?? self.__lt__
      self.__le__ = other.__le__ ?? self.__le__
      self.__gt__ = other.__gt__ ?? self.__gt__
      self.__ge__ = other.__ge__ ?? self.__ge__

      self.__bool__ = other.__bool__ ?? self.__bool__
      self.__int__ = other.__int__ ?? self.__int__
      self.__float__ = other.__float__ ?? self.__float__
      self.__complex__ = other.__complex__ ?? self.__complex__
      self.__index__ = other.__index__ ?? self.__index__

      self.__getattr__ = other.__getattr__ ?? self.__getattr__
      self.__getattribute__ = other.__getattribute__ ?? self.__getattribute__
      self.__setattr__ = other.__setattr__ ?? self.__setattr__
      self.__delattr__ = other.__delattr__ ?? self.__delattr__

      self.__getitem__ = other.__getitem__ ?? self.__getitem__
      self.__setitem__ = other.__setitem__ ?? self.__setitem__
      self.__delitem__ = other.__delitem__ ?? self.__delitem__

      self.__iter__ = other.__iter__ ?? self.__iter__
      self.__next__ = other.__next__ ?? self.__next__
      self.__len__ = other.__len__ ?? self.__len__
      self.__contains__ = other.__contains__ ?? self.__contains__
      self.__reversed__ = other.__reversed__ ?? self.__reversed__
      self.keys = other.keys ?? self.keys

      self.__del__ = other.__del__ ?? self.__del__
      self.__call__ = other.__call__ ?? self.__call__

      self.__instancecheck__ = other.__instancecheck__ ?? self.__instancecheck__
      self.__subclasscheck__ = other.__subclasscheck__ ?? self.__subclasscheck__
      self.__isabstractmethod__ = other.__isabstractmethod__ ?? self.__isabstractmethod__

      self.__pos__ = other.__pos__ ?? self.__pos__
      self.__neg__ = other.__neg__ ?? self.__neg__
      self.__invert__ = other.__invert__ ?? self.__invert__
      self.__abs__ = other.__abs__ ?? self.__abs__
      self.__trunc__ = other.__trunc__ ?? self.__trunc__
      self.__round__ = other.__round__ ?? self.__round__

      self.__add__ = other.__add__ ?? self.__add__
      self.__and__ = other.__and__ ?? self.__and__
      self.__divmod__ = other.__divmod__ ?? self.__divmod__
      self.__floordiv__ = other.__floordiv__ ?? self.__floordiv__
      self.__lshift__ = other.__lshift__ ?? self.__lshift__
      self.__matmul__ = other.__matmul__ ?? self.__matmul__
      self.__mod__ = other.__mod__ ?? self.__mod__
      self.__mul__ = other.__mul__ ?? self.__mul__
      self.__or__ = other.__or__ ?? self.__or__
      self.__rshift__ = other.__rshift__ ?? self.__rshift__
      self.__sub__ = other.__sub__ ?? self.__sub__
      self.__truediv__ = other.__truediv__ ?? self.__truediv__
      self.__xor__ = other.__xor__ ?? self.__xor__

      self.__radd__ = other.__radd__ ?? self.__radd__
      self.__rand__ = other.__rand__ ?? self.__rand__
      self.__rdivmod__ = other.__rdivmod__ ?? self.__rdivmod__
      self.__rfloordiv__ = other.__rfloordiv__ ?? self.__rfloordiv__
      self.__rlshift__ = other.__rlshift__ ?? self.__rlshift__
      self.__rmatmul__ = other.__rmatmul__ ?? self.__rmatmul__
      self.__rmod__ = other.__rmod__ ?? self.__rmod__
      self.__rmul__ = other.__rmul__ ?? self.__rmul__
      self.__ror__ = other.__ror__ ?? self.__ror__
      self.__rrshift__ = other.__rrshift__ ?? self.__rrshift__
      self.__rsub__ = other.__rsub__ ?? self.__rsub__
      self.__rtruediv__ = other.__rtruediv__ ?? self.__rtruediv__
      self.__rxor__ = other.__rxor__ ?? self.__rxor__

      self.__iadd__ = other.__iadd__ ?? self.__iadd__
      self.__iand__ = other.__iand__ ?? self.__iand__
      self.__idivmod__ = other.__idivmod__ ?? self.__idivmod__
      self.__ifloordiv__ = other.__ifloordiv__ ?? self.__ifloordiv__
      self.__ilshift__ = other.__ilshift__ ?? self.__ilshift__
      self.__imatmul__ = other.__imatmul__ ?? self.__imatmul__
      self.__imod__ = other.__imod__ ?? self.__imod__
      self.__imul__ = other.__imul__ ?? self.__imul__
      self.__ior__ = other.__ior__ ?? self.__ior__
      self.__irshift__ = other.__irshift__ ?? self.__irshift__
      self.__isub__ = other.__isub__ ?? self.__isub__
      self.__itruediv__ = other.__itruediv__ ?? self.__itruediv__
      self.__ixor__ = other.__ixor__ ?? self.__ixor__

      self.__pow__ = other.__pow__ ?? self.__pow__
      self.__rpow__ = other.__rpow__ ?? self.__rpow__
      self.__ipow__ = other.__ipow__ ?? self.__ipow__
    }

    private func removeOverriddenMethods(_ py: Py, dict: PyDict) {
      for entry in dict.elements {
        let key = entry.key.object
        guard let string = py.cast.asString(key) else {
          continue
        }

        // All of the methods have ASCII name, so we can just use Swift definition
        // of equality.
        switch string.value {
        case "__repr__": self.__repr__ = nil
        case "__str__": self.__str__ = nil

        case "__hash__": self.__hash__ = nil
        case "__dir__": self.__dir__ = nil

        case "__eq__": self.__eq__ = nil
        case "__ne__": self.__ne__ = nil
        case "__lt__": self.__lt__ = nil
        case "__le__": self.__le__ = nil
        case "__gt__": self.__gt__ = nil
        case "__ge__": self.__ge__ = nil

        case "__bool__": self.__bool__ = nil
        case "__int__": self.__int__ = nil
        case "__float__": self.__float__ = nil
        case "__complex__": self.__complex__ = nil
        case "__index__": self.__index__ = nil

        case "__getattr__": self.__getattr__ = nil
        case "__getattribute__": self.__getattribute__ = nil
        case "__setattr__": self.__setattr__ = nil
        case "__delattr__": self.__delattr__ = nil

        case "__getitem__": self.__getitem__ = nil
        case "__setitem__": self.__setitem__ = nil
        case "__delitem__": self.__delitem__ = nil

        case "__iter__": self.__iter__ = nil
        case "__next__": self.__next__ = nil
        case "__len__": self.__len__ = nil
        case "__contains__": self.__contains__ = nil
        case "__reversed__": self.__reversed__ = nil
        case "keys": self.keys = nil

        case "__del__": self.__del__ = nil
        case "__call__": self.__call__ = nil

        case "__instancecheck__": self.__instancecheck__ = nil
        case "__subclasscheck__": self.__subclasscheck__ = nil
        case "__isabstractmethod__": self.__isabstractmethod__ = nil

        case "__pos__": self.__pos__ = nil
        case "__neg__": self.__neg__ = nil
        case "__invert__": self.__invert__ = nil
        case "__abs__": self.__abs__ = nil
        case "__trunc__": self.__trunc__ = nil
        case "__round__": self.__round__ = nil

        case "__add__": self.__add__ = nil
        case "__and__": self.__and__ = nil
        case "__divmod__": self.__divmod__ = nil
        case "__floordiv__": self.__floordiv__ = nil
        case "__lshift__": self.__lshift__ = nil
        case "__matmul__": self.__matmul__ = nil
        case "__mod__": self.__mod__ = nil
        case "__mul__": self.__mul__ = nil
        case "__or__": self.__or__ = nil
        case "__rshift__": self.__rshift__ = nil
        case "__sub__": self.__sub__ = nil
        case "__truediv__": self.__truediv__ = nil
        case "__xor__": self.__xor__ = nil

        case "__radd__": self.__radd__ = nil
        case "__rand__": self.__rand__ = nil
        case "__rdivmod__": self.__rdivmod__ = nil
        case "__rfloordiv__": self.__rfloordiv__ = nil
        case "__rlshift__": self.__rlshift__ = nil
        case "__rmatmul__": self.__rmatmul__ = nil
        case "__rmod__": self.__rmod__ = nil
        case "__rmul__": self.__rmul__ = nil
        case "__ror__": self.__ror__ = nil
        case "__rrshift__": self.__rrshift__ = nil
        case "__rsub__": self.__rsub__ = nil
        case "__rtruediv__": self.__rtruediv__ = nil
        case "__rxor__": self.__rxor__ = nil

        case "__iadd__": self.__iadd__ = nil
        case "__iand__": self.__iand__ = nil
        case "__idivmod__": self.__idivmod__ = nil
        case "__ifloordiv__": self.__ifloordiv__ = nil
        case "__ilshift__": self.__ilshift__ = nil
        case "__imatmul__": self.__imatmul__ = nil
        case "__imod__": self.__imod__ = nil
        case "__imul__": self.__imul__ = nil
        case "__ior__": self.__ior__ = nil
        case "__irshift__": self.__irshift__ = nil
        case "__isub__": self.__isub__ = nil
        case "__itruediv__": self.__itruediv__ = nil
        case "__ixor__": self.__ixor__ = nil

        case "__pow__": self.__pow__ = nil
        case "__rpow__": self.__rpow__ = nil
        case "__ipow__": self.__ipow__ = nil
        default: break
        }
      }
    }

    // MARK: - Copy

    public func copy() -> KnownNotOverriddenMethods {
      let result = KnownNotOverriddenMethods()

      result.__repr__ = self.__repr__
      result.__str__ = self.__str__

      result.__hash__ = self.__hash__
      result.__dir__ = self.__dir__

      result.__eq__ = self.__eq__
      result.__ne__ = self.__ne__
      result.__lt__ = self.__lt__
      result.__le__ = self.__le__
      result.__gt__ = self.__gt__
      result.__ge__ = self.__ge__

      result.__bool__ = self.__bool__
      result.__int__ = self.__int__
      result.__float__ = self.__float__
      result.__complex__ = self.__complex__
      result.__index__ = self.__index__

      result.__getattr__ = self.__getattr__
      result.__getattribute__ = self.__getattribute__
      result.__setattr__ = self.__setattr__
      result.__delattr__ = self.__delattr__

      result.__getitem__ = self.__getitem__
      result.__setitem__ = self.__setitem__
      result.__delitem__ = self.__delitem__

      result.__iter__ = self.__iter__
      result.__next__ = self.__next__
      result.__len__ = self.__len__
      result.__contains__ = self.__contains__
      result.__reversed__ = self.__reversed__
      result.keys = self.keys

      result.__del__ = self.__del__
      result.__call__ = self.__call__

      result.__instancecheck__ = self.__instancecheck__
      result.__subclasscheck__ = self.__subclasscheck__
      result.__isabstractmethod__ = self.__isabstractmethod__

      result.__pos__ = self.__pos__
      result.__neg__ = self.__neg__
      result.__invert__ = self.__invert__
      result.__abs__ = self.__abs__
      result.__trunc__ = self.__trunc__
      result.__round__ = self.__round__

      result.__add__ = self.__add__
      result.__and__ = self.__and__
      result.__divmod__ = self.__divmod__
      result.__floordiv__ = self.__floordiv__
      result.__lshift__ = self.__lshift__
      result.__matmul__ = self.__matmul__
      result.__mod__ = self.__mod__
      result.__mul__ = self.__mul__
      result.__or__ = self.__or__
      result.__rshift__ = self.__rshift__
      result.__sub__ = self.__sub__
      result.__truediv__ = self.__truediv__
      result.__xor__ = self.__xor__

      result.__radd__ = self.__radd__
      result.__rand__ = self.__rand__
      result.__rdivmod__ = self.__rdivmod__
      result.__rfloordiv__ = self.__rfloordiv__
      result.__rlshift__ = self.__rlshift__
      result.__rmatmul__ = self.__rmatmul__
      result.__rmod__ = self.__rmod__
      result.__rmul__ = self.__rmul__
      result.__ror__ = self.__ror__
      result.__rrshift__ = self.__rrshift__
      result.__rsub__ = self.__rsub__
      result.__rtruediv__ = self.__rtruediv__
      result.__rxor__ = self.__rxor__

      result.__iadd__ = self.__iadd__
      result.__iand__ = self.__iand__
      result.__idivmod__ = self.__idivmod__
      result.__ifloordiv__ = self.__ifloordiv__
      result.__ilshift__ = self.__ilshift__
      result.__imatmul__ = self.__imatmul__
      result.__imod__ = self.__imod__
      result.__imul__ = self.__imul__
      result.__ior__ = self.__ior__
      result.__irshift__ = self.__irshift__
      result.__isub__ = self.__isub__
      result.__itruediv__ = self.__itruediv__
      result.__ixor__ = self.__ixor__

      result.__pow__ = self.__pow__
      result.__rpow__ = self.__rpow__
      result.__ipow__ = self.__ipow__

      return result
    }
  }

  // MARK: - __repr__

  internal static func __repr__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__repr__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __str__

  internal static func __str__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__str__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __hash__

  internal static func __hash__(_ py: Py, object: PyObject) -> HashResult? {
    guard let method = object.type.staticMethods.__hash__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __dir__

  internal static func __dir__(_ py: Py, object: PyObject) -> PyResultGen<DirResult>? {
    guard let method = object.type.staticMethods.__dir__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __eq__

  internal static func __eq__(_ py: Py, left: PyObject, right: PyObject) -> CompareResult? {
    guard let method = left.type.staticMethods.__eq__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __ne__

  internal static func __ne__(_ py: Py, left: PyObject, right: PyObject) -> CompareResult? {
    guard let method = left.type.staticMethods.__ne__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __lt__

  internal static func __lt__(_ py: Py, left: PyObject, right: PyObject) -> CompareResult? {
    guard let method = left.type.staticMethods.__lt__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __le__

  internal static func __le__(_ py: Py, left: PyObject, right: PyObject) -> CompareResult? {
    guard let method = left.type.staticMethods.__le__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __gt__

  internal static func __gt__(_ py: Py, left: PyObject, right: PyObject) -> CompareResult? {
    guard let method = left.type.staticMethods.__gt__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __ge__

  internal static func __ge__(_ py: Py, left: PyObject, right: PyObject) -> CompareResult? {
    guard let method = left.type.staticMethods.__ge__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __bool__

  internal static func __bool__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__bool__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __int__

  internal static func __int__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__int__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __float__

  internal static func __float__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__float__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __complex__

  internal static func __complex__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__complex__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __index__

  internal static func __index__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__index__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __getattr__

  internal static func __getattr__(_ py: Py, object: PyObject, name: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__getattr__ else {
      return nil
    }

    return method(py, object, name)
  }

  // MARK: - __getattribute__

  internal static func __getattribute__(_ py: Py, object: PyObject, name: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__getattribute__ else {
      return nil
    }

    return method(py, object, name)
  }

  // MARK: - __setattr__

  internal static func __setattr__(_ py: Py, object: PyObject, name: PyObject, value: PyObject?) -> PyResult? {
    guard let method = object.type.staticMethods.__setattr__ else {
      return nil
    }

    return method(py, object, name, value)
  }

  // MARK: - __delattr__

  internal static func __delattr__(_ py: Py, object: PyObject, name: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__delattr__ else {
      return nil
    }

    return method(py, object, name)
  }

  // MARK: - __getitem__

  internal static func __getitem__(_ py: Py, object: PyObject, index: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__getitem__ else {
      return nil
    }

    return method(py, object, index)
  }

  // MARK: - __setitem__

  internal static func __setitem__(_ py: Py, object: PyObject, index: PyObject, value: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__setitem__ else {
      return nil
    }

    return method(py, object, index, value)
  }

  // MARK: - __delitem__

  internal static func __delitem__(_ py: Py, object: PyObject, index: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__delitem__ else {
      return nil
    }

    return method(py, object, index)
  }

  // MARK: - __iter__

  internal static func __iter__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__iter__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __next__

  internal static func __next__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__next__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __len__

  internal static func __len__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__len__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __contains__

  internal static func __contains__(_ py: Py, object: PyObject, element: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__contains__ else {
      return nil
    }

    return method(py, object, element)
  }

  // MARK: - __reversed__

  internal static func __reversed__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__reversed__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - keys

  internal static func keys(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.keys else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __del__

  internal static func __del__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__del__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __call__

  internal static func __call__(_ py: Py, object: PyObject, args: [PyObject], kwargs: PyDict?) -> PyResult? {
    guard let method = object.type.staticMethods.__call__ else {
      return nil
    }

    return method(py, object, args, kwargs)
  }

  // MARK: - __instancecheck__

  internal static func __instancecheck__(_ py: Py, type: PyObject, object: PyObject) -> PyResult? {
    guard let method = type.type.staticMethods.__instancecheck__ else {
      return nil
    }

    return method(py, type, object)
  }

  // MARK: - __subclasscheck__

  internal static func __subclasscheck__(_ py: Py, type: PyObject, base: PyObject) -> PyResult? {
    guard let method = type.type.staticMethods.__subclasscheck__ else {
      return nil
    }

    return method(py, type, base)
  }

  // MARK: - __isabstractmethod__

  internal static func __isabstractmethod__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__isabstractmethod__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __pos__

  internal static func __pos__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__pos__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __neg__

  internal static func __neg__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__neg__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __invert__

  internal static func __invert__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__invert__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __abs__

  internal static func __abs__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__abs__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __trunc__

  internal static func __trunc__(_ py: Py, object: PyObject) -> PyResult? {
    guard let method = object.type.staticMethods.__trunc__ else {
      return nil
    }

    return method(py, object)
  }

  // MARK: - __round__

  internal static func __round__(_ py: Py, object: PyObject, nDigits: PyObject?) -> PyResult? {
    guard let method = object.type.staticMethods.__round__ else {
      return nil
    }

    return method(py, object, nDigits)
  }

  // MARK: - __add__

  internal static func __add__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__add__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __and__

  internal static func __and__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__and__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __divmod__

  internal static func __divmod__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__divmod__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __floordiv__

  internal static func __floordiv__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__floordiv__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __lshift__

  internal static func __lshift__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__lshift__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __matmul__

  internal static func __matmul__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__matmul__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __mod__

  internal static func __mod__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__mod__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __mul__

  internal static func __mul__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__mul__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __or__

  internal static func __or__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__or__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rshift__

  internal static func __rshift__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rshift__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __sub__

  internal static func __sub__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__sub__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __truediv__

  internal static func __truediv__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__truediv__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __xor__

  internal static func __xor__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__xor__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __radd__

  internal static func __radd__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__radd__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rand__

  internal static func __rand__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rand__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rdivmod__

  internal static func __rdivmod__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rdivmod__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rfloordiv__

  internal static func __rfloordiv__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rfloordiv__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rlshift__

  internal static func __rlshift__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rlshift__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rmatmul__

  internal static func __rmatmul__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rmatmul__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rmod__

  internal static func __rmod__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rmod__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rmul__

  internal static func __rmul__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rmul__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __ror__

  internal static func __ror__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__ror__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rrshift__

  internal static func __rrshift__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rrshift__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rsub__

  internal static func __rsub__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rsub__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rtruediv__

  internal static func __rtruediv__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rtruediv__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __rxor__

  internal static func __rxor__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__rxor__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __iadd__

  internal static func __iadd__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__iadd__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __iand__

  internal static func __iand__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__iand__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __idivmod__

  internal static func __idivmod__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__idivmod__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __ifloordiv__

  internal static func __ifloordiv__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__ifloordiv__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __ilshift__

  internal static func __ilshift__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__ilshift__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __imatmul__

  internal static func __imatmul__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__imatmul__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __imod__

  internal static func __imod__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__imod__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __imul__

  internal static func __imul__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__imul__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __ior__

  internal static func __ior__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__ior__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __irshift__

  internal static func __irshift__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__irshift__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __isub__

  internal static func __isub__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__isub__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __itruediv__

  internal static func __itruediv__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__itruediv__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __ixor__

  internal static func __ixor__(_ py: Py, left: PyObject, right: PyObject) -> PyResult? {
    guard let method = left.type.staticMethods.__ixor__ else {
      return nil
    }

    return method(py, left, right)
  }

  // MARK: - __pow__

  internal static func __pow__(_ py: Py, base: PyObject, exp: PyObject, mod: PyObject) -> PyResult? {
    guard let method = base.type.staticMethods.__pow__ else {
      return nil
    }

    return method(py, base, exp, mod)
  }

  // MARK: - __rpow__

  internal static func __rpow__(_ py: Py, base: PyObject, exp: PyObject, mod: PyObject) -> PyResult? {
    guard let method = base.type.staticMethods.__rpow__ else {
      return nil
    }

    return method(py, base, exp, mod)
  }

  // MARK: - __ipow__

  internal static func __ipow__(_ py: Py, base: PyObject, exp: PyObject, mod: PyObject) -> PyResult? {
    guard let method = base.type.staticMethods.__ipow__ else {
      return nil
    }

    return method(py, base, exp, mod)
  }
}
