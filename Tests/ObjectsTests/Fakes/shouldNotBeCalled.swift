func shouldNotBeCalled(fn: StaticString = #function) -> Never {
  let msg = "Function '\(fn)' should not be called"
  fatalError(msg)
}
