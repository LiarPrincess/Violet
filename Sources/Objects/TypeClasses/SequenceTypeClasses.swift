import Core

// TODO: Add other from:
// https://docs.python.org/3/reference/datamodel.html#emulating-container-types

// MARK: - Length

internal protocol LengthTypeClass: TypeClass {
  // sourcery: pymethod = __len__
  func getLength() -> BigInt
}

// MARK: - Get/set item

internal typealias GetItemResult<T> = PyResult<T>

internal protocol GetItemTypeClass: TypeClass {
  // sourcery: pymethod = __getitem__
  func getItem(at index: PyObject) -> GetItemResult<PyObject>
}

internal protocol SetItemTypeClass: TypeClass {
  // sourcery: pymethod = __setitem__
  func setItem(at index: PyObject, to value: PyObject) -> PyErrorEnum?
}

// MARK: - Contains

internal protocol ContainsTypeClass: TypeClass {
  // sourcery: pymethod = __contains__
  func contains(_ element: PyObject) -> Bool
}

// MARK: - Count

internal typealias CountResult = PyResult<BigInt>

internal protocol CountTypeClass: TypeClass {
  // sourcery: pymethod = count
  func count(_ element: PyObject) -> CountResult
}

// MARK: - Index

internal typealias IndexOfResult = PyResult<BigInt>

internal protocol GetIndexOfTypeClass: TypeClass {
  // sourcery: pymethod = index
  func getIndex(of element: PyObject) -> IndexOfResult
}

// MARK: - Slice

//  void *was_sq_slice;
//  void *was_sq_ass_slice;

// MARK: - Iterable

// TODO: pymethod
internal protocol IterableTypeClass {
  func next() -> PyObject
}
