struct ConsoleOutput: Output {

  func write(_ string: String) {
    print(string, terminator: "")
  }

  func close() {}
}
