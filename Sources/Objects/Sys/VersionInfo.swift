/// Internal helper for `version_info`.
///
/// A tuple containing the five components of the version number:
/// `major`, `minor`, `micro`, `releaselevel`, and `serial`.
///
/// All values except `releaselevel` are integers;
/// the release level is `'alpha'`, `'beta'`, `'candidate'`, or `'final'`.
///
/// The `version_info` value corresponding to the Python version 2.0
/// is (2, 0, 0, 'final', 0).
///
/// The components can also be accessed by name, so `sys.version_info[0]`
/// is equivalent to `sys.version_info.major` and so on.
///
/// ```
/// >>> sys.version_info
/// sys.version_info(major=3, minor=7, micro=2, releaselevel='final', serial=0)
/// ```
public class VersionInfo {

  public enum ReleaseLevel: CustomStringConvertible {
    case alpha
    case beta
    case candidate
    case final

    public var description: String {
      switch self {
      case .alpha: return "alpha"
      case .beta: return "beta"
      case .candidate: return "candidate"
      case .final: return "final"
      }
    }

    fileprivate var hexVersion: UInt8 {
      switch self {
      case .alpha: return 0x0a
      case .beta: return 0x0b
      case .candidate: return 0x0c
      case .final: return 0x0f
      }
    }
  }

  public let major: UInt8
  public let minor: UInt8
  public let micro: UInt8
  public let releaseLevel: ReleaseLevel
  public let serial: UInt8

  public lazy var object: PyNamespace = {
    let attributes = Attributes()
    attributes.set(key: "major", to: Py.builtins.newInt(self.major))
    attributes.set(key: "minor", to: Py.builtins.newInt(self.minor))
    attributes.set(key: "micro", to: Py.builtins.newInt(self.micro))
    attributes.set(key: "releaseLevel", to: Py.builtins.newString(self.releaseLevel.description))
    attributes.set(key: "serial", to: Py.builtins.newInt(self.serial))
    return Py.builtins.newNamespace(attributes: attributes)
  }()

  public let hexVersion: UInt32

  public lazy var hexVersionObject = Py.builtins.newInt(self.hexVersion)

  public init(major: UInt8,
              minor: UInt8,
              micro: UInt8,
              releaseLevel: ReleaseLevel,
              serial: UInt8) {
    self.major = major
    self.minor = minor
    self.micro = micro
    self.releaseLevel = releaseLevel
    self.serial = serial

    // https://docs.python.org/3.7/c-api/apiabiversion.html#apiabiversion
    // >>> sys.version_info
    // sys.version_info(major=3, minor=7, micro=2, releaselevel='final', serial=0)
    // >>> hex(sys.hexversion)
    // '0x030702f0'
    let majorHex = UInt32(major) << 24
    let minorHex = UInt32(minor) << 16
    let microHex = UInt32(micro) << 8
    let releaseLevelHex = UInt32(releaseLevel.hexVersion) << 4
    let serialHex = UInt32(serial)
    self.hexVersion = majorHex | minorHex | microHex | releaseLevelHex | serialHex
  }
}
