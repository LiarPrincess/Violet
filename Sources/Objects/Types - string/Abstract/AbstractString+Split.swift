// swiftlint:disable file_length

// MARK: - Collection extensions

extension Collection where Element: Equatable {
  fileprivate func formIndex(after index: inout Index,
                             untilItStartsWith value: Self) {
    while index != self.endIndex {
      let sub = self[index...]
      if sub.starts(with: value) {
        return
      }

      self.formIndex(after: &index)
    }
  }

  fileprivate func formIndex(after index: inout Index,
                             while predicate: (Element) -> Bool) {
    while index != self.endIndex {
      let element = self[index]
      switch predicate(element) {
      case true:
        self.formIndex(after: &index)
      case false:
        return
      }
    }
  }
}

extension BidirectionalCollection where Element: Equatable {
  internal func formIndex(before index: inout Index,
                          untilItStartsWith value: Self) {
    while index != self.startIndex {
      let sub = self[index...]
      if sub.starts(with: value) {
        return
      }

      self.formIndex(before: &index)
    }
  }

  internal func formIndex(before index: inout Index,
                          while predicate: (Element) -> Bool) {
    while index != self.startIndex {
      let element = self[index]
      switch predicate(element) {
      case true:
        self.formIndex(before: &index)
      case false:
        return
      }
    }
  }
}

// MARK: - SplitResultBuilder

private struct SplitResultBuilder<S: AbstractString> {

  fileprivate var elements = [S.SwiftType]()

  fileprivate mutating func append(group: S.Elements) {
    let object = S._toObject(elements: group)
    self.elements.append(object)
  }

  fileprivate mutating func append(group: S.Elements.SubSequence) {
    let object = S._toObject(elements: group)
    self.elements.append(object)
  }
}

// MARK: - Separator

private enum SplitSeparator<T> {
  case whitespace
  case some(T)
  case error(PyBaseException)
}

// MARK: - Arguments

private let splitArguments = ArgumentParser.createOrTrap(
  arguments: ["sep", "maxsplit"],
  format: "|OO:split"
)

extension AbstractString {

  // MARK: - Split

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _split(args: [PyObject],
                       kwargs: PyDict?) -> PyResult<PyList> {
    return self._template(args: args,
                          kwargs: kwargs,
                          onWhitespaceSplit: self._splitWhitespace(maxCount:),
                          onSeparatorSplit: self._split(separator:maxCount:))
  }

  private func _split(separator: Elements, maxCount: Int) -> [SwiftType] {
    var result = SplitResultBuilder<Self>()
    var index = self.elements.startIndex

    self._wouldBeBetterWithRandomAccessCollection()
    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      let groupStart = index
      self.elements.formIndex(after: &index, untilItStartsWith: separator)

      // 'index' is either at the start of the 'separator' or 'end index'
      let group = self.elements[groupStart..<index]
      result.append(group: group)

      if index == self.elements.endIndex {
        return result.elements
      }

      // Move index after 'separator'
      index = self.elements.index(index, offsetBy: separator.count)
    }

