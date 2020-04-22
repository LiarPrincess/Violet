extension PyInstance {

  // MARK: - Get

  /// PySequence_GetItem
  public func getItem(object: PyObject,
                      at index: Int) -> PyResult<PyObject> {
    let int = self.newInt(index)
    return self.getItem(object: object, at: int)
  }

  /// PyObject_GetItem
  public func getItem(object: PyObject,
                      at index: PyObject) -> PyResult<PyObject> {
    if let result = Fast.__getitem__(object, at: index) {
      return result
    }

    switch self.callMethod(object: object, selector: .__getitem__, arg: index) {
    case .value(let r):
      return .value(r)
    case .missingMethod:
      return .typeError("'\(object.typeName)' object is not subscriptable")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Set

  /// PyObject_SetItem
  public func setItem(object: PyObject,
                      at index: PyObject,
                      value: PyObject) -> PyResult<PyNone> {
    if let result = Fast.__setitem__(object, at: index, to: value) {
      return result
    }

    switch self.callMethod(object: object, selector: .__setitem__, arg: value) {
    case .value:
      return .value(self.none)
    case .missingMethod:
      let t = object.typeName
      return .typeError("'\(t)' object does not support item assignment")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Delete

  /// PyObject_DelItem
  public func deleteItem(object: PyObject,
                         at index: PyObject) -> PyResult<PyNone> {
    if let result = Fast.__delitem__(object, at: index) {
      return result
    }

    switch self.callMethod(object: object, selector: .__delitem__) {
    case .value:
      return .value(self.none)
    case .missingMethod:
      let t = object.typeName
      return .typeError("'\(t)' object does not support item deletion")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}
