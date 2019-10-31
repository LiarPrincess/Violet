import Core

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// sourcery: pytype = str
public class PyString: PyObject {

  internal static let doc = """
    str(object='') -> str
    str(bytes_or_buffer[, encoding[, errors]]) -> str

    Create a new string object from the given object. If encoding or
    errors is specified, then the object must expose a data buffer
    that will be decoded using the given encoding and error handler.
    Otherwise, returns the result of object.__str__() (if defined)
    or repr(object).
    encoding defaults to sys.getdefaultencoding().
    errors defaults to 'strict'.
    """

  internal let value: String
  internal lazy var scalars = self.value.unicodeScalars

  // MARK: - Init

  internal init(_ context: PyContext, value: String) {
    self.value = value
    super.init(type: context.builtins.types.str)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    if self === other {
      return .value(true)
    }

    return self.compare(other).map { $0 == .equal }
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .less }
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .less || $0 == .equal }
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .greater }
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return self.compare(other).map { $0 == .greater || $0 == .equal }
  }

  private enum CompareResult {
    case less
    case greater
    case equal
  }

  private func compare(_ other: PyObject) -> PyResultOrNot<CompareResult> {
    guard let other = other as? PyString else {
      return .notImplemented
    }

    return .value(self.compare(other.value))
  }

  private func compare(_ other: String) -> CompareResult {
    // "Cafe\u0301" == "Café" (Caf\u00E9) -> False
    // "Cafe\u0301" <  "Café" (Caf\u00E9) -> True
    let lScalars = self.scalars
    let rScalars = other.unicodeScalars

    for (l, r) in zip(lScalars, rScalars) {
      if l.value < r.value {
        return .less
      }
      if l.value > r.value {
        return .greater
      }
    }

    let lCount = lScalars.count
    let rCount = rScalars.count
    return lCount < rCount ? .less :
           lCount > rCount ? .greater :
           .equal
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .value(HashHelper.hash(self.value))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    // Compute length of output, quote characters and maximum character
    var singleQuoteCount = 0
    var doubleQuoteCount = 0
    for c in self.value {
      switch c {
      case "'":  singleQuoteCount += 1
      case "\"": doubleQuoteCount += 1
      default:   break
      }
    }

    // Use single quote if equal
    let quote: Character = doubleQuoteCount > singleQuoteCount ? "\"" : "'"

    var result = String(quote)
    result.reserveCapacity(self.value.count)

    for c in self.value {
      switch c {
      case quote, "\\":
        result.append("\\")
        result.append(c)
      case "\n":
        result.append("\\")
        result.append("n")
      case "\t":
        result.append("\\")
        result.append("t")
      case "\r":
        result.append("\\")
        result.append("r")
      default:
        result.append(c)
      }
    }
    result.append(quote)

    return result
  }

  // sourcery: pymethod = __str__
  internal func str() -> String {
    return self.value
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> Int {
    return self.scalars.count
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'

    guard let elementString = element as? PyString else {
      return .error(
        .typeError(
          "'in <string>' requires string as left operand, not \(element.typeName)"
        )
      )
    }

    // There are many good substring algorithms, and we went with this?
    var iter = scalars.startIndex
    let needle = elementString.value.unicodeScalars

    while iter != self.scalars.endIndex {
      let substring = self.scalars[iter...]
      if substring.starts(with: needle) {
        return .value(true)
      }

      self.scalars.formIndex(after: &iter)
    }

    return .value(false)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    let result = SequenceHelper.getItem(context: self.context,
                                        elements: self.scalars,
                                        index: index,
                                        typeName: "string")

    switch result {
    case let .single(scalar):
      return .value(self.builtins.newString(String(scalar)))
    case let .slice(scalars):
      return .value(self.builtins.newString(String(scalars)))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherStr = other as? PyString else {
      return .error(
        .typeError("can only concatenate str (not '\(other.typeName)') to str")
      )
    }

    if self.value.isEmpty {
      return .value(PyString(self.context, value: otherStr.value))
    }

    if otherStr.value.isEmpty {
      return .value(PyString(self.context, value: self.value))
    }

    let result = self.value + otherStr.value
    return .value(PyString(self.context, value: result))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let pyInt = other as? PyInt else {
      return .error(
        .typeError("can only multiply str and int (not '\(other.typeName)')")
      )
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .error(.overflowError("repeated string is too long"))
    }

    if self.value.isEmpty || int == 1 {
      return .value(PyString(self.context, value: self.value))
    }

    var result = ""
    for _ in 0..<max(int, 0) {
      result.append(self.value)
    }

    return .value(PyString(self.context, value: result))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.mul(other)
  }
}
