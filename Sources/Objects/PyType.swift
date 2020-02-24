import Core

// In CPython:
// Objects -> typeobject.c

// swiftlint:disable file_length

// MARK: - Flags

internal struct PyTypeFlags: OptionSet {

  let rawValue: UInt16

  /// Set if the type object is dynamically allocated
  /// (for example by `class` statement).
  internal static let heapType = PyTypeFlags(rawValue: 1 << 0)

  /// Set if the type allows subclassing.
  internal static let baseType = PyTypeFlags(rawValue: 1 << 1)

  /// Objects support garbage collection.
  internal static let hasGC = PyTypeFlags(rawValue: 1 << 2)

  /// Type is abstract and cannot be instantiated
  internal static let isAbstract = PyTypeFlags(rawValue: 1 << 3)

  /// Type structure has tp_finalize member (3.4)
  internal static let hasFinalize = PyTypeFlags(rawValue: 1 << 4)

  /// #define Py_TPFLAGS_DEFAULT  ( \
  ///     Py_TPFLAGS_HAVE_STACKLESS_EXTENSION | \
  ///     Py_TPFLAGS_HAVE_VERSION_TAG)
  internal static let `default` = PyTypeFlags(rawValue: 1 << 5)

  /// These flags are used to determine if a type is a subclass.
  internal static let longSubclass = PyTypeFlags(rawValue: 1 << 8)
  /// These flags are used to determine if a type is a subclass.
  internal static let listSubclass = PyTypeFlags(rawValue: 1 << 9)
  /// These flags are used to determine if a type is a subclass.
  internal static let tupleSubclass = PyTypeFlags(rawValue: 1 << 10)
  /// These flags are used to determine if a type is a subclass.
  internal static let bytesSubclass = PyTypeFlags(rawValue: 1 << 11)
  /// These flags are used to determine if a type is a subclass.
  internal static let unicodeSubclass = PyTypeFlags(rawValue: 1 << 12)
  /// These flags are used to determine if a type is a subclass.
  internal static let dictSubclass = PyTypeFlags(rawValue: 1 << 13)
  /// These flags are used to determine if a type is a subclass.
  internal static let baseExceptionSubclass = PyTypeFlags(rawValue: 1 << 14)
  /// These flags are used to determine if a type is a subclass.
  internal static let typeSubclass = PyTypeFlags(rawValue: 1 << 15)
}

// MARK: - Type weak ref

/// Box to store weak reference to `PyType`.
/// Used to store subclasses in `PyType` (to avoid cycle since we
/// also store reference to base classes in `mro`).
internal struct PyTypeWeakRef {

  fileprivate weak var value: PyType?

  fileprivate init(_ value: PyType) {
    self.value = value
  }
}

// MARK: - Type

// sourcery: default, hasGC, baseType, typeSubclass
public class PyType: PyObject {

  internal static let doc: String = """
    type(object_or_name, bases, dict)
    type(object) -> the object's type
    type(name, bases, dict) -> a new type
    """

  // object type - type: typeType, base: nil,        mro: [self]
  // type type   - type: typeType, base: objectType, mro: [self, objectType]
  // normal type - type: typeType, base: objectType, mro: [self, objectType]
  private var name: String
  private var qualname: String
  private var base:  PyType?
  private var bases: [PyType]
  private var mro:   [PyType]
  private var subclasses: [PyTypeWeakRef] = []
  private lazy var __dict__ = PyDict()

  internal private(set) var typeFlags = PyTypeFlags()

  internal var isHeapType: Bool {
    return self.typeFlags.contains(.heapType)
  }

  internal var isBaseType: Bool {
    return self.typeFlags.contains(.baseType)
  }

  internal func setFlag(_ flag: PyTypeFlags) {
    self.typeFlags.insert(flag)
  }

  override public var description: String {
    return "PyType(name: \(self.name), qualname: \(qualname))"
  }

  // MARK: - Init

