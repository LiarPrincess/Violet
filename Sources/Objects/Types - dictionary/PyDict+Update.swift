import BigInt
import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c
// https://docs.python.org/3.7/c-api/dict.html

// This method is very long (and complicated).
extension PyDict {

  public enum OnUpdateKeyDuplicate {
    /// This is probably what you want.
    case `continue`
    /// Do not allow duplicates.
    case error
  }

  public static func update(_ py: Py,
                            zelf: PyDict,
                            from object: PyObject,
                            onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyObject> {
    // Fast path if we are 'dict' (but not subclass)
    if let dict = py.cast.asExactlyDict(object) {
      return Self.update(py,
                         zelf: zelf,
                         from: dict.elements,
                         onKeyDuplicate: onKeyDuplicate)
    }

    switch py.getKeys(object: object) {
    case .value(let keys): // We have keys -> dict-like object
      return Self.update(py,
                         zelf: zelf,
                         fromKeysOwner: object,
                         keys: keys,
                         onKeyDuplicate: onKeyDuplicate)

    case .missingMethod: // We don't have keys -> try iterable
      return Self.update(py,
                         zelf: zelf,
                         fromIterableOfPairs: object,
                         onKeyDuplicate: onKeyDuplicate)

    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - From other dict

  internal static func update(_ py: Py,
                              zelf: PyDict,
                              from data: OrderedDictionary,
                              onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyObject> {
    for entry in data {
      if let e = Self.updateSingleEntry(py,
                                        zelf: zelf,
                                        key: entry.key,
                                        value: entry.value,
                                        onKeyDuplicate: onKeyDuplicate) {
        return .error(e)
      }
    }

    return .none(py)
  }

  // MARK: - From iterable of pairs

  private struct KeyValue {
    fileprivate let key: Key
    fileprivate let value: PyObject
  }

  /// int
  /// PyDict_MergeFromSeq2(PyObject *d, PyObject *seq2, int override)
  ///
  /// Iterable of sequences with 2 elements (key and value).
  private static func update(_ py: Py,
                             zelf: PyDict,
                             fromIterableOfPairs iterable: PyObject,
                             onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyObject> {
    var keyValues = [KeyValue]()
    let reduceError = py.reduce(iterable: iterable, into: &keyValues) { acc, object in
      switch Self.unpackKeyValuePair(py, iterable: object) {
      case let .value(keyValue):
        acc.append(keyValue)
        return .goToNextElement
      case let .error(e):
        return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    for kv in keyValues {
      if let e = self.updateSingleEntry(py,
                                        zelf: zelf,
                                        key: kv.key,
                                        value: kv.value,
                                        onKeyDuplicate: onKeyDuplicate) {
        return .error(e)
      }
    }

    return .none(py)
  }

  /// Given iterable of 2 elements it will return
  /// `iterable[0]` as key and `iterable[1]` as value.
  private static func unpackKeyValuePair(_ py: Py,
                                         iterable: PyObject) -> PyResult<KeyValue> {
    struct Tmp {
      var key: Key?
      var value: PyObject?
      var count = 0
    }

    var tmp = Tmp()
    let e = py.reduce(iterable: iterable, into: &tmp) { acc, object in
      acc.count += 1

      if acc.key == nil {
        switch Self.createKey(py, object: object) {
        case let .value(k): acc.key = k
        case let .error(e): return .error(e)
        }
      } else if acc.value == nil {
        acc.value = object
      }

      return .goToNextElement
    }

    if let e = e {
      return .error(e)
    }

    guard let key = tmp.key, let value = tmp.value, tmp.count == 2 else {
      let message = "dictionary update sequence element has length \(tmp.count); 2 is required"
      return .valueError(py, message: message)
    }

    let result = KeyValue(key: key, value: value)
    return .value(result)
  }

  // MARK: - From keys owner

  /// static int
  /// dict_merge(PyObject *a, PyObject *b, int override)
  private static func update(_ py: Py,
                             zelf: PyDict,
                             fromKeysOwner dict: PyObject,
                             keys keyIterable: PyObject,
                             onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyObject> {
    let e = py.forEach(iterable: keyIterable) { keyObject in
      let key: Key
      switch PyDict.createKey(py, object: keyObject) {
      case let .value(k): key = k
      case let .error(e): return .error(e)
      }

      let value: PyObject
      switch py.getItem(object: dict, index: keyObject) {
      case let .value(v): value = v
      case let .error(e): return .error(e)
      }

      if let e = self.updateSingleEntry(py,
                                        zelf: zelf,
                                        key: key,
                                        value: value,
                                        onKeyDuplicate: onKeyDuplicate) {
        return .error(e)
      }

      return .goToNextElement
    }

    if let e = e {
      return .error(e)
    }

    return .none(py)
  }

  // MARK: - Update single entry

  internal static func updateSingleEntry(
    _ py: Py,
    zelf: PyDict,
    key: Key,
    value: PyObject,
    onKeyDuplicate: OnUpdateKeyDuplicate
  ) -> PyBaseException? {
    switch zelf.elements.insert(py, key: key, value: value) {
    case .inserted:
      return nil
    case .updated:
      switch onKeyDuplicate {
      case .continue:
        return nil
      case .error:
        let error = py.newKeyError(key: key.object)
        return error.asBaseException
      }
    case .error(let e):
      return e
    }
  }
}
