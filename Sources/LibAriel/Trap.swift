/// Our own version of `fatalError`.
public func trap(_ msg: String,
                 file: StaticString = #file,
                 function: StaticString = #function,
                 line: Int = #line) -> Never {
  // 'function' is a module name if we are in global scope
  fatalError("\(file):\(line) - \(msg)")
}