  /// Full init with all of the options.
  internal convenience init(name: String,
                            qualname: String,
                            type: PyType,
                            base: PyType,
                            mro:  MRO) {
    assert(mro.baseClasses.contains { $0 === base })

    self.init(name: name, qualname: qualname, base: base, mro: mro)
    self.setType(to: type)
  }

  /// Unsafe init without `type` property filled.
  ///
  /// NEVER EVER use this function!
  /// Reserved for `objectType` and `typeType`.
  private init(name: String, qualname: String, base: PyType?, mro: MRO?) {
    self.name = name
    self.qualname = qualname
    self.base = base
    self.bases = mro?.baseClasses ?? []
    self.mro = [] // temporary, until we are able to use self

    // Special init just for `PyType` and `BaseType`.
    super.init()

    // Proper mro (with self at 1st place)
    if let mro = mro {
      self.mro = [self] + mro.resolutionOrder

      for base in mro.baseClasses {
        base.subclasses.append(PyTypeWeakRef(self))
      }
    } else {
      self.mro = [self]
    }
  }

  /// NEVER EVER use this function! It is a reserved for `objectType`.
  ///
  /// - Warning:
  /// It will not set `self.type` property!
  internal static func initObjectType() -> PyType {
    let name = "object"
    return PyType(name: name, qualname: name, base: nil, mro: nil)
  }

  /// NEVER EVER use this function! It is a reserved for `typeType`.
  ///
  /// - Warning:
  /// It will not set `self.type` property!
  internal static func initTypeType(objectType: PyType) -> PyType {
    let name = "type"
    let mro = MRO.linearize(baseClass: objectType)
    return PyType(name: name, qualname: name, base: objectType, mro: mro)
  }

  /// NEVER EVER use this function! It is a reserved for builtin types
  /// (except for `objectType` and `typeType` they have their own inits).
  internal static func initBuiltinType(name: String,
                                       type: PyType,
                                       base: PyType) -> PyType {
    let mro = MRO.linearize(baseClass: base)
    return PyType(name: name, qualname: name, type: type, base: base, mro: mro)
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter = setName
  public func getName() -> String {
    if self.isHeapType {
      return self.name
    }

    switch self.name.lastIndex(of: ".") {
    case let .some(index):
      return String(self.name.suffix(from: index))
    case .none:
      return self.name
    }
  }

  public func setName(_ value: PyObject?) -> PyResult<()> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: "__name__", value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    guard let string = object as? PyString else {
      let t = object.typeName
      return .typeError("can only assign string to \(self.name).__name__, not '\(t)'")
    }

    self.name = string.value
    return .value()
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__, setter = setQualname
  public func getQualname() -> String {
    if self.isHeapType {
      return self.qualname
    }

    return self.getName()
  }

  public func setQualname(_ value: PyObject?) -> PyResult<()> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: "__qualname__", value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    guard let string = object as? PyString else {
      let t = object.typeName
      return .typeError("can only assign string to \(self.name).__qualname__, not '\(t)'")
    }

    self.qualname = string.value
    return .value()
  }

  // MARK: - Doc

  // sourcery: pyproperty = __doc__, setter = setDoc
  public func getDoc() -> PyResult<PyObject> {
    guard let doc = self.__dict__.getItem(id: Ids.__doc__) else {
      return .value(Py.none)
    }

    if let descr = GetDescriptor.get(object: self, attribute: doc) {
      switch descr.call() {
      case let .value(o): return .value(o)
      case let .error(e): return .error(e)
      }
    }

    return .value(doc)
  }

