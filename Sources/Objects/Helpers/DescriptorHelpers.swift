// MARK: - Get

// It has to be class because it is a very common pattern to check `self.isData`
// after creation.
// This mutation and it is not ergonomic to use it as struct.
internal class GetDescriptor {

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

  private init(owner: PyObject, descriptor: PyObject, get: PyObject) {
    self.owner = owner
    self.descriptor = descriptor
    self.get = get
  }

  internal func call(withOwner: Bool = true) -> PyResult<PyObject> {
    let owner: PyObject? = withOwner ? self.owner : nil
    let args = [self.descriptor, owner, self.owner.type]

    let context = self.descriptor.context
    return context.call(self.get, args: args)
  }

  // MARK: Factory

  /// Get 'get' descriptor with given `name` from `object`.
  internal static func get(object: PyObject,
                           attributeName: String) -> GetDescriptor? {
    // Do we even have such attribute?
    guard let attribute = object.type.lookup(name: attributeName) else {
      return nil
    }

    return GetDescriptor.get(object: object, attribute: attribute)
  }

  /// Get 'get' descriptor with given `attribute` from `object`.
  internal static func get(object: PyObject,
                           attribute: PyObject) -> GetDescriptor? {
    // No getter -> no descriptor
    guard let get = attribute.type.lookup(name: "__get__") else {
      return nil
    }

    // We found ourselves a fully functioning descriptor!
    return GetDescriptor(owner: object, descriptor: attribute, get: get)
  }
}

// MARK: - Set

internal class SetDescriptor {

  /// Object on which this descriptor should be called.
  private let owner: PyObject
  /// Descriptor object (the one with get/set/del methods).
  private let descriptor: PyObject
  /// Set method on `self.descriptor`.
  private var set: PyObject

  private init(owner: PyObject, descriptor: PyObject, set: PyObject) {
    self.owner = owner
    self.descriptor = descriptor
    self.set = set
  }

  internal func call(value: PyObject?) -> PyResult<PyObject> {
    let context = self.descriptor.context
    let args = [self.descriptor, self.owner, value]
    return context.call(self.set, args: args)
  }

  // MARK: Factory

  internal static func get(object: PyObject,
                           attributeName: String) -> SetDescriptor? {
    // Do we even have such attribute?
    guard let attribute = object.type.lookup(name: attributeName) else {
      return nil
    }

    // No setter -> no descriptor
    guard let set = attribute.type.lookup(name: "__set__") else {
      return nil
    }

    return SetDescriptor(owner: object, descriptor: attribute, set: set)
  }
}
