// swiftlint:disable empty_count

private enum FillChar<T> {
  case `default`
  case value(T)
  case error(PyBaseException)
}

extension AbstractString {

  // MARK: - Center

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _center(width: PyObject, fillChar: PyObject?) -> PyResult<SwiftType> {
    return self._justTemplate(fnName: "center",
                              width: width,
                              fillChar: fillChar,
                              justFn: self._center(width:fillChar:))
  }

  private func _center(width: Int, fillChar: Element) -> Builder {
    let count = width - self.elements.count

    guard count > 0 else {
      return Builder(elements: self.elements)
    }

    let leftCount = count / 2 + (count & width & 1)
    let rightCount = count - leftCount

    var builder = Builder(capacity: width)
    builder.append(element: fillChar, repeated: leftCount)
    builder.append(contentsOf: self.elements)
    builder.append(element: fillChar, repeated: rightCount)
    return builder
  }

  // MARK: - LJust

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _ljust(width: PyObject, fillChar: PyObject?) -> PyResult<SwiftType> {
    return self._justTemplate(fnName: "ljust",
                              width: width,
                              fillChar: fillChar,
                              justFn: self._ljust(width:fillChar:))
  }

  private func _ljust(width: Int, fillChar: Element) -> Builder {
    let count = width - self.elements.count

    guard count > 0 else {
      return Builder(elements: self.elements)
    }

    var builder = Builder(capacity: width)
    builder.append(contentsOf: self.elements)
    builder.append(element: fillChar, repeated: count)
    return builder
  }

  // MARK: - RJust

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _rjust(width: PyObject, fillChar: PyObject?) -> PyResult<SwiftType> {
    return self._justTemplate(fnName: "rjust",
                              width: width,
                              fillChar: fillChar,
                              justFn: self._rjust(width:fillChar:))
  }

  private func _rjust(width: Int, fillChar: Element) -> Builder {
    let count = width - self.elements.count

    guard count > 0 else {
      return Builder(elements: self.elements)
    }

    var builder = Builder(capacity: width)
    builder.append(element: fillChar, repeated: count)
    builder.append(contentsOf: self.elements)
    return builder
  }

  // MARK: - Just template

  private func _justTemplate(
    fnName: String,
    width widthObject: PyObject,
    fillChar fillCharObject: PyObject?,
    justFn: (Int, Element) -> Builder
  ) -> PyResult<SwiftType> {
    let width: Int
    switch self._parseWidth(fnName: fnName, width: widthObject) {
    case let .value(w): width = w
    case let .error(e): return .error(e)
    }

    let fillChar: Element
    switch self._parseFillChar(fnName: fnName, fillChar: fillCharObject) {
    case .default: fillChar = Self._defaultFill
    case .value(let s): fillChar = s
    case .error(let e): return .error(e)
    }

    let builder = justFn(width, fillChar)
    let result = builder.finalize()
    let resultObject = Self._toObject(result: result)
    return .value(resultObject)
  }

  private func _parseWidth(fnName: String, width: PyObject) -> PyResult<Int> {
    guard let pyInt = PyCast.asInt(width) else {
      return .typeError("\(fnName) width arg must be int, not \(width.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("\(fnName) width is too large")
    }

    return .value(int)
  }

  private func _parseFillChar(
    fnName: String,
    fillChar object: PyObject?
  ) -> FillChar<Element> {
    guard let object = object else {
      return .default
    }

    if let char = Self._getElements(object: object) {
      if let first = char.first, char.count == 1 {
        return .value(first)
      }
    }

    let t = Self._pythonTypeName
    let charType = object.typeName
    let msg = "\(fnName) fillchar arg must be \(t) of length 1, not \(charType)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - ZFill

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _zFill(width widthObject: PyObject) -> PyResult<SwiftType> {
    guard let widthPyInt = PyCast.asInt(widthObject) else {
      return .typeError("width must be int, not \(widthObject.typeName)")
    }

    guard let width = Int(exactly: widthPyInt.value) else {
      return .overflowError("width is too big")
    }

    let builder = self._zfill(width: width)
    let result = builder.finalize()
    let resultObject = Self._toObject(result: result)
    return .value(resultObject)
  }

  private func _zfill(width: Int) -> Builder {
    let fillCount = width - self.elements.count

    guard fillCount > 0 else {
      return Builder(elements: self.elements)
    }

    var builder = Builder(capacity: width)

    guard let first = self.elements.first else {
      builder.append(element: Self._zFill, repeated: fillCount)
      return builder
    }

    let firstScalar = Self._asUnicodeScalar(element: first)
    let hasSign = firstScalar == "+" || firstScalar == "-"

    if hasSign {
      builder.append(element: first)
    }

    builder.append(element: Self._zFill, repeated: fillCount)

    if hasSign {
      builder.append(contentsOf: self.elements.dropFirst())
    } else {
      builder.append(contentsOf: self.elements)
    }

    return builder
  }
}
