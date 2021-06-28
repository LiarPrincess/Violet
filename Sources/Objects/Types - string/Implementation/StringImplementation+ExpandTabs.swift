import Foundation

extension StringImplementation {

  internal static func expandTabs(scalars: UnicodeScalars,
                                  tabSize: PyObject?) -> PyResult<String> {
    return Self.expandTabs(collection: scalars,
                           tabSize: tabSize,
                           fill: Self.scalarsDefaultFill,
                           using: StringBuilder.self)
  }

  internal static func expandTabs(data: Data,
                                  tabSize: PyObject?) -> PyResult<Data> {
    return Self.expandTabs(collection: data,
                           tabSize: tabSize,
                           fill: Self.dataDefaultFill,
                           using: BytesBuilder.self)
  }

  private static func expandTabs<C: Collection, B: StringBuilderType>(
    collection: C,
    tabSize tabSizeObject: PyObject?,
    fill: C.Element,
    using: B.Type
  ) -> PyResult<B.Result> where C.Element == B.Element, C.Element: UnicodeScalarConvertible {
    switch Self.parseTabSize(tabSize: tabSizeObject) {
    case let .value(tabSize):
      let result = Self.expandTabs(collection: collection,
                                   tabSize: tabSize,
                                   fill: fill,
                                   using: B.self)

      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  private static func expandTabs<C: Collection, B: StringBuilderType>(
    collection: C,
    tabSize: Int,
    fill: C.Element,
    using: B.Type
  ) -> B.Result where C.Element == B.Element, C.Element: UnicodeScalarConvertible {
    var builder = B()
    var linePos = 0

    for element in collection {
      let scalar = element.asUnicodeScalar
      switch scalar {
      case "\t":
        if tabSize > 0 {
          let incr = tabSize - (linePos % tabSize)
          linePos += incr
          builder.append(element: fill, repeated: incr)
        }

      default:
        linePos += 1
        builder.append(element)

        if scalar == "\n" || scalar == "\r" {
          linePos = 0
        }
      }
    }

    return builder.result
  }

  private static func parseTabSize(tabSize: PyObject?) -> PyResult<Int> {
    guard let tabSize = tabSize else {
      return .value(8)
    }

    guard let pyInt = PyCast.asInt(tabSize) else {
      return .typeError("tabsize must be int, not \(tabSize.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("tabsize is too big")
    }

    return .value(int)
  }
}
