/* MARKER
import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  /// globals()
  /// See [this](https://docs.python.org/3/library/functions.html#globals)
  public func globals() -> PyResult<PyDict> {
    guard let frame = self.delegate.frame else {
      return .runtimeError("globals(): no current frame")
    }

    let dict = frame.globals
    return .value(dict)
  }

  /// locals()
  /// See [this](https://docs.python.org/3/library/functions.html#locals)
  public func locals() -> PyResult<PyDict> {
    guard let frame = self.delegate.frame else {
      return .runtimeError("locals(): no current frame")
    }

    // Interesting edge case:
    // def sing(elsa):
    //     l = locals()
    //     print(l)
    //     elsa = 'into_the_unknown'
    //     print(l)
    //
    // sing('let_it_go')
    //
    // It will print:
    // {'elsa': 'let_it_go'}
    // {'elsa': 'let_it_go'}
    //
    // Shouldn't the 2nd line be 'into_the_unknown'?
    // Well yes…
    // (All this is CPython internal implementation leaking)

    if let e = frame.copyFastToLocals() {
      return .error(e)
    }

    let dict = frame.locals
    return .value(dict)
  }
}

*/