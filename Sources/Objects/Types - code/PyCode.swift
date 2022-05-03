import VioletCore
import VioletBytecode

// cSpell:ignore codeobject

// In CPython:
// Objects -> codeobject.c

// (Unofficial) docs:
// https://tech.blog.aknin.name/2010/07/03/pythons-innards-code-objects/

// sourcery: pytype = code, isDefault
public struct PyCode: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = "Create a code object. Not for the faint of heart."

  // MARK: - Code

  // Due to how we generate layout code we have to have the same properties in
  // DEBUG and non-DEBUG code.
#if DEBUG
  public typealias CodeObject = VioletBytecode.CodeObject
#else
  public typealias CodeObject = Void
#endif

  // sourcery: storedProperty
  /// Code object from compiler.
  ///
  /// Available only in `DEBUG`.
  public var codeObject: PyCode.CodeObject {
    // We need to '#if' to silence compiler warning:
    // 'Property is accessed but result is unused'.
    // ^^ This is not exactly true, but I guess that having a 'Void' computed
    //    property is a but surprising to a compiler.
#if DEBUG
    return self.codeObjectPtr.pointee
#else
    return // Void
#endif
  }

  // MARK: - Names

  // sourcery: storedProperty
  /// Non-unique name of this code object.
  ///
  /// It will be:
  /// - module -> \<module\>
  /// - class -> class name
  /// - function -> function name
  /// - lambda -> \<lambda\>
  /// - generator -> \<genexpr\>
  /// - list comprehension -> \<listcomp\>
  /// - set comprehension -> \<setcomp\>
  /// - dictionary comprehension -> \<dictcomp\>
  public var name: PyString { self.namePtr.pointee }

  // sourcery: storedProperty
  /// Unique dot-separated qualified name.
  ///
  /// For example:
  /// ```c
  /// class frozen: <- qualified name: frozen
  ///   def elsa:   <- qualified name: frozen.elsa
  ///     pass
  /// ```
  public var qualifiedName: PyString { self.qualifiedNamePtr.pointee }

  // sourcery: storedProperty
  /// The filename from which the code was compiled.
  /// Will be `<stdin>` for code entered in the interactive interpreter
  /// or whatever name is given as the second argument to `compile`
  /// for code objects created with `compile`.
  public var filename: PyString { self.filenamePtr.pointee }

  // MARK: - Instructions

  // sourcery: storedProperty
  /// Instruction opcodes.
  /// CPython: `co_code`.
  public var instructions: [Instruction] { self.instructionsPtr.pointee }

  // MARK: - Lines

  // sourcery: storedProperty
  /// First line that contains a valid instruction.
  public var firstLine: SourceLine { self.firstLinePtr.pointee }

  // sourcery: storedProperty
  private var instructionLines: [SourceLine] { self.instructionLinesPtr.pointee }

  /// CPython: `co_lnotab` <- but not exactly the same.
  public func getLine(instructionIndex index: Int) -> SourceLine {
    let lines = self.instructionLines
    assert(0 <= index && index < lines.count)
    return lines[index]
  }

  // MARK: - Constants, labels

  // sourcery: storedProperty
  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  /// CPython: `co_consts`.
  public var constants: [PyObject] { self.constantsPtr.pointee }

  // sourcery: storedProperty
  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public var labels: [VioletBytecode.CodeObject.Label] { self.labelsPtr.pointee }

  // MARK: - Names

  // sourcery: storedProperty
  /// Names which aren’t covered by any of the other fields (they are not local
  /// variables, they are not free variables, etc) used by the bytecode.
  /// This includes names deemed to be in the global or builtin namespace
  /// as well as attributes (i.e., if you do foo.bar in a function, bar will
  /// be listed in its code object’s names).
  ///
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  /// CPython: `co_names`.
  public var names: [PyString] { self.namesPtr.pointee }

  // MARK: - Variables

  // sourcery: storedProperty
  /// Names of the local variables (including arguments).
  ///
  /// In the ‘richest’ case, `variableNames` contains (in order):
  /// - positional argument names (including optional ones)
  /// - keyword only argument names (again, both required and optional)
  /// - varargs argument name (i.e., *args)
  /// - kwds argument name (i.e., **kwargs)
  /// - any other local variable names.
  ///
  /// So you need to look at `argCount`, `posOnlyArgCount`, `kwOnlyArgCount` and `codeFlags`
  /// to fully interpret this
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_varnames`.
  public var variableNames: [MangledName] { self.variableNamesPtr.pointee }

  public var variableCount: Int {
    return self.variableNames.count
  }

  // MARK: - Cell variables

  // sourcery: storedProperty
  /// List of cell variable names.
  /// Cell = source for 'free' variable.
  ///
  /// [See docs.](https://docs.python.org/3/c-api/cell.html)
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_cellvars`.
  public var cellVariableNames: [MangledName] { self.cellVariableNamesPtr.pointee }

  public var cellVariableCount: Int {
    return self.cellVariableNames.count
  }

  // sourcery: storedProperty
  /// List of free variable names.
  ///
  /// 'Free variable' means a variable which is referenced by an expression
  /// but isn’t defined in it.
  /// In our case, it means a variable that is referenced in this code object
  /// but was defined and will be dereferenced to a cell in another code object
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_freevars`.
  public var freeVariableNames: [MangledName] { self.freeVariableNamesPtr.pointee }

  public var freeVariableCount: Int {
    return self.freeVariableNames.count
  }

  // MARK: - Count

  // sourcery: storedProperty
  /// The number of positional arguments the code object expects to receive,
  /// including those with default values (but excluding `*args`).
  /// CPython: `co_argcount`.
  public var argCount: Int { self.argCountPtr.pointee }

  // sourcery: storedProperty
  /// The number of positional only arguments the code object expects to receive,
  /// CPython: `co_posonlyargcount`.
  public var posOnlyArgCount: Int { self.posOnlyArgCountPtr.pointee }

  // sourcery: storedProperty
  /// The number of keyword arguments the code object can receive.
  /// CPython: `co_kwonlyargcount`.
  public var kwOnlyArgCount: Int { self.kwOnlyArgCountPtr.pointee }

  // MARK: - Predicted count

  // sourcery: storedProperty
  /// After executing this code we will store the stack count,
  /// so that the next execution avoids reallocations.
  public var predictedObjectStackCount: Int {
    get { self.predictedObjectStackCountPtr.pointee }
    nonmutating set { self.predictedObjectStackCountPtr.pointee = newValue }
  }

  // MARK: - Flags

  /// Various flags used during the compilation process.
  public private(set) var codeFlags: VioletBytecode.CodeObject.Flags {
    get {
      let custom = self.flags.customUInt16
      return VioletBytecode.CodeObject.Flags(rawValue: custom)
    }
    nonmutating set {
      let raw = newValue.rawValue
      self.flags.customUInt16 = raw
    }
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(_ py: Py, type: PyType, code: VioletBytecode.CodeObject) {
    self.initializeBase(py, type: type)

#if DEBUG
    self.codeObjectPtr.initialize(to: code)
#else
    self.codeObjectPtr.initialize(to: ())
#endif

    let totalArgs = Self.countArguments(code: code)
    assert(code.variableNames.count >= totalArgs)

    let name = py.intern(string: code.name)
    let qualifiedName = py.intern(string: code.qualifiedName)
    let filename = py.intern(string: code.filename)
    self.namePtr.initialize(to: name)
    self.qualifiedNamePtr.initialize(to: qualifiedName)
    self.filenamePtr.initialize(to: filename)

    self.instructionsPtr.initialize(to: code.instructions)
    self.firstLinePtr.initialize(to: code.firstLine)
    self.instructionLinesPtr.initialize(to: code.instructionLines)

    // We will convert constants and names here.
    // Otherwise we would have to convert them on each use.
    let constants = code.constants.map { PyCode.toObject(py, constant: $0) }
    self.constantsPtr.initialize(to: constants)

    self.labelsPtr.initialize(to: code.labels)

    let names = code.names.map(py.intern)
    self.namesPtr.initialize(to: names)
    self.variableNamesPtr.initialize(to: code.variableNames)
    self.cellVariableNamesPtr.initialize(to: code.cellVariableNames)
    self.freeVariableNamesPtr.initialize(to: code.freeVariableNames)

    self.argCountPtr.initialize(to: code.argCount)
    self.posOnlyArgCountPtr.initialize(to: code.posOnlyArgCount)
    self.kwOnlyArgCountPtr.initialize(to: code.kwOnlyArgCount)
    self.predictedObjectStackCountPtr.initialize(to: 0)

    self.codeFlags = code.flags
  }

  private static func countArguments(code: VioletBytecode.CodeObject) -> Int {
    let argCount = code.argCount
    let kwOnlyArgCount = code.kwOnlyArgCount
    let variableCount = code.variableNames.count

    if argCount <= variableCount && kwOnlyArgCount <= variableCount {
      let varArgs = code.flags.contains(.varArgs) ? 1 : 0
      let varKeywords = code.flags.contains(.varKeywords) ? 1 : 0
      return argCount + kwOnlyArgCount + varArgs + varKeywords
    }

    return variableCount + 1
  }

  private static func toObject(
    _ py: Py,
    constant: VioletBytecode.CodeObject.Constant
  ) -> PyObject {
    switch constant {
    case .true: return py.true.asObject
    case .false: return py.false.asObject
    case .none: return py.none.asObject
    case .ellipsis: return py.ellipsis.asObject

    case let .integer(i):
      return py.newInt(i).asObject
    case let .float(d):
      return py.newFloat(d).asObject
    case let .complex(real, imag):
      return py.newComplex(real: real, imag: imag).asObject

    case let .string(s):
      return py.newString(s).asObject
    case let .bytes(b):
      return py.newBytes(b).asObject

    case let .code(c):
      return py.newCode(code: c).asObject

    case let .tuple(t):
      let elements = t.map { PyCode.toObject(py, constant: $0) }
      return py.newTuple(elements: elements).asObject
    }
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyCode(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "name", value: zelf.name, includeInDescription: true)
    result.append(name: "qualifiedName", value: zelf.qualifiedName, includeInDescription: true)
    result.append(name: "filename", value: zelf.filename, includeInDescription: true)
    result.append(name: "codeFlags", value: zelf.codeFlags)
    result.append(name: "instructionCount", value: zelf.instructions.count)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(_ py: Py, zelf: PyCode, other: PyObject) -> CompareResult {
    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    // We are simplifying things a bit.
    // We should do property based equal instead, but comparing code objects
    // is not that frequent to waste time on this.
    //
    // If you change this then remember to also update '__hash__'.
    return .value(zelf.ptr === other.ptr)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__lt__)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__le__)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__gt__)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__ge__)
  }

  private static func compare(_ py: Py,
                              zelf: PyObject,
                              operation: CompareResult.Operation) -> CompareResult {
    guard Self.downcast(py, zelf) != nil else {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, operation)
    }

    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    // See the comment in '__eq__'.
    let result = py.hasher.hash(zelf.ptr)
    return .value(result)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let name = zelf.name.value
    let ptr = zelf.ptr
    let file = zelf.filename.value
    let line = zelf.firstLine
    let result = "<code object \(name) at \(ptr), file '\(file)', line \(line)>"
    return PyResult(py, interned: result)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Properties

  // sourcery: pyproperty = co_name
  internal static func co_name(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "co_name")
    }

    return PyResult(zelf.name)
  }

  // sourcery: pyproperty = co_filename
  internal static func co_filename(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "co_filename")
    }

    return PyResult(zelf.filename)
  }

  // sourcery: pyproperty = co_firstlineno
  internal static func co_firstlineno(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "co_firstlineno")
    }

    let result = Int(zelf.firstLine)
    return PyResult(py, result)
  }

  // sourcery: pyproperty = co_argcount
  internal static func co_argcount(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "co_argcount")
    }

    return PyResult(py, zelf.argCount)
  }

  // sourcery: pyproperty = co_posonlyargcount
  internal static func co_posonlyargcount(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "co_posonlyargcount")
    }

    return PyResult(py, zelf.posOnlyArgCount)
  }

  // sourcery: pyproperty = co_kwonlyargcount
  internal static func co_kwonlyargcount(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "co_kwonlyargcount")
    }

    return PyResult(py, zelf.kwOnlyArgCount)
  }

  // sourcery: pyproperty = co_nlocals
  internal static func co_nlocals(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "co_nlocals")
    }

    return PyResult(py, zelf.variableCount)
  }
}
