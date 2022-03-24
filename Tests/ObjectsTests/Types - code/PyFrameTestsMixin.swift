import XCTest
import Foundation
import VioletBytecode
import VioletObjects

protocol PyFrameTestsMixin: PyTestCase { }

extension PyFrameTestsMixin {

  func createFrame(_ py: Py) -> PyFrame {
    let code = self.createCode(py)
    let locals = py.newDict()
    let globals = py.newDict()
    return py.newFrame(code: code, locals: locals, globals: globals, parent: nil)
  }

  func createCode(_ py: Py) -> PyCode {
    let builer = CodeObjectBuilder(
      name: "NAME",
      qualifiedName: "QUALIFIED_NAME",
      filename: "FILENAME",
      kind: .function,
      flags: [],
      variableNames: [],
      freeVariableNames: [],
      cellVariableNames: [],
      argCount: 0,
      kwOnlyArgCount: 0,
      firstLine: 0
    )

    let codeObject = builer.finalize()
    return py.newCode(code: codeObject)
  }
}
