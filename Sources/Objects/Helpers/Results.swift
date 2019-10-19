public enum GetAttributeResult {
  case value(PyObject)
  case attributeError(String)
}

public enum DelAttributeResult {
  case value(PyObject)
  case attributeError(String)
}
