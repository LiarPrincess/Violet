/// Our own version of `fatalError`.
///
/// Call this when one of the core invariants is broken and it may not be safe
/// to continue.
///
/// It is highly recommended to put a breakpoint in here.
///
/// Originally this function was called `uhOhSoThatHappened`,
/// but that was way too long for our 80 character limit .
public func trap(_ msg: String,
                 file: StaticString = #file,
                 function: StaticString = #function,
                 line: Int = #line) -> Never {
  // 'function' is a module name if we are in global scope
  fatalError("\(file):\(line) - \(msg)")
}
