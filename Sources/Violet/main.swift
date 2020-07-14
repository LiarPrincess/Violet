import Foundation
import VioletCore
import VioletObjects
import VioletVM

checkInvariants()

let arguments = Arguments()
let environment = Environment()
let vm = VM(arguments: arguments, environment: environment)

switch vm.run() {
case .done:
  exit(0)

case .systemExit(let object):
  // CPython: handle_system_exit(void)
  if object.isNone {
    exit(0)
  }

  if let pyInt = object as? PyInt {
    guard let status = Int32(exactly: pyInt.value) else {
      exit(1) // Python does not define what to do
    }

    exit(status)
  }

  // Just print this object in 'stderr' and call it a day…
  switch Py.sys.getStderrOrNone() {
  case .none:
    break // User requested no printing
  case .file(let f):
    _ = Py.print(args: [object], file: f) // Ignore error
  case .error:
    break // Ignore error, it's not like we can do anything
  }

  // Error is an error, even if we did print message
  exit(1)

case .error(let error):
  // CPython: PyErr_PrintEx(int set_sys_last_vars)
  let excepthookResult = Py.sys.callExcepthook(error: error)

  if case .value = excepthookResult {
    // Everything is 'ok' (at least in 'excepthook', the whole 'VM.run' just
    // raised, but yeah… 'excepthook' is fine).
    // Anyway… let's ignore whatever nonsense this function returned…
    exit(1)
  }

  // We will be printing to 'stderr' (probably)
  let stderr: PyTextFile
  switch Py.sys.getStderrOrNone() {
  case .none: exit(1) // User requested no printing
  case .file(let f): stderr = f
  case .error: exit(1) // Ignore error, it's not like we can do anything
  }

  func write(string: String) {
    _ = stderr.write(string: string) // Ignore error (again)
  }

  // 'switch' is better than series of 'ifs', because it checks for exhaustiveness
  switch excepthookResult {
  case .value:
    assert(
      false,
      "We checked that already " +
      "(btw. you broke Swift… https://www.youtube.com/watch?v=oyFQVZ2h0V8)"
    )

  case .missing:
    write(string: "sys.excepthook is missing\n")
    // 'printRecursive' ignores any new errors (just like we are doing right now)
    Py.printRecursive(error: error, file: stderr)

  case .notCallable(let hookError),
       .error(let hookError):
    // There was an error when displaying an error… well… bad day?

    write(string: "Error in sys.excepthook:\n")
    Py.printRecursive(error: hookError, file: stderr)

    write(string: "\nOriginal exception was:\n")
    Py.printRecursive(error: error, file: stderr)
  }

  // Regardless of whether we did print something or not, it is still an error
  exit(1)
}
