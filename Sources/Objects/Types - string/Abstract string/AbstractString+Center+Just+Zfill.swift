// swiftlint:disable empty_count

private enum FillChar<T> {
  case `default`
  case value(T)
  case error(PyTypeError)
}

extension AbstractString {

  // MARK: - Center

  internal static func abstractCenter(_ py: Py,
                                      zelf: PyObject,
                                      width: PyObject,
                                      fillChar: PyObject?) -> PyResult {
    return Self.justTemplate(py,
                             zelf: zelf,
                             width: width,
                             fillChar: fillChar,
                             fnName: "center",
                             justFn: Self.center(zelf:width:fillChar:))
  }

  private static func center(zelf: Self, width: Int, fillChar: Element) -> Builder {
    let count = width - zelf.count

    guard count > 0 else {
      return Builder(elements: zelf.elements)
    }

    let leftCount = count / 2 + (count & width & 1)
    let rightCount = count - leftCount

    var builder = Builder(capacity: width)
    builder.append(element: fillChar, repeated: leftCount)
    builder.append(contentsOf: zelf.elements)
    builder.append(element: fillChar, repeated: rightCount)
    return builder
  }

  // MARK: - LJust

  internal static func abstractLJust(_ py: Py,
                                     zelf: PyObject,
                                     width: PyObject,
                                     fillChar: PyObject?) -> PyResult {
    return Self.justTemplate(py,
                             zelf: zelf,
                             width: width,
                             fillChar: fillChar,
                             fnName: "ljust",
                             justFn: Self.ljust(zelf:width:fillChar:))
  }

  private static func ljust(zelf: Self, width: Int, fillChar: Element) -> Builder {
    let count = width - zelf.count

    guard count > 0 else {
      return Builder(elements: zelf.elements)
    }

    var builder = Builder(capacity: width)
    builder.append(contentsOf: zelf.elements)
    builder.append(element: fillChar, repeated: count)
    return builder
  }

  // MARK: - RJust

  internal static func abstractRJust(_ py: Py,
                                     zelf: PyObject,
                                     width: PyObject,
                                     fillChar: PyObject?) -> PyResult {
    return Self.justTemplate(py,
                             zelf: zelf,
                             width: width,
                             fillChar: fillChar,
                             fnName: "rjust",
                             justFn: Self.rjust(zelf:width:fillChar:))
  }

  private static func rjust(zelf: Self, width: Int, fillChar: Element) -> Builder {
    let count = width - zelf.count

    guard count > 0 else {
      return Builder(elements: zelf.elements)
    }

    var builder = Builder(capacity: width)
    builder.append(element: fillChar, repeated: count)
    builder.append(contentsOf: zelf.elements)
    return builder
  }

  // MARK: - Just template

  // swiftlint:disable:next function_parameter_count
  private static func justTemplate(_ py: Py,
                                   zelf _zelf: PyObject,
                                   width widthObject: PyObject,
                                   fillChar fillCharObject: PyObject?,
                                   fnName: String,
                                   justFn: (Self, Int, Element) -> Builder) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let width: Int
    switch Self.parseWidth(py, object: widthObject, fnName: fnName) {
    case let .value(w): width = w
    case let .error(e): return .error(e)
    }

    let fillChar: Element
    switch Self.parseFillChar(py, object: fillCharObject, fnName: fnName) {
    case .default: fillChar = Self.defaultFill
    case .value(let s): fillChar = s
    case .error(let e): return .error(e.asBaseException)
    }

    let builder = justFn(zelf, width, fillChar)
    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  private static func parseWidth(_ py: Py,
                                 object: PyObject,
                                 fnName: String) -> PyResultGen<Int> {
    guard let pyInt = py.cast.asInt(object) else {
      let message = "\(fnName) width arg must be int, not \(object.typeName)"
      return .typeError(py, message: message)
    }

    guard let int = Int(exactly: pyInt.value) else {
      let message = "\(fnName) width is too large"
      return .overflowError(py, message: message)
    }

    return .value(int)
  }

  private static func parseFillChar(_ py: Py,
                                    object: PyObject?,
                                    fnName: String) -> FillChar<Element> {
    guard let object = object else {
      return .default
    }

    if let char = Self.getElements(py, object: object) {
      if let first = char.first, char.count == 1 {
        return .value(first)
      }
    }

    let t = Self.pythonTypeName
    let charType = object.typeName
    let message = "\(fnName) fillchar arg must be \(t) of length 1, not \(charType)"
    let error = py.newTypeError(message: message)
    return .error(error)
  }

  // MARK: - ZFill

  internal static func abstractZFill(_ py: Py,
                                     zelf _zelf: PyObject,
                                     width widthObject: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "zfill")
    }

    guard let widthPyInt = py.cast.asInt(widthObject) else {
      return .typeError(py, message: "width must be int, not \(widthObject.typeName)")
    }

    guard let width = Int(exactly: widthPyInt.value) else {
      return .overflowError(py, message: "width is too big")
    }

    let builder = Self.zfill(zelf: zelf, width: width)
    let result = builder.finalize()
    let resultObject = Self.newObject(py, result: result)
    return PyResult(resultObject)
  }

  private static func zfill(zelf: Self, width: Int) -> Builder {
    let fillCount = width - zelf.count

    guard fillCount > 0 else {
      return Builder(elements: zelf.elements)
    }

    var builder = Builder(capacity: width)

    guard let first = zelf.elements.first else {
      // string is empty
      builder.append(element: Self.zFill, repeated: width)
      return builder
    }

    let hasSign = Self.isPlusOrMinus(element: first)
    if hasSign {
      builder.append(element: first)
    }

    builder.append(element: Self.zFill, repeated: fillCount)

    if hasSign {
      builder.append(contentsOf: zelf.elements.dropFirst())
    } else {
      builder.append(contentsOf: zelf.elements)
    }

    return builder
  }
}
