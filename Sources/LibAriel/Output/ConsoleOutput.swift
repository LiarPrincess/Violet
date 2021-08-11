public struct ConsoleOutput: Output {

  public func write(_ string: String) {
    print(string, terminator: "")
  }

  public func close() {}
}
