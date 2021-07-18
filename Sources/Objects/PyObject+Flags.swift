extension PyObject {

  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// Some of the flags are the same on every object (for example `reprLock`).
  /// The rest (the ones starting with `custom`) depend on the object type
  /// (so basically, you can use `Flags` to store `Bool` properties).
  ///
  /// Btw. it does not implement 'OptionSet', its interface is a bit awkward.
  public struct Flags: CustomStringConvertible {

    private var rawValue: UInt32

    // MARK: - Present on every object

    /// This flag is used to control infinite recursion
    /// in `repr`, `str`, `print` etc.
    ///
    /// It is used when container objects recursively contain themselves:
    /// ```py
    /// >>> l = [1]
    /// >>> l.append(l)
    /// >>> l
    /// [1, [...]]
    /// ```
    ///
    /// Use `PyObject.withReprLock()` to automate setting/resetting this flag.
    public static let reprLock = Flags(rawValue: 1 << 0)

    /// (VIOLET ONLY!)
    /// Flag denoting that this object has access to `__dict__`.
    ///
    /// This flag is automatically copied from `self.type`.
    public static let has__dict__ = Flags(rawValue: 1 << 1)

    // *** Reserved for future use ***
    // Not assigned (for now), but we expect garbage collection to use some of them.
//    public static let reserved2 = Flags(rawValue: 1 << 2)
//    public static let reserved3 = Flags(rawValue: 1 << 3)
//    public static let reserved4 = Flags(rawValue: 1 << 4)
//    public static let reserved5 = Flags(rawValue: 1 << 5)
//    public static let reserved6 = Flags(rawValue: 1 << 6)
//    public static let reserved7 = Flags(rawValue: 1 << 7)

    // MARK: - Depends on object type

    /// Flag `0` that can be used based on object type.
    public static let custom0 = Flags(rawValue: 1 << 8)
    /// Flag `1` that can be used based on object type.
    public static let custom1 = Flags(rawValue: 1 << 9)
    /// Flag `2` that can be used based on object type.
    public static let custom2 = Flags(rawValue: 1 << 10)
    /// Flag `3` that can be used based on object type.
    public static let custom3 = Flags(rawValue: 1 << 11)
    /// Flag `4` that can be used based on object type.
    public static let custom4 = Flags(rawValue: 1 << 12)
    /// Flag `5` that can be used based on object type.
    public static let custom5 = Flags(rawValue: 1 << 13)
    /// Flag `6` that can be used based on object type.
    public static let custom6 = Flags(rawValue: 1 << 14)
    /// Flag `7` that can be used based on object type.
    public static let custom7 = Flags(rawValue: 1 << 15)
    /// Flag `8` that can be used based on object type.
    public static let custom8 = Flags(rawValue: 1 << 16)
    /// Flag `9` that can be used based on object type.
    public static let custom9 = Flags(rawValue: 1 << 17)
    /// Flag `10` that can be used based on object type.
    public static let custom10 = Flags(rawValue: 1 << 18)
    /// Flag `11` that can be used based on object type.
    public static let custom11 = Flags(rawValue: 1 << 19)
    /// Flag `12` that can be used based on object type.
    public static let custom12 = Flags(rawValue: 1 << 20)
    /// Flag `13` that can be used based on object type.
    public static let custom13 = Flags(rawValue: 1 << 21)
    /// Flag `14` that can be used based on object type.
    public static let custom14 = Flags(rawValue: 1 << 22)
    /// Flag `15` that can be used based on object type.
    public static let custom15 = Flags(rawValue: 1 << 23)
    /// Flag `16` that can be used based on object type.
    public static let custom16 = Flags(rawValue: 1 << 24)
    /// Flag `17` that can be used based on object type.
    public static let custom17 = Flags(rawValue: 1 << 25)
    /// Flag `18` that can be used based on object type.
    public static let custom18 = Flags(rawValue: 1 << 26)
    /// Flag `19` that can be used based on object type.
    public static let custom19 = Flags(rawValue: 1 << 27)
    /// Flag `20` that can be used based on object type.
    public static let custom20 = Flags(rawValue: 1 << 28)
    /// Flag `21` that can be used based on object type.
    public static let custom21 = Flags(rawValue: 1 << 29)
    /// Flag `22` that can be used based on object type.
    public static let custom22 = Flags(rawValue: 1 << 30)
    /// Flag `23` that can be used based on object type.
    public static let custom23 = Flags(rawValue: 1 << 31)

    // MARK: - Description

    public var description: String {
      var result = ""
      func append(_ s: String) {
        if !result.isEmpty {
          result += ", "
        }

        result.append(s)
      }

      if self.isSet(.reprLock) {
        append("reprLock")
      }

      if self.isSet(.has__dict__) {
        append("has__dict__")
      }

      let customStart = Self.custom0.rawValue
      let customEnd = Self.custom23.rawValue
      for rawValue in customStart...customEnd {
        let flag = Flags(rawValue: rawValue)
        if self.isSet(flag) {
          let index = rawValue - customStart
          append("custom\(index)")
        }
      }

      return "PyObject.Flags(\(result))"
    }

    // MARK: - Methods

    /// Is given flag set?
    public func isSet(_ flag: Flags) -> Bool {
      return (self.rawValue & flag.rawValue) == flag.rawValue
    }

    /// Append given flag.
    public mutating func set(_ flag: Flags) {
      self.rawValue = self.rawValue | flag.rawValue
    }

    /// Append/remove given flag.
    public mutating func set(_ flag: Flags, to value: Bool) {
      if value {
        self.set(flag)
      } else {
        self.unset(flag)
      }
    }

    /// Remove given flag.
    public mutating func unset(_ flag: Flags) {
      let flagNegated = ~flag.rawValue
      self.rawValue = self.rawValue & flagNegated
    }

    public init() {
      self.rawValue = 0
    }

    private init(rawValue: UInt32) {
      self.rawValue = rawValue
    }
  }
}
