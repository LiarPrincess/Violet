// We will store all of the elements in a single array (on the heap).
// It is not 'ideal'.
//
// Alternative would be to store 'first' and 'rest' as fields.
// Unfortunately we can't do this, because:
//
// public struct MyArray<Element> {
//   fileprivate let first: Element
// }
//
// public struct ASTNode {
//   fileprivate let children: MyArray<ASTNode>
// }
//
// This will not compile, because:
// - we need to know size of 'ASTNode' to compile 'MyArray<ASTNode>'
// - we need to know size of 'MyArray<ASTNode>' to compile 'ASTNode'
//
// I'm almost sure this is the reason. 'almost' because normally Swift would
// create a nice error message for this, but Swift 5.2 just crashes in parser.
//
// I also don't think that we actually hit this case,
// but our AST is is way too complicated for me to analyse.
//
// Btw, do not add 'ExpressibleByArrayLiteral' - it may break our invariant.

/// Array that has at least 1 element.
public struct NonEmptyArray<Element>: RandomAccessCollection,
                                      CustomStringConvertible {

  public private(set) var elements = [Element]()

  /// The first element of the collection.
  public var first: Element { return self.elements.first! }
  // swiftlint:disable:previous force_unwrapping

  /// The last element of the collection.
  public var last: Element { return self.elements.last! }
  // swiftlint:disable:previous force_unwrapping

  public init(first: Element) {
    self.elements.append(first)
  }

  public init<S: Sequence>(first: Element, rest: S) where S.Element == Element {
    self.elements.append(first)
    self.elements.append(contentsOf: rest)
  }

  /// Adds a new element at the end of the array.
  public mutating func append(_ newElement: Element) {
    self.elements.append(newElement)
  }

  /// Adds the elements of a sequence to the end of the array.
  public mutating func append<S: Sequence>(contentsOf newElements: S)
    where S.Element == Element {

    self.elements.append(contentsOf: newElements)
  }

  // MARK: - Collection

  public typealias Index = Array<Element>.Index

  public var startIndex: Index {
    return self.elements.startIndex
  }

  public var endIndex: Index {
    return self.elements.endIndex
  }

  public subscript(index: Index) -> Element {
    return self.elements[index]
  }

  // MARK: - CustomStringConvertible

  public var description: String {
    return String(describing: self.elements)
  }
}

// MARK: - Conditional conformance

extension NonEmptyArray: Equatable where Element: Equatable {}
extension NonEmptyArray: Hashable where Element: Hashable {}

// MARK: - To array

extension Array {
  public init(_ nonEmpty: NonEmptyArray<Element>) {
    self = nonEmpty.elements
  }
}
