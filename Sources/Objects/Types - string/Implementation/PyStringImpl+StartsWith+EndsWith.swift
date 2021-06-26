// MARK: - Starts/ends with

extension PyStringImpl {

  internal func starts(with element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<Bool> {
    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    switch Self.extractSelf(from: element) {
    case .value(let string):
      return .value(self.starts(substring: substring, with: string))
    case .notSelf:
      break // Try other
    case .error(let e):
      return .error(e)
    }

    if let tuple = PyCast.asTuple(element) {
      for element in tuple.elements {
        switch Self.extractSelf(from: element) {
        case .value(let string):
          if self.starts(substring: substring, with: string) {
            return .value(true)
          }
        case .notSelf:
          let s = Self.typeName
          let t = element.typeName
          return .typeError("tuple for startswith must only contain \(s), not \(t)")
        case .error(let e):
          return .error(e)
        }
      }

      return .value(false)
    }

    let s = Self.typeName
    let t = element.typeName
    return .typeError("startswith first arg must be \(s) or a tuple of \(s), not \(t)")
  }

  internal func ends(with element: PyObject,
                     start: PyObject?,
                     end: PyObject?) -> PyResult<Bool> {
    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    switch Self.extractSelf(from: element) {
    case .value(let string):
      return .value(self.ends(substring: substring, with: string))
    case .notSelf:
      break // Try other
    case .error(let e):
      return .error(e)
    }

    if let tuple = PyCast.asTuple(element) {
      for element in tuple.elements {
        switch Self.extractSelf(from: element) {
        case .value(let string):
          if self.ends(substring: substring, with: string) {
            return .value(true)
          }
        case .notSelf:
          let s = Self.typeName
          let t = element.typeName
          return .typeError("tuple for endswith must only contain \(s), not \(t)")
        case .error(let e):
          return .error(e)
        }
      }

      return .value(false)
    }

    let s = Self.typeName
    let t = element.typeName
    return .typeError("endswith first arg must be \(s) or a tuple of \(s), not \(t)")
  }

  internal func starts(substring zelf: IndexedSubSequence,
                       with other: Self) -> Bool {
    if self.is(substring: zelf, longerThan: other) {
      return false
    }

    if other.isEmpty {
      return true
    }

    return zelf.value.starts(with: other.scalars)
  }

  internal func ends(substring zelf: IndexedSubSequence,
                     with other: Self) -> Bool {
    if self.is(substring: zelf, longerThan: other) {
      return false
    }

    if zelf.value.isEmpty {
      return true
    }

    return zelf.value.ends(with: other.scalars)
  }

  private func `is`(substring zelf: IndexedSubSequence,
                    longerThan other: Self) -> Bool {
    let start = zelf.start?.adjustedInt ?? Int.min
    var end = zelf.end?.adjustedInt ?? Int.max
    end -= other.count

    return start > end
  }
}
