import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

public final class Builtins: PyModuleImplementation {

  internal static let moduleName = "builtins"

  internal static let doc = """
    Built-in functions, exceptions, and other objects.

    Noteworthy: None is the `nil' object; Ellipsis represents `...' in slices.
    """

  /// This dict will be used inside our `PyModule` instance.
  internal let __dict__: PyDict
  internal let py: Py

  internal init(_ py: Py) {
    self.py = py
    self.__dict__ = self.py.newDict()
    self.fill__dict__()
  }

  // MARK: - Properties

  internal struct Properties: CustomStringConvertible {

    internal static let none = Properties(value: "None")
    internal static let ellipsis = Properties(value: "Ellipsis")
    internal static let dotDotDot = Properties(value: "...")
    internal static let notImplemented = Properties(value: "NotImplemented")
    internal static let `true` = Properties(value: "True")
    internal static let `false` = Properties(value: "False")

    internal static let object = Properties(value: "object")
    internal static let bool = Properties(value: "bool")
    internal static let bytearray = Properties(value: "bytearray")
    internal static let bytes = Properties(value: "bytes")
    internal static let classmethod = Properties(value: "classmethod")
    internal static let complex = Properties(value: "complex")
    internal static let dict = Properties(value: "dict")
    internal static let enumerate = Properties(value: "enumerate")
    internal static let filter = Properties(value: "filter")
    internal static let float = Properties(value: "float")
    internal static let frozenset = Properties(value: "frozenset")
    internal static let int = Properties(value: "int")
    internal static let list = Properties(value: "list")
    internal static let map = Properties(value: "map")
    internal static let property = Properties(value: "property")
    internal static let range = Properties(value: "range")
    internal static let reversed = Properties(value: "reversed")
    internal static let set = Properties(value: "set")
    internal static let slice = Properties(value: "slice")
    internal static let staticmethod = Properties(value: "staticmethod")
    internal static let str = Properties(value: "str")
    internal static let `super` = Properties(value: "super")
    internal static let tuple = Properties(value: "tuple")
    internal static let type = Properties(value: "type")
    internal static let zip = Properties(value: "zip")

    internal static let arithmeticError = Properties(value: "ArithmeticError")
    internal static let assertionError = Properties(value: "AssertionError")
    internal static let attributeError = Properties(value: "AttributeError")
    internal static let baseException = Properties(value: "BaseException")
    internal static let blockingIOError = Properties(value: "BlockingIOError")
    internal static let brokenPipeError = Properties(value: "BrokenPipeError")
    internal static let bufferError = Properties(value: "BufferError")
    internal static let bytesWarning = Properties(value: "BytesWarning")
    internal static let childProcessError = Properties(value: "ChildProcessError")
    internal static let connectionAbortedError = Properties(value: "ConnectionAbortedError")
    internal static let connectionError = Properties(value: "ConnectionError")
    internal static let connectionRefusedError = Properties(value: "ConnectionRefusedError")
    internal static let connectionResetError = Properties(value: "ConnectionResetError")
    internal static let deprecationWarning = Properties(value: "DeprecationWarning")
    internal static let eofError = Properties(value: "EOFError")
    internal static let exception = Properties(value: "Exception")
    internal static let fileExistsError = Properties(value: "FileExistsError")
    internal static let fileNotFoundError = Properties(value: "FileNotFoundError")
    internal static let floatingPointError = Properties(value: "FloatingPointError")
    internal static let futureWarning = Properties(value: "FutureWarning")
    internal static let generatorExit = Properties(value: "GeneratorExit")
    internal static let importError = Properties(value: "ImportError")
    internal static let importWarning = Properties(value: "ImportWarning")
    internal static let indentationError = Properties(value: "IndentationError")
    internal static let indexError = Properties(value: "IndexError")
    internal static let interruptedError = Properties(value: "InterruptedError")
    internal static let isADirectoryError = Properties(value: "IsADirectoryError")
    internal static let keyError = Properties(value: "KeyError")
    internal static let keyboardInterrupt = Properties(value: "KeyboardInterrupt")
    internal static let lookupError = Properties(value: "LookupError")
    internal static let memoryError = Properties(value: "MemoryError")
    internal static let moduleNotFoundError = Properties(value: "ModuleNotFoundError")
    internal static let nameError = Properties(value: "NameError")
    internal static let notADirectoryError = Properties(value: "NotADirectoryError")
    internal static let notImplementedError = Properties(value: "NotImplementedError")
    internal static let osError = Properties(value: "OSError")
    internal static let overflowError = Properties(value: "OverflowError")
    internal static let pendingDeprecationWarning = Properties(value: "PendingDeprecationWarning")
    internal static let permissionError = Properties(value: "PermissionError")
    internal static let processLookupError = Properties(value: "ProcessLookupError")
    internal static let recursionError = Properties(value: "RecursionError")
    internal static let referenceError = Properties(value: "ReferenceError")
    internal static let resourceWarning = Properties(value: "ResourceWarning")
    internal static let runtimeError = Properties(value: "RuntimeError")
    internal static let runtimeWarning = Properties(value: "RuntimeWarning")
    internal static let stopAsyncIteration = Properties(value: "StopAsyncIteration")
    internal static let stopIteration = Properties(value: "StopIteration")
    internal static let syntaxError = Properties(value: "SyntaxError")
    internal static let syntaxWarning = Properties(value: "SyntaxWarning")
    internal static let systemError = Properties(value: "SystemError")
    internal static let systemExit = Properties(value: "SystemExit")
    internal static let tabError = Properties(value: "TabError")
    internal static let timeoutError = Properties(value: "TimeoutError")
    internal static let typeError = Properties(value: "TypeError")
    internal static let unboundLocalError = Properties(value: "UnboundLocalError")
    internal static let unicodeDecodeError = Properties(value: "UnicodeDecodeError")
    internal static let unicodeEncodeError = Properties(value: "UnicodeEncodeError")
    internal static let unicodeError = Properties(value: "UnicodeError")
    internal static let unicodeTranslateError = Properties(value: "UnicodeTranslateError")
    internal static let unicodeWarning = Properties(value: "UnicodeWarning")
    internal static let userWarning = Properties(value: "UserWarning")
    internal static let valueError = Properties(value: "ValueError")
    internal static let warning = Properties(value: "Warning")
    internal static let zeroDivisionError = Properties(value: "ZeroDivisionError")

