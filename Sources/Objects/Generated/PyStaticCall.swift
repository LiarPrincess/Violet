/* MARKER
// =========================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyStaticCall.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// =========================================================================

import BigInt
import VioletCore

// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable line_length
// swiftlint:disable file_length

/// Call Swift method directly without going through full Python dispatch
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
/// 2. Go into method wrapper (lldb: `s`)
/// 3. Step over `self` cast (lldb: `n`)
/// 4. Go into the final method (lldb: `s`)
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
internal enum PyStaticCall {

  // MARK: - __repr__

  internal static func __repr__(_ object: PyObject) -> PyResult<String>? {
    if let method = object.type.staticMethods.__repr__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __str__

  internal static func __str__(_ object: PyObject) -> PyResult<String>? {
    if let method = object.type.staticMethods.__str__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __hash__

  internal static func __hash__(_ object: PyObject) -> HashResult? {
    if let method = object.type.staticMethods.__hash__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __dir__

  internal static func __dir__(_ object: PyObject) -> PyResult<DirResult>? {
    if let method = object.type.staticMethods.__dir__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __eq__

  internal static func __eq__(left: PyObject, right: PyObject) -> CompareResult? {
    if let method = left.type.staticMethods.__eq__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __ne__

  internal static func __ne__(left: PyObject, right: PyObject) -> CompareResult? {
    if let method = left.type.staticMethods.__ne__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __lt__

  internal static func __lt__(left: PyObject, right: PyObject) -> CompareResult? {
    if let method = left.type.staticMethods.__lt__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __le__

  internal static func __le__(left: PyObject, right: PyObject) -> CompareResult? {
    if let method = left.type.staticMethods.__le__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __gt__

  internal static func __gt__(left: PyObject, right: PyObject) -> CompareResult? {
    if let method = left.type.staticMethods.__gt__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __ge__

  internal static func __ge__(left: PyObject, right: PyObject) -> CompareResult? {
    if let method = left.type.staticMethods.__ge__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __bool__

  internal static func __bool__(_ object: PyObject) -> Bool? {
    if let method = object.type.staticMethods.__bool__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __int__

  internal static func __int__(_ object: PyObject) -> PyResult<PyInt>? {
    if let method = object.type.staticMethods.__int__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __float__

  internal static func __float__(_ object: PyObject) -> PyResult<PyFloat>? {
    if let method = object.type.staticMethods.__float__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __complex__

  internal static func __complex__(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.__complex__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __index__

  internal static func __index__(_ object: PyObject) -> BigInt? {
    if let method = object.type.staticMethods.__index__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __getattr__

  internal static func __getattr__(_ object: PyObject, name: PyObject) -> PyResult<PyObject>? {
    if let method = object.type.staticMethods.__getattr__?.fn {
      return method(object, name)
    }

    return nil
  }

  // MARK: - __getattribute__

  internal static func __getattribute__(_ object: PyObject, name: PyObject) -> PyResult<PyObject>? {
    if let method = object.type.staticMethods.__getattribute__?.fn {
      return method(object, name)
    }

    return nil
  }

  // MARK: - __setattr__

  internal static func __setattr__(_ object: PyObject, name: PyObject, value: PyObject?) -> PyResult<PyNone>? {
    if let method = object.type.staticMethods.__setattr__?.fn {
      return method(object, name, value)
    }

    return nil
  }

  // MARK: - __delattr__

  internal static func __delattr__(_ object: PyObject, name: PyObject) -> PyResult<PyNone>? {
    if let method = object.type.staticMethods.__delattr__?.fn {
      return method(object, name)
    }

    return nil
  }

  // MARK: - __getitem__

  internal static func __getitem__(_ object: PyObject, index: PyObject) -> PyResult<PyObject>? {
    if let method = object.type.staticMethods.__getitem__?.fn {
      return method(object, index)
    }

    return nil
  }

  // MARK: - __setitem__

  internal static func __setitem__(_ object: PyObject, index: PyObject, value: PyObject) -> PyResult<PyNone>? {
    if let method = object.type.staticMethods.__setitem__?.fn {
      return method(object, index, value)
    }

    return nil
  }

  // MARK: - __delitem__

  internal static func __delitem__(_ object: PyObject, index: PyObject) -> PyResult<PyNone>? {
    if let method = object.type.staticMethods.__delitem__?.fn {
      return method(object, index)
    }

    return nil
  }

  // MARK: - __iter__

  internal static func __iter__(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.__iter__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __next__

  internal static func __next__(_ object: PyObject) -> PyResult<PyObject>? {
    if let method = object.type.staticMethods.__next__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __len__

  internal static func __len__(_ object: PyObject) -> BigInt? {
    if let method = object.type.staticMethods.__len__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __contains__

  internal static func __contains__(_ object: PyObject, element: PyObject) -> PyResult<Bool>? {
    if let method = object.type.staticMethods.__contains__?.fn {
      return method(object, element)
    }

    return nil
  }

  // MARK: - __reversed__

  internal static func __reversed__(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.__reversed__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - keys

  internal static func keys(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.keys?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __del__

  internal static func __del__(_ object: PyObject) -> PyResult<PyNone>? {
    if let method = object.type.staticMethods.__del__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __call__

  internal static func __call__(_ object: PyObject, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>? {
    if let method = object.type.staticMethods.__call__?.fn {
      return method(object, args, kwargs)
    }

    return nil
  }

  // MARK: - __instancecheck__

  internal static func __instancecheck__(type: PyObject, object: PyObject) -> Bool? {
    if let method = type.type.staticMethods.__instancecheck__?.fn {
      return method(type, object)
    }

    return nil
  }

  // MARK: - __subclasscheck__

  internal static func __subclasscheck__(type: PyObject, base: PyObject) -> PyResult<Bool>? {
    if let method = type.type.staticMethods.__subclasscheck__?.fn {
      return method(type, base)
    }

    return nil
  }

  // MARK: - __isabstractmethod__

  internal static func __isabstractmethod__(_ object: PyObject) -> PyResult<Bool>? {
    if let method = object.type.staticMethods.__isabstractmethod__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __pos__

  internal static func __pos__(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.__pos__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __neg__

  internal static func __neg__(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.__neg__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __invert__

  internal static func __invert__(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.__invert__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __abs__

  internal static func __abs__(_ object: PyObject) -> PyObject? {
    if let method = object.type.staticMethods.__abs__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __trunc__

  internal static func __trunc__(_ object: PyObject) -> PyResult<PyInt>? {
    if let method = object.type.staticMethods.__trunc__?.fn {
      return method(object)
    }

    return nil
  }

  // MARK: - __round__

  internal static func __round__(_ object: PyObject, nDigits: PyObject?) -> PyResult<PyObject>? {
    if let method = object.type.staticMethods.__round__?.fn {
      return method(object, nDigits)
    }

    return nil
  }

  // MARK: - __add__

  internal static func __add__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__add__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __and__

  internal static func __and__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__and__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __divmod__

  internal static func __divmod__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__divmod__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __floordiv__

  internal static func __floordiv__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__floordiv__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __lshift__

  internal static func __lshift__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__lshift__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __matmul__

  internal static func __matmul__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__matmul__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __mod__

  internal static func __mod__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__mod__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __mul__

  internal static func __mul__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__mul__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __or__

  internal static func __or__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__or__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rshift__

  internal static func __rshift__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rshift__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __sub__

  internal static func __sub__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__sub__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __truediv__

  internal static func __truediv__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__truediv__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __xor__

  internal static func __xor__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__xor__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __radd__

  internal static func __radd__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__radd__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rand__

  internal static func __rand__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rand__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rdivmod__

  internal static func __rdivmod__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rdivmod__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rfloordiv__

  internal static func __rfloordiv__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rfloordiv__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rlshift__

  internal static func __rlshift__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rlshift__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rmatmul__

  internal static func __rmatmul__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rmatmul__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rmod__

  internal static func __rmod__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rmod__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rmul__

  internal static func __rmul__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rmul__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __ror__

  internal static func __ror__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__ror__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rrshift__

  internal static func __rrshift__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rrshift__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rsub__

  internal static func __rsub__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rsub__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rtruediv__

  internal static func __rtruediv__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rtruediv__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __rxor__

  internal static func __rxor__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__rxor__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __iadd__

  internal static func __iadd__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__iadd__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __iand__

  internal static func __iand__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__iand__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __idivmod__

  internal static func __idivmod__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__idivmod__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __ifloordiv__

  internal static func __ifloordiv__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__ifloordiv__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __ilshift__

  internal static func __ilshift__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__ilshift__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __imatmul__

  internal static func __imatmul__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__imatmul__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __imod__

  internal static func __imod__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__imod__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __imul__

  internal static func __imul__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__imul__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __ior__

  internal static func __ior__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__ior__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __irshift__

  internal static func __irshift__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__irshift__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __isub__

  internal static func __isub__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__isub__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __itruediv__

  internal static func __itruediv__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__itruediv__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __ixor__

  internal static func __ixor__(left: PyObject, right: PyObject) -> PyResult<PyObject>? {
    if let method = left.type.staticMethods.__ixor__?.fn {
      return method(left, right)
    }

    return nil
  }

  // MARK: - __pow__

  internal static func __pow__(base: PyObject, exp: PyObject, mod: PyObject) -> PyResult<PyObject>? {
    if let method = base.type.staticMethods.__pow__?.fn {
      return method(base, exp, mod)
    }

    return nil
  }

  // MARK: - __rpow__

  internal static func __rpow__(base: PyObject, exp: PyObject, mod: PyObject) -> PyResult<PyObject>? {
    if let method = base.type.staticMethods.__rpow__?.fn {
      return method(base, exp, mod)
    }

    return nil
  }

  // MARK: - __ipow__

  internal static func __ipow__(base: PyObject, exp: PyObject, mod: PyObject) -> PyResult<PyObject>? {
    if let method = base.type.staticMethods.__ipow__?.fn {
      return method(base, exp, mod)
    }

    return nil
  }
}

*/