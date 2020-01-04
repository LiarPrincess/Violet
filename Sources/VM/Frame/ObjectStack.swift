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

  internal var isEmpty: Bool { return self.elements.isEmpty }

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
    let last = self.elements.popLast()
    assert(last != nil, "Stack pop from empty stack.")
    return last! // swiftlint:disable:this force_unwrapping
  }

  /// Pop `count` elements and then reverse,
  /// so that first pushed element is in 1st position.
  internal mutating func popElementsInPushOrder(count elementCount: Int) -> [PyObject] {
    let count = self.elements.count
    assert(
      count >= elementCount,
      "Stack popElements out of bounds (pop: \(elementCount), count: \(count))."
    )

    let resultStart = count - elementCount
    let result = self.elements[resultStart...]

    self.elements.removeLast(elementCount)

    return Array(result.reversed())
  }
}
