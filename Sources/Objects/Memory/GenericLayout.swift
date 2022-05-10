/// See this:
/// https://belkadan.com/blog/2020/09/Swift-Runtime-Type-Layout/
internal struct GenericLayout {

  internal struct Field {
    internal let size: Int
    internal let alignment: Int
    internal let repeatCount: Int

    /// `repeatCount` is the number of times `type` is repeated:
    /// ```c
    /// struct DisnepPrincess {
    ///     char name[20];
    /// };
    /// sizeof (struct DisnepPrincess) // 20
    /// ```
    internal init<T>(_ type: T.Type, repeatCount: Int = 1) {
      assert(repeatCount >= 0)
      self.size = MemoryLayout<T>.size
      self.alignment = MemoryLayout<T>.alignment
      self.repeatCount = repeatCount
    }
  }

  internal private(set) var size: Int
  internal private(set) var alignment: Int
  internal private(set) var offsets: [Int]

  internal init(initialOffset: Int, initialAlignment: Int, fields: [Field]) {
    self.size = initialOffset
    self.alignment = initialAlignment

    self.offsets = [Int]()
    self.offsets.reserveCapacity(fields.count)

    for field in fields {
      Self.round(&self.size, alignment: field.alignment)
      self.offsets.append(self.size)

      // If 'repeatCount == 1' then we will not pad after!
      // It is possible that the next field will fit there.
      //
      // If 'repeatCount > 1' then pad, it is simpler. Technically we could pad
      // everything except for last, but then the mental model is complicatd.
      if field.repeatCount == 1 {
        self.size += field.size
      } else {
        var stride = field.size
        Self.round(&stride, alignment: field.alignment)
        self.size += stride * field.repeatCount
      }

      self.alignment = Swift.max(self.alignment, field.alignment)
    }

    // Technically we could round up the 'self.size' to 'self.alignment',
    // but by not doing so we can safe some memory (maybe).
    //
    // Example for 'PyObject' on 64-bit:
    // - alignment: 8
    // - last field size: 4 (flags: UInt32, other fields are 8)
    //
    // If we align the 'PyObject' then we will get a hole with size 4 after last
    // field. But what if the next field has size 4? We could have used this hole!
    //
    // In C they would align. This is because of 'no-padding-in-arrays',
    // 'taking-pointers-to-nested-structs' and 'other-complicated-things'.
    // In Swift they would not align (afaik) - just like we do. This makes
    // certain operations illegal, but potentially saves memory.
  }

  private static func round(_ value: inout Int, alignment: Int) {
    value += alignment &- 1
    value &-= value % alignment
  }
}
