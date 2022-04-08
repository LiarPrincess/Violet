private enum GetItemImpl: GetItemHelper {
  fileprivate typealias Source = [PyObject]
  fileprivate typealias SliceBuilder = GetItemSliceBuilder
}

private struct GetItemSliceBuilder: GetItemSliceBuilderType {
  fileprivate typealias Source = [PyObject]
  fileprivate typealias Result = [PyObject]

  private var result: [PyObject]

  fileprivate static func whenStepIs1(subsequence: Source.SubSequence) -> Result {
    return Array(subsequence)
  }

  fileprivate init(capacity: Int) {
    self.result = [PyObject]()
    self.result.reserveCapacity(capacity)
  }

  fileprivate mutating func append(element: PyObject) {
    self.result.append(element)
  }

  fileprivate func finalize() -> [PyObject] {
    return self.result
  }
}

extension AbstractSequence {

  internal static func abstract__getitem__(_ py: Py,
                                           zelf _zelf: PyObject,
                                           index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getitem__")
    }

    switch GetItemImpl.getItem(py, source: zelf.elements, index: index) {
    case let .single(object):
      return .value(object)
    case let .slice(elements):
      let result = Self.newObject(py, elements: elements)
      return PyResult(result)
    case let .error(e):
      return .error(e)
    }
  }
}
