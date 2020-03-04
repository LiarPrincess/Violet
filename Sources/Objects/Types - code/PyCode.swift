import Core
import Bytecode

// In CPython:
// Objects -> codeobject.c

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
  public var name: String {
    return self.codeObject.name
  }

  /// Unique dot-separated qualified name.
  ///
  /// For example:
  /// ```c
  /// class frozen: <- qualified name: frozen
  ///   def elsa:   <- qualified name: frozen.elsa
  ///     pass
  /// ```
  public var qualifiedName: String {
    return self.codeObject.qualifiedName
  }

  /// Various flags used during the compilation process.
  public var codeFlags: CodeObjectFlags {
    return self.codeObject.flags
  }

  /// Name of the file that this code object was loaded from.
  public var filename: String {
    return self.codeObject.filename
  }

  // MARK: - Names, constants and labels

  /// We will convert `CodeObject.names` -> `[PyString]` in `init`.
  /// Otherwise we would have to convert them (`O(1)` + massive constants)
  /// on each use.
  private let _names: [PyString]

  /// List of strings (names used).
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  /// CPython: `co_names`.
  public var names: [PyString] {
    return self._names
  }

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

  // MARK: - Instructions

  /// Instruction opcodes.
  /// CPython: `co_code`.
  public var instructions: [Instruction] {
    return self.codeObject.instructions
  }

  /// Instruction locations.
  /// CPython: `co_lnotab` <- but not exactly the same.
  public func getLine(instructionIndex index: Int) -> SourceLine {
    let lines = self.codeObject.instructionLines
    assert(0 <= index && index < lines.count)
    return lines[index]
  }

  // MARK: - Variables

  public var variableCount: Int {
    return self.variableNames.count
  }

  /// List of local variable names.
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_varnames`.
  public var variableNames: [MangledName] {
    return self.codeObject.variableNames
  }

  public var cellVariableCount: Int {
    return self.cellVariableNames.count
  }

  /// List of cell variable names.
  /// Cell = source for 'free' variable.
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_cellvars`.
  public var cellVariableNames: [MangledName] {
    return self.codeObject.cellVariableNames
  }

  public var freeVariableCount: Int {
    return self.freeVariableNames.count
  }

  /// List of free variable names.
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_freevars`.
  public var freeVariableNames: [MangledName] {
    return self.codeObject.freeVariableNames
  }

  // MARK: - Count

  /// Argument count (excluding `*args`).
  /// CPython: `co_argcount`.
  public var argCount: Int {
    return self.codeObject.argCount
  }

  /// Keyword only argument count.
  /// CPython: `co_kwonlyargcount`.
  public var kwOnlyArgCount: Int {
    return self.codeObject.kwOnlyArgCount
  }

  // MARK: - Description

  override public var description: String {
    let firstLine = self.codeObject.firstLine
    return "PyCode(filename: \(self.filename), line: \(firstLine))"
  }

  // MARK: - Init

  internal init(code: CodeObject) {
    self.codeObject = code
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

  // MARK: - Dump

  public func dump() -> String {
    return self.codeObject.dump()
  }

  public func dumpInstruction(_ instruction: Instruction,
                              extendedArg: Int) -> String {
    return self.codeObject.dumpInstruction(instruction, extendedArg: extendedArg)
  }
}
