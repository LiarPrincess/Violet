// MARK: - Add

private struct AddOp: BinaryOp {

  fileprivate static let op = "+"
  fileprivate static let inPlaceOp = "+="
  fileprivate static let selector = "__add__"
  fileprivate static let reverseSelector = "__radd__"
  fileprivate static let inPlaceSelector = "__iadd__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __add__Owner {
      return owner.add(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __radd__Owner {
      return owner.radd(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __iadd__Owner {
      return owner.iadd(right)
    }
    return .unavailable
  }
}

public func add(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return AddOp.call(left: left, right: right)
}

public func addInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return AddOp.callInPlace(left: left, right: right)
}

// MARK: - Sub

private struct SubOp: BinaryOp {

  fileprivate static let op = "-"
  fileprivate static let inPlaceOp = "-="
  fileprivate static let selector = "__sub__"
  fileprivate static let reverseSelector = "__rsub__"
  fileprivate static let inPlaceSelector = "__isub__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __sub__Owner {
      return owner.sub(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rsub__Owner {
      return owner.rsub(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __isub__Owner {
      return owner.isub(right)
    }
    return .unavailable
  }
}

public func sub(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return SubOp.call(left: left, right: right)
}

public func subInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return SubOp.callInPlace(left: left, right: right)
}

// MARK: - Mul

private struct MulOp: BinaryOp {

  fileprivate static let op = "*"
  fileprivate static let inPlaceOp = "*="
  fileprivate static let selector = "__mul__"
  fileprivate static let reverseSelector = "__rmul__"
  fileprivate static let inPlaceSelector = "__imul__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __mul__Owner {
      return owner.mul(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rmul__Owner {
      return owner.rmul(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __imul__Owner {
      return owner.imul(right)
    }
    return .unavailable
  }
}

public func mul(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return MulOp.call(left: left, right: right)
}

public func mulInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return MulOp.callInPlace(left: left, right: right)
}

// MARK: - Matmul

private struct MatmulOp: BinaryOp {

  fileprivate static let op = "@"
  fileprivate static let inPlaceOp = "@="
  fileprivate static let selector = "__matmul__"
  fileprivate static let reverseSelector = "__rmatmul__"
  fileprivate static let inPlaceSelector = "__imatmul__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __matmul__Owner {
      return owner.matmul(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rmatmul__Owner {
      return owner.rmatmul(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __imatmul__Owner {
      return owner.imatmul(right)
    }
    return .unavailable
  }
}

public func matmul(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return MatmulOp.call(left: left, right: right)
}

public func matmulInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return MatmulOp.callInPlace(left: left, right: right)
}

// MARK: - Truediv

private struct TruedivOp: BinaryOp {

  fileprivate static let op = "/"
  fileprivate static let inPlaceOp = "/="
  fileprivate static let selector = "__truediv__"
  fileprivate static let reverseSelector = "__rtruediv__"
  fileprivate static let inPlaceSelector = "__itruediv__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __truediv__Owner {
      return owner.truediv(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rtruediv__Owner {
      return owner.rtruediv(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __itruediv__Owner {
      return owner.itruediv(right)
    }
    return .unavailable
  }
}

public func truediv(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return TruedivOp.call(left: left, right: right)
}

public func truedivInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return TruedivOp.callInPlace(left: left, right: right)
}

// MARK: - Floordiv

private struct FloordivOp: BinaryOp {

  fileprivate static let op = "//"
  fileprivate static let inPlaceOp = "//="
  fileprivate static let selector = "__floordiv__"
  fileprivate static let reverseSelector = "__rfloordiv__"
  fileprivate static let inPlaceSelector = "__ifloordiv__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __floordiv__Owner {
      return owner.floordiv(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rfloordiv__Owner {
      return owner.rfloordiv(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __ifloordiv__Owner {
      return owner.ifloordiv(right)
    }
    return .unavailable
  }
}

public func floordiv(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return FloordivOp.call(left: left, right: right)
}

public func floordivInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return FloordivOp.callInPlace(left: left, right: right)
}

// MARK: - Mod

private struct ModOp: BinaryOp {

