import VioletCore
import VioletBytecode

// swiftlint:disable file_length
// cSpell:ignore codeobject

// In CPython:
// Objects -> codeobject.c

// (Unofficial) docs:
// https://tech.blog.aknin.name/2010/07/03/pythons-innards-code-objects/

// sourcery: pytype = code, isDefault
public struct PyCode: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = "Create a code object. Not for the faint of heart."

  // MARK: - Name

  // sourcery: includeInLayout
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

  // sourcery: includeInLayout
  /// Unique dot-separated qualified name.
  ///
  /// For example:
  /// ```c
  /// class frozen: <- qualified name: frozen
  ///   def elsa:   <- qualified name: frozen.elsa
  ///     pass
  /// ```
  public var qualifiedName: PyString { self.qualifiedNamePtr.pointee }

  // sourcery: includeInLayout
  /// The filename from which the code was compiled.
  /// Will be `<stdin>` for code entered in the interactive interpreter
  /// or whatever name is given as the second argument to `compile`
  /// for code objects created with `compile`.
  public var filename: PyString { self.filenamePtr.pointee }

  // MARK: - Instructions

  // sourcery: includeInLayout
  /// Instruction opcodes.
  /// CPython: `co_code`.
  public var instructions: [Instruction] { self.instructionsPtr.pointee }

  // MARK: - Lines

  // sourcery: includeInLayout
  /// First line that contains a valid instruction.
  public var firstLine: SourceLine { self.firstLinePtr.pointee }

  // sourcery: includeInLayout
  private var instructionLines: [SourceLine] { self.instructionLinesPtr.pointee }

  /// CPython: `co_lnotab` <- but not exactly the same.
  public func getLine(instructionIndex index: Int) -> SourceLine {
    let lines = self.instructionLines
    assert(0 <= index && index < lines.count)
    return lines[index]
  }

  // MARK: - Constants

  // sourcery: includeInLayout
  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  /// CPython: `co_consts`.
  public var constants: [PyObject] { self.constantsPtr.pointee }

  // MARK: - Labels

  // sourcery: includeInLayout
  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public var labels: [CodeObject.Label] { self.labelsPtr.pointee }

  // MARK: - Names

  // sourcery: includeInLayout
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

  // sourcery: includeInLayout
  /// Names of the local variables (including arguments).
  ///
  /// In the ‘richest’ case, `variableNames` contains (in order):
  /// - positional argument names (including optional ones)
  /// - keyword only argument names (again, both required and optional)
  /// - varargs argument name (i.e., *args)
  /// - kwds argument name (i.e., **kwargs)
  /// - any other local variable names.
  ///
  /// So you need to look at `argCount`, `kwOnlyArgCount` and `codeFlags`
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

  // sourcery: includeInLayout
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

  // sourcery: includeInLayout
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

  // sourcery: includeInLayout
  /// The number of positional arguments the code object expects to receive,
  /// including those with default values (but excluding `*args`).
  /// CPython: `co_argcount`.
  internal var argCount: Int { self.argCountPtr.pointee }

  // sourcery: includeInLayout
  /// The number of keyword arguments the code object can receive.
  /// CPython: `co_kwonlyargcount`.
  internal var kwOnlyArgCount: Int { self.kwOnlyArgCountPtr.pointee }

  /// Various flags used during the compilation process.
  public private(set) var codeFlags: CodeObject.Flags {
    get {
      let custom = self.flags.customUInt16
      return CodeObject.Flags(rawValue: custom)
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

  internal func initialize(_ py: Py, type: PyType, code: CodeObject) {
    self.header.initialize(py, type: type)

    let totalArgs = PyCode.countArguments(code: code)
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
    self.kwOnlyArgCountPtr.initialize(to: code.kwOnlyArgCount)

    self.codeFlags = code.flags
  }

  private static func countArguments(code: CodeObject) -> Int {
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

  private static func toObject(_ py: Py, constant: CodeObject.Constant) -> PyObject {
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
  internal func beforeDeinitialize() { }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyCode(ptr: ptr)
    return "PyCode(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

//  public var customMirror: Mirror {
//    let name = self.name.value
//    let qualifiedName = self.qualifiedName.value
//    let filename = self.filename.value
//
//    return Mirror(
//      self,
//      children: [
//        "name": name,
//        "qualifiedName": qualifiedName,
//        "codeFlags": self.codeFlags,
//        "instructionCount": self.instructions.count,
//        "filename": filename
//      ]
//    )
//  }
}

/* MARKER

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    // We are simplifying things a bit.
    // We should do property based equal instead, but comparing code objects
    // is not that frequent to waste time on this.
    //
    // If you change this then remember to also update '__hash__'.
    return .value(self === other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyHash {
    // See the comment in '__eq__'.
    let id = ObjectIdentifier(self)
    return Py.hasher.hash(id)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    let name = self.name.value
    let ptr = self.ptr
    let file = self.filename.value
    let line = self.firstLine
    return "<code object \(name) at \(ptr), file '\(file)', line \(line)>"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Properties

  // sourcery: pyproperty = co_name
  internal func getName() -> PyString {
    return self.name
  }

  // sourcery: pyproperty = co_filename
  internal func getFilename() -> PyString {
    return self.filename
  }

  // sourcery: pyproperty = co_firstlineno
  internal func getFirstLineNo() -> Int {
    return Int(self.firstLine)
  }

  // sourcery: pyproperty = co_argcount
  internal func getArgCount() -> Int {
    return self.argCount
  }

  // sourcery: pyproperty = co_kwonlyargcount
  internal func getKwOnlyArgCount() -> Int {
    return self.kwOnlyArgCount
  }

  // sourcery: pyproperty = co_nlocals
  internal func getNLocals() -> Int {
    return self.variableCount
  }
}

*/
