import Core
import Bytecode

// In CPython:
// Objects -> codeobject.c

// (Unofficial) docs:
// https://tech.blog.aknin.name/2010/07/03/pythons-innards-code-objects/

// swiftlint:disable file_length

// sourcery: pytype = code, default
public class PyCode: PyObject {

  internal static let doc: String = """
    Create a code object. Not for the faint of heart.
    """

  private let codeObject: CodeObject

  // MARK: - Basic

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
  public var codeFlags: CodeObjectFlags {
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

  // MARK: - Constants and labels

  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  /// CPython: `co_consts`.
  public var constants: [Constant] {
    return self.codeObject.constants
  }

  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public var labels: [Int] {
    return self.codeObject.labels
  }

  // MARK: - Names

  /// We will convert `CodeObject.names` -> `[PyString]` in `init`.
  /// Otherwise we would have to convert them (`O(1)` + massive constants)
  /// on each use.
  private let _names: [PyString]

  /// Names which aren’t covered by any of the other fields (they are not local
  /// variables, they are not free variables, etc) used by the bytecode.
  /// This includes names deemed to be in the global or builtin namespace
  /// as well as attributes (i.e., if you do foo.bar in a function, bar will
  /// be listed in its code object’s names).
  ///
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  /// CPython: `co_names`.
  public var names: [PyString] {
    return self._names
  }

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
    let firstLine = self.codeObject.firstLine
    return "PyCode(filename: \(self.filename), line: \(firstLine))"
  }

  // MARK: - Init

  internal init(code: CodeObject) {
    self.codeObject = code
    self.name = Py.getInterned(code.name)
    self.qualifiedName = Py.getInterned(code.qualifiedName)
    self.filename = Py.getInterned(code.filename)
    self._names = code.names.map(Py.getInterned)
    super.init(type: Py.types.code)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    // We are simplifing things a bit.
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
    let ptr = self.ptrString
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

  // MARK: - Dump

  public func dump() -> String {
    return self.codeObject.dump()
  }

  public func dumpInstruction(_ instruction: Instruction,
                              extendedArg: Int) -> String {
    return self.codeObject.dumpInstruction(instruction, extendedArg: extendedArg)
  }
}
