import VioletCore
import VioletBytecode

// swiftlint:disable file_length
// cSpell:ignore codeobject

// In CPython:
// Objects -> codeobject.c

// (Unofficial) docs:
// https://tech.blog.aknin.name/2010/07/03/pythons-innards-code-objects/

// sourcery: pytype = code, default
public class PyCode: PyObject {

  // MARK: - Types

  public enum Constant {
    case `true`
    case `false`
    case none
    case ellipsis
    case integer(PyInt)
    case float(PyFloat)
    case complex(PyComplex)
    case string(PyString)
    case bytes(PyBytes)
    case code(PyCode)
    case tuple(PyTuple)

    public var asObject: PyObject {
      switch self {
      case .true: return Py.true
      case .false: return Py.false
      case .none: return Py.none
      case .ellipsis: return Py.ellipsis
      case let .integer(object): return object
      case let .float(object): return object
      case let .complex(object): return object
      case let .string(object): return object
      case let .bytes(object): return object
      case let .code(object): return object
      case let .tuple(object): return object
      }
    }
  }

  // MARK: - Basic properties

  internal static let doc: String = """
    Create a code object. Not for the faint of heart.
    """

  public let codeObject: CodeObject

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
  public var name: PyString

  /// Unique dot-separated qualified name.
  ///
  /// For example:
  /// ```c
  /// class frozen: <- qualified name: frozen
  ///   def elsa:   <- qualified name: frozen.elsa
  ///     pass
  /// ```
  public var qualifiedName: PyString

  /// Various flags used during the compilation process.
  public var codeFlags: CodeObject.Flags {
    return self.codeObject.flags
  }

  public var firstLine: SourceLine {
    return self.codeObject.firstLine
  }

  /// The filename from which the code was compiled.
  /// Will be `<stdin>` for code entered in the interactive interpreter
  /// or whatever name is given as the second argument to `compile`
  /// for code objects created with `compile`.
  public var filename: PyString

  // MARK: - Instructions

  /// Instruction opcodes.
  /// CPython: `co_code`.
  public var instructions: [Instruction] {
    return self.codeObject.instructions
  }

  /// CPython: `co_lnotab` <- but not exactly the same.
  public func getLine(instructionIndex index: Int) -> SourceLine {
    let lines = self.codeObject.instructionLines
    assert(0 <= index && index < lines.count)
    return lines[index]
  }

  // MARK: - Constants

  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  /// CPython: `co_consts`.
  public let constants: [Constant]

  // MARK: - Labels

  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public var labels: [CodeObject.Label] {
    return self.codeObject.labels
  }

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

  public var variableCount: Int {
    return self.variableNames.count
  }

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
  public var variableNames: [MangledName] {
    return self.codeObject.variableNames
  }

  // MARK: - Cell variables

  public var cellVariableCount: Int {
    return self.cellVariableNames.count
  }

  /// List of cell variable names.
  /// Cell = source for 'free' variable.
  ///
  /// [See docs.](https://docs.python.org/3/c-api/cell.html)
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_cellvars`.
  public var cellVariableNames: [MangledName] {
    return self.codeObject.cellVariableNames
  }

  // MARK: - Free variables

  public var freeVariableCount: Int {
    return self.freeVariableNames.count
  }

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
  public var freeVariableNames: [MangledName] {
    return self.codeObject.freeVariableNames
  }

  // MARK: - Count

  /// The number of positional arguments the code object expects to receive,
  /// including those with default values (but excluding `*args`).
  /// CPython: `co_argcount`.
  public var argCount: Int {
    return self.codeObject.argCount
  }

  /// The number of keyword arguments the code object can receive.
  /// CPython: `co_kwonlyargcount`.
  public var kwOnlyArgCount: Int {
    return self.codeObject.kwOnlyArgCount
  }

  /// The number of local variables used in the code object (including arguments).
  /// CPython: `co_nlocals`.
  public var localsCount: Int {
    return self.variableCount
  }

  // MARK: - Description

  override public var description: String {
    let name = self.qualifiedName.value
    let file = self.filename.value
    return "PyCode(qualifiedName: '\(name)', file: \(file))"
  }

  // MARK: - Init

  internal init(code: CodeObject) {
    let totalArgs = PyCode.totalArgs(code: code)
    assert(code.variableNames.count >= totalArgs)

    self.codeObject = code
    self.name = Py.intern(string: code.name)
    self.qualifiedName = Py.intern(string: code.qualifiedName)
    self.filename = Py.intern(string: code.filename)

    // We will convert constants and names here.
    // Otherwise we would have to convert them on each use.
    self.constants = code.constants.map(PyCode.intern(constant:))
    self.names = code.names.map(Py.intern)

    super.init(type: Py.types.code)
  }

  private static func totalArgs(code: CodeObject) -> Int {
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

  private static func intern(constant: CodeObject.Constant) -> Constant {
    switch constant {
    case .true: return .true
    case .false: return .false
    case .none: return .none
    case .ellipsis: return .ellipsis

    case let .integer(i):
      return .integer(Py.newInt(i))
    case let .float(d):
      return .float(Py.newFloat(d))
    case let .complex(real, imag):
      return .complex(Py.newComplex(real: real, imag: imag))

    case let .string(s):
      return .string(Py.newString(s))
    case let .bytes(b):
      return .bytes(Py.newBytes(b))

    case let .code(c):
      return .code(Py.newCode(code: c))

    case let .tuple(t):
      let elements = t.map { PyCode.intern(constant: $0).asObject }
      return .tuple(Py.newTuple(elements: elements))
    }
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    // We are simplifying things a bit.
    // We should do property based equal instead, but comparing code objects
    // is not that frequent to waste time on this.
    //
    // If you change this then remember to also update '__hash__'.
    return .value(self === other)
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    // See the comment in '__eq__'.
    let id = ObjectIdentifier(self)
    return .value(Py.hasher.hash(id))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    let name = self.codeObject.name
    let ptr = self.ptr
    let file = self.codeObject.filename
    let line = self.codeObject.firstLine
    return .value("<code object \(name) at \(ptr), file '\(file)', line \(line)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
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
    return self.localsCount
  }
}
