import VioletCore
@testable import VioletBytecode

func createBuilder(
  name: String = "name",
  qualifiedName: String = "qualifiedName",
  filename: String = "filename",
  kind: CodeObject.Kind = .module,
  flags: CodeObject.Flags = CodeObject.Flags(),
  variableNames: [MangledName] = [],
  freeVariableNames: [MangledName] = [],
  cellVariableNames: [MangledName] = [],
  argCount: Int = 0,
  posOnlyArgCount: Int = 0,
  kwOnlyArgCount: Int = 0,
  firstLine: SourceLine = SourceLocation.start.line
) -> CodeObjectBuilder {
  return CodeObjectBuilder(name: name,
                           qualifiedName: qualifiedName,
                           filename: filename,
                           kind: kind,
                           flags: flags,
                           variableNames: variableNames,
                           freeVariableNames: freeVariableNames,
                           cellVariableNames: cellVariableNames,
                           argCount: argCount,
                           posOnlyArgCount: posOnlyArgCount,
                           kwOnlyArgCount: kwOnlyArgCount,
                           firstLine: firstLine)
}
