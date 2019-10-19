// In CPython:
// Objects -> typeobject.c

// TODO: Type
//__abstractmethods__
//__call__
//__repr__
//__getattribute__
//__delattr__
//__setattr__
//__dir__
//__init__
//__sizeof__
//__instancecheck__
//__subclasscheck__
//__subclasses__
//mro

private class PyTypeWeakRef {

  fileprivate weak var value: PyType?

  fileprivate init(_ value: PyType) {
    self.value = value
  }
}

// sourcery: pytype = type
internal class PyType: PyObject, DictOwnerTypeClass {

  internal static let doc: String = """
    type(object_or_name, bases, dict)
    type(object) -> the object's type
    type(name, bases, dict) -> a new type
    """

  internal var name: String
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

  // MARK: - Name

  internal func getName() -> String {
    return self.name
  }

  internal func setName(_ value: PyObject) -> PyResult<()> {
    guard let valueStr = value as? PyString else {
      let typeName = value.type.name
      return .error(
        .typeError(
          "can only assign string to \(self.name).__name__, not '\(typeName)'"
        )
      )
    }

    self.name = valueStr.value
    return .value(())
  }

  // MARK: - Qualname

  internal func getQualname() -> String {
//    if let result = self.dict["__qualname__"] {
//      return result
//    }
    fatalError()
  }

  internal func setQualname(_ value: PyObject) -> PyResult<()> {
    guard let valueStr = value as? PyString else {
      let typeName = value.type.name
      return .error(
        .typeError(
          "can only assign string to \(self.name).__qualname__, not '\(typeName)'"
        )
      )
    }

    fatalError()
  }

  // MARK: - Module

  internal enum Module {
    case external(String)
    case builtins
  }

  internal func getModule() -> Module {
    // type_module(PyTypeObject *type, void *context)
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

  internal func setModule(_ value: PyObject) -> PyResult<()> {
    // type_set_module(PyTypeObject *type, PyObject *value, void *context)
    fatalError()
  }

  // MARK: - Bases

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    switch self.type.getModule() {
    case .builtins:
      return "<class '\(self.name)'>"
    case let .external(module):
      return "<class '\(module).\(self.name)'>"
    }
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

  /// PyObject *
  /// _PyType_Lookup(PyTypeObject *type, PyObject *name)
  internal func lookup(name: String) -> PyObject {
    fatalError()
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
