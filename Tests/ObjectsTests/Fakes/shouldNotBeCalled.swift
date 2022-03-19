func shouldNotBeCalled(fn: StaticString = #function) -> Never {
  fatalError("Function '\(fn)' should not be called")
}
