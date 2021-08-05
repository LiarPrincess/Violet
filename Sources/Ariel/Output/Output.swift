protocol Output {
  func write(_ string: String)
  func flush()
}

struct ConsoleOutput: Output {

  func write(_ string: String) {
    print(string)
  }

  func flush() {}
}
