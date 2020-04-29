import Foundation
import VioletCore
import VioletObjects
import VioletVM

// swiftlint:disable function_body_length

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
  let dir = testDir.appendingPathComponent("Types")
  run(file: dir.appendingPathComponent("test_assignment.py"))
  run(file: dir.appendingPathComponent("test_basic_types.py"))
  run(file: dir.appendingPathComponent("test_bool.py"))
  run(file: dir.appendingPathComponent("test_bytes.py"))
  run(file: dir.appendingPathComponent("test_class.py"))
  run(file: dir.appendingPathComponent("test_commas.py"))
  run(file: dir.appendingPathComponent("test_comparisons.py"))
  run(file: dir.appendingPathComponent("test_dict.py"))
  run(file: dir.appendingPathComponent("test_ellipsis.py"))
  run(file: dir.appendingPathComponent("test_floats.py"))
  run(file: dir.appendingPathComponent("test_for.py"))
  run(file: dir.appendingPathComponent("test_hash.py"))
  run(file: dir.appendingPathComponent("test_if_expressions.py"))
  run(file: dir.appendingPathComponent("test_if.py"))
  run(file: dir.appendingPathComponent("test_int_float_comparisons.py"))
  run(file: dir.appendingPathComponent("test_int.py"))
  run(file: dir.appendingPathComponent("test_iterations.py"))
  run(file: dir.appendingPathComponent("test_list.py"))
  run(file: dir.appendingPathComponent("test_literals.py"))
  run(file: dir.appendingPathComponent("test_loop.py"))
  run(file: dir.appendingPathComponent("test_math_basics.py"))
  run(file: dir.appendingPathComponent("test_none.py"))
  run(file: dir.appendingPathComponent("test_numbers.py"))
  run(file: dir.appendingPathComponent("test_set.py"))
  run(file: dir.appendingPathComponent("test_short_circuit_evaluations.py"))
  run(file: dir.appendingPathComponent("test_slice.py"))
  run(file: dir.appendingPathComponent("test_statements.py"))
  run(file: dir.appendingPathComponent("test_strings.py"))
  run(file: dir.appendingPathComponent("test_try_exceptions.py"))
  run(file: dir.appendingPathComponent("test_tuple.py"))
  run(file: dir.appendingPathComponent("test_with.py"))
  run(file: dir.appendingPathComponent("type_hints.py"))
}

// MARK: - Old builtins

private func runOldBuiltins() {
  let dir = testDir.appendingPathComponent("Builtins")
  run(file: dir.appendingPathComponent("builtin_abs.py"))
  run(file: dir.appendingPathComponent("builtin_all.py"))
  run(file: dir.appendingPathComponent("builtin_any.py"))
  run(file: dir.appendingPathComponent("builtin_ascii.py"))
  run(file: dir.appendingPathComponent("builtin_bin.py"))
  run(file: dir.appendingPathComponent("builtin_callable.py"))
  run(file: dir.appendingPathComponent("builtin_chr.py"))
  run(file: dir.appendingPathComponent("builtin_complex.py"))
  run(file: dir.appendingPathComponent("builtin_dict.py"))
  run(file: dir.appendingPathComponent("builtin_dir.py"))
  run(file: dir.appendingPathComponent("builtin_divmod.py"))
  run(file: dir.appendingPathComponent("builtin_enumerate.py"))
  run(file: dir.appendingPathComponent("builtin_filter.py"))
  run(file: dir.appendingPathComponent("builtin_hex.py"))
  run(file: dir.appendingPathComponent("builtin_len.py"))
  run(file: dir.appendingPathComponent("builtin_map.py"))
  run(file: dir.appendingPathComponent("builtin_max.py"))
  run(file: dir.appendingPathComponent("builtin_min.py"))
  run(file: dir.appendingPathComponent("builtin_ord.py"))
  run(file: dir.appendingPathComponent("builtin_pow.py"))
  run(file: dir.appendingPathComponent("builtin_range.py"))
  run(file: dir.appendingPathComponent("builtin_reversed.py"))
  run(file: dir.appendingPathComponent("builtin_round.py"))
  run(file: dir.appendingPathComponent("builtin_slice.py"))
  run(file: dir.appendingPathComponent("builtin_zip.py"))
  run(file: dir.appendingPathComponent("builtins.py"))
  run(file: dir.appendingPathComponent("printing.py"))
}

// MARK: - Violet

private func runVioletTests() {
  let dir = testDir.appendingPathComponent("Violet")
  run(file: dir.appendingPathComponent("closures.py"))
  run(file: dir.appendingPathComponent("empty_init.py"))
  run(file: dir.appendingPathComponent("getattr.py"))
  run(file: dir.appendingPathComponent("traceback.py"))
  run(file: dir.appendingPathComponent("type_hints.py"))
  run(file: dir.appendingPathComponent("unbound_methods.py"))
}

// MARK: - Not finished

private func runNotFinished() {
//  run(file: testDir.appendingPathComponent("fizzbuzz.py"))
//  run(file: testDir.appendingPathComponent("test_import.py"))

//  let waiting = testDir.appendingPathComponent("Waiting room")
//  run(file: waiting.appendingPathComponent("builtin_exec.py"))
//  run(file: waiting.appendingPathComponent("builtin_file.py"))
//  run(file: waiting.appendingPathComponent("builtin_format.py"))
//  run(file: waiting.appendingPathComponent("builtin_locals.py"))
//  run(file: waiting.appendingPathComponent("builtin_open.py"))
//  run(file: waiting.appendingPathComponent("builtins_module.py"))
}

// MARK: - Main

//runOldTypes()
//runOldBuiltins()
runVioletTests()
//runNotFinished()
