// cSpell:ignore subscriptable

extension Py {

  // MARK: - Get

  /// PySequence_GetItem
  public func getItem(object: PyObject, index: Int) -> PyResult {
    let int = self.newInt(index).asObject
    return self.getItem(object: object, index: int)
  }

  /// PyObject_GetItem
  public func getItem(object: PyObject, index: PyObject) -> PyResult {
    if let result = PyStaticCall.__getitem__(self, object: object, index: index) {
      return result
    }

    switch self.callMethod(object: object, selector: .__getitem__, arg: index) {
    case .value(let r):
      return .value(r)
    case .missingMethod:
      return .typeError(self, message: "'\(object.typeName)' object is not subscriptable")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Set

  /// PyObject_SetItem
  public func setItem(object: PyObject,
                      index: PyObject,
                      value: PyObject) -> PyResult {
    if let result = PyStaticCall.__setitem__(self,
                                             object: object,
                                             index: index,
                                             value: value) {
      return result
    }

    let args = [index, value]
    switch self.callMethod(object: object, selector: .__setitem__, args: args) {
    case .value:
      return .none(self)
    case .missingMethod:
      let t = object.typeName
      return .typeError(self, message: "'\(t)' object does not support item assignment")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Delete

  /// PyObject_DelItem
  public func deleteItem(object: PyObject, index: PyObject) -> PyResult {
    if let result = PyStaticCall.__delitem__(self, object: object, index: index) {
      return result
    }

    switch self.callMethod(object: object, selector: .__delitem__, arg: index) {
    case .value:
      return .none(self)
    case .missingMethod:
      let t = object.typeName
      return .typeError(self, message: "'\(t)' object does not support item deletion")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
