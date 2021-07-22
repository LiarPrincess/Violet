import VioletCore

// swiftlint:disable nesting
// swiftlint:disable file_length

// We can force cast, because if the Swift type does not correspond to the Python
// type, then we are in deep trouble (this is one of the main invariants in Violet).
private func forceCast<T: PyObject>(object: PyObject, as type: T.Type) -> T {
  #if DEBUG
  let swiftType = Swift.type(of: object)
  guard swiftType == T.self else {
    trap("Swift type (\(type)) does not match Python type (\(object.typeName))")
  }
  #endif

  // swiftlint:disable:next force_cast
  return object as! T
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
    internal var __float__: AsFloatWrapper?
    internal var __int__: AsIntWrapper?
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
    internal var __instancecheck__: IsTypeWrapper?
    internal var __subclasscheck__: IsSubtypeWrapper?
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
    internal var __pow__: NumericTernaryWrapper?
    internal var __rpow__: NumericTernaryWrapper?
    internal var __ipow__: NumericTernaryWrapper?

    // MARK: - Copy

    internal func copy() -> StaticallyKnownNotOverriddenMethods {
      // We are struct, so this is trivial.
      // If we ever change it to reference type, then we just need to change
      // this method.
      return self
    }

    // MARK: StringConversionWrapper

    /// repr(zelf: PyObject) -> PyResult<String>
    /// repr(bool zelf: PyBool) -> PyResult<String>
    /// repr() -> PyResult<String>
    /// repr(int zelf: PyInt) -> PyResult<String>
    internal struct StringConversionWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: HashWrapper

    /// hash(zelf: PyObject) -> HashResult
    /// hash() -> HashResult
    internal struct HashWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: ComparisonWrapper

    /// isEqual(zelf: PyObject, other: PyObject) -> CompareResult
    /// isEqual(_ other: PyObject) -> CompareResult
    internal struct ComparisonWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: AsBoolWrapper

    /// asBool() -> Bool
    internal struct AsBoolWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: AsFloatWrapper

    /// asFloat() -> PyResult<PyFloat>
    internal struct AsFloatWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: AsIntWrapper

    /// asInt() -> PyResult<PyInt>
    internal struct AsIntWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: AsComplexWrapper

    internal struct AsComplexWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: AsIndexWrapper

    /// asIndex() -> BigInt
    internal struct AsIndexWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: GetAttributeWrapper

    internal struct GetAttributeWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: SetAttributeWrapper

    /// setAttribute(zelf: PyObject, name: PyObject, value: PyObject?) -> PyResult<PyNone>
    /// setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone>
    internal struct SetAttributeWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: DelAttributeWrapper

    /// delAttribute(zelf: PyObject, name: PyObject) -> PyResult<PyNone>
    /// delAttribute(name: PyObject) -> PyResult<PyNone>
    internal struct DelAttributeWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: GetItemWrapper

    /// getItem(index: PyObject) -> PyResult<PyObject>
    internal struct GetItemWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: SetItemWrapper

    /// setItem(index: PyObject, value: PyObject) -> PyResult<PyNone>
    internal struct SetItemWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: DelItemWrapper

    /// delItem(index: PyObject) -> PyResult<PyNone>
    internal struct DelItemWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: IterWrapper

    /// iter() -> PyObject
    internal struct IterWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: NextWrapper

    /// next() -> PyResult<PyObject>
    internal struct NextWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: GetLengthWrapper

    /// getLength() -> BigInt
    internal struct GetLengthWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: ContainsWrapper

    /// contains(element: PyObject) -> PyResult<Bool>
    internal struct ContainsWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: ReversedWrapper

    /// reversed() -> PyObject
    internal struct ReversedWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: KeysWrapper

    /// keys() -> PyObject
    internal struct KeysWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: DelWrapper

    /// del() -> PyResult<PyNone>
    internal struct DelWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: DirWrapper

    /// dir(zelf: PyObject) -> PyResult<DirResult>
    /// dir() -> PyResult<DirResult>
    internal struct DirWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: CallWrapper

    /// call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>
    internal struct CallWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: IsTypeWrapper

    /// isType(of object: PyObject) -> Bool
    internal struct IsTypeWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: IsSubtypeWrapper

    /// isSubtype(of object: PyObject) -> PyResult<Bool>
    internal struct IsSubtypeWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: IsAbstractMethodWrapper

    /// isAbstractMethod() -> PyResult<Bool>
    internal struct IsAbstractMethodWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: NumericUnaryWrapper

    /// positive() -> PyObject
    internal struct NumericUnaryWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: NumericTruncWrapper

    /// trunc() -> PyResult<PyInt>
    internal struct NumericTruncWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: NumericRoundWrapper

    /// round(nDigits: PyObject?) -> PyResult<PyObject>
    /// round(nDigits _nDigits: PyObject?) -> PyResult<PyObject>
    internal struct NumericRoundWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: NumericBinaryWrapper

    /// add(_ other: PyObject) -> PyResult<PyObject>
    internal struct NumericBinaryWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }

    // MARK: NumericTernaryWrapper

    /// pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject>
    internal struct NumericTernaryWrapper {

      internal let fn: (PyObject) -> PyObject

//      internal init<T: PyObject>(_ fn: @escaping (T) -> PyObject) {
//        self.fn = { (arg0: PyObject) in
//          let zelf = forceCast(object: arg0, as: T)
//          return fn(zelf)
//        }
//        fatalError()
//      }
    }
  }
}
