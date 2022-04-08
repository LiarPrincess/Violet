import VioletCore

// swiftlint:disable static_operator
// swiftlint:disable file_length
// cSpell:ignore typeobject

// In CPython:
// Objects -> typeobject.c
// https://docs.python.org/3/c-api/typeobj.html

public func === (lhs: PyType, rhs: PyType) -> Bool { lhs.ptr === rhs.ptr }
public func !== (lhs: PyType, rhs: PyType) -> Bool { lhs.ptr !== rhs.ptr }

// sourcery: pytype = type, isDefault, hasGC, isBaseType, isTypeSubclass
// sourcery: instancesHave__dict__
public struct PyType: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    type(object_or_name, bases, dict)
    type(object) -> the object's type
    type(name, bases, dict) -> a new type
    """

  // MARK: - Properties

  public typealias DebugFn = (RawPtr) -> PyObject.DebugMirror
  public typealias DeinitializeFn = (Py, RawPtr) -> Void

  // sourcery: storedProperty
  internal var name: String {
    get { self.namePtr.pointee }
    nonmutating set { self.namePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var qualname: String {
    get { self.qualnamePtr.pointee }
    nonmutating set { self.qualnamePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var doc: PyObject? { self.docPtr.pointee }
  // sourcery: storedProperty
  internal var base: PyType? { self.basePtr.pointee }
  // sourcery: storedProperty
  internal var bases: [PyType] { self.basesPtr.pointee }
  // sourcery: storedProperty
  internal var mro: [PyType] { self.mroPtr.pointee }
  // sourcery: storedProperty
  internal var subclasses: [PyType] { self.subclassesPtr.pointee }

  // sourcery: storedProperty
  /// Amount of memory taken by a single instance not counting any (optional)
  /// tail allocation.
  ///
  /// This is needed when looking for `solid base` when creating a new type.
  ///
  /// Example for `SystemExit`:
  /// - base class `object` has: `type`, `__dict__` and `flags` stored properties.
  /// - base class `BaseException` has `args` (and other) stored properties.
  /// - `SystemExit` has `code` stored property.
  ///
  /// If we want to create `MyException(BaseException, SystemExit, object)`
  /// we have to use `SystemExit` because it adds new properties to `BaseException`
  /// and `object` (in other words: it has the biggest size).
  internal var instanceSizeWithoutTail: Int {
    self.instanceSizeWithoutTailPtr.pointee
  }

  // sourcery: storedProperty
  /// Methods needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal var staticMethods: PyStaticCall.KnownNotOverriddenMethods {
    self.staticMethodsPtr.pointee
  }

  // sourcery: storedProperty
  internal var debugFn: DebugFn { self.debugFnPtr.pointee }
  // sourcery: storedProperty
  internal var deinitialize: DeinitializeFn { self.deinitializePtr.pointee }

  /// `PyObject.flags` that are only available on `type` instances.
  internal var typeFlags: Flags {
    get { return Flags(objectFlags: self.flags) }
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
                           flags: PyType.Flags,
                           base: PyType?,
                           bases: [PyType],
                           mroWithoutSelf: [PyType],
                           subclasses: [PyType],
                           instanceSizeWithoutTail: Int,
                           staticMethods: PyStaticCall.KnownNotOverriddenMethods,
                           debugFn: @escaping PyType.DebugFn,
                           deinitialize: @escaping PyType.DeinitializeFn) {
    if let b = base {
      assert(bases.contains { $0 === b })
      assert(mroWithoutSelf.contains { $0 === b })
    }

    self.initializeBase(py, type: type)
    self.initializeProperties(name: name,
                              qualname: qualname,
                              flags: flags,
                              base: base,
                              bases: bases,
                              mroWithoutSelf: mroWithoutSelf,
                              subclasses: subclasses,
                              instanceSizeWithoutTail: instanceSizeWithoutTail,
                              staticMethods: staticMethods,
                              debugFn: debugFn,
                              deinitialize: deinitialize)

    for base in bases {
      base.subclassesPtr.pointee.append(self)
    }
  }

  /// `type type` (type of all of the types) and `object type` are a bit special.
  ///
  /// They are the 1st python objects that we allocate and at the point of calling
  /// this methods they are UNINITIALIZED!
  internal static func initialize(typeType: PyType,
                                  typeTypeFlags: PyType.Flags,
                                  objectType: PyType,
                                  objectTypeFlags: PyType.Flags) {
    // Just a reminder:
    //             | Type     | Base       | MRO
    // object type | typeType | nil        | [self]
    // type type   | typeType | objectType | [self, objectType]
    // normal type | typeType | objectType | [self, (…), objectType]

    PyObject.initialize(typeType: typeType, objectType: objectType)

    typeType.initializeProperties(name: "type",
                                  qualname: "type",
                                  flags: typeTypeFlags,
                                  base: objectType,
                                  bases: [objectType],
                                  mroWithoutSelf: [objectType],
                                  subclasses: [],
                                  instanceSizeWithoutTail: PyType.layout.size,
                                  staticMethods: Py.Types.typeStaticMethods,
                                  debugFn: PyType.createDebugInfo(ptr:),
                                  deinitialize: PyType.deinitialize(_:ptr:))

    objectType.initializeProperties(name: "object",
                                    qualname: "object",
                                    flags: objectTypeFlags,
                                    base: nil,
                                    bases: [],
                                    mroWithoutSelf: [],
                                    subclasses: [],
                                    instanceSizeWithoutTail: PyObject.layout.size,
                                    staticMethods: Py.Types.objectStaticMethods,
                                    debugFn: PyObject.createDebugInfo(ptr:),
                                    deinitialize: PyObject.deinitialize(_:ptr:))

    objectType.subclassesPtr.pointee.append(typeType)
  }

  // swiftlint:disable function_parameter_count

  /// Initialize type properties.
  /// It assumes that base properties are already initialized.
  private func initializeProperties(name: String,
                                    qualname: String,
                                    flags: PyType.Flags,
                                    base: PyType?,
                                    bases: [PyType],
                                    mroWithoutSelf: [PyType],
                                    subclasses: [PyType],
                                    instanceSizeWithoutTail: Int,
                                    staticMethods: PyStaticCall.KnownNotOverriddenMethods,
                                    debugFn: @escaping PyType.DebugFn,
                                    deinitialize: @escaping PyType.DeinitializeFn) {
    // swiftlint:enable function_parameter_count

    let mro = [self] + mroWithoutSelf
    self.namePtr.initialize(to: name)
    self.qualnamePtr.initialize(to: qualname)
    self.docPtr.initialize(to: nil)
    self.basePtr.initialize(to: base)
    self.basesPtr.initialize(to: bases)
    self.mroPtr.initialize(to: mro)
    self.subclassesPtr.initialize(to: subclasses)
    self.instanceSizeWithoutTailPtr.initialize(to: instanceSizeWithoutTail)
    self.staticMethodsPtr.initialize(to: staticMethods)
    self.debugFnPtr.initialize(to: debugFn)
    self.deinitializePtr.initialize(to: deinitialize)

    self.flags.setCustomFlags(from: flags.objectFlags)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyType(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "name", value: zelf.name, includeInDescription: true)
    result.append(name: "qualname", value: zelf.qualname, includeInDescription: true)
    result.append(name: "typeFlags", value: zelf.typeFlags)
    result.append(name: "base", value: zelf.base as Any)
    result.append(name: "bases", value: zelf.bases)
    result.append(name: "mro", value: zelf.mro)
    result.append(name: "instanceSizeWithoutTail", value: zelf.instanceSizeWithoutTail)
    return result
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter
  internal static func __name__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__name__")
    }

    let name = zelf.getNameString()
    return PyResult(py, interned: name)
  }

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
                                zelf _zelf: PyObject,
                                value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__name__")
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
  internal static func __qualname__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__qualname__'")
    }

    let qualname = zelf.getQualnameString()
    return PyResult(py, interned: qualname)
  }

  internal func getQualnameString() -> String {
    if self.typeFlags.isHeapType {
      return self.qualname
    }

    return self.getNameString()
  }

  internal static func __qualname__(_ py: Py,
                                    zelf _zelf: PyObject,
                                    value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__qualname__")
    }

    switch zelf.setQualname(py, value: value) {
    case .value:
      return .none(py)
    case .error(let e):
      return .error(e)
    }
  }

  internal func setQualname(_ py: Py, value: PyObject?) -> PyResultGen<Void> {
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
  internal static func __doc__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__doc__")
    }

    // If we are a builtin type then we have our 'doc' stored:
    if let doc = zelf.doc {
      return PyResult(py, doc)
    }

    // Otherwise we get it from '__doc__', possible cases:
    // - if the type allows its instances to have '__doc__' then the object that
    //   we get from '__dict__' is a 'property'. In this case we will call 'fget'
    //   of this property and maybe get something useful (or an TypeError).
    // - if the type does not permit '__doc__' then the thing stored in '__dict__'
    //   is an 'str' that describes this type.
    let dict = zelf.getDict(py)
    guard let doc = dict.get(py, id: .__doc__) else {
      return .none(py)
    }

    if let descr = GetDescriptor(py, object: zelf.asObject, attribute: doc) {
      return descr.call()
    }

    return .value(doc)
  }

  internal static func __doc__(_ py: Py,
                               zelf _zelf: PyObject,
                               value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__doc__")
    }

    let object: PyObject
    switch zelf.checkSetSpecialAttribute(py, name: .__doc__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    let dict = zelf.getDict(py)
    dict.set(py, id: .__doc__, value: object)
    return .none(py)
  }

  /// Set `__doc__` for a builtin type.
  ///
  /// We can't do it in init because we are not allowed to use other types in init.
  /// (Which means that we would not be able to create PyString to put in dict)
  internal func setBuiltinTypeDoc(_ py: Py, value: String?) {
    let object: PyObject
    if let v = value {
      let withoutSignature = DocHelper.getDocWithoutSignature(v)
      object = py.newString(withoutSignature).asObject
    } else {
      object = py.none.asObject
    }

    self.docPtr.pointee = object
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter
  internal static func __module__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__module__")
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
      switch py.strString(o) {
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
      let dict = self.getDict(py)

      guard let object = dict.get(py, id: .__module__) else {
        let e = py.newAttributeError(message: "__module__")
        return .error(e.asBaseException)
      }

      guard let module = py.cast.asModule(object) else {
        switch py.str(object) {
        case let .value(s):
          return .pyString(s)
        case let .error(e):
          return .error(e)
        }
      }

      switch module.getName(py) {
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
                                  zelf _zelf: PyObject,
                                  value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__module__")
    }

    switch zelf.setModule(py, value: value) {
    case .value:
      return .none(py)
    case .error(let e):
      return .error(e)
    }
  }

  internal func setModule(_ py: Py, value: PyObject?) -> PyResultGen<Void> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(py, name: .__module__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    let dict = self.getDict(py)
    dict.set(py, id: .__module__, value: object)
    return .value()
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }

    let result = zelf.getDict(py)
    return PyResult(result)
  }

  internal func getDict(_ py: Py) -> PyDict {
    let object = self.asObject

    guard let result = object.get__dict__(py) else {
      py.trapMissing__dict__(object: self)
    }

    return result
  }

  internal func setDict(_ value: PyDict) {
    let object = self.asObject
    object.set__dict__(value)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    switch zelf.getModuleName(py) {
    case .builtins:
      let result = "<class '\(zelf.name)'>"
      return PyResult(py, result)
    case .string(let module):
      let result = "<class '\(module).\(zelf.name)'>"
      return PyResult(py, result)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Base

  // sourcery: pyproperty = __base__
  internal static func __base__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__base__")
    }

    guard let base = zelf.base else {
      return .none(py)
    }

    return .value(base.asObject)
  }

  // MARK: - Bases

  // sourcery: pyproperty = __bases__, setter
  internal static func __bases__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__bases__")
    }

    let bases = zelf.bases.map { $0.asObject }
    return PyResult(py, tuple: bases)
  }

  internal static func __bases__(_ py: Py,
                                 zelf _zelf: PyObject,
                                 value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__bases__")
    }

    // Violet currently does not support this
    return .typeError(py, message: "can't set \(zelf.name).__bases__")
  }

  // MARK: - Mro

  // sourcery: pyproperty = __mro__
  internal static func __mro__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__mro__")
    }

    let mro = zelf.mro.map { $0.asObject }
    return PyResult(py, tuple: mro)
  }

  internal static let mroDoc = """
    mro($self, /)
    --

    Return a type's method resolution order.
    """

  // sourcery: pymethod = mro, doc = mroDoc
  internal static func mro(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "mro")
    }

    let elements = zelf.mro.map { $0.asObject }
    let list = py.newList(elements: elements)
    return PyResult(list)
  }

  // MARK: - Subtypes

  // sourcery: pymethod = __subclasscheck__
  internal static func __subclasscheck__(_ py: Py,
                                         zelf _zelf: PyObject,
                                         object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__subclasscheck__")
    }

    let result = zelf.isSubtype(py, of: object)
    return PyResult(py, result)
  }

  internal func isSubtype(_ py: Py, of object: PyObject) -> PyResultGen<Bool> {
    guard let type = py.cast.asType(object) else {
      return .typeError(py, message: "issubclass() arg 1 must be a class")
    }

    let result = self.isSubtype(of: type)
    return .value(result)
  }

  internal func isSubtype(of type: PyType) -> Bool {
    return self.mro.contains { $0 === type }
  }

  // sourcery: pymethod = __instancecheck__
  internal static func __instancecheck__(_ py: Py,
                                         zelf _zelf: PyObject,
                                         object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__instancecheck__")
    }

    let result = object.type.isSubtype(of: zelf)
    return PyResult(py, result)
  }

  // sourcery: pymethod = __subclasses__
  internal static func __subclasses__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__subclasses__")
    }

    let subclasses = zelf.subclasses.map { $0.asObject }
    let result = py.newList(elements: subclasses)
    return PyResult(result)
  }

  // MARK: - Prepare

  internal static let prepareDoc = """
    __prepare__() -> dict
    --

    used to create the namespace for the class statement
    """

  // sourcery: pyclassmethod = __prepare__, doc = prepareDoc
  /// static PyObject *
  /// type_prepare(PyObject *self, PyObject *const *args, Py_ssize_t nargs, ...)
  internal static func __prepare__(_ py: Py,
                                   zelf: PyObject,
                                   args: [PyObject],
                                   kwargs: PyDict?) -> PyResult {
    guard Self.downcast(py, zelf) != nil else {
      return Self.invalidZelfArgument(py, zelf, "__prepare__")
    }

    let result = py.newDict()
    return PyResult(result)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return zelf.getAttribute(py, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal func getAttribute(_ py: Py, name: PyString) -> PyResult {
    return self.getAttribute(py, name: name, searchDict: true)
  }

  private func getAttribute(_ py: Py,
                            name: PyString,
                            searchDict: Bool) -> PyResult {
    let metaAttribute: PyObject?
    let metaDescriptor: GetDescriptor?

    // Look for the attribute in the metatype
    switch self.type.mroLookup(py, name: name) {
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
      switch self.mroLookup(py, name: name) {
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
    return .attributeError(py, message: message)
  }

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__setattr__")
    }

    if let error = zelf.preventSetAttributeOnBuiltin(py) {
      return .error(error.asBaseException)
    }

    return zelf.setAttribute(py, name: name, value: value)
  }

  private func setAttribute(_ py: Py,
                            name: PyObject,
                            value: PyObject?) -> PyResult {
    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return self.setAttribute(py, name: n, value: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal func setAttribute(_ py: Py,
                             name: PyString,
                             value: PyObject?) -> PyResult {
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
                                   zelf _zelf: PyObject,
                                   name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delattr__")
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
  internal static func __dir__(_ py: Py,
                               zelf _zelf: PyObject) -> PyResultGen<DirResult> {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(py, _zelf, Self.pythonTypeName)
    }

    return zelf.dir(py)
  }

  // Function used in other places in this module.
  internal func dir(_ py: Py) -> PyResultGen<DirResult> {
    var result = DirResult()

    for base in self.mro {
      let dict = base.getDict(py)
      if let e = result.append(py, keysFrom: dict) {
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
  internal func mroLookup(_ py: Py, name: IdString) -> MroLookupResult? {
    for type in self.mro {
      let dict = type.getDict(py)

      if let object = dict.get(py, id: name) {
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
  internal func mroLookup(_ py: Py, name: PyString) -> MroLookupByStringResult {
    for type in self.mro {
      let dict = type.getDict(py)

      switch dict.get(py, key: name.asObject) {
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
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__call__")
    }

    return zelf.call(py, args: args, kwargs: kwargs)
  }

  internal func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
    let object: PyObject
    switch self.call__new__(py, args: args, kwargs: kwargs) {
    case let .value(o):
      object = o
    case let .error(e):
      return .error(e)
    }

    // Ugly exception: when the call was type(something),
    // don't call tp_init on the result.
    let isTypeNotSubclass = self === py.types.type
    let hasSingleArg = args.count == 1
    let hasEmptyKwargs = kwargs?.elements.isEmpty ?? true

    if isTypeNotSubclass && hasSingleArg && hasEmptyKwargs {
      return .value(object)
    }

    // If the returned object is not an instance of type, it won't be initialized.
    guard object.type.isSubtype(of: self) else {
      return .value(object)
    }

    switch self.call__init__(py, object: object, args: args, kwargs: kwargs) {
    case .value:
      return .value(object)
    case .error(let e):
      return .error(e)
    }
  }

  private func call__new__(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {
    // Fast path for 'type' type.
    // Mostly because of how common type checks are (e.g. 'type(elsa)')
    if self === py.types.type {
      return Self.__new__(py, type: self, args: args, kwargs: kwargs)
    }

    // '__new__' is a static method, so we can't just use 'callMethod'
    guard let newLookup = self.mroLookup(py, name: .__new__) else {
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
    let callResult = py.call(callable: newFn, args: argsWithType, kwargs: kwargs)
    return callResult.asResult
  }

  private func call__init__(_ py: Py,
                            object: PyObject,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult {
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
                                        value: PyObject?) -> PyResult {
    guard self.typeFlags.isHeapType else {
      return .typeError(py, message: "can't set \(self.name).\(name)")
    }

    guard let value = value else {
      return .typeError(py, message: "can't delete \(self.name).\(name)")
    }

    return .value(value)
  }
}
