import Foundation
import BigInt
import VioletCore

// In CPython:
// Python -> builtinmodule.c
// Python -> pythonrun.c
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3/library/functions.html
// https://docs.python.org/3.7/library/io.html

private let causeMsg: String = """

  The above exception was the direct cause of the following exception:


  """

private let contextMsg = """

  During handling of the above exception, another exception occurred:


  """

extension Py {

  // MARK: - Print

  /// static void
  /// print_exception(PyObject *f, PyObject *value)
  public func print(file: PyTextFile, error: PyBaseException) -> PyBaseException? {
    // This is what we are going after:
    // >>> raise AnnaException('Then don\'t run into fire!')
    // Traceback (most recent call last):
    //   File "<frozen.py>", line 2, in <elsa_walks_into_fire_module>
    // AnnaException: Then don't run into fire
    //
    // Regular reminder that Elsa outfit at the beginning of Frozen 2 was AMAZING…
    // You know, the one before she ran into water.
    // Yeah, there may be a pattern here…
    //
    // Also:
    // We could totally use '??' as monadic bind for errors and write this whole
    // function as a single line with just 'return' statement.
    // But we are not monsters…

    if let traceback = error.getTraceback() {
      if let e = self.print(file: file, traceback: traceback) {
        return e
      }
    }

    let errorObject = error.asObject
    if let e = self.printFileAndLine(file: file, error: errorObject) {
      return e
    }

    if let e = self.printModuleDotClassName(file: file, error: error) {
      return e
    }

    let str: String
    switch self.strString(errorObject) {
    case .value(let s) where s.isEmpty:
      str = "\n"
    case .value(let s):
      str = ": " + s + "\n"
    case .error:
      str = ": <exception str() failed>\n"
    }

    return file.write(self, string: str)
  }

  // MARK: - Print recursive

  /// This function will swallow any error and continue printing!
  ///
  /// static void
  /// print_exception_recursive(PyObject *f, PyObject *value, PyObject *seen)
  public func printRecursiveIgnoringErrors(file: PyTextFile,
                                           error: PyBaseException) {
    var alreadyPrinted = Set<ErrorId>()
    self.printRecursiveIgnoringErrors(file: file,
                                      error: error,
                                      alreadyPrinted: &alreadyPrinted)
  }

  /// This function will swallow any error and continue printing!
  ///
  /// static void
  /// print_exception_recursive(PyObject *f, PyObject *value, PyObject *seen)
  private func printRecursiveIgnoringErrors(file: PyTextFile,
                                            error: PyBaseException,
                                            alreadyPrinted: inout Set<ErrorId>) {
    // Mark it as 'already printed' (even though it was not yet printed),
    // to prevent infinite recursion.
    let id = self.newId(error)
    alreadyPrinted.insert(id)

    if let cause = error.getCause() {
      let causeId = self.newId(cause)
      if !alreadyPrinted.contains(causeId) {
        self.printRecursiveIgnoringErrors(file: file,
                                          error: cause,
                                          alreadyPrinted: &alreadyPrinted)

        _ = file.write(self, string: causeMsg) // Swallow error
      }
    } else if let context = error.getContext(), !error.getSuppressContext() {
      let contextId = self.newId(context)
      if !alreadyPrinted.contains(contextId) {
        self.printRecursiveIgnoringErrors(file: file,
                                          error: context,
                                          alreadyPrinted: &alreadyPrinted)

        _ = file.write(self, string: contextMsg) // Swallow error
      }
    }

    _ = self.print(file: file, error: error) // Swallow error (again…)
  }

  private typealias ErrorId = Int

  private func newId(_ error: PyBaseException) -> Int {
    return Int(bitPattern: error.ptr)
  }

  // MARK: - File and line

  private func printFileAndLine(file: PyTextFile, error: PyObject) -> PyBaseException? {
    assert(self.isException(object: error))

    let print_file_and_line = self.intern(string: "print_file_and_line")
    switch self.hasAttribute(object: error, name: print_file_and_line) {
    case .value(true): break
    case .value(false): return nil // Do nothing
    case .error(let e): return e // Ooops…
    }

    let filename: String
    switch self.getErrorAttribute(error: error, name: "filename") {
    case let .value(s): filename = s
    case let .error(e): return e
    }

    let lineno: String
    switch self.getErrorAttribute(error: error, name: "lineno") {
    case let .value(s): lineno = s
    case let .error(e): return e
    }

    let line = "  File \"\(filename)\", line \(lineno)\n"
    return file.write(self, string: line)
  }

  private func getErrorAttribute(error: PyObject, name: String) -> PyResultGen<String> {
    assert(self.isException(object: error))
    let key = self.intern(string: name)

    let object: PyObject
    switch self.getAttribute(object: error, name: key) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    return self.strString(object)
  }

  // MARK: - Module (dot) class

  private func printModuleDotClassName(file: PyTextFile,
                                       error: PyBaseException) -> PyBaseException? {
    let type = error.type
    assert(self.isException(type: type))

    // Module
    switch type.getModuleName(self) {
    case .builtins:
      break // do not write module
    case .string(let name):
      if let e = file.write(self, string: name) {
        return e
      }
      if let e = file.write(self, string: ".") {
        return e
      }
    case .error:
      if let e = file.write(self, string: "<unknown>.") {
        return e
      }
    }

    // Class name
    let className: String = {
      let typeName = type.getNameString()

      if let moduleEndIndex = typeName.firstIndex(of: ".") {
        let afterDot = typeName.index(after: moduleEndIndex)
        return String(typeName[afterDot...])
      }

      return typeName
    }()

    return file.write(self, string: className)
  }
}
