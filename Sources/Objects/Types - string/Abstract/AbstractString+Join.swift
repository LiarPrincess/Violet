extension AbstractString {

  /// >>> '@'.join(['A', 'B', 'C'])
  /// 'A@B@C'
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _join(iterable: PyObject) -> PyResult<SwiftType> {
    let capacity = self._approximateCapacity(iterable: iterable)
    var builder = Builder(capacity: capacity)
    var index = 0

    let reduceError = Py.reduce(iterable: iterable, into: &builder) { acc, object in
      if index > 0 {
        acc.append(contentsOf: self.elements) // @ in '@'.join(['A', 'B', 'C'])
      }

      guard let objectElements = Self._getElements(object: object) else {
        let t = Self._pythonTypeName
        let ot = object.typeName
        let msg = "sequence item \(index): expected a \(t)-like object, \(ot) found"
        return .error(Py.newTypeError(msg: msg))
      }

      acc.append(contentsOf: objectElements)
      index += 1
      return .goToNextElement
    }

    if let e = reduceError {
      return .error(e)
    }

    let result = builder.finalize()
    let resultObject = Self._toObject(result: result)
    return .value(resultObject)
  }

  private func _approximateCapacity(iterable: PyObject) -> Int {
    // We need some default. 5 is as good as any other.
    var iterableCount = 5

    // If we can easily get the '__len__' then use it.
    // If not, then we can't call python method, because it may side-effect.
    if let bigInt = Fast.__len__(iterable), let int = Int(exactly: bigInt) {
      iterableCount = int
    }

    let ourCount = self.elements.count
    let iterableElementExpectedCount = 2 // Again, 2 is our guess.
    return iterableCount * (ourCount + iterableElementExpectedCount)
  }
}
