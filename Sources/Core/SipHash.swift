import Foundation

// swiftlint:disable fallthrough

/// Number of compression rounds.
private let c = 2
/// Number of finalization rounds.
private let d = 4

/// Implementation of [SipHash-2-4](https://131002.net/siphash/)
/// Based on [reference implementation](https://github.com/veorq/SipHash).
public enum SipHash {

  /// Hash given buffer using [SipHash-2-4](https://131002.net/siphash/).
  ///
  /// - Parameter key0: little-endian 64-bit word encoding the key `k`.
  /// - Parameter key1: little-endian 64-bit word encoding the key `k`.
  /// - Parameter bytes: buffer to hash
  public static func hash(key0: UInt64,
                          key1: UInt64,
                          bytes: UnsafeBufferPointer<UInt8>) -> UInt64 {
    let rawBufferPointer = UnsafeRawBufferPointer(bytes)
    return SipHash.hash(key0: key0, key1: key1, bytes: rawBufferPointer)
  }

  /// Hash given buffer using [SipHash-2-4](https://131002.net/siphash/).
  ///
  /// - Parameter key0: little-endian 64-bit word encoding the key `k`.
  /// - Parameter key1: little-endian 64-bit word encoding the key `k`.
  /// - Parameter bytes: buffer to hash
  public static func hash(key0: UInt64,
                          key1: UInt64,
                          bytes: UnsafeRawBufferPointer) -> UInt64 {
    var state = State(key0: key0, key1: key1)

    // Read bytes as 'UInt64' buffer.
    // If `bytes.count` is not multiply of word size (UInt64 - 8 bytes) then
    // some bytes will not be processed.
    // For example if `bytes.count` is 17 then it will leave 1 byte unprocessed.
    // We are also assuming little-endian architecture.
    for word in bytes.bindMemory(to: UInt64.self) {
      state.process(word)
    }

    /// Process remaining bytes
    let wordSizeInBytes = MemoryLayout<UInt64>.size
    let remainingBytes = bytes.count % wordSizeInBytes
    let remainingBytesStart = (bytes.count / wordSizeInBytes) * wordSizeInBytes

    var b = UInt64(bytes.count) &<< 56
    switch remainingBytes {
    case 7: b |= UInt64(bytes[remainingBytesStart + 6]) &<< 48; fallthrough
    case 6: b |= UInt64(bytes[remainingBytesStart + 5]) &<< 40; fallthrough
    case 5: b |= UInt64(bytes[remainingBytesStart + 4]) &<< 32; fallthrough
    case 4: b |= UInt64(bytes[remainingBytesStart + 3]) &<< 24; fallthrough
    case 3: b |= UInt64(bytes[remainingBytesStart + 2]) &<< 16; fallthrough
    case 2: b |= UInt64(bytes[remainingBytesStart + 1]) &<< 8; fallthrough
    case 1: b |= UInt64(bytes[remainingBytesStart]); fallthrough
    case 0: state.process(b)
    default: unreachable() // "0 <= remainingBytes < 8"
    }

    return state.finalize()
  }

  private struct State {
    // cspell:disable-next
    // We will use the same "somepseudorandomlygeneratedbytes" as in example.
    // (Although it is very tempting to use Disnep themed values.)
    private var v0: UInt64 = 0x736f_6d65_7073_6575
    private var v1: UInt64 = 0x646f_7261_6e64_6f6d
    private var v2: UInt64 = 0x6c79_6765_6e65_7261
    private var v3: UInt64 = 0x7465_6462_7974_6573

    fileprivate init(key0: UInt64, key1: UInt64) {
      self.v0 ^= key0
      self.v1 ^= key1
      self.v2 ^= key0
      self.v3 ^= key1
    }

    fileprivate mutating func process(_ value: UInt64) {
      self.v3 ^= value

      for _ in 0..<c {
        self.round()
      }

      self.v0 ^= value
    }

    fileprivate mutating func finalize() -> UInt64 {
      self.v2 ^= 0xff

      for _ in 0..<d {
        self.round()
      }

      return self.v0 ^ self.v1 ^ self.v2 ^ self.v3
    }

    private mutating func round() {
      self.v0 = self.v0 &+ self.v1
      self.v1 = self.rotateLeft(self.v1, by: 13)
      self.v1 ^= self.v0
      self.v0 = self.rotateLeft(self.v0, by: 32)
      self.v2 = self.v2 &+ self.v3
      self.v3 = self.rotateLeft(self.v3, by: 16)
      self.v3 ^= self.v2
      self.v0 = self.v0 &+ self.v3
      self.v3 = self.rotateLeft(self.v3, by: 21)
      self.v3 ^= self.v0
      self.v2 = self.v2 &+ self.v1
      self.v1 = self.rotateLeft(self.v1, by: 17)
      self.v1 ^= self.v2
      self.v2 = self.rotateLeft(self.v2, by: 32)
    }

    private func rotateLeft(_ value: UInt64, by count: UInt64) -> UInt64 {
      return (value &<< count) | (value &>> (64 - count))
    }

    fileprivate func trace() {
      print("v0 \(String(self.v0, radix: 16, uppercase: false))")
      print("v1 \(String(self.v1, radix: 16, uppercase: false))")
      print("v2 \(String(self.v2, radix: 16, uppercase: false))")
      print("v3 \(String(self.v3, radix: 16, uppercase: false))")
    }
  }
}
