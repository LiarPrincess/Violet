extension Builtins {

  // MARK: - Get

  /// PyObject_GetItem
  public func getItem(_ object: PyObject,
                      at index: PyObject) -> PyResult<PyObject> {
    if let owner = object as? __getitem__Owner {
      return owner.getItem(at: index)
    }

    switch self.callMethod(on: object, selector: "__getitem__", arg: index) {
    case .value(let r):
      return .value(r)
    case .notImplemented,
         .noSuchMethod:
      return .typeError("'\(object.typeName)' object is not subscriptable")
    case .error(let e),
         .methodIsNotCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Set

  /// PyObject_SetItem
  public func setItem(_ object: PyObject,
                      at index: PyObject,
                      value: PyObject) -> PyResult<PyNone> {
    if let owner = object as? __setitem__Owner {
      return owner.setItem(at: index, to: value)
    }

    switch self.callMethod(on: object, selector: "__setitem__", arg: value) {
    case .value:
      return .value(self.none)
    case .notImplemented,
         .noSuchMethod:
      return .typeError("'\(object.typeName)' object does not support item assignment")
    case .error(let e),
         .methodIsNotCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Delete

  /// PyObject_DelItem
  public func deleteItem(_ object: PyObject,
                         at index: PyObject) -> PyResult<PyNone> {
    if let owner = object as? __delitem__Owner {
      return owner.delItem(at: index)
    }

    switch self.callMethod(on: object, selector: "__delitem__") {
    case .value:
      return .value(self.none)
    case .notImplemented,
         .noSuchMethod:
      return .typeError("'\(object.typeName)' object does not support item deletion")
    case .error(let e),
         .methodIsNotCallable(let e):
      return .error(e)
    }
  }
}
