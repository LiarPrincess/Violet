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

extension PyInstance {

  // MARK: - Print

  /// static void
  /// print_exception(PyObject *f, PyObject *value)
  public func print(error: PyBaseException,
                    file: PyTextFile) -> PyBaseException? {
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
      if let e = self.print(traceback: traceback, file: file) {
        return e
      }
    }

    if let e = self.printFileAndLine(error: error, file: file) {
      return e
    }

    if let e = self.printModuleDotClassName(error: error, file: file) {
      return e
    }

    let str: String = {
      switch self.strString(object: error) {
      case .value(let s) where s.isEmpty:
        return "\n"
      case .value(let s):
        return ": " + s + "\n"
      case .error:
        return ": <exception str() failed>\n"
      }
    }()

    return self.write(file: file, string: str)
  }

  // MARK: - Print recursive

  /// This function will swallow any error and continue printing!
  ///
  /// static void
  /// print_exception_recursive(PyObject *f, PyObject *value, PyObject *seen)
  public func printRecursiveIgnoringErrors(error: PyBaseException,
                                           file: PyTextFile) {
    var alreadyPrinted = Set<ObjectIdentifier>()
    self.printRecursiveIgnoringErrors(error: error,
                                      file: file,
                                      alreadyPrinted: &alreadyPrinted)
  }

  /// This function will swallow any error and continue printing!
  ///
  /// static void
  /// print_exception_recursive(PyObject *f, PyObject *value, PyObject *seen)
  private func printRecursiveIgnoringErrors(error: PyBaseException,
                                            file: PyTextFile,
                                            alreadyPrinted: inout Set<ObjectIdentifier>) {
    // Mark it as 'already printed' (even though it was not yet printed),
    // to prevent infinite recursion.
    let id = ObjectIdentifier(error)
    alreadyPrinted.insert(id)

    if let cause = error.getCause() {
      let causeId = ObjectIdentifier(cause)
      if !alreadyPrinted.contains(causeId) {
        self.printRecursiveIgnoringErrors(error: cause,
                                          file: file,
                                          alreadyPrinted: &alreadyPrinted)

        _ = self.write(file: file, string: causeMsg) // swallow error
      }
    } else if let context = error.getContext(), !error.getSuppressContext() {
      let contextId = ObjectIdentifier(context)
      if !alreadyPrinted.contains(contextId) {
        self.printRecursiveIgnoringErrors(error: context,
                                          file: file,
                                          alreadyPrinted: &alreadyPrinted)

        _ = self.write(file: file, string: contextMsg) // swallow error
      }
    }

    _ = self.print(error: error, file: file) // swallow error (again…)
  }

  // MARK: - File and line

  private func printFileAndLine(error: PyBaseException,
                                file: PyTextFile) -> PyBaseException? {
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
    return self.write(file: file, string: line)
  }

  private func getErrorAttribute(error: PyBaseException,
                                 name: String) -> PyResult<String> {
    let key = self.intern(string: name)

    let object: PyObject
    switch self.getAttribute(object: error, name: key) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    return self.strString(object: object)
  }

  // MARK: - Module (dot) class

  private func printModuleDotClassName(error: PyBaseException,
                                       file: PyTextFile) -> PyBaseException? {
    let type = error.type
    assert(type.isException)

    // Module
    switch type.getModuleString() {
    case .builtins:
      break // do not write module
    case .string(let name):
      if let e = self.write(file: file, string: name + ".") {
        return e
      }
    case .error:
      if let e = self.write(file: file, string: "<unknown>.") {
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

    return self.write(file: file, string: className)
  }

  // MARK: - Write

  private func write(file: PyTextFile, string: String) -> PyBaseException? {
    switch file.write(string: string) {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }
}
