import Core

/// Separate class for visibility.
public class BuiltinModules {

  // Do not make it a stored property!
  // It would hold reference to 'sys' which would cause cycle.
  public var modules: [PyModule] {
    return [
      Py.builtinsModule,
      Py.sysModule,
      Py._impModule
    ]
  }

  public var names: [String] {
    var result = [String]()
    for module in self.modules {
      switch module.name {
      case .value(let n):
        result.append(n)
      case .error:
        let msg = "Error when creating 'builtin_module_names': " +
                  "one of the builtins modules does not have name."
        trap(msg)
      }
    }

    return result
  }

  public private(set) lazy var namesObject: PyTuple = {
    let strings = self.names
    let interned = strings.map(Py.getInterned)
    return Py.newTuple(interned)
  }()
}
