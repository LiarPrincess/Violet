/// Maximum index supported by `SmallArray` for storing values
/// (254 which will give us 255 elements).
private let maxUsableIndex = UInt8.max - 1

/// Last possible index (255), reserved for `SmallArray.endIndex`
/// when array is full.
private let reservedLastIndex = UInt8.max

/// Array with max 255 elements (so that we can index it with UInt8).
/// Basically wrapper around `Array<E>`,
/// but with some additional fluff for safety (all checks are runtime checks!).
///
/// Do not add 'ExpressibleByArrayLiteral' - it may break our invariant.
public struct SmallArray<Element> {

  /// Maximum count of elements that can be stored in `SmallArray`.
  public static var maxCount: UInt8 { return reservedLastIndex }

  private var elements = [Element]()

  public init() { }

  /// It is guaranteed that this element will be inserted at `self.endIndex`.
  public mutating func append(_ newElement: Element) {
    precondition(
      self.elements.count != maxUsableIndex,
      "[BUG] SmallArray cannot contain more than 255 elements."
    )
    self.elements.append(newElement)
  }

  // MARK: - Collection

  public typealias Index = SmallArrayIndex
  public typealias Element = Element
  //public typealias Iterator = Array<Element>.Iterator

  public var startIndex: Index {
    return SmallArrayIndex(value: UInt8(self.elements.startIndex))
  }

  public var endIndex: Index {
    assert(self.elements.count <= reservedLastIndex)
    return SmallArrayIndex(value: UInt8(self.elements.endIndex))
  }

  public subscript(index: Index) -> Element {
    get { return self.elements[Int(index.value)] }
    _modify { yield &self.elements[Int(index.value)] }
  }

  public func index(after i: Index) -> Index {
    precondition(
      i.value != reservedLastIndex,
      "[BUG] Requesting index after maximum possilbe SmallArray index."
    )
    return SmallArrayIndex(value: i.value + 1)
  }

  public func index(before i: Index) -> Index {
    precondition(
      i.value != 0,
      "[BUG] Requesting index before first element in SmallArray."
    )
    return SmallArrayIndex(value: i.value - 1)
  }
}

/// Index for SmallArray (0-254 and 255 as reserved value).
public struct SmallArrayIndex: Comparable {

  fileprivate let value: UInt8

  fileprivate init(value: UInt8) {
    self.value = value
  }

  public static func == (lhs: SmallArrayIndex, rhs: SmallArrayIndex) -> Bool {
    return lhs.value == rhs.value
  }

  public static func < (lhs: SmallArrayIndex, rhs: SmallArrayIndex) -> Bool {
    return lhs.value < rhs.value
  }
}
