import BigInt
import VioletCore

// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// Python requires a stable sort, we are not that fancy.
extension PyList {

  internal func sort(_ py: Py, key: PyObject?, isReverse: PyObject?) -> PyResult {
    let key = py.cast.isNilOrNone(key) ? nil : key

    guard let isReverse = isReverse else {
      return self.sort(py, key: key, isReverse: false)
    }

    switch py.isTrueBool(object: isReverse) {
    case let .value(b):
      return self.sort(py, key: key, isReverse: b)
    case let .error(e):
      return .error(e)
    }
  }

  internal func sort(_ py: Py, key: PyObject?, isReverse: Bool) -> PyResult {
    // Make list temporarily empty to detect any modifications made by 'key' fn.
    // CPython does the same:
    // >>> l = [1, 2, 3]
    // >>> def get_key(e):
    // ...   print(l)
    // ...   return e
    // ...
    // >>> l.sort(key=get_key)
    // []
    // []
    // []
    var copy = self.elements
    self.elementsPtr.pointee = []

    // Cache keys (for a brief moment we will use 3*memory).
    var keyedElements: [ElementWithKey]
    switch Self.apply(py, elements: copy, keyFn: key) {
    case let .value(k):
      keyedElements = k
    case let .error(e):
      self.elementsPtr.pointee = copy // Go back to elements before keys.
      return .error(e)
    }

    let hasAddedElementsDuringKey = !self.isEmpty
    if hasAddedElementsDuringKey {
      self.elementsPtr.pointee = copy // Go back to elements before keys.
      let error = Self.createListModifiedDuringSortError(py)
      return .error(error)
    }

    // We no longer need 'copy' since we moved the data to 'keyedElements'.
    copy = []

    let sortError = Self.sort(py, elements: &keyedElements, isReverse: isReverse)
    let hasAddedElementsDuringSort = !self.isEmpty

    // Even if the sort fails we will assign partially sorted elements.
    self.elementsPtr.pointee = keyedElements.map { $0.element }

    if let e = sortError {
      return .error(e)
    }

    if hasAddedElementsDuringSort {
      let error = Self.createListModifiedDuringSortError(py)
      return .error(error)
    }

    return .none(py)
  }

  // MARK: - Actual sort

  private struct ElementWithKey {
    /// Sort key (result of calling `key` function on `self.element`).
    fileprivate let key: PyObject
    fileprivate let element: PyObject
  }

  /// Wrapper for `PyBaseException` so that it can be used with `throw`.
  private enum SortError: Error {
    case wrapper(PyBaseException)
  }

  // 'static' to make sure we dont touch 'self.elements'
  private static func sort(_ py: Py,
                           elements: inout [ElementWithKey],
                           isReverse: Bool) -> PyBaseException? {
    do {
      // Reverse sort stability achieved by initially reversing the list,
      // applying a forward sort, then reversing the final result.
      if isReverse { elements.reverse() }
      defer { if isReverse { elements.reverse() } }

      // Note that Python requires STABLE sort, which Swift does not guarantee!
      // But we will conveniently ignore this fact… because reasons…
      // Btw. under certain conditions Swift sort is actually stable
      // (at the time of writing this comment), but that's an implementation detail.
      try elements.sort { (lhs: ElementWithKey, rhs: ElementWithKey) throws -> Bool in
        switch py.isLessBool(left: lhs.key, right: rhs.key) {
        case let .value(b): return b
        case let .error(e): throw SortError.wrapper(e)
        }
      }

      return nil
    } catch let SortError.wrapper(e) {
      return e
    } catch {
      trap("Unexpected error type in PyList.sort: \(error)")
    }
  }

  // MARK: - Key

  // 'static' to make sure we dont touch 'self.elements'
  private static func apply(_ py: Py,
                            elements: [PyObject],
                            keyFn: PyObject?) -> PyResultGen<[ElementWithKey]> {
    var result = [ElementWithKey]()
    result.reserveCapacity(elements.count)

    for element in elements {
      switch py.selectKey(object: element, key: keyFn) {
      case let .value(key):
        let withKey = ElementWithKey(key: key, element: element)
        result.append(withKey)

      case let .error(e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Modification during

  private static func createListModifiedDuringSortError(_ py: Py) -> PyBaseException {
    let error = py.newValueError(message: "list modified during sort")
    return error.asBaseException
  }
}
