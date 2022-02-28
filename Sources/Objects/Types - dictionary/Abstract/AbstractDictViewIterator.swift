/* MARKER
/// Mixin with methods for various `PyDict` iterators.
///
/// All of the methods/properties should be prefixed with `_`.
/// DO NOT use them outside of the dict iterator objects!
internal protocol AbstractDictViewIterator: PyObject {
  var dict: PyDict { get }
  var index: Int { get set }
  var initialCount: Int { get }
}

extension AbstractDictViewIterator {

  /// DO NOT USE! This is a part of `AbstractDictViewIterator` implementation.
  internal func _iter() -> PyObject {
    return self
  }

  /// DO NOT USE! This is a part of `AbstractDictViewIterator` implementation.
  internal func _next() -> PyResult<PyDict.OrderedDictionary.Entry> {
    let currentCount = self.dict.elements.count
    guard currentCount == self.initialCount else {
      self.index = -1 // Make this state sticky
      return .runtimeError("dictionary changed size during iteration")
    }

    let entries = self.dict.elements.entries
    while self.index < entries.count {
      let entry = entries[self.index]

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

  /// DO NOT USE! This is a part of `AbstractDictViewIterator` implementation.
  internal func _lengthHint() -> PyInt {
    let count = self.dict.elements.count
    let result = count - self.index
    return Py.newInt(result)
  }
}

*/