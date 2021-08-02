import VioletCore

// swiftlint:disable file_length
// cSpell:ignore typeobject TPFLAGS STACKLESS

// In CPython:
// Objects -> typeobject.c
// https://docs.python.org/3/c-api/typeobj.html

// sourcery: pytype = type, isDefault, hasGC, isBaseType, isTypeSubclass
// sourcery: instancesHave__dict__
public final class PyType: PyObject, HasCustomGetMethod {

  // MARK: - Weak ref

  /// Box to store `weak` reference to `PyType`.
  /// Used to store subclasses (to avoid cycle, since we also store reference
  /// to base classes in `mro`).
  internal struct WeakRef {

    fileprivate weak var value: PyType?

    fileprivate init(_ value: PyType) {
      self.value = value
    }
  }

  // MARK: - Properties & init

  // sourcery: pytypedoc
  internal static let doc = """
    type(object_or_name, bases, dict)
    type(object) -> the object's type
    type(name, bases, dict) -> a new type
    """

  // object type - type: typeType, base: nil,        mro: [self]
  // type type   - type: typeType, base: objectType, mro: [self, objectType]
  // normal type - type: typeType, base: objectType, mro: [self, objectType]
  private var name: String
  private var qualname: String
  private var base: PyType?
  private var bases: [PyType]
  private var mro: [PyType]
  private var subclasses: [WeakRef] = []

  /// Swift storage (layout).
  /// See `PyType.MemoryLayout` documentation for details.
  internal let layout: MemoryLayout

  /// Methods needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal let staticMethods: StaticallyKnownNotOverriddenMethods

  /// `Object.flags` that are only avaiable on `type` instances.
  internal var typeFlags: TypeFlags {
    get { return TypeFlags(objectFlags: self.flags) }
    set { self.flags.setCustomFlags(from: newValue.objectFlags) }
  }

  override public var description: String {
    return "PyType(name: \(self.name), qualname: \(self.qualname))"
  }

  // MARK: - Init

  /// Full init with all of the options.
  internal convenience init(name: String,
                            qualname: String,
                            metatype: PyType,
                            base: PyType,
                            mro: MRO,
                            staticMethods: PyType.StaticallyKnownNotOverriddenMethods,
                            layout: PyType.MemoryLayout) {
    assert(mro.baseClasses.contains { $0 === base })

    self.init(name: name,
              qualname: qualname,
              base: base,
              mro: mro,
              staticMethods: staticMethods,
              layout: layout)

    self.setType(to: metatype)
  }

  /// Unsafe `init` without `type` property filled.
  ///
  /// NEVER EVER use this function!
  /// Reserved for `objectType` and `typeType`.
  internal init(name: String,
                qualname: String,
                base: PyType?,
                mro: MRO?,
                staticMethods: PyType.StaticallyKnownNotOverriddenMethods,
                layout: PyType.MemoryLayout) {
    self.name = name
    self.qualname = qualname
    self.base = base
    self.bases = mro?.baseClasses ?? []
    self.mro = [] // temporary, until we are able to use self
    self.staticMethods = staticMethods
    self.layout = layout

    // Special init() without 'type' argument, just for `PyType` and `BaseType`.
    super.init()

    // Proper mro (with self at 1st place)
    if let mro = mro {
      self.mro = [self] + mro.resolutionOrder

      for base in mro.baseClasses {
        base.subclasses.append(WeakRef(self))
      }
    } else {
      self.mro = [self]
    }
  }

  /// NEVER EVER use this function! It is a reserved for `object` type.
  ///
  /// - Warning:
  /// It will not set `self.type` property!
  internal static func initObjectType() -> PyType {
    let name = "object"
    let staticMethods = StaticMethodsForBuiltinTypes.object
    let layout = MemoryLayout.PyObject

    return PyMemory.newType(name: name,
                            qualname: name,
                            base: nil,
                            mro: nil,
                            staticMethods: staticMethods,
                            layout: layout)
  }

