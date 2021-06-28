// MARK: - Split

// swiftlint:disable file_length

/// Parser for 'split' method.
private let splitArguments = ArgumentParser.createOrTrap(
  arguments: ["sep", "maxsplit"],
  format: "|OO:split"
)

private enum SplitSeparator<T> {
  case whitespace
  case some(T)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func split(args: [PyObject],
                      kwargs: PyDict?) -> PyResult<[SubSequence]> {
    switch splitArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let sep = binding.optional(at: 0)
      let maxCount = binding.optional(at: 1)
      return self.split(separator: sep, maxCount: maxCount)
    case let .error(e):
      return .error(e)
    }
  }

  internal func split(separator: PyObject?,
                      maxCount: PyObject?) -> PyResult<[SubSequence]> {
    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    switch self.parseSplitSeparator(separator) {
    case .whitespace:
      return .value(self.splitWhitespace(maxCount: count))
    case .some(let s):
      return .value(self.split(separator: s, maxCount: count))
    case .error(let e):
      return .error(e)
    }
  }

  internal func split(separator: Self, maxCount: Int) -> [SubSequence] {
    if self.count < separator.count {
      return [self.asSubSequence]
    }

    var result = [SubSequence]()
    var index = self.startIndex

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Advance index until the end of the group
      let groupStart = index
      self.formIndex(after: &index) { !self[$0...].starts(with: separator.scalars) }

      result.append(self[groupStart..<index])

      if index == self.endIndex {
        return result
      }

      // Move index after `sep`
      index = self.index(index, offsetBy: separator.count)
    }

    if index != self.endIndex && remainingCount == 0 {
      result.append(self[index...])
    }

    return result
  }

  internal func splitWhitespace(maxCount: Int) -> [SubSequence] {
    var result = [SubSequence]()
    var index = self.startIndex

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      self.formIndex(after: &index) { Self.isWhitespace(self[$0]) }

      if index == self.endIndex {
        return result
      }

      // Consume group
      let groupStart = index
      self.formIndex(after: &index) { !Self.isWhitespace(self[$0]) }

      let s = self[groupStart..<index]
      result.append(s)
    }

    if index != self.endIndex && remainingCount == 0 {
      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      self.formIndex(after: &index) { Self.isWhitespace(self[$0]) }

      if index != self.endIndex {
        result.append(self[index...])
      }
    }

    return result
  }

  // MARK: - RSplit

  internal func rsplit(args: [PyObject],
                       kwargs: PyDict?) -> PyResult<[SubSequence]> {
    switch splitArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let sep = binding.optional(at: 0)
      let maxCount = binding.optional(at: 1)
      return self.rsplit(separator: sep, maxCount: maxCount)
    case let .error(e):
      return .error(e)
    }
  }

  internal func rsplit(separator: PyObject?,
                       maxCount: PyObject?) -> PyResult<[SubSequence]> {
    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    switch self.parseSplitSeparator(separator) {
    case .whitespace:
      return .value(self.rsplitWhitespace(maxCount: count))
    case .some(let s):
      return .value(self.rsplit(separator: s, maxCount: count))
    case .error(let e):
      return .error(e)
    }
  }

  internal func rsplit(separator: Self, maxCount: Int) -> [SubSequence] {
    if self.count < separator.count {
      return [self.asSubSequence]
    }

    var result = [SubSequence]()
    var index = scalars.endIndex

    // `endIndex` is AFTER the collection
    self.formIndex(before: &index)

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      let groupEnd = index // Include character at this index!
      self.formIndex(before: &index) { !self[$0...].starts(with: separator.scalars) }
      // At this point 'index' is 1st character of 'separator' or start of the string
      // (it may be bot at the same time!).

      // Arrived at front - add group and break
      if index == self.startIndex {
        let startsWithSeparator = self[index...].starts(with: separator.scalars)

        if startsWithSeparator {
          let groupStart = self.index(index, offsetBy: separator.count)
          result.append(self[groupStart...groupEnd])

          // If 'self' starts with separator then we need to append empty
          result.append(self[self.startIndex..<self.startIndex])
        } else {
          result.append(self[self.startIndex...groupEnd])
        }

        break
      }

      // We are in the middle - index is 1st character of separator
      let groupStart = self.index(index, offsetBy: separator.count)

      // Group may be empty when:
      // - self has 'separator' as suffix
      // - we have multiple separators in a row
      let isGroupEmpty = groupStart > groupEnd
      if isGroupEmpty {
        result.append(self[groupStart..<groupStart])
      } else {
        result.append(self[groupStart...groupEnd])
      }

      // Move our index, so that it points to last character of next group
      self.formIndex(before: &index)
    }

    if index != self.startIndex && remainingCount == 0 {
      result.append(self[self.startIndex...index])
    }

    // Because we were going from end we appended in a reverse order.
    // Now reverse this reverse to get correct order.
    // Random thought: 'reverse' is idempotent if you always apply it twice
    // (and it has not side-effects).
    result.reverse()
    return result
  }

  internal func rsplitWhitespace(maxCount: Int) -> [SubSequence] {
    var result = [SubSequence]()
    var index = self.endIndex

    // `endIndex` is AFTER the collection
    self.formIndex(before: &index)

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      self.formIndex(before: &index) { Self.isWhitespace(self[$0]) }

      // If we arrived at the start and we are still whitespace - no more groups
      if index == self.startIndex && Self.isWhitespace(self[index]) {
        break
      }

      // Consume group
      let groupEnd = index // Include character at this index!
      self.formIndex(before: &index) { !Self.isWhitespace(self[$0]) }
      // At this point 'index' is 1st non-whitespace or start of the string
      // (it may be bot at the same time!).

      // Arrived at front - add group and break
      if index == self.startIndex {
        let isFirstWhitespace = Self.isWhitespace(self[index])
        let groupStart = isFirstWhitespace ?
          self.index(after: index) :
          index

        let part = self[groupStart...groupEnd]
        result.append(part)
        break
      }

      // We are in the middle - index is 1st whitespace, group starts after it
      let groupStart = self.index(after: index)
      let part = self[groupStart...groupEnd]
      result.append(part)
    }

    if index != self.startIndex && remainingCount == 0 {
      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      self.formIndex(before: &index) { Self.isWhitespace(self[$0]) }
      result.append(self[...index])
    }

    // See comment in 'self.rsplit', why we need to reverse
    result.reverse()
    return result
  }

  // `SubSequence` that contains the whole string
  private var asSubSequence: SubSequence {
    return self[self.startIndex...]
  }

  private func parseSplitSeparator(_ separator: PyObject?) -> SplitSeparator<Self> {
    guard let separator = separator else {
      return .whitespace
    }

    if separator is PyNone {
      return .whitespace
    }

    switch Self.extractSelf(from: separator) {
    case .value(let sep):
      if sep.scalars.isEmpty {
        return .error(Py.newValueError(msg: "empty separator"))
      }

      return .some(sep)

    case .notSelf:
      let msg = "sep must be \(Self.typeName) or None, not \(separator.typeName)"
      return .error(Py.newTypeError(msg: msg))
    case .error(let e):
      return .error(e)
    }
  }

  private func parseSplitMaxCount(_ maxCount: PyObject?) -> PyResult<Int> {
    guard let maxCount = maxCount else {
      return .value(Int.max)
    }

    guard let pyInt = PyCast.asInt(maxCount) else {
      return .typeError("maxsplit must be int, not \(maxCount.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("maxsplit is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }
}

// MARK: - Split lines

private let splitLinesArguments = ArgumentParser.createOrTrap(
  arguments: ["keepends"],
  format: "|O:splitlines"
)

extension PyStringImpl {
/*
  internal func splitLines(args: [PyObject],
                           kwargs: PyDict?) -> PyResult<[SubSequence]> {
    switch splitLinesArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let keepEnds = binding.optional(at: 0)
      return self.splitLines(keepEnds: keepEnds)
    case let .error(e):
      return .error(e)
    }
  }

  internal func splitLines(keepEnds: PyObject?) -> PyResult<[SubSequence]> {
    guard let keepEnds = keepEnds else {
      return .value(self.splitLines(keepEnds: false))
    }

    // `bool` is also `int`
    if let int = PyCast.asInt(keepEnds) {
      let isTrue = int.value.isTrue
      return .value(self.splitLines(keepEnds: isTrue))
    }

    return .typeError("keepends must be integer or bool, not \(keepEnds.typeName)")
  }

  internal func splitLines(keepEnds: Bool) -> [SubSequence] {
    var result = [SubSequence]()
    var index = self.startIndex

    while index != self.endIndex {
      let groupStart = index

      // Advance 'till line break
      self.formIndex(after: &index) { !Self.isLineBreak(self[$0]) }

      // 'index' is either new line or 'endIndex'
      let lineExcludingNewLine = groupStart..<index

      // Consume CRLF as one line break
      if index != self.endIndex {
        let after = self.index(after: index)
        if after != self.endIndex
          && Self.toUnicodeScalar(self[index]) == "\r"
          && Self.toUnicodeScalar(self[after]) == "\n" {

          index = after
        }
      }

      // Go to the start of the next group
      if index != self.endIndex {
        self.formIndex(after: &index)
      }

      // 'index' is either 1st character of next group or end
      let lineIncludingNewLine = groupStart..<index

      let line = keepEnds ? lineIncludingNewLine : lineExcludingNewLine
      result.append(self[line])
    }

    return result
  }
*/
}
