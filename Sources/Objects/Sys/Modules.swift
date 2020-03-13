import Core

public final class Modules {

  public private(set) lazy var object = PyDict()

  internal func insert(name: IdString, module: PyModule) {
    self.object.set(id: name, to: module)
  }

  internal func get(name: IdString) -> PyObject? {
    return self.object.get(id: name)
  }

  internal func get(name: PyObject) -> PyDict.GetResult {
    return self.object.get(key: name)
  }
}
