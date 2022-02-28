import Foundation
import BigInt
import VioletCore
import VioletBytecode

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
    Self.checkIfAlignmentIsLessEqualWord(RawPtr.self)
    Self.checkIfAlignmentIsLessEqualWord(Ptr<PyObject>.self)

    Self.checkIfAlignmentIsLessEqualWord(Int.self)
    Self.checkIfAlignmentIsLessEqualWord(Optional<Int>.self)
    Self.checkIfAlignmentIsLessEqualWord(UInt32.self)
    Self.checkIfAlignmentIsLessEqualWord(BigInt.self)
    Self.checkIfAlignmentIsLessEqualWord(PyHash.self)
    Self.checkIfAlignmentIsLessEqualWord(Double.self)

    Self.checkIfAlignmentIsLessEqualWord([PyObject].self)
    Self.checkIfAlignmentIsLessEqualWord(String.self)
    Self.checkIfAlignmentIsLessEqualWord(Optional<String>.self)
    Self.checkIfAlignmentIsLessEqualWord(Data.self)

    Self.checkIfAlignmentIsLessEqualWord(PyType.DeinitializeFn.self)

    Self.checkIfAlignmentIsLessEqualWord(PyType.MemoryLayout.self)
    Self.checkIfAlignmentIsLessEqualWord(PyType.StaticallyKnownNotOverriddenMethods.self)

    Self.checkIfAlignmentIsLessEqualWord(OrderedDictionary<PyDict.Key, Int>.self)
    Self.checkIfAlignmentIsLessEqualWord(OrderedSet<AbstractSet_Element>.self)
    Self.checkIfAlignmentIsLessEqualWord(PyAnySet.self)

    Self.checkIfAlignmentIsLessEqualWord(SourceLine.self)
    Self.checkIfAlignmentIsLessEqualWord(PyFrame.ObjectStack.self)
    Self.checkIfAlignmentIsLessEqualWord(PyFrame.BlockStack.self)
    Self.checkIfAlignmentIsLessEqualWord(FunctionWrapper.self)

     Self.checkIfAlignmentIsLessEqualWord(FileDescriptorType.self)
     Self.checkIfAlignmentIsLessEqualWord(FileMode.self)
     Self.checkIfAlignmentIsLessEqualWord(PyString.Encoding.self)
     Self.checkIfAlignmentIsLessEqualWord(PyString.ErrorHandling.self)
  }

  // I know, this is a very weird check...
  private static func checkIfAlignmentIsLessEqualWord<T>(_ type: T.Type) {
    let alignment = MemoryLayout<T>.alignment
    guard alignment <= AlignmentOf.word else {
      let typeName = String(describing: type)
      trap("[Invariant] \(typeName) has alignment \(alignment) instead of expected word")
    }
  }
}
