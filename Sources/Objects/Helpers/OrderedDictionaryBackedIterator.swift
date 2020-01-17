/// Shared implementation for all of the `PyIterators` that iterate over type
/// that stores data in `OrderedDictionary` (dict, set, frozenset).
internal protocol OrderedDictionaryBackedIterator: PyObject {
  associatedtype Key: PyHashable
  associatedtype Value
  typealias Dict = OrderedDictionary<Key, Value>

  var index: Int { get set }
  var dict: Dict { get }
}

extension OrderedDictionaryBackedIterator {
  internal func iterShared() -> PyObject {
    return self
  }

  internal func nextShared() -> PyResult<Dict.Entry> {
    while self.index < self.dict.count {
      switch self.dict.entries[self.index] {
      case .entry(let e):
        // Increment index, so that the next iteration
        // does not return the same element
        self.index += 1
        return .value(e)
      case .deleted:
        self.index += 1
      }
    }

    return .error(Py.newStopIteration())
  }
}
