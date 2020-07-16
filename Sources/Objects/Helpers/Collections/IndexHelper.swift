import BigInt
import VioletCore

/// Helper for dealing with `__index__` Python method.
internal enum IndexHelper {

  // MARK: - Int

  internal enum IntOrNone {
    case value(Int)
    case notIndex
    case error(PyBaseException)
  }

  /// Try to extract `Int` index from `PyObject`.
  ///
  /// When object is not convertible to index it will return `.notIndex`.
  /// When index is out of range of `int` it will return error.
  ///
  /// CPython:
  /// ```
  /// Py_ssize_t PyNumber_AsSsize_t(PyObject *item, PyObject *err)
  /// _PyEval_SliceIndexNotNone
  /// ```
  internal static func intOrNone(_ value: PyObject) -> IntOrNone {
    let bigInt: BigInt
    switch Self.bigInt(value) {
    case .value(let v): bigInt = v
    case .notIndex: return .notIndex
    case .error(let e): return .error(e)
    }

    if let int = Int(exactly: bigInt) {
      return .value(int)
    }

    let msg = "cannot fit '\(value.typeName)' into an index-sized integer"
    return .error(Py.newIndexError(msg: msg))
  }

  /// Extract `int` index from `PyObject`.
  ///
  /// It will return error when:
  /// - object is not convertible to index
  /// - index is out of range of `int`
  internal static func intOrError(_ value: PyObject) -> PyResult<Int> {
    switch IndexHelper.intOrNone(value) {
    case .value(let v):
      return .value(v)
    case .notIndex:
      let msg = "'\(value.typeName)' object cannot be interpreted as an integer"
      return .typeError(msg)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - BigInt

  internal enum BigIntIndex {
    case value(BigInt)
    /// Given object is not an index.
    /// Associated value is the 'given object'.
    case notIndex(PyObject)
    case error(PyBaseException)

    internal func asResult() -> PyResult<BigInt> {
      switch self {
      case .value(let int):
        return .value(int)

      case .notIndex(let object):
        let typeName = object.typeName
        let msg = "'\(typeName)' object cannot be interpreted as an integer"
        return .typeError(msg)

      case .error(let e):
        return .error(e)
      }
    }
  }

  /// Try to extract `BigInt` index from `PyObject`.
  ///
  /// When object is not convertible to index it will return `.notIndex`.
  ///
  /// CPython:
  /// ```
  /// PyObject *
  /// PyNumber_Index(PyObject *item)
  /// ```
  internal static func bigInt(_ value: PyObject) -> BigIntIndex {
    if let int = value as? PyInt {
      return .value(int.value)
    }

    if let result = Fast.__index__(value) {
      return .value(result)
    }

    switch Py.callMethod(object: value, selector: .__index__) {
    case .value(let object):
      guard let int = object as? PyInt else {
        let msg = "__index__ returned non-int (type \(object.typeName)"
        return .error(Py.newTypeError(msg: msg))
      }

      let isSubclass = !int.checkExact()
      if isSubclass {
        let msg = "__index__ returned non-int (type \(int.typeName)).  " +
          "The ability to return an instance of a strict subclass of int " +
          "is deprecated, and may be removed in a future version of Python."

        if let e = Py.warn(type: .deprecation, msg: msg) {
          return .error(e)
        }
      }

      return .value(int.value)

    case .missingMethod:
      return .notIndex(value)

    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
