import Foundation
import BigInt
import VioletCore

/// Alignment of a various things in a memory.
public enum AlignmentOf {

  // We only have 1 possible alignment for all of the Python objects.
  // It is important it is a compile-time constant!

  public static let word = SizeOf.object

  public static func roundUp(_ value: Int, to alignment: Int) -> Int {
    let rem = value % alignment
    return rem == 0 ? value : value - rem + alignment
  }

  internal static func checkInvariants() {
    Self.checkAlignment(of: RawPtr.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: Ptr<PyObject>.self, isLessEqual: AlignmentOf.word)

    Self.checkAlignment(of: Int32.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: Int64.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: UInt32.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: UInt64.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: BigInt.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: Double.self, isLessEqual: AlignmentOf.word)

    Self.checkAlignment(of: [PyObject].self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: String.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: Data.self, isLessEqual: AlignmentOf.word)

    Self.checkAlignment(of: PyType.DeinitializeFn.self, isLessEqual: AlignmentOf.word)

    Self.checkAlignment(of: PyType.MemoryLayout.self, isLessEqual: AlignmentOf.word)
    Self.checkAlignment(of: PyType.StaticallyKnownNotOverriddenMethods.self,
                        isLessEqual: AlignmentOf.word)

    // Self.checkAlignment(of: BlockStack.self, isLessEqual: Self.BlockStack)
    // Self.checkAlignment(of: CodeObject.self, isLessEqual: Self.CodeObject)
    // Self.checkAlignment(of: FileDescriptorType.self, isLessEqual: Self.FileDescriptorType)
    // Self.checkAlignment(of: FileMode.self, isLessEqual: Self.FileMode)
    // Self.checkAlignment(of: FunctionWrapper.self, isLessEqual: Self.FunctionWrapper)

    // Self.checkAlignment(of: ObjectStack.self, isLessEqual: Self.ObjectStack)
    // Self.checkAlignment(of: OrderedDictionary.self, isLessEqual: Self.OrderedDictionary)
    // Self.checkAlignment(of: OrderedSet.self, isLessEqual: Self.OrderedSet)
    // Self.checkAlignment(of: PyAnySet.self, isLessEqual: Self.PyAnySet)
    // Self.checkAlignment(of: PyString.Encoding.self, isLessEqual: Self.PyString.Encoding)
    // Self.checkAlignment(of: PyString.ErrorHandling.self,
    //                     isLessEqual: Self.PyString.ErrorHandling)
    // Self.checkAlignment(of: SourceLine.self, isLessEqual: Self.SourceLine)
  }

  private static func checkAlignment<T>(of type: T.Type, isLessEqual: Int) {
    let alignment = MemoryLayout<T>.alignment
    guard alignment <= isLessEqual else {
      let typeName = String(describing: type)
      trap("[Invariant] \(typeName) has alignment \(alignment) instead of expected \(isLessEqual)")
    }
  }
}
