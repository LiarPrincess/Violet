import Objects
import Bytecode

public struct CodeObjectFlags: OptionSet {
  public let rawValue: UInt16

//  public static let optimized   = CodeObjectFlags(rawValue: 0x0001)
//  public static let newLocals   = CodeObjectFlags(rawValue: 0x0002)
  public static let varArgs     = CodeObjectFlags(rawValue: 0x0004)
  public static let varKeywords = CodeObjectFlags(rawValue: 0x0008)
//  public static let nested      = CodeObjectFlags(rawValue: 0x0010)
//  public static let generator   = CodeObjectFlags(rawValue: 0x0020)
//  public static let noFree      = CodeObjectFlags(rawValue: 0x0040)
//  public static let coroutine         = CodeObjectFlags(rawValue: 0x0080)
//  public static let iterableCoroutine = CodeObjectFlags(rawValue: 0x0100)
//  public static let asyncGenerator    = CodeObjectFlags(rawValue: 0x0200)

  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }
}

extension CodeObject {
  public var flags: CodeObjectFlags {
    return CodeObjectFlags()
  }

  public var argCount: Int { return 0 }
  public var kwOnlyArgCount: Int { return 0 }
}
