import VioletCore

// swiftlint:disable file_length
// cSpell:ignore typeobject

// In CPython:
// Objects -> typeobject.c
// https://docs.python.org/3/c-api/typeobj.html

internal func ===(lhs: PyType, rhs: PyType) -> Bool {
  return lhs.ptr === rhs.ptr
}

// sourcery: pytype = type, isDefault, hasGC, isBaseType, isTypeSubclass
// sourcery: instancesHave__dict__
public struct PyType: PyObjectMixin, HasCustomGetMethod {

  // sourcery: pytypedoc
  internal static let doc = """
    type(object_or_name, bases, dict)
    type(object) -> the object's type
    type(name, bases, dict) -> a new type
    """

  // Just a reminder:
  //             | Type     | Base       | MRO
  // object type | typeType | nil        | [self]
  // type type   | typeType | objectType | [self, objectType]
  // normal type | typeType | objectType | [self, (...), objectType]

  // MARK: - Properties

  public typealias DebugFn = (RawPtr) -> String
  public typealias DeinitializeFn = (RawPtr) -> Void

  // sourcery: includeInLayout
  internal var name: String {
    get { self.namePtr.pointee }
    nonmutating set { self.namePtr.pointee = newValue }
  }

  // sourcery: includeInLayout
  internal var qualname: String {
    get { self.qualnamePtr.pointee }
    nonmutating set { self.qualnamePtr.pointee = newValue }
  }

  // sourcery: includeInLayout
  internal var base: PyType? { self.basePtr.pointee }
  // sourcery: includeInLayout
  internal var bases: [PyType] { self.basesPtr.pointee }
  // sourcery: includeInLayout
  internal var mro: [PyType] { self.mroPtr.pointee }
  // sourcery: includeInLayout
  internal var subclasses: [PyType] { self.subclassesPtr.pointee }

  // sourcery: includeInLayout
  /// Swift storage (layout).
  /// See `PyType.MemoryLayout` documentation for details.
  internal var layout: MemoryLayout { self.layoutPtr.pointee }

