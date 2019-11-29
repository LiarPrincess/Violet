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

  private var name: String
  private var qualname: String
  private let bases: [PyType]
  private var mro:   [PyType]
  private var subclasses: [PyTypeWeakRef] = []
  private let attributes = Attributes()

  private var typeFlags = PyTypeFlags()

  internal var isHeapType: Bool {
    return self.typeFlags.contains(.heapType)
  }

  // Special hack for cyclic reference
  private unowned let _context: PyContext
  override internal var context: PyContext {
    return self._context
  }

  internal func setFlag(_ flag: PyTypeFlags) {
    self.typeFlags.insert(flag)
  }

  // MARK: - Init

  /// Special init for types where we have single base and `qualname` = `name`.
  internal convenience init(_ context: PyContext,
                            name: String,
                            doc:  String?,
                            type: PyType,
                            base: PyType) {
    let mro = MRO.linearize(baseClass: base)
    self.init(context, name: name, qualname: name, doc: doc, type: type, mro: mro)
  }

  /// Full init with all of the options.
  internal convenience init(_ context: PyContext,
                            name: String,
                            qualname: String,
                            doc:  String?,
                            type: PyType,
                            mro:  MRO) {
    self.init(context, name: name, doc: doc, mro: mro)
    self.setType(to: type)
  }

  /// Unsafe init without `type` property filled.
  ///
  /// NEVER EVER use this function!
  /// Reserved for `objectType` and `typeType`.
  ///
  /// If you really want to use it then do it by `PyType.initWithoutType` proxy
  /// (so that you don't use by accident).
  private init(_ context: PyContext, name: String, doc: String?, mro: MRO?) {
    self.name = name
    self.qualname = name
    self.bases = mro?.baseClasses ?? []
    self.mro = [] // temporary, until we are able to use self
    self._context = context

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

    self.attributes["__doc__"] = doc
      .map(DocHelper.getDocWithoutSignature)
      .map(context.builtins.newString) ?? context.builtins.none
  }

  /// NEVER EVER use this function!
  /// This is a reserved for `objectType` and `typeType`.
  internal static func initWithoutType(_ context: PyContext,
                                       name: String,
                                       doc:  String,
                                       base: PyType?) -> PyType {
    let mro = base.map(MRO.linearize(baseClass:))
    return PyType(context, name: name, doc: doc, mro: mro)
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__, setter = setName
  internal func getName() -> String {
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

  internal func setName(_ value: PyObject?) -> PyResult<()> {
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
  internal func getQualname() -> String {
    if self.isHeapType {
      return self.qualname
    }

    return self.getName()
  }

  internal func setQualname(_ value: PyObject?) -> PyResult<()> {
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
  internal func getDoc() -> PyResult<PyObject> {
    guard let doc = self.attributes.get(key: "__doc__") else {
      return .value(self.builtins.none)
    }

    if let descr = GetDescriptor.get(object: self, attribute: doc) {
      switch descr.call() {
      case let .value(o): return .value(o)
      case let .error(e): return .error(e)
      }
    }

    return .value(doc)
  }

  internal func setDoc(_ value: PyObject?) -> PyResult<()> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: "__doc__", value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    self.attributes.set(key: "__doc__", to: object)
    return .value()
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__, setter = setModule
  internal func getModule() -> PyResult<String> {
    switch self.getModuleRaw() {
    case .builtins:
      return .value("builtins")
    case .module(let name):
      return .value(name)
    case .error(let e):
      return .error(e)
    }
  }

  internal enum GetModuleRawResult {
    case builtins
    case module(String)
    case error(PyErrorEnum)
  }

  internal func getModuleRaw() -> GetModuleRawResult {
    if self.isHeapType {
      guard let object = self.attributes.get(key: "__module__") else {
        return .error(.attributeError("__module__"))
      }

      guard let module = object as? PyModule else {
        return .module(self.context._str(value: object))
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

  internal func setModule(_ value: PyObject?) -> PyResult<()> {
    let object: PyObject
    switch self.checkSetSpecialAttribute(name: "__module__", value: value) {
    case let .value(v): object = v
    case let .error(e): return .error(e)
    }

    self.attributes.set(key: "__module__", to: object)
    return .value()
  }

  // MARK: - Base

  // sourcery: pyproperty = __bases__, setter = setBases
  internal func getBases() -> PyTuple {
    return self.builtins.newTuple(self.getBasesRaw())
  }

  internal func getBasesRaw() -> [PyType] {
    return self.bases
  }

  internal func setBases(_ value: PyObject?) -> PyResult<()> {
    // Violet currently does not support this
    return .typeError("can't set \(self.name).__bases__")
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> Attributes {
    return self.attributes
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    switch self.getModuleRaw() {
    case .builtins:
      return .value("<class '\(self.name)'>")
    case .module(let module):
      return .value("<class '\(module).\(self.name)'>")
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Mro

  // sourcery: pyproperty = __mro__
  internal func getMRO() -> PyTuple {
    return self.builtins.newTuple(self.getMRORaw())
  }

  internal func getMRORaw() -> [PyType] {
    return self.mro
  }

  // MARK: - Subtypes

  internal func isSubtype(of type: PyType) -> Bool {
    return self.mro.contains { $0 === type }
  }

  /// PyExceptionInstance_Check
  internal var isException: Bool {
    let baseException = self.builtins.errorTypes.baseException
    return self.isSubtype(of: baseException)
  }

  // sourcery: pymethod = __subclasses__
  internal func getSubclasses() -> [PyType] {
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
    guard let nameString = name as? PyString else {
      return .typeError("attribute name must be string, not '\(name.typeName)'")
    }

    return self.getAttribute(name: nameString.value)
  }

  internal func getAttribute(name: String) -> PyResult<PyObject> {
    let metaType = self.type
    let metaAttribute = metaType.lookup(name: name)
    var metaDescriptor: GetDescriptor?

    // Look for the attribute in the metatype
    if let metaAttribute = metaAttribute {
      metaDescriptor = GetDescriptor.get(object: self, attribute: metaAttribute)
      if let desc = metaDescriptor, desc.isData {
        return desc.call()
      }
    }

    // No data descriptor found on metatype.
    // Look in __dict__ of this type and its bases
    if let attribute = self.lookup(name: name) {
      if let descr = GetDescriptor.get(object: self, attribute: attribute) {
        // NULL ;owner; indicates the descriptor was
        // found on the target object itself (or a base)
        return descr.call(withOwner: false)
      }

      return .value(attribute)
    }

    // No attribute found in __dict__ (or bases):
    // use the descriptor from the metatype
    if let descr = metaDescriptor {
      return descr.call()
    }

    // If an ordinary attribute was found on the metatype, return it now
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

    guard let nameString = name as? PyString else {
      return .error(AttributeHelper.nameTypeError(name: name))
    }

    return self.setAttribute(name: nameString.value, value: value)
  }

  internal func setAttribute(name: String, value: PyObject?) -> PyResult<PyNone> {
    if let error = self.checkSetAttributeOnBuiltin() {
      return .error(error)
    }

    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  private func checkSetAttributeOnBuiltin() -> PyErrorEnum? {
    if !self.isHeapType {
      let msg = "can't set attributes of built-in/extension type '\(self.name)'"
      return .typeError(msg)
    }

    return nil
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return self.setAttribute(name: name, value: nil)
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  /// __dir__ for type objects: returns __dict__ and __bases__.
  ///
  /// We deliberately don't suck up its __class__, as methods belonging to the
  /// metaclass would probably be more confusing than helpful.
  internal func dir() -> DirResult {
    return self.mro.reduce(into: DirResult()) { acc, base in
      acc.append(contentsOf: base.attributes.keys)
    }
  }

  // MARK: - Lookup

  /// Internal API to look for a name through the MRO.
  ///
  /// PyObject *
  /// _PyType_Lookup(PyTypeObject *type, PyObject *name)
  internal func lookup(name: String) -> PyObject? {
    for base in self.mro {
      if let result = base.attributes[name] {
        return result
      }
    }

    return nil
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// static PyObject *
  /// type_call(PyTypeObject *type, PyObject *args, PyObject *kwds)
  internal func call(args: PyObject,
                     kwargs: PyObject?) -> PyResultOrNot<PyObject> {
    let newResult = self.builtins.callMethod(on: self,
                                             selector: "__new__",
                                             args: args,
                                             kwargs: kwargs)
    let object: PyObject
    switch newResult {
    case .value(let o):
      object = o
    case .notImplemented:
      return .value(self.builtins.notImplemented)
    case .noSuchMethod:
      return .typeError("cannot create '\(self.name)' instances")
    case .methodIsNotCallable(let e), .error(let e):
      return .error(e)
    }

    // Ugly exception: when the call was type(something),
    // don't call tp_init on the result.
    if self === self.builtins.type
      && self.isSingleElementTuple(args: args)
      && self.isEmptyDictOrNil(kwargs: kwargs) {
      return .value(object)
    }

    // If the returned object is not an instance of type,
    // it won't be initialized.
    guard object.type.isSubtype(of: self) else {
      return .value(object)
    }

    // Call '__init__' (on object type not on self!).
    let initResult = self.builtins.callMethod(on: object.type,
                                              selector: "__init__",
                                              args: args,
                                              kwargs: kwargs)

    switch initResult {
    case .value, .noSuchMethod, .notImplemented:
      return .value(object)
    case .methodIsNotCallable(let e), .error(let e):
      return .error(e)
    }
  }

  private func isSingleElementTuple(args: PyObject) -> Bool {
    guard let tuple = args as? PyTuple else {
      return false
    }

    return tuple.data.count == 1
  }

  private func isEmptyDictOrNil(kwargs: PyObject?) -> Bool {
    guard let kwargs = kwargs else {
      return false
    }

    guard let kwargsDict = kwargs as? PyDict else {
      return false
    }

    return kwargsDict.elements.isEmpty
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
