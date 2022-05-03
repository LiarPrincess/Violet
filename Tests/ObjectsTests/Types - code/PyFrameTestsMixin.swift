import XCTest
import Foundation
import VioletBytecode
import VioletObjects

protocol PyFrameTestsMixin: PyTestCase {}

extension PyFrameTestsMixin {

  func createFrame(_ py: Py,
                   file: StaticString = #file,
                   line: UInt = #line) -> PyFrame? {
    let code = self.createCode(py)
    let locals = py.newDict()
    let globals = py.newDict()

    switch py.newFrame(parent: nil,
                       code: code,
                       args: [],
                       kwargs: nil,
                       defaults: [],
                       kwDefaults: nil,
                       locals: locals,
                       globals: globals,
                       closure: nil) {
    case let .value(frame):
      return frame
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail(reason, file: file, line: line)
      return nil
    }
  }

  func createCode(_ py: Py) -> PyCode {
    let builder = CodeObjectBuilder(
      name: "NAME",
      qualifiedName: "QUALIFIED_NAME",
      filename: "FILENAME",
      kind: .function,
      flags: [],
      variableNames: [],
      freeVariableNames: [],
      cellVariableNames: [],
      argCount: 0,
      posOnlyArgCount: 0,
      kwOnlyArgCount: 0,
      firstLine: 0
    )

    let codeObject = builder.finalize()
    return py.newCode(code: codeObject)
  }
}
