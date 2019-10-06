// MARK: - Length

internal protocol LengthTypeClass: TypeClass {
  func getLength() throws -> PyInt
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
  func `repeat`(count: PyInt) throws -> PyObject
}

internal protocol RepeatInPlaceTypeClass: TypeClass {
  func repeatInPlace(count: PyInt) throws
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

// MARK: - Iterable

internal protocol IterableTypeClass {
  func next(value: PyObject) throws -> PyObject
}
