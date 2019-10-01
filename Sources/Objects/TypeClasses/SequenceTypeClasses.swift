// MARK: - Length

internal protocol LengthTypeClass: TypeClass {
  func length(value: PyObject) throws -> PyInt
}

// TODO: This is not finished
extension LengthTypeClass {
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

// MARK: - Concat

internal protocol ConcatTypeClass: TypeClass {
  func concat(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol ConcatInPlaceTypeClass: TypeClass {
  func concatInPlace(left: PyObject, right: PyObject) throws
}

// MARK: - Repeat

internal protocol RepeatTypeClass: TypeClass {
  func `repeat`(value: PyObject, count: PyInt) throws -> PyObject
}

internal protocol RepeatInPlaceTypeClass: TypeClass {
  func repeatInPlace(value: PyObject, count: PyInt) throws
}

// MARK: - Items

internal protocol ItemTypeClass: TypeClass {
  func item(owner: PyObject, at index: Int) throws -> PyObject
}

internal protocol ItemAssignTypeClass: TypeClass {
  func itemAssign(owner: PyObject, at index: Int, to value: PyObject) throws
}

internal protocol ContainsTypeClass: TypeClass {
  func contains(owner: PyObject, element: PyObject) throws -> Bool
}

// MARK: - Slice

//  void *was_sq_slice;
//  void *was_sq_ass_slice;
