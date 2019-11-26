// It has to be class because it is a very common pattern to check `self.isData`
// after creation.
// This mutation and it is not ergonomic to use it as struct.
internal class Descriptor {

  /// Object on which this descriptor should be called.
  private let owner: PyObject
  /// Descriptor object (the one with get/set/del methods).
  private let descriptor: PyObject

  /// Get method on `self.descriptor`.
  private let get: PyObject
  /// Set method on `self.descriptor`.
  private lazy var set = self.descriptor.type.lookup(name: "__set__")

  /// define PyDescr_IsData(d) (Py_TYPE(d)->tp_descr_set != NULL)
  internal var isData: Bool {
    return self.set != nil
  }

  fileprivate init(owner: PyObject, descriptor: PyObject, get: PyObject) {
    self.owner = owner
    self.descriptor = descriptor
    self.get = get
  }

  internal func callGet() -> PyResult<PyObject> {
    let context = self.descriptor.context
    let args = [self.descriptor, self.owner, self.owner.type]
    return context.call(self.get, args: args)
  }
}

internal enum DescriptorHelper {

  /// Get descriptor with given `name` from `object`.
  internal static func get(from object: PyObject, name: String) -> Descriptor? {
    // Do we even have such attribute?
    guard let attribute = object.type.lookup(name: name) else {
      return nil
    }

    return DescriptorHelper.fromAttribute(object: object, attribute: attribute)
  }

  internal static func fromAttribute(object: PyObject,
                                     attribute: PyObject) -> Descriptor? {
    // No getter -> not a descriptor
    guard let get = attribute.type.lookup(name: "__get__") else {
      return nil
    }

    // We found ourselves a fully functioning descriptor!
    return Descriptor(owner: object, descriptor: attribute, get: get)
  }
}
