internal protocol SubscriptTypeClass: LengthTypeClass {
  func `subscript`(owner: PyObject, index: PyObject) throws -> PyObject
}

internal protocol SubscriptAssignTypeClass: LengthTypeClass {
  func subscriptAssign(owner: PyObject, index: PyObject, value: PyObject) throws
}
