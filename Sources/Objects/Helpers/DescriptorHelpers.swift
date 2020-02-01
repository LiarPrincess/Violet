// Run this:
// >>> class MyProp:
// ...     def __init__(self, method): pass
// ...     def __get__(self, instance, klass):
// ...             print('instance:', instance)
// ...             print('klass:', klass)
// ...             return 7

// >>> class C:
// ...     def __init__(self, x): self.__x = x
// ...     @MyProp
// ...     def x(self): return self.__x

// >>> c = C(4)
// >>> c.x          <-- will call '__get__' on 'MyProp'
// instance: <__main__.C object at 0x1022f33c8>
// klass: <class '__main__.C'>
// 7

// >>> C.x          <-- will call '__get__' on 'MyProp'
// instance: None
// klass: <class '__main__.C'>
// 7

// MARK: - Marker

/// If descriptor is called on a class then this value will be used
/// as a `object` parameter.
internal var descriptorStaticMarker: PyObject {
  return Py.none
}

extension PyObject {

  /// If descriptor is called on a class then this value will be used
  /// as a `object` parameter.
  internal var isDescriptorStaticMarker: Bool {
    return self is PyNone
  }
}

// MARK: - Get

// It has to be class because it is a very common pattern to check `self.isData`
// after creation. Since this property is lazy it would be mutation
// and then we would have to declare descriptor as `var` which is ugly.
internal class GetDescriptor {

  /// Object on which this descriptor should be called.
  private let owner: PyObject
  /// Descriptor object (the one with get/set/del methods).
  private let descriptor: PyObject

  /// `__get__` method on `self.descriptor`.
  private let get: PyObject
  /// `__set__` method on `self.descriptor`.
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
    let owner = withOwner ? self.owner : descriptorStaticMarker
    let args = [self.descriptor, owner, self.owner.type]

    switch Py.call(callable: self.get, args: args) {
    case .value(let r):
      return .value(r)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
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
  /// `__set__` method on `self.descriptor`.
  private var set: PyObject

  private init(owner: PyObject, descriptor: PyObject, set: PyObject) {
    self.owner = owner
    self.descriptor = descriptor
    self.set = set
  }

  internal func call(value: PyObject?) -> PyResult<PyObject> {
    let args = [self.descriptor, self.owner, value ?? Py.none]

    switch Py.call(callable: self.set, args: args) {
    case .value(let r):
      return .value(r)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
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
