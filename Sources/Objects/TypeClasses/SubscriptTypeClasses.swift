internal protocol SubscriptLengthTypeClass: TypeClass {
  func subscriptLength(value: PyObject) throws -> PyInt
}

internal protocol SubscriptTypeClass: SubscriptLengthTypeClass {
  func `subscript`(owner: PyObject, index: PyObject) throws -> PyObject
}

internal protocol SubscriptAssignTypeClass: SubscriptLengthTypeClass {
  func subscriptAssign(owner: PyObject, index: PyObject, value: PyObject) throws
}

// This is not finished
extension SubscriptLengthTypeClass {
  internal func extractIndex(value: PyObject) throws -> Int? {
    guard let indexType = value.type as? IndexTypeClass else {
      return nil
    }

    let index = try indexType.index(value: value)
    let bigInt = try self.context.types.int.extractInt(index)
    guard let result = Int(exactly: bigInt) else {
      // i = PyNumber_AsSsize_t(item, PyExc_IndexError);
      fatalError()
    }

    return result
  }
}
