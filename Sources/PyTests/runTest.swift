import Foundation
import VioletCore
import VioletObjects
import VioletVM

// This will leak memory on every call.
// (because we do not have GC to break circular references)
internal func runTest(file: URL) {
  print(file.lastPathComponent)

  var arguments = Arguments()
  let environment = Environment()
  arguments.script = file.path

  let vm = VM(arguments: arguments, environment: environment)
  switch vm.run() {
  case .done:
    print("  ✔ Success")
    return

  case .systemExit(let object):
    let status: String = {
      switch object {
      case let o where o.isNone:
        return "None"
      case let int as PyInt:
        return String(describing: int.value)
      default:
        return Py.reprOrGeneric(object: object)
      }
    }()

    print("  ✔ Success (SystemExit: \(status))")
    return

  case .error(let error):
    // Try to print error to orginal 'stdout'
    let stdout: PyTextFile
    switch Py.sys.get__stdout__() {
    case let .value(f): stdout = f
    case let .error(e): trap("'__stdout__' is missing: \(e)")
    }

    // 'printRecursive' ignores any new errors
    print("  ✖ Error:")
    Py.printRecursive(error: error, file: stdout)
    exit(1) // halt for inspection
  }
}
