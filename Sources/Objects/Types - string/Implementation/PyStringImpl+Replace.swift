
// MARK: - Replace

extension PyStringImpl {

  internal func replace(old: PyObject,
                        new: PyObject,
                        count: PyObject?) -> PyResult<Builder.Result> {
    let oldString: Self
    switch Self.extractSelf(from: old) {
    case .value(let s):
      oldString = s
    case .notSelf:
      return .typeError("old must be \(Self.typeName), not \(old.typeName)")
    case .error(let e):
      return .error(e)
    }

    let newString: Self
    switch Self.extractSelf(from: new) {
    case .value(let s):
      newString = s
    case .notSelf:
      return .typeError("new must be \(Self.typeName), not \(old.typeName)")
    case .error(let e):
      return .error(e)
    }

    var parsedCount: Int
    switch self.parseReplaceCount(count) {
    case let .value(c): parsedCount = c
    case let .error(e): return .error(e)
    }

    let result = self.replace(old: oldString, new: newString, count: parsedCount)
    return .value(result)
  }

  private func replace(old: Self, new: Self, count: Int) -> Builder.Result {
    var builder = Builder()

    // swiftlint:disable:next empty_count
    guard count != 0 else {
      builder.append(contentsOf: self[self.startIndex...])
      return builder.result
    }

    var index = self.startIndex
    var remainingCount = count

    while index != self.endIndex {
      let s = self[index...]
      guard s.starts(with: old.scalars) else {
        builder.append(self[index])
        self.formIndex(after: &index)
        continue
      }

      builder.append(contentsOf: new.scalars)
      index = self.index(index, offsetBy: old.count)

      remainingCount -= 1
      if remainingCount <= 0 {
        builder.append(contentsOf: self[index...])
        break
      }
    }

    return builder.result
  }

  private func parseReplaceCount(_ count: PyObject?) -> PyResult<Int> {
    guard let count = count else {
      return .value(Int.max)
    }

    guard let pyInt = PyCast.asInt(count) else {
      return .typeError("count must be int, not \(count.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("count is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }
}
