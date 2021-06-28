import Foundation

/// In some algorithms we would require `UnicodeScalars` to conform to
/// `RandomAccessCollection`, but they don't.
/// In such case we will use this type as replacement.
///
/// If we ever solve this, then remove this `protocol` so that every function
/// with this requirement fails to compile.
protocol CollectionBecauseUnicodeScalarsAreNotRandomAccess: Collection {
  // No additonal requirements.
  //
  // As it turns out nominal type systems have their use…
  // (For example in structural type systems all types conforming to `Collection`
  // would automatically get `CollectionBecauseUnicodeScalarsAreNotRandomAccess`,
  // so we would have to add dummy requirement to prevent that.)
}

extension CollectionBecauseUnicodeScalarsAreNotRandomAccess {

  // `SubSequence` that contains the whole string
  internal var asSubSequence: SubSequence {
    return self[self.startIndex...]
  }

  internal func formIndex(after index: inout Index, while predicate: (Index) -> Bool) {
    while index != self.endIndex {
      switch predicate(index) {
      case true:
        self.formIndex(after: &index) // go to the next element
      case false:
        return
      }
    }
  }
}

extension String.UnicodeScalarView:
  CollectionBecauseUnicodeScalarsAreNotRandomAccess {}
extension String.UnicodeScalarView.SubSequence:
  CollectionBecauseUnicodeScalarsAreNotRandomAccess {}
extension Data:
  CollectionBecauseUnicodeScalarsAreNotRandomAccess {}
