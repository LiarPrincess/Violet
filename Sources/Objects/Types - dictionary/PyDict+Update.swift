/* MARKER
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

  public func update(
    from object: PyObject,
    onKeyDuplicate: OnUpdateKeyDuplicate
  ) -> PyResult<PyNone> {
    // Fast path if we are 'dict' (but not subclass)
    if let dict = PyCast.asExactlyDict(object) {
      return self.update(from: dict.elements,
                         onKeyDuplicate: onKeyDuplicate)
    }

    switch Py.getKeys(object: object) {
    case .value(let keys): // We have keys -> dict-like object
      return self.update(fromKeysOwner: object,
                         keys: keys,
                         onKeyDuplicate: onKeyDuplicate)

    case .missingMethod: // We don't have keys -> try iterable
      return self.update(fromIterableOfPairs: object,
                         onKeyDuplicate: onKeyDuplicate)

    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - From other dict

  internal func update(
    from data: OrderedDictionary,
    onKeyDuplicate: OnUpdateKeyDuplicate
  ) -> PyResult<PyNone> {
    for entry in data {
      if let e = self.updateSingleEntry(key: entry.key,
                                        value: entry.value,
                                        onKeyDuplicate: onKeyDuplicate) {
        return .error(e)
      }
    }

    return .value(Py.none)
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
  private func update(fromIterableOfPairs iterable: PyObject,
                      onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyNone> {
    var keyValues = [KeyValue]()
    let reduceError = Py.reduce(iterable: iterable, into: &keyValues) { acc, object in
      switch self.unpackKeyValue(fromIterable: object) {
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
      if let e = self.updateSingleEntry(key: kv.key,
                                        value: kv.value,
                                        onKeyDuplicate: onKeyDuplicate) {
        return .error(e)
      }
    }

    return .value(Py.none)
  }

  /// Given iterable of 2 elements it will return
  /// `iterable[0]` as key and `iterable[1]` as value.
  private func unpackKeyValue(fromIterable iterable: PyObject) -> PyResult<KeyValue> {
    struct Tmp {
      var key: Key?
      var value: PyObject?
      var count = 0
    }

    var tmp = Tmp()
    let e = Py.reduce(iterable: iterable, into: &tmp) { acc, object in
      acc.count += 1

      if acc.key == nil {
        switch PyDict.createKey(from: object) {
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
      let msg = "dictionary update sequence element has length \(tmp.count); 2 is required"
      return .valueError(msg)
    }

    let result = KeyValue(key: key, value: value)
    return .value(result)
  }

  // MARK: - From keys owner

  /// static int
  /// dict_merge(PyObject *a, PyObject *b, int override)
  private func update(fromKeysOwner dict: PyObject,
                      keys keyIterable: PyObject,
                      onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyNone> {
    let e = Py.forEach(iterable: keyIterable) { keyObject in
      let key: Key
      switch PyDict.createKey(from: keyObject) {
      case let .value(k): key = k
      case let .error(e): return .error(e)
      }

      let value: PyObject
      switch Py.getItem(object: dict, index: keyObject) {
      case let .value(v): value = v
      case let .error(e): return .error(e)
      }

      if let e = self.updateSingleEntry(key: key,
                                        value: value,
                                        onKeyDuplicate: onKeyDuplicate) {
        return .error(e)
      }

      return .goToNextElement
    }

    if let e = e {
      return .error(e)
    }

    return .value(Py.none)
  }

  // MARK: - Update single entry

  internal func updateSingleEntry(
    key: Key,
    value: PyObject,
    onKeyDuplicate: OnUpdateKeyDuplicate
  ) -> PyBaseException? {
    switch self.elements.insert(key: key, value: value) {
    case .inserted:
      return nil
    case .updated:
      switch onKeyDuplicate {
      case .continue: return nil
      case .error: return Py.newKeyError(key: key.object)
      }
    case .error(let e):
      return e
    }
  }
}

*/