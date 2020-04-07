import Core

/// Indices of already added objects (so that we don't store duplicates).
internal struct CodeObjectBuilderCache {

  internal var `true`: Int?
  internal var `false`: Int?
  internal var none: Int?
  internal var ellipsis: Int?
  internal var zero: Int?
  internal var one: Int?
  /// CodeObject.constants -> string
  internal var constantStrings = [UseScalarsToHashString:Int]()

  /// CodeObject.names
  internal var names = [UseScalarsToHashString:Int]()

  /// CodeObject.variableNames
  internal let variableNames: [MangledName:Int]
  /// CodeObject.freeVariableNames
  internal let freeVariableNames: [MangledName:Int]
  /// CodeObject.cellVariableNames
  internal let cellVariableNames: [MangledName:Int]

  internal init(code: CodeObject) {
    for (index, constant) in code.constants.enumerated() {
      switch constant {
      case .true:
        self.true = index
      case .false:
        self.false = index
      case .none:
        self.none = index
      case .ellipsis:
        self.ellipsis = index

      case let .string(s):
        let key = UseScalarsToHashString(s)
        self.constantStrings[key] = index

      case let .integer(i) where i == 0:
        self.zero = index
      case let .integer(i) where i == 1:
        self.one = index

      case .integer, .float, .complex, .bytes, .code, .tuple:
        break
      }
    }

    self.names = toIndexDict(names: code.names)
    self.variableNames = toIndexDict(names: code.variableNames)
    self.freeVariableNames = toIndexDict(names: code.freeVariableNames)
    self.cellVariableNames = toIndexDict(names: code.cellVariableNames)
  }
}

/// Name -> index
private func toIndexDict(names: [String]) -> [UseScalarsToHashString:Int] {
  var result = [UseScalarsToHashString:Int]()
  result.reserveCapacity(names.count)

  for (index, name) in names.enumerated() {
    let key = UseScalarsToHashString(name)
    assert(result[key] == nil, "Duplicate name: '\(name)'")
    result[key] = index
  }

  return result
}

/// Mangled name -> index
private func toIndexDict(names: [MangledName]) -> [MangledName:Int] {
  var result = [MangledName:Int]()
  result.reserveCapacity(names.count)

  for (index, name) in names.enumerated() {
    assert(result[name] == nil, "Duplicate name: '\(name)'")
    result[name] = index
  }

  return result
}
