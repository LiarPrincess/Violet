import Foundation
import BigInt
import VioletCore

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
  public static let uint32 = 4
  public static let bigInt = 8
  public static let double = 8

  public static let array = -1
  public static let string = 16
  public static let data = -1

  public static let function = 16

  public static let typeMemoryLayout = -1
  public static let typeStaticallyKnownNotOverriddenMethods = -1
  // public static let BlockStack = -1
  // public static let CodeObject = -1
  // public static let FileDescriptorType = -1
  // public static let FileMode = -1
  // public static let FunctionWrapper = -1
  // public static let ObjectStack = -1
  // public static let OrderedDictionary = -1
  // public static let OrderedSet = -1
  // public static let PyAnySet = -1
  // public static let PyString.Encoding = -1
  // public static let PyString.ErrorHandling = -1
  // public static let SourceLine = -1

  internal static func checkInvariants() {
    Self.checkSize(of: RawPtr.self, expected: Self.object)
    Self.checkSize(of: Ptr<PyObject>.self, expected: Self.object)

    Self.checkSize(of: Int.self, expected: Self.int)
    Self.checkSize(of: UInt32.self, expected: Self.uint32)
    Self.checkSize(of: BigInt.self, expected: Self.bigInt)
    Self.checkSize(of: Double.self, expected: Self.double)

    Self.checkSize(of: [PyObject].self, expected: Self.array)
    Self.checkSize(of: String.self, expected: Self.string)
    Self.checkSize(of: Data.self, expected: Self.data)

    Self.checkSize(of: PyType.DeinitializeFn.self, expected: Self.function)

    Self.checkSize(of: PyType.MemoryLayout.self, expected: Self.typeMemoryLayout)
    Self.checkSize(of: PyType.StaticallyKnownNotOverriddenMethods.self,
                   expected: Self.typeStaticallyKnownNotOverriddenMethods)
    // Self.checkSize(of: BlockStack.self, expected: Self.BlockStack)
    // Self.checkSize(of: CodeObject.self, expected: Self.CodeObject)
    // Self.checkSize(of: FileDescriptorType.self, expected: Self.FileDescriptorType)
    // Self.checkSize(of: FileMode.self, expected: Self.FileMode)
    // Self.checkSize(of: FunctionWrapper.self, expected: Self.FunctionWrapper)
    // Self.checkSize(of: ObjectStack.self, expected: Self.ObjectStack)
    // Self.checkSize(of: OrderedDictionary.self, expected: Self.OrderedDictionary)
    // Self.checkSize(of: OrderedSet.self, expected: Self.OrderedSet)
    // Self.checkSize(of: PyAnySet.self, expected: Self.PyAnySet)
    // Self.checkSize(of: PyString.Encoding.self, expected: Self.PyString.Encoding)
    // Self.checkSize(of: PyString.ErrorHandling.self, expected: Self.PyString.ErrorHandling)
    // Self.checkSize(of: SourceLine.self, expected: Self.SourceLine)
  }

  private static func checkSize<T>(of type: T.Type, expected: Int) {
    let size = MemoryLayout<T>.stride
    if size != expected {
      let typeName = String(describing: type)
      trap("[Invariant] \(typeName) has size \(size) instead of expected \(expected)")
    }
  }
}
