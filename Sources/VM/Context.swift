import Objects

// MARK: - Context

internal class Context {

  internal var number: PyNumberType
  internal var unicode: PyUnicodeType

  init() {
    self.number = PyNumberType()
    self.unicode = PyUnicodeType()
  }
}

// MARK: - Owner

internal protocol ContextOwner {
  var context: Context { get }
}

extension ContextOwner {

  internal var Py_True: PyObject {
    return PyObject()
  }

  internal var Py_False: PyObject {
    return PyObject()
  }

  internal var Py_None: PyObject {
    return PyObject()
  }

  internal var numberType: PyNumberType {
    return self.context.number
  }

  internal var unicodeType: PyUnicodeType {
    return self.context.unicode
  }
}
