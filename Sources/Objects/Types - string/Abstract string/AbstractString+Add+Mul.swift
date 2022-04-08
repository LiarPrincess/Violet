extension AbstractString {

  // MARK: - Add

  internal static func abstract__add__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__add__")
    }

    guard let otherElements = Self.getElements(py, object: other) else {
      let e = Self.abstractCreateAddTypeError(py, other: other)
      return .error(e.asBaseException)
    }

    var builder = Builder(elements: zelf.elements)
    builder.append(contentsOf: otherElements)
    let result = builder.finalize()

    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  internal static func abstractCreateAddTypeError(_ py: Py, other: PyObject) -> PyTypeError {
    let t = Self.pythonTypeName
    let otherType = other.typeName
    let message = "can only concatenate \(t) (not '\(otherType)') to \(t)"
    return py.newTypeError(message: message)
  }

  // MARK: - Mul

  internal static func abstract__mul__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__mul__")
    }

    return Self.mul(py, zelf: zelf, count: other)
  }

  internal static func abstract__rmul__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__rmul__")
    }

    return Self.mul(py, zelf: zelf, count: other)
  }

  private static func mul(_ py: Py,
                          zelf: Self,
                          count countObject: PyObject) -> PyResult {
    let count: Int
    switch Self.abstractParseMulCount(py, object: countObject) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    let capacity = zelf.count * count
    var builder = Builder(capacity: capacity)

    for _ in 0..<max(count, 0) {
      builder.append(contentsOf: zelf.elements)
    }

    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  internal static func abstractParseMulCount(_ py: Py, object: PyObject) -> PyResultGen<Int> {
    guard let pyInt = py.cast.asInt(object) else {
      let t = Self.pythonTypeName
      let message = "can only multiply \(t) and int (not '\(object.typeName)')"
      return .typeError(py, message: message)
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError(py, message: "repeated string is too long")
    }

    return .value(int)
  }
}
