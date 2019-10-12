private class PyTypeWeakRef {

  fileprivate weak var value: PyType?

  fileprivate init(_ value: PyType) {
    self.value = value
  }
}

internal class PyType: PyObject, DictOwnerTypeClass {

  internal let name: String
  private let doc: String? = nil
  private var subclasses: [PyTypeWeakRef] = []

  /// Method Resolution Order
  /// https://www.python.org/download/releases/2.3/mro/
  private let mro: [PyType] = []

  internal var dict: [String:PyObject] = [:]

  private unowned let _context: PyContext
  override internal var context: PyContext {
    return self._context
  }

  // MARK: - Init

  internal convenience init(_ context: PyContext,
                            name: String,
                            type: PyType,
                            base: PyType?) {
    self.init(context,
              name: name,
              type: type,
              bases: base.map { [$0] } ?? [])
  }

  internal init(_ context: PyContext,
                name: String,
                type: PyType,
                bases: [PyType]) {
    // creation of bases is complicated! add self at [0]
   // TODO: Do we have custom mro? (mro_invoke(PyTypeObject *type))
   // TODO: PyErr_SetString(PyExc_TypeError, "bases must be types");
   //    self.mro = PyClass.lineariseMRO(bases)

    self.name = name
    self._context = context
    super.init(type: context.types.type)
  }

  // MARK: - Unsafe `objectType` and `typeType`

  private init(_ context: PyContext, name: String, base: PyType?) {
    self.name = name
    self._context = context
    super.init()
  }

  /// NEVER EVER use this function!
  /// This is a reserved for `objectType` and `typeType`.
  internal static func createTypeWithoutTypeProperty(
    _ context: PyContext,
    name: String,
    base: PyType?) -> PyType {

    return PyType(context, name: name, base: base)
  }

  /// NEVER EVER use this function!
  /// This is a reserved for `objectType` and `typeType`.
  internal static func setTypeProperty(
    type: PyType,
    setting typeType: PyType) {

    assert(type.type == nil, "Type is already assigned!")
    type.setType(to: typeType)
  }

  // MARK: - Subtype

  internal func isSubtype(_ type: PyObject) -> Bool {
    guard let type = type as? PyType else {
      fatalError()
    }

    return self.mro.contains { $0 === type }
  }

  // MARK: - Bases

  internal var bases: [PyType] {
    return []
  }

  // TODO: Check _PyType_Lookup(PyTypeObject *type, PyObject *name)

  // MARK: - Qualname

  internal var qualname: String {
    fatalError()
  }

  /// PyObject *
  /// _PyType_Lookup(PyTypeObject *type, PyObject *name)
  internal func lookup(name: String) -> PyObject {
    fatalError()
  }

  // MARK: - Module

  internal enum Module {
    case external(String)
    case builtins
  }

  internal var module: Module {
    if let dictValue = self.dict["__module__"] {
      if let str = dictValue as? PyString {
        return .external(str.value)
      }

      return .external(self.context._repr(value: dictValue))
    }

    if let dotIndex = self.name.firstIndex(of: ".") {
      return .external(String(self.name.prefix(upTo: dotIndex)))
    }

    return .builtins
  }

  // MARK: - MRO

  /// It will not take into account `self` class (which should be 1st in MRO).
  private static func lineariseMRO(_ baseClasses: [PyType]) -> PyResult<[PyType]> {
    // No base classes? Empty MRO.
    if baseClasses.isEmpty {
      return .value([])
    }

    // Fast path: if there is a single base, constructing the MRO is trivial.
    if baseClasses.count == 1 {
      return .value(baseClasses[0].mro)
    }

    // Sanity check.
    if let duplicate = getDuplicateBaseClassName(baseClasses) {
      return .error(.typeError("duplicate base class \(duplicate)"))
    }

    // Perform C3 linearisation.
    var result = [PyType]()
    let mros = baseClasses.map { $0.mro } + [baseClasses]

    while hasAnyClassRemaining(mros) {
      guard let base = self.getNextBase(mros) else {
        return .error(
          .valueError(
            "Cannot create a consistent method resolution order (MRO) for bases"
          )
        )
      }

      result.append(base)

      for var m in mros {
        m.removeAll { $0 === base }
      }
    }

    return .value(result)
  }

  private static func getDuplicateBaseClassName(_ baseClasses: [PyType]) -> String? {
    var processedNames = Set<String>()

    for base in baseClasses {
      let name = base.name

      if processedNames.contains(name) {
        return name
      }

      processedNames.insert(name)
    }

    return nil
  }

  private static func hasAnyClassRemaining(_ mros: [[PyType]]) -> Bool {
    return mros.contains { classList in
      classList.any
    }
  }

  private static func getNextBase(_ mros: [[PyType]]) -> PyType? {
    for baseClassMro in mros {
      guard let head = baseClassMro.first else {
        continue
      }

      let anyTailContains = mros.contains { classList in
        let tail = classList.dropFirst()
        return tail.contains { $0 === head }
      }

      if anyTailContains {
        continue
      }

      return head
    }

    return nil
  }
}
