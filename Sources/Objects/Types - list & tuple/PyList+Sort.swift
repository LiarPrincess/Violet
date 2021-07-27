import BigInt
import VioletCore

// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// Python requires a stable sort, we are not that fancy.
extension PyList {

  internal func sort(key _key: PyObject?,
                     isReverse: PyObject?) -> PyResult<PyNone> {
    let key = PyCast.isNilOrNone(_key) ? nil : _key

    guard let isReverse = isReverse else {
      return self.sort(key: key, isReverse: false)
    }

    switch Py.isTrueBool(object: isReverse) {
    case let .value(b):
      return self.sort(key: key, isReverse: b)
    case let .error(e):
      return .error(e)
    }
  }

  private struct ElementWithKey {
    /// Sort key (result of calling `key` function on `self.element`).
    fileprivate let key: PyObject
    fileprivate let element: PyObject
  }

  /// Wrapper for `PyBaseException` so that it can be used with `throw`.
  private enum SortError: Error {
    case wrapper(PyBaseException)
  }

  internal func sort(key: PyObject?, isReverse: Bool) -> PyResult<PyNone> {
    // Make list is temporarily empty to detect any modifications made by 'key' fn.
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
    _ = self.elements = []

    // Cache keys (for a brief moment we will use 3*memory)
    var keyedElements = [ElementWithKey]()
    for object in copy {
      switch Py.selectKey(object: object, key: key) {
      case let .value(k):
        keyedElements.append(ElementWithKey(key: k, element: object))
      case let .error(e):
        self.elements = copy // Go back to elements before keys
        return .error(e)
      }
    }

    guard self.isEmpty else {
      self.elements = copy // Go back to elements before keys
      return .error(self.createListModifiedDuringSortError())
    }

    // On exit we will assign sorted elements to 'self.data'.
    // Even if sort fails we will assign partially sorted elements.
    // Also, we no longer need 'copy' (we moved data to 'keyedElements').
    defer { self.elements = keyedElements.map { $0.element } }
    copy = []

    do {
      // Reverse sort stability achieved by initially reversing the list,
      // applying a forward sort, then reversing the final result.
      //
      // Remember that the last declared 'defer' will run first!
      // So it will be:
      // 1. undo reversal
      // 2. assign to 'self.data.elements'
      if isReverse { keyedElements.reverse() }
      defer { if isReverse { keyedElements.reverse() } }

      // Note that Python requires STABLE sort, which Swift does not guarantee!
      // But we will conveniently ignore this fact… because reasons…
      // Btw. under certain conditions Swift sort is actually stable
      // (at the time of writing this comment), but that's an implementation detail.
      try keyedElements.sort(by: PyList.sortFn(lhs:rhs:))

      // Check if user tried to touch our list.
      // Remember that 'self.data' was set to []
      // (and it still should be empty because 'defer' did not run yet)!
      guard self.isEmpty else {
        return .error(self.createListModifiedDuringSortError())
      }

      return .value(Py.none)
    } catch let SortError.wrapper(e) {
      return .error(e)
    } catch {
      trap("Unexpected error type in PyList.sort: \(error)")
    }
  }

  private static func sortFn(lhs: ElementWithKey, rhs: ElementWithKey) throws -> Bool {
    switch Py.isLessBool(left: lhs.key, right: rhs.key) {
    case let .value(b): return b
    case let .error(e): throw SortError.wrapper(e)
    }
  }

  private func createListModifiedDuringSortError() -> PyBaseException {
    return Py.newValueError(msg: "list modified during sort")
  }
}
