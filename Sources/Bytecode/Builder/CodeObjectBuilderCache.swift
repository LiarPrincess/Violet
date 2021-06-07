import VioletCore

/// Indices of already added objects (so that we don't store duplicates).
internal struct CodeObjectBuilderCache {

  /// Index inside `CodeObjectBuilder.constants` that contains `True`.
  internal var `true`: Int?
  /// Index inside `CodeObjectBuilder.constants` that contains `False`.
  internal var `false`: Int?
  /// Index inside `CodeObjectBuilder.constants` that contains `None`.
  internal var none: Int?
  /// Index inside `CodeObjectBuilder.constants` that contains `ellipsis` (`...`).
  internal var ellipsis: Int?
  /// Index inside `CodeObjectBuilder.constants` that contains `0`.
  internal var zero: Int?
  /// Index inside `CodeObjectBuilder.constants` that contains `1`.
  internal var one: Int?

  /// Index inside `CodeObjectBuilder.constants` that contains given `string`.
  internal var constantStrings = [UseScalarsToHashString: Int]()

  /// Index inside `CodeObjectBuilder.names` that contains given `name`.
  internal var names = [UseScalarsToHashString: Int]()

  /// Index inside `CodeObjectBuilder.variableNames` that contains given `name`.
  internal let variableNames: [MangledName: Int]
  /// Index inside `CodeObjectBuilder.freeVariableNames` that contains given `name`.
  internal let freeVariableNames: [MangledName: Int]
  /// Index inside `CodeObjectBuilder.cellVariableNames` that contains given `name`.
  internal let cellVariableNames: [MangledName: Int]

  internal init(variableNames: [MangledName],
                freeVariableNames: [MangledName],
                cellVariableNames: [MangledName]) {
//    for (index, constant) in constants.enumerated() {
//      switch constant {
//      case .true:
//        self.true = index
//      case .false:
//        self.false = index
//      case .none:
//        self.none = index
//      case .ellipsis:
//        self.ellipsis = index
//
//      case let .string(s):
//        let key = UseScalarsToHashString(s)
//        self.constantStrings[key] = index
//
//      case let .integer(i) where i == 0:
//        self.zero = index
//      case let .integer(i) where i == 1:
//        self.one = index
//
//      case .integer, .float, .complex, .bytes, .code, .tuple:
//        break
//      }
//    }

//    self.names = toIndexDict(names: names)
    self.variableNames = toIndexDict(names: variableNames)
    self.freeVariableNames = toIndexDict(names: freeVariableNames)
    self.cellVariableNames = toIndexDict(names: cellVariableNames)
  }
}

/// Name -> index
private func toIndexDict(names: [String]) -> [UseScalarsToHashString: Int] {
  var result = [UseScalarsToHashString: Int]()
  result.reserveCapacity(names.count)

  for (index, name) in names.enumerated() {
    let key = UseScalarsToHashString(name)
    assert(result[key] == nil, "Duplicate name: '\(name)'")
    result[key] = index
  }

  return result
}

/// Mangled name -> index
private func toIndexDict(names: [MangledName]) -> [MangledName: Int] {
  var result = [MangledName: Int]()
  result.reserveCapacity(names.count)

  for (index, name) in names.enumerated() {
    assert(result[name] == nil, "Duplicate name: '\(name)'")
    result[name] = index
  }

  return result
}
