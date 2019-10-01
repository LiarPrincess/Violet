public enum CompareMode {
  case equal
  case notEqual
  case less
  case lessEqual
  case greater
  case greaterEqual
}

public class CreateDictionaryArg {
  public let key: PyObject
  public let value: PyObject

  public init(key: PyObject, value: PyObject) {
    self.key = key
    self.value = value
  }
}

extension PyContext {

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> PyObject {
    return self.types.bool.new(left === right)
  }

  /// Test a value used as condition, e.g., in a for or if statement.
  public func isTrue(value: PyObject) throws -> Bool {
    // PyObject_IsTrue(PyObject *v)

    if let bool = value as? PyBool {
      return bool.value.isTrue
    }

    if let boolType = value as? PyBoolConvertibleTypeClass {
      let result = try boolType.bool(value: value)
      return result.value.isTrue
    }

    if let subscriptType = value as? SubscriptLengthTypeClass {
      let length = try subscriptType.subscriptLength(value: value)
      return length.value.isTrue
    }

    if let lengthType = value as? LengthTypeClass {
      let length = try lengthType.length(value: value)
      return length.value.isTrue
    }

    return true
  }

  public func createTuple(elements: [PyObject] = []) -> PyObject {
    return elements.isEmpty ? self.emptyTuple : self.types.tuple.new(elements)
  }

  public func createTuple(list: PyObject) -> PyObject {
    fatalError()
  }

  public func createList(elements: [PyObject] = []) -> PyObject {
    return self.types.list.new(elements)
  }

  public func createSet(elements: [PyObject] = []) -> PyObject {
    fatalError()
  }

  public func createDictionary(elements: [CreateDictionaryArg] = []) -> PyObject {
    fatalError()
  }

  public func createConstDictionary(keys: PyObject,
                                    elements: [PyObject]) -> PyObject {
    // check keys.count == elements.count
    fatalError()
  }

  public func _PyList_Extend(list: PyObject, iterable: PyObject) { }

  public func _PySet_Update(set: PyObject, iterable: PyObject) { }

  public func PyDict_Update(dictionary: PyObject, iterable: PyObject) { }

  public func dictionaryAdd(dictionary: PyObject, key: PyObject, value: PyObject) { }

  public func setAdd(set: PyObject, value: PyObject) { }

  public func listAdd(list: PyObject, value: PyObject) { }

  public func _PyUnicode_JoinArray(elements: [PyObject]) -> PyObject {
    fatalError()
  }

  // MARK: - TODO

  public func getSizeInt(value: PyObject) -> Int {
    return 0
  }

  public func not(value: PyObject) throws -> PyObject {
    return value
  }

  internal func hash(value: PyObject) throws -> PyHash {
    return 0
  }

  public func contains(sequence: PyObject, value: PyObject) -> PyObject {
    return sequence
  }

  internal func _PyType_Name(value: PyType) -> String {
    return value.name
  }

  internal func PyType_IsSubtype(parent: PyType, subtype: PyType) -> Bool {
    return false
  }

  internal func PyUnicode_FromFormat(format: String, args: Any...) -> String {
    return ""
  }

  public func PyObject_Format(value: PyObject, format: PyObject) -> PyObject {
    fatalError()
  }

  public func Py_CLEAR(value: PyObject) throws { }

  public func pySlice_New(start: PyObject, stop: PyObject, step: PyObject?) -> PyObject {
    return start
  }
}
