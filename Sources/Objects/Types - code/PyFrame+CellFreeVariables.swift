import VioletCore

extension PyFrame {

  public typealias Cell = PyCell

  // MARK: - Cells

  public struct CellVariablesProxy {

    private let ptr: BufferPtr<Cell>

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      let storage = frame.fastLocalsCellFreeBlockStackStorage
      self.ptr = storage.cellVariables
    }

    internal func initialize(_ py: Py) {
      self.ptr.initialize { _ in py.newCell(content: nil) }
    }

    public func fill(code: PyCode, fastLocals: FastLocalsProxy) {
      for (index, name) in code.cellVariableNames.enumerated() {
        // Possibly account for the cell variable being an argument.
        if let arg = code.variableNames.firstIndex(of: name) {
          let local = fastLocals[arg]
          self[index].content = local
          fastLocals[arg] = nil
        }
      }
    }

    public subscript(index: Int) -> Cell {
      return self.ptr[index]
    }
  }

  // MARK: - Free

  public struct FreeVariablesProxy {

    private let ptr: BufferPtr<Cell>

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      let storage = frame.fastLocalsCellFreeBlockStackStorage
      self.ptr = storage.freeVariables
    }

    internal func initialize(_ py: Py) {
      // Everything will be taken from 'closure' in 'self.fill'
    }

    public func fill(_ py: Py, code: PyCode, closure: PyTuple?) {
      let closure = closure?.elements ?? []
      assert(closure.count == code.freeVariableCount)

      for (index, object) in closure.enumerated() {
        guard let cell = py.cast.asCell(object) else {
          trap("Closure can only contain cells, not '\(object.typeName)'.")
        }

        self.ptr[index] = cell
      }
    }

    public subscript(index: Int) -> Cell {
      return self.ptr[index]
    }
  }
}
