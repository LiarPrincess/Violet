import Core

internal enum SequenceHelper {

  internal enum GetIndexResult<T> {
    case value(T)
    case notIndex
    case error(PyErrorEnum)
  }

  // MARK: - Int

  /// Py_ssize_t PyNumber_AsSsize_t(PyObject *item, PyObject *err)
  /// _PyEval_SliceIndexNotNone
  internal static func tryGetIndex(_ value: PyObject) -> GetIndexResult<Int> {
    let bigInt: BigInt
    switch tryGetIndexBig(value) {
    case .value(let v): bigInt = v
    case .notIndex: return .notIndex
    case .error(let e): return .error(e)
    }

    if let int = Int(exactly: bigInt) {
      return .value(int)
    }

    let msg = "cannot fit '\(value.typeName)' into an index-sized integer"
    return .error(.indexError(msg))
  }

  /// Basically `SequenceHelper.tryGetIndex`, but it will return type error
  /// if the value cannot be converted to index.
  internal static func getIndex(_ value: PyObject) -> PyResult<Int> {
    switch SequenceHelper.tryGetIndex(value) {
    case .value(let v):
      return .value(v)
    case .notIndex:
      let msg = "'\(value.typeName)' object cannot be interpreted as an integer"
      return .error(.typeError(msg))
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - BigInt

  /// Basically `SequenceHelper.tryGetIndexBig`, but it will return type error
  /// if the value cannot be converted to index.
  internal static func getIndexBig(_ value: PyObject) -> PyResult<BigInt> {
    switch SequenceHelper.tryGetIndexBig(value) {
    case .value(let v):
      return .value(v)
    case .notIndex:
      let msg = "'\(value.typeName)' object cannot be interpreted as an integer"
      return .error(.typeError(msg))
    case .error(let e):
      return .error(e)
    }
  }

  /// Return a Python int from the object item.
  /// Raise TypeError if the result is not an int
  /// or if the object cannot be interpreted as an index.
  ///
  /// PyObject * PyNumber_Index(PyObject *item)
  internal static func tryGetIndexBig(_ value: PyObject) -> GetIndexResult<BigInt> {
    if let int = value as? PyInt {
      return .value(int.value)
    }

    if let indexOwner = value as? __index__Owner {
      return .value(indexOwner.asIndex())
    }

    switch value.builtins.callMethod(on: value, selector: "__index__") {
    case .value(let object):
      guard let int = object as? PyInt else {
        let msg = "__index__ returned non-int (type \(object.typeName)"
        return .error(.typeError(msg))
      }
      return .value(int.value)

    case .noSuchMethod,
         .notImplemented:
      return .notIndex
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }
  }
}
