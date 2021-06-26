extension PyStringImpl {

  // >>> '@'.join(['A', 'B', 'C'])
  // 'A@B@C'
  internal func join(iterable: PyObject) -> PyResult<Builder.Result> {
    var index = 0
    var builder = Builder()

    let reduceError = Py.reduce(iterable: iterable, into: &builder) { acc, object in
      if index > 0 {
        acc.append(contentsOf: self.scalars) // @ in '@'.join(['A', 'B', 'C'])
      }

      switch Self.extractSelf(from: object) {
      case .value(let string):
        acc.append(contentsOf: string.scalars)
        index += 1
        return .goToNextElement
      case .notSelf:
        let s = Self.typeName
        let t = object.typeName
        let msg = "sequence item \(index): expected a \(s)-like object, \(t) found"
        return .error(Py.newTypeError(msg: msg))
      case .error(let e):
        return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    let result = builder.result
    return .value(result)
  }
}
