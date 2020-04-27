import VioletCore
import VioletBytecode

public struct SymbolInfo: Equatable, CustomStringConvertible {

  /// Symbol information.
  public let flags: SymbolFlags

  /// Location of the first occurence of given symbol.
  public let location: SourceLocation

  public var description: String {
    return "SymbolInfo(flags: \(self.flags), location: \(self.location))"
  }
}

/// Dicitonary that holds `SymbolInfo` instances.
///
/// It will remember the order in which symbols were inserted.
public struct SymbolByNameDictionary: Sequence {

  // This is a very 'dump' implementation of ordered dictionary,
  // but it is enought.
  private var dict = [MangledName: SymbolInfo]()
  private var list = [MangledName]()

  public var count: Int {
    assert(self.dict.count == self.list.count)
    return self.list.count
  }

  public var isEmpty: Bool {
    assert(self.dict.count == self.list.count)
    return self.list.isEmpty
  }

  public internal(set) subscript(name: MangledName) -> SymbolInfo? {
    get { return self.dict[name] }
    set {
      if let newValue = newValue {
        let oldValue = self.dict.updateValue(newValue, forKey: name)

        let isInsert = oldValue == nil
        if isInsert {
          self.list.append(name)
        }

        assert(self.dict.count == self.list.count)
      } else {
        // We should not need this operation, but we want fancy subscript syntax.
        trap("Symbol removal was not implemented.")
      }
    }
  }

  public typealias Element = (key: MangledName, info: SymbolInfo)
  public typealias Iterator = AnyIterator<Self.Element>

  public func makeIterator() -> Iterator {
    var index = 0
    return AnyIterator { () -> Self.Element? in
      guard index < self.list.count else {
        return nil
      }

      defer { index += 1 }

      let name = self.list[index]
      guard let info = self.dict[name] else {
        trap("[SymbolByNameDictionary] Missing '\(name)' in dictionary.")
      }

      return (name, info)
    }
  }
}