  /// NEVER EVER use this function! It is a reserved for `type` type.
  ///
  /// - Warning:
  /// It will not set `self.type` property!
  internal static func initTypeType(objectType: PyType) -> PyType {
    let name = "type"
    let mro = MRO.linearizeForBuiltinType(baseClass: objectType)
    let staticMethods = StaticMethodsForBuiltinTypes.type
    let layout = MemoryLayout.PyType

    return PyMemory.newType(name: name,
                            qualname: name,
                            base: objectType,
                            mro: mro,
                            staticMethods: staticMethods,
                            layout: layout)
  }

  /// NEVER EVER use this function! It is a reserved for builtin types
  /// (except for `objectType` and `typeType` they have their own inits).
  internal static func initBuiltinType(
    name: String,
    type: PyType,
    base: PyType,
    staticMethods: StaticallyKnownNotOverriddenMethods,
    layout: MemoryLayout
  ) -> PyType {
    let mro = MRO.linearizeForBuiltinType(baseClass: base)
    return PyMemory.newType(name: name,
                            qualname: name,
                            metatype: type,
                            base: base,
                            mro: mro,
                            staticMethods: staticMethods,
                            layout: layout)
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter = setName
  internal func getName() -> PyString {
    let name = self.getNameString()
    return Py.intern(string: name)
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

  internal func setName(_ value: PyObject?) -> PyResult<Void> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: .__name__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    guard let string = PyCast.asString(object) else {
      let t = object.typeName
      return .typeError("can only assign string to \(self.name).__name__, not '\(t)'")
    }

    self.name = string.value
    return .value()
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter = setQualname
  internal func getQualname() -> PyString {
    let qualname = self.getQualnameString()
    return Py.intern(string: qualname)
  }

  internal func getQualnameString() -> String {
    if self.typeFlags.isHeapType {
      return self.qualname
    }

    return self.getNameString()
  }

  internal func setQualname(_ value: PyObject?) -> PyResult<Void> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: .__qualname__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    guard let string = PyCast.asString(object) else {
      let t = object.typeName
      return .typeError("can only assign string to \(self.name).__qualname__, not '\(t)'")
    }

    self.qualname = string.value
    return .value()
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__, setter = setDoc
  internal func getDoc() -> PyResult<PyObject> {
    guard let doc = self.__dict__.get(id: .__doc__) else {
      return .value(Py.none)
    }

    if let descr = GetDescriptor(object: self, attribute: doc) {
      return descr.call()
    }

    return .value(doc)
  }

  internal func setDoc(_ value: PyObject?) -> PyResult<Void> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: .__doc__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    self.__dict__.set(id: .__doc__, to: object)
    return .value()
  }

  /// Set `__doc__` for a builtin type.
  ///
  /// We can't do it in init because we are not allowed to use other types in init.
  /// (Which means that we would not be able to create PyString to put in dict)
  internal func setBuiltinTypeDoc(_ value: String?) {
    let doc: PyObject = value
      .map(DocHelper.getDocWithoutSignature)
      .map(Py.newString) ?? Py.none

    self.__dict__.set(id: .__doc__, to: doc)
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter = setModule
  internal func getModule() -> PyResult<PyObject> {
    switch self.getModuleImpl() {
    case .builtins:
      let builtins = Py.intern(string: "builtins")
      return .value(builtins)
    case .string(let s):
      let interned = Py.intern(string: s)
      return .value(interned)
    case .pyString(let s):
      return .value(s)
    case .objectNotYetConvertedToString(let o):
      return .value(o)
    case .error(let e):
      return .error(e)
    }
  }

  internal enum ModuleAsString {
    case builtins
    case string(String)
    case error(PyBaseException)
  }

  /// The same as `self.getModule` but with a builtin `string` conversion.
  internal func getModuleString() -> ModuleAsString {
    switch self.getModuleImpl() {
    case .builtins:
      return .builtins
    case .string(let s):
      return .string(s)
    case .pyString(let s):
      return .string(s.value)
    case .objectNotYetConvertedToString(let o):
      switch Py.strString(object: o) {
      case let .value(s): return .string(s)
      case let .error(e): return .error(e)
      }
    case .error(let e):
      return .error(e)
    }
  }

  private enum GetModuleImplResult {
    case builtins
    case string(String)
    case pyString(PyString)
    case objectNotYetConvertedToString(PyObject)
    case error(PyBaseException)
  }

  private func getModuleImpl() -> GetModuleImplResult {
    if self.typeFlags.isHeapType {
      guard let object = self.__dict__.get(id: .__module__) else {
        let e = Py.newAttributeError(msg: "__module__")
        return .error(e)
      }

      guard let module = PyCast.asModule(object) else {
        switch Py.str(object: object) {
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

  internal func setModule(_ value: PyObject?) -> PyResult<Void> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: .__module__, value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    self.__dict__.set(id: .__module__, to: object)
    return .value()
  }

  // MARK: - Base

  // sourcery: pyproperty = __bases__, setter = setBases
  internal func getBasesPy() -> PyTuple {
    let bases = self.getBases()
    return Py.newTuple(elements: bases)
  }

  internal func getBases() -> [PyType] {
    return self.bases
  }

  internal func setBases(_ value: PyObject?) -> PyResult<Void> {
    // Violet currently does not support this
    return .typeError("can't set \(self.name).__bases__")
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> PyDict {
    return self.__dict__
  }

  internal func setDict(value: PyDict) {
    self.__dict__ = value
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    switch self.getModuleString() {
    case .builtins:
      return .value("<class '\(self.name)'>")
    case .string(let module):
      return .value("<class '\(module).\(self.name)'>")
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Base

  // sourcery: pyproperty = __base__
  internal func getBase() -> PyType? {
    return self.base
  }

  // MARK: - Mro

  // sourcery: pyproperty = __mro__
  /// This is an implementation of `Python __mro__` property.
  /// In Swift use `self.getMRO` instead.
  internal func get__mro__() -> PyTuple {
    let mro = self.getMRO()
    return Py.newTuple(elements: mro)
  }

  internal static let mroPyDoc = """
    mro($self, /)
    --

    Return a type's method resolution order.
    """

  // sourcery: pymethod = mro, doc = mroPyDoc
  /// Return a type's method resolution order.
  ///
  /// This is an implementation of `Python mro` function.
  /// In Swift use `self.getMRO` instead.
  internal func getMROPy() -> PyList {
    let mro = self.getMRO()
    return Py.newList(elements: mro)
  }

  internal func getMRO() -> [PyType] {
    return self.mro
  }

  // MARK: - Subtypes

  // sourcery: pymethod = __subclasscheck__
  internal func isSubtype(of object: PyObject) -> PyResult<Bool> {
    if let type = PyCast.asType(object) {
      return .value(self.isSubtype(of: type))
    }

    return .typeError("issubclass() arg 1 must be a class")
  }

  internal func isSubtype(of type: PyType) -> Bool {
    return self.mro.contains { $0 === type }
  }

  // sourcery: pymethod = __instancecheck__
  internal func isType(of object: PyObject) -> Bool {
    return object.type.isSubtype(of: self)
  }

  /// Is `self` subtype of `baseException`?
  ///
  /// PyExceptionInstance_Check
  public var isException: Bool {
    let baseException = Py.errorTypes.baseException
    return self.isSubtype(of: baseException)
  }

  // sourcery: pymethod = __subclasses__
  internal func getSubclasses() -> PyList {
    var elements = [PyType]()

    for subclassRef in self.subclasses {
      if let subclass = subclassRef.value {
        elements.append(subclass)
      }
    }

    return Py.newList(elements: elements)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return self.getAttribute(name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal func getAttribute(name: PyString) -> PyResult<PyObject> {
    return self.getAttribute(name: name, searchDict: true)
  }

  private func getAttribute(name: PyString,
                            searchDict: Bool) -> PyResult<PyObject> {
    let metaAttribute: PyObject?
    let metaDescriptor: GetDescriptor?

    // Look for the attribute in the metatype
    switch self.type.mroLookup(name: name) {
    case .value(let r):
      metaAttribute = r.object
      metaDescriptor = GetDescriptor(object: self, attribute: r.object)
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
        if let descr = GetDescriptor(type: self, attribute: r.object) {
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
    let msg = "type object '\(self.name)' has no attribute \(nameQuoted)"
    return .attributeError(msg)
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    if let error = self.preventSetAttributeOnBuiltin() {
      return .error(error)
    }

    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return self.setAttribute(name: n, value: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal func setAttribute(name: PyString, value: PyObject?) -> PyResult<PyNone> {
    if let error = self.preventSetAttributeOnBuiltin() {
      return .error(error)
    }

    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  private func preventSetAttributeOnBuiltin() -> PyBaseException? {
    if !self.typeFlags.isHeapType {
      let msg = "can't set attributes of built-in/extension type '\(self.name)'"
      return Py.newTypeError(msg: msg)
    }

    return nil
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return self.setAttribute(name: name, value: nil)
  }

  // MARK: - Get method

  internal func getMethod(
    selector: PyString,
    allowsCallableFromDict: Bool
  ) -> PyInstance.GetMethodResult {
    let result = self.getAttribute(name: selector,
                                   searchDict: allowsCallableFromDict)

    switch result {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if PyCast.isAttributeError(e) {
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
  internal func dir() -> PyResult<DirResult> {
    let result = DirResult()

    for base in self.mro {
      if let e = result.append(keysFrom: base.__dict__) {
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
      switch type.__dict__.get(key: name) {
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
  internal func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    let object: PyObject
    switch self.call__new__(args: args, kwargs: kwargs) {
    case let .value(o):
      object = o
    case let .error(e):
      return .error(e)
    }

    // Ugly exception: when the call was type(something),
    // don't call tp_init on the result.
    let hasSingleArg = args.count == 1
    let hasEmptyKwargs = kwargs?.elements.isEmpty ?? true
    if self === Py.types.type && hasSingleArg && hasEmptyKwargs {
      return .value(object)
    }

    // If the returned object is not an instance of type, it won't be initialized.
    guard object.type.isSubtype(of: self) else {
      return .value(object)
    }

    switch self.call__init__(object: object, args: args, kwargs: kwargs) {
    case .value:
      return .value(object)
    case .error(let e):
      return .error(e)
    }
  }

  private func call__new__(args: [PyObject],
                           kwargs: PyDict?) -> PyResult<PyObject> {
    // Fast path for 'type' type.
    // Mostly because of how common type checks are (e.g. 'type(elsa)')
    if self === Py.types.type {
      return PyType.pyNew(type: self, args: args, kwargs: kwargs)
    }

    // '__new__' is a static method, so we can't just use 'callMethod'
    guard let newLookup = self.mroLookup(name: .__new__) else {
      return .typeError("cannot create '\(self.name)' instances")
    }

    // '__new__' can (and probably will) be an descriptor,
    // in the most common case (staticmethod) we still have to call '__get__'
    let newFn: PyObject
    if let descr = GetDescriptor(type: self, attribute: newLookup.object) {
      switch descr.call() {
      case let .value(f):
        newFn = f
      case let .error(e):
        return .error(e)
      }
    } else {
      newFn = newLookup.object
    }

    let argsWithType = [self] + args
    let callResult = Py.call(callable: newFn,
                             args: argsWithType,
                             kwargs: kwargs)

    return callResult.asResult
  }

  private func call__init__(object: PyObject,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyNone> {
    let result = Py.callMethod(object: object,
                               selector: .__init__,
                               args: args,
                               kwargs: kwargs,
                               allowsCallableFromDict: false)

    switch result {
    case .value,
         .missingMethod:
      return .value(Py.none)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - GC

  /// Remove all of the references to other Python objects.
  override internal func gcClean() {
    self.base = nil
    self.bases = []
    self.mro = []
    self.subclasses = []
    self.__dict__.gcClean()
    super.gcClean()
  }

  // MARK: - Helpers

  private func checkSetSpecialAttribute(name: IdString,
                                        value: PyObject?) -> PyResult<PyObject> {
    let nameString = name.value.value

    guard self.typeFlags.isHeapType else {
      return .typeError("can't set \(self.name).\(nameString)")
    }

    guard let value = value else {
      return .typeError("can't delete \(self.name).\(nameString)")
    }

    return .value(value)
  }
}
