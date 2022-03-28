import Foundation
import BigInt
import VioletCore
import VioletBytecode

// MARK: - Assert size

/// Check the memory footprint of a given type.
///
/// Technically `stride` would be better, but the same `stride` may describe
/// multiple `sizes` and in this test we are more interested in the fact
/// that the value has changed and not in the value itself.
private func assertSize<T>(type: T.Type, expected: Int) {
  let size = MemoryLayout<T>.size
  let typeName = String(describing: type)
  assertSize(typeName: typeName, size: size, expected: expected)
}

private func assertSize(typeName: String, size: Int, expected: Int) {
  if size != expected {
    trap("[Invariant] \(typeName) has size \(size) instead of expected \(expected)")
  }
}

// MARK: - Dump

/// Print the memory representation of a given value.
private func dumpMemory<T>(of value: T) {
  print("\(String(describing: value)) (\(String(describing: T.self)))")
  print("  Size:", MemoryLayout<T>.size)
  print("  Stride:", MemoryLayout<T>.stride)
  print("  Alignment:", MemoryLayout<T>.alignment)

  withUnsafeBytes(of: value) { bufferPtr in
    let address = bufferPtr.baseAddress.map { String(describing: $0) } ?? ""
    print("  Address:", address)
    print("  Data:    ", terminator: "")
    for byte in bufferPtr {
      let hex = String(byte, radix: 16, uppercase: false)
      let hexPad = hex.padding(toLength: 2, withPad: "0", startingAt: 0)
      print(hexPad + " ", terminator: "")
    }
    print()
  }
  print()
}

// MARK: - Check invariants

/// Static checks, at runtime because YOLO.
internal func checkInvariants() {
  // 1 ptr (it should use tagged pointer internally)
  assertSize(type: BigInt.self, expected: 8)

  // 1 opcode + 1 argument = 2
  assertSize(type: Instruction.self, expected: 2)

  // 4 line + 4 column = 8
  assertSize(type: SourceLocation.self, expected: 8)

  //            | size alignment | offset | object_size object_alignment
  // type       |    8         8 |      0 |           8                8
  // memoryInfo |   16         8 |      8 |          24                8
  // __dict__   |(!) 9         8 |     24 |          33                8
  // flags      |    4         4 |     36 |          40                8
  //                                                 ^^ THIS
  let objectSize = PyObject.layout.size
  assertSize(typeName: "PyObject", size: objectSize, expected: 40)
}
