import Foundation
import VioletCore
import VioletObjects
import VioletVM

// MARK: - Run

private func run(file: URL) {
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

// MARK: - Test dir

private var testDir: URL = {
  let currentFile = URL(fileURLWithPath: #file)
  let mainDir = currentFile
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
  return mainDir.appendingPathComponent("PyTests")
}()

// MARK: - Old types

private func runOldTypes() {
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
  run(file: typesDir.appendingPathComponent("test_bytes.py"))
}

// MARK: - Old builtins

private func runOldBuiltins() {
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
//  run(file: builtinsDir.appendingPathComponent("builtin_dir.py"))
//  run(file: builtinsDir.appendingPathComponent("builtin_exec.py"))
//  run(file: builtinsDir.appendingPathComponent("builtin_file.py"))
//  run(file: builtinsDir.appendingPathComponent("builtin_format.py"))
//  run(file: builtinsDir.appendingPathComponent("builtin_locals.py"))
//  run(file: builtinsDir.appendingPathComponent("builtin_open.py"))
//  run(file: builtinsDir.appendingPathComponent("builtins_module.py"))
}

// MARK: - Not finished

private func runNotFinished() {
  run(file: testDir.appendingPathComponent("fizzbuzz.py"))
  run(file: testDir.appendingPathComponent("test_import.py"))
  run(file: testDir.appendingPathComponent("test_class.py"))
  run(file: testDir.appendingPathComponent("test_with.py"))
  run(file: testDir.appendingPathComponent("scarry.py"))
}

// MARK: - Main

runOldTypes()
runOldBuiltins()
//runNotFinished()
