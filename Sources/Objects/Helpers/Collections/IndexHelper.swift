import VioletCore

internal enum IndexHelper {

  internal enum IndexMaybe<T> {
    case value(T)
    case notIndex
    case error(PyBaseException)
  }

  // MARK: - Int

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
  internal static func intMaybe(_ value: PyObject) -> IndexMaybe<Int> {
    let bigInt: BigInt
    switch self.bigIntMaybe(value) {
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
  internal static func int(_ value: PyObject) -> PyResult<Int> {
    switch IndexHelper.intMaybe(value) {
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

  /// Try to extract `BigInt` index from `PyObject`.
  ///
  /// When object is not convertible to index it will return `.notIndex`.
  internal static func bigIntMaybe(_ value: PyObject) -> IndexMaybe<BigInt> {
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
      return .value(int.value)

    case .missingMethod:
      return .notIndex
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  /// Extract `BigInt` index from `PyObject`.
  ///
  /// It will return error when:
  /// - object is not convertible to index
  internal static func bigInt(_ value: PyObject) -> PyResult<BigInt> {
    switch IndexHelper.bigIntMaybe(value) {
    case .value(let v):
      return .value(v)
    case .notIndex:
      let msg = "'\(value.typeName)' object cannot be interpreted as an integer"
      return .typeError(msg)
    case .error(let e):
      return .error(e)
    }
  }
}