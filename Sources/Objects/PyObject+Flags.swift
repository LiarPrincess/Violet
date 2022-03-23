extension PyObject {

  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// Some of the flags are the same on every object (for example `reprLock`).
  /// The rest (the ones starting with `custom`) depend on the object type
  /// (so basically, you can use `Flags` to store `Bool` properties).
  ///
  /// Btw. it does not implement 'OptionSet', its interface is a bit awkward.
  public struct Flags: Equatable, CustomStringConvertible {

    public static let `default` = Flags()

    // swiftlint:disable:next nesting
    private typealias Storage = UInt32

    private var rawValue: Storage

    public init() {
      self.rawValue = 0
    }

    private init(rawValue: Storage) {
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

    // === Reserved for future use ===
    // Not assigned (for now), but we expect garbage collection to use some of them.
    private static let reserved2 = Flags(rawValue: 1 << 2)
    private static let reserved3 = Flags(rawValue: 1 << 3)
    private static let reserved4 = Flags(rawValue: 1 << 4)
    private static let reserved5 = Flags(rawValue: 1 << 5)
    private static let reserved6 = Flags(rawValue: 1 << 6)
    private static let reserved7 = Flags(rawValue: 1 << 7)

    /// Mask that contains all of the flags that are present on every object
    /// (regardless of object type).
    ///
    /// It includes: `reprLock`, `has__dict__` etc.
    private static var presentOnEveryObjectMask: Storage = 0b1111_1111

    // MARK: - Custom

    private static let customStart: Storage = 8

    // Use following code to generate:
    //
    // for i in range(0, 24):
    //   print(f'/// Flag `{i}` that can be used based on object type.')
    //   print(f'public static let custom{i} = Flags(rawValue: 1 << (Self.customStart + {i}))')

    /// Flag `0` that can be used based on object type.
    public static let custom0 = Flags(rawValue: 1 << (Self.customStart + 0))
    /// Flag `1` that can be used based on object type.
    public static let custom1 = Flags(rawValue: 1 << (Self.customStart + 1))
    /// Flag `2` that can be used based on object type.
    public static let custom2 = Flags(rawValue: 1 << (Self.customStart + 2))
    /// Flag `3` that can be used based on object type.
    public static let custom3 = Flags(rawValue: 1 << (Self.customStart + 3))
    /// Flag `4` that can be used based on object type.
    public static let custom4 = Flags(rawValue: 1 << (Self.customStart + 4))
    /// Flag `5` that can be used based on object type.
    public static let custom5 = Flags(rawValue: 1 << (Self.customStart + 5))
    /// Flag `6` that can be used based on object type.
    public static let custom6 = Flags(rawValue: 1 << (Self.customStart + 6))
    /// Flag `7` that can be used based on object type.
    public static let custom7 = Flags(rawValue: 1 << (Self.customStart + 7))
    /// Flag `8` that can be used based on object type.
    public static let custom8 = Flags(rawValue: 1 << (Self.customStart + 8))
    /// Flag `9` that can be used based on object type.
    public static let custom9 = Flags(rawValue: 1 << (Self.customStart + 9))
    /// Flag `10` that can be used based on object type.
    public static let custom10 = Flags(rawValue: 1 << (Self.customStart + 10))
    /// Flag `11` that can be used based on object type.
    public static let custom11 = Flags(rawValue: 1 << (Self.customStart + 11))
    /// Flag `12` that can be used based on object type.
    public static let custom12 = Flags(rawValue: 1 << (Self.customStart + 12))
    /// Flag `13` that can be used based on object type.
    public static let custom13 = Flags(rawValue: 1 << (Self.customStart + 13))
    /// Flag `14` that can be used based on object type.
    public static let custom14 = Flags(rawValue: 1 << (Self.customStart + 14))
    /// Flag `15` that can be used based on object type.
    public static let custom15 = Flags(rawValue: 1 << (Self.customStart + 15))
    /// Flag `16` that can be used based on object type.
    public static let custom16 = Flags(rawValue: 1 << (Self.customStart + 16))
    /// Flag `17` that can be used based on object type.
    public static let custom17 = Flags(rawValue: 1 << (Self.customStart + 17))
    /// Flag `18` that can be used based on object type.
    public static let custom18 = Flags(rawValue: 1 << (Self.customStart + 18))
    /// Flag `19` that can be used based on object type.
    public static let custom19 = Flags(rawValue: 1 << (Self.customStart + 19))
    /// Flag `20` that can be used based on object type.
    public static let custom20 = Flags(rawValue: 1 << (Self.customStart + 20))
    /// Flag `21` that can be used based on object type.
    public static let custom21 = Flags(rawValue: 1 << (Self.customStart + 21))
    /// Flag `22` that can be used based on object type.
    public static let custom22 = Flags(rawValue: 1 << (Self.customStart + 22))
    /// Flag `23` that can be used based on object type.
    public static let custom23 = Flags(rawValue: 1 << (Self.customStart + 23))

    /// Mask that contains all of the flags that can be used based on object type.
    private static var customMask: Storage {
      let everyObjectMask = Flags.presentOnEveryObjectMask
      return ~everyObjectMask
    }

    // MARK: - Custom UInt16

    private static var customUInt16Mask: Storage {
      let allOneUInt16 = UInt16.max
      let allOneStorage = Storage(allOneUInt16)
      return allOneStorage << Self.customStart
    }

    /// Custom flags are wide enough that we can store a whole `UInt16` inside.
    ///
    /// - Important:
    /// `customUInt16` overlaps with `custom` flags from `0` to `15`!
    internal var customUInt16: UInt16 {
      get {
        let valueShiftedHigh = self.rawValue & Self.customUInt16Mask
        let valueStorage = valueShiftedHigh >> Self.customStart
        return UInt16(valueStorage)
      }
      set {
        let newValueStorage = Storage(newValue)
        let toCopy = newValueStorage << Self.customStart

        let toPreserveMask = ~Self.customUInt16Mask
        let toPreserve = self.rawValue & toPreserveMask

        self.rawValue = toPreserve | toCopy
      }
    }

    // MARK: - Description

    public var description: String {
      var result = "["
      var isFirst = true

      func appendIfSet(_ flag: Flags, name: String) {
        guard self.isSet(flag) else {
          return
        }

        if !isFirst {
          result += ", "
        }

        result.append(name)
        isFirst = false
      }

      // We want to list all of the flags by hand, so that if we rename some
      // flag (for example 'reserved3' -> 'XXX') we will get an compilation error.
      appendIfSet(.reprLock, name: "reprLock")
      appendIfSet(.descriptionLock, name: "descriptionLock")
      appendIfSet(.reserved2, name: "reserved2")
      appendIfSet(.reserved3, name: "reserved3")
      appendIfSet(.reserved4, name: "reserved4")
      appendIfSet(.reserved5, name: "reserved5")
      appendIfSet(.reserved6, name: "reserved6")
      appendIfSet(.reserved7, name: "reserved7")
      appendIfSet(.custom0, name: "custom0")
      appendIfSet(.custom1, name: "custom1")
      appendIfSet(.custom2, name: "custom2")
      appendIfSet(.custom3, name: "custom3")
      appendIfSet(.custom4, name: "custom4")
      appendIfSet(.custom5, name: "custom5")
      appendIfSet(.custom6, name: "custom6")
      appendIfSet(.custom7, name: "custom7")
      appendIfSet(.custom8, name: "custom8")
      appendIfSet(.custom9, name: "custom9")
      appendIfSet(.custom10, name: "custom10")
      appendIfSet(.custom11, name: "custom11")
      appendIfSet(.custom12, name: "custom12")
      appendIfSet(.custom13, name: "custom13")
      appendIfSet(.custom14, name: "custom14")
      appendIfSet(.custom15, name: "custom15")
      appendIfSet(.custom16, name: "custom16")
      appendIfSet(.custom17, name: "custom17")
      appendIfSet(.custom18, name: "custom18")
      appendIfSet(.custom19, name: "custom19")
      appendIfSet(.custom20, name: "custom20")
      appendIfSet(.custom21, name: "custom21")
      appendIfSet(.custom22, name: "custom22")
      appendIfSet(.custom23, name: "custom23")

      result.append("]")
      return result
    }

    // MARK: - Methods

    /// Is given flag set?
    public func isSet(_ flag: Flags) -> Bool {
      return (self.rawValue & flag.rawValue) == flag.rawValue
    }

    /// Append given flag.
    internal mutating func set(_ flag: Flags) {
      self.rawValue = self.rawValue | flag.rawValue
    }

    /// Append/remove given flag.
    internal mutating func set(_ flag: Flags, value: Bool) {
      if value {
        self.set(flag)
      } else {
        self.unset(flag)
      }
    }

    /// Set all of the `custom` flags to match the ones on provided object.
    internal mutating func setCustomFlags(from other: Flags) {
      let toPreserveMask = Flags.presentOnEveryObjectMask
      let toPreserve = self.rawValue & toPreserveMask

      let toCopyMask = Flags.customMask
      let toCopy = other.rawValue & toCopyMask

      self.rawValue = toPreserve | toCopy
    }

    /// Remove given flag.
    internal mutating func unset(_ flag: Flags) {
      let flagNegated = ~flag.rawValue
      self.rawValue = self.rawValue & flagNegated
    }
  }
}
