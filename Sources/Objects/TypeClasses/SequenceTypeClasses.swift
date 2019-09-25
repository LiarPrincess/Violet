// MARK: - Length

internal protocol LengthTypeClass: TypeClass {
  func length(value: PyObject) throws -> PyInt
}

// MARK: - Concat

internal protocol ConcatTypeClass: TypeClass {
  func concat(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol ConcatInPlaceTypeClass: TypeClass {
  func concatInPlace(left: PyObject, right: PyObject) throws -> PyObject
}

// MARK: - Repeat

internal protocol RepeatTypeClass: TypeClass {
  func `repeat`(value: PyObject, count: PyInt) throws -> PyObject
}

internal protocol RepeatInPlaceTypeClass: TypeClass {
  func repeatInPlace(value: PyObject, count: PyInt) throws -> PyObject
}

// MARK: - Items

internal protocol GetItemTypeClass: TypeClass {
  func getItem(from: PyObject, at index: Int) throws -> PyObject
}

internal protocol ContainsTypeClass: TypeClass {
  func contains(owner: PyObject, element: PyObject) throws -> Bool
}

// MARK: - Slice

//  void *was_sq_slice;
//  void *was_sq_ass_slice;
