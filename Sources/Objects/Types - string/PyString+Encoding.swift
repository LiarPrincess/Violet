import Foundation

extension PyString {

  /// https://docs.python.org/3.7/library/codecs.html#standard-encodings
  public enum Encoding: CustomStringConvertible {

    /// ascii, 646, us-ascii; English
    case ascii
    /// latin_1, iso-8859-1, iso8859-1, 8859, cp819, latin, latin1, L1; Western Europe
    case isoLatin1
    /// utf_8, U8, UTF, utf8; all languages
    case utf8
    /// utf_16, U16, utf16; all languages
    case utf16
    /// utf_16_be, UTF-16BE; all languages
    case utf16BigEndian
    /// utf_16_le, UTF-16LE; all languages
    case utf16LittleEndian
    /// utf_32, U32, utf32; all languages
    case utf32
    /// utf_32_be, UTF-32BE; all languages
    case utf32BigEndian
    /// utf_32_le, UTF-32LE; all languages
    case utf32LittleEndian

    public static let `default` = Unimplemented.locale.getpreferredencoding

    private var inSwift: String.Encoding {
      switch self {
      case .ascii: return .ascii
      case .isoLatin1: return .isoLatin1
      case .utf8: return .utf8
      case .utf16: return .utf16
      case .utf16BigEndian: return .utf16BigEndian
      case .utf16LittleEndian: return .utf16LittleEndian
      case .utf32: return .utf32
      case .utf32BigEndian: return .utf32BigEndian
      case .utf32LittleEndian: return .utf32LittleEndian
      }
    }

    public var description: String {
      switch self {
      case .ascii: return "ascii"
      case .isoLatin1: return "latin-1"
      case .utf8: return "utf-8"
      case .utf16: return "utf-16"
      case .utf16BigEndian: return "utf-16-be"
      case .utf16LittleEndian: return "utf-16-le"
      case .utf32: return "utf-32"
      case .utf32BigEndian: return "utf-32-be"
      case .utf32LittleEndian: return "utf-32-le"
      }
    }

    // MARK: - Decode

    /// Decode `data` returning `nil` if it fails.
    internal func decode(data: Data) -> String? {
      return String(data: data, encoding: self.inSwift)
    }

    /// Decode `data`.
    /// If this fails -> handle error according to `errorHandling` argument.
    internal func decodeOrError(data: Data,
                                onError: ErrorHandling) -> PyResult<String> {
      if let string = self.decode(data: data) {
        return .value(string)
      }

      // static int _PyCodecRegistry_Init(void)
      switch onError {
      case .strict:
        return .unicodeDecodeError(encoding: self, data: data)
      case .ignore:
        return .value("")
      }
    }

    // MARK: - Encode

    /// Encode `string` returning `nil` if it fails.
    internal func encode(string: String) -> Data? {
      return string.data(using: self.inSwift, allowLossyConversion: false)
    }

    /// Encode `data`.
    /// If this fails -> handle error according to `errorHandling` argument.
    internal func encodeOrError(string: String,
                                onError: ErrorHandling) -> PyResult<Data> {
      if let data = self.encode(string: string) {
        return .value(data)
      }

      // static int _PyCodecRegistry_Init(void)
      switch onError {
      case .strict:
        return .unicodeEncodeError(encoding: self, string: string)
      case .ignore:
        return .value(Data())
      }
    }

    // MARK: - From

    internal static func from(object: PyObject?) -> PyResult<Encoding> {
      guard let object = object else {
        return .value(.default)
      }

      guard let string = PyCast.asString(object) else {
        return .typeError("encoding must be str, not \(object.typeName)")
      }

      return Self.from(string: string.value)
    }

    // swiftlint:disable:next function_body_length
    internal static func from(string: String) -> PyResult<Encoding> {
      switch string {
      case "ascii",
           "646",
           "us-ascii":
        return .value(.ascii)
      case "latin_1",
           "iso-8859-1",
           "iso8859-1",
           "8859",
           "cp819",
           "latin",
           "latin1",
           "L1":
        return .value(.isoLatin1)
      case "utf_8",
           "U8",
           "UTF",
           "utf8",
           "utf-8":
        return .value(.utf8)
      case "utf_16",
           "U16",
           "utf16":
        return .value(.utf16)
      case "utf_16_be",
           "UTF-16BE":
        return .value(.utf16BigEndian)
      case "utf_16_le",
           "UTF-16LE":
        return .value(.utf16LittleEndian)
      case "utf_32",
           "U32",
           "utf32":
        return .value(.utf32)
      case "utf_32_be",
           "UTF-32BE":
        return .value(.utf32BigEndian)
      case "utf_32_le",
           "UTF-32LE":
        return .value(.utf32LittleEndian)
      default:
        return .unboundLocalError(variableName: "unknown encoding: \(string)")
      }
    }
  }
}
