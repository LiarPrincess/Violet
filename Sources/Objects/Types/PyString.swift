import Core

// In CPython:
// Objects -> unicodeobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// TODO: PyUnicode
// PyObject_GenericGetAttr,        /* tp_getattro */
// unicode_iter,           /* tp_iter */
// unicode_methods,            /* tp_methods */
// &PyBaseObject_Type,         /* tp_base */

internal class PyString: PyObject {

  internal var value: String

  internal init(_ context: PyContext, value: String) {
    self.value = value
    super.init(type: context.types.string)
  }
}

internal final class PyStringType: PyType /* ,
  ReprTypeClass, StrTypeClass,
  HashableTypeClass, ComparableTypeClass,
  RemainderTypeClass,
  LengthTypeClass,
  ConcatTypeClass, RepeatTypeClass, ItemTypeClass, ContainsTypeClass,
  SubscriptTypeClass */ {

//  override internal var name: String { return "str" }
//  override internal var doc: String? { return """
//    str(object='') -> str
//    str(bytes_or_buffer[, encoding[, errors]]) -> str
//
//    Create a new string object from the given object. If encoding or
//    errors is specified, then the object must expose a data buffer
//    that will be decoded using the given encoding and error handler.
//    Otherwise, returns the result of object.__str__() (if defined)
//    or repr(object).
//    encoding defaults to sys.getdefaultencoding().
//    errors defaults to 'strict'.
//    """
//  }

  // MARK: - String
/*
  internal func repr(value: PyObject) throws -> String {
    let rawString = try self.extract(value)

    // Compute length of output, quote characters and maximum character
    var singleQuoteCount = 0
    var doubleQuoteCount = 0
    for c in rawString {
      switch c {
      case "'":  singleQuoteCount += 1
      case "\"": doubleQuoteCount += 1
      default:   break
      }
    }

    // Use single quote if equal
    let quote: Character = doubleQuoteCount > singleQuoteCount ? "\"" : "'"

    var result = String(quote)
    result.reserveCapacity(rawString.count)

    for c in rawString {
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

  internal func str(value: PyObject) throws -> String {
    return try self.extract(value)
  }

  // MARK: - Equatable, hashable

  internal func hash(value: PyObject) throws -> PyHash {
    let v = try self.extract(value)
    return self.context.hasher.hash(v)
  }

  internal func compare(left: PyObject,
                        right: PyObject,
                        mode: CompareMode) throws -> Bool {
    guard let l = self.extractOrNil(left),
          let r = self.extractOrNil(right) else {
      throw ComparableNotImplemented(left: left, right: right)
    }

    if left === right {
      switch mode {
      case .equal, .lessEqual, .greaterEqual: return true
      case .notEqual, .less, .greater: return false
      }
    }

    switch mode {
    case .equal:
      return self.isEqual(left: l, right: r)
    case .notEqual:
      return !self.isEqual(left: l, right: r)
    case .less:
      let result = self.compare(left: l, right: r)
      return result == .less
    case .lessEqual:
      let result = self.compare(left: l, right: r)
      return result == .less || result == .equal
    case .greater:
      let result = self.compare(left: l, right: r)
      return result == .greater
    case .greaterEqual:
      let result = self.compare(left: l, right: r)
      return result == .greater || result == .equal
    }
  }

  private func isEqual(left: String, right: String) -> Bool {
    // "Cafe\u0301" == "Café" -> False
    let lScalars = left.unicodeScalars
    let rScalars = right.unicodeScalars

    return lScalars.count == rScalars.count
        && zip(lScalars, rScalars).allSatisfy { $0 == $1 }
  }

  private enum CompareResult {
    case less
    case greater
    case equal
  }

  private func compare(left: String, right: String) -> CompareResult {
    // "Cafe\u0301" < "Café" -> True
    let lScalars = left.unicodeScalars
    let rScalars = right.unicodeScalars

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
           lCount  > rCount ? .greater :
           .equal
  }

  // MARK: - Methods

  internal func length(value: PyObject) throws -> PyInt {
    let v = try self.extract(value)
    let count = v.unicodeScalars.count
    return self.types.int.new(count)
  }

  internal func remainder(left: PyObject, right: PyObject) throws -> PyObject {
    // unicode_mod
    fatalError()
  }

  internal func concat(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.extract(left)
    guard let r = self.extractOrNil(right) else {
//      PyErr_Format(PyExc_TypeError,
//                   "can only concatenate str (not \"%.200s\") to str",
//                   right->ob_type->tp_name);
      fatalError()
    }

    if l.isEmpty {
      return self.new(r)
    }

    if r.isEmpty {
      return self.new(l)
    }

    return self.new(l + r)
  }

  internal func `repeat`(value: PyObject, count: PyInt) throws -> PyObject {
    let v = try self.extract(value)

    let countRaw = try self.types.int.extractInt(count)
    let count = max(countRaw, 0)

    if v.isEmpty || count == 1 {
      return self.new(v)
    }

    var i: BigInt = 0
    var result = ""
    while i < count {
      result.append(v)
      i += 1
    }

    return self.new(result)
  }

  // MARK: - Items

  internal func item(owner: PyObject, at index: Int) throws -> PyObject {
    let o = try self.extract(owner)
    let scalars = o.unicodeScalars

    let iter = scalars.index(scalars.startIndex, offsetBy: index)
    return self.new(scalars[iter])
  }

  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    let o = try self.extract(owner)
    let e = try self.extract(element)
    return o.contains(e)
  }

  // MARK: - Subscript

  internal func `subscript`(owner: PyObject, index: PyObject) throws -> PyObject {
    let bigInt = try self.types.int.extractInt(index)
    guard let int = Int(exactly: bigInt) else {
      fatalError()
    }
    return try self.item(owner: owner, at: int)
  }

  // MARK: - Helpers

  internal func extractOrNil(_ object: PyObject) -> String? {
    let str = object as? PyString
    return str.map { $0.value }
  }

  internal func extract(_ object: PyObject) throws -> String {
    if let str = object as? PyString {
      return str.value
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }

  private func matchTypeOrNil(_ object: PyObject) -> PyString? {
    if let str = object as? PyString {
      return str
    }

    return nil
  }

  private func matchType(_ object: PyObject) throws -> PyString {
    if let str = object as? PyString {
      return str
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
*/
}
