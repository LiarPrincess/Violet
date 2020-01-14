public struct DirResult {

  private var values = Set<String>()

  internal var sortedValues: [String] {
    return self.values.sorted()
  }

  internal init() { }

  internal init<S: Sequence>(_ elements: S) where S.Element == String {
    self.append(contentsOf: elements)
  }

  internal mutating func append(_ element: String) {
    self.values.insert(element)
  }

  internal mutating func append<S: Sequence>(contentsOf newElements: S)
    where S.Element == String {

    for element in newElements {
      self.append(element)
    }
  }

  internal mutating func append(contentsOf newElements: DirResult) {
    self.append(contentsOf: newElements.values)
  }
}

extension DirResult: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    let builtins = context.builtins
    let elements = self.sortedValues.map { builtins.newString($0) }
    return .value(builtins.newList(elements))
  }
}
