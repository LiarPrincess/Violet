import Objects

internal struct ObjectStack {

  private var elements = [PyObject]()

  internal var top: PyObject {
    get { return self.peek(1) }
    set { self.set(1, to: newValue) }
  }

  internal var second: PyObject {
    get { return self.peek(2) }
    set { self.set(2, to: newValue) }
  }

  internal var third: PyObject {
    get { return self.peek(3) }
    set { self.set(3, to: newValue) }
  }

  internal var fourth: PyObject {
    get { return self.peek(4) }
    set { self.set(4, to: newValue) }
  }

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
    return self.elements.count
  }

  // MARK: - Peek

  internal func peek(_ n: Int) -> PyObject {
    let count = self.elements.count
    assert(count >= n, "Stack peek out of bounds (peek: \(n), count: \(count)).")
    return self.elements[count - n]
  }

  // MARK: - Set

  internal mutating func set(_ n: Int, to value: PyObject) {
    let count = self.elements.count
    assert(count >= n, "Stack set out of bounds (set: \(n), count: \(count)).")
    self.elements[count - n] = value
  }

  // MARK: - Push

  internal mutating func push(_ value: PyObject) {
    self.elements.push(value)
  }

  // MARK: - Pop

  internal mutating func pop() -> PyObject {
    // Using 'isEmpty' or 'count' for assert would require another type lookup.
    // (only in DEBUG and it depends on inling, but still...)

    let last = self.elements.popLast()
    assert(last != nil, "Stack pop from empty stack.")
    return last! // swiftlint:disable:this force_unwrapping
  }

  /// Pop `count` elements and then reverse,
  /// so that first pushed element is at `0` index.
  ///
  /// - Note:
  /// Actual implementation is faster and does not require reversal.
  internal mutating func popElementsInPushOrder(count requestedCount: Int) -> [PyObject] {
    // Fast check to avoid allocation.
    if requestedCount == 0 {
      return []
    }

    let count = self.elements.count
    assert(
      count >= requestedCount,
      "Stack popElements out of bounds (pop: \(requestedCount), count: \(count))."
    )

    // Use 'Array.init' on slice before'removeLast'!
    // Otherwise COW would copy whole array on 'removeLast'
    // (because slice still has reference to it).
    let resultStart = count - requestedCount
    let result = Array(self.elements[resultStart...])

    self.elements.removeLast(requestedCount)

    return result
  }

  /// Pop elements untill we reach `untilCount`.
  internal mutating func pop(untilCount: Int) {
    assert(self.elements.count >= untilCount)

    // Avoid allocation when we have correct size
    if self.elements.count != untilCount {
      self.elements = Array(self.elements[0..<untilCount])
    }

    assert(self.elements.count == untilCount)
  }
}
