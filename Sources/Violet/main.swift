import Foundation
import VioletCore
import VioletObjects
import VioletVM

let arguments = try Arguments(from: CommandLine.arguments)
let environment = Environment(from: ProcessInfo.processInfo.environment)
let vm = VM(arguments: arguments, environment: environment)
let py = vm.py

switch vm.run() {
case .done:
  // It worked! Yay!
  // https://youtu.be/kHx5hCVN26E?t=117
  exit(EXIT_SUCCESS)

case .systemExit(let object):
  // It worked! It raised! This one got it all!
  // What scientific witchery is this?
  // https://www.youtube.com/watch?v=d-nxW9qBtxQ
  // CPython: handle_system_exit(void)

  if py.cast.isNone(object) {
    exit(EXIT_SUCCESS)
  }

  if let pyInt = py.cast.asInt(object) {
    guard let status = Int32(exactly: pyInt.value) else {
      exit(EXIT_FAILURE) // Python does not define what to do
    }

    exit(status)
  }

  // Just print this object in 'stderr' and call it a day…
  switch py.sys.getStderrOrNone() {
  case .none:
    break // User requested no printing
  case .value(let file):
    let fileObject = file.asObject
    _ = py.print(file: fileObject, arg: object) // Ignore error
  case .error:
    break // Ignore error, it's not like we can do anything
  }

  // Error is an error, even if we did print message
  exit(EXIT_FAILURE)

case .error(let error):
  // CPython: PyErr_PrintEx(int set_sys_last_vars)
  let excepthookResult = py.sys.callExcepthook(error: error)

  if case .value = excepthookResult {
    // Everything is 'ok' (at least in 'excepthook', the whole 'VM.run' just
    // raised, but yeah… 'excepthook' is fine).
    // Anyway… let's ignore whatever nonsense this function returned…
    exit(EXIT_FAILURE)
  }

  // We will be printing to 'stderr' (probably)
  let stderr: PyTextFile
  switch py.sys.getStderrOrNone() {
  case .none: exit(EXIT_FAILURE) // User requested no printing
  case .value(let f): stderr = f
  case .error: exit(EXIT_FAILURE) // Ignore error, it's not like we can do anything
  }

  func write(string: String) {
    // Ignore error (again, yep… there is a pattern here)
    _ = stderr.write(py, string: string)
  }

  // 'switch' is better than series of 'ifs', because it checks for exhaustiveness
  switch excepthookResult {
  case .value:
    // We checked that already
    // (btw. you broke Swift… https://www.youtube.com/watch?v=oyFQVZ2h0V8)
    unreachable()

  case .missing:
    write(string: "sys.excepthook is missing\n")
    py.printRecursiveIgnoringErrors(file: stderr, error: error)

  case .notCallable(let hookError),
       .error(let hookError):
    // There was an error when displaying an error… well… bad day?

    write(string: "Error in sys.excepthook:\n")
    py.printRecursiveIgnoringErrors(file: stderr, error: hookError)

    write(string: "\nOriginal exception was:\n")
    py.printRecursiveIgnoringErrors(file: stderr, error: error)
  }

  // Regardless of whether we did print something or not, it is still an error
  exit(EXIT_FAILURE)
}
