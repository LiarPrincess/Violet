// Docs:
// https://docs.python.org/3/howto/descriptor.html

// Practical example:
// >>> class MyProp:
// ...     def __init__(self, method): pass
// ...     def __get__(self, instance, klass): # klass because we Java now
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
// instance: None   < called on type, None (marker) will we used as instance
// klass: <class '__main__.C'>
// 7

// MARK: - Marker

extension Py {

  /// If descriptor is called on a class/type then this value will be used
  /// as a `object/instance` parameter.
  internal var descriptorStaticMarker: PyObject {
    return self.none.asObject
  }

  /// If descriptor is called on a class/type then this value will be used
  /// as a `object/instance` parameter.
  internal func isDescriptorStaticMarker(_ object: PyObject) -> Bool {
    return self.cast.isNone(object)
  }
}

// MARK: - Get

// SEE COMMENT AT THE TOP OF THIS FILE FOR AN EXPLANATION OF WHAT A DESCRIPTOR IS!
//
// It is a class because it is a very common pattern to check `self.isData`
// after creation. Since this property is lazy, it would be a mutation
// and then we would have to declare descriptor as `var` which is ugly.
internal class GetDescriptor {

  private let py: Py
  /// Object on which this descriptor should be called.
  private let object: PyObject
  /// Type to use when calling descriptor
  private let type: PyType
  /// Descriptor object (the one with get/set/del methods).
  private let descriptor: PyObject

  /// `__get__` method on `self.descriptor`.
  private let get: PyObject
  /// `__set__` method on `self.descriptor`.
  private lazy var set: PyObject? = {
    let setter = self.descriptor.type.mroLookup(self.py, name: .__set__)
    return setter?.object
  }()

  /// define PyDescr_IsData(d) (Py_TYPE(d)->tp_descr_set != NULL)
  internal var isData: Bool {
    return self.set != nil
  }

  /// Create a (potential) descriptor for static property.
  ///
  /// Most of the time this is not what you want to use!
  /// You probably want `init?(object:attribute:)`.
  internal convenience init?(_ py: Py, type: PyType, attribute: PyObject) {
    // - 'object: None' - to provide static binding
    //   ('__get__' will be called with 'None' as 2nd arg)
    // - 'type: type' - so we know the actual desired type
    //   (because we can't get it from object - it is 'None')
    let object = py.descriptorStaticMarker
    self.init(py, object: object, type: type, attribute: attribute)
  }

  /// Create a (potential) descriptor for instance property.
  internal convenience init?(_ py: Py, object: PyObject, attribute: PyObject) {
    self.init(py, object: object, type: object.type, attribute: attribute)
  }

  /// Create a (potential) descriptor.
  ///
  /// Most of the time this is not what you want to use!
  /// You probably want `init?(object:attribute:)`.
  internal init?(_ py: Py, object: PyObject, type: PyType, attribute: PyObject) {
    // No getter -> no descriptor
    guard let getLookup = attribute.type.mroLookup(py, name: .__get__) else {
      return nil
    }

    // We found ourselves a fully functioning descriptor!
    self.py = py
    self.object = object
    self.type = type
    self.descriptor = attribute
    self.get = getLookup.object
  }

  internal func call() -> PyResult {
    let args = [self.descriptor, self.object, self.type.asObject]
    switch self.py.call(callable: self.get, args: args) {
    case .value(let r):
      return .value(r)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}

// MARK: - Set

// SEE COMMENT AT THE TOP OF THIS FILE FOR AN EXPLANATION OF WHAT A DESCRIPTOR IS!
//
// It is a class because 'GetDescriptor' also is (and we like symmetry).
internal class SetDescriptor {

  private let py: Py
  /// Object on which this descriptor should be called.
  private let object: PyObject
  /// Descriptor object (the one with get/set/del methods).
  private let descriptor: PyObject
  /// `__set__` method on `self.descriptor`.
  private var set: PyObject

  internal init?(_ py: Py, object: PyObject, attributeName: PyString) {
    // Do we even have such attribute?
    let attribute: PyObject
    switch object.type.mroLookup(py, name: attributeName) {
    case .value(let l):
      attribute = l.object
    case .notFound,
         .error:
      return nil
    }

    // No setter -> no descriptor
    guard let setLookup = attribute.type.mroLookup(py, name: .__set__) else {
      return nil
    }

    self.py = py
    self.object = object
    self.descriptor = attribute
    self.set = setLookup.object
  }

  internal func call(value: PyObject?) -> PyResult {
    let none = self.py.none.asObject
    let args = [self.descriptor, self.object, value ?? none]

    switch self.py.call(callable: self.set, args: args) {
    case .value(let r):
      return .value(r)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
