// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

import Foundation
import BigInt
import FileSystem
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

public struct Py {

  public var `true`: PyBool { fatalError() }
  public var `false`: PyBool { fatalError() }
  public var none: PyNone { fatalError() }
  public var ellipsis: PyEllipsis { fatalError() }
  public var notImplemented: PyNotImplemented { fatalError() }
  public var emptyTuple: PyTuple { fatalError() }
  public var emptyString: PyString { fatalError() }
  public var emptyBytes: PyBytes { fatalError() }
  public var emptyFrozenSet: PyFrozenSet { fatalError() }

  public let memory = PyMemory()
  public var types: Py.Types { fatalError() }
  public var errorTypes: Py.ErrorTypes { fatalError() }
  public var cast: PyCast { fatalError() }
  internal var hasher: Hasher { fatalError() }

  public var delegate: PyDelegate { fatalError() }
  public var fileSystem: PyFileSystem { fatalError() }

  internal var builtins: Builtins { fatalError() }
  internal var sys: Sys { fatalError() }
  internal var _warnings: UnderscoreWarnings { fatalError() }

  internal var sysModule: PyModule { fatalError() }
  internal var _impModule: PyModule { fatalError() }
  internal var builtinsModule: PyModule { fatalError() }

  // MARK: - New

  public func newObject(type: PyType? = nil) -> PyObject { fatalError() } // default type

  internal func newType(
    name: String,
    qualname: String,
    flags: PyType.TypeFlags,
    base: PyType,
    mro: MethodResolutionOrder,
    layout: PyType.MemoryLayout,
    staticMethods: PyStaticCall.KnownNotOverriddenMethods,
    debugFn: @escaping PyType.DebugFn,
    deinitialize: @escaping PyType.DeinitializeFn
  ) -> PyType {
    let metatype = self.types.type
    return self.memory.newType(self,
                               type: metatype,
                               name: name,
                               qualname: qualname,
                               flags: flags,
                               base: base,
                               bases: mro.baseClasses,
                               mroWithoutSelf: mro.resolutionOrder,
                               subclasses: [],
                               layout: layout,
                               staticMethods: staticMethods,
                               debugFn: debugFn,
                               deinitialize: deinitialize)
  }

  // MARK: - Other

  internal func getInterned(int: Int) -> PyInt? { fatalError() }
  internal func getInterned(int: BigInt) -> PyInt? { fatalError() }

  public func intern(scalar: UnicodeScalar) -> PyString { fatalError() }
  public func intern(string: String) -> PyString { fatalError() }

  public func get__dict__(object: PyObject) -> PyDict? { fatalError() }

  // MARK: - Errors

  public func newInvalidSelfArgumentError(object: PyObject,
                                          expectedType: String,
                                          swiftFnName: StaticString) -> PyTypeError {
    // Note that 'swiftFnName' is a full selector!
    // For example: '__repr__(_:zelf:)'
    fatalError()
  }

  // 'IndentationError' is a subclass of 'SyntaxError' with custom 'init'
  // ImportError: Exception # Import can't find module, or can't find name in module.
  // ModuleNotFoundError: ImportError # Module not found.
  //
  // SyntaxError: Exception # Invalid syntax.
  // IndentationError: SyntaxError # Improper indentation.
  // TabError: IndentationError # Improper mixture of spaces and tabs.

  public func newIndentationError(message: String?,
                                  filename: String?,
                                  lineno: BigInt?,
                                  offset: BigInt?,
                                  text: String?,
                                  printFileAndLine: Bool?) -> PyIndentationError { fatalError() }

  public func newIndentationError(message: PyString?,
                                  filename: PyString?,
                                  lineno: PyInt?,
                                  offset: PyInt?,
                                  text: PyString?,
                                  printFileAndLine: PyBool?) -> PyIndentationError { fatalError() }
}
