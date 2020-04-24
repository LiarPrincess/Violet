import VM
import Core
import Objects
import Foundation

// swiftlint:disable:next function_body_length
private func run(file: URL) {
  checkInvariants()

  print(file.lastPathComponent)
  var arguments = Arguments()
  let environment = Environment()
  arguments.script = file.path

  let vm = VM(arguments: arguments, environment: environment)
  switch vm.run() {
  case .done:
    print(".. done")
    return // nothing unusal happened

  case .systemExit(let object):
    // CPython: handle_system_exit(void)
    if object.isNone {
      print(".. done (status: 0)")
      return
    }

    if let int = object as? PyInt {
      print(".. done (status: \(int))")
      return
    }

    // Just print this object in 'stderr' and call it a day...
    switch Py.sys.getStderrOrNone() {
    case .none: return // User requested no printing
    case .file(let f): _ = Py.print(args: [object], file: f) // Ignore error
    case .error: return // Ignore error, it's not like we can do anything
    }

  case .error(let error):
    func haltForInspection() -> Never {
      exit(1)
    }

    // CPython: PyErr_PrintEx(int set_sys_last_vars)
    let excepthookResult = Py.sys.callExcepthook(error: error)

    if case Sys.CallExcepthookResult.value = excepthookResult {
      // Everything is 'ok' (at least in 'excepthook', the whole 'VM.run' just
      // raised, but yeah 'excepthook' is fine).
      // Anyway... let's ignore whatever nonsense this function returned...
      haltForInspection()
    }

    // We will be printing to 'stderr' (probably).
    let stderr: PyTextFile
    switch Py.sys.getStderrOrNone() {
    case .none: haltForInspection() // User requested no printing
    case .file(let f): stderr = f
    case .error: haltForInspection() // Ignore error, it's not like we can do anything
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
        "(btw. you broke Swift... https://www.youtube.com/watch?v=oyFQVZ2h0V8)"
      )

    case .missing:
      write(string: "sys.excepthook is missing\n")
      // 'printRecursive' ignores any new errors (just like we are doing right now)
      Py.printRecursive(error: error, file: stderr)
      haltForInspection()

    case .notCallable(let hookError),
         .error(let hookError):
      // There was an error when displaying an error... well... bad day?

      write(string: "Error in sys.excepthook:\n")
      Py.printRecursive(error: hookError, file: stderr)

      write(string: "\nOriginal exception was:\n")
      Py.printRecursive(error: error, file: stderr)
      haltForInspection()
    }
  }
}

// ------------------------------------------------
//exit(0)
// ------------------------------------------------

let currentFile = URL(fileURLWithPath: #file)
let mainDir = currentFile
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent()
let testDir = mainDir.appendingPathComponent("PyTests")

//run(file: testDir.appendingPathComponent("fizzbuzz.py"))
//run(file: testDir.appendingPathComponent("test_import.py"))
//run(file: testDir.appendingPathComponent("test_class.py"))
//run(file: testDir.appendingPathComponent("test_with.py"))

if false {

  // MARK: - Types

  let typesDir = testDir.appendingPathComponent("Types")
  run(file: typesDir.appendingPathComponent("test_int.py"))
  run(file: typesDir.appendingPathComponent("test_bool.py"))
  run(file: typesDir.appendingPathComponent("test_ellipsis.py"))
  run(file: typesDir.appendingPathComponent("test_floats.py"))
  run(file: typesDir.appendingPathComponent("test_none.py"))
  run(file: typesDir.appendingPathComponent("test_if.py"))
  run(file: typesDir.appendingPathComponent("test_literals.py"))
  run(file: typesDir.appendingPathComponent("test_tuple.py"))
  run(file: typesDir.appendingPathComponent("test_numbers.py"))
  run(file: typesDir.appendingPathComponent("test_if_expressions.py"))
  run(file: typesDir.appendingPathComponent("test_set.py"))
  run(file: typesDir.appendingPathComponent("test_int_float_comparisons.py"))
  run(file: typesDir.appendingPathComponent("test_commas.py"))
  run(file: typesDir.appendingPathComponent("test_hash.py"))
  run(file: typesDir.appendingPathComponent("test_comparisons.py"))
  run(file: typesDir.appendingPathComponent("test_math_basics.py"))
  run(file: typesDir.appendingPathComponent("test_short_circuit_evaluations.py"))
  run(file: typesDir.appendingPathComponent("test_for.py"))
  run(file: typesDir.appendingPathComponent("test_loop.py"))
  run(file: typesDir.appendingPathComponent("test_assignment.py"))
  run(file: typesDir.appendingPathComponent("test_statements.py"))
  run(file: typesDir.appendingPathComponent("test_strings.py"))
  run(file: typesDir.appendingPathComponent("test_iterations.py"))
  run(file: typesDir.appendingPathComponent("test_basic_types.py"))
  run(file: typesDir.appendingPathComponent("test_slice.py"))
  run(file: typesDir.appendingPathComponent("test_list.py"))
  run(file: typesDir.appendingPathComponent("test_dict.py"))
  run(file: typesDir.appendingPathComponent("test_try_exceptions.py"))
  run(file: typesDir.appendingPathComponent("scarry.py"))
  run(file: typesDir.appendingPathComponent("test_bytes.py"))

  // MARK: - Builtins

  let builtinsDir = testDir.appendingPathComponent("Builtins")
  run(file: builtinsDir.appendingPathComponent("builtin_abs.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_all.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_any.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_ascii.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_bin.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_callable.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_chr.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_complex.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_dict.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_divmod.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_enumerate.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_filter.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_hex.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_len.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_map.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_max.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_min.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_ord.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_pow.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_range.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_reversed.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_round.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_slice.py"))
  run(file: builtinsDir.appendingPathComponent("builtin_zip.py"))
  run(file: builtinsDir.appendingPathComponent("builtins.py"))
  run(file: builtinsDir.appendingPathComponent("printing.py"))

  // Not implemented:
  //run(file: builtinsDir.appendingPathComponent("builtin_dir.py"))
  //run(file: builtinsDir.appendingPathComponent("builtin_exec.py"))
  //run(file: builtinsDir.appendingPathComponent("builtin_file.py"))
  //run(file: builtinsDir.appendingPathComponent("builtin_format.py"))
  //run(file: builtinsDir.appendingPathComponent("builtin_locals.py"))
  //run(file: builtinsDir.appendingPathComponent("builtin_open.py"))
  //run(file: builtinsDir.appendingPathComponent("builtins_module.py"))
}