    let hasSomeStringLeft = index != self.elements.endIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      let lastGroup = self.elements[index...]
      result.append(group: lastGroup)
    }

    return result.elements
  }

  private func _splitWhitespace(maxCount: Int) -> [SwiftType] {
    var result = SplitResultBuilder<Self>()
    var index = self.elements.startIndex

    var remainingCount = maxCount
    self._wouldBeBetterWithRandomAccessCollection()
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      self.elements.formIndex(after: &index, while: Self._isWhitespace(element:))

      // 'index' is either at the start of the group or 'end index'
      if index == self.elements.endIndex {
        return result.elements
      }

      let groupStart = index
      self.elements.formIndex(after: &index, while: Self._isNotWhitespace(element:))

      // 'index' is either 'whitespace' or 'end index'
      let group = self.elements[groupStart..<index]
      result.append(group: group)
    }

    let hasSomeStringLeft = index != self.elements.endIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      self.elements.formIndex(after: &index, while: Self._isWhitespace(element:))

      // 'a b cd     '.split() -> ['a', 'b', 'cd']
      if index != self.elements.endIndex {
        let lastGroup = self.elements[index...]
        result.append(group: lastGroup)
      }
    }

    return result.elements
  }

  private static func _isNotWhitespace(element: Element) -> Bool {
    return !Self._isWhitespace(element: element)
  }

  // MARK: - RSplit

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _rsplit(args: [PyObject],
                        kwargs: PyDict?) -> PyResult<PyList> {
    return self._template(args: args,
                          kwargs: kwargs,
                          onWhitespaceSplit: self._rsplitWhitespace(maxCount:),
                          onSeparatorSplit: self._rsplit(separator:maxCount:))
  }

  // swiftlint:disable:next function_body_length
  private func _rsplit(separator: Elements, maxCount: Int) -> [SwiftType] {
    var result = SplitResultBuilder<Self>()
    var index = self.elements.endIndex

    // `endIndex` is AFTER the collection
    self.elements.formIndex(before: &index)

    var remainingCount = maxCount
    self._wouldBeBetterWithRandomAccessCollection()
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      let groupEnd = index // Include character at this index!
      self.elements.formIndex(before: &index, untilItStartsWith: separator)
      // At this point 'index' is 1st character of 'separator' or start of the string
      // (it may be both at the same time!).

      // Arrived at the front - add group and break
      if index == self.elements.startIndex {
        let startsWithSeparator = self.elements[index...].starts(with: separator)

        if startsWithSeparator {
          let groupStart = self.elements.index(index, offsetBy: separator.count)
          let group = self.elements[groupStart...groupEnd]
          result.append(group: group)

          // If 'self' starts with separator then we need to append empty
          // >>> 'abca'.split('a') -> ['', 'bc', '']
          let emptyGroup = self.elements[self.elements.startIndex..<self.elements.startIndex]
          result.append(group: emptyGroup)
        } else {
          let group = self.elements[self.elements.startIndex...groupEnd]
          result.append(group: group)
        }

        break
      }

      // We are in the middle - index is 1st character of separator
      let groupStart = self.elements.index(index, offsetBy: separator.count)

      // Group may be empty when:
      // - self has 'separator' as suffix
      // - we have multiple separators in a row
      let isGroupEmpty = groupStart > groupEnd
      let group = isGroupEmpty ?
        self.elements[groupStart..<groupStart] :
        self.elements[groupStart...groupEnd]

      result.append(group: group)

      // Move our index, so that it points to last character of next group
      self.elements.formIndex(before: &index)
    }

    let hasSomeStringLeft = index != self.elements.startIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      let lastGroup = self.elements[self.elements.startIndex...index]
      result.append(group: lastGroup)
    }

    // Because we were going from end we appended in a reverse order.
    // Now reverse this reverse to get correct order.
    // Random thought: 'reverse' is idempotent if you always apply it twice
    // (and it has not side-effects).
    return result.elements.reversed()
  }

  private func _rsplitWhitespace(maxCount: Int) -> [SwiftType] {
    var result = SplitResultBuilder<Self>()
    var index = self.elements.endIndex

    // `endIndex` is AFTER the collection
    self.elements.formIndex(before: &index)

    var remainingCount = maxCount
    self._wouldBeBetterWithRandomAccessCollection()
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      self.elements.formIndex(before: &index, while: Self._isWhitespace(element:))

      // If we arrived at the start and we are still whitespace -> no more groups
      // >>> '     a b cd'.rsplit() -> ['a', 'b', 'cd']
      if index == self.elements.startIndex && Self._isWhitespace(element: self.elements[index]) {
        break
      }

      // Consume group
      let groupEnd = index // Include character at this index!
      self.elements.formIndex(before: &index, while: Self._isNotWhitespace(element:))
      // At this point 'index' is 1st non-whitespace or 'start index'
      // (it may be both at the same time!).

      // Arrived at front - add group and break
      if index == self.elements.startIndex {
        let isFirstWhitespace = Self._isWhitespace(element: self.elements[index])
        let groupStart = isFirstWhitespace ?
          self.elements.index(after: index) :
          index

        let group = self.elements[groupStart...groupEnd]
        result.append(group: group)
        break
      }

      // We are in the middle - index is 1st whitespace, group starts after it
      let groupStart = self.elements.index(after: index)
      let group = self.elements[groupStart...groupEnd]
      result.append(group: group)
    }

    let hasSomeStringLeft = index != self.elements.startIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      self.elements.formIndex(before: &index, while: Self._isWhitespace(element:))
      let lastGroup = self.elements[...index]
      result.append(group: lastGroup)
    }

    // See comment in 'self._rsplit', why we need to reverse
    return result.elements.reversed()
  }

  // MARK: - Template

  private func _template(
    args: [PyObject],
    kwargs: PyDict?,
    onWhitespaceSplit: (Int) -> [SwiftType],
    onSeparatorSplit: (Elements, Int) -> [SwiftType]
  ) -> PyResult<PyList> {
    switch splitArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let sep = binding.optional(at: 0)
      let maxCount = binding.optional(at: 1)
      return self._template(separator: sep,
                            maxCount: maxCount,
                            onWhitespaceSplit: onWhitespaceSplit,
                            onSeparatorSplit: onSeparatorSplit)
    case let .error(e):
      return .error(e)
    }
  }

  private func _template(
    separator separatorObject: PyObject?,
    maxCount maxCountObject: PyObject?,
    onWhitespaceSplit: (Int) -> [SwiftType],
    onSeparatorSplit: (Elements, Int) -> [SwiftType]
  ) -> PyResult<PyList> {
    var count: Int
    switch self._parseMaxCount(maxCount: maxCountObject) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    switch self._parseSeparator(separator: separatorObject) {
    case .whitespace:
      let result = onWhitespaceSplit(count)
      let list = Py.newList(elements: result)
      return .value(list)
    case .some(let separator):
      let result: [PyObject]
      let separatorIsLongerThanUs = self.count < separator.count

      // This 'switch' is overkill, but it makes it easier to debug
      // (we can just 'n', without checking the value of 'separatorIsLongerThanUs').
      switch separatorIsLongerThanUs {
      case true: result = [self]
      case false: result = onSeparatorSplit(separator, count)
      }

      let list = Py.newList(elements: result)
      return .value(list)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Separator

  private func _parseMaxCount(maxCount object: PyObject?) -> PyResult<Int> {
    guard let object = object else {
      return .value(Int.max)
    }

    guard let pyInt = PyCast.asInt(object) else {
      return .typeError("maxsplit must be int, not \(object.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("maxsplit is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }

  private func _parseSeparator(separator object: PyObject?) -> SplitSeparator<Elements> {
    guard let object = object else {
      return .whitespace
    }

    if object.isNone {
      return .whitespace
    }

    guard let sep = Self._getElements(object: object) else {
      let msg = "sep must be \(Self._pythonTypeName) or None, not \(object.typeName)"
      return .error(Py.newTypeError(msg: msg))
    }

    if sep.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    return .some(sep)
  }
}
