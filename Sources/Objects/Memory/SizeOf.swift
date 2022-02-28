import Foundation
import BigInt
import VioletCore
import VioletBytecode

/// Sizes of a various things in a memory.
public enum SizeOf {

  // Alternatives:
  // - use 'MemoryLayout<T>.stride' everywhere - this would make the 'mental math'
  //   more difficult.
  // - write general purpose layout algorithm - too difficult for what we gain.
  //   The algorithm itself is quite simple, but then adding it to every type is not.
  //
  // Btw. It is important that those are a compile-time constants!

  public static let object = 8
  public static let optionalObject = 8
  public static let objectHeader = PyObjectHeader.Layout.size

  public static let int = 8
  public static let optionalInt = -1
  public static let uint32 = 4
  public static let bigInt = 8
  public static let hash = 8
  public static let double = 8

  public static let array = -1
  public static let string = 16
  public static let optionalString = 16
  public static let data = -1

  public static let function = 16

  public static let typeMemoryLayout = -1
  public static let typeStaticallyKnownNotOverriddenMethods = -1

  public static let orderedDictionary = -1
  public static let orderedSet = -1
  public static let anySet = -1

  public static let sourceLine = -1
  public static let objectStack = -1
  public static let blockStack = -1
  // public static let FunctionWrapper = -1

   public static let fileDescriptorType = -1
   public static let fileMode = -1
   public static let stringEncoding = -1
   public static let stringErrorHandling = -1

  internal static func checkInvariants() {
    Self.checkSize(of: RawPtr.self, expected: Self.object)
    Self.checkSize(of: Ptr<PyObject>.self, expected: Self.object)

    Self.checkSize(of: Int.self, expected: Self.int)
    Self.checkSize(of: Optional<Int>.self, expected: Self.optionalInt)
    Self.checkSize(of: UInt32.self, expected: Self.uint32)
    Self.checkSize(of: BigInt.self, expected: Self.bigInt)
    Self.checkSize(of: PyHash.self, expected: Self.hash)
    Self.checkSize(of: Double.self, expected: Self.double)

    Self.checkSize(of: [PyObject].self, expected: Self.array)
    Self.checkSize(of: String.self, expected: Self.string)
    Self.checkSize(of: Optional<String>.self, expected: Self.optionalString)
    Self.checkSize(of: Data.self, expected: Self.data)

    Self.checkSize(of: PyType.DeinitializeFn.self, expected: Self.function)

    Self.checkSize(of: PyType.MemoryLayout.self, expected: Self.typeMemoryLayout)
    Self.checkSize(
      of: PyType.StaticallyKnownNotOverriddenMethods.self,
      expected: Self.typeStaticallyKnownNotOverriddenMethods
    )

    Self.checkSize(of: OrderedDictionary<PyDict.Key, Int>.self, expected: Self.orderedDictionary)
    Self.checkSize(of: OrderedSet<AbstractSet_Element>.self, expected: Self.orderedSet)
    Self.checkSize(of: PyAnySet.self, expected: Self.anySet)

    Self.checkSize(of: SourceLine.self, expected: Self.sourceLine)
    Self.checkSize(of: PyFrame.ObjectStack.self, expected: Self.objectStack)
    Self.checkSize(of: PyFrame.BlockStack.self, expected: Self.blockStack)
    // Self.checkSize(of: FunctionWrapper.self, expected: Self.FunctionWrapper)

    Self.checkSize(of: FileDescriptorType.self, expected: Self.fileDescriptorType)
    Self.checkSize(of: FileMode.self, expected: Self.fileMode)
    Self.checkSize(of: PyString.Encoding.self, expected: Self.stringEncoding)
    Self.checkSize(of: PyString.ErrorHandling.self, expected: Self.stringErrorHandling)
  }

  private static func checkSize<T>(of type: T.Type, expected: Int) {
    let size = MemoryLayout<T>.stride
    if size != expected {
      let typeName = String(describing: type)
      trap("[Invariant] \(typeName) has size \(size) instead of expected \(expected)")
    }
  }
}
