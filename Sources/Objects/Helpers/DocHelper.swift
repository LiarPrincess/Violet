private let signatureMarker = ")\n--\n\n"

internal enum DocHelper {

  /// PyObject *
  /// _PyType_GetTextSignatureFromInternalDoc(const char *name, const char *internal_doc)
  internal static func getSignature(_ doc: String) -> String? {
    guard let markerRange = DocHelper.getMarkerRange(doc) else {
      return nil
    }

    // Signature end is ')'.
    let end = markerRange.lowerBound

    // Go from start until first '('.
    var start = doc.startIndex
    while true {
      if doc[start] == "(" {
        return String(doc[start...end])
      }

      // Did we reach the ')' before '('?
      if start == end {
        return nil
      }

      doc.formIndex(after: &start)
    }
  }

  /// static const char *
  /// _PyType_DocWithoutSignature(const char *name, const char *internal_doc)
  internal static func getDocWithoutSignature(_ doc: String) -> String {
    switch DocHelper.getMarkerRange(doc) {
    case .some(let markerRange):
      let markerEnd = markerRange.upperBound
      return String(doc.suffix(from: markerEnd))
    case .none:
      return doc
    }
  }

  private static func getMarkerRange(_ doc: String) -> Range<String.Index>? {
    return doc.range(of: signatureMarker)
  }
}
