// MARK: - Add

extension PyStringImpl {

  internal func add(_ other: PyObject) -> PyResult<Builder.Result> {
    switch Self.extractSelf(from: other) {
    case .value(let otherStr):
      return .value(self.add(otherStr))
    case .notSelf:
      let s = Self.typeName
      let t = other.typeName
      return .typeError("can only concatenate \(s) (not '\(t)') to \(s)")
    case .error(let e):
      return .error(e)
    }
  }

  internal func add(_ other: Self) -> Builder.Result {
    var builder = Builder()

    if self.any {
      builder.append(contentsOf: self.scalars)
    }

    if other.any {
      builder.append(contentsOf: other.scalars)
    }

    return builder.result
  }
}

// MARK: - Mul

extension PyStringImpl {

  internal func mul(_ other: PyObject) -> PyResult<Builder.Result> {
    guard let pyInt = PyCast.asInt(other) else {
      let s = Self.typeName
      let t = other.typeName
      return .typeError("can only multiply \(s) and int (not '\(t)')")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("repeated string is too long")
    }

    return .value(self.mul(int))
  }

  internal func mul(_ n: Int) -> Builder.Result {
    var builder = Builder()

    if self.isEmpty {
      return builder.result
    }

    for _ in 0..<max(n, 0) {
      builder.append(contentsOf: self.scalars)
    }

    return builder.result
  }

  internal func rmul(_ other: PyObject) -> PyResult<Builder.Result> {
    return self.mul(other)
  }
}
