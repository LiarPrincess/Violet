
// MARK: - Center, just

private enum FillChar<T> {
  case `default`
  case value(T)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func center(width: PyObject,
                       fill: PyObject?) -> PyResult<Builder.Result> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "center") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let parsedFill: Element
    switch self.parseJustFillChar(fill, fnName: "center") {
    case .default: parsedFill = Self.defaultFill
    case .value(let s): parsedFill = s
    case .error(let e): return .error(e)
    }

    return .value(self.center(width: parsedWidth, fill: parsedFill))
  }

  internal func center(width: Int, fill: Element) -> Builder.Result {
    let marg = width - self.count
    guard marg > 0 else {
      var builder = Builder()
      builder.append(contentsOf: self.scalars)
      return builder.result
    }

    let left = marg / 2 + (marg & width & 1)
    let right = marg - left
    return self.pad(left: left, right: right, fill: fill)
  }

  internal func ljust(width: PyObject,
                      fill: PyObject?) -> PyResult<Builder.Result> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "ljust") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let parsedFill: Element
    switch self.parseJustFillChar(fill, fnName: "ljust") {
    case .default: parsedFill = Self.defaultFill
    case .value(let s): parsedFill = s
    case .error(let e): return .error(e)
    }

    return .value(self.ljust(width: parsedWidth, fill: parsedFill))
  }

  internal func ljust(width: Int, fill: Element) -> Builder.Result {
    let count = width - self.count
    return self.pad(left: 0, right: count, fill: fill)
  }

  internal func rjust(width: PyObject,
                      fill: PyObject?) -> PyResult<Builder.Result> {
    let parsedWidth: Int
    switch self.parseJustWidth(width, fnName: "rjust") {
    case let .value(w): parsedWidth = w
    case let .error(e): return .error(e)
    }

    let parsedFill: Element
    switch self.parseJustFillChar(fill, fnName: "rjust") {
    case .default: parsedFill = Self.defaultFill
    case .value(let s): parsedFill = s
    case .error(let e): return .error(e)
    }

    return .value(self.rjust(width: parsedWidth, fill: parsedFill))
  }

  internal func rjust(width: Int, fill: Element) -> Builder.Result {
    let count = width - self.count
    return self.pad(left: count, right: 0, fill: fill)
  }

  private func parseJustWidth(_ width: PyObject,
                              fnName: String) -> PyResult<Int> {
    guard let pyInt = PyCast.asInt(width) else {
      return .typeError("\(fnName) width arg must be int, not \(width.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("\(fnName) width is too large")
    }

    return .value(int)
  }

  private func parseJustFillChar(_ fill: PyObject?,
                                 fnName: String) -> FillChar<Element> {
    guard let fill = fill else {
      return .default
    }

    switch Self.extractSelf(from: fill) {
    case .value(let string):
      if let first = string.scalars.first, string.scalars.count == 1 {
        return .value(first)
      }
    case .notSelf:
      break
    case .error(let e):
      return .error(e)
    }

    let t = fill.typeName
    let msg = "\(fnName) fillchar arg must be \(Self.typeName) of length 1, not \(t)"
    return .error(Py.newTypeError(msg: msg))
  }

  private func pad(left: Int, right: Int, fill: Element) -> Builder.Result {
    var builder = Builder()

    guard left > 0 || right > 0 else {
      builder.append(contentsOf: self.scalars)
      return builder.result
    }

    if left > 0 {
      builder.append(contentsOf: Array(repeating: fill, count: left))
    }

    builder.append(contentsOf: self.scalars)

    if right > 0 {
      builder.append(contentsOf: Array(repeating: fill, count: right))
    }

    return builder.result
  }
}

// MARK: - ZFill

extension PyStringImpl {

  internal func zfill(width: PyObject) -> PyResult<Builder.Result> {
    guard let widthInt = PyCast.asInt(width) else {
      return .typeError("width must be int, not \(width.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("width is too big")
    }

    let result = self.zfill(width: width)
    return .value(result)
  }

  internal func zfill(width: Int) -> Builder.Result {
    var builder = Builder()

    let fillCount = width - self.count
    guard fillCount > 0 else {
      builder.append(contentsOf: self.scalars)
      return builder.result
    }

    let padding = Array(repeating: Self.zFill, count: fillCount)
    guard let first = self.scalars.first else {
      builder.append(contentsOf: padding)
      return builder.result
    }

    let firstScalar = Self.toUnicodeScalar(first)
    let hasSign = firstScalar == "+" || firstScalar == "-"

    if hasSign {
      builder.append(first)
    }

    builder.append(contentsOf: padding)

    if hasSign {
      builder.append(contentsOf: self.scalars.dropFirst())
    } else {
      builder.append(contentsOf: self.scalars)
    }

    return builder.result
  }
}

// MARK: - Expand tabs

extension PyStringImpl {

  internal func expandTabs(tabSize: PyObject?) -> PyResult<Builder.Result> {
    switch self.parseExpandTabsSize(tabSize) {
    case let .value(v):
      return .value(self.expandTabs(tabSize: v))
    case let .error(e):
      return .error(e)
    }
  }

  internal func expandTabs(tabSize: Int) -> Builder.Result {
    var builder = Builder()
    var linePos = 0

    for element in self.scalars {
      let scalar = Self.toUnicodeScalar(element)
      switch scalar {
      case "\t":
        if tabSize > 0 {
          let incr = tabSize - (linePos % tabSize)
          linePos += incr
          builder.append(contentsOf: Array(repeating: Self.defaultFill, count: incr))
        }

      default:
        linePos += 1
        builder.append(element)

        if scalar == "\n" || scalar == "\r" {
          linePos = 0
        }
      }
    }

    return builder.result
  }

  private func parseExpandTabsSize(_ tabSize: PyObject?) -> PyResult<Int> {
    guard let tabSize = tabSize else {
      return .value(8)
    }

    guard let pyInt = PyCast.asInt(tabSize) else {
      return .typeError("tabsize must be int, not \(tabSize.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("tabsize is too big")
    }

    return .value(int)
  }
}
