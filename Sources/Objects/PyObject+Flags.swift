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

    public init() {
      self.rawValue = 0
    }

    private init(rawValue: UInt32) {
      self.rawValue = rawValue
    }

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
    /// This flag is used to control infinite recursion in `description`.
    ///
    /// It is used when container objects recursively contain themselves.
    public static let descriptionLock = Flags(rawValue: 1 << 1)

    /// (VIOLET ONLY!)
    /// Flag denoting that this object has access to `__dict__`.
    ///
    /// This flag is automatically copied from `self.type`.
    public static let has__dict__ = Flags(rawValue: 1 << 2)

    // === Reserved for future use ===
    // Not assigned (for now), but we expect garbage collection to use some of them.
    private static let reserved3 = Flags(rawValue: 1 << 3)
    private static let reserved4 = Flags(rawValue: 1 << 4)
    private static let reserved5 = Flags(rawValue: 1 << 5)
    private static let reserved6 = Flags(rawValue: 1 << 6)
    private static let reserved7 = Flags(rawValue: 1 << 7)

    /// Mask that contains all of the flags that are present on every object
    /// (regardless of object type).
    ///
    /// It includes: `reprLock`, `has__dict__` etc.
    public static var presentOnEveryObjectMask: Flags = {
      var result = Flags()
      result.set(Flags.reprLock)
      result.set(Flags.descriptionLock)
      result.set(Flags.has__dict__)
      result.set(Flags.reserved3)
      result.set(Flags.reserved4)
      result.set(Flags.reserved5)
      result.set(Flags.reserved6)
      result.set(Flags.reserved7)
      return result
    }()

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

    /// Mask that contains all of the flags that can be used based on object type.
    public static var customMask: Flags {
      let everyObjectMask = Flags.presentOnEveryObjectMask.rawValue
      let negative = ~everyObjectMask
      return Flags(rawValue: negative)
    }

    // MARK: - Description

    public var description: String {
      var result = "["
      var isFirst = true

      func append(_ s: String) {
        if !isFirst {
          result += ", "
        }

        result.append(s)
        isFirst = false
      }

      if self.isSet(.reprLock) { append("reprLock") }
      if self.isSet(.descriptionLock) { append("descriptionLock") }
      if self.isSet(.has__dict__) { append("has__dict__") }
      if self.isSet(.reserved3) { append("reserved3") }
      if self.isSet(.reserved4) { append("reserved4") }
      if self.isSet(.reserved5) { append("reserved5") }
      if self.isSet(.reserved6) { append("reserved6") }
      if self.isSet(.reserved7) { append("reserved7") }
      if self.isSet(.custom0) { append("custom0") }
      if self.isSet(.custom1) { append("custom1") }
      if self.isSet(.custom2) { append("custom2") }
      if self.isSet(.custom3) { append("custom3") }
      if self.isSet(.custom4) { append("custom4") }
      if self.isSet(.custom5) { append("custom5") }
      if self.isSet(.custom6) { append("custom6") }
      if self.isSet(.custom7) { append("custom7") }
      if self.isSet(.custom8) { append("custom8") }
      if self.isSet(.custom9) { append("custom9") }
      if self.isSet(.custom10) { append("custom10") }
      if self.isSet(.custom11) { append("custom11") }
      if self.isSet(.custom12) { append("custom12") }
      if self.isSet(.custom13) { append("custom13") }
      if self.isSet(.custom14) { append("custom14") }
      if self.isSet(.custom15) { append("custom15") }
      if self.isSet(.custom16) { append("custom16") }
      if self.isSet(.custom17) { append("custom17") }
      if self.isSet(.custom18) { append("custom18") }
      if self.isSet(.custom19) { append("custom19") }
      if self.isSet(.custom20) { append("custom20") }
      if self.isSet(.custom21) { append("custom21") }
      if self.isSet(.custom22) { append("custom22") }
      if self.isSet(.custom23) { append("custom23") }

      result.append("]")
      return result
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

    /// Set all of the `custom` flags to match the ones on provided object.
    internal mutating func setCustomFlags(from other: Flags) {
      let toPreserveMask = Flags.presentOnEveryObjectMask.rawValue
      let toPreserve = self.rawValue & toPreserveMask

      let toCopyMask = Flags.customMask.rawValue
      let toCopy = other.rawValue & toCopyMask

      self.rawValue = toPreserve | toCopy
    }

    /// Remove given flag.
    public mutating func unset(_ flag: Flags) {
      let flagNegated = ~flag.rawValue
      self.rawValue = self.rawValue & flagNegated
    }
  }
}
