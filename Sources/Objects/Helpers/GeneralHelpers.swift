import Core
// TODO: Remove everything from here

// swiftlint:disable unavailable_function
// swiftlint:disable fatal_error_message

internal struct AdjustedIndices {
  internal var start:  Int
  internal var stop:   Int
  internal var step:   Int
  internal let length: Int
}

internal enum GeneralHelpers {

  /// PySlice_AdjustIndices
  internal static func adjustIndices(value: PySlice,
                                     to length: Int) -> AdjustedIndices {
    //    var start = value.start ?? 0
    //    var stop = value.stop ?? Int.max
    //    let step = value.step ?? 1
    //    let goingDown = step < 0
    //
    //    if start < 0 {
    //      start += length
    //      if start < 0 {
    //        start = goingDown ? -1 : 0
    //      }
    //    } else if start >= length {
    //      start = goingDown ? length - 1 : length
    //    }
    //
    //    if stop < 0 {
    //      stop += length
    //      if stop < 0 {
    //        stop = goingDown ? -1 : 0
    //      }
    //    } else if stop >= length {
    //      stop = goingDown ? length - 1 : length
    //    }
    //
    //    var length = length
    //    if goingDown {
    //      if stop < start {
    //        length = (start - stop - 1) / (-step) + 1
    //      }
    //    } else {
    //      if start < stop {
    //        length = (stop - start - 1) / step + 1
    //      }
    //    }
    //
    //    return AdjustedIndices(start: start, stop: stop, step: step, length: length)
    fatalError()
  }

  internal static func pyInt(_ value: BigInt) -> PyInt {
//    return self.types.int.new(value)
    fatalError()
  }

  internal static func pyInt(_ value: Int) -> PyInt {
//    return self.types.int.new(value)
    fatalError()
  }

  internal static func pyBool(_ value: Bool) -> PyBool {
    //    return PyTuple.new(self.context, elements)
    fatalError()
  }

  internal static func pyFloat(_ value: Double) -> PyFloat {
    //    return self.types.int.new(value)
    fatalError()
  }

  internal static func pyComplex(real: Double, imag: Double) -> PyComplex {
    fatalError()
  }

  internal static func pyTuple(_ elements: [PyObject]) -> PyTuple {
//    return PyTuple.new(self.context, elements)
    fatalError()
  }

  internal static func extractInt(_ object: PyObject) -> PyInt? {
//    return object as? PyInt
    fatalError()
  }

  internal static var none: PyNone {
    fatalError()
  }

  /// PyLong_FromSsize_t
  internal static func extractIndex(value: PyObject) -> BigInt? {
    // This should return precise error

    //    guard let indexType = value.type as? IndexTypeClass else {
    //      return nil
    //    }

    //    let index = try indexType.index(value: value)
    //    let bigInt = try self.context.types.int.extractInt(index)
    //    guard let result = Int(exactly: bigInt) else {
    //      // i = PyNumber_AsSsize_t(item, PyExc_IndexError);
    //      fatalError()
    //    }

    //    return result
    //    return nil
    fatalError()
  }

  internal static var nan: PyFloat {
    fatalError()
  }

  internal static var `true`: PyBool {
    //PyBool(type: self, value: BigInt(1))
    fatalError()
  }

  internal static var `false`: PyBool {
    //PyBool(type: self, value: BigInt(0))
    fatalError()
  }

  internal static var emptyTuple: PyTuple {
    // Make it let inside class
    fatalError()
  }
}
