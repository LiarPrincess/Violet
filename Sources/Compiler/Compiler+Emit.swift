import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable cyclomatic_complexity

extension Compiler {

  /// compiler_addop(struct compiler *c, int opcode)
  internal func emit(_ instruction: Instruction) throws {
    // TODO: fill
//    let location = compile_location(&self.current_source_location);
//    let cur_code_obj = self.current_code_object();
//    cur_code_obj.instructions.push(instruction);
//    cur_code_obj.locations.push(location);
  }

  /// compiler_addop_o(struct compiler *c, int opcode, PyObject *dict, PyObject *o)
  /// compiler_addop_i(struct compiler *c, int opcode, Py_ssize_t oparg)
  internal func emitConstant(_ c: Constant) throws {
    try self.emit(.loadConst(c))
  }

  /// unaryop(unaryop_ty op)
  internal func emitUnaryOperator(_ op: UnaryOperator) throws {
    switch op {
    case .invert: try self.emit(.unaryInvert)
    case .not: try self.emit(.unaryNot)
    case .plus: try self.emit(.unaryPositive)
    case .minus: try self.emit(.unaryNegative)
    }
  }

  /// binop(struct compiler *c, operator_ty op)
  internal func emitBinaryOperator(_ op: BinaryOperator) throws {
    switch op {
    case .add: try self.emit(.binaryAdd)
    case .sub: try self.emit(.binarySubtract)
    case .mul: try self.emit(.binaryMultiply)
    case .matMul: try self.emit(.binaryMatrixMultiply)
    case .div: try self.emit(.binaryTrueDivide)
    case .modulo: try self.emit(.binaryModulo)
    case .pow: try self.emit(.binaryPower)
    case .leftShift: try self.emit(.binaryLShift)
    case .rightShift: try self.emit(.binaryRShift)
    case .bitOr: try self.emit(.binaryOr)
    case .bitXor: try self.emit(.binaryXor)
    case .bitAnd: try self.emit(.binaryAnd)
    case .floorDiv: try self.emit(.binaryFloorDivide)
    }
  }
}
