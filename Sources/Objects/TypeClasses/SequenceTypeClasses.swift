import Core

// MARK: - Length

internal protocol LengthTypeClass: TypeClass {
  var length: PyInt { get }
}

// MARK: - Concat

//internal protocol ConcatTypeClass: TypeClass {
//  func concat(_ other: PyObject) throws -> PyObject
//}
//
//internal protocol ConcatInPlaceTypeClass: TypeClass {
//  func concatInPlace(_ other: PyObject) throws
//}

// MARK: - Repeat

//internal protocol RepeatTypeClass: TypeClass {
//  func `repeat`(count: PyInt) throws -> PyObject
//}
//
//internal protocol RepeatInPlaceTypeClass: TypeClass {
//  func repeatInPlace(count: PyInt) throws
//}

// MARK: - Get/set item

internal typealias GetItemResult<T> = Either<T, PyErrorEnum>

internal protocol GetItemTypeClass: TypeClass {
  func getItem(at index: PyObject) -> GetItemResult<PyObject>
}

internal protocol SetItemTypeClass: TypeClass {
  func setItem(at index: PyObject, to value: PyObject) -> PyErrorEnum?
}

// MARK: - Contains

internal protocol ContainsTypeClass: TypeClass {
  func contains(_ element: PyObject) -> Bool
}

// MARK: - Count

internal protocol CountTypeClass: TypeClass {
  func count(_ element: PyObject) -> BigInt
}

// MARK: - Index

internal typealias IndexOfResult = Either<BigInt, PyErrorEnum>

internal protocol IndexOfTypeClass: TypeClass {
  func index(of element: PyObject) -> IndexOfResult
}

// MARK: - Slice

//  void *was_sq_slice;
//  void *was_sq_ass_slice;

// MARK: - Iterable

internal protocol IterableTypeClass {
  func next(value: PyObject) throws -> PyObject
}
