import Core
import Parser
import Bytecode

public struct CodeObject {

  /// Name of the class if the unit is for a class.
  /// Name of the function if the unit is for a function.
  /// Otherwise 'top'.
  public let name: String

  public var instructions = [Instruction]()
  public var locations    = [SourceLocation]()

  /// Jump targets.
  public var labelMap = [Label:UInt]()

  /// Names of positional arguments
  public var argNames = [String]()
  /// *args or *
  public var varargs = Vararg.none
  public var kwonlyArgNames = [String]()
  /// **kwargs or **
  public var varKeywords = Vararg.none

  public var isGenerator = false

  /*
   pub source_path: String,
   pub first_line_number: usize,
   */

  public init(name: String) {
    self.name = name
  }
}

/*
public enum CompilerScope {
  public static let module = 1
  public static let `class` = 2
  public static let function = 3
  public static let asyncFunction = 4
  public static let lambda = 5
  public static let comprehension = 5
}

/// The following items change on entry and exit of code blocks.
/// They must be saved and restored when returning to a block.
internal struct CompilerUnit {

  /// Name of the class if the unit is for a class.
  /// Name of the function if the unit is for a function.
  /// Otherwise 'top'.
  internal let name: String

  /// Type of the unit.
  /// Possible values are 'class', 'module' and 'function'.
  internal let type: ScopeType

  internal let scope: SymbolScope
  /*
   PyObject *u_qualname;  /* dot-separated qualified name (lazy) */

   /*
   The following fields are dicts that map objects to the index of them in co_XXX.
   The index is used as the argument for opcodes that refer to those collections.
   */
   PyObject *u_consts;    /* all constants */
   PyObject *u_names;     /* all names */
   PyObject *u_varnames;  /* local variables */
   PyObject *u_cellvars;  /* cell variables */
   PyObject *u_freevars;  /* free variables */

   PyObject *u_private;        /* for private name mangling */

   /* Pointer to the most recently allocated block.  By following b_list
   members, you can reach all early allocated blocks. */
   basicblock *u_blocks;
   basicblock *u_curblock; /* pointer to current block */

   int u_nfblocks;
   struct fblockinfo u_fblock[CO_MAXBLOCKS];
   */

  /// Number of arguments for block
  internal var argCount = 0
  /// Number of keyword only arguments for block
  internal var kwonlyArgCount = 0

  /// The first line number of the block
  internal var firstLineno = 0

  /// The line number for the current stmt
  internal var lineno = 0

  /// The offset of the current stmt
  internal var colOffset = 0

  /// Boolean to indicate whether instruction
  /// has been generated with current line number
  internal var linenoSet = false

  internal init(name: String, type: ScopeType, scope: SymbolScope) {
    self.name = name
    self.type = type
    self.scope = scope
  }
}
*/
