private enum GetItemImpl: GetItemHelper {
  fileprivate typealias Source = [PyObject]
  fileprivate typealias SliceBuilder = GetItemSliceBuilder
}

private struct GetItemSliceBuilder: GetItemSliceBuilderType {
  fileprivate typealias Source = [PyObject]
  fileprivate typealias Result = [PyObject]

  private var result: [PyObject]

  fileprivate init(capacity: Int) {
    self.result = [PyObject]()
    self.result.reserveCapacity(capacity)
  }

  fileprivate init(sourceSubsequenceWhenStepIs1: Source.SubSequence) {
    self.result = Array(sourceSubsequenceWhenStepIs1)
  }

  fileprivate mutating func append(element: PyObject) {
    self.result.append(element)
  }

  fileprivate func finalize() -> [PyObject] {
    return self.result
  }
}

extension AbstractSequence {

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _getItem(index: PyObject) -> PyResult<PyObject> {
    switch GetItemImpl.getItem(source: self.elements, index: index) {
    case let .single(object):
      return .value(object)
    case let .slice(elements):
      let result = Self._toSelf(elements: elements)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _getItem(index: Int) -> PyResult<PyObject> {
    return GetItemImpl.getItem(source: self.elements, index: index)
  }
}
