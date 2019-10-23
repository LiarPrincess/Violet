// In CPython:
// Objects -> typeobject.c

// TODO: Heaptype
// TODO: PyType_Ready(PyTypeObject *type)

// swiftlint:disable file_length

internal class PyTypeWeakRef {

  fileprivate weak var value: PyType?

  fileprivate init(_ value: PyType) {
    self.value = value
  }
}

internal final class PyType: PyObject, AttributesOwner {

  internal static let doc: String = """
    type(object_or_name, bases, dict)
    type(object) -> the object's type
    type(name, bases, dict) -> a new type
    """

  internal let _name: String
  internal let _bases: [PyType]
  internal var _mro:   [PyType]
  internal var _subclasses: [PyTypeWeakRef] = []
  internal let _attributes = Attributes()

  internal var attributes: Attributes {
    return self._attributes
  }

  // Special hack for cyclic referency
  private unowned let _context: PyContext
  override internal var context: PyContext {
    return self._context
  }

  // MARK: - Init

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc:  String?,
                            type: PyType,
                            base: PyType) {
    let mro = PyType.linearizeMRO(baseClass: base)
    self.init(context, name: name, doc: doc, type: type, mro: mro)
  }

  internal convenience init(_ context: PyContext,
                            name: String,
                            doc:  String?,
                            type: PyType,
                            mro:  MRO) {
    self.init(context, name: name, doc: doc, mro: mro)
    self.setType(to: type)
  }

  // MARK: - Unsafe `objectType` and `typeType` init

  /// Unsafe init without `type` property filled.
  private init(_ context: PyContext, name: String, doc: String?, mro: MRO?) {
    self._name = name
    self._bases = mro?.baseClasses ?? []
    self._mro = [] // temporary, until we get to 2nd phase (we need to use self)
    self._context = context

    super.init()

    // proper mro (with self at 1st place)
    if let mro = mro {
      self._mro = [self] + mro.resolutionOrder

      for base in mro.baseClasses {
        base._subclasses.append(PyTypeWeakRef(self))
      }
    } else {
      self._mro = [self]
    }

    if let doc = self.getDocWithoutSignature(doc) {
      self._attributes["__doc__"] = context._string(doc)
    } else {
      self._attributes["__doc__"] = context._none
    }
  }

  /// NEVER EVER use this function!
  /// This is a reserved for `objectType` and `typeType`.
  internal static func initWithoutType(_ context: PyContext,
                                       name: String,
                                       doc:  String,
                                       base: PyType?) -> PyType {
    let mro = base.map(PyType.linearizeMRO)
    return PyType(context, name: name, doc: doc, mro: mro)
  }

  /// static const char *
  /// _PyType_DocWithoutSignature(const char *name, const char *internal_doc)
  private func getDocWithoutSignature(_ doc: String?) -> String? {
    guard let doc = doc else {
      return nil
    }

    let signatureEndMarker = ")\n--\n\n"
    let signatureEnd = doc.range(of: signatureEndMarker)?.upperBound
    return signatureEnd.map { doc.suffix(from: $0) }.map(String.init)
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter = setName
  internal func getName() -> String {
    switch self._name.lastIndex(of: ".") {
    case let .some(index):
      return String(self._name.suffix(from: index))
    case .none:
      return self._name
    }
  }

  internal func setName(_ value: PyObject) -> PyResult<()> {
    return .error(.typeError("can't set \(self._name).__name__"))
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter = setQualname
  internal func getQualname() -> String {
    return self.getName()
  }

  internal func setQualname(_ value: PyObject) -> PyResult<()> {
    return .error(.typeError("can't set \(self._name).__qualname__"))
  }

  // MARK: - Module

  internal enum GetModuleResult {
    case external(String)
    case builtins
  }

  // sourcery: pyproperty = __module__, setter = setModule
  internal func getModule() -> String {
    switch self.getModuleRaw() {
    case let .external(e): return e
    case .builtins: return "__builtins__"
    }
  }

  internal func getModuleRaw() -> GetModuleResult {
    if let dotIndex = self._name.firstIndex(of: ".") {
      return .external(String(self._name.prefix(upTo: dotIndex)))
    }

    return .builtins
  }

  internal func setModule(_ value: PyObject) -> PyResult<()> {
    return .error(.typeError("can't set \(self._name).__module__"))
  }

  // MARK: - Base

  // sourcery: pyproperty = __bases__, setter = setBases
  internal func getBases() -> [PyType] {
    return self._bases
  }

  internal func setBases(_ value: PyObject) -> PyResult<()> {
    return .error(.typeError("can't set \(self._name).__bases__"))
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func dict() -> Attributes {
    return self._attributes
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    switch self.type.getModuleRaw() {
    case .builtins:
      return "<class '\(self._name)'>"
    case let .external(module):
      return "<class '\(module).\(self._name)'>"
    }
  }

  // MARK: - Subtypes

  internal func isSubtype(of type: PyType) -> Bool {
    return self._mro.contains { $0 === type }
  }

  // sourcery: pymethod = __subclasses__
  internal func subclasses() -> [PyType] {
    var result = [PyType]()
    for subclassRef in self._subclasses {
      if let subclass = subclassRef.value {
        result.append(subclass)
      }
    }
    return result
  }

  // sourcery: pymethod = __instancecheck__
  internal func isInstance(of type: PyObject) -> PyResult<Bool> {
    guard let type = type as? PyType else {
      return .error(
        .typeError("isinstance() arg 2 must be a type or tuple of types")
      )
    }

    if self.type === type || self.type.isSubtype(of: type) {
      return .value(true)
    }

    // Add:
    // abstract.c -> recursive_isinstance(PyObject *inst, PyObject *cls) ->
    // retval = _PyObject_LookupAttrId(inst, &PyId___class__, &icls);
    fatalError()
  }

  // sourcery: pymethod = __subclasscheck__
  internal func isSubclass(of type: PyObject) -> PyResult<Bool> {
    guard let type = type as? PyType else {
      return .error(
        .typeError("issubclass() arg 2 must be a class or tuple of classes")
      )
    }

    return .value(self.isSubtype(of: type))
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    return self.getAttribute(name: nameString.value)
  }

  internal func getAttribute(name: String) -> PyResult<PyObject> {
    let metaType = self.type
    let metaAttribute = metaType.lookup(name: name)
    var metaGet: PyObject?

    // Look for the attribute in the metatype
    if let metaAttribute = metaAttribute {
      metaGet = metaAttribute.type.lookup(name: "__get__")
      // TODO: Also check if 'PyDescr_IsData(meta_attribute))'
      if let metaGet = metaGet {
        let args = [metaAttribute, self, metaType]
        return self.context.call(metaGet, args: args)
      }
    }

    // No data descriptor found on metatype. Look in __dict__ of this type and its bases
    if let attribute = self.lookup(name: name) {
      if let localGet = attribute.type.lookup(name: "__get__") {
        let args = [attribute, nil, self]
        return self.context.call(localGet, args: args)
      }

      return .value(attribute)
    }

    // No attribute found in __dict__ (or bases): use the descriptor from the metatype
    if let metaGet = metaGet {
      let args = [metaAttribute, self, metaType]
      return self.context.call(metaGet, args: args)
    }

    // If an ordinary attribute was found on the metatype, return it now
    if let metaAttribute = metaAttribute {
      return .value(metaAttribute)
    }

    return .error(
      .attributeError("type object '\(self.typeName)' has no attribute '\(name)'")
    )
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject) -> PyResult<()> {
    return .error(
      .typeError("can't set attributes of built-in/extension type '\(self.typeName)'")
    )
  }

  internal func setAttribute(name: String, value: PyObject) -> PyResult<()> {
    return .error(
      .typeError("can't set attributes of built-in/extension type '\(self.typeName)'")
    )
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<()> {
    return self.setAttribute(name: name, value: self.context.none)
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  /// __dir__ for type objects: returns __dict__ and __bases__.
  ///
  /// We deliberately don't suck up its __class__, as methods belonging to the
  /// metaclass would probably be more confusing than helpful.
  internal func dir() -> DirResult {
    var result = DirResult()
    self.mergeClassDict(type: self, into: &result)
    return result
  }

  private func mergeClassDict(type: PyType, into result: inout DirResult) {
    result.append(contentsOf: self._attributes.keys)

    for base in self.getBases() {
      self.mergeClassDict(type: base, into: &result)
    }
  }

  // MARK: - Helpers

  /// Internal API to look for a name through the MRO.
  ///
  /// PyObject *
  /// _PyType_Lookup(PyTypeObject *type, PyObject *name)
  internal func lookup(name: String) -> PyObject? {
    for base in self._mro {
      if let result = base._attributes[name] {
        return result
      }
    }

    return nil
  }
}
