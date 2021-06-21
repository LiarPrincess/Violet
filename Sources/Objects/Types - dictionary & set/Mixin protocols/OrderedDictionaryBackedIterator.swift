/// Shared implementation for all of the `PyIterators` that iterate over type
/// that stores data in `OrderedDictionary` (dict, set, frozenset).
internal protocol OrderedDictionaryBackedIterator: PyObject {
  associatedtype Key: PyHashable
  associatedtype Value
  typealias Dictionary = OrderedDictionary<Key, Value>

  var index: Int { get set }
  var dict: Dictionary { get }
}

extension OrderedDictionaryBackedIterator {

  internal func iterShared() -> PyObject {
    return self
  }

  internal func nextShared() -> PyResult<Dictionary.Entry> {
    while self.index < self.dict.entries.count {
      let entry = self.dict.entries[self.index]

      // Increment index NOW, so that the regardless of whether we return 'entry'
      // or iterate more we move to next element.
      self.index += 1

      switch entry {
      case .entry(let e):
        return .value(e)
      case .deleted:
        break // move to next element
      }
    }

    return .error(Py.newStopIteration())
  }

  internal func lengthHintShared() -> PyInt {
    let result = self.dict.count - self.index
    return Py.newInt(result)
  }
}
