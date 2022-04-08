extension AbstractString {

  /// >>> '@'.join(['A', 'B', 'C'])
  /// 'A@B@C'
  internal static func abstractJoin(_ py: Py,
                                    zelf _zelf: PyObject,
                                    iterable: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "join")
    }

    let capacity = Self.approximateCapacity(py, zelf: zelf, iterable: iterable)
    var builder = Builder(capacity: capacity)
    var index = 0

    let reduceError = py.reduce(iterable: iterable, into: &builder) { acc, object in
      if index > 0 {
        acc.append(contentsOf: zelf.elements) // @ in '@'.join(['A', 'B', 'C'])
      }

      guard let objectElements = Self.getElements(py, object: object) else {
        let t = Self.pythonTypeName
        let ot = object.typeName
        let message = "sequence item \(index): expected a \(t)-like object, \(ot) found"
        let error = py.newTypeError(message: message)
        return .error(error.asBaseException)
      }

      acc.append(contentsOf: objectElements)
      index += 1
      return .goToNextElement
    }

    if let e = reduceError {
      return .error(e)
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  private static func approximateCapacity(_ py: Py,
                                          zelf: Self,
                                          iterable: PyObject) -> Int {
    // We need some default. 5 is as good as any other.
    var iterableCount = 5

    // If we can easily get the '__len__' then use it.
    // If not, then we can't call python method, because it may side-effect.
    if let int = Self.abstractApproximateCount(py, iterable: iterable) {
      iterableCount = int
    }

    let ourCount = zelf.count
    let iterableElementExpectedCount = 2 // Again, 2 is our guess.
    return iterableCount * (ourCount + iterableElementExpectedCount)
  }

  internal static func abstractApproximateCount(_ py: Py, iterable: PyObject) -> Int? {
    // If we can easily get the '__len__' then use it.
    // If not, then we can't call python method, because it may side-effect.
    guard let result = PyStaticCall.__len__(py, object: iterable) else {
      return nil
    }

    let object: PyObject
    switch result {
    case .value(let o): object = o
    case .error: return nil
    }

    guard let int = py.cast.asInt(object) else {
      return nil
    }

    return Int(exactly: int.value)
  }
}
