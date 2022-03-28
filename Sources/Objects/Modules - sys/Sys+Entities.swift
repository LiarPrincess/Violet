import VioletCore

extension Sys {

  // MARK: - Flags

  public struct Flags {

    private let arguments: Arguments
    private let _environment: Environment

    private var environment: Environment? {
      if self.ignoreEnvironment {
        return nil
      }

      return self._environment
    }

    internal init(config: PyConfig) {
      self = Flags(arguments: config.arguments, environment: config.environment)
    }

    internal init(arguments: Arguments, environment: Environment) {
      self.arguments = arguments
      self._environment = environment
    }

    public var debug: Bool {
      let env = self.environment?.debug ?? false
      return self.arguments.debug || env
    }

    public var inspect: Bool {
      let env = self.environment?.inspectInteractively ?? false
      return self.arguments.inspectInteractively || env
    }

    public var interactive: Bool {
      let env = self.environment?.inspectInteractively ?? false
      return self.arguments.inspectInteractively || env
    }

    public var optimize: Py.OptimizationLevel {
      let env = self.environment?.optimize ?? .none
      return Swift.max(self.arguments.optimize, env)
    }

    public var ignoreEnvironment: Bool {
      return self.arguments.ignoreEnvironment
    }

    public var verbose: Int {
      let env = self.environment?.verbose ?? 0
      return Swift.max(self.arguments.verbose, env)
    }

    /// Warning options.
    ///
    /// Order: the LATER in the list the bigger the priority.
    public var warnings: [Arguments.WarningOption] {
      // Comment from CPython 'config_init_warnoptions':
      //
      // The priority order for warnings configuration is (highest first):
      // - any '-W' command line options; then
      // - the 'PYTHONWARNINGS' environment variable;
      //
      // Since the warnings module works on the basis of
      // "the most recently added filter will be checked first", we add
      // the lowest precedence entries first so that later entries override them.

      let env = (self.environment?.warnings ?? [])
      return env + self.arguments.warnings
    }

    public var bytesWarning: Arguments.BytesWarningOption {
      return self.arguments.bytesWarning
    }

    public var quiet: Bool {
      return self.arguments.quiet
    }

    public var isolated: Bool {
      return self.arguments.isolated
    }
  }

  // MARK: - HashInfo

  public struct HashInfo {

    /// Name of the algorithm for hashing of str, bytes, and memoryview
    public let algorithm = Hasher.algorithm

    /// Width in bits used for hash values
    public let width = Hasher.width
    /// Internal output size of the hash algorithm
    public let hashBits = Hasher.hashBits
    /// Size of the seed key of the hash algorithm
    public let seedBits = Hasher.seedBits

    /// Prime modulus P used for numeric hash scheme
    public let modulus = Hasher.modulus
    /// Hash value returned for a positive infinity
    public let inf = Hasher.inf
    /// Hash value returned for a nan
    public let nan = Hasher.nan
    /// Multiplier used for the imaginary part of a complex number
    public let imag = Hasher.imag
  }

  // MARK: - VersionInfo

  /// Internal helper for `sys.version_info`.
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
  public struct VersionInfo {

    // swiftlint:disable:next nesting
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

    public let hexVersion: UInt32

    internal init(major: UInt8,
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

  // MARK: - ImplementationInfo

  /// Internal helper for `sys.implementation`.
  public struct ImplementationInfo {

    /// Program name to use on the command line.
    public let name: String
    /// A one-line description of this command.
    public let abstract: String
    /// A longer description of this program,
    /// to be shown in the extended help display.
    public let discussion: String
    public let version: VersionInfo
    public let cacheTag: String?

    internal init(name: String,
                  abstract: String,
                  discussion: String,
                  version: VersionInfo,
                  cacheTag: String?) {
      self.name = name
      self.abstract = abstract
      self.discussion = discussion
      self.version = version
      self.cacheTag = cacheTag
    }
  }
}
