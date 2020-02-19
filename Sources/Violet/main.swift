import Foundation
import Core
import Lexer
import Parser
import Bytecode
import Compiler
import Objects
import VM

private func run(file: URL) {
  do {
    checkInvariants()

    print(file.lastPathComponent, terminator: "")
    var arguments = Arguments()
    let environment = Environment()
    arguments.script = file.path

    let vm = VM(arguments: arguments, environment: environment)
    try vm.run()
    print(" ✔")
  } catch {
    print(" ✖")
    print(error)
    exit(1)
  }
}

let currentFile = URL(fileURLWithPath: #file)
let mainDir = currentFile
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent()
let testDir = mainDir.appendingPathComponent("PyTests")

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
//run(file: builtinsDir.appendingPathComponent("testutils.py"))