    internal static let abs = Properties(value: "abs")
    internal static let any = Properties(value: "any")
    internal static let all = Properties(value: "all")
    internal static let sum = Properties(value: "sum")
    internal static let globals = Properties(value: "globals")
    internal static let locals = Properties(value: "locals")
    internal static let isinstance = Properties(value: "isinstance")
    internal static let issubclass = Properties(value: "issubclass")
    internal static let next = Properties(value: "next")
    internal static let iter = Properties(value: "iter")
    internal static let bin = Properties(value: "bin")
    internal static let oct = Properties(value: "oct")
    internal static let hex = Properties(value: "hex")
    internal static let chr = Properties(value: "chr")
    internal static let ord = Properties(value: "ord")
    internal static let __build_class__ = Properties(value: "__build_class__")
    internal static let hash = Properties(value: "hash")
    internal static let id = Properties(value: "id")
    internal static let dir = Properties(value: "dir")
    internal static let exec = Properties(value: "exec")
    internal static let eval = Properties(value: "eval")
    internal static let breakpoint = Properties(value: "breakpoint")
    internal static let vars = Properties(value: "vars")
    internal static let input = Properties(value: "input")
    internal static let format = Properties(value: "format")
    internal static let help = Properties(value: "help")
    internal static let memoryview = Properties(value: "memoryview")
    internal static let repr = Properties(value: "repr")
    internal static let ascii = Properties(value: "ascii")
    internal static let len = Properties(value: "len")
    internal static let sorted = Properties(value: "sorted")
    internal static let callable = Properties(value: "callable")
    internal static let __import__ = Properties(value: "__import__")
    internal static let compile = Properties(value: "compile")
    internal static let round = Properties(value: "round")
    internal static let divmod = Properties(value: "divmod")
    internal static let pow = Properties(value: "pow")
    internal static let print = Properties(value: "print")
    internal static let open = Properties(value: "open")
    internal static let getattr = Properties(value: "getattr")
    internal static let hasattr = Properties(value: "hasattr")
    internal static let setattr = Properties(value: "setattr")
    internal static let delattr = Properties(value: "delattr")
    internal static let min = Properties(value: "min")
    internal static let max = Properties(value: "max")

    private let value: String

    internal var description: String {
      return self.value
    }

    // Private so we can't create new values from the outside.
    private init(value: String) {
      self.value = value
    }
  }
}
