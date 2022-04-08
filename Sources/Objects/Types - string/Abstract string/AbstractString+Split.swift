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

  fileprivate var elements = [PyObject]()

  fileprivate mutating func append(_ py: Py, group: S.Elements) {
    let object = S.newObject(py, elements: group)
    self.elements.append(object.asObject)
  }

  fileprivate mutating func append(_ py: Py, group: S.Elements.SubSequence) {
    let object = S.newObject(py, elements: group)
    self.elements.append(object.asObject)
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

  internal static func abstractSplit(_ py: Py,
                                     zelf: PyObject,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult {
    return Self.template(py,
                         zelf: zelf,
                         args: args,
                         kwargs: kwargs,
                         fnName: "split",
                         onWhitespaceSplit: Self.splitWhitespace(_:zelf:maxCount:),
                         onSeparatorSplit: Self.split(_:zelf:separator:maxCount:))
  }

  private static func split(_ py: Py,
                            zelf: Self,
                            separator: Elements,
                            maxCount: Int) -> [PyObject] {
    var result = SplitResultBuilder<Self>()
    var index = zelf.elements.startIndex

    Self.wouldBeBetterWithRandomAccessCollection()
    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      let groupStart = index
      zelf.elements.formIndex(after: &index, untilItStartsWith: separator)

      // 'index' is either at the start of the 'separator' or 'end index'
      let group = zelf.elements[groupStart..<index]
      result.append(py, group: group)

      if index == zelf.elements.endIndex {
        return result.elements
      }

      // Move index after 'separator'
      index = zelf.elements.index(index, offsetBy: separator.count)
    }

    let hasSomeStringLeft = index != zelf.elements.endIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      let lastGroup = zelf.elements[index...]
      result.append(py, group: lastGroup)
    }

    return result.elements
  }

  private static func splitWhitespace(_ py: Py,
                                      zelf: Self,
                                      maxCount: Int) -> [PyObject] {
    var result = SplitResultBuilder<Self>()
    var index = zelf.elements.startIndex

    var remainingCount = maxCount
    Self.wouldBeBetterWithRandomAccessCollection()
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      zelf.elements.formIndex(after: &index, while: Self.isWhitespace(element:))

      // 'index' is either at the start of the group or 'end index'
      if index == zelf.elements.endIndex {
        return result.elements
      }

      let groupStart = index
      zelf.elements.formIndex(after: &index, while: Self.isNotWhitespace(element:))

      // 'index' is either 'whitespace' or 'end index'
      let group = zelf.elements[groupStart..<index]
      result.append(py, group: group)
    }

    let hasSomeStringLeft = index != zelf.elements.endIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      zelf.elements.formIndex(after: &index, while: Self.isWhitespace(element:))

      // 'a b cd     '.split() -> ['a', 'b', 'cd']
      if index != zelf.elements.endIndex {
        let lastGroup = zelf.elements[index...]
        result.append(py, group: lastGroup)
      }
    }

    return result.elements
  }

  private static func isNotWhitespace(element: Element) -> Bool {
    return !Self.isWhitespace(element: element)
  }

  // MARK: - RSplit

  internal static func abstractRSplit(_ py: Py,
                                      zelf: PyObject,
                                      args: [PyObject],
                                      kwargs: PyDict?) -> PyResult {
    return Self.template(py,
                         zelf: zelf,
                         args: args,
                         kwargs: kwargs,
                         fnName: "rsplit",
                         onWhitespaceSplit: Self.rsplitWhitespace(_:zelf:maxCount:),
                         onSeparatorSplit: Self.rsplit(_:zelf:separator:maxCount:))
  }

  private static func rsplit(_ py: Py,
                             zelf: Self,
                             separator: Elements,
                             maxCount: Int) -> [PyObject] {
    var result = SplitResultBuilder<Self>()
    var index = zelf.elements.endIndex

    // `endIndex` is AFTER the collection
    zelf.elements.formIndex(before: &index)

    var remainingCount = maxCount
    Self.wouldBeBetterWithRandomAccessCollection()
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      let groupEnd = index // Include character at this index!
      zelf.elements.formIndex(before: &index, untilItStartsWith: separator)
      // At this point 'index' is 1st character of 'separator' or start of the string
      // (it may be both at the same time!).

      // Arrived at the front - add group and break
      if index == zelf.elements.startIndex {
        let startsWithSeparator = zelf.elements[index...].starts(with: separator)

        if startsWithSeparator {
          let groupStart = zelf.elements.index(index, offsetBy: separator.count)
          let group = zelf.elements[groupStart...groupEnd]
          result.append(py, group: group)

          // If 'self' starts with separator then we need to append empty
          // >>> 'abca'.split('a') -> ['', 'bc', '']
          let emptyGroup = zelf.elements[zelf.elements.startIndex..<zelf.elements.startIndex]
          result.append(py, group: emptyGroup)
        } else {
          let group = zelf.elements[zelf.elements.startIndex...groupEnd]
          result.append(py, group: group)
        }

        break
      }

      // We are in the middle - index is 1st character of separator
      let groupStart = zelf.elements.index(index, offsetBy: separator.count)

      // Group may be empty when:
      // - self has 'separator' as suffix
      // - we have multiple separators in a row
      let isGroupEmpty = groupStart > groupEnd
      let group = isGroupEmpty ?
        zelf.elements[groupStart..<groupStart] :
        zelf.elements[groupStart...groupEnd]

      result.append(py, group: group)

      // Move our index, so that it points to last character of next group
      zelf.elements.formIndex(before: &index)
    }

    let hasSomeStringLeft = index != zelf.elements.startIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      let lastGroup = zelf.elements[zelf.elements.startIndex...index]
      result.append(py, group: lastGroup)
    }

    // Because we were going from end we appended in a reverse order.
    // Now reverse this reverse to get correct order.
    // Random thought: 'reverse' is idempotent if you always apply it twice
    // (and it has not side-effects).
    return result.elements.reversed()
  }

  private static func rsplitWhitespace(_ py: Py,
                                       zelf: Self,
                                       maxCount: Int) -> [PyObject] {
    var result = SplitResultBuilder<Self>()
    var index = zelf.elements.endIndex

    // `endIndex` is AFTER the collection
    zelf.elements.formIndex(before: &index)

    var remainingCount = maxCount
    Self.wouldBeBetterWithRandomAccessCollection()
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      zelf.elements.formIndex(before: &index, while: Self.isWhitespace(element:))

      // If we arrived at the start and we are still whitespace -> no more groups
      // >>> '     a b cd'.rsplit() -> ['a', 'b', 'cd']
      if index == zelf.elements.startIndex && Self.isWhitespace(element: zelf.elements[index]) {
        break
      }

      // Consume group
      let groupEnd = index // Include character at this index!
      zelf.elements.formIndex(before: &index, while: Self.isNotWhitespace(element:))
      // At this point 'index' is 1st non-whitespace or 'start index'
      // (it may be both at the same time!).

      // Arrived at front - add group and break
      if index == zelf.elements.startIndex {
        let isFirstWhitespace = Self.isWhitespace(element: zelf.elements[index])
        let groupStart = isFirstWhitespace ?
          zelf.elements.index(after: index) :
          index

        let group = zelf.elements[groupStart...groupEnd]
        result.append(py, group: group)
        break
      }

      // We are in the middle - index is 1st whitespace, group starts after it
      let groupStart = zelf.elements.index(after: index)
      let group = zelf.elements[groupStart...groupEnd]
      result.append(py, group: group)
    }

    let hasSomeStringLeft = index != zelf.elements.startIndex
    let consumedAllCounts = remainingCount == 0
    if hasSomeStringLeft && consumedAllCounts {
      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      zelf.elements.formIndex(before: &index, while: Self.isWhitespace(element:))
      let lastGroup = zelf.elements[...index]
      result.append(py, group: lastGroup)
    }

    // See comment in 'self._rsplit', why we need to reverse
    return result.elements.reversed()
  }

  // MARK: - Template

  // swiftlint:disable:next function_parameter_count
  private static func template(
    _ py: Py,
    zelf _zelf: PyObject,
    args: [PyObject],
    kwargs: PyDict?,
    fnName: String,
    onWhitespaceSplit: (Py, Self, Int) -> [PyObject],
    onSeparatorSplit: (Py, Self, Elements, Int) -> [PyObject]
  ) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    switch splitArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let sep = binding.optional(at: 0)
      let maxCount = binding.optional(at: 1)
      return Self.template(py,
                           zelf: zelf,
                           separator: sep,
                           maxCount: maxCount,
                           onWhitespaceSplit: onWhitespaceSplit,
                           onSeparatorSplit: onSeparatorSplit)
    case let .error(e):
      return .error(e)
    }
  }

  // swiftlint:disable:next function_parameter_count
  private static func template(
    _ py: Py,
    zelf: Self,
    separator separatorObject: PyObject?,
    maxCount maxCountObject: PyObject?,
    onWhitespaceSplit: (Py, Self, Int) -> [PyObject],
    onSeparatorSplit: (Py, Self, Elements, Int) -> [PyObject]
  ) -> PyResult {
    var count: Int
    switch Self.parseMaxCount(py, object: maxCountObject) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    switch Self.parseSeparator(py, object: separatorObject) {
    case .whitespace:
      let result = onWhitespaceSplit(py, zelf, count)
      let list = py.newList(elements: result)
      return PyResult(list)

    case .some(let separator):
      let result: [PyObject]
      let separatorIsLongerThanUs = zelf.count < separator.count

      // This 'switch' is overkill, but it makes it easier to debug
      // (we can just 'n', without checking the value of 'separatorIsLongerThanUs').
      switch separatorIsLongerThanUs {
      case true: result = [zelf.asObject]
      case false: result = onSeparatorSplit(py, zelf, separator, count)
      }

      let list = py.newList(elements: result)
      return PyResult(list)

    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Parse arguments

  private static func parseMaxCount(_ py: Py, object: PyObject?) -> PyResultGen<Int> {
    guard let object = object else {
      return .value(Int.max)
    }

    guard let pyInt = py.cast.asInt(object) else {
      return .typeError(py, message: "maxsplit must be int, not \(object.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError(py, message: "maxsplit is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }

  private static func parseSeparator(_ py: Py, object: PyObject?) -> SplitSeparator<Elements> {
    guard let object = object else {
      return .whitespace
    }

    if py.cast.isNone(object) {
      return .whitespace
    }

    guard let separator = Self.getElements(py, object: object) else {
      let message = "sep must be \(Self.pythonTypeName) or None, not \(object.typeName)"
      let error = py.newTypeError(message: message)
      return .error(error.asBaseException)
    }

    if separator.isEmpty {
      let error = py.newValueError(message: "empty separator")
      return .error(error.asBaseException)
    }

    return .some(separator)
  }
}
