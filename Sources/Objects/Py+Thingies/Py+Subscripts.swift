// cSpell:ignore subscriptable

extension PyInstance {

  // MARK: - Get

  /// PySequence_GetItem
  public func getItem(object: PyObject, index: Int) -> PyResult<PyObject> {
    let int = self.newInt(index)
    return self.getItem(object: object, index: int)
  }

  /// PyObject_GetItem
  public func getItem(object: PyObject, index: PyObject) -> PyResult<PyObject> {
    if let result = Fast.__getitem__(object, index: index) {
      return result
    }

    switch self.callMethod(object: object, selector: .__getitem__, arg: index) {
    case .value(let r):
      return .value(r)
    case .missingMethod:
      return .typeError("'\(object.typeName)' object is not subscriptable")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Set

  /// PyObject_SetItem
  public func setItem(object: PyObject,
                      index: PyObject,
                      value: PyObject) -> PyResult<PyNone> {
    if let result = Fast.__setitem__(object, index: index, value: value) {
      return result
    }

    let args = [index, value]
    switch self.callMethod(object: object, selector: .__setitem__, args: args) {
    case .value:
      return .value(self.none)
    case .missingMethod:
      let t = object.typeName
      return .typeError("'\(t)' object does not support item assignment")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Delete

  /// PyObject_DelItem
  public func deleteItem(object: PyObject, index: PyObject) -> PyResult<PyNone> {
    if let result = Fast.__delitem__(object, index: index) {
      return result
    }

    switch self.callMethod(object: object, selector: .__delitem__, arg: index) {
    case .value:
      return .value(self.none)
    case .missingMethod:
      let t = object.typeName
      return .typeError("'\(t)' object does not support item deletion")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
