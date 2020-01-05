// swiftlint:disable unavailable_function

/// Our own version of `fatalError`.
///
/// Call this when one the core invariants is broken and it may not be safe
/// to continue.
///
/// Orginally this function was called `uhOhSoThatHappened`,
/// but that was way too long for our 80 column limit .
internal func trap(_ msg: String,
                   file: StaticString = #file,
                   function: StaticString = #function,
                   line: Int = #line) -> Never {
  fatalError("\(file):\(line) - \(msg)")
}
