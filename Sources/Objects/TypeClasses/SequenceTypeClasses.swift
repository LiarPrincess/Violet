import Core

// MARK: - Length

internal protocol LengthTypeClass: TypeClass {
  var length: PyInt { get }
}

// MARK: - Get/set item

internal typealias GetItemResult<T> = PyResult<T>

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

internal typealias CountResult = PyResult<BigInt>

internal protocol CountTypeClass: TypeClass {
  func count(_ element: PyObject) -> CountResult
}

// MARK: - Index

internal typealias IndexOfResult = PyResult<BigInt>

internal protocol GetIndexOfTypeClass: TypeClass {
  func getIndex(of element: PyObject) -> IndexOfResult
}

// MARK: - Slice

//  void *was_sq_slice;
//  void *was_sq_ass_slice;

// MARK: - Iterable

internal protocol IterableTypeClass {
  func next() -> PyObject
}