  // sourcery: includeInLayout
  /// Methods needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal var staticMethods: PyStaticCall.KnownNotOverriddenMethods {
    self.staticMethodsPtr.pointee
  }

  // sourcery: includeInLayout
  internal var debugFn: DebugFn { self.debugFnPtr.pointee }
  // sourcery: includeInLayout
  internal var deinitialize: DeinitializeFn { self.deinitializePtr.pointee }

  /// `PyObjectHeader.flags` that are only available on `type` instances.
  internal var typeFlags: TypeFlags {
    get { return TypeFlags(objectFlags: self.flags) }
    set { self.flags.setCustomFlags(from: newValue.objectFlags) }
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           name: String,
                           qualname: String,
                           flags: PyType.TypeFlags,
                           base: PyType?,
                           bases: [PyType],
                           mroWithoutSelf: [PyType],
                           subclasses: [PyType],
                           layout: PyType.MemoryLayout,
                           staticMethods: PyStaticCall.KnownNotOverriddenMethods,
                           debugFn: @escaping PyType.DebugFn,
                           deinitialize: @escaping PyType.DeinitializeFn) {
    if let b = base {
      assert(mro.contains { $0 === b })
    }

    let mro = [self] + mroWithoutSelf
    self.header.initialize(py, type: type)
    self.namePtr.initialize(to: name)
    self.qualnamePtr.initialize(to: qualname)
    self.basePtr.initialize(to: base)
    self.basesPtr.initialize(to: bases)
    self.mroPtr.initialize(to: mro)
    self.subclassesPtr.initialize(to: subclasses)
    self.layoutPtr.initialize(to: layout)
    self.staticMethodsPtr.initialize(to: staticMethods)
    self.debugFnPtr.initialize(to: debugFn)
    self.deinitializePtr.initialize(to: deinitialize)

    self.flags.setCustomFlags(from: typeFlags.objectFlags)

    for base in bases {
      base.subclassesPtr.pointee.append(self)
    }
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyType(ptr: ptr)
    return "PyType(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // We use mirrors to create description.
  //  public var customMirror: Mirror {
  //    let base = self.base?.name ?? "nil"
  //    let bases = self.bases.map { $0.name }
  //    let mro = self.mro.map { $0.name }
  //
  //    return Mirror(
  //      self,
  //      children: [
  //        "name": self.name,
  //        "qualname": self.qualname,
  //        "typeFlags": self.typeFlags,
  //        "base": base,
  //        "bases": bases,
  //        "mro": mro
  //      ]
  //    )
  //  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter
  internal static func __name__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let name = zelf.getNameString()
    let result = py.intern(string: name)
    return .value(result.asObject)
  }

  // TODO: Rename: func getNameWithoutModule (has to be func for symmetry w. module)
  internal func getNameString() -> String {
    if self.typeFlags.isHeapType {
      return self.name
    }

    if let moduleDotIndex = self.name.lastIndex(of: ".") {
      let name = self.name.suffix(from: moduleDotIndex)
      return String(name)
    }

    return self.name
  }

  internal static func __name__(_ py: Py,
                                zelf: PyObject,
                                value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let object: PyObject
    switch zelf.checkSetSpecialAttribute(py, name: .__name__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    guard let string = py.cast.asString(object) else {
      let msg = "can only assign string to \(zelf.name).__name__, not '\(object.typeName)'"
      return .typeError(py, message: msg)
    }

    zelf.name = string.value
    return .none(py)
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter
  internal static func getQualname(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let qualname = zelf.getQualnameString()
    let result = py.intern(string: qualname)
    return .value(result.asObject)
  }

  internal func getQualnameString() -> String {
    if self.typeFlags.isHeapType {
      return self.qualname
    }

    return self.getNameString()
  }

  internal static func __qualname__(_ py: Py,
                                    zelf: PyObject,
                                    value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    switch zelf.setQualname(py, value: value) {
    case .value:
      return .none(py)
    case .error(let e):
      return .error(e)
    }
  }

  internal func setQualname(_ py: Py, value: PyObject?) -> PyResult<Void> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(py, name: .__qualname__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    guard let string = py.cast.asString(object) else {
      let msg = "can only assign string to \(self.name).__qualname__, not '\(object.typeName)'"
      return .typeError(py, message: msg)
    }

    self.qualname = string.value
    return .value()
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__, setter
  internal static func getDoc(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    guard let doc = zelf.__dict__.get(id: .__doc__) else {
      return .none(py)
    }

    if let descr = GetDescriptor(py, object: zelf.asObject, attribute: doc) {
      return descr.call()
    }

    return .value(doc)
  }

  internal static func __doc__(_ py: Py,
                               zelf: PyObject,
                               value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let object: PyObject
    switch zelf.checkSetSpecialAttribute(py, name: .__doc__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    zelf.__dict__.set(id: .__doc__, to: object)
    return .none(py)
  }

  /// Set `__doc__` for a builtin type.
  ///
  /// We can't do it in init because we are not allowed to use other types in init.
  /// (Which means that we would not be able to create PyString to put in dict)
  internal func setBuiltinTypeDoc(_ py: Py, value: String?) {
    let string = value.map(DocHelper.getDocWithoutSignature)

    let object: PyObject
    if let string = string {
      object = py.newString(string).asObject
    } else {
      object = py.none.asObject
    }

    self.__dict__.set(id: .__doc__, to: object)
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter
  internal static func __module__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    switch zelf.getModuleNameRaw(py) {
    case .builtins:
      let builtins = py.intern(string: "builtins")
      return .value(builtins.asObject)
    case .string(let s):
      let interned = py.intern(string: s)
      return .value(interned.asObject)
    case .pyString(let s):
      return .value(s.asObject)
    case .objectNotYetConvertedToString(let o):
      return .value(o)
    case .error(let e):
      return .error(e)
    }
  }

  internal enum ModuleName {
    case builtins
    case string(String)
    case error(PyBaseException)
  }

  internal func getModuleName(_ py: Py) -> ModuleName {
    switch self.getModuleNameRaw(py) {
    case .builtins:
      return .builtins
    case .string(let s):
      return .string(s)
    case .pyString(let s):
      return .string(s.value)
    case .objectNotYetConvertedToString(let o):
      switch py.strString(object: o) {
      case let .value(s): return .string(s)
      case let .error(e): return .error(e)
      }
    case .error(let e):
      return .error(e)
    }
  }

  private enum GetModuleNameRawResult {
    case builtins
    case string(String)
    case pyString(PyString)
    case objectNotYetConvertedToString(PyObject)
    case error(PyBaseException)
  }

  // This whole thing to try to avoid conversion for 'objectNotYetConvertedToString'.
  private func getModuleNameRaw(_ py: Py) -> GetModuleNameRawResult {
    if self.typeFlags.isHeapType {
      guard let object = self.__dict__.get(id: .__module__) else {
        let e = py.newAttributeError(message: "__module__")
        return .error(e.asBaseException)
      }

      guard let module = py.cast.asModule(object) else {
        switch py.str(object: object) {
        case let .value(s):
          return .pyString(s)
        case let .error(e):
          return .error(e)
        }
      }

      switch module.getName() {
      case let .value(name):
        return .objectNotYetConvertedToString(name)
      case let .error(e):
        return .error(e)
      }
    }

    if let dotIndex = self.name.firstIndex(of: ".") {
      let moduleName = self.name.prefix(upTo: dotIndex)
      return .string(String(moduleName))
    }

    return .builtins
  }

  internal static func __module__(_ py: Py,
                                  zelf: PyObject,
                                  value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    switch zelf.setModule(py, value: value) {
    case .value:
      return .none(py)
    case .error(let e):
      return .error(e)
    }
  }

  internal func setModule(_ py: Py, value: PyObject?) -> PyResult<Void> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(py, name: .__module__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    self.__dict__.set(id: .__module__, to: object)
    return .value()
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let result = zelf.__dict__
    return .value(result.asObject)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    switch zelf.getModuleName(py) {
    case .builtins:
      let result = "<class '\(zelf.name)'>"
      return result.toResult(py)
    case .string(let module):
      let result = "<class '\(module).\(zelf.name)'>"
      return result.toResult(py)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Base

  // sourcery: pyproperty = __base__
  internal static func __base__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    guard let base = zelf.base else {
      return .none(py)
    }

    return .value(base.asObject)
  }

  // MARK: - Bases

  // sourcery: pyproperty = __bases__, setter
  internal static func __bases__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let bases = zelf.bases.map { $0.asObject }
    let result = py.newTuple(elements: bases)
    return .value(result.asObject)
  }

  internal static func __bases__(_ py: Py,
                                 zelf: PyObject,
                                 value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    // Violet currently does not support this
    return .typeError(py, message: "can't set \(zelf.name).__bases__")
  }

  // MARK: - Mro

  // sourcery: pyproperty = __mro__
  internal static func __mro__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let mro = zelf.mro.map { $0.asObject }
    let result = py.newTuple(elements: mro)
    return .value(result.asObject)
  }

  internal static let mroDoc = """
    mro($self, /)
    --

    Return a type's method resolution order.
    """

  // sourcery: pymethod = mro, doc = mroDoc
  internal static func mro(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let mro = zelf.mro.map { $0.asObject }
    let result = py.newList(elements: mro)
    return .value(result.asObject)
  }

  // MARK: - Subtypes

  // sourcery: pymethod = __subclasscheck__
  internal static func __subclasscheck__(_ py: Py,
                                         zelf: PyObject,
                                         object: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    guard let otherType = py.cast.asType(object) else {
      return .typeError(py, message: "issubclass() arg 1 must be a class")
    }

    let bool = zelf.isSubtype(of: otherType)
    let result = py.newBool(bool)
    return .value(result.asObject)
  }

  internal func isSubtype(of type: PyType) -> Bool {
    return self.mro.contains { $0 === type }
  }

  // sourcery: pymethod = __instancecheck__
  internal static func __instancecheck__(_ py: Py,
                                         zelf: PyObject,
                                         object: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let bool = object.type.isSubtype(of: zelf)
    let result = py.newBool(bool)
    return .value(result.asObject)
  }

  // sourcery: pymethod = __subclasses__
  internal static func __subclasses__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let subclasses = zelf.subclasses.map { $0.asObject }
    let result = py.newList(elements: subclasses)
    return .value(result.asObject)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return zelf.getAttribute(py, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal func getAttribute(_ py: Py, name: PyString) -> PyResult<PyObject> {
    return self.getAttribute(py, name: name, searchDict: true)
  }

  private func getAttribute(_ py: Py,
                            name: PyString,
                            searchDict: Bool) -> PyResult<PyObject> {
    let metaAttribute: PyObject?
    let metaDescriptor: GetDescriptor?

    // Look for the attribute in the metatype
    switch self.type.mroLookup(name: name) {
    case .value(let r):
      metaAttribute = r.object
      metaDescriptor = GetDescriptor(py, object: self.asObject, attribute: r.object)
    case .notFound:
      metaAttribute = nil
      metaDescriptor = nil
    case .error(let e):
      return .error(e)
    }

    if let desc = metaDescriptor, desc.isData {
      return desc.call() // Will call '__get__' with self (PyType)
    }

    // No data descriptor found on metatype.
    // Look in '__dict__' of this type and its bases.
    if searchDict {
      switch self.mroLookup(name: name) {
      case .value(let r):
        if let descr = GetDescriptor(py, type: self, attribute: r.object) {
          return descr.call()
        }

        return .value(r.object)
      case .notFound: break
      case .error(let e): return .error(e)
      }
    }

    // No attribute found in __dict__ (or bases):
    // use the descriptor from the metatype
    if let descr = metaDescriptor {
      return descr.call() // Will call '__get__' with self (PyType)
    }

    // If an ordinary attribute was found on the metatype, return it
    if let a = metaAttribute {
      return .value(a)
    }

    let nameQuoted = name.repr().quoted
    let message = "type object '\(self.name)' has no attribute \(nameQuoted)"
    return .typeError(py, message: message)
  }

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    if let error = zelf.preventSetAttributeOnBuiltin(py) {
      return .error(error.asBaseException)
    }

    return zelf.setAttribute(py, name: name, value: value)
  }

  private func setAttribute(_ py: Py,
                            name: PyObject,
                            value: PyObject?) -> PyResult<PyObject> {
    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return self.setAttribute(py, name: n, value: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal func setAttribute(_ py: Py,
                             name: PyString,
                             value: PyObject?) -> PyResult<PyObject> {
    if let error = self.preventSetAttributeOnBuiltin(py) {
      return .error(error.asBaseException)
    }

    let object = self.asObject
    return AttributeHelper.setAttribute(py, object: object, name: name, value: value)
  }

  private func preventSetAttributeOnBuiltin(_ py: Py) -> PyTypeError? {
    if !self.typeFlags.isHeapType {
      let message = "can't set attributes of built-in/extension type '\(self.name)'"
      return py.newTypeError(message: message)
    }

    return nil
  }

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    return zelf.setAttribute(py, name: name, value: nil)
  }

  // MARK: - Get method

  internal func getMethod(_ py: Py,
                          selector: PyString,
                          allowsCallableFromDict: Bool) -> Py.GetMethodResult {
    let result = self.getAttribute(py,
                                   name: selector,
                                   searchDict: allowsCallableFromDict)

    switch result {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if py.cast.isAttributeError(e.asObject) {
        return .notFound(e)
      }

      return .error(e)
    }
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  /// __dir__ for type objects: returns __dict__ and __bases__.
  ///
  /// We deliberately don't suck up its __class__, as methods belonging to the
  /// metaclass would probably be more confusing than helpful.
  internal static func __dir__(_ py: Py, zelf: PyObject) -> PyResult<DirResult> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    return zelf.dir(py)
  }

  // Function used in other places in this module.
  internal func dir(_ py: Py) -> PyResult<DirResult> {
    var result = DirResult()

    for base in self.mro {
      if let e = result.append(py, keysFrom: base.__dict__) {
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - MRO lookup

  /// Tuple: lookup result + type on which it was found
  internal struct MroLookupResult {
    internal let object: PyObject
    /// Type on which `self.object` was found.
    internal let type: PyType
  }

  /// Internal API to look for a name through the MRO.
  ///
  /// PyObject *
  /// _PyType_Lookup(PyTypeObject *type, PyObject *name)
  internal func mroLookup(name: IdString) -> MroLookupResult? {
    for type in self.mro {
      if let object = type.__dict__.get(id: name) {
        return MroLookupResult(object: object, type: type)
      }
    }

    return nil
  }

  internal enum MroLookupByStringResult {
    case value(MroLookupResult)
    case notFound
    case error(PyBaseException)
  }

  /// Internal API to look for a name through the MRO.
  ///
  /// PyObject *
  /// _PyType_Lookup(PyTypeObject *type, PyObject *name)
  internal func mroLookup(name: PyString) -> MroLookupByStringResult {
    for type in self.mro {
      switch type.__dict__.get(key: name.asObject) {
      case .value(let o):
        return .value(MroLookupResult(object: o, type: type))
      case .notFound:
        break // not in this type, move to next one
      case .error(let e):
        return .error(e)
      }
    }

    return .notFound
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// static PyObject *
  /// type_call(PyTypeObject *type, PyObject *args, PyObject *kwds)
  internal static func __call__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf)
    }

    let object: PyObject
    switch zelf.call__new__(py, args: args, kwargs: kwargs) {
    case let .value(o):
      object = o
    case let .error(e):
      return .error(e)
    }

    // Ugly exception: when the call was type(something),
    // don't call tp_init on the result.
    let isTypeNotSubclass = zelf === py.types.type
    let hasSingleArg = args.count == 1
    let hasEmptyKwargs = kwargs?.elements.isEmpty ?? true

    if isTypeNotSubclass && hasSingleArg && hasEmptyKwargs {
      return .value(object)
    }

    // If the returned object is not an instance of type, it won't be initialized.
    guard object.type.isSubtype(of: zelf) else {
      return .value(object)
    }

    switch zelf.call__init__(py, object: object, args: args, kwargs: kwargs) {
    case .value:
      return .value(object)
    case .error(let e):
      return .error(e)
    }
  }

  private func call__new__(_ py: Py,
                           args: [PyObject],
                           kwargs: PyDict?) -> PyResult<PyObject> {
    // Fast path for 'type' type.
    // Mostly because of how common type checks are (e.g. 'type(elsa)')
    if self === py.types.type {
      return PyType.pyNew(type: self, args: args, kwargs: kwargs)
    }

    // '__new__' is a static method, so we can't just use 'callMethod'
    guard let newLookup = self.mroLookup(name: .__new__) else {
      let message = "cannot create '\(self.name)' instances"
      return .typeError(py, message: message)
    }

    // '__new__' can (and probably will) be an descriptor,
    // in the most common case (staticmethod) we still have to call '__get__'
    let newFn: PyObject
    if let descr = GetDescriptor(py, type: self, attribute: newLookup.object) {
      switch descr.call() {
      case let .value(f):
        newFn = f
      case let .error(e):
        return .error(e)
      }
    } else {
      newFn = newLookup.object
    }

    let argsWithType = [self.asObject] + args
    let callResult = py.call(callable: newFn,
                             args: argsWithType,
                             kwargs: kwargs)

    return callResult.asResult
  }

  private func call__init__(_ py: Py,
                            object: PyObject,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyObject> {
    let result = py.callMethod(object: object,
                               selector: .__init__,
                               args: args,
                               kwargs: kwargs,
                               allowsCallableFromDict: false)

    switch result {
    case .value,
        .missingMethod:
      return .none(py)
    case .error(let e),
        .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  private func checkSetSpecialAttribute(_ py: Py,
                                        name: IdString,
                                        value: PyObject?) -> PyResult<PyObject> {
    let string = name.value.value

    guard self.typeFlags.isHeapType else {
      return .typeError(py, message: "can't set \(self.name).\(string)")
    }

    guard let value = value else {
      return .typeError(py, message: "can't delete \(self.name).\(string)")
    }

    return .value(value)
  }

  internal static func castZelf(_ py: Py, _ object: PyObject) -> PyType? {
    return py.cast.asType(object)
  }

  internal static func invalidSelfArgument<T>(
    _ py: Py,
    _ object: PyObject,
    swiftFnName: StaticString = #function
  ) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: "type",
                                               swiftFnName: swiftFnName)
    return .error(error.asBaseException)
  }
}
