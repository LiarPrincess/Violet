extension AbstractString {

  // MARK: - Lower case

  internal static func abstractLower(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "lower")
    }

    var builder = Builder(capacity: zelf.count)

    for element in zelf.elements {
      let mapping = Self.lowercaseMapping(element: element)
      builder.append(mapping: mapping)
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  // MARK: - Upper case

  internal static func abstractUpper(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "upper")
    }

    var builder = Builder(capacity: zelf.count)

    for element in zelf.elements {
      let mapping = Self.uppercaseMapping(element: element)
      builder.append(mapping: mapping)
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  // MARK: - Title case

  internal static func abstractTitle(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "title")
    }

    var builder = Builder(capacity: zelf.count)
    var isPreviousCased = false

    for element in zelf.elements {
      if isPreviousCased {
        let mapping = Self.lowercaseMapping(element: element)
        builder.append(mapping: mapping)
      } else {
        let mapping = Self.titlecaseMapping(element: element)
        builder.append(mapping: mapping)
      }

      isPreviousCased = Self.isCased(element: element)
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  // MARK: - Swap case

  internal static func abstractSwapcase(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "swapcase")
    }

    var builder = Builder(capacity: zelf.count)

    for element in zelf.elements {
      let isCased = Self.isCased(element: element)

      if isCased && Self.isLower(element: element) {
        let mapping = Self.uppercaseMapping(element: element)
        builder.append(mapping: mapping)
      } else if isCased && Self.isUpper(element: element) {
        let mapping = Self.lowercaseMapping(element: element)
        builder.append(mapping: mapping)
      } else {
        // (is not cased OR is cased but not lower or upper)
        builder.append(element: element)
      }
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  // MARK: - Capitalize

  internal static func abstractCapitalize(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "capitalize")
    }

    // Capitalize only the first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    var builder = Builder(capacity: zelf.count)

    guard let first = zelf.elements.first else {
      let result = builder.finalize()
      let resultObject = Self.newObject(py, result: result)
      return PyResult(resultObject)
    }

    let firstUpper = Self.uppercaseMapping(element: first)
    builder.append(mapping: firstUpper)

    for element in zelf.elements.dropFirst() {
      let mapping = Self.lowercaseMapping(element: element)
      builder.append(mapping: mapping)
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }
}