  fileprivate static let op = "%"
  fileprivate static let inPlaceOp = "%="
  fileprivate static let selector = "__mod__"
  fileprivate static let reverseSelector = "__rmod__"
  fileprivate static let inPlaceSelector = "__imod__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __mod__Owner {
      return owner.mod(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rmod__Owner {
      return owner.rmod(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __imod__Owner {
      return owner.imod(right)
    }
    return .unavailable
  }
}

public func mod(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return ModOp.call(left: left, right: right)
}

public func modInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return ModOp.callInPlace(left: left, right: right)
}

// MARK: - Divmod

private struct DivmodOp: BinaryOp {

  fileprivate static let op = "divmod()"
  fileprivate static let inPlaceOp = "divmod()="
  fileprivate static let selector = "__divmod__"
  fileprivate static let reverseSelector = "__rdivmod__"
  fileprivate static let inPlaceSelector = "__idivmod__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __divmod__Owner {
      return owner.divmod(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rdivmod__Owner {
      return owner.rdivmod(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __idivmod__Owner {
      return owner.idivmod(right)
    }
    return .unavailable
  }
}

public func divmod(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return DivmodOp.call(left: left, right: right)
}

// `divmod` in place does not make sense

// MARK: - Lshift

private struct LshiftOp: BinaryOp {

  fileprivate static let op = "<<"
  fileprivate static let inPlaceOp = "<<="
  fileprivate static let selector = "__lshift__"
  fileprivate static let reverseSelector = "__rlshift__"
  fileprivate static let inPlaceSelector = "__ilshift__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __lshift__Owner {
      return owner.lshift(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rlshift__Owner {
      return owner.rlshift(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __ilshift__Owner {
      return owner.ilshift(right)
    }
    return .unavailable
  }
}

public func lshift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return LshiftOp.call(left: left, right: right)
}

public func lshiftInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return LshiftOp.callInPlace(left: left, right: right)
}

// MARK: - Rshift

private struct RshiftOp: BinaryOp {

  fileprivate static let op = ">>"
  fileprivate static let inPlaceOp = ">>="
  fileprivate static let selector = "__rshift__"
  fileprivate static let reverseSelector = "__rrshift__"
  fileprivate static let inPlaceSelector = "__irshift__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __rshift__Owner {
      return owner.rshift(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rrshift__Owner {
      return owner.rrshift(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __irshift__Owner {
      return owner.irshift(right)
    }
    return .unavailable
  }
}

public func rshift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return RshiftOp.call(left: left, right: right)
}

public func rshiftInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return RshiftOp.callInPlace(left: left, right: right)
}

// MARK: - And

private struct AndOp: BinaryOp {

  fileprivate static let op = "&"
  fileprivate static let inPlaceOp = "&="
  fileprivate static let selector = "__and__"
  fileprivate static let reverseSelector = "__rand__"
  fileprivate static let inPlaceSelector = "__iand__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __and__Owner {
      return owner.and(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rand__Owner {
      return owner.rand(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __iand__Owner {
      return owner.iand(right)
    }
    return .unavailable
  }
}

public func and(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return AndOp.call(left: left, right: right)
}

public func andInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return AndOp.callInPlace(left: left, right: right)
}

// MARK: - Or

private struct OrOp: BinaryOp {

  fileprivate static let op = "|"
  fileprivate static let inPlaceOp = "|="
  fileprivate static let selector = "__or__"
  fileprivate static let reverseSelector = "__ror__"
  fileprivate static let inPlaceSelector = "__ior__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __or__Owner {
      return owner.or(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __ror__Owner {
      return owner.ror(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __ior__Owner {
      return owner.ior(right)
    }
    return .unavailable
  }
}

public func or(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return OrOp.call(left: left, right: right)
}

public func orInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return OrOp.callInPlace(left: left, right: right)
}

// MARK: - Xor

private struct XorOp: BinaryOp {

  fileprivate static let op = "^"
  fileprivate static let inPlaceOp = "^="
  fileprivate static let selector = "__xor__"
  fileprivate static let reverseSelector = "__rxor__"
  fileprivate static let inPlaceSelector = "__ixor__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __xor__Owner {
      return owner.xor(right)
    }
    return .unavailable
  }

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = right as? __rxor__Owner {
      return owner.rxor(left)
    }
    return .unavailable
  }

  fileprivate static func callFastInPlace(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let owner = left as? __ixor__Owner {
      return owner.ixor(right)
    }
    return .unavailable
  }
}

public func xor(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return XorOp.call(left: left, right: right)
}

public func xorInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
  return XorOp.callInPlace(left: left, right: right)
}

