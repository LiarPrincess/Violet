import BigInt
import VioletCore

// cSpell:ignore STRINGLIB

// MARK: - Contains

extension PyStringImpl {

  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    switch Self.extractSelf(from: element) {
    case .value(let string):
      return .value(self.contains(string))
    case .notSelf:
      let s = Self.typeName
      let t = element.typeName
      return .typeError("'in <\(s)>' requires \(s) as left operand, not \(t)")
    case .error(let e):
      return .error(e)
    }
  }

  internal func contains(_ data: Self) -> Bool {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'

    switch self.findRaw(in: self.scalars, value: data) {
    case .index: return true
    case .notFound: return false
    }
  }
}

// MARK: - Index

extension PyStringImpl {

  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    let elementString: Self
    switch Self.extractSelf(from: element) {
    case .value(let e):
      elementString = e
    case .notSelf:
      return .typeError("index arg must be \(Self.typeName), not \(element.typeName)")
    case .error(let e):
      return .error(e)
    }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.findRaw(in: substring.value, value: elementString)
    return self.getIndexResult(substring: substring, result: result)
  }

  internal func rindex(_ element: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<BigInt> {
    let elementString: Self
    switch Self.extractSelf(from: element) {
    case .value(let e):
      elementString = e
    case .notSelf:
      return .typeError("rindex arg must be \(Self.typeName), not \(element.typeName)")
    case .error(let e):
      return .error(e)
    }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.rfindRaw(in: substring.value, value: elementString)
    return self.getIndexResult(substring: substring, result: result)
  }

  private func getIndexResult(substring: IndexedSubSequence,
                              result: StringFindResult<Index>) -> PyResult<BigInt> {
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)
    case .notFound:
      return .valueError("substring not found")
    }
  }
}

// MARK: - Count

extension PyStringImpl {

  internal func count(_ element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    switch Self.extractSelf(from: element) {
    case .value(let elementString):
      switch self.substring(start: start, end: end) {
      case let .value(s):
        return .value(self.count(in: s.value, element: elementString))
      case let .error(e):
        return .error(e)
      }

    case .notSelf:
      return .typeError("sub arg must be \(Self.typeName), not \(element.typeName)")
    case .error(let e):
      return .error(e)
    }
  }

  /// STRINGLIB(count)(const STRINGLIB_CHAR* str, Py_ssize_t str_len,
  ///                  const STRINGLIB_CHAR* sub, Py_ssize_t sub_len,
  ///                  Py_ssize_t maxcount)
  private func count(in collection: SubSequence, element: Self) -> BigInt {
    if collection.isEmpty {
      return 0
    }

    if element.isEmpty {
      return BigInt(collection.count + 1)
    }

    var result = BigInt(0)
    var index = collection.startIndex

    while index != collection.endIndex {
      let s = collection[index...]
      if s.starts(with: element.scalars) {
        result += 1

        // we know that 'element.count' != 0, because we checked 'element.isEmpty'
        index = collection.index(index, offsetBy: element.count)
      } else {
        self.formIndex(after: &index)
      }
    }

    return result
  }
}
