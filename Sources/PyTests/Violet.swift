internal func runVioletTests() {
  let dir = testDir.appendingPathComponent("Violet")
  runTest(file: dir.appendingPathComponent("closures.py"))
  runTest(file: dir.appendingPathComponent("empty_init.py"))
  runTest(file: dir.appendingPathComponent("getattr.py"))
  runTest(file: dir.appendingPathComponent("traceback.py"))
  runTest(file: dir.appendingPathComponent("type_hints.py"))
  runTest(file: dir.appendingPathComponent("unbound_methods.py"))
}
