import BigInt
import VioletCore

// swiftlint:disable nesting
// swiftlint:disable file_length

// We can force cast, because if the Swift type does not correspond to the Python
// type, then we are in deep trouble (this is one of the main invariants in Violet).
private func forceCast<T: PyObject>(object: PyObject, as type: T.Type) -> T {
  #if DEBUG
  guard let result = object as? T else {
    trap("Python type (\(object.typeName)) does not match Swift type (\(type)).")
  }

  return result
  #else
  // swiftlint:disable:next force_cast
  return object as! T
  #endif
}

// MARK: - Statically known not overridden methods

extension PyType {

  /// Methods needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal struct StaticallyKnownNotOverriddenMethods {

    // MARK: Methods

    // All of the function pointers have 16 bytes.
    // They also have invalid representation that can be used as optional tag.
    // So each of those function wrappers is exactly 16 bytes.

    internal var __repr__: StringConversionWrapper?
    internal var __str__: StringConversionWrapper?

    internal var __hash__: HashWrapper?

    internal var __eq__: ComparisonWrapper?
    internal var __ne__: ComparisonWrapper?
    internal var __lt__: ComparisonWrapper?
    internal var __le__: ComparisonWrapper?
    internal var __gt__: ComparisonWrapper?
    internal var __ge__: ComparisonWrapper?

    internal var __bool__: AsBoolWrapper?
    internal var __int__: AsIntWrapper?
    internal var __float__: AsFloatWrapper?
    internal var __complex__: AsComplexWrapper?
    internal var __index__: AsIndexWrapper?

    internal var __getattr__: GetAttributeWrapper?
    internal var __getattribute__: GetAttributeWrapper?
    internal var __setattr__: SetAttributeWrapper?
    internal var __delattr__: DelAttributeWrapper?

    internal var __getitem__: GetItemWrapper?
    internal var __setitem__: SetItemWrapper?
    internal var __delitem__: DelItemWrapper?

    internal var __iter__: IterWrapper?
    internal var __next__: NextWrapper?
    internal var __len__: GetLengthWrapper?
    internal var __contains__: ContainsWrapper?
    internal var __reversed__: ReversedWrapper?
    internal var keys: KeysWrapper?

    internal var __del__: DelWrapper?
    internal var __dir__: DirWrapper?
    internal var __call__: CallWrapper?

    internal var __instancecheck__: InstanceCheckWrapper?
    internal var __subclasscheck__: SubclassCheckWrapper?
    internal var __isabstractmethod__: IsAbstractMethodWrapper?

    internal var __pos__: NumericUnaryWrapper?
    internal var __neg__: NumericUnaryWrapper?
    internal var __abs__: NumericUnaryWrapper?
    internal var __invert__: NumericUnaryWrapper?
    internal var __trunc__: NumericTruncWrapper?
    internal var __round__: NumericRoundWrapper?

    internal var __add__: NumericBinaryWrapper?
    internal var __and__: NumericBinaryWrapper?
    internal var __divmod__: NumericBinaryWrapper?
    internal var __floordiv__: NumericBinaryWrapper?
    internal var __lshift__: NumericBinaryWrapper?
    internal var __matmul__: NumericBinaryWrapper?
    internal var __mod__: NumericBinaryWrapper?
    internal var __mul__: NumericBinaryWrapper?
    internal var __or__: NumericBinaryWrapper?
    internal var __rshift__: NumericBinaryWrapper?
    internal var __sub__: NumericBinaryWrapper?
    internal var __truediv__: NumericBinaryWrapper?
    internal var __xor__: NumericBinaryWrapper?

    internal var __radd__: NumericBinaryWrapper?
    internal var __rand__: NumericBinaryWrapper?
    internal var __rdivmod__: NumericBinaryWrapper?
    internal var __rfloordiv__: NumericBinaryWrapper?
    internal var __rlshift__: NumericBinaryWrapper?
    internal var __rmatmul__: NumericBinaryWrapper?
    internal var __rmod__: NumericBinaryWrapper?
    internal var __rmul__: NumericBinaryWrapper?
    internal var __ror__: NumericBinaryWrapper?
    internal var __rrshift__: NumericBinaryWrapper?
    internal var __rsub__: NumericBinaryWrapper?
    internal var __rtruediv__: NumericBinaryWrapper?
    internal var __rxor__: NumericBinaryWrapper?