  public func setDoc(_ value: PyObject?) -> PyResult<()> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: "__doc__", value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    self.__dict__.setItem(at: Ids.__doc__, to: object)
    return .value()
  }

  /// Set type for a builtin type.
  /// We can't do it in init because we are not allowed to use other types in init.
  /// (Which means that we would not be able to create PyString to put in dict)
  internal func setBuiltinTypeDoc(_ value: String?) {
    let doc: PyObject = value
      .map(DocHelper.getDocWithoutSignature)
      .map(Py.newString) ?? Py.none

    self.__dict__.setItem(at: Ids.__doc__, to: doc)
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter = setModule
  public func getModule() -> PyResult<String> {
    switch self.getModuleRaw() {
    case .builtins:
      return .value("builtins")
    case .module(let name):
      return .value(name)
    case .error(let e):
      return .error(e)
    }
  }

  public enum GetModuleRawResult {
    case builtins
    case module(String)
    case error(PyBaseException)
  }

  public func getModuleRaw() -> GetModuleRawResult {
    if self.isHeapType {
      guard let object = self.__dict__.getItem(id: Ids.__module__) else {
        return .error(Py.newAttributeError(msg: "__module__"))
      }

      guard let module = object as? PyModule else {
        switch Py.strValue(object) {
        case let .value(s):
          return .module(s)
        case let .error(e):
          return .error(e)
        }
      }

      switch module.name {
      case let .value(name):
        return .module(name)
      case let .error(e):
        return .error(e)
      }
    }

    if let dotIndex = self.name.firstIndex(of: ".") {
      let module = self.name.prefix(upTo: dotIndex)
      return .module(String(module))
    }

    return .builtins
  }

  public func setModule(_ value: PyObject?) -> PyResult<()> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: "__module__", value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    self.__dict__.setItem(at: Ids.__module__, to: object)
    return .value()
  }

  // MARK: - Base

  // sourcery: pyproperty = __bases__, setter = setBases
  internal func getBases() -> PyTuple {
    return Py.newTuple(self.getBasesRaw())
  }

  public func getBasesRaw() -> [PyType] {
    return self.bases
  }

  public func setBases(_ value: PyObject?) -> PyResult<()> {
    // Violet currently does not support this
    return .typeError("can't set \(self.name).__bases__")
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  public func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    switch self.getModuleRaw() {
    case .builtins:
      return .value("<class '\(self.name)'>")
    case .module(let module):
      return .value("<class '\(module).\(self.name)'>")
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Base

  // sourcery: pyproperty = __base__
  public func getBase() -> PyType? {
    return self.base
  }

  // MARK: - Mro

  // sourcery: pyproperty = __mro__
  internal func getMRO() -> PyTuple {
    return Py.newTuple(self.getMRORaw())
  }

  public func getMRORaw() -> [PyType] {
    return self.mro
  }

  // MARK: - Subtypes

  // sourcery: pymethod = __subclasscheck__
  public func isSubtype(of object: PyObject) -> PyResult<Bool> {
    if let type = object as? PyType {
      return .value(self.isSubtype(of: type))
    }

    return .typeError("issubclass() arg 1 must be a class")
  }

  public func isSubtype(of type: PyType) -> Bool {
    return self.mro.contains { $0 === type }
  }

  // sourcery: pymethod = __instancecheck__
  public func isType(of object: PyObject) -> Bool {
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
  public func getSubclasses() -> [PyType] {
    var result = [PyType]()
    for subclassRef in self.subclasses {
      if let subclass = subclassRef.value {
        result.append(subclass)
      }
    }
    return result
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.extractName(from: name)
      .flatMap(self.getAttribute(name:))
  }

  public func getAttribute(name: String) -> PyResult<PyObject> {
    let metaType = self.type
    let metaAttribute = metaType.lookup(name: name)
    var metaDescriptor: GetDescriptor?

    // Look for the attribute in the metatype
    if let metaAttribute = metaAttribute {
      metaDescriptor = GetDescriptor.get(object: self, attribute: metaAttribute)
      if let desc = metaDescriptor, desc.isData {
        return desc.call() // Will call '__get__' with self (PyType)
      }
    }

    // No data descriptor found on metatype.
    // Look in __dict__ of this type and its bases
    if let attribute = self.lookup(name: name) {
      if let descr = GetDescriptor.get(object: self, attribute: attribute) {
        // 'Without owner' means that we will call '__get__' with 'None' object
        // This will result in static binding.
        // For example: 'int.__eq__' will not bind 'self' to any number!
        return descr.call(withObject: false)
      }

      return .value(attribute)
    }

    // No attribute found in __dict__ (or bases):
    // use the descriptor from the metatype
    if let descr = metaDescriptor {
      return descr.call() // Will call '__get__' with self (PyType)
    }

    // If an ordinary attribute was found on the metatype, return it
    if let metaAttribute = metaAttribute {
      return .value(metaAttribute)
    }

    let msg = "type object '\(self.typeName)' has no attribute '\(name)'"
    return .attributeError(msg)
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    if let error = self.checkSetAttributeOnBuiltin() {
      return .error(error)
    }

    return AttributeHelper.extractName(from: name)
      .flatMap { self.setAttribute(name: $0, value: value) }
  }

  public func setAttribute(name: String, value: PyObject?) -> PyResult<PyNone> {
    if let error = self.checkSetAttributeOnBuiltin() {
      return .error(error)
    }

    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  private func checkSetAttributeOnBuiltin() -> PyBaseException? {
    if !self.isHeapType {
      let msg = "can't set attributes of built-in/extension type '\(self.name)'"
      return Py.newTypeError(msg: msg)
    }

    return nil
  }

  // sourcery: pymethod = __delattr__
  public func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return self.setAttribute(name: name, value: nil)
  }

  public func delAttribute(name: String) -> PyResult<PyNone> {
    return self.setAttribute(name: name, value: nil)
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  /// __dir__ for type objects: returns __dict__ and __bases__.
  ///
  /// We deliberately don't suck up its __class__, as methods belonging to the
  /// metaclass would probably be more confusing than helpful.
  public func dir() -> DirResult {
    return self.mro.reduce(into: DirResult()) { acc, base in
      acc.append(contentsOf: base.__dict__)
    }
  }

  // MARK: - Lookup

  /// Internal API to look for a name through the MRO.
  ///
  /// PyObject *
  /// _PyType_Lookup(PyTypeObject *type, PyObject *name)
  internal func lookup(name: PyString) -> PyObject? {
    for base in self.mro {
      if let result = base.__dict__.getItem(id: name) {
        return result
      }
    }

    return nil
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// static PyObject *
  /// type_call(PyTypeObject *type, PyObject *args, PyObject *kwds)
  internal func call(args: [PyObject],
                     kwargs: PyDictData?) -> PyResult<PyObject> {
    let object: PyObject
    switch self.call__new__(args: args, kwargs: kwargs) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    // Ugly exception: when the call was type(something),
    // don't call tp_init on the result.
    let hasSingleArg = args.count == 1
    let hasEmptyKwargs = kwargs?.isEmpty ?? true
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
                           kwargs: PyDictData?) -> PyResult<PyObject> {
    // Fast path for 'type' type.
    // Mostly because of how common type checks are (e.g. 'type(elsa)')
    if self === Py.types.type {
      return PyType.pyNew(type: self, args: args, kwargs: kwargs)
    }

    // '__new__' is a static method, so we can't just use 'callMethod'
    guard let newFn = self.lookup(name: Ids.__new__) else {
      return .typeError("cannot create '\(self.name)' instances")
    }

    let argsWithType = [self] + args
    return Py.call(callable: newFn, args: argsWithType, kwargs: kwargs).asResult
  }

  private func call__init__(object: PyObject,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyNone> {
    let result = Py.callMethod(on: object,
                               selector: "__init__",
                               args: args,
                               kwargs: kwargs)

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
    self.__dict__.clear()
    super.gcClean()
  }

  // MARK: - Helpers

  private func checkSetSpecialAttribute(name: String,
                                        value: PyObject?) -> PyResult<PyObject> {
    guard self.isHeapType else {
      return .typeError("can't set \(self.name).\(name)")
    }

    guard let value = value else {
      return .typeError("can't delete \(self.name).\(name)")
    }

    return .value(value)
  }
}
