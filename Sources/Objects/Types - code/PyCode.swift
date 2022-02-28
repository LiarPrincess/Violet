/* MARKER
import VioletCore
import VioletBytecode

// swiftlint:disable file_length
// cSpell:ignore codeobject

// In CPython:
// Objects -> codeobject.c

// (Unofficial) docs:
// https://tech.blog.aknin.name/2010/07/03/pythons-innards-code-objects/

// sourcery: pytype = code, isDefault
public final class PyCode: PyObject, CustomReflectable {

  // MARK: - Basic properties

  // sourcery: pytypedoc
  internal static let doc = "Create a code object. Not for the faint of heart."

  #if DEBUG
  public let codeObject: CodeObject
  #endif

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
  public let name: PyString

  /// Unique dot-separated qualified name.
  ///
  /// For example:
  /// ```c
  /// class frozen: <- qualified name: frozen
  ///   def elsa:   <- qualified name: frozen.elsa
  ///     pass
  /// ```
  public let qualifiedName: PyString

  /// The filename from which the code was compiled.
  /// Will be `<stdin>` for code entered in the interactive interpreter
  /// or whatever name is given as the second argument to `compile`
  /// for code objects created with `compile`.
  public let filename: PyString

  /// Various flags used during the compilation process.
  public private(set) var codeFlags: CodeObject.Flags {
    get {
      let custom = self.flags.customUInt16
      return CodeObject.Flags(rawValue: custom)
    }
    set {
      let raw = newValue.rawValue
      self.flags.customUInt16 = raw
    }
  }

  // MARK: - Instructions

  /// Instruction opcodes.
  /// CPython: `co_code`.
  public let instructions: [Instruction]

  // MARK: - Lines

  /// First line that contains a valid instruction.
  public let firstLine: SourceLine

  private let instructionLines: [SourceLine]

  /// CPython: `co_lnotab` <- but not exactly the same.
  public func getLine(instructionIndex index: Int) -> SourceLine {
    let lines = self.instructionLines
    assert(0 <= index && index < lines.count)
    return lines[index]
  }

  // MARK: - Constants

  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  /// CPython: `co_consts`.
  public let constants: [PyObject]

  // MARK: - Labels

  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public let labels: [CodeObject.Label]

  // MARK: - Names

  /// Names which aren’t covered by any of the other fields (they are not local
  /// variables, they are not free variables, etc) used by the bytecode.
  /// This includes names deemed to be in the global or builtin namespace
  /// as well as attributes (i.e., if you do foo.bar in a function, bar will
  /// be listed in its code object’s names).
  ///
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  /// CPython: `co_names`.
  public let names: [PyString]

  // MARK: - Variables

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
  public let variableNames: [MangledName]

  public var variableCount: Int {
    return self.variableNames.count
  }

  // MARK: - Cell variables

  /// List of cell variable names.
  /// Cell = source for 'free' variable.
  ///
  /// [See docs.](https://docs.python.org/3/c-api/cell.html)
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_cellvars`.
  public let cellVariableNames: [MangledName]

  public var cellVariableCount: Int {
    return self.cellVariableNames.count
  }

  // MARK: - Free variables

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
  public let freeVariableNames: [MangledName]

  public var freeVariableCount: Int {
    return self.freeVariableNames.count
  }

  // MARK: - Count

  /// The number of positional arguments the code object expects to receive,
  /// including those with default values (but excluding `*args`).
  /// CPython: `co_argcount`.
  public let argCount: Int

  /// The number of keyword arguments the code object can receive.
  /// CPython: `co_kwonlyargcount`.
  public let kwOnlyArgCount: Int

  // MARK: - Mirror

  // We use mirrors to create description.
  public var customMirror: Mirror {
    let name = self.name.value
    let qualifiedName = self.qualifiedName.value
    let filename = self.filename.value

    return Mirror(
      self,
      children: [
        "name": name,
        "qualifiedName": qualifiedName,
        "codeFlags": self.codeFlags,
        "instructionCount": self.instructions.count,
        "filename": filename
      ]
    )
  }

  // MARK: - Init

  internal init(code: CodeObject) {
    #if DEBUG
    self.codeObject = code
    #endif

    let totalArgs = PyCode.countArguments(code: code)
    assert(code.variableNames.count >= totalArgs)

    self.name = Py.intern(string: code.name)
    self.qualifiedName = Py.intern(string: code.qualifiedName)
    self.filename = Py.intern(string: code.filename)

    self.instructions = code.instructions
    self.firstLine = code.firstLine
    self.instructionLines = code.instructionLines

    // We will convert constants and names here.
    // Otherwise we would have to convert them on each use.
    self.constants = code.constants.map(PyCode.toObject(constant:))
    self.labels = code.labels

    self.names = code.names.map(Py.intern)
    self.variableNames = code.variableNames
    self.cellVariableNames = code.cellVariableNames
    self.freeVariableNames = code.freeVariableNames

    self.argCount = code.argCount
    self.kwOnlyArgCount = code.kwOnlyArgCount

    super.init(type: Py.types.code)

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

  private static func toObject(constant: CodeObject.Constant) -> PyObject {
    switch constant {
    case .true: return Py.true
    case .false: return Py.false
    case .none: return Py.none
    case .ellipsis: return Py.ellipsis

    case let .integer(i):
      return Py.newInt(i)
    case let .float(d):
      return Py.newFloat(d)
    case let .complex(real, imag):
      return Py.newComplex(real: real, imag: imag)

    case let .string(s):
      return Py.newString(s)
    case let .bytes(b):
      return Py.newBytes(b)

    case let .code(c):
      return Py.newCode(code: c)

    case let .tuple(t):
      let elements = t.map(PyCode.toObject(constant:))
      return Py.newTuple(elements: elements)
    }
  }

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