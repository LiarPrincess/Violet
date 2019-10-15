// In CPython:
// Objects -> moduleobject.c

// sourcery: pytype = nodule
internal final class PyModule: PyObject {

  internal static let doc: String = """
    module(name, doc=None)
    --
    Create a module object.
    The name must be a string; the optional doc argument can have any type.
    """

  internal var dict: [String:PyObject] = [:]

  internal init(_ context: PyContext, name: PyObject, doc: PyObject?) {
    self.dict["__name__"] = name
    self.dict["__doc__"] = doc
    self.dict["__package__"] = context._none
    self.dict["__loader__"] = context._none
    self.dict["__spec__"] = context._none

    #warning("Add to PyContext")
    super.init()
  }

  // MARK: - String

  internal func repr() -> String {
    return "'\(self.name)'"
  }

  private var name: String {
    guard let obj = self.dict["__name__"] else {
      return "module"
    }

    guard let str = obj as? PyString else {
      return self.context._repr(value: obj)
    }

    return str.value
  }
}