    internal var __iadd__: NumericBinaryWrapper?
    internal var __iand__: NumericBinaryWrapper?
    internal var __idivmod__: NumericBinaryWrapper?
    internal var __ifloordiv__: NumericBinaryWrapper?
    internal var __ilshift__: NumericBinaryWrapper?
    internal var __imatmul__: NumericBinaryWrapper?
    internal var __imod__: NumericBinaryWrapper?
    internal var __imul__: NumericBinaryWrapper?
    internal var __ior__: NumericBinaryWrapper?
    internal var __irshift__: NumericBinaryWrapper?
    internal var __isub__: NumericBinaryWrapper?
    internal var __itruediv__: NumericBinaryWrapper?
    internal var __ixor__: NumericBinaryWrapper?

    internal var __pow__: NumericPowWrapper?
    internal var __rpow__: NumericPowWrapper?
    internal var __ipow__: NumericPowWrapper?

    // MARK: - Copy

    internal func copy() -> StaticallyKnownNotOverriddenMethods {
      // We are struct, so this is trivial.
      // If we ever change it to reference type, then we just need to change
      // this method.
      return self
    }

    // MARK: StringConversionWrapper

    internal struct StringConversionWrapper {

      internal let fn: (PyObject) -> PyResult<String>

      internal init<T: PyObject>(_ fn: @escaping (T) -> PyResult<String>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)
        }
      }

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<String>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }

      internal init<T: PyObject>(_ fn: @escaping (T) -> PyResult<PyString>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          let result = fn(zelf)
          return result.map { $0.value }
        }
      }
    }

    // MARK: HashWrapper

    internal struct HashWrapper {

      internal let fn: (PyObject) -> HashResult

      internal init(_ fn: @escaping (PyObject) -> HashResult) {
        self.fn = fn
      }

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> HashResult) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: ComparisonWrapper

    internal struct ComparisonWrapper {

      internal let fn: (PyObject, PyObject) -> CompareResult

      internal init(_ fn: @escaping (PyObject, PyObject) -> CompareResult) {
        self.fn = fn
      }

      internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> CompareResult) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: AsBoolWrapper

    internal struct AsBoolWrapper {

      internal let fn: (PyObject) -> Bool

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> Bool) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: AsIntWrapper

    internal struct AsIntWrapper {

      internal let fn: (PyObject) -> PyResult<PyInt>

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyInt>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: AsFloatWrapper

    internal struct AsFloatWrapper {

      internal let fn: (PyObject) -> PyResult<PyFloat>

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyFloat>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: AsComplexWrapper

    internal struct AsComplexWrapper {

      internal let fn: (PyObject) -> PyObject

      // This one is never used, so we do not need 'init'.
    }

    // MARK: AsIndexWrapper

    internal struct AsIndexWrapper {

      internal let fn: (PyObject) -> BigInt

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> BigInt) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: GetAttributeWrapper

    internal struct GetAttributeWrapper {

      internal let fn: (PyObject, PyObject) -> PyResult<PyObject>

      internal init(_ fn: @escaping (PyObject, PyObject) -> PyResult<PyObject>) {
        self.fn = fn
      }

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject) -> PyResult<PyObject>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: SetAttributeWrapper

    internal struct SetAttributeWrapper {

      internal let fn: (PyObject, PyObject, PyObject?) -> PyResult<PyNone>

      internal init(
        _ fn: @escaping (PyObject, PyObject, PyObject?) -> PyResult<PyNone>
      ) {
        self.fn = fn
      }

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject, PyObject?) -> PyResult<PyNone>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1, arg2)
        }
      }
    }

    // MARK: DelAttributeWrapper

    internal struct DelAttributeWrapper {

      internal let fn: (PyObject, PyObject) -> PyResult<PyNone>

      internal init(_ fn: @escaping (PyObject, PyObject) -> PyResult<PyNone>) {
        self.fn = fn
      }

      internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> PyResult<PyNone>) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: GetItemWrapper

    internal struct GetItemWrapper {

      internal let fn: (PyObject, PyObject) -> PyResult<PyObject>

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject) -> PyResult<PyObject>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: SetItemWrapper

    internal struct SetItemWrapper {

      internal let fn: (PyObject, PyObject, PyObject) -> PyResult<PyNone>

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject, PyObject) -> PyResult<PyNone>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1, arg2)
        }
      }
    }

    // MARK: DelItemWrapper

    internal struct DelItemWrapper {

      internal let fn: (PyObject, PyObject) -> PyResult<PyNone>

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject) -> PyResult<PyNone>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: IterWrapper

    internal struct IterWrapper {

      internal let fn: (PyObject) -> PyObject

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyObject) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: NextWrapper

    internal struct NextWrapper {

      internal let fn: (PyObject) -> PyResult<PyObject>

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyObject>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: GetLengthWrapper

    internal struct GetLengthWrapper {

      internal let fn: (PyObject) -> BigInt

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> BigInt) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: ContainsWrapper

    internal struct ContainsWrapper {

      internal let fn: (PyObject, PyObject) -> PyResult<Bool>

      internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> PyResult<Bool>) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: ReversedWrapper

    internal struct ReversedWrapper {

      internal let fn: (PyObject) -> PyObject

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyObject) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: KeysWrapper

    internal struct KeysWrapper {

      internal let fn: (PyObject) -> PyObject

      internal init(_ fn: @escaping (PyDict) -> () -> PyObject) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: PyDict.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: DelWrapper

    internal struct DelWrapper {

      internal let fn: (PyObject) -> PyResult<PyNone>

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyNone>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: DirWrapper

    internal struct DirWrapper {

      internal let fn: (PyObject) -> PyResult<DirResult>

      internal init(_ fn: @escaping (PyObject) -> PyResult<DirResult>) {
        self.fn = fn
      }

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<DirResult>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: CallWrapper

    internal struct CallWrapper {

      internal let fn: (PyObject, [PyObject], PyDict?) -> PyResult<PyObject>

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> ([PyObject], PyDict?) -> PyResult<PyObject>
      ) {
        self.fn = { (arg0: PyObject, args: [PyObject], kwargs: PyDict?) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(args, kwargs)
        }
      }
    }

    // MARK: InstanceCheckWrapper

    internal struct InstanceCheckWrapper {

      internal let fn: (PyObject, PyObject) -> Bool

      internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> Bool) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: SubclassCheckWrapper

    internal struct SubclassCheckWrapper {

      internal let fn: (PyObject, PyObject) -> PyResult<Bool>

      internal init<T: PyObject>(_ fn: @escaping (T) -> (PyObject) -> PyResult<Bool>) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: IsAbstractMethodWrapper

    internal struct IsAbstractMethodWrapper {

      internal let fn: (PyObject) -> PyResult<Bool>

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<Bool>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: NumericUnaryWrapper

    internal struct NumericUnaryWrapper {

      internal let fn: (PyObject) -> PyObject

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyObject) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: NumericTruncWrapper

    internal struct NumericTruncWrapper {

      internal let fn: (PyObject) -> PyResult<PyInt>

      internal init<T: PyObject>(_ fn: @escaping (T) -> () -> PyResult<PyInt>) {
        self.fn = { (arg0: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)()
        }
      }
    }

    // MARK: NumericRoundWrapper

    internal struct NumericRoundWrapper {

      internal let fn: (PyObject, PyObject?) -> PyResult<PyObject>

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject?) -> PyResult<PyObject>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject?) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: NumericBinaryWrapper

    internal struct NumericBinaryWrapper {

      internal let fn: (PyObject, PyObject) -> PyResult<PyObject>

      internal init<T: PyObject>(
        _ fn: @escaping (T, PyObject) -> PyResult<PyObject>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf, arg1)
        }
      }

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject) -> PyResult<PyObject>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1)
        }
      }
    }

    // MARK: NumericTernaryWrapper

    internal struct NumericPowWrapper {

      internal let fn: (PyObject, PyObject, PyObject) -> PyResult<PyObject>

      internal init<T: PyObject>(
        _ fn: @escaping (T) -> (PyObject, PyObject) -> PyResult<PyObject>
      ) {
        self.fn = { (arg0: PyObject, arg1: PyObject, arg2: PyObject) in
          let zelf = forceCast(object: arg0, as: T.self)
          return fn(zelf)(arg1, arg2)
        }
      }
    }
  }
}
