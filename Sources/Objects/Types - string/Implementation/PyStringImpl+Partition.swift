
// MARK: - Partition

internal enum StringPartitionResult<Zelf, SubString> {
  /// Separator was not found
  case separatorNotFound
  /// Separator was found.
  case separatorFound(before: SubString, separator: Zelf, after: SubString)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal typealias PartitionResult = StringPartitionResult<Self, Self.SubSequence>

  internal func partition(separator: PyObject) -> PartitionResult {
    switch Self.extractSelf(from: separator) {
    case .value(let sep):
      return self.partition(separator: sep)
    case .notSelf:
      let msg = "sep must be string, not \(separator.typeName)"
      return .error(Py.newTypeError(msg: msg))
    case .error(let e):
      return .error(e)
    }
  }

  internal func partition(separator: Self) -> PartitionResult {
    if separator.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    switch self.findRaw(in: self.scalars, value: separator) {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let sepCount = separator.scalars.count
      let index2 = self.index(index1, offsetBy: sepCount, limitedBy: self.endIndex)

      let before = self.substring(end: index1)
      let after = self.substring(start: index2)
      return .separatorFound(before: before, separator: separator, after: after)

    case .notFound:
      return .separatorNotFound
    }
  }

  internal func rpartition(separator: PyObject) -> PartitionResult {
    switch Self.extractSelf(from: separator) {
    case .value(let sep):
      return self.rpartition(separator: sep)
    case .notSelf:
      let msg = "sep must be string, not \(separator.typeName)"
      return .error(Py.newTypeError(msg: msg))
    case .error(let e):
      return .error(e)
    }
  }

  internal func rpartition(separator: Self) -> PartitionResult {
    if separator.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    switch self.rfindRaw(in: self.scalars, value: separator) {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let sepCount = separator.scalars.count
      let index2 = self.index(index1, offsetBy: sepCount, limitedBy: self.endIndex)

      let before = self.substring(end: index1)
      let after = self.substring(start: index2)
      return .separatorFound(before: before, separator: separator, after: after)

    case .notFound:
      return .separatorNotFound
    }
  }
}
