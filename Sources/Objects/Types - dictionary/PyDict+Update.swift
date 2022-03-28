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

  public func update(_ py: Py,
                     from object: PyObject,
                     onKeyDuplicate: OnUpdateKeyDuplicate) -> PyBaseException? {
    // Fast path if we are 'dict' (but not subclass)
    if let dict = py.cast.asExactlyDict(object) {
      return self.update(py,
                         from: dict.elements,
                         onKeyDuplicate: onKeyDuplicate)
    }

    switch py.getKeys(object: object) {
    case .value(let keys): // We have keys -> dict-like object
      return self.update(py,
                         fromKeysOwner: object,
                         keys: keys,
                         onKeyDuplicate: onKeyDuplicate)

    case .missingMethod: // We don't have keys -> try iterable
      return self.update(py,
                         fromIterableOfPairs: object,
                         onKeyDuplicate: onKeyDuplicate)

    case .error(let e):
      return e
    }
  }

  // MARK: - From other dict

  internal func update(_ py: Py,
                       from dict: PyDict,
                       onKeyDuplicate: OnUpdateKeyDuplicate) -> PyBaseException? {
    let data = dict.elements
    return self.update(py, from: data, onKeyDuplicate: onKeyDuplicate)
  }

  internal func update(_ py: Py,
                       from data: OrderedDictionary,
                       onKeyDuplicate: OnUpdateKeyDuplicate) -> PyBaseException? {
    for entry in data {
      if let error = self.updateSingleEntry(py,
                                            key: entry.key,
                                            value: entry.value,
                                            onKeyDuplicate: onKeyDuplicate) {
        return error
      }
    }

    return nil
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
  private func update(_ py: Py,
                      fromIterableOfPairs iterable: PyObject,
                      onKeyDuplicate: OnUpdateKeyDuplicate) -> PyBaseException? {
    var keyValues = [KeyValue]()
    let reduceError = py.reduce(iterable: iterable, into: &keyValues) { acc, object in
      switch self.unpackKeyValuePair(py, iterable: object) {
      case let .value(keyValue):
        acc.append(keyValue)
        return .goToNextElement
      case let .error(e):
        return .error(e)
      }
    }

    if let error = reduceError {
      return error
    }

    for kv in keyValues {
      if let error = self.updateSingleEntry(py,
                                            key: kv.key,
                                            value: kv.value,
                                            onKeyDuplicate: onKeyDuplicate) {
        return error
      }
    }

    return nil
  }

  /// Given iterable of 2 elements it will return
  /// `iterable[0]` as key and `iterable[1]` as value.
  private func unpackKeyValuePair(_ py: Py,
                                  iterable: PyObject) -> PyResultGen<KeyValue> {
    struct Tmp {
      var key: Key?
      var value: PyObject?
      var count = 0
    }

    var tmp = Tmp()
    let error = py.reduce(iterable: iterable, into: &tmp) { acc, object in
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

    if let error = error {
      return .error(error)
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
  private func update(_ py: Py,
                      fromKeysOwner dict: PyObject,
                      keys keyIterable: PyObject,
                      onKeyDuplicate: OnUpdateKeyDuplicate) -> PyBaseException? {
    let error = py.forEach(iterable: keyIterable) { keyObject in
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
                                        key: key,
                                        value: value,
                                        onKeyDuplicate: onKeyDuplicate) {
        return .error(e)
      }

      return .goToNextElement
    }

    // We could just 'return py.forEach', but this is easier to debug.
    return error
  }

  // MARK: - Update single entry

  internal func updateSingleEntry(_ py: Py,
                                  key: Key,
                                  value: PyObject,
                                  onKeyDuplicate: OnUpdateKeyDuplicate) -> PyBaseException? {
    switch self.elementsPtr.pointee.insert(py, key: key, value: value) {
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
