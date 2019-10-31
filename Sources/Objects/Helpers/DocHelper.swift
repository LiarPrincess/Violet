internal enum DocHelper {

  /// static const char *
  /// _PyType_DocWithoutSignature(const char *name, const char *internal_doc)
  internal static func getDocWithoutSignature(_ doc: String) -> String {
    switch getSignarureEnd(doc) {
    case let .some(index):
      return String(doc.suffix(from: index))
    case .none:
      return doc
    }
  }

  /// PyObject *
  /// _PyType_GetTextSignatureFromInternalDoc(const char *name, const char *internal_doc)
  internal static func getSignature(_ doc: String) -> String {
    fatalError()
  }

  private static func getSignarureEnd(_ doc: String) -> String.Index? {
    let signatureEndMarker = ")\n--\n\n"
    return doc.range(of: signatureEndMarker)?.upperBound
  }
}
